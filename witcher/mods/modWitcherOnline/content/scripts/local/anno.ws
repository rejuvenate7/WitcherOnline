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

    wo_messagetitle = "Failed to get Player Data!";

    wo_messagebody = "Your game is not communicating with the Witcher Online server.<br/><br/>"
        + "Ensure your game was launched with -net -debugscripts and delete x64.final.redscripts.<br/><br/>"
        + "Follow all steps from the Troubleshooting page of the wiki.<br/>"
        + "https://rejuvenate.gitbook.io/witcheronline/guides/troubleshooting<br/>";
    
    theGame.r_getMultiplayerClient().tutorialPopup(wo_messagetitle, wo_messagebody);
}

@addMethod(CR4Player) 
timer function r_showUsernameAlert(dt : float, id : int)
{
    theGame.r_getMultiplayerClient().showUsernameTaken();
}

@addMethod(CR4Player) 
timer function r_showBannedAlert(dt : float, id : int)
{
    theGame.r_getMultiplayerClient().showBannedMsg();
}

@addMethod(CR4Player) 
timer function r_showNotWhitelistedAlert(dt : float, id : int)
{
    theGame.r_getMultiplayerClient().showNotWhitelisted();
}

@addMethod(CR4Player) 
timer function r_showJoinMessage(dt : float, id : int)
{
    var players : array<r_RemotePlayer>;
    var total : int;
    var regions : int;
    var i : int;
    var myId : string;
    var kaerMorhen : int;
    var whiteOrchard : int;
    var toussaint : int;
    var velen : int;
    var skellige : int;
    var vizima : int;
    var regionString : string;
    var regionName : string;
    var currentRegion : string;

    if(!theGame.r_getMultiplayerClient().getServerReceived())
    {
        return;
    }

    players = theGame.r_getMultiplayerClient().getGlobalPlayers();
    myId = theGame.r_getMultiplayerClient().getId();

    for(i = 0; i < players.Size(); i += 1)
    {
        if(players[i].id == myId)
        {
            continue;
        }

        total += 1;

        regionName = SUH_normalizeRegion(AreaTypeToName(players[i].area));

        if(regionName == "no_mans_land")
        {
            velen += 1;
        }
        else if(regionName == "skellige")
        {
            skellige += 1;
        }
        else if(regionName == "bob")
        {
            toussaint += 1;
        }
        else if(regionName == "prolog_village")
        {
            whiteOrchard += 1;
        }
        else if(regionName == "kaer_morhen")
        {
            kaerMorhen += 1;
        }
        else if(regionName == "wyzima_castle")
        {
            vizima += 1;
        }
    }

    total += 1;

    currentRegion = SUH_normalizeRegion(AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea()));

    if(currentRegion == "no_mans_land")
    {
        velen += 1;
    }
    else if(currentRegion == "skellige")
    {
        skellige += 1;
    }
    else if(currentRegion == "bob")
    {
        toussaint += 1;
    }
    else if(currentRegion == "prolog_village")
    {
        whiteOrchard += 1;
    }
    else if(currentRegion == "kaer_morhen")
    {
        kaerMorhen += 1;
    }
    else if(currentRegion == "wyzima_castle")
    {
        vizima += 1;
    }

    if(velen > 0)
    {
        regions += 1;
    }
    if(skellige > 0)
    {
        regions += 1;
    }
    if(toussaint > 0)
    {
        regions += 1;
    }
    if(whiteOrchard > 0)
    {
        regions += 1;
    }
    if(kaerMorhen > 0)
    {
        regions += 1;
    }
    if(vizima > 0)
    {
        regions += 1;
    }

    if(regions == 1)
    {
        regionString = "region";
    }
    else
    {
        regionString = "regions";
    }
    
    GetWitcherPlayer().DisplayHudMessage("There are " + total + " players online in " + regions + " " + regionString + ".");
}

@addMethod(CR4Player) 
timer function r_showWelcome(dt : float, id : int)
{
    if(theGame.r_getMultiplayerClient().getServerReceived())
    {
        GetWitcherPlayer().DisplayHudMessage("Welcome, " + theGame.r_getMultiplayerClient().getUsername() + "!");
    }
    else
    {
        GetWitcherPlayer().DisplayHudMessage("You are not connected to any Witcher Online server.");
    }
}

