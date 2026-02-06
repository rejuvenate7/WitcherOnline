

function MP_SU_updateCustomMapPins(out flash_array: CScriptedFlashArray, value_storage: CScriptedFlashValueStorage, shown_area: EAreaName) {
  var flash_object: CScriptedFlashObject;
  var custom_pins: array<MP_SU_MapPin>;
  var current_pin: MP_SU_MapPin;
  var region, shown_region: String;
  var journal_area: int;
  var i: int;

  custom_pins = MP_SUMP_getCustomPins();

  region = SUH_getCurrentRegion();
  shown_region = SUH_normalizeRegion(AreaTypeToName(shown_area));
  journal_area = theGame.GetCommonMapManager().GetCurrentJournalArea();

  for (i = 0; i < custom_pins.Size(); i += 1) {
    current_pin = custom_pins[i];

    // the player is not in the right region or right map view, we skip the pin.
    if (SUH_normalizeRegion(AreaTypeToName(current_pin.region)) != shown_region) {
      continue;
    }

    flash_object = value_storage.CreateTempFlashObject("red.game.witcher3.data.StaticMapPinData");
    flash_object.SetMemberFlashString("type", current_pin.type);
    flash_object.SetMemberFlashString("filteredType", current_pin.filtered_type);
    flash_object.SetMemberFlashString("label", current_pin.label);
    flash_object.SetMemberFlashString("description", current_pin.description);
    flash_object.SetMemberFlashNumber("posX", current_pin.position.X);
    flash_object.SetMemberFlashNumber("posY", current_pin.position.Y);
    flash_object.SetMemberFlashNumber("radius", RoundF(current_pin.radius));
    flash_object.SetMemberFlashBool("isQuest", current_pin.is_quest);
    flash_object.SetMemberFlashBool("isFastTravel", current_pin.is_fast_travel);
    flash_object.SetMemberFlashUInt("id", NameToFlashUInt(current_pin.pin_tag));

    //Constants - Should not be modified from these values for our purposes.
    flash_object.SetMemberFlashInt("journalAreaId", journal_area);
    flash_object.SetMemberFlashNumber("rotation", current_pin.rotation);
    flash_object.SetMemberFlashBool("isPlayer", true);
    flash_object.SetMemberFlashBool("isUserPin", false);
    flash_object.SetMemberFlashBool("highlighted", false);
    flash_object.SetMemberFlashBool("tracked", false);
    flash_object.SetMemberFlashBool("hidden", false);
    flash_array.PushBackFlashObject(flash_object);
  }
}

function MP_SU_updateMinimapPins() {
  var minimapModule : CR4HudModuleMinimap2;
  var m_AddMapPin : CScriptedFlashFunction;
  var m_MovePin : CScriptedFlashFunction;
  var flashModule : CScriptedFlashSprite;
  var custom_pins: array<MP_SU_MapPin>;
  var hud : CR4ScriptedHud;
  var pin: MP_SU_MapPin;
  var i: int;
  var manager: MP_SUMP_Manager;

  manager = MP_SUMP_getManager();

  hud = (CR4ScriptedHud)theGame.GetHud();
  if (hud) {
    minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");

    if (minimapModule) {
      flashModule = minimapModule.GetModuleFlash();
      m_AddMapPin = flashModule.GetMemberFlashFunction( "AddMapPin" );
      m_MovePin = flashModule.GetMemberFlashFunction( "MoveMapPin" );

      custom_pins = MP_SUMP_getCustomPins();

      for (i = 0; i < custom_pins.Size(); i += 1) {
        pin = custom_pins[i];

        if (!pin.appears_on_minimap) {
          continue;
        }

        m_AddMapPin.InvokeSelfNineArgs(
          FlashArgInt(50000 + pin.playerId),
          FlashArgString(pin.tag), // tag
          FlashArgString("Companion"), 
          FlashArgNumber(pin.radius), // radius
          FlashArgBool(pin.pointed_by_arrow), // can be pointed by arrows
          FlashArgInt(0), // priority
          FlashArgBool(false), // is quest pin
          FlashArgBool(true), // is user pin
          FlashArgBool(pin.highlighted), // highlighted
        );

        m_MovePin.InvokeSelfFourArgs(
          FlashArgInt(50000 + pin.playerId),
          FlashArgNumber(pin.position.X),
          FlashArgNumber(pin.position.Y),
          FlashArgNumber(pin.radius)
        );

        if(!manager.seenPinIds.Contains(pin.playerId))
        {
          manager.seenPinIds.PushBack(pin.playerId);
        }
      }
    }
  }
}

