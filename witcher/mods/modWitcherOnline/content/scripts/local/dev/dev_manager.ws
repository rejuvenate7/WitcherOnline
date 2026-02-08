
class r_DevManager {
    private var debugCoords : r_DebugCoords;

    public function Init(client : r_MultiplayerClient) {
        debugCoords = new r_DebugCoords in client;
        debugCoords.Init(client);
    }

    public function Update(player: CPlayer) {
        if (debugCoords) {
            debugCoords.Update(player);
        }
    }

    public function GetDebugCoords() : r_DebugCoords {
        return debugCoords;
    }
}
