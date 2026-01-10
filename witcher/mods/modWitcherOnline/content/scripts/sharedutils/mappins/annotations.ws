@addField(CR4Player)
var MP_sharedutils_mappins: MP_SUMP_Manager;

@addMethod(CR4Player)
function MP_getSharedutilsMappinsManager(): MP_SUMP_Manager {
  if (!this.MP_sharedutils_mappins) {
    MP_SUMP_Logger("SUMP_getManager(), received null, instantiating instance");
    this.MP_sharedutils_mappins = new MP_SUMP_Manager in this;
  }

  return this.MP_sharedutils_mappins;
}


@wrapMethod(CR4MapMenu)
function UpdateUserMapPins( out flashArray : CScriptedFlashArray, indexToUpdate : int ) : void {
  wrappedMethod(flashArray, indexToUpdate);

  if (indexToUpdate <= -1) {
    MP_SU_updateCustomMapPins(flashArray, GetMenuFlashValueStorage(), m_shownArea);
  }
}

@wrapMethod(CR4MapMenu)
function OnStaticMapPinUsed( pinTag : name, areaId : int) {
  if (MP_SUMP_onPinUsed(pinTag, areaId)) {
    return true;
  }

  return wrappedMethod(pinTag, areaId);
}

@wrapMethod(CR4HudModuleMinimap2)
function OnConfigUI() {
  MP_SU_updateMinimapPins();

  return wrappedMethod();
}
