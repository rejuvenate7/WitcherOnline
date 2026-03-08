// Witcher Online by rejuvenate
// https://www.nexusmods.com/profile/rejuvenate7
@addField(CR4Game) 
var r_multiplayerClient: r_MultiplayerClient;

@addMethod(CR4Game)
public function r_getMultiplayerClient(): r_MultiplayerClient 
{
    if (!this.r_multiplayerClient) {
        this.r_multiplayerClient = new r_MultiplayerClient in this;
        this.r_multiplayerClient.Init();
    }

    return this.r_multiplayerClient;
}

@wrapMethod(CR4Player)
function OnSpawned(spawnData: SEntitySpawnData) 
{    
    theGame.r_getMultiplayerClient().setInGame(true);
    theGame.r_getMultiplayerClient().setSpawnTime(theGame.GetEngineTimeAsSeconds());
    theGame.r_getMultiplayerClient().startTick();
    
    wrappedMethod(spawnData);
}

@addMethod(CR4Player) 
timer function r_showConnectionAlert(dt : float, id : int)
{
    var wo_messagetitle : string;
    var wo_messagebody  : string;

    wo_messagetitle = "<p align=\"center\">Failed to get Player Data!</p>";

    wo_messagebody =
        "<p align=\"center\">"
        + "Your game is not communicating with the Witcher Online server.<br/><br/>"
        + "Ensure your game was launched with -net -debugscripts and delete x64.final.redscripts.<br/><br/>"
        + "Follow all steps from the Troubleshooting page of the wiki.<br/>"
        + "https://rejuvenate.gitbook.io/witcheronline/guides/troubleshooting<br/><br/>"
        + "Multiple players with the same IP cannot connect to the public server at the same time.<br/>"
        + "If you want to play with two or more players with the same IP, host your own server."
        + "</p>";
    
    theGame.r_getMultiplayerClient().DisplayUserMessage(WitcherOnline_PlayerNotification(wo_messagetitle, wo_messagebody));
}

@wrapMethod(CR4GuiManager)
function OnEnteredMainMenu()
{
    wrappedMethod();
    //LogChannel('WOLVEN TRAINER', "NEW LOAD|main menu");
    theGame.r_getMultiplayerClient().setInGame(false);
}

@wrapMethod(CR4Game)
function OnAfterLoadingScreenGameStart()
{
    wrappedMethod();
    theGame.r_getMultiplayerClient().setInGame(true);
    theGame.r_getMultiplayerClient().setSpawnTime(theGame.GetEngineTimeAsSeconds());
    theGame.r_getMultiplayerClient().setEmote(-1);

    theInput.MP_newSharedutilsOnelinersManager();

    if(!theGame.r_getMultiplayerClient().getReceived())
    {
        thePlayer.AddTimer('r_showConnectionAlert', 1, false);
    }
}

@wrapMethod(CR4Game)
function OnGameLoadInitFinishedSuccess()
{
    wrappedMethod();
    theGame.r_getMultiplayerClient().destroyAll();
    //LogChannel('WOLVEN TRAINER', "NEW LOAD|clear options");
    theGame.r_getMultiplayerClient().setInGame(false);
}

@wrapMethod(CR4Player)
function PlayHitAnimation(damageAction : W3DamageAction, animType : EHitReactionType)
{
    wrappedMethod(damageAction, animType);
    theGame.r_getMultiplayerClient().setLastHit(theGame.GetEngineTimeAsSeconds());
}

@wrapMethod(CR4Player)
function PerformParryCheck( parryInfo : SParryInfo) : bool
{
    var parried : bool;
    parried = wrappedMethod(parryInfo);
    if(parried)
    {
        theGame.r_getMultiplayerClient().setLastParry(theGame.GetEngineTimeAsSeconds());
    }
    return parried;
}

@wrapMethod(CR4Player)
function PerformCounterCheck( parryInfo : SParryInfo) : bool
{
    var parried : bool;
    parried = wrappedMethod(parryInfo);
    if(parried)
    {
        theGame.r_getMultiplayerClient().setLastParry(theGame.GetEngineTimeAsSeconds());
    }
    return parried;
}

@wrapMethod(CR4Player)
function OnFinisherStart()
{
    wrappedMethod();

    if(((CActor)finisherTarget).IsMonster())
    {
        theGame.r_getMultiplayerClient().setFinisherMonster(true);
    }
    else
    {
        theGame.r_getMultiplayerClient().setFinisherMonster(false);
    }

    theGame.r_getMultiplayerClient().setLastFinisher(theGame.GetEngineTimeAsSeconds());
}

