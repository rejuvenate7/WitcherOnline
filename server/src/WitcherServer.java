import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.CodeSource;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

public class WitcherServer
{
    private static final Map<String, PlayerSession> players = new ConcurrentHashMap<>();
    private static final Set<ClientEndpoint> clients = ConcurrentHashMap.newKeySet();
    private static final Set<String> bannedIps = ConcurrentHashMap.newKeySet();
    private static final Set<String> whitelistedIps = ConcurrentHashMap.newKeySet();

    private static final AtomicBoolean running = new AtomicBoolean(true);
    private static final AtomicBoolean whitelistEnabled = new AtomicBoolean(false);

    private static final Map<String, UsernameReservation> reservedUsernames = new ConcurrentHashMap<>();

    private static final long PLAYER_TIMEOUT_MS = 5000;
    private static final long USERNAME_HOLD_MS = 60_000;
    private static final int DEFAULT_PORT = 40000;
    private static final DateTimeFormatter LOG_TIME = DateTimeFormatter.ofPattern("HH:mm:ss");

    public static void main(String[] args) throws Exception
    {
        Properties serverProperties = loadServerProperties();
        int port = choosePort(args, serverProperties);
        whitelistEnabled.set(readBoolean(serverProperties, "whitelist", false));

        loadBannedIps();
        loadWhitelistIps();

        DatagramSocket socket = new DatagramSocket(port);

        dbgNotime("Launching Witcher Online for The Witcher 3: Wild Hunt...\n");
        dbgNotime("Author: rejuvenate7 - Github: https://github.com/rejuvenate7\n");
        dbg("Starting Witcher Online server on *:%d\n", port);
        dbg("For help, type \"help\" or \"?\"\n");

        Thread recvThread = new Thread(() -> receiveLoop(socket), "udp-recv");
        Thread sendThread = new Thread(() -> broadcastLoop(socket), "udp-broadcast");
        Thread cleanupThread = new Thread(() -> cleanupLoop(socket), "udp-cleanup");
        Thread consoleThread = new Thread(() -> consoleLoop(socket), "console");

        recvThread.start();
        sendThread.start();
        cleanupThread.start();
        consoleThread.start();

        recvThread.join();
        sendThread.join();
        cleanupThread.join();
        consoleThread.join();
    }

