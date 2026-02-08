
class r_DevManager {
    private var debugCoords : r_DebugCoords;
    private var tpWayCmd : r_TpWayCommand;
    private var tpCmd : r_TpCommand;

    public function Init(client : r_MultiplayerClient) {
        debugCoords = new r_DebugCoords in client;
        debugCoords.Init(client);
        
        tpWayCmd = new r_TpWayCommand in client;
        tpCmd = new r_TpCommand in client;
    }

    public function Update(player: CPlayer) {
        if (debugCoords) {
            debugCoords.Update(player);
        }
        if (tpWayCmd) {
            tpWayCmd.Update(player);
        }
        if (tpCmd) {
            tpCmd.Update(player);
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

    public function TeleportTo(x : float, y : float, z : float, area : int) {
        if (tpCmd) {
            tpCmd.TeleportTo(thePlayer, x, y, z, area);
        }
    }
}