@wrapMethod(CR4Player)
function RaiseAttackFriendlyEvent( actor : CActor ) : bool {
    var npc : CNewNPC;
    npc = (CNewNPC)actor;

    if(npc.HasTag('MPEntity'))
    {
        return false;
    }

    return wrappedMethod(actor);
}

@wrapMethod(CR4Player)
function ShouldPerformFriendlyAction( actor : CActor, inputHeading, attackAngle, clearanceMin, clearanceMax : float ) : bool {

    var npc : CNewNPC;
    npc = (CNewNPC)actor;

    if(npc.HasTag('MPEntity'))
    {
        return false;
    }

    return wrappedMethod(actor, inputHeading, attackAngle, clearanceMin, clearanceMax);
}

// cpc
@addMethod(NR_PlayerManager)
function mpghosts_GetHeads() : array< name >
{
    return m_headNames;
}

@wrapMethod(CR4Player)
function PrepareToAttack( optional target : CActor, optional action : EBufferActionType )
{
    wrappedMethod(target, action);

    if(action == EBAT_LightAttack)
    {
        theGame.r_getMultiplayerClient().setLastLightTime(theGame.GetEngineTimeAsSeconds());
    }
    else if(action == EBAT_HeavyAttack)
    {
        theGame.r_getMultiplayerClient().setLastHeavyTime(theGame.GetEngineTimeAsSeconds());
    }
}

@wrapMethod(CExplorationStateManager)
function ChangeStateTo( _NewStateN : name )
{
    if(_NewStateN == 'Jump')
    {
        theGame.r_getMultiplayerClient().setLastJumpTime(theGame.GetEngineTimeAsSeconds());
    }
    wrappedMethod(_NewStateN);
}

@wrapMethod(W3PlayerWitcher)
function EvadePressed( bufferAction : EBufferActionType )
{
    if(bufferAction == EBAT_Dodge)
    {
        theGame.r_getMultiplayerClient().setLastDodgeTime(theGame.GetEngineTimeAsSeconds());
    }
    else if(bufferAction == EBAT_Roll)
    {
        theGame.r_getMultiplayerClient().setLastRollTime(theGame.GetEngineTimeAsSeconds());
    }
    wrappedMethod(bufferAction);
}

@wrapMethod(CPlayerInput)
function OnCastSign( action : SInputAction )
{
    theGame.r_getMultiplayerClient().setLastSignTime(theGame.GetEngineTimeAsSeconds());
    wrappedMethod(action);
}

@wrapMethod(CPlayerInput)
function AltCastSign(signType : ESignType)
{
    theGame.r_getMultiplayerClient().setLastSignTime(theGame.GetEngineTimeAsSeconds());
    wrappedMethod(signType);
}

@wrapMethod(CPlayerInput)
function OnCbtSpecialAttackLight( action : SInputAction )
{
    if ( IsReleased( action )  )
    {
        theGame.r_getMultiplayerClient().setSwirling(false);
    }
    wrappedMethod(action);
    if( IsPressed(action) && thePlayer.CanUseSkill(S_Sword_s01) )	
    {			
        theGame.r_getMultiplayerClient().setSwirling(true);
    }	
}

@wrapMethod(CPlayerInput)
function OnCbtSpecialAttackHeavy( action : SInputAction )
{
    if ( IsReleased( action )  )
    {
        theGame.r_getMultiplayerClient().setRend(false);
    }
    wrappedMethod(action);
    if( IsPressed(action) && thePlayer.CanUseSkill(S_Sword_s02) )	
    {			
        theGame.r_getMultiplayerClient().setRend(true);
    }	
}

@wrapMethod(W3AxiiEntity)
function IsTargetValid(actor : CActor, isAdditionalTarget : bool) : bool
{
    if(actor.HasTag('MPEntity'))
    {
        return false;
    }

    return wrappedMethod(actor, isAdditionalTarget);
}

@wrapMethod(CR4Player)
function PlayerStartAction( playerAction : EPlayerExplorationAction, optional animName : name ) : bool
{
    var val : bool;
    val = wrappedMethod(playerAction, animName);

    if(val)
    {
        theGame.r_getMultiplayerClient().setLastAction(playerAction);
        theGame.r_getMultiplayerClient().setLastActionTime(theGame.GetEngineTimeAsSeconds());
    }

    return val;
}