    private static void receiveLoop(DatagramSocket socket)
    {
        byte[] buffer = new byte[8192];

        while (running.get())
        {
            try
            {
                DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
                socket.receive(packet);

                ClientEndpoint sender = new ClientEndpoint(packet.getAddress(), packet.getPort());
                String senderIp = normalizeIp(sender.address.getHostAddress());

                String msg = new String(
                        packet.getData(),
                        packet.getOffset(),
                        packet.getLength(),
                        StandardCharsets.UTF_8
                );

                dbg("Received packet len=%d from %s:%d val:%s\n", packet.getLength(), packet.getAddress().getHostAddress(), packet.getPort(), msg);

                if (isIpBanned(senderIp))
                {
                    //dbg("Rejected packet from banned IP %s:%d\n", senderIp, sender.port);
                    safeSend(socket, sender, "ERROR\tBANNED");
                    continue;
                }

                if (whitelistEnabled.get() && !isIpWhitelisted(senderIp))
                {
                    //dbg("Rejected packet from non-whitelisted IP %s:%d\n", senderIp, sender.port);
                    safeSend(socket, sender, "ERROR\tNOT_WHITELISTED");
                    continue;
                }

                handleMessage(socket, sender, msg);

            }
            catch (SocketException e)
            {
                if (running.get())
                {
                    e.printStackTrace();
                }
                break;
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }
    }

    private static boolean isUpdateOpcode(String opcode)
    {
        return "UPDATE1A".equals(opcode)
                || "UPDATE1B".equals(opcode)
                || "UPDATE2A".equals(opcode)
                || "UPDATE2B".equals(opcode);
    }

    private static void handleMessage(DatagramSocket socket, ClientEndpoint sender, String msg) throws Exception
    {
        String[] parts = msg.split("\t", -1);

        if (parts.length < 2)
        {
            return;
        }

        String opcode = parts[0];

        if (!isUpdateOpcode(opcode))
        {
            return;
        }

        String username = parts[1].trim();
        if (username.isEmpty())
        {
            safeSend(socket, sender, "ERROR\tINVALID_USERNAME");
            return;
        }

        String usernameKey = normalizeUsernameKey(username);
        String senderIp = normalizeIp(sender.address.getHostAddress());
        long now = System.currentTimeMillis();

        PlayerSession current = players.get(usernameKey);

        if (current != null)
        {
            String currentIp = normalizeIp(current.endpoint.address.getHostAddress());

            boolean sameEndpoint = current.endpoint.equals(sender);
            boolean sameIp = currentIp.equals(senderIp);
            boolean expired = (now - current.lastSeen) > PLAYER_TIMEOUT_MS;

            if (sameEndpoint)
            {
                // normal packet from same endpoint
            }
            else if (sameIp)
            {
                ClientEndpoint old = current.endpoint;
                current.endpoint = sender;
                dbg("Updated endpoint for %s from %s to %s\n", username, old, sender);
            }
            else if (expired)
            {
                boolean reserved = reserveTimedOutPlayer(socket, usernameKey, current, now);
                if (reserved)
                {
                    dbg("Rejected %s from %s because username is reserved for previous IP\n", username, sender);
                    safeSend(socket, sender, "ERROR\tUSERNAME_TAKEN");
                    return;
                }

                current = players.get(usernameKey);
                if (current != null)
                {
                    dbg("Rejected duplicate username %s from %s because owned by %s\n",
                            username, sender, current.endpoint);
                    safeSend(socket, sender, "ERROR\tUSERNAME_TAKEN");
                    return;
                }
            }
            else
            {
                dbg("Rejected duplicate username %s from %s because owned by %s\n",
                        username, sender, current.endpoint);
                safeSend(socket, sender, "ERROR\tUSERNAME_TAKEN");
                return;
            }
        }

        // No active player owns the name. Check whether the username is reserved.
        if (!players.containsKey(usernameKey))
        {
            UsernameReservation reservation = reservedUsernames.get(usernameKey);

            if (reservation != null)
            {
                if (now >= reservation.expiresAt)
                {
                    reservedUsernames.remove(usernameKey, reservation);
                    reservation = null;
                }
            }

            if (reservation != null)
            {
                if (!reservation.ip.equals(senderIp))
                {
                    dbg("Rejected username %s from %s because it is reserved for IP %s\n",
                            username, sender, reservation.ip);
                    safeSend(socket, sender, "ERROR\tUSERNAME_TAKEN");
                    return;
                }

                reservedUsernames.remove(usernameKey, reservation);
                dbg("Restored reserved username %s for %s\n", username, sender);
            }

            PlayerSession created = new PlayerSession(username, sender, now);
            PlayerSession race = players.putIfAbsent(usernameKey, created);

            if (race == null)
            {
                current = created;
                dbg("Accepted username %s for %s\n", username, sender);
            }
            else
            {
                current = race;

                String currentIp = normalizeIp(current.endpoint.address.getHostAddress());
                if (!currentIp.equals(senderIp) && !current.endpoint.equals(sender))
                {
                    dbg("Rejected duplicate username %s from %s because owned by %s\n",
                            username, sender, current.endpoint);
                    safeSend(socket, sender, "ERROR\tUSERNAME_TAKEN");
                    return;
                }

                current.endpoint = sender;
            }
        }

        current.lastSeen = now;

        List<String> fields = new ArrayList<>();
        for (int i = 2; i < parts.length; i++)
        {
            fields.add(unescapeField(parts[i]));
        }

        List<String> frozenFields = Collections.unmodifiableList(fields);

        if ("UPDATE1A".equals(opcode))
        {
            current.update1AFields = frozenFields;
        }
        else if ("UPDATE1B".equals(opcode))
        {
            current.update1BFields = frozenFields;
        }
        else if ("UPDATE2A".equals(opcode))
        {
            current.update2AFields = frozenFields;
        }
        else if ("UPDATE2B".equals(opcode))
        {
            current.update2BFields = frozenFields;
        }

        clients.add(sender);
    }

    private static void cleanupLoop(DatagramSocket socket)
    {
        while (running.get())
        {
            try
            {
                long now = System.currentTimeMillis();

                for (Map.Entry<String, PlayerSession> entry : players.entrySet())
                {
                    PlayerSession session = entry.getValue();
                    if ((now - session.lastSeen) > PLAYER_TIMEOUT_MS)
                    {
                        reserveTimedOutPlayer(socket, entry.getKey(), session, now);
                    }
                }

                for (Map.Entry<String, UsernameReservation> entry : reservedUsernames.entrySet())
                {
                    UsernameReservation reservation = entry.getValue();
                    if (now >= reservation.expiresAt)
                    {
                        if (reservedUsernames.remove(entry.getKey(), reservation))
                        {
                            dbg("Released reserved username %s for IP %s\n",
                                    reservation.username,
                                    reservation.ip);
                        }
                    }
                }

                cleanupClients();
                Thread.sleep(1000);
            }
            catch (InterruptedException e)
            {
                Thread.currentThread().interrupt();
                break;
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }
    }

    private static void broadcastLoop(DatagramSocket socket)
    {
        while (running.get())
        {
            try
            {
                for (PlayerSession session : players.values())
                {
                    broadcastChunk(socket, session, "UPDATE1A", session.update1AFields);
                    broadcastChunk(socket, session, "UPDATE1B", session.update1BFields);
                    broadcastChunk(socket, session, "UPDATE2A", session.update2AFields);
                    broadcastChunk(socket, session, "UPDATE2B", session.update2BFields);
                }

                Thread.sleep(100);

            }
            catch (InterruptedException e)
            {
                Thread.currentThread().interrupt();
                break;
            }
            catch (SocketException e)
            {
                if (running.get())
                {
                    e.printStackTrace();
                }
                break;
            }
            catch (Exception e)
            {
                e.printStackTrace();
            }
        }
    }

    private static void broadcastChunk(DatagramSocket socket, PlayerSession session, String opcode, List<String> fields) throws Exception
    {
        if (fields == null || fields.isEmpty())
        {
            return;
        }

        String packetText = buildTypedPacket(opcode, session.username, fields);
        byte[] data = packetText.getBytes(StandardCharsets.UTF_8);

        for (ClientEndpoint client : clients)
        {
            DatagramPacket packet = new DatagramPacket(
                    data,
                    data.length,
                    client.address,
                    client.port
            );
            socket.send(packet);
        }
    }

    private static String buildTypedPacket(String opcode, String playerId, List<String> fields)
    {
        StringBuilder sb = new StringBuilder();
        sb.append(opcode).append("\t").append(escapeField(playerId));

        for (String field : fields)
        {
            sb.append("\t").append(escapeField(field));
        }

        return sb.toString();
    }

    private static void consoleLoop(DatagramSocket socket)
    {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(System.in, StandardCharsets.UTF_8)))
        {
            String line;
            while (running.get() && (line = reader.readLine()) != null)
            {
                handleConsoleCommand(socket, line.trim());
            }
        }
        catch (IOException e)
        {
            if (running.get())
            {
                e.printStackTrace();
            }
        }
    }

