#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <cstdarg>
#include <string>
#include <vector>
#include <unordered_map>
#include <mutex>
#include <thread>
#include <atomic>
#include <chrono>
#include <iostream>
#include <fstream>
#include <optional>
#include <filesystem>
#include <cctype>
#include <unordered_set>
namespace fs = std::filesystem;

#ifdef _WIN32
#define NOMINMAX
#define _WINSOCK_DEPRECATED_NO_WARNINGS
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#pragma comment(lib, "Ws2_32.lib")
using socket_t = SOCKET;
constexpr socket_t invalid_socket = INVALID_SOCKET;
inline int last_net_error() { return WSAGetLastError(); }
inline void closesock(socket_t s) { closesocket(s); }
inline bool net_init() { WSADATA wsa{}; return WSAStartup(MAKEWORD(2, 2), &wsa) == 0; }
inline void net_shutdown() { WSACleanup(); }
inline bool is_timeout_error(int e) { return e == WSAETIMEDOUT; }
inline void OutputDebugStringA_if(const char* s) { OutputDebugStringA(s); }
#ifndef MAX_PATH
#define MAX_PATH 260
#endif
#else
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
using socket_t = int;
constexpr socket_t invalid_socket = -1;
inline int last_net_error() { return errno; }
inline void closesock(socket_t s) { if (s != -1) ::close(s); }
inline bool net_init() { return true; }  // no-op
inline void net_shutdown() {}             // no-op
inline bool is_timeout_error(int e) { return e == EAGAIN || e == EWOULDBLOCK; }
inline void OutputDebugStringA_if(const char*) {}
#define _vsnprintf_s(buf, size, _truncate, fmt, ap) vsnprintf((buf), (size), (fmt), (ap))
#ifndef MAX_PATH
#define MAX_PATH 4096
#endif
#endif

static bool parse_port(const std::string& s, uint16_t& out) {
	try {
		size_t idx = 0;
		unsigned long v = std::stoul(s, &idx, 10);
		if (idx != s.size() || v == 0 || v > 65535) return false;
		out = static_cast<uint16_t>(v);
		return true;
	}
	catch (...) { return false; }
}

static std::string trim(std::string x) {
	auto issp = [](unsigned char c) { return std::isspace(c); };
	while (!x.empty() && issp((unsigned char)x.front())) x.erase(x.begin());
	while (!x.empty() && issp((unsigned char)x.back()))  x.pop_back();
	return x;
}

static std::optional<uint16_t> read_port_from_file(const fs::path& p) {
	std::ifstream f(p);
	if (!f) return std::nullopt;
	std::string line;
	while (std::getline(f, line)) {
		line = trim(line);
		if (line.empty()) continue;
		if (line.rfind("//", 0) == 0 || line[0] == '#' || line[0] == ';') continue;
		std::string value = line;
		if (auto eq = line.find('='); eq != std::string::npos) value = trim(line.substr(eq + 1));
		uint16_t port{};
		if (parse_port(value, port)) return port;
	}
	return std::nullopt;
}

static fs::path exe_dir() {
#ifdef _WIN32
	char buf[MAX_PATH]{};
	GetModuleFileNameA(nullptr, buf, MAX_PATH);
	return fs::path(buf).parent_path();
#else
	char buf[MAX_PATH]{};
	ssize_t n = readlink("/proc/self/exe", buf, sizeof(buf) - 1);
	if (n > 0) buf[n] = '\0';
	return fs::path(buf).parent_path();
#endif
}

static uint16_t choose_port(int argc, char** argv) {
	if (argc >= 2) {
		uint16_t p{};
		if (parse_port(argv[1], p)) return p;
		std::fprintf(stderr, "Invalid CLI port: %s (falling back)\n", argv[1]);
	}
#ifdef _WIN32
	{
		char* envValue = nullptr;
		size_t len = 0;
		if (_dupenv_s(&envValue, &len, "W3MP_PORT") == 0 && envValue) {
			uint16_t p{};
			if (parse_port(envValue, p)) { free(envValue); return p; }
			std::fprintf(stderr, "Invalid W3MP_PORT: %s (falling back)\n", envValue);
			free(envValue);
		}
	}
#else
	if (const char* env = std::getenv("W3MP_PORT")) {
		uint16_t p{};
		if (parse_port(env, p)) return p;
		std::fprintf(stderr, "Invalid W3MP_PORT: %s (falling back)\n", env);
	}
#endif
	auto confPath = exe_dir() / "server.properties";
	if (auto p = read_port_from_file(confPath)) return *p;
	return 40000;
}

