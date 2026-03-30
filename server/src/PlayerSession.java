import java.util.Collections;
import java.util.List;

public class PlayerSession {
    public final String username;
    public volatile ClientEndpoint endpoint;
    public volatile List<String> fields;
    public volatile long lastSeen;

    public PlayerSession(String username, ClientEndpoint endpoint, long now) {
        this.username = username;
        this.endpoint = endpoint;
        this.fields = Collections.emptyList();
        this.lastSeen = now;
    }
}