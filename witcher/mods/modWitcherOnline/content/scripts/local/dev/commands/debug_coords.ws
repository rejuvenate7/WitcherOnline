
class r_DebugCoords {
    private var showCoords : bool;
    default showCoords = false;

    public function Toggle() {
        showCoords = !showCoords;
        if (!showCoords) {
            this.Hide();
        }
    }

    public function Init(client : r_MultiplayerClient) {
        // Optional initialization
    }

    private function Hide() {
        MP_SUOL_getManager().deleteByTag("MPClientCoords");
    }

    public function Update(player: CPlayer) {
        var coordsOneliner : MP_SU_OnelinerScreen;
        var pos : Vector;
        var rot : EulerAngles;
        var txt : string;

        if (!showCoords) {
            return;
        }

        pos = player.GetWorldPosition();
        rot = player.GetWorldRotation();

        txt = "X: " + pos.X + "<br/>Y: " + pos.Y + "<br/>Z: " + pos.Z + "<br/>Yaw: " + rot.Yaw;

        coordsOneliner = (MP_SU_OnelinerScreen)MP_SUOL_getManager().findByTag("MPClientCoords");

        if(coordsOneliner) {
            coordsOneliner.text = (new MP_SUOL_TagBuilder in theInput)
            .tag("font")
            .attr("size", "25")
            .attr("color", "#FFFFFF")
            .text(txt);
            coordsOneliner.position = Vector(0.05, 0.45, 0);
            coordsOneliner.visible = true;
            MP_SUOL_getManager().updateOneliner(coordsOneliner);
            return;
        }

        coordsOneliner = new MP_SU_OnelinerScreen in theInput;
        coordsOneliner.text = (new MP_SUOL_TagBuilder in theInput)
        .tag("font")
        .attr("size", "25")
        .attr("color", "#FFFFFF")
        .text(txt);
        coordsOneliner.position = Vector(0.05, 0.45, 0);
        coordsOneliner.visible = true;
        coordsOneliner.tag = "MPClientCoords";

        MP_SUOL_getManager().createOneliner(coordsOneliner);
    }
}

exec function coords()
{
    theGame.r_getMultiplayerClient().GetDevManager().GetDebugCoords().Toggle();
}