function MP_SU_moveMinimapPins() {
  var minimapModule : CR4HudModuleMinimap2;
  var m_MovePin : CScriptedFlashFunction;
  var flashModule : CScriptedFlashSprite;
  var custom_pins: array<MP_SU_MapPin>;
  var hud : CR4ScriptedHud;
  var pin: MP_SU_MapPin;
  var i : int;
  var j: int;
  var seenId: int;
  var found: bool;
  var manager: MP_SUMP_Manager;

  manager = MP_SUMP_getManager();

  hud = (CR4ScriptedHud)theGame.GetHud();
  if (hud) {
    minimapModule = (CR4HudModuleMinimap2)hud.GetHudModule("Minimap2Module");

    if (minimapModule) {
      flashModule = minimapModule.GetModuleFlash();
      m_MovePin = flashModule.GetMemberFlashFunction( "MoveMapPin" );

      custom_pins = MP_SUMP_getCustomPins();

      for (i = 0; i < custom_pins.Size(); i += 1) {
        pin = custom_pins[i];

        if (!pin.appears_on_minimap) {
          continue;
        }

        m_MovePin.InvokeSelfFourArgs(
          FlashArgInt(50000 + pin.playerId),
          FlashArgNumber(pin.position.X),
          FlashArgNumber(pin.position.Y),
          FlashArgNumber(pin.radius)
        );
      }
    }
  }

  for (i = manager.seenPinIds.Size() - 1; i >= 0; i -= 1)
  {
    seenId = manager.seenPinIds[i];
    found = false;

    for (j = 0; j < manager.mappins.Size(); j += 1)
    {
      pin = manager.mappins[j];

      if (pin.playerId == seenId)
      {
        found = true;
        break;
      }
    }

    if (!found)
    {
      MP_SU_removeMinimapPin(seenId);
      manager.seenPinIds.Erase(i);
    }
  }
}

function MP_SUMP_addCustomPin(pin: MP_SU_MapPin) {
  var manager: MP_SUMP_Manager;

  manager = MP_SUMP_getManager();
  manager.mappins.PushBack(pin);

  MP_SU_updateMinimapPins();
}

function MP_SUMP_getCustomPins(): array<MP_SU_MapPin> {
  return MP_SUMP_getManager().mappins;
}

function MP_SUMP_getCustomPinByTag(tag : string): MP_SU_MapPin {
  var i : int;
  var thePins : array<MP_SU_MapPin>;

  thePins = MP_SUMP_getManager().mappins;
  for(i = 0; i < thePins.Size(); i+=1)
  {
    if(thePins[i].tag == tag)
    {
      return thePins[i];
    }
  }

  return NULL;
}

function MP_SUMP_updateCustomPinsLabel(tag: string, label: string) {
  var custom_pins: array<MP_SU_MapPin> = MP_SUMP_getManager().mappins;
  var i: int;
  
  for (i = 0; i < custom_pins.Size(); i += 1) {
    if (custom_pins[i].tag == tag) {
      custom_pins[i].label = label;
      return;
    }
  }
  //MP_SUMP_Logger("Unable to update label for map pin: " + tag);
}

function MP_SUMP_Logger(message: string, optional informGUI: bool) {
	//LogChannel('SUMP', message);
	
	if (informGUI) {
		//theGame.GetGuiManager().ShowNotification("SUMP: " + message, 5, true);
	}
}
