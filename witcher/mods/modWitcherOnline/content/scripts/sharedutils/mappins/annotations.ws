@addField(CR4Player)
var MP_sharedutils_mappins: MP_SUMP_Manager;

@addMethod(CR4Player)
function MP_getSharedutilsMappinsManager(): MP_SUMP_Manager {
  if (!this.MP_sharedutils_mappins) {
    //MP_SUMP_Logger("SUMP_getManager(), received null, instantiating instance");
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

@wrapMethod(CR4HudModuleMinimap2)
function OnConfigUI() {
  MP_SU_updateMinimapPins();

  return wrappedMethod();
}

@wrapMethod(CR4MapMenu)
function OnStaticMapPinUsed( pinTag : name, areaId : int) {
  if (MP_SUMP_onPinUsed(pinTag, areaId)) {
    return true;
  }

  return wrappedMethod(pinTag, areaId);
}

function MP_SUMP_onPinUsed(pin_tag: name, area_id: int): bool {
  var custom_pins: array<MP_SU_MapPin>;
  var current_pin: MP_SU_MapPin;
  var i: int;

  custom_pins = MP_SUMP_getCustomPins();

  for (i = 0; i < custom_pins.Size(); i += 1) {
    current_pin = custom_pins[i];

    if (current_pin.pin_tag == pin_tag) {
      current_pin.onPinUsed();

      return true;
    }
  }

  return false;
}