    private static void handleConsoleCommand(DatagramSocket socket, String line)
    {
        if (line.isEmpty())
        {
            return;
        }

        if (line.equals("list")) {
            dbg("---- Connected players (%d) ----\n", players.size());
            long now = System.currentTimeMillis();

            for (PlayerSession session : players.values()) {
                long secsSinceSeen = Math.max(0L, (now - session.lastSeen) / 1000L);

                String locationRaw = getLocation(session.update1AFields);
                String region = getRegion(locationRaw);

                List<String> coords = getCoords(session.update1AFields);
                String coordsStr = "?";
                if (coords.size() == 3) {
                    coordsStr = "(" + coords.get(0) + ", " + coords.get(1) + ", " + coords.get(2) + ")";
                }

                dbg("name=\"%s\"  ip=%s  location=%s  coords=%s  lastSeen=%ds ago\n",
                        session.username,
                        session.endpoint,
                        locationRaw.isEmpty() ? "?" : region,
                        coordsStr,
                        secsSinceSeen);
            }

            dbgNotime("\n");
            return;
        }

        if (line.startsWith("kick"))
        {
            String arg = trimCommandArg(line, "kick");
            if (arg.isEmpty())
            {
                dbg("Usage: kick <name|ip>\n\n");
                return;
            }

            PlayerSession victim = findPlayer(arg);
            if (victim == null)
            {
                dbg("No connected player matches \"%s\".\n\n", arg);
                return;
            }

            dbg("Kicking %s (%s)\n", victim.username, victim.endpoint);
            kickPlayer(socket, victim, "KICK\tKicked by server");
            dbgNotime("\n");
            return;
        }

        if (line.startsWith("ban"))
        {
            String arg = trimCommandArg(line, "ban");
            if (arg.isEmpty())
            {
                dbg("Usage: ban <name|ip>\n\n");
                return;
            }

            PlayerSession victim = findPlayer(arg);
            String ipToBan = (victim != null)
                    ? normalizeIp(victim.endpoint.address.getHostAddress())
                    : normalizeIp(stripPort(arg));

            if (ipToBan.isEmpty())
            {
                dbg("Could not resolve \"%s\" to an IP address to ban.\n\n", arg);
                return;
            }

            boolean newlyBanned = bannedIps.add(ipToBan);
            if (newlyBanned)
            {
                saveBannedIps();
                dbg("Added IP '%s' to ban list.\n", ipToBan);
            }
            else
            {
                dbg("IP '%s' is already in ban list.\n", ipToBan);
            }

            if (victim != null)
            {
                kickAllPlayersByIp(socket, ipToBan, "KICK\tBanned by server");
            }

            dbgNotime("\n");
            return;
        }

        if (line.startsWith("unban"))
        {
            String arg = trimCommandArg(line, "unban");
            if (arg.isEmpty())
            {
                dbg("Usage: unban <ip>\n\n");
                return;
            }

            String ip = normalizeIp(stripPort(arg));
            if (ip.isEmpty())
            {
                dbg("Usage: unban <ip>\n\n");
                return;
            }

            if (bannedIps.remove(ip))
            {
                saveBannedIps();
                dbg("'%s' has been unbanned.\n\n", ip);
            }
            else
            {
                dbg("IP '%s' is not banned.\n\n", ip);
            }
            return;
        }

        if (line.startsWith("whitelist"))
        {
            String arg = trimCommandArg(line, "whitelist");
            if (arg.isEmpty())
            {
                dbg("Usage: whitelist on|off - enable or disable the whitelist\n");
                dbg("Usage: whitelist <ip>|remove <ip> - add or remove IP to whitelist\n\n");
                return;
            }

            String lower = arg.toLowerCase(Locale.ROOT);
            if (lower.equals("on"))
            {
                whitelistEnabled.set(true);
                dbg("The whitelist is now enabled.\n\n");
                return;
            }

            if (lower.equals("off"))
            {
                whitelistEnabled.set(false);
                dbg("The whitelist is now disabled.\n\n");
                return;
            }

            if (lower.startsWith("remove"))
            {
                String ip = normalizeIp(stripPort(trimCommandArg(arg, "remove")));
                if (ip.isEmpty())
                {
                    dbg("Usage: whitelist remove <ip>\n\n");
                    return;
                }

                if (whitelistedIps.remove(ip))
                {
                    saveWhitelistIps();
                    dbg("Removed IP '%s' from whitelist.\n\n", ip);
                }
                else
                {
                    dbg("IP '%s' is not in the whitelist.\n\n", ip);
                }
                return;
            }

            String ip = normalizeIp(stripPort(arg));
            if (ip.isEmpty())
            {
                dbg("Usage: whitelist on|off - enable or disable the whitelist\n");
                dbg("Usage: whitelist <ip>|remove <ip> - add or remove IP to whitelist\n\n");
                return;
            }

            if (whitelistedIps.add(ip))
            {
                saveWhitelistIps();
                dbg("Added IP '%s' to whitelist.\n\n", ip);
            }
            else
            {
                dbg("IP '%s' is already in whitelist.\n\n", ip);
            }
            return;
        }

        if (line.equals("stop"))
        {
            dbg("Shutting down...\n\n");
            shutdown(socket);
            return;
        }

        if (line.equals("help") || line.equals("?"))
        {
            dbg("--------- Help: Index ---------\n");
            dbg("kick <name|ip>            - remove a player and send a kick notice\n");
            dbg("ban <name|ip>             - ban by name/ip and prevent future updates\n");
            dbg("unban <ip>                - remove IP from ban list\n");
            dbg("whitelist on|off|<ip>     - toggle whitelist or add IP to whitelist\n");
            dbg("whitelist remove <ip>     - remove IP from whitelist\n");
            dbg("list                      - list connected players\n");
            dbg("about                     - info about Witcher Online\n");
            dbg("stop                      - stop server\n");
            dbg("help                      - show this help\n\n");
            return;
        }

        if (line.equals("about"))
        {
            dbg("--------- About ---------\n");
            dbg("Witcher Online v2.0\n");
            dbg("by rejuvenate7\n");
            dbg("https://github.com/rejuvenate7\n");
            dbg("https://discord.gg/KYu9c5TWej\n\n");
            return;
        }

        dbg("Unknown command: %s (type 'help')\n\n", line);
    }

