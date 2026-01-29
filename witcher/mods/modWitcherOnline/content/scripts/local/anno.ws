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