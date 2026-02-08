
class r_TpWayCommand {
    private var pendingTeleport : bool;
    private var targetPos : Vector;
    private var targetArea : int;
    private var teleportStartTime : float;
    private var retryCount : int;

    public function TeleportToPin(player: CPlayer) {
        var manager : CCommonMapManager = theGame.GetCommonMapManager();
        var pos, groundPos, playerPos : Vector;
        var i, id, area, type : int;
        var x, y : float;

        // Find user waypoint
        for (i = 0; i < 5; i += 1) {
            if (manager.GetUserMapPinByIndex(i, id, area, x, y, type)) {
                pos.X = x;
                pos.Y = y;
                pos.Z = 100;
                break;
            }
        }

        if (i >= 5) {
            theGame.GetGuiManager().ShowNotification("No User Pin found!");
            return;
        }

        // Cross-map teleport
        if (area != manager.GetCurrentArea()) {
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
        
        // Same-map teleport
        if (r_FindGroundZ(pos, groundPos)) {
            player.Teleport(groundPos);
            theGame.GetGuiManager().ShowNotification("Teleported!");
        } else {
            playerPos = player.GetWorldPosition();
            pos.Z = playerPos.Z + 1.0;
            player.Teleport(pos);
            theGame.GetGuiManager().ShowNotification("Teleported (fallback Z).");
        }
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
        
        // Start timer on arrival
        if (teleportStartTime == 0.0) {
            teleportStartTime = currentTime;
            return;
        }

        // Wait 0.5 seconds for world to stream
        if ((currentTime - teleportStartTime) < 0.5) {
            return;
        }

        // Try to find ground
        if (r_FindGroundZ(targetPos, groundPos)) {
            player.Teleport(groundPos);
            theGame.GetGuiManager().ShowNotification("Teleported!");
            pendingTeleport = false;
            return;
        }
        
        // Retry up to 10 times
        retryCount += 1;
        if (retryCount < 10) {
            teleportStartTime = currentTime - 1.5;
            return;
        }
        
        // Give up, use current Z
        playerPos = player.GetWorldPosition();
        groundPos = targetPos;
        groundPos.Z = playerPos.Z;
        player.Teleport(groundPos);
        theGame.GetGuiManager().ShowNotification("Teleported (fallback).");
        pendingTeleport = false;
    }
}

exec function tpway() {
    theGame.r_getMultiplayerClient().GetDevManager().TeleportToPin();
}