    private static void kickPlayer(DatagramSocket socket, PlayerSession victim, String kickText)
    {
        String usernameKey = normalizeUsernameKey(victim.username);

        PlayerSession removed = players.remove(usernameKey);
        reservedUsernames.remove(usernameKey);

        if (removed != null)
        {
            safeSend(socket, removed.endpoint, kickText);
        }

        cleanupClients();
    }

    private static void kickAllPlayersByIp(DatagramSocket socket, String ip, String kickText)
    {
        List<PlayerSession> victims = new ArrayList<>();
        for (PlayerSession session : players.values())
        {
            String sessionIp = normalizeIp(session.endpoint.address.getHostAddress());
            if (sessionIp.equals(ip))
            {
                victims.add(session);
            }
        }

        for (PlayerSession victim : victims)
        {
            dbg("Removing %s (%s) after ban\n", victim.username, victim.endpoint);
            kickPlayer(socket, victim, kickText);
        }
    }

    private static void cleanupClients()
    {
        Set<ClientEndpoint> activeEndpoints = new HashSet<>();
        for (PlayerSession session : players.values())
        {
            activeEndpoints.add(session.endpoint);
        }
        clients.removeIf(endpoint -> !activeEndpoints.contains(endpoint));
    }

    private static PlayerSession findPlayer(String arg)
    {
        PlayerSession exact = players.get(normalizeUsernameKey(arg));
        if (exact != null)
        {
            return exact;
        }

        String ipArg = normalizeIp(stripPort(arg));

        for (PlayerSession session : players.values())
        {
            String sessionIp = normalizeIp(session.endpoint.address.getHostAddress());
            if (!ipArg.isEmpty() && sessionIp.equals(ipArg))
            {
                return session;
            }
        }

        return null;
    }

