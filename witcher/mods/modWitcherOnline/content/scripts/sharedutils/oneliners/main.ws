function MP_SUOL_getManager(): MP_SUOL_Manager {
  //MP_SUOL_Logger("SUOL_getManager()");
	return theInput.MP_getSharedutilsOnelinersManager();
}

function MP_SUOL_Logger(message: string, optional informGUI: bool) {
	LogChannel('MP_SUOL', message);
	
	if (informGUI) {
		theGame.GetGuiManager().ShowNotification("MP_SUOL: " + message, 5, true);
	}
}