@wrapMethod(CR4ItemSelectionPopup)
function OnCallSelectItem(itemId : SItemUniqueId)
{
    if(m_DataObject.wo_isTrade)
    {
        theGame.r_getMultiplayerClient().tradeSelectItem(itemId);
        ClosePopup();
    }
    else if(m_DataObject.wo_isReceivingTrade)
    {
        theGame.r_getMultiplayerClient().acceptTrade();
        ClosePopup();
    }
    else
    {
        wrappedMethod(itemId);
    }
}

@wrapMethod(CR4ItemSelectionPopup)
function OnCloseSelectionPopup()
{
    if(m_DataObject.wo_isReceivingTrade)
    {
        GetWitcherPlayer().DisplayHudMessage("The trade was declined.");
        theGame.r_getMultiplayerClient().declineTrade();
        theSound.SoundEvent('gui_global_highlight');
        ClosePopup();
    }
    else
    {
        wrappedMethod();
    }
}

@wrapMethod(CR4ItemSelectionPopup)
function OnConfigUI()
{
    var l_flashObject			: CScriptedFlashObject;
	var l_flashArray			: CScriptedFlashArray;
    var m_tradeInventory: W3GuiSelectItemComponent;

    m_DataObject = (W3ItemSelectionPopupData)GetPopupInitData();

    if(m_DataObject.wo_isTrade || m_DataObject.wo_isReceivingTrade)
    {
        super.OnConfigUI();
		
		theInput.StoreContext( 'EMPTY_CONTEXT' );
		
		if (!m_DataObject)
		{
			ClosePopup();
		}
		
		if (theInput.LastUsedPCInput())
		{
			theGame.MoveMouseTo(0.5, 0.5);
		}
		
		m_fxSetItemDescription = GetPopupFlash().GetMemberFlashFunction( "setItemDescription" );
		m_fxSetCategory = GetPopupFlash().GetMemberFlashFunction( "setCategory" );
		m_fxShowCategoryButtons = GetPopupFlash().GetMemberFlashFunction( "showCategoryButtons" );
		m_fxDeselectItem = GetPopupFlash().GetMemberFlashFunction( "deselectItem" );

        m_fxShowCategoryButtons.InvokeSelfOneArg( FlashArgBool(false) );		
        
        m_playerInv = new W3GuiSelectItemComponent in this;
        m_playerInv.Initialize( thePlayer.GetInventory() );
        m_playerInv.filterTagList = m_DataObject.filterTagsList;
        m_playerInv.filterForbiddenTagList = m_DataObject.filterForbiddenTagsList;
        m_playerInv.ignorePosition = true; 
        m_playerInv.checkTagsOR = m_DataObject.checkTagsOR; 

        m_playerInv.SetFilterType( IFT_None );	

        m_containerOwner = (CGameplayEntity)theGame.GetEntityByTag( m_DataObject.collectorTag );
		
		UpdateData();
		
		m_guiManager.RequestMouseCursor(true);
		theGame.ForceUIAnalog(true);

        if(m_DataObject.wo_isTrade)
        {
            m_fxSetCategory.InvokeSelfOneArg( FlashArgString("Trading with " +m_DataObject.wo_toTrade) );
        }
        else if(m_DataObject.wo_isReceivingTrade)
        {
            m_tradeInventory = new W3GuiSelectItemComponent in theGame.GetGuiManager();
            m_tradeInventory.Initialize( m_DataObject.targetInventory );
            //m_tradeInventory.filterTagList = tagsP;
            //m_tradeInventory.filterForbiddenTagList = forbiddenTagsPotion;
            m_tradeInventory.ignorePosition = true;
            m_tradeInventory.SetFilterType( IFT_None );

            m_fxSetCategory.InvokeSelfOneArg( FlashArgString(m_DataObject.wo_toTrade + " wants to trade for " + m_DataObject.wo_crownsAmount + " crowns") );

            l_flashObject = m_flashValueStorage.CreateTempFlashObject();
            l_flashArray = m_flashValueStorage.CreateTempFlashArray();		
            m_tradeInventory.GetInventoryFlashArray(l_flashArray, l_flashObject);		
            m_flashValueStorage.SetFlashArray( "repair.grid.player", l_flashArray );
        }
    }
    else
    {
        return wrappedMethod();
    }
}