    private static void shutdown(DatagramSocket socket)
    {
        if (!running.compareAndSet(true, false))
        {
            return;
        }
        socket.close();
    }

    private static void sendText(DatagramSocket socket, ClientEndpoint client, String text) throws Exception
    {
        byte[] data = text.getBytes(StandardCharsets.UTF_8);
        DatagramPacket packet = new DatagramPacket(data, data.length, client.address, client.port);
        socket.send(packet);
    }

    private static void safeSend(DatagramSocket socket, ClientEndpoint client, String text)
    {
        try
        {
            sendText(socket, client, text);
        }
        catch (Exception e)
        {
            if (running.get())
            {
                e.printStackTrace();
            }
        }
    }

    private static boolean isIpBanned(String ip)
    {
        return bannedIps.contains(normalizeIp(ip));
    }

    private static boolean isIpWhitelisted(String ip)
    {
        return whitelistedIps.contains(normalizeIp(ip));
    }

    private static void loadBannedIps()
    {
        Set<String> loaded = loadJsonStringArray(bannedPlayersPath());
        bannedIps.clear();
        bannedIps.addAll(loaded);
        if (!loaded.isEmpty())
        {
            dbg("Loaded %d banned IP(s) from %s\n", loaded.size(), bannedPlayersPath());
        }
    }

