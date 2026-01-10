@addField(CInputManager) 
var MP_sharedutils_oneliners: MP_SUOL_Manager;

@addMethod(CInputManager)
public function MP_getSharedutilsOnelinersManager(): MP_SUOL_Manager {
  if (!this.MP_sharedutils_oneliners) {
    MP_SUOL_Logger("MP_SUOL_getManager(), received null, instantiating instance");

    this.MP_sharedutils_oneliners = new MP_SUOL_Manager in this;
  }

  return this.MP_sharedutils_oneliners;
}


@addMethod(CInputManager)
public function MP_newSharedutilsOnelinersManager() 
{
    MP_getSharedutilsOnelinersManager().deleteAllOneliners();
    this.MP_sharedutils_oneliners = new MP_SUOL_Manager in this;
}