@addField(W3ItemSelectionPopupData)
var wo_toTrade : string;

@addField(W3ItemSelectionPopupData)
var wo_isTrade : bool;

@addField(W3ItemSelectionPopupData)
var wo_isReceivingTrade : bool;

@addField(W3ItemSelectionPopupData)
var wo_crownsAmount : int;

exec function test()
{
    var cat : array<name>;
    var m_popupData : W3ItemSelectionPopupData;

    m_popupData = new W3ItemSelectionPopupData in theGame.GetGuiManager();
    m_popupData.targetInventory = thePlayer.GetInventory();
    m_popupData.overrideQuestItemRestrictions = true;

    // pages
    //m_popupData.selectionMode = EISPM_RadialMenuSlot1;
    m_popupData.selectionMode = EISPM_RadialMenuSilverOil;
    m_popupData.wo_isTrade = true;
    m_popupData.wo_toTrade = "Rejuvenate";
    
    //cat.PushBack('potion');
    //cat.PushBack('edibles');
    //m_popupData.categoryFilterList = cat;
    
    theGame.RequestPopup('ItemSelectionPopup', m_popupData);
    
    //ToggleRadialMenuInput(false);
    //radialPopupShown = true;
}

exec function test2() 
{

}

exec function test3() {
  var tut: W3TutorialPopupData;

  tut = new W3TutorialPopupData in thePlayer;

  tut.managerRef = theGame.GetTutorialSystem();
  tut.messageTitle = "Test";
  tut.messageText = "TestBody";

  // You can even add images if you want, i didn't test it however
  // tut.imagePath = tutorialEntry.GetImagePath();

  tut.enableGlossoryLink = false;
  tut.autosize = true;
  tut.blockInput = true;
  tut.pauseGame = true;
  tut.fullscreen = true;
  tut.canBeShownInMenus = true;

  tut.duration = -1; // input
  tut.posX = 0;
  tut.posY = 0;
  tut.enableAcceptButton = true;
  tut.fullscreen = true;

  theGame.GetTutorialSystem().ShowTutorialHint(tut);
}

exec function test4()
{
    var cat : array<name>;
    var m_popupData : W3ItemSelectionPopupData;
    var inventory : CInventoryComponent;
    
    //inventory = player.ghost.GetInventory();
    inventory = new CInventoryComponent in thePlayer;
    inventory.AddAnItem('Aerondight EP2', 1);

    m_popupData = new W3ItemSelectionPopupData in theGame.GetGuiManager();
    m_popupData.targetInventory = inventory;
    m_popupData.overrideQuestItemRestrictions = true;

    // pages
    //m_popupData.selectionMode = EISPM_RadialMenuSlot1;
    m_popupData.selectionMode = EISPM_RadialMenuSilverOil;
    m_popupData.wo_isReceivingTrade = true;
    m_popupData.wo_toTrade = "Rejuvenate";
    m_popupData.wo_crownsAmount = 10413;
    
    //cat.PushBack('potion');
    //cat.PushBack('edibles');
    //m_popupData.categoryFilterList = cat;
    
    theGame.RequestPopup('ItemSelectionPopup', m_popupData);
    
    //ToggleRadialMenuInput(false);
    //radialPopupShown = true;
}

exec function openMenu()
{
    //theGame.r_getMultiplayerClient().menuSelectedPlayer = mpghosts_getPlayer("rejuvenate");
    //theGame.r_getMultiplayerClient().createMenu(mpghosts_getPlayer("rejuvenate"));
}

@wrapMethod(CPlayerInput)
function OnToggleSigns( action : SInputAction )
{
    var tolerance : float;
	tolerance = 2.5f;

    wrappedMethod(action);
    
    if(theGame.r_getMultiplayerClient().isMenuOpen())
    {
        if( action.value < -tolerance )
        {
            theGame.r_getMultiplayerClient().updateMenuIndex(true);
        }
        else if( action.value > tolerance )
        {
            theGame.r_getMultiplayerClient().updateMenuIndex(false);
        }
    }
}

@wrapMethod(CExplorationStateManager) 
function UpdateCameraIfNeeded( out moveData : SCameraMovementData, dt : float ) : bool
{
	if ( (theGame.r_getMultiplayerClient().isRiding()))
	{
		return theGame.r_getMultiplayerClient().updateCamera(moveData,dt);
	}
	else
	{
		return wrappedMethod(moveData, dt);
	}
}