    private static void saveBannedIps()
    {
        saveJsonStringArray(bannedPlayersPath(), bannedIps, "banned IP list");
    }

    private static void loadWhitelistIps()
    {
        Set<String> loaded = loadJsonStringArray(whitelistedPlayersPath());
        whitelistedIps.clear();
        whitelistedIps.addAll(loaded);
        if (!loaded.isEmpty())
        {
            dbg("Loaded %d whitelisted IP(s) from %s\n", loaded.size(), whitelistedPlayersPath());
        }
    }

    private static void saveWhitelistIps()
    {
        saveJsonStringArray(whitelistedPlayersPath(), whitelistedIps, "whitelist IP list");
    }

    private static Set<String> loadJsonStringArray(Path path)
    {
        Set<String> out = new HashSet<>();

        if (!Files.exists(path))
        {
            return out;
        }

        try
        {
            String content = Files.readString(path, StandardCharsets.UTF_8);
            StringBuilder cur = new StringBuilder();
            boolean inString = false;
            boolean escaping = false;

            for (int i = 0; i < content.length(); i++)
            {
                char c = content.charAt(i);

                if (!inString)
                {
                    if (c == '"')
                    {
                        inString = true;
                        cur.setLength(0);
                    }
                    continue;
                }

                if (escaping)
                {
                    cur.append(c);
                    escaping = false;
                    continue;
                }

                if (c == '\\')
                {
                    escaping = true;
                    continue;
                }

                if (c == '"')
                {
                    String value = normalizeIp(cur.toString());
                    if (!value.isEmpty())
                    {
                        out.add(value);
                    }
                    inString = false;
                    continue;
                }

                cur.append(c);
            }
        }
        catch (IOException e)
        {
            dbg("Failed to read %s: %s\n", path, e.getMessage());
        }

        return out;
    }

    private static void saveJsonStringArray(Path path, Set<String> values, String label)
    {
        try
        {
            Files.createDirectories(path.getParent());
            List<String> sorted = new ArrayList<>(values);
            Collections.sort(sorted);

            StringBuilder sb = new StringBuilder();
            sb.append("[\n");
            for (int i = 0; i < sorted.size(); i++)
            {
                if (i > 0)
                {
                    sb.append(",\n");
                }
                sb.append("  \"").append(jsonEscape(sorted.get(i))).append("\"");
            }
            sb.append("\n]\n");

            Files.writeString(path, sb.toString(), StandardCharsets.UTF_8);
        }
        catch (IOException e)
        {
            dbg("Failed to write %s to %s: %s\n", label, path, e.getMessage());
        }
    }

