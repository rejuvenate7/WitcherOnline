
class r_DevManager {
    private var debugCoords : r_DebugCoords;
    private var tpWayCmd : r_TpWayCommand;

    public function Init(client : r_MultiplayerClient) {
        debugCoords = new r_DebugCoords in client;
        debugCoords.Init(client);
        
        tpWayCmd = new r_TpWayCommand in client;
    }

    public function Update(player: CPlayer) {
        if (debugCoords) {
            debugCoords.Update(player);
        }
        if (tpWayCmd) {
            tpWayCmd.Update(player);
        }
    }

    public function GetDebugCoords() : r_DebugCoords {
        return debugCoords;
    }

    public function TeleportToPin() {
        if (tpWayCmd) {
            tpWayCmd.TeleportToPin(thePlayer);
        }
    }
}