static void dbg_notime(const char* fmt, ...) {
	char buf[1024];
	va_list ap; va_start(ap, fmt);
	_vsnprintf_s(buf, sizeof(buf), _TRUNCATE, fmt, ap);
	va_end(ap);
	std::cout << buf << std::flush;
	OutputDebugStringA_if(buf);
}

static void dbg(const char* fmt, ...)
{
	char msg[1024];
	va_list ap;
	va_start(ap, fmt);
	_vsnprintf_s(msg, sizeof(msg), _TRUNCATE, fmt, ap);
	va_end(ap);

	auto now = std::chrono::system_clock::now();
	std::time_t t = std::chrono::system_clock::to_time_t(now);
	std::tm tm_buf{};
#ifdef _WIN32
	localtime_s(&tm_buf, &t);
#else
	localtime_r(&t, &tm_buf);
#endif

	char prefix[64];
	std::strftime(prefix, sizeof(prefix), "[%H:%M:%S INFO]: ", &tm_buf);

	std::string out = std::string(prefix) + msg;
	std::cout << out << std::flush;
	OutputDebugStringA_if(out.c_str());
}

static bool set_no_delay(socket_t s) {
#ifdef _WIN32
	BOOL one = TRUE;
	return setsockopt(s, IPPROTO_TCP, TCP_NODELAY, (const char*)&one, sizeof(one)) == 0;
#else
	int one = 1;
	return setsockopt(s, IPPROTO_TCP, TCP_NODELAY, &one, sizeof(one)) == 0;
#endif
}

static void set_timeouts(socket_t s, int ms_recv, int ms_send) {
#ifdef _WIN32
	setsockopt(s, SOL_SOCKET, SO_RCVTIMEO, (char*)&ms_recv, sizeof(ms_recv));
	setsockopt(s, SOL_SOCKET, SO_SNDTIMEO, (char*)&ms_send, sizeof(ms_send));
#else
	timeval rcv{ ms_recv / 1000, (ms_recv % 1000) * 1000 };
	timeval snd{ ms_send / 1000, (ms_send % 1000) * 1000 };
	setsockopt(s, SOL_SOCKET, SO_RCVTIMEO, &rcv, sizeof(rcv));
	setsockopt(s, SOL_SOCKET, SO_SNDTIMEO, &snd, sizeof(snd));
#endif
}

static bool send_all(socket_t s, const char* data, size_t n) {
	while (n) {
		int r = (int)send(s, data, (int)n, 0);
		if (r <= 0) return false;
		data += r; n -= (size_t)r;
	}
	return true;
}

static bool send_line(socket_t s, const std::string& line) {
	return send_all(s, line.c_str(), line.size());
}

struct ClientInfo {
	socket_t s = invalid_socket;
	std::string id;
	std::string username;
	std::string addr;
	std::string location;

	std::vector<std::string> data;

	std::atomic<bool> alive{ true };

	std::atomic<int> ping_ms{ -1 };
	std::chrono::steady_clock::time_point connect_time;
	std::chrono::steady_clock::time_point last_seen;
};

static std::unordered_map<std::string, ClientInfo*> g_clients;
static std::mutex g_mu;
static std::atomic<bool> g_running{ true };
static socket_t g_listen_socket = invalid_socket;

static std::unordered_set<std::string> g_banned_ips;
static std::mutex g_ban_mu;

static std::unordered_set<std::string> g_whitelisted_ips;
static std::mutex g_whitelist_mu;
static std::atomic<bool> g_whitelist_enabled{ false };

static bool read_whitelist_flag_from_file(bool& out) {
	auto confPath = exe_dir() / "server.properties";
	std::ifstream f(confPath);
	if (!f) return false;

	std::string line;
	while (std::getline(f, line)) {
		line = trim(line);
		if (line.empty()) continue;
		if (line.rfind("//", 0) == 0 || line[0] == '#' || line[0] == ';') continue;

		auto eq = line.find('=');
		if (eq == std::string::npos) continue;

		std::string key = trim(line.substr(0, eq));
		std::string value = trim(line.substr(eq + 1));
		if (key == "whitelist") {
			std::string vLower;
			vLower.reserve(value.size());
			for (char ch : value)
				vLower.push_back((char)std::tolower((unsigned char)ch));

			if (vLower == "true" || vLower == "1" || vLower == "yes" || vLower == "on")
				out = true;
			else
				out = false;
			return true;
		}
	}
	return false;
}

static fs::path whitelisted_players_path() {
	return exe_dir() / "whitelisted-players.json";
}