@wrapMethod(CR4GuiManager)
function OnEnteredMainMenu()
{
    wrappedMethod();
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
    else if(theGame.r_getMultiplayerClient().getUsernameTaken() && !theGame.r_getMultiplayerClient().getJoinMessage())
    {
        thePlayer.AddTimer('r_showUsernameAlert', 1, false);
        theGame.r_getMultiplayerClient().setAlertedDisconnect();
        theGame.r_getMultiplayerClient().setJoinMessage();
    }
    else if(theGame.r_getMultiplayerClient().getBanned() && !theGame.r_getMultiplayerClient().getJoinMessage())
    {
        thePlayer.AddTimer('r_showBannedAlert', 1, false);
        theGame.r_getMultiplayerClient().setAlertedDisconnect();
        theGame.r_getMultiplayerClient().setJoinMessage();
    }
    else if(theGame.r_getMultiplayerClient().getNotWhitelisted() && !theGame.r_getMultiplayerClient().getJoinMessage())
    {
        thePlayer.AddTimer('r_showNotWhitelistedAlert', 1, false);
        theGame.r_getMultiplayerClient().setAlertedDisconnect();
        theGame.r_getMultiplayerClient().setJoinMessage();
    }
    else if(theGame.r_getMultiplayerClient().getReceived() && !theGame.r_getMultiplayerClient().getJoinMessage() && !theGame.r_getMultiplayerClient().getUsernameTaken() && !theGame.r_getMultiplayerClient().getBanned() && !theGame.r_getMultiplayerClient().getNotWhitelisted())
    {
        thePlayer.AddTimer('r_showWelcome', 1, false);
        thePlayer.AddTimer('r_showJoinMessage', 1.5, false);
        theGame.r_getMultiplayerClient().setJoinMessage();
    }
}

