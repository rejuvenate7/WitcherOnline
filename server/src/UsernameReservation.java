public class UsernameReservation
{
    public final String username;
    public final String ip;
    public final long expiresAt;

    public UsernameReservation(String username, String ip, long expiresAt)
    {
        this.username = username;
        this.ip = ip;
        this.expiresAt = expiresAt;
    }
}