static void load_whitelist_ips() {
	std::lock_guard<std::mutex> lk(g_whitelist_mu);
	g_whitelisted_ips.clear();

	fs::path path = whitelisted_players_path();
	std::ifstream f(path);
	if (!f) {
		return;
	}

	std::string content((std::istreambuf_iterator<char>(f)),
		std::istreambuf_iterator<char>());

	std::string cur;
	bool in_string = false;

	for (size_t i = 0; i < content.size(); ++i) {
		char c = content[i];
		if (!in_string) {
			if (c == '"') {
				in_string = true;
				cur.clear();
			}
		}
		else {
			if (c == '"') {
				in_string = false;
				if (!cur.empty()) {
					g_whitelisted_ips.insert(cur);
				}
			}
			else if (c == '\\') {
				if (i + 1 < content.size()) {
					char next = content[++i];
					cur.push_back(next);
				}
			}
			else {
				cur.push_back(c);
			}
		}
	}
}

static void save_whitelist_ips() {
	std::lock_guard<std::mutex> lk(g_whitelist_mu);
	fs::path path = whitelisted_players_path();
	std::ofstream f(path, std::ios::trunc);
	if (!f) {
		dbg("Failed to write whitelist IP list to %s\n",
			path.string().c_str());
		return;
	}

	f << "[\n";
	bool first = true;
	for (const auto& ip : g_whitelisted_ips) {
		if (!first) f << ",\n";
		first = false;
		f << "  \"" << ip << "\"";
	}
	f << "\n]\n";
}

static bool is_ip_whitelisted(const std::string& ip) {
	std::lock_guard<std::mutex> lk(g_whitelist_mu);
	return g_whitelisted_ips.find(ip) != g_whitelisted_ips.end();
}

static fs::path banned_players_path() {
	return exe_dir() / "banned-players.json";
}

static void load_banned_ips() {
	std::lock_guard<std::mutex> lk(g_ban_mu);
	g_banned_ips.clear();

	fs::path path = banned_players_path();
	std::ifstream f(path);
	if (!f) {
		return;
	}

	std::string content((std::istreambuf_iterator<char>(f)),
		std::istreambuf_iterator<char>());

	std::string cur;
	bool in_string = false;

	for (size_t i = 0; i < content.size(); ++i) {
		char c = content[i];
		if (!in_string) {
			if (c == '"') {
				in_string = true;
				cur.clear();
			}
		}
		else {
			if (c == '"') {
				in_string = false;
				if (!cur.empty()) {
					g_banned_ips.insert(cur);
				}
			}
			else if (c == '\\') {
				if (i + 1 < content.size()) {
					char next = content[++i];
					cur.push_back(next);
				}
			}
			else {
				cur.push_back(c);
			}
		}
	}

	if (!g_banned_ips.empty()) {
		dbg("Loaded %zu banned IP(s) from %s\n",
			g_banned_ips.size(),
			path.string().c_str());
	}
}

static void save_banned_ips() {
	std::lock_guard<std::mutex> lk(g_ban_mu);
	fs::path path = banned_players_path();
	std::ofstream f(path, std::ios::trunc);
	if (!f) {
		dbg("Failed to write banned IP list to %s\n",
			path.string().c_str());
		return;
	}

	f << "[\n";
	bool first = true;
	for (const auto& ip : g_banned_ips) {
		if (!first) f << ",\n";
		first = false;
		f << "  \"" << ip << "\"";
	}
	f << "\n]\n";
}

static bool is_ip_banned(const std::string& ip) {
	std::lock_guard<std::mutex> lk(g_ban_mu);
	return g_banned_ips.find(ip) != g_banned_ips.end();
}

static std::string getUsername(const std::vector<std::string>& fields) {
	if (fields.empty())
		return {};

	std::string name = trim(fields[0]);

	if (name == "NR_PlayerManager.Init" || name == "Player" || name.empty() || name == " ")
	{
		return {};
	}

	return name;
}

static std::string getRegion(std::string region)
{
	if (region == "1" || region == "9")
	{
		region = "Novigrad/Velen";
	}
	else if (region == "2")
	{
		region = "Skellige";
	}
	else if (region == "3")
	{
		region = "Kaer Morhen";
	}
	else if (region == "4" || region == "8")
	{
		region = "White Orchard";
	}
	else if (region == "5")
	{
		region = "Vizima";
	}
	else if (region == "6")
	{
		region = "Isle of Mists";
	}
	else if (region == "7")
	{
		region = "Spiral";
	}
	else if (region == "11")
	{
		region = "Toussaint";
	}
	else
	{
		region = "Unknown";
	}

	return region;
}

