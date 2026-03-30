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