    private static Properties loadServerProperties()
    {
        Properties properties = new Properties();
        Path path = serverPropertiesPath();

        if (!Files.exists(path))
        {
            return properties;
        }

        try (var reader = Files.newBufferedReader(path, StandardCharsets.UTF_8))
        {
            properties.load(reader);
        }
        catch (IOException e)
        {
            dbg("Failed to read %s: %s\n", path, e.getMessage());
        }

        return properties;
    }

    private static int choosePort(String[] args, Properties properties)
    {
        if (args.length >= 1)
        {
            Integer cliPort = parsePort(args[0]);
            if (cliPort != null)
            {
                return cliPort;
            }
            System.err.println("Invalid CLI port: " + args[0] + " (falling back)");
        }

        String propertyPort = properties.getProperty("port");
        if (propertyPort != null)
        {
            Integer parsed = parsePort(propertyPort.trim());
            if (parsed != null)
            {
                return parsed;
            }
            System.err.println("Invalid server.properties port: " + propertyPort + " (falling back)");
        }

        return DEFAULT_PORT;
    }

    private static Integer parsePort(String text)
    {
        try
        {
            int port = Integer.parseInt(text);
            return (port >= 1 && port <= 65535) ? port : null;
        }
        catch (NumberFormatException e)
        {
            return null;
        }
    }

    private static boolean readBoolean(Properties properties, String key, boolean defaultValue)
    {
        String value = properties.getProperty(key);
        if (value == null)
        {
            return defaultValue;
        }

        String lower = value.trim().toLowerCase(Locale.ROOT);
        return lower.equals("true") || lower.equals("1") || lower.equals("yes") || lower.equals("on");
    }

    private static Path serverPropertiesPath()
    {
        return appDir().resolve("server.properties");
    }

    private static Path bannedPlayersPath()
    {
        return appDir().resolve("banned-players.json");
    }

    private static Path whitelistedPlayersPath()
    {
        return appDir().resolve("whitelisted-players.json");
    }

    private static Path appDir()
    {
        try
        {
            CodeSource codeSource = WitcherServer.class.getProtectionDomain().getCodeSource();
            if (codeSource != null && codeSource.getLocation() != null)
            {
                Path path = Paths.get(codeSource.getLocation().toURI()).toAbsolutePath().normalize();
                return Files.isRegularFile(path) ? path.getParent() : path;
            }
        }
        catch (Exception ignored)
        {
        }

        return Paths.get(".").toAbsolutePath().normalize();
    }

    private static String normalizeIp(String ip)
    {
        return stripPort(ip == null ? "" : ip.trim());
    }

    private static String stripPort(String value)
    {
        if (value == null)
        {
            return "";
        }

        String trimmed = value.trim();
        if (trimmed.isEmpty())
        {
            return "";
        }

        if (trimmed.startsWith("[") && trimmed.contains("]"))
        {
            int close = trimmed.indexOf(']');
            return trimmed.substring(1, close);
        }

        long colonCount = trimmed.chars().filter(ch -> ch == ':').count();
        if (colonCount == 1)
        {
            int idx = trimmed.indexOf(':');
            String left = trimmed.substring(0, idx);
            String right = trimmed.substring(idx + 1);
            if (!left.isEmpty() && right.chars().allMatch(Character::isDigit))
            {
                return left;
            }
        }

        return trimmed;
    }

    private static String trimCommandArg(String line, String command)
    {
        return line.length() <= command.length() ? "" : line.substring(command.length()).trim();
    }

    private static String escapeField(String s)
    {
        StringBuilder out = new StringBuilder();

        for (int i = 0; i < s.length(); i++)
        {
            char c = s.charAt(i);

            switch (c)
            {
                case '\\':
                    out.append("\\\\");
                    break;
                case '\t':
                    out.append("\\t");
                    break;
                case '\n':
                    out.append("\\n");
                    break;
                case '\r':
                    out.append("\\r");
                    break;
                default:
                    out.append(c);
                    break;
            }
        }

        return out.toString();
    }

