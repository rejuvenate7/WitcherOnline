function MP_SUOL_usernameKey(serverPlayerId: int): int {
  return serverPlayerId * 10 + 1;
}

function MP_SUOL_statusKey(serverPlayerId: int): int {
  return serverPlayerId * 10 + 2;
}

function MP_SUOL_dummyKey(serverPlayerId: int): int {
  return serverPlayerId * 10 + 3;
}

class MP_SU_HashMapValueOneliner extends MP_SU_HashMapValue {
  public var value: MP_SU_Oneliner;
}

function hm_fromOneliner(oneliner: MP_SU_Oneliner): MP_SU_HashMapValueOneliner {
  var value: MP_SU_HashMapValueOneliner;

  value = new MP_SU_HashMapValueOneliner in thePlayer;
  value.value = oneliner;

  return value;
}

function hm_getOneliner(map: MP_SU_HashMap, key: int): MP_SU_Oneliner {
  var wrapped: MP_SU_HashMapValueOneliner;

  wrapped = (MP_SU_HashMapValueOneliner)map.get(key);

  if(wrapped) {
    return wrapped.value;
  }

  return NULL;
}
///
statemachine class MP_SUOL_Manager {
  /// an internal counter
  private var oneliner_counter: int;

  /// A list of all the active oneliners
  protected var oneliners: array<MP_SU_Oneliner>;
  private var onelinersByIntTag: MP_SU_HashMap;

  private function ensureIntTagIndex() {
    if(!this.onelinersByIntTag) {
      this.onelinersByIntTag = (new MP_SU_HashMap in this).init();
    }
  }

  private function indexOneliner(oneliner: MP_SU_Oneliner) {
    if(!oneliner || oneliner.intTag <= 0) {
      return;
    }

    this.ensureIntTagIndex();
    this.onelinersByIntTag.insert(oneliner.intTag, hm_fromOneliner(oneliner));
  }

  private function unindexOneliner(oneliner: MP_SU_Oneliner) {
    var existing: MP_SU_Oneliner;

    if(!oneliner || oneliner.intTag <= 0 || !this.onelinersByIntTag) {
      return;
    }

    existing = hm_getOneliner(this.onelinersByIntTag, oneliner.intTag);

    if(existing == oneliner) {
      this.onelinersByIntTag.remove(oneliner.intTag);
    }
  }

  public function findByIntTag(intTag: int): MP_SU_Oneliner {
    this.ensureIntTagIndex();

    if(intTag <= 0) {
      return NULL;
    }

    return hm_getOneliner(this.onelinersByIntTag, intTag);
  }

  public function deleteByIntTag(intTag: int): MP_SU_Oneliner {
    var oneliner: MP_SU_Oneliner;

    oneliner = this.findByIntTag(intTag);

    if(oneliner) {
      this.deleteOneliner(oneliner);
    }

    return oneliner;
  }

  public function deleteRemotePlayerOneliners(serverPlayerId: int) {
    if(serverPlayerId <= 0) {
      return;
    }

    this.deleteByIntTag(MP_SUOL_usernameKey(serverPlayerId));
    this.deleteByIntTag(MP_SUOL_statusKey(serverPlayerId));
    this.deleteByIntTag(MP_SUOL_dummyKey(serverPlayerId));
  }

  //////////////////////////////////////////////////////////////////////////////
  // statemachine workflow code:

  protected var module_oneliners: CR4HudModuleOneliners;
  protected var module_flash: CScriptedFlashSprite;
  protected var module_hud: CR4ScriptedHud;

  private var fxCreateOnelinerSFF: CScriptedFlashFunction;
  private var fxRemoveOnelinerSFF: CScriptedFlashFunction;

  private function initialize() {
    this.module_hud = (CR4ScriptedHud)theGame.GetHud();
    this.module_oneliners = (CR4HudModuleOneliners)(this.module_hud.GetHudModule( "OnelinersModule" ));
    this.module_flash = this.module_oneliners.GetModuleFlash();

		this.fxCreateOnelinerSFF 	= this.module_flash.GetMemberFlashFunction( "CreateOneliner" );
		this.fxRemoveOnelinerSFF 	= this.module_flash.GetMemberFlashFunction( "RemoveOneliner" );
  }

  private function getNewId(): int {
    var id: int = Max(this.oneliner_counter, (int)theGame.GetLocalTimeAsMilliseconds());
	this.oneliner_counter = id + 1;
    return id;
  }

  //////////////////////////////////////////////////////////////////////////////
  // public API:

  public function createOneliner(oneliner: MP_SU_Oneliner) {
    var should_initialize_and_render: bool;
    var existing: MP_SU_Oneliner;

    should_initialize_and_render = this.GetCurrentStateName() != 'MP_Render';

    if(should_initialize_and_render) {
      this.initialize();
    }

    if(oneliner && oneliner.intTag > 0) {
      existing = this.findByIntTag(oneliner.intTag);

      if(existing && existing != oneliner) {
        this.deleteOneliner(existing);
      }
    }

    oneliner.id = this.getNewId();
    this.fxCreateOnelinerSFF.InvokeSelfTwoArgs(
      FlashArgInt(oneliner.id),
      FlashArgString(oneliner.text)
    );
    this.oneliners.PushBack(oneliner);
    this.indexOneliner(oneliner);

    if(should_initialize_and_render) {
      this.GotoState('MP_Render');
    }
  }

  /// Updates the flash values with the oneliner's new/current text
  public function updateOneliner(oneliner: MP_SU_Oneliner) {
    this.module_flash
      .GetChildFlashSprite("mcOneliner" + oneliner.id)
      .GetChildFlashTextField("textField")
      .SetTextHtml(oneliner.text);
  }

  public function deleteOneliner(oneliner: MP_SU_Oneliner) {
    if(!oneliner) {
      return;
    }

    this.unindexOneliner(oneliner);
    this.oneliners.Remove(oneliner);
    this.fxRemoveOnelinerSFF.InvokeSelfOneArg(FlashArgInt(oneliner.id));
  }

  public function findByTagMulti(tag: string): array<MP_SU_Oneliner> {
    var output: array<MP_SU_Oneliner>;
    var i: int;

    for (i = 0; i < this.oneliners.Size(); i += 1) {
      if (this.oneliners[i].tag == tag) {
        output.PushBack(this.oneliners[i]);
      }
    }

    return output;
  }

  public function findByTag(tag: string): MP_SU_Oneliner {
    var output: MP_SU_Oneliner;
    var i: int;

    for (i = 0; i < this.oneliners.Size(); i += 1) {
      if (this.oneliners[i].tag == tag) {
        return this.oneliners[i];
      }
    }

    return output;
  }

  public function findByTagPrefix(tag: string): array<MP_SU_Oneliner> {
    var output: array<MP_SU_Oneliner>;
    var i: int;

    for (i = 0; i < this.oneliners.Size(); i += 1) {
      if (StrStartsWith(this.oneliners[i].tag, tag)) {
        output.PushBack(this.oneliners[i]);
      }
    }

    return output;
  }

  public function deleteByTag(tag: string): array<MP_SU_Oneliner> {
    var output: array<MP_SU_Oneliner>;
    var i: int;

    output = this.findByTagMulti(tag);
    for (i = 0; i < output.Size(); i += 1) {
      this.deleteOneliner(output[i]);
    }

    return output;
  }

  public function deleteByTagPrefix(tag: string): array<MP_SU_Oneliner> {
    var output: array<MP_SU_Oneliner>;
    var i: int;

    output = this.findByTagPrefix(tag);
    for (i = 0; i < output.Size(); i += 1) {
      this.deleteOneliner(output[i]);
    }

    return output;
  }

  public function findByTagBool(tag: string): bool { 
    var i: int; 
    for (i = 0; i < this.oneliners.Size(); i += 1) 
    { 
      if (this.oneliners[i].tag == tag) 
      { 
        return true; 
      } 
    } 
        return false; 
    }

  public function deleteAllOneliners() { 
    while(this.oneliners.Size() > 0) 
    { 
      this.deleteOneliner(this.oneliners[this.oneliners.Size() - 1]); 
    }

    this.onelinersByIntTag = (new MP_SU_HashMap in this).init();
  }
}