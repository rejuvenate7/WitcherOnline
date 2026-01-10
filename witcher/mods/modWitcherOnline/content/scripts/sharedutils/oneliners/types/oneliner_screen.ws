
/// A oneliner that stays at the `position` vector on the screen, `(0.5, 0.5)`
/// would mean in the middle of the screen.
class MP_SU_OnelinerScreen extends MP_SU_Oneliner {
  function getScreenPosition(hud: CR4ScriptedHud, out screen_position: Vector): bool {
    var position: Vector;

    position = this.getPosition();
    screen_position = hud.GetScaleformPoint(position.X, position.Y);

    return true;
  }
}