static std::string getLocation(const std::vector<std::string>& fields) {
	if (fields.empty() || fields.size() < 8)
		return {};

	std::string name = trim(fields[7]);

	if (name == "NR_PlayerManager.Init" || name == "Player" || name.empty() || name == " ")
	{
		return {};
	}

	return name;
}

static std::vector<std::string> getCoords(const std::vector<std::string>& fields) {
	if (fields.empty() || fields.size() < 8)
		return {};

	std::vector<std::string> toReturn;
	toReturn.push_back(trim(fields[1]));
	toReturn.push_back(trim(fields[2]));
	toReturn.push_back(trim(fields[3]));

	return toReturn;
}

static std::vector<std::string> split_tsv(const std::string& s) {
	std::vector<std::string> out;
	size_t i = 0, n = s.size();
	while (i < n) {
		size_t j = s.find('\t', i);
		if (j == std::string::npos) j = n;
		out.emplace_back(s.substr(i, j - i));
		i = j + (j < n ? 1 : 0);
	}
	return out;
}

static std::string json_escape(const std::string& s) {
	std::string o; o.reserve(s.size() + 8);
	for (char c : s) {
		if (c == '\\' || c == '\"') { o.push_back('\\'); o.push_back(c); }
		else if ((unsigned char)c < 0x20) {}
		else o.push_back(c);
	}
	return o;
}

static std::string mk_world_snapshot_json() {
	std::lock_guard<std::mutex> lk(g_mu);
	std::string out = "WORLD [";
	bool first = true;
	for (auto& kv : g_clients) {
		ClientInfo* c = kv.second;
		if (!c) continue;
		if (!first) out += ",";
		first = false;
		out += "{\"id\":\"" + json_escape(kv.first) + "\",\"d\":[";
		for (size_t i = 0; i < c->data.size(); ++i) {
			if (i) out += ",";
			out += "\"" + json_escape(c->data[i]) + "\"";
		}
		out += "]}";
	}
	out += "]\n";
	return out;
}

static void broadcast_thread() {
	using namespace std::chrono_literals;
	while (g_running.load()) {
		std::string world = mk_world_snapshot_json();
		{
			std::lock_guard<std::mutex> lk(g_mu);
			for (auto& kv : g_clients) {
				ClientInfo* c = kv.second;
				if (!c) continue;
				if (c->alive.load() && c->s != invalid_socket) {
					(void)send_line(c->s, world);
				}
			}
		}
		std::this_thread::sleep_for(100ms);
	}
}

