// Witcher Online by rejuvenate
// https://www.nexusmods.com/profile/rejuvenate7
class r_TradeWindow extends CR4HudModuleDialog {
  function DialogueSliderDataPopupResult(value: float, optional isItemReward: bool) {
    var trade_amount : int;
    super.DialogueSliderDataPopupResult(0, false);
    trade_amount = (int)(value);

    LogChannel('amountt', value);
    theGame.r_getMultiplayerClient().setTradeAmount(trade_amount);
  }
  
  function openTradeWindow() {
    var data: r_TradeSliderData;
    data = new r_TradeSliderData in this;
    //data.ScreenPosX = 0.62;
    //data.ScreenPosY = 0.65;
    data.SetMessageTitle( "Asking Price" );
    data.dialogueRef = this;
    data.BlurBackground = false;
    data.minValue = 0;
    data.maxValue = 50000;
    data.currentValue = Clamp(50, 0, 25000);
    theGame.RequestMenu('PopupMenu', data);
  }
  
}

class r_TradeSliderData extends BettingSliderData 
{
  public function GetGFxData(parentFlashValueStorage: CScriptedFlashValueStorage): CScriptedFlashObject 
  {
    var l_flashObject: CScriptedFlashObject;
    l_flashObject = super.GetGFxData(parentFlashValueStorage);
    l_flashObject.SetMemberFlashInt("playerMoney", thePlayer.inv.GetMoney());
    l_flashObject.SetMemberFlashBool("displayMoneyIcon", true);
    return l_flashObject;
  }
  
  public function OnUserFeedback(KeyCode: string): void 
  {
    if (KeyCode=="enter-gamepad_A") 
    {
      LogChannel('amounttt', currentValue);
      dialogueRef.DialogueSliderDataPopupResult(currentValue);
      ClosePopup();
    }
    
  }
  
}

