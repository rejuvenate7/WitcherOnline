import java.util.Collections;
import java.util.List;

public class PlayerSession
{
    public final String username;
    public volatile ClientEndpoint endpoint;
    public volatile long lastSeen;

    public volatile List<String> update1AFields = Collections.emptyList();
    public volatile List<String> update1BFields = Collections.emptyList();
    public volatile List<String> update2AFields = Collections.emptyList();
    public volatile List<String> update2BFields = Collections.emptyList();

    public PlayerSession(String username, ClientEndpoint endpoint, long lastSeen)
    {
        this.username = username;
        this.endpoint = endpoint;
        this.lastSeen = lastSeen;
    }
}