function MP_SU_removeMinimapPin(id: int) {
  var minimapModule : CR4HudModuleMinimap2;
  var m_DeleteMapPin : CScriptedFlashFunction;
  var flashModule : CScriptedFlashSprite;
  var hud : CR4ScriptedHud;
  var pin: MP_SU_MapPin;
  var i: int;

  hud = (CR4ScriptedHud)theGame.GetHud();
  if (hud) {
    minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");

    if (minimapModule) {
      flashModule = minimapModule.GetModuleFlash();
      m_DeleteMapPin = flashModule.GetMemberFlashFunction( "DeleteMapPin" );

      m_DeleteMapPin.InvokeSelfOneArg(
        FlashArgInt(50000 + id)
      );
    }
  }
}