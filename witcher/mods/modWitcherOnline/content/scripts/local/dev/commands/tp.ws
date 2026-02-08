
class r_TpCommand {
    private var pendingTeleport : bool;
    private var targetPos : Vector;
    private var targetArea : int;
    private var teleportStartTime : float;
    private var retryCount : int;

    public function TeleportTo(player: CPlayer, x : float, y : float, z : float, area : int) {
        var manager : CCommonMapManager = theGame.GetCommonMapManager();
        var pos, groundPos, playerPos : Vector;
        var autoZ : bool;
        
        pos.X = x;
        pos.Y = y;
        autoZ = (z == 0.0);
        pos.Z = 100;

        // Cross-map teleport
        if (area > 0 && area != manager.GetCurrentArea()) {
            theGame.GetGuiManager().ShowNotification("Changing world...");
            pos.Z = 150.0;
            
            pendingTeleport = true;
            targetPos = pos;
            targetArea = area;
            teleportStartTime = 0.0;
            retryCount = 0;
            
            theGame.ScheduleWorldChangeToPosition(manager.GetWorldPathFromAreaType(area), pos, player.GetWorldRotation());
            return;
        }
        
        // Same-map teleport with auto Z
        if (autoZ) {
            if (r_FindGroundZ(pos, groundPos)) {
                player.Teleport(groundPos);
                theGame.GetGuiManager().ShowNotification("Teleported!");
                return;
            }
            playerPos = player.GetWorldPosition();
            pos.Z = playerPos.Z;
        } else {
            pos.Z = z;
        }
        
        player.Teleport(pos);
        theGame.GetGuiManager().ShowNotification("Teleported!");
    }

    public function Update(player: CPlayer) {
        var manager : CCommonMapManager = theGame.GetCommonMapManager();
        var currentTime : float;
        var groundPos, playerPos : Vector;

        if (!pendingTeleport) {
            return;
        }

        if (manager.GetCurrentArea() != targetArea) {
            return;
        }

        currentTime = theGame.GetEngineTimeAsSeconds();
        
        if (teleportStartTime == 0.0) {
            teleportStartTime = currentTime;
            return;
        }

        if ((currentTime - teleportStartTime) < 0.5) {
            return;
        }

        if (r_FindGroundZ(targetPos, groundPos)) {
            player.Teleport(groundPos);
            theGame.GetGuiManager().ShowNotification("Teleported!");
            pendingTeleport = false;
            return;
        }
        
        retryCount += 1;
        if (retryCount < 10) {
            teleportStartTime = currentTime - 1.5;
            return;
        }
        
        playerPos = player.GetWorldPosition();
        groundPos = targetPos;
        groundPos.Z = playerPos.Z;
        player.Teleport(groundPos);
        theGame.GetGuiManager().ShowNotification("Teleported (fallback).");
        pendingTeleport = false;
    }
}

// Usage:
// tp(x, y)           - Teleport to X,Y with auto Z
// tp(x, y, z)        - Teleport to X,Y,Z
// tp(x, y, 0, area)  - Teleport to X,Y in specified area with auto Z
// tp(x, y, z, area)  - Teleport to X,Y,Z in specified area
//
// Areas (EAreaName) - valores começam em 0:
//  0 = AN_Undefined
//  1 = AN_NMLandEnv (No Man's Land / Velen + Novigrad)
//  2 = AN_Skellige_ArdSkellig (Skellige)
//  3 = AN_Kaer_Morhen
//  4 = AN_Prologue_Village (White Orchard)
//  5 = AN_Wyzima (Royal Palace in Vizima)
//  6 = AN_Island_of_Mist
//  7 = AN_Spiral
//  8 = AN_Prologue_Village_Winter
// 
// DLC Areas:
// 100 = AN_Dlc_Bob (Toussaint - Blood and Wine)

exec function tp(x : float, y : float, optional z : float, optional area : int) {
    theGame.r_getMultiplayerClient().GetDevManager().TeleportTo(x, y, z, area);
}