@wrapMethod(CR4Game)
function OnGameLoadInitFinishedSuccess()
{
    wrappedMethod();
    theGame.r_getMultiplayerClient().destroyAll();
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
    var defMgr : CDefinitionsManagerAccessor = theGame.GetDefinitionsManager();
    var itemName : name;
    var emoteId : int;

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
    else if(m_DataObject.wo_isReceivingGwent)
    {
        theGame.r_getMultiplayerClient().acceptGwentRequest();
        ClosePopup();
    }
    else if(m_DataObject.wo_isGwent)
    {
        itemName = m_DataObject.targetInventory.GetItemName(itemId);

        if(itemName == 'wo_timed_gwent')
        {
            theGame.r_getMultiplayerClient().setGwentGameType(GG_Timed);
        }
        else
        {
            theGame.r_getMultiplayerClient().setGwentGameType(GG_Normal);
        }

        theGame.r_getMultiplayerClient().openGwentBetWindow();
        ClosePopup();
    }
    else if(m_DataObject.wo_isEmotes)
    {
        if(m_selectedItemCategory == 0)
        {
            itemName = m_DataObject.targetInventory.GetItemName(itemId);
        }
        else if(m_selectedItemCategory == 1)
        {
            itemName = theGame.r_getMultiplayerClient().getChatInventory().GetItemName(itemId);
        }
        else if(m_selectedItemCategory == 2)
        {
            itemName = theGame.r_getMultiplayerClient().getMorphInventory().GetItemName(itemId);
        }
        
        emoteId = StringToInt(StrReplace(itemName, "wo_emote", "")) - 1;

        if(itemName == 'wo_chat1')
        {
            mpghosts_chat("Hello");
        }
        else if(itemName == 'wo_chat2')
        {
            mpghosts_chat("Bye");
        }
        else if(itemName == 'wo_chat3')
        {
            mpghosts_chat("Follow me");
        }
        else if(itemName == 'wo_chat4')
        {
            mpghosts_chat("Wait here");
        }
        else if(itemName == 'wo_chat5')
        {
            mpghosts_chat("Need a ride?");
        }
        else if(itemName == 'wo_chat6')
        {
            mpghosts_chat("Trade?");
        }
        else if(itemName == 'wo_chat7')
        {
            mpghosts_chat("Thanks");
        }
        else if(itemName == 'wo_chat8')
        {
            mpghosts_chat("Sorry");
        }
        else if(itemName == 'wo_chat9')
        {
            mpghosts_chat("Look here");
        }
        else if(itemName == 'wo_chat10')
        {
            mpghosts_chat("Help!");
        }
        else if(itemName == 'wo_chat11')
        {
            mpghosts_chat("Nice armor");
        }
        else if(itemName == 'wo_chat12')
        {
            mpghosts_chat("Nice sword");
        }
        else if(itemName == 'wo_chat13')
        {
            mpghosts_chat("Nice outfit");
        }
        else if(itemName == 'wo_morph1')
        {
            mpghosts_morph('cat');
        }
        else if(itemName == 'wo_morph2')
        {
            mpghosts_morph('fox');
        }
        else if(itemName == 'wo_morph3')
        {
            mpghosts_morph('owl');
        }
        else if(itemName == 'wo_morph4')
        {
            mpghosts_morph('crow');
        }
        else if(StrBeginsWith(itemName, "wo_emote"))
        {
            mpghosts_emote(emoteId);
        }
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
        theGame.r_getMultiplayerClient().declineTrade(true);
        mpghosts_playSound('gui_enchanting_runeword_remove');
        ClosePopup();
    }
    else if(m_DataObject.wo_isReceivingGwent)
    {
        GetWitcherPlayer().DisplayHudMessage("The Gwent duel was declined.");
        theGame.r_getMultiplayerClient().declineGwentRequest();
        mpghosts_playSound('gui_enchanting_runeword_remove');
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
    
    m_DataObject = (W3ItemSelectionPopupData)GetPopupInitData();

    if(m_DataObject.wo_isTrade || m_DataObject.wo_isReceivingTrade || m_DataObject.wo_isGwent || m_DataObject.wo_isReceivingGwent || m_DataObject.wo_isEmotes)
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
            m_tradeInventory.ignorePosition = true;
            m_tradeInventory.SetFilterType( IFT_None );

            m_fxSetCategory.InvokeSelfOneArg( FlashArgString(m_DataObject.wo_toTrade + " wants to trade for " + m_DataObject.wo_crownsAmount + " crowns") );

            l_flashObject = m_flashValueStorage.CreateTempFlashObject();
            l_flashArray = m_flashValueStorage.CreateTempFlashArray();		
            m_tradeInventory.GetInventoryFlashArray(l_flashArray, l_flashObject);		
            m_flashValueStorage.SetFlashArray( "repair.grid.player", l_flashArray );
        }
        else if(m_DataObject.wo_isGwent)
        {
            m_tradeInventory = new W3GuiSelectItemComponent in theGame.GetGuiManager();
            m_tradeInventory.Initialize( m_DataObject.targetInventory );
            m_tradeInventory.ignorePosition = true;
            m_tradeInventory.SetFilterType( IFT_None );

            m_fxSetCategory.InvokeSelfOneArg( FlashArgString("Gwent: Playing " + m_DataObject.wo_toGwent) );

            l_flashObject = m_flashValueStorage.CreateTempFlashObject();
            l_flashArray = m_flashValueStorage.CreateTempFlashArray();		
            m_tradeInventory.GetInventoryFlashArray(l_flashArray, l_flashObject);		
            m_flashValueStorage.SetFlashArray( "repair.grid.player", l_flashArray );
        }
        else if(m_DataObject.wo_isReceivingGwent)
        {
            m_tradeInventory = new W3GuiSelectItemComponent in theGame.GetGuiManager();
            m_tradeInventory.Initialize( m_DataObject.targetInventory );
            m_tradeInventory.ignorePosition = true;
            m_tradeInventory.SetFilterType( IFT_None );

            m_fxSetCategory.InvokeSelfOneArg( FlashArgString(m_DataObject.wo_toGwent + " wants to play Gwent and bets " + m_DataObject.wo_betAmount + " crowns") );

            l_flashObject = m_flashValueStorage.CreateTempFlashObject();
            l_flashArray = m_flashValueStorage.CreateTempFlashArray();		
            m_tradeInventory.GetInventoryFlashArray(l_flashArray, l_flashObject);		
            m_flashValueStorage.SetFlashArray( "repair.grid.player", l_flashArray );
        }
        else if(m_DataObject.wo_isEmotes)
        {
            m_fxShowCategoryButtons.InvokeSelfOneArg( FlashArgBool(true) );	

            m_tradeInventory = new W3GuiSelectItemComponent in theGame.GetGuiManager();
            m_tradeInventory.Initialize( m_DataObject.targetInventory );
            m_tradeInventory.ignorePosition = true;
            m_tradeInventory.SetFilterType( IFT_None );

            m_fxSetCategory.InvokeSelfOneArg( FlashArgString(GetLocStringById(2111114099)) );

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

@wrapMethod(CR4ItemSelectionPopup)
function OnItemSelected( itemId : SItemUniqueId )
{
    if(m_DataObject.wo_isEmotes)
    {
        if(m_selectedItemCategory == 0)
        {
            m_fxSetItemDescription.InvokeSelfOneArg( FlashArgString( GetLocStringById(2111114076) ) );
        }
        else if(m_selectedItemCategory == 1)
        {
            m_fxSetItemDescription.InvokeSelfOneArg( FlashArgString( GetLocStringById(2111114096)) );
        }
        else if(m_selectedItemCategory == 2)
        {
            m_fxSetItemDescription.InvokeSelfOneArg( FlashArgString( GetLocStringById(2111114095)) );
        }
    }
    else if(m_DataObject.wo_isGwent)
    {
        if(m_DataObject.targetInventory.GetItemName(itemId) == 'wo_timed_gwent')
        {
            m_fxSetItemDescription.InvokeSelfOneArg( FlashArgString( GetLocStringById(2111114074) ) );
        }
        else if(m_DataObject.targetInventory.GetItemName(itemId) == 'wo_notime_gwent')
        {
            m_fxSetItemDescription.InvokeSelfOneArg( FlashArgString( GetLocStringById(2111114075) ) );
        }
    }
    else
    {
        return wrappedMethod(itemId);
    }
}

@wrapMethod(CR4ItemSelectionPopup)
function OnChangeCategory( id : int )
{
    var locString : string;
    var l_flashObject			: CScriptedFlashObject;
    var l_flashArray			: CScriptedFlashArray;

    if(m_DataObject.wo_isEmotes)
    {
        m_selectedItemCategory += id;

        if (m_selectedItemCategory < 0)
            m_selectedItemCategory = 2;
        else if (m_selectedItemCategory > 2)
            m_selectedItemCategory = 0;

        switch(m_selectedItemCategory)
        {
            case 0:
                locString = GetLocStringById(2111114099);
                m_tradeInventory = new W3GuiSelectItemComponent in theGame.GetGuiManager();
                m_tradeInventory.Initialize( m_DataObject.targetInventory );
                m_tradeInventory.ignorePosition = true;
                m_tradeInventory.SetFilterType( IFT_None );
                break;
            case 1:
                locString = GetLocStringById(2111114098);
                m_tradeInventory = new W3GuiSelectItemComponent in theGame.GetGuiManager();
                m_tradeInventory.Initialize( theGame.r_getMultiplayerClient().getChatInventory() );
                m_tradeInventory.ignorePosition = true;
                m_tradeInventory.SetFilterType( IFT_None );
                break;
            case 2:
                locString = GetLocStringById(2111114097);
                m_tradeInventory = new W3GuiSelectItemComponent in theGame.GetGuiManager();
                m_tradeInventory.Initialize( theGame.r_getMultiplayerClient().getMorphInventory() );
                m_tradeInventory.ignorePosition = true;
                m_tradeInventory.SetFilterType( IFT_None );
                break;
        }
        
        m_fxDeselectItem.InvokeSelf();
        m_fxSetCategory.InvokeSelfOneArg( FlashArgString( locString ) );
        
        l_flashObject = m_flashValueStorage.CreateTempFlashObject();
        l_flashArray = m_flashValueStorage.CreateTempFlashArray();		
        m_tradeInventory.GetInventoryFlashArray(l_flashArray, l_flashObject);		
        m_flashValueStorage.SetFlashArray( "repair.grid.player", l_flashArray );

        return true;
    }
    else
    {
        return wrappedMethod(id);
    }
}

@addField(CR4ItemSelectionPopup)
var m_tradeInventory: W3GuiSelectItemComponent;

@addField(W3ItemSelectionPopupData)
var wo_toTrade : string;

@addField(W3ItemSelectionPopupData)
var wo_isTrade : bool;

@addField(W3ItemSelectionPopupData)
var wo_isGwent : bool;

@addField(W3ItemSelectionPopupData)
var wo_isReceivingGwent : bool;

@addField(W3ItemSelectionPopupData)
var wo_toGwent : string;

@addField(W3ItemSelectionPopupData)
var wo_isReceivingTrade : bool;

@addField(W3ItemSelectionPopupData)
var wo_isEmotes : bool;

@addField(W3ItemSelectionPopupData)
var wo_crownsAmount : int;

@addField(W3ItemSelectionPopupData)
var wo_betAmount : int;

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

@addMethod(CInputManager)
function IgnoreGameInput( actionName : name, ignore : bool );

@wrapMethod(CPlayerInput)
function OnCommDrinkPotion1( action : SInputAction )
{
    if(theGame.r_getMultiplayerClient().isMenuOpen() && theInput.LastUsedGamepad())
    {
        if(action.value > 0)
        {
            theGame.r_getMultiplayerClient().updateMenuIndex(false);
        }

        return true;
    }
    else
    {
        return wrappedMethod(action);
    }
}

@wrapMethod(CPlayerInput)
function OnCommDrinkPotion2( action : SInputAction )
{
    if(theGame.r_getMultiplayerClient().isMenuOpen() && theInput.LastUsedGamepad())
    {
        if(action.value > 0)
        {
            theGame.r_getMultiplayerClient().updateMenuIndex(true);
        }

        return true;
    }
    else
    {
        return wrappedMethod(action);
    }
}

@wrapMethod(CExplorationStatePushed)
function StateWantsToEnter() : bool 
{
    if (theGame.r_getMultiplayerClient().emoteCancelledRecently()) 
    {
		return false;
	}

    return wrappedMethod();
}

@wrapMethod(CExplorationStateJump)
function StateWantsToEnter() : bool 
{
    if (theGame.r_getMultiplayerClient().emoteCancelledRecently()) 
    {
		return false;
	}

    return wrappedMethod();
}