    private static String unescapeField(String s)
    {
        StringBuilder out = new StringBuilder();

        for (int i = 0; i < s.length(); i++)
        {
            char c = s.charAt(i);

            if (c == '\\' && i + 1 < s.length())
            {
                char n = s.charAt(i + 1);

                if (n == 't')
                {
                    out.append('\t');
                    i++;
                }
                else if (n == 'n')
                {
                    out.append('\n');
                    i++;
                }
                else if (n == 'r')
                {
                    out.append('\r');
                    i++;
                }
                else if (n == '\\')
                {
                    out.append('\\');
                    i++;
                }
                else
                {
                    out.append(c);
                }
            }
            else
            {
                out.append(c);
            }
        }

        return out.toString();
    }

    private static String jsonEscape(String s)
    {
        StringBuilder out = new StringBuilder(s.length() + 8);
        for (int i = 0; i < s.length(); i++)
        {
            char c = s.charAt(i);
            if (c == '\\' || c == '"')
            {
                out.append('\\').append(c);
            }
            else if (c >= 0x20)
            {
                out.append(c);
            }
        }
        return out.toString();
    }

    private static void dbgNotime(String format, Object... args)
    {
        System.out.print(String.format(format, args));
        System.out.flush();
    }

    private static void dbg(String format, Object... args)
    {
        String prefix = "[" + LocalTime.now().format(LOG_TIME) + " INFO]: ";
        System.out.print(prefix + String.format(format, args));
        System.out.flush();
    }

    private static String trim(String s)
    {
        return s == null ? "" : s.trim();
    }

    private static String getRegion(String region)
    {
        region = trim(region);

        if (region.equals("1") || region.equals("9"))
        {
            return "Novigrad/Velen";
        }
        else if (region.equals("2"))
        {
            return "Skellige";
        }
        else if (region.equals("3"))
        {
            return "Kaer Morhen";
        }
        else if (region.equals("4") || region.equals("8"))
        {
            return "White Orchard";
        }
        else if (region.equals("5"))
        {
            return "Vizima";
        }
        else if (region.equals("6"))
        {
            return "Isle of Mists";
        }
        else if (region.equals("7"))
        {
            return "Spiral";
        }
        else if (region.equals("11"))
        {
            return "Toussaint";
        }
        else
        {
            return "Unknown";
        }
    }

    private static String getLocation(List<String> fields)
    {
        if (fields == null || fields.size() < 8)
        {
            return "";
        }

        String name = trim(fields.get(7));

        if (name.equals("NR_PlayerManager.Init") || name.equals("Player") || name.isEmpty())
        {
            return "";
        }

        return name;
    }

    private static List<String> getCoords(List<String> fields)
    {
        if (fields == null || fields.size() < 4)
        {
            return Collections.emptyList();
        }

        List<String> out = new ArrayList<>(3);
        out.add(trim(fields.get(1)));
        out.add(trim(fields.get(2)));
        out.add(trim(fields.get(3)));
        return out;
    }

    private static String normalizeUsernameKey(String username)
    {
        return username == null ? "" : username.trim().toLowerCase(Locale.ROOT);
    }

    private static boolean reserveTimedOutPlayer(DatagramSocket socket, String usernameKey, PlayerSession session, long now)
    {
        if (!players.remove(usernameKey, session))
        {
            return false;
        }

        String ip = normalizeIp(session.endpoint.address.getHostAddress());
        reservedUsernames.put(usernameKey, new UsernameReservation(
                session.username,
                ip,
                now + USERNAME_HOLD_MS
        ));

        dbg("Timed out player %s; reserving username for %d seconds to IP %s\n",
                session.username,
                USERNAME_HOLD_MS / 1000,
                ip);

        cleanupClients();
        return true;
    }
}