static void console_thread() {
	std::string line;
	while (g_running.load() && std::getline(std::cin, line)) {
		if (line == "list") {
			std::lock_guard<std::mutex> lk(g_mu);
			dbg("---- Connected players (%zu) ----\n", g_clients.size());
			for (auto& kv : g_clients) {
				ClientInfo* c = kv.second;
				if (!c || !c->alive.load()) continue;

				auto now = std::chrono::steady_clock::now();
				auto secs_since_seen =
					std::chrono::duration_cast<std::chrono::seconds>(now - c->last_seen).count();

				std::string location = getRegion(getLocation(c->data));

				std::vector<std::string> coordsVec = getCoords(c->data);
				std::string coordsStr;
				if (coordsVec.size() == 3) {
					coordsStr = "(" + coordsVec[0] + ", " + coordsVec[1] + ", " + coordsVec[2] + ")";
				}

				dbg("id=%s  name=\"%s\"  ip=%s  ping=%dms  location=%s  coords=%s  lastSeen=%llds ago\n",
					c->id.c_str(),
					c->username.empty() ? "?" : c->username.c_str(),
					c->addr.c_str(),
					c->ping_ms.load(),
					location.empty() ? "?" : location.c_str(),
					coordsStr.empty() ? "?" : coordsStr.c_str(),
					(long long)secs_since_seen);
			}
			dbg_notime("\n");
		}
		else if (line.rfind("kick", 0) == 0) {
			std::string arg = trim(line.substr(4)); // strip "kick"
			if (arg.empty()) {
				dbg("Usage: kick <id|name>\n\n");
				continue;
			}

			bool kicked = false;
			{
				std::lock_guard<std::mutex> lk(g_mu);

				ClientInfo* victim = nullptr;

				auto it = g_clients.find(arg);
				if (it != g_clients.end() && it->second && it->second->alive.load()) {
					victim = it->second;
				}
				else {
					std::string argLower = arg;
					for (auto& ch : argLower)
						ch = (char)std::tolower((unsigned char)ch);

					for (auto& kv : g_clients) {
						ClientInfo* c = kv.second;
						if (!c || !c->alive.load()) continue;
						if (c->username.empty()) continue;

						std::string nameLower = c->username;
						for (auto& ch : nameLower)
							ch = (char)std::tolower((unsigned char)ch);

						if (nameLower == argLower) {
							victim = c;
							break;
						}
					}
				}

				if (victim) {
					dbg("Kicking %s (id=%s, ip=%s)\n",
						victim->username.empty() ? "?" : victim->username.c_str(),
						victim->id.c_str(),
						victim->addr.c_str());

					if (victim->s != invalid_socket) {
						closesock(victim->s);
						victim->s = invalid_socket;
					}
					victim->alive.store(false);
					kicked = true;
				}
			}

			if (!kicked) {
				dbg("No connected client matches \"%s\".\n\n", arg.c_str());
			}
		}
		else if (line.rfind("ban", 0) == 0) {
			std::string arg = trim(line.substr(3)); // strip "ban"
			if (arg.empty()) {
				dbg("Usage: ban <id|name|ip>\n\n");
				continue;
			}

			std::string ipToBan;

			{
				std::lock_guard<std::mutex> lk(g_mu);

				ClientInfo* victim = nullptr;

				auto it = g_clients.find(arg);
				if (it != g_clients.end() && it->second && it->second->alive.load()) {
					victim = it->second;
				}
				else {
					std::string argLower = arg;
					for (auto& ch : argLower)
						ch = (char)std::tolower((unsigned char)ch);

					for (auto& kv : g_clients) {
						ClientInfo* c = kv.second;
						if (!c || !c->alive.load()) continue;
						if (c->username.empty()) continue;

						std::string nameLower = c->username;
						for (auto& ch : nameLower)
							ch = (char)std::tolower((unsigned char)ch);

						if (nameLower == argLower) {
							victim = c;
							break;
						}
					}
				}

				if (victim) {
					std::string::size_type colonPos = victim->addr.find(':');
					if (colonPos != std::string::npos)
						ipToBan = victim->addr.substr(0, colonPos);
					else
						ipToBan = victim->addr;

					dbg("Banning %s (id=%s, ip=%s)\n",
						victim->username.empty() ? "?" : victim->username.c_str(),
						victim->id.c_str(),
						victim->addr.c_str());

					if (victim->s != invalid_socket) {
						closesock(victim->s);
						victim->s = invalid_socket;
					}
					victim->alive.store(false);
				}
			}

			if (ipToBan.empty()) {
				std::string::size_type colonPos = arg.find(':');
				if (colonPos != std::string::npos)
					ipToBan = arg.substr(0, colonPos);
				else
					ipToBan = arg;
			}

			if (ipToBan.empty()) {
				dbg("Could not resolve \"%s\" to an IP address to ban.\n\n", arg.c_str());
				continue;
			}

			bool newlyBanned = false;
			{
				std::lock_guard<std::mutex> ban_lk(g_ban_mu);
				newlyBanned = g_banned_ips.insert(ipToBan).second;
			}

			if (newlyBanned) {
				save_banned_ips();
				dbg("Added IP '%s' to ban list.\n\n", ipToBan.c_str());
			}
			else {
				dbg("IP '%s' is already in ban list.\n\n", ipToBan.c_str());
			}
		}
		else if (line.rfind("unban", 0) == 0) {
			std::string arg = trim(line.substr(5)); // strip "unban"
			if (arg.empty()) {
				dbg("Usage: unban <ip>\n\n");
				continue;
			}

			std::string ip = arg;
			std::string::size_type colonPos = ip.find(':');
			if (colonPos != std::string::npos) {
				ip = ip.substr(0, colonPos);
			}

			if (ip.empty()) {
				dbg("Usage: unban <ip>\n\n");
				continue;
			}

			bool removed = false;
			{
				std::lock_guard<std::mutex> ban_lk(g_ban_mu);
				auto it = g_banned_ips.find(ip);
				if (it != g_banned_ips.end()) {
					g_banned_ips.erase(it);
					removed = true;
				}
			}

			if (removed) {
				save_banned_ips();
				dbg("'%s' has been unbanned.\n\n", ip.c_str());
			}
			else {
				dbg("IP '%s' is not banned.\n\n", ip.c_str());
			}
		}
		else if (line.rfind("whitelist", 0) == 0) {
			std::string arg = trim(line.substr(9));
			if (arg.empty()) {
				dbg("Usage: whitelist on|off - enable or disable the whitelist\n");
				dbg("Usage: whitelist <ip>|remove <ip> - add or remove IP to whitelist\n\n");
				continue;
			}

			std::string argLower = arg;
			for (auto& ch : argLower)
				ch = (char)std::tolower((unsigned char)ch);

			if (argLower == "on") {
				g_whitelist_enabled.store(true);
				dbg("The whitelist is now enabled.\n\n");
			}
			else if (argLower == "off") {
				g_whitelist_enabled.store(false);
				dbg("The whitelist is now disabled.\n\n");
			}
			else if (argLower.rfind("remove", 0) == 0) {
				std::string ip = trim(arg.substr(6));
				if (ip.empty()) {
					dbg("Usage: whitelist remove <ip>\n\n");
					continue;
				}

				std::string::size_type colonPos = ip.find(':');
				if (colonPos != std::string::npos)
					ip = ip.substr(0, colonPos);

				if (ip.empty()) {
					dbg("Usage: whitelist remove <ip>\n\n");
					continue;
				}

				bool removed = false;
				{
					std::lock_guard<std::mutex> wl_lk(g_whitelist_mu);
					auto it = g_whitelisted_ips.find(ip);
					if (it != g_whitelisted_ips.end()) {
						g_whitelisted_ips.erase(it);
						removed = true;
					}
				}

				if (removed) {
					save_whitelist_ips();
					dbg("Removed IP '%s' from whitelist.\n\n", ip.c_str());
				}
				else {
					dbg("IP '%s' is not in the whitelist.\n\n", ip.c_str());
				}
			}
			else {
				std::string ip = arg;
				std::string::size_type colonPos = ip.find(':');
				if (colonPos != std::string::npos)
					ip = ip.substr(0, colonPos);

				if (ip.empty()) {
					dbg("Usage: whitelist on|off - enable or disable the whitelist\n");
					dbg("Usage: whitelist <ip>|remove <ip> - add or remove IP to whitelist\n\n");
					continue;
				}

				bool newlyAdded = false;
				{
					std::lock_guard<std::mutex> wl_lk(g_whitelist_mu);
					newlyAdded = g_whitelisted_ips.insert(ip).second;
				}

				if (newlyAdded) {
					save_whitelist_ips();
					dbg("Added IP '%s' to whitelist.\n\n", ip.c_str());
				}
				else {
					dbg("IP '%s' is already in whitelist.\n\n", ip.c_str());
				}
			}
		}
		else if (line == "stop") {
			dbg("Shutting down...\n\n");
			g_running.store(false);

			if (g_listen_socket != invalid_socket) {
#ifdef _WIN32
				shutdown(g_listen_socket, SD_BOTH);
#else
				shutdown(g_listen_socket, SHUT_RDWR);
#endif
				closesock(g_listen_socket);
				g_listen_socket = invalid_socket;
			}
			break;
		}
		else if (line == "help" || line == "?") {
			dbg("--------- Help: Index ---------\n");
			dbg("kick <id|name>            - disconnect a player\n");
			dbg("ban <id|name|ip>          - ban by id/name/ip and prevent future joins\n");
			dbg("unban <ip>                - remove IP from ban list\n");
			dbg("whitelist on|off|<ip>     - toggle whitelist or add IP to whitelist\n");
			dbg("whitelist remove <ip>     - remove IP from whitelist\n");
			dbg("list                      - list connected clients\n");
			dbg("about                     - info about Witcher Online\n");
			dbg("stop                      - stop server\n");
			dbg("help                      - show this help\n\n");
		}
		else if (line == "about") {
			dbg("--------- About ---------\n");
			dbg("Witcher Online v1.0\n");
			dbg("by rejuvenate7\n");
			dbg("https://github.com/rejuvenate7\n");
			dbg("https://discord.gg/KYu9c5TWej\n\n");
		}
		else if (!line.empty()) {
			dbg("Unknown command: %s (type 'help')\n\n", line.c_str());
		}
	}
}

static std::string assign_unique_id() {
	static std::atomic<uint64_t> counter{ 1 };
	return std::to_string(counter.fetch_add(1));
}

static void remove_client(ClientInfo* ci) {
	std::lock_guard<std::mutex> lk(g_mu);
	if (!ci->id.empty()) {
		auto it = g_clients.find(ci->id);
		if (it != g_clients.end() && it->second == ci) g_clients.erase(it);
	}
}

static void close_client(ClientInfo* ci) {
	if (ci->s != invalid_socket) {
		closesock(ci->s);
		ci->s = invalid_socket;
	}
	ci->alive.store(false);
}

static void broadcast_disconnect(const std::string& id, ClientInfo* exclude) {
	if (id.empty()) return;
	std::vector<socket_t> recips;
	{
		std::lock_guard<std::mutex> lk(g_mu);
		recips.reserve(g_clients.size());
		for (auto& kv : g_clients) {
			ClientInfo* c = kv.second;
			if (!c || !c->alive.load() || c == exclude || c->s == invalid_socket) continue;
			recips.push_back(c->s);
		}
	}
	const std::string msg = "DISCONNECT " + id + "\n";
	for (socket_t s : recips) (void)send_all(s, msg.c_str(), msg.size());
}

static void client_thread(ClientInfo* ci) {
	set_no_delay(ci->s);
	set_timeouts(ci->s, 2000, 2000);

	std::string buffer;
	buffer.reserve(4096);

	{
		char tmp[1024];
		int n = recv(ci->s, tmp, sizeof(tmp), 0);
		if (n > 0) buffer.append(tmp, tmp + n);
	}

	auto eat_line = [](std::string& buf)->std::string {
		auto pos = buf.find('\n');
		if (pos == std::string::npos) return {};
		std::string line = buf.substr(0, pos);
		buf.erase(0, pos + 1);
		if (!line.empty() && line.back() == '\r') line.pop_back();
		return line;
		};

	bool greeted = false;
	while (true) {
		std::string line = eat_line(buffer);
		if (line.empty()) break;
		if (line.rfind("HELLO", 0) == 0) {
			std::string id = assign_unique_id();
			{
				std::lock_guard<std::mutex> lk(g_mu);
				auto it = g_clients.find(id);
				if (it != g_clients.end() && it->second && it->second != ci) {
					it->second->alive.store(false);
					g_clients.erase(it);
				}
				ci->id = id;
				g_clients[id] = ci;
			}
			std::string welcome = "WELCOME " + ci->id + "\n";
			send_line(ci->s, welcome);
			dbg("ID of player %s is %s\n",
				ci->addr.c_str(),
				ci->id.c_str());
			greeted = true;
			break;
		}
		else {
			break;
		}
	}

	if (!greeted) {
		ci->id = assign_unique_id();
		{
			std::lock_guard<std::mutex> lk(g_mu);
			g_clients[ci->id] = ci;
		}
		std::string welcome = "WELCOME " + ci->id + "\n";
		send_line(ci->s, welcome);
		dbg("ID of player %s is %s\n",
			ci->addr.c_str(),
			ci->id.c_str());
	}

	while (g_running.load() && ci->alive.load()) {
		if (buffer.find('\n') == std::string::npos) {
			char tmp[2048];
			int n = recv(ci->s, tmp, sizeof(tmp), 0);
			if (n > 0) {
				buffer.append(tmp, tmp + n);
			}
			else if (n == 0) {
				break;
			}
			else {
				int e = last_net_error();
				if (!is_timeout_error(e)) {
					break;
				}
			}
		}

		std::string line = eat_line(buffer);
		if (line.empty()) continue;

		if (line.rfind("DATA\t", 0) == 0) {
			std::vector<std::string> fields = split_tsv(line.substr(5));
			std::string username = getUsername(fields);
			std::string location = getLocation(fields);
			std::vector<std::string> coords = getCoords(fields);

			{
				std::lock_guard<std::mutex> lk(g_mu);
				ci->data.swap(fields);
				ci->last_seen = std::chrono::steady_clock::now();

				if (!username.empty() && !location.empty() && ci->username != username) {
					bool firstName = ci->username.empty();
					ci->username = username;
					ci->location = location;
					std::string region = getRegion(ci->location);

					if (firstName) {
						if (region == "Unknown")
						{
							dbg("%s[/%s] joined with entity id %s\n",
								ci->username.c_str(),
								ci->addr.c_str(),
								ci->id.c_str());
						}
						else
						{
							dbg("%s[/%s] joined with entity id %s in region %s\n",
								ci->username.c_str(),
								ci->addr.c_str(),
								ci->id.c_str(),
								region.c_str());
						}
					}
					else {
						dbg("Entity %s (%s) changed name to \"%s\"\n",
							ci->id.c_str(),
							ci->addr.c_str(),
							ci->username.c_str());
					}
				}

				if (!username.empty() && !location.empty() && (coords.size() == 3) && ci->location != location)
				{
					ci->location = location;
					std::string region = getRegion(ci->location);
					dbg("%s is now in region %s at (%s, %s, %s)\n",
						ci->username.c_str(),
						region.c_str(),
						coords[0].c_str(),
						coords[1].c_str(),
						coords[2].c_str());
				}
			}
		}
		else if (line.rfind("PING", 0) == 0) {
			ci->last_seen = std::chrono::steady_clock::now();

			int clientPing = -1;
			if (line.size() > 4) {
				const char* p = line.c_str() + 4;
				while (*p == ' ') ++p;
				if (*p) {
					try { clientPing = std::stoi(p); }
					catch (...) {}
				}
			}
			if (clientPing >= 0) {
				ci->ping_ms.store(clientPing);
			}

			send_line(ci->s, "PONG\n");
		}
		else if (line.rfind("HELLO ", 0) == 0) {
			std::string id = line.substr(6);
			if (id.empty()) id = assign_unique_id();
			{
				std::lock_guard<std::mutex> lk(g_mu);
				auto it = g_clients.find(id);
				if (it != g_clients.end() && it->second != ci) {
					it->second->alive.store(false);
					g_clients.erase(it);
				}
				if (!ci->id.empty() && ci->id != id) {
					g_clients.erase(ci->id);
				}
				ci->id = id;
				g_clients[id] = ci;
			}
			std::string welcome = "WELCOME " + ci->id + "\n";
			send_line(ci->s, welcome);
		}
		else if (line == "BYE") {
			break;
		}
		else {
		}
	}

	if (ci->username.empty())
	{
		dbg("%s lost connection: Disconnected\n", ci->id.c_str());
	}
	else
	{
		dbg("%s lost connection: Disconnected\n", ci->username.c_str());
	}
	const std::string id_copy = ci->id;
	broadcast_disconnect(id_copy, ci);
	remove_client(ci);
	close_client(ci);

	delete ci;
}

int main(int argc, char** argv) {
	uint16_t port = choose_port(argc, argv);

	bool wlFromFile = false;
	if (read_whitelist_flag_from_file(wlFromFile)) {
		g_whitelist_enabled.store(wlFromFile);
	}


	load_banned_ips();
	load_whitelist_ips();

	if (!net_init()) {
		std::fprintf(stderr, "Network init failed\n");
		return 1;
	}

	socket_t ls = ::socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (ls == invalid_socket) { std::fprintf(stderr, "socket() failed\n"); net_shutdown(); return 2; }

	g_listen_socket = ls;

#ifdef _WIN32
	BOOL yes = TRUE;
	setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, (const char*)&yes, sizeof(yes));
#else
	int yes = 1;
	setsockopt(ls, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));
#endif

	sockaddr_in addr{};
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = htonl(INADDR_ANY);
	addr.sin_port = htons(port);

	if (bind(ls, (sockaddr*)&addr, sizeof(addr)) != 0) {
		std::fprintf(stderr, "bind() failed: %d\n", last_net_error());
		closesock(ls); net_shutdown(); return 3;
	}
	if (listen(ls, SOMAXCONN) != 0) {
		std::fprintf(stderr, "listen() failed: %d\n", last_net_error());
		closesock(ls); net_shutdown(); return 4;
	}

	dbg_notime("Launching Witcher Online for The Witcher 3: Wild Hunt...\n");
	dbg_notime("Author: rejuvenate7 - Github: https://github.com/rejuvenate7\n");
	dbg("Starting Witcher Online server on *:%u\n", port);
	dbg("For help, type \"help\" or \"?\"\n");

	std::thread broadcaster(broadcast_thread);
	std::thread console(console_thread);

	while (g_running.load()) {
		sockaddr_in ca{}; socklen_t calen = (socklen_t)sizeof(ca);
		socket_t cs = accept(ls, (sockaddr*)&ca, &calen);
		if (cs == invalid_socket) {
			int e = last_net_error();

			if (!g_running.load()) {
				break;
			}

			std::fprintf(stderr, "accept error: %d\n", e);
			continue;
		}

		char addrbuf[64]{};
		inet_ntop(AF_INET, &ca.sin_addr, addrbuf, sizeof(addrbuf));
		unsigned short cport = ntohs(ca.sin_port);

		std::string ipStr(addrbuf);

		if (is_ip_banned(ipStr)) {
			dbg("Rejected connection from banned IP %s:%hu\n",
				addrbuf,
				cport);
			closesock(cs);
			continue;
		}


		if (g_whitelist_enabled.load() && !is_ip_whitelisted(ipStr)) {
			dbg("Rejected connection from non-whitelisted IP %s:%hu\n",
				addrbuf,
				cport);
			closesock(cs);
			continue;
		}

		auto* ci = new ClientInfo();
		ci->s = cs;
		ci->connect_time = std::chrono::steady_clock::now();
		ci->last_seen = ci->connect_time;
		ci->addr = std::string(addrbuf) + ":" + std::to_string(cport);

		std::thread(client_thread, ci).detach();
	}

	g_running.store(false);
	if (broadcaster.joinable()) broadcaster.join();
	if (console.joinable()) console.join();
	closesock(ls);
	net_shutdown();
	return 0;
}
