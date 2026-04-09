import java.net.InetAddress;
import java.util.Objects;

public class ClientEndpoint {
    public final InetAddress address;
    public final int port;

    public ClientEndpoint(InetAddress address, int port) {
        this.address = address;
        this.port = port;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof ClientEndpoint other)) return false;
        return port == other.port && Objects.equals(address, other.address);
    }

    @Override
    public int hashCode() {
        return Objects.hash(address, port);
    }

    @Override
    public String toString() {
        return address.getHostAddress() + ":" + port;
    }
}

// Hi! from supeeeeeerstiiinkyyyyyygaaaaaaaaamer920!!! thOUSANDS!!!

// WElcome home.

// I am a super stinky gamer. I have been playing games for 10 years. I am very good at games. I am the best gamer in the world. I have won many tournaments. I am very popular on Twitch. I have millions of followers. I am a super stinky gamer.
// ... yeah.
public class CountToTen {
    public static void main(String[] args) {
        for (int i = 1; i <= 10; i++) {
            //counts to ten.
        }
    }
}