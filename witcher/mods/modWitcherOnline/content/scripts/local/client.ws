// Witcher Online by rejuvenate
// https://www.nexusmods.com/profile/rejuvenate7
struct r_ChillDef 
{ 
    var anim : name; 
    var dur : float;
}

struct r_NameColor
{
    var playerName : string;
    var color : string;
}

struct r_RemoteMenuItem
{
    var label  : string;
    var action : string;
}

struct r_RiderHorseAnchor
{
    var rider  : CActor;
    var target : CActor;
    var anchor : CEntity;
}

enum E_GwentRequest
{
    E_None,
	E_RequestTimed,
	E_RequestNormal,
	E_Accept,	
	E_Decline,
    E_Ack
}

enum E_GwentGameType
{
    GG_None,
	GG_Timed,
    GG_Normal
}

struct wo_SSceneChoice
{
	var emphasised : bool;
	var previouslyChoosen : bool;
	var disabled : bool;
	var dialogAction : EDialogActionIcon;
	var playGoChunk : string;
}

statemachine class r_MultiplayerClient
{
    private var chillDefs : array<r_ChillDef>;
    private var id, username : string;
    private var serverPlayerId : int;
    public var multiplayerLocalName : string;
    public var multiplayerOpponentName : string;
    private var players : array<r_RemotePlayer>;
    private var globalPlayers : array<r_RemotePlayer>;
    private var playersByServerId : MP_SU_HashMap;
    private var globalPlayersByServerId : MP_SU_HashMap;
    private var inGame : bool;
    private var spawnTime : float;
    private var execReceived : bool;
    private var serverReceived : bool;

    private var lightAttackAnims : array<r_Anim>;
    private var heavyAttackAnims : array<r_Anim>;
    private var lightFistAnims : array<r_Anim>;
    private var heavyFistAnims : array<r_Anim>;
    private var fistBackDodgeAnims : array<r_Anim>;
    private var fistForwardDodgeAnims : array<r_Anim>;
    private var fistLeftDodgeAnims : array<r_Anim>;
    private var fistRightDodgeAnims : array<r_Anim>;
    private var swordBackDodgeAnims : array<r_Anim>;
    private var swordForwardDodgeAnims : array<r_Anim>;
    private var swordLeftDodgeAnims : array<r_Anim>;
    private var swordRightDodgeAnims : array<r_Anim>;
    private var swordRollAnims : array<r_Anim>;
    private var swordIdleAnims : array<r_Anim>;
    private var swordParryAnims : array<r_Anim>;
    private var fistParryAnims : array<r_Anim>;
    private var finisherAnims : array<r_Anim>;

    private var swordHitAnims : array<r_Anim>;
    private var fistHitAnims : array<r_Anim>;

    private var lastTimeGotHit : float;
    private var lastTimeParry : float;
    private var lastTimeFinisher : float;
    private var isFinisherMonster : bool;
    private var lastHeavyTime : float;
    private var lastLightTime : float;
    private var lastJumpTime : float;
    private var lastRollTime : float;
    private var lastDodgeTime : float;
    private var lastSignTime : float;
    private var lastActionTime : float;
    private var lastAction : EPlayerExplorationAction;

    private var swirling : bool;
    private var rend : bool;

    private var lastEmote : int;
    private var lastEmoteTime : float;

    private var localEmoteAnim  : name;
    private var localEmoteForce : bool;
    private var localEmoteLoop  : bool;
    private var localEmoteRestartAt : float;

    private var lastChat : string;
    private var lastChatTime : float;
    private var prevChatTime : float;
    private var nameColors : array<r_NameColor>;

    private var maleTemp : CEntityTemplate;
    private var femaleTemp : CEntityTemplate;

    protected var ridingEnabled : bool;
    protected var ridingPlayer : r_RemotePlayer;

    private var tradeInProgress : bool;
    private var tradeLastCompleted : float;
    default tradeLastCompleted = -999;
    private var outgoingTradeTo : r_RemotePlayer;
    private var outgoingTradeItem : name;
    private var outgoingTradePrice : int;
    private var outgoingTradeFlag : int;
    default outgoingTradeFlag = -1;

    private var resetFlagPending : bool;
    private var resetFlagAt : float;
    default resetFlagPending = false;
    default resetFlagAt = -999;

    private var joinMessage : bool;

    private var nextPlayerNum : int;
    default nextPlayerNum = 1000;

    private var riderHorseAnchors : array<r_RiderHorseAnchor>;

    // gwent request
    private var outgoingGwentTo : string;
    private var outgoingGwentRequest : E_GwentRequest;
    default outgoingGwentRequest = E_None;
    private var shownGwentRequestWindow : bool;
    private var outgoingGwentBet : int;
    private var outgoingGwentSeed : int;
    private var requestedGwentGameType : E_GwentGameType;
    default requestedGwentGameType = GG_None;

    protected var inGwentGame : bool;
    private var gwentOpponent : r_RemotePlayer;

    private var gwentLastCompleted : float;
    default gwentLastCompleted = -999;

    private var resetGwentFlagPending : bool;
    default resetGwentFlagPending = false;

    private var resetGwentFlagAt : float;
    default resetGwentFlagAt = -999;

    private var lastGwentAction : string;
    private var lastGwentActionTime  : float;
    private var gwentActionBuffer : array<string>;
    private var lastGwentActionWasQuit : bool;

    private var activeGwentBet : int;
    private var activeGwentSeed : int;

    // party
    private var inParty : bool;
    private var joinedParty : string;
    private var nextWeatherSyncAt : float;
    default nextWeatherSyncAt = -999;

    private var dialogChoices : array<SSceneChoice>;
    private var dialogChoicesActive : bool;
    private var lastSelectedDialogIndex : int;
    private var lastSelectedDialogCount : int;

    private var applyingSyncedDialogChoice : bool;

    private var pendingSyncedDialogChoice : bool;
    private var pendingSyncedDialogIndex : int;
    private var pendingSyncedDialogCount : int;
    private var pendingSyncedDialogAcceptAt : float;

    private var currentDialogChoiceSetId : int;
    private var lastSelectedDialogChoiceSetId : int;
    private var lastSelectedDialogValid : bool;

    default lastSelectedDialogIndex = -1;
    default lastSelectedDialogChoiceSetId = -1;
    default lastSelectedDialogValid = false;

    private var lastSelectedDialogChoices : array<SSceneChoice>;
    private var lastSelectedDialogAt : float;
    default lastSelectedDialogAt = -999;

    private var joinedPartyAt : float;
    private var nextPartyFollowTeleportAt : float;

    default joinedPartyAt = -999;
    default nextPartyFollowTeleportAt = -999;

    private var partyTargetMissingSince : float;
    private var partyTargetWasMissing : bool;
    private var partyTargetLastSeenAt : float;
    private var partyTargetLastKnownArea : EAreaName;
    private var partyTargetLastKnownPos : Vector;

    default partyTargetMissingSince = -1;
    default partyTargetWasMissing = false;
    default partyTargetLastSeenAt = -999;

    private var leaderDialogReadyText : string;
    private var leaderDialogAllReadyShown : bool;
    private var leaderDialogAllReadyClearAt : float;

    default leaderDialogReadyText = "";
    default leaderDialogAllReadyShown = false;
    default leaderDialogAllReadyClearAt = -999;

    private var seenPartyPlayers : array<string>;
    private var lastHideCompanion : bool;
    default lastHideCompanion = true;

    public function getPlayerMap() : MP_SU_HashMap
    {
        return playersByServerId;
    }

    public function getPartyMembers() : array<r_RemotePlayer>
    {
        var i : int;
        var j : int;
        var ret : array<r_RemotePlayer>;
        var partyLeader : string;
        var sortedNames : array<string>;

        ret.Clear();
        sortedNames.Clear();

        if(inParty)
        {
            partyLeader = joinedParty;
        }
        else
        {
            partyLeader = username;
        }

        if(partyLeader == "" || partyLeader == "none")
        {
            return ret;
        }

        for(i = 0; i < globalPlayers.Size(); i += 1)
        {
            if(!globalPlayers[i])
            {
                continue;
            }

            if(globalPlayers[i].username == username || globalPlayers[i].id == id)
            {
                continue;
            }

            if(globalPlayers[i].username == partyLeader)
            {
                ret.PushBack(globalPlayers[i]);
                break;
            }
        }

        for(i = 0; i < globalPlayers.Size(); i += 1)
        {
            if(!globalPlayers[i])
            {
                continue;
            }

            if(globalPlayers[i].username == username || globalPlayers[i].id == id)
            {
                continue;
            }

            if(globalPlayers[i].username == partyLeader)
            {
                continue;
            }

            if(globalPlayers[i].inParty && globalPlayers[i].joinedParty == partyLeader)
            {
                sortedNames.PushBack(globalPlayers[i].username);
            }
        }

        ArraySortStrings(sortedNames);

        for(i = 0; i < sortedNames.Size(); i += 1)
        {
            for(j = 0; j < globalPlayers.Size(); j += 1)
            {
                if(!globalPlayers[j])
                {
                    continue;
                }

                if(globalPlayers[j].username == sortedNames[i])
                {
                    ret.PushBack(globalPlayers[j]);
                    break;
                }
            }
        }

        return ret;
    }

    private var lastCompanionUpdateAt : float;

    public function updateCompanionIcons()
    {
        var party : array<r_RemotePlayer>;
        var now : float;

        if(!thePlayer)
        {
            return;
        }

        now = theGame.GetEngineTimeAsSeconds();

        if(now < lastCompanionUpdateAt)
        {
            lastCompanionUpdateAt = 0.0f;
        }

        if((now - lastCompanionUpdateAt) < 0.25f)
        {
            return;
        }

        lastCompanionUpdateAt = now;

        party = getPartyMembers();

        if(((now - theGame.r_getMultiplayerClient().getSpawnTime()) > 1.5) && party.Size() > 0 && !theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HidePartyHUD'))
        {
            showCompanionIcons(party);
            lastHideCompanion = false;
        }
        else
        {
            if(!lastHideCompanion)
            {
                hideCompanionIcons();
                lastHideCompanion = true;
            }
        }
    }

    public function showCompanionIcons(party : array<r_RemotePlayer>)
    {
        var hud : CR4ScriptedHud;
        var module : CR4HudModuleCompanion;

        hud = (CR4ScriptedHud)theGame.GetHud();

        if(!hud)
        {
            return;
        }

        module = (CR4HudModuleCompanion)hud.GetHudModule("CompanionModule");

        if(!module)
        {
            return;
        }

        module.WO_RefreshCompanionHud(party);
    }

    public function hideCompanionIcons()
    {
        var hud : CR4ScriptedHud;
        var module : CR4HudModuleCompanion;

        hud = (CR4ScriptedHud)theGame.GetHud();

        if(!hud)
        {
            return;
        }

        module = (CR4HudModuleCompanion)hud.GetHudModule("CompanionModule");

        if(!module)
        {
            return;
        }

        module.WO_HideCompanionHud();

        lastHideCompanion = true;
    }

    public function colorToId(val : name) : int
    {
        if (val == 'Dye Default')
            return 1;
        if (val == 'Dye Black')
            return 2;
        if (val == 'Dye Blue')
            return 3;
        if (val == 'Dye Brown')
            return 4;
        if (val == 'Dye Gray')
            return 5;
        if (val == 'Dye Green')
            return 6;
        if (val == 'Dye Orange')
            return 7;
        if (val == 'Dye Pink')
            return 8;
        if (val == 'Dye Purple')
            return 9;
        if (val == 'Dye Red')
            return 10;
        if (val == 'Dye Turquoise')
            return 11;
        if (val == 'Dye White')
            return 12;
        if (val == 'Dye Yellow')
            return 13;

        return 0;
    }

    public function clearDialogPickAlert()
    {
        var hud : CR4ScriptedHud;
        var module : CR4HudModuleDialog;

        hud = (CR4ScriptedHud)theGame.GetHud();

        if(!hud)
        {
            return;
        }

        module = (CR4HudModuleDialog)hud.GetHudModule("DialogModule");

        if(!module)
        {
            return;
        }

        module.WO_ClearDialogAssistText();
    }

    public function updateLeaderDialogReadyPopup()
    {
        var i : int;
        var total : int;
        var ready : int;
        var text : string;
        var waitingName : string;
        var remotePlayer : r_RemotePlayer;
        var now : float;
        var allPlayersInRange : bool;

        now = theGame.GetEngineTimeAsSeconds();

        if(inParty)
        {
            return;
        }

        if(!hasActiveDialogChoices())
        {
            if(leaderDialogReadyText != "")
            {
                clearDialogPickAlert();
            }

            leaderDialogReadyText = "";
            leaderDialogAllReadyShown = false;
            leaderDialogAllReadyClearAt = -999;
            return;
        }

        total = 0;
        ready = 0;
        waitingName = "";
        allPlayersInRange = true;

        for(i = 0; i < globalPlayers.Size(); i += 1)
        {
            if(globalPlayers[i] && globalPlayers[i].inParty && globalPlayers[i].joinedParty == username)
            {
                total += 1;

                remotePlayer = hm_getRemotePlayer(playersByServerId, globalPlayers[i].serverPlayerId);

                if(!isRemotePlayerCloseForDialogSync(remotePlayer))
                {
                    allPlayersInRange = false;
                    break;
                }

                if(isFollowerCaughtUpToLeaderDialog(remotePlayer))
                {
                    ready += 1;
                }
                else if(waitingName == "")
                {
                    waitingName = globalPlayers[i].username;
                }
            }
        }

        if(!allPlayersInRange)
        {
            if(leaderDialogReadyText != "")
            {
                clearDialogPickAlert();
            }

            leaderDialogReadyText = "";
            leaderDialogAllReadyShown = false;
            leaderDialogAllReadyClearAt = -999;

            return;
        }

        if(total <= 0)
        {
            if(leaderDialogReadyText != "")
            {
                clearDialogPickAlert();
            }

            leaderDialogReadyText = "";
            leaderDialogAllReadyShown = false;
            leaderDialogAllReadyClearAt = -999;
            return;
        }

        if(ready < total)
        {
            leaderDialogAllReadyShown = false;
            leaderDialogAllReadyClearAt = -999;

            text = "(" + IntToString(ready+1) + "/" + IntToString(total+1) + ") " + GetLocStringById(2111114103);

            if(leaderDialogReadyText != text)
            {
                leaderDialogReadyText = text;
                showDialogPickAlert(text, false);
            }

            return;
        }

        if(!leaderDialogAllReadyShown)
        {
            leaderDialogAllReadyShown = true;
            leaderDialogAllReadyClearAt = now + 2.0;

            leaderDialogReadyText = "(" + IntToString(ready+1) + "/" + IntToString(total+1) + ") " + GetLocStringById(2111114104);
            showDialogPickAlert(leaderDialogReadyText, true);

            return;
        }

        if(leaderDialogAllReadyClearAt > 0 && now >= leaderDialogAllReadyClearAt)
        {
            clearDialogPickAlert();

            leaderDialogReadyText = "";
            leaderDialogAllReadyClearAt = -999;
        }
    }

    private function isFollowerCaughtUpToLeaderDialog(remotePlayer : r_RemotePlayer) : bool
    {
        if(!remotePlayer)
        {
            return false;
        }

        if(remotePlayer.menuName != "InCutscene")
        {
            return false;
        }

        if(!remotePlayer.dialogChoicesActive)
        {
            return false;
        }

        if(remotePlayer.dialogChoices.Size() <= 0)
        {
            return false;
        }

        return dialogChoicesMatch(dialogChoices, remotePlayer.dialogChoices);
    }

    public function setDialogChoices(val : array<SSceneChoice>)
    {
        dialogChoices = val;
        dialogChoicesActive = val.Size() > 0;

        currentDialogChoiceSetId += 1;

        if(dialogChoicesActive)
        {
            lastSelectedDialogValid = false;
            lastSelectedDialogIndex = -1;

            leaderDialogReadyText = "";
            leaderDialogAllReadyShown = false;
            leaderDialogAllReadyClearAt = -999;
        }
    }

    public function showDialogPickAlert(text : string, emphasise : bool)
    {
        var hud : CR4ScriptedHud;
        var module : CR4HudModuleDialog;

        hud = (CR4ScriptedHud)theGame.GetHud();

        if(!hud)
        {
            return;
        }

        module = (CR4HudModuleDialog)hud.GetHudModule("DialogModule");

        if(!module)
        {
            return;
        }

        module.WO_ShowDialogAssistText(text, emphasise);
    }

    public function clearActiveDialogChoices()
    {
        dialogChoicesActive = false;
    }

    public function hasActiveDialogChoices() : bool
    {
        return dialogChoicesActive && dialogChoices.Size() > 0 && !NR_IsSceneInPreviewState();
    }

    public function getDialogChoices() : array<SSceneChoice>
    {
        return dialogChoices;
    }

    public function setLastDialog(index : int)
    {
        var i : int;

        if(index < 0 || index >= dialogChoices.Size())
        {
            return;
        }

        if(dialogChoices[index].disabled)
        {
            return;
        }

        lastSelectedDialogIndex = index;
        lastSelectedDialogCount = lastSelectedDialogCount + 1;
        lastSelectedDialogChoiceSetId = currentDialogChoiceSetId;
        lastSelectedDialogValid = true;
        lastSelectedDialogAt = theGame.GetEngineTimeAsSeconds();

        lastSelectedDialogChoices.Clear();

        for(i = 0; i < dialogChoices.Size(); i += 1)
        {
            lastSelectedDialogChoices.PushBack(dialogChoices[i]);
        }
    }

    public function getLastDialogIndex() : int
    {
        if(lastSelectedDialogCount <= 0)
        {
            return -1;
        }

        if(!lastSelectedDialogValid)
        {
            return -1;
        }

        return lastSelectedDialogIndex;
    }

    public function getLastSelectedDialogChoices() : array<SSceneChoice>
    {
        return lastSelectedDialogChoices;
    }

    public function getLastDialogCount() : int
    {
        return lastSelectedDialogCount;
    }

    public function isApplyingSyncedDialogChoice() : bool
    {
        return applyingSyncedDialogChoice;
    }

    public function dialogActionToInt(action : EDialogActionIcon) : int
    {
        if(action == DialogAction_NONE)              return 0;
        if(action == DialogAction_AXII)              return 1;
        if(action == DialogAction_CONTENT_MISSING)   return 2;
        if(action == DialogAction_BRIBE)             return 3;
        if(action == DialogAction_HOUSE)             return 4;
        if(action == DialogAction_PERSUASION)        return 5;
        if(action == DialogAction_GETBACK)           return 6;
        if(action == DialogAction_GAME_DICES)        return 7;
        if(action == DialogAction_GAME_FIGHT)        return 8;
        if(action == DialogAction_GAME_WRESTLE)      return 9;
        if(action == DialogAction_CRAFTING)          return 10;
        if(action == DialogAction_SHOPPING)          return 11;
        if(action == DialogAction_EXIT)              return 12;
        if(action == DialogAction_HAIRCUT)           return 13;
        if(action == DialogAction_MONSTERCONTRACT)   return 14;
        if(action == DialogAction_BET)               return 15;
        if(action == DialogAction_STORAGE)           return 16;
        if(action == DialogAction_GIFT)              return 17;
        if(action == DialogAction_GAME_DRINK)        return 18;
        if(action == DialogAction_GAME_DAGGER)       return 19;
        if(action == DialogAction_SMITH)             return 20;
        if(action == DialogAction_ARMORER)           return 21;
        if(action == DialogAction_RUNESMITH)         return 22;
        if(action == DialogAction_TEACHER)           return 23;
        if(action == DialogAction_FAST_TRAVEL)       return 24;
        if(action == DialogAction_GAME_CARDS)        return 25;
        if(action == DialogAction_SHAVING)           return 26;
        if(action == DialogAction_AUCTION)           return 27;

        return 0;
    }

    public function stringToDialogAction(val : string) : EDialogActionIcon
    {
        if(val == "DialogAction_NONE" || val == "0")               return DialogAction_NONE;
        if(val == "DialogAction_AXII" || val == "1")               return DialogAction_AXII;
        if(val == "DialogAction_CONTENT_MISSING" || val == "2")    return DialogAction_CONTENT_MISSING;
        if(val == "DialogAction_BRIBE" || val == "3")              return DialogAction_BRIBE;
        if(val == "DialogAction_HOUSE" || val == "4")              return DialogAction_HOUSE;
        if(val == "DialogAction_PERSUASION" || val == "5")         return DialogAction_PERSUASION;
        if(val == "DialogAction_GETBACK" || val == "6")            return DialogAction_GETBACK;
        if(val == "DialogAction_GAME_DICES" || val == "7")         return DialogAction_GAME_DICES;
        if(val == "DialogAction_GAME_FIGHT" || val == "8")         return DialogAction_GAME_FIGHT;
        if(val == "DialogAction_GAME_WRESTLE" || val == "9")       return DialogAction_GAME_WRESTLE;
        if(val == "DialogAction_CRAFTING" || val == "10")          return DialogAction_CRAFTING;
        if(val == "DialogAction_SHOPPING" || val == "11")          return DialogAction_SHOPPING;
        if(val == "DialogAction_EXIT" || val == "12")              return DialogAction_EXIT;
        if(val == "DialogAction_HAIRCUT" || val == "13")           return DialogAction_HAIRCUT;
        if(val == "DialogAction_MONSTERCONTRACT" || val == "14")   return DialogAction_MONSTERCONTRACT;
        if(val == "DialogAction_BET" || val == "15")               return DialogAction_BET;
        if(val == "DialogAction_STORAGE" || val == "16")           return DialogAction_STORAGE;
        if(val == "DialogAction_GIFT" || val == "17")              return DialogAction_GIFT;
        if(val == "DialogAction_GAME_DRINK" || val == "18")        return DialogAction_GAME_DRINK;
        if(val == "DialogAction_GAME_DAGGER" || val == "19")       return DialogAction_GAME_DAGGER;
        if(val == "DialogAction_SMITH" || val == "20")             return DialogAction_SMITH;
        if(val == "DialogAction_ARMORER" || val == "21")           return DialogAction_ARMORER;
        if(val == "DialogAction_RUNESMITH" || val == "22")         return DialogAction_RUNESMITH;
        if(val == "DialogAction_TEACHER" || val == "23")           return DialogAction_TEACHER;
        if(val == "DialogAction_FAST_TRAVEL" || val == "24")       return DialogAction_FAST_TRAVEL;
        if(val == "DialogAction_GAME_CARDS" || val == "25")        return DialogAction_GAME_CARDS;
        if(val == "DialogAction_SHAVING" || val == "26")           return DialogAction_SHAVING;
        if(val == "DialogAction_AUCTION" || val == "27")           return DialogAction_AUCTION;

        return DialogAction_NONE;
    }

    public function updateWorldSync()
    {
        var newTime : GameTime;
        var remotePlayer : r_RemotePlayer;
        var globalPlayer : r_RemotePlayer;
        var now : float;
        var text : string;

        if(!inParty)
        {
            return;
        }

        now = theGame.GetEngineTimeAsSeconds();

        remotePlayer = mpghosts_getPlayer(joinedParty);
        globalPlayer = getGlobalPlayerByUsername(joinedParty);

        if(!globalPlayer)
        {
            partyTargetWasMissing = true;
            handleMissingPartyTarget();
            cancelPendingSyncedDialogChoice();
            return;
        }

        if(partyTargetWasMissing)
        {
            partyTargetWasMissing = false;
            cancelPendingSyncedDialogChoice();
            return;
        }

        updatePartyTargetSeen(globalPlayer);

        if(now - globalPlayer.lastUpdate > 90.0)
        {
            leavePartyBecauseTargetLeft();
            return;
        }

        if(checkPartyRegions(globalPlayer))
        {
            return;
        }

        if(!remotePlayer)
        {
            return;
        }

        newTime = GameTimeCreate(remotePlayer.day, remotePlayer.hour, remotePlayer.minute, remotePlayer.second);

        if(!isGameTimeCloseEnough(newTime, 90))
        {
            theGame.SetGameTime( newTime, true );
        }

        if(theGame.GetEngineTimeAsSeconds() >= nextWeatherSyncAt)
        {
            if(remotePlayer.weather != '' && remotePlayer.weather != 'none')
            {
                if(GetWeatherConditionName() != remotePlayer.weather)
                {
                    RequestWeatherChangeTo(remotePlayer.weather, 3, false);

                    nextWeatherSyncAt = theGame.GetEngineTimeAsSeconds() + 6;
                }
            }
        }

        if(hasActiveDialogChoices() && remotePlayer.menuName == "InCutscene" && remotePlayer.dialogChoices.Size() > 0 && isRemotePlayerCloseForDialogSync(remotePlayer)
            && dialogChoicesMatch(dialogChoices, remotePlayer.dialogChoices) && !pendingSyncedDialogChoice && !(remotePlayer.lastDialogIndex >= 0 && remotePlayer.lastDialogCount > 0 && remotePlayer.lastDialogCount != remotePlayer.prevDialogCount))
        {
            text = GetLocStringById(2111114102) + " " + joinedParty;

            if(leaderDialogReadyText != text)
            {
                leaderDialogReadyText = text;
                showDialogPickAlert(text, false);
            }
        }
        else if(leaderDialogReadyText != "")
        {
            leaderDialogReadyText = "";
            clearDialogPickAlert();
        }

        if(pendingSyncedDialogChoice)
        {
            applyRemoteDialogChoice(remotePlayer);
        }
        else if(remotePlayer.lastDialogIndex >= 0 && remotePlayer.lastDialogCount > 0 && remotePlayer.lastDialogCount != remotePlayer.prevDialogCount)
        {
            applyRemoteDialogChoice(remotePlayer);
        }
        else if(hasActiveDialogChoices() && (theGame.IsDialogOrCutscenePlaying() || theGame.IsCurrentlyPlayingNonGameplayScene()))
        {
            applyRemoteDialogChoice(remotePlayer);
        }
        else
        {
            cancelPendingSyncedDialogChoice();
        }
    }

    private function consumeRemoteDialogChoice(remotePlayer : r_RemotePlayer)
    {
        if(!remotePlayer)
        {
            return;
        }

        remotePlayer.prevDialogCount = remotePlayer.lastDialogCount;
        cancelPendingSyncedDialogChoice();
    }

    private function getDialogModule() : CR4HudModuleDialog
    {
        var hud : CR4ScriptedHud;
        var module : CR4HudModuleDialog;

        hud = (CR4ScriptedHud)theGame.GetHud();

        if(!hud)
        {
            return NULL;
        }

        module = (CR4HudModuleDialog)hud.GetHudModule("DialogModule");

        return module;
    }

    private function canApplyRemoteDialogChoice(remotePlayer : r_RemotePlayer) : bool
    {
        var index : int;

        if(!remotePlayer)
        {
            return false;
        }

        index = remotePlayer.lastDialogIndex;

        if(index < 0)
        {
            return false;
        }

        if(remotePlayer.lastDialogCount <= 0)
        {
            return false;
        }

        if(remotePlayer.lastDialogCount == remotePlayer.prevDialogCount)
        {
            return false;
        }

        if(!hasActiveDialogChoices())
        {
            return false;
        }

        if(index >= dialogChoices.Size())
        {
            return false;
        }

        if(index >= remotePlayer.dialogChoices.Size())
        {
            return false;
        }

        if(dialogChoices[index].disabled)
        {
            return false;
        }

        return true;
    }

    private function cancelPendingSyncedDialogChoice()
    {
        pendingSyncedDialogChoice = false;
        pendingSyncedDialogIndex = -1;
        pendingSyncedDialogCount = -1;
        pendingSyncedDialogAcceptAt = -999;
    }

    private function updatePendingSyncedDialogChoice(remotePlayer : r_RemotePlayer)
    {
        var module : CR4HudModuleDialog;

        if(!pendingSyncedDialogChoice)
        {
            return;
        }

        if(theGame.GetEngineTimeAsSeconds() < pendingSyncedDialogAcceptAt)
        {
            return;
        }

        if(!remotePlayer)
        {
            cancelPendingSyncedDialogChoice();
            return;
        }

        if(remotePlayer.lastDialogCount != pendingSyncedDialogCount)
        {
            cancelPendingSyncedDialogChoice();
            return;
        }

        if(remotePlayer.prevDialogCount == pendingSyncedDialogCount)
        {
            cancelPendingSyncedDialogChoice();
            return;
        }

        if(pendingSyncedDialogIndex < 0 || pendingSyncedDialogIndex >= dialogChoices.Size())
        {
            cancelPendingSyncedDialogChoice();
            return;
        }

        module = getDialogModule();

        if(!module)
        {
            return;
        }

        applyingSyncedDialogChoice = true;

        module.OnDialogOptionAccepted(pendingSyncedDialogIndex);

        applyingSyncedDialogChoice = false;

        remotePlayer.prevDialogCount = pendingSyncedDialogCount;

        clearActiveDialogChoices();
        cancelPendingSyncedDialogChoice();
    }

    private function startPendingSyncedDialogChoice(remotePlayer : r_RemotePlayer)
    {
        var module : CR4HudModuleDialog;
        var index : int;

        if(pendingSyncedDialogChoice)
        {
            return;
        }

        if(!canApplyRemoteDialogChoice(remotePlayer))
        {
            return;
        }

        module = getDialogModule();

        if(!module)
        {
            return;
        }

        index = remotePlayer.lastDialogIndex;

        if(leaderDialogReadyText != "")
        {
            leaderDialogReadyText = "";
            clearDialogPickAlert();
        }

        module.OnDialogOptionSelected(index);
        module.WO_ShowOnlySelectedDialogChoice(index);

        pendingSyncedDialogChoice = true;
        pendingSyncedDialogIndex = index;
        pendingSyncedDialogCount = remotePlayer.lastDialogCount;
        pendingSyncedDialogAcceptAt = theGame.GetEngineTimeAsSeconds() + 1.0;
    }

    private function applyRemoteDialogChoice(remotePlayer : r_RemotePlayer)
    {
        if(!remotePlayer)
        {
            return;
        }

        updatePendingSyncedDialogChoice(remotePlayer);

        if(pendingSyncedDialogChoice)
        {
            return;
        }

        if(remotePlayer.lastDialogIndex < 0)
        {
            return;
        }

        if(remotePlayer.lastDialogCount <= 0)
        {
            return;
        }

        if(remotePlayer.lastDialogCount == remotePlayer.prevDialogCount)
        {
            return;
        }

        if(!isRemotePlayerCloseForDialogSync(remotePlayer))
        {
            consumeRemoteDialogChoice(remotePlayer);
            return;
        }


        if(!hasActiveDialogChoices())
        {
            // auto consume
            consumeRemoteDialogChoice(remotePlayer);
            return;
        }

        if(!dialogChoicesMatch(dialogChoices, remotePlayer.dialogChoices))
        {
            consumeRemoteDialogChoice(remotePlayer);
            return;
        }

        startPendingSyncedDialogChoice(remotePlayer);
    }

    private function isRemotePlayerCloseForDialogSync(remotePlayer : r_RemotePlayer) : bool
    {
        var localPos : Vector;
        var remotePos : Vector;
        var horizontalDist : float;
        var heightDiff : float;
        var maxHorizontalDist : float;
        var maxHeightDiff : float;

        if(!remotePlayer)
        {
            return false;
        }

        maxHorizontalDist = 8.0;
        maxHeightDiff = 3.0;

        localPos = thePlayer.GetWorldPosition();
        remotePos = remotePlayer.pos;

        horizontalDist = VecDistance2D(localPos, remotePos);
        heightDiff = localPos.Z - remotePos.Z;

        if(heightDiff < 0.0)
        {
            heightDiff = -heightDiff;
        }

        if(horizontalDist > maxHorizontalDist)
        {
            return false;
        }

        if(heightDiff > maxHeightDiff)
        {
            return false;
        }

        return true;
    }

    private function sceneChoiceMatches(localChoice : SSceneChoice, remoteChoice : wo_SSceneChoice) : bool
    {
        var localPlayGoChunk : string;
        var remotePlayGoChunk : string;

        if(localChoice.emphasised != remoteChoice.emphasised)
        {
            return false;
        }

        if(localChoice.disabled != remoteChoice.disabled)
        {
            return false;
        }

        if(localChoice.dialogAction != remoteChoice.dialogAction)
        {
            return false;
        }

        if(localChoice.playGoChunk != '')
        {
            localPlayGoChunk = NameToString(localChoice.playGoChunk);
        }
        else
        {
            localPlayGoChunk = "none";
        }

        if(remoteChoice.playGoChunk != "")
        {
            remotePlayGoChunk = remoteChoice.playGoChunk;
        }
        else
        {
            remotePlayGoChunk = "none";
        }

        return localPlayGoChunk == remotePlayGoChunk;
    }

    private function dialogChoicesMatch(localChoices : array<SSceneChoice>, remoteChoices : array<wo_SSceneChoice>) : bool
    {
        var i : int;

        if(localChoices.Size() <= 0)
        {
            return false;
        }

        if(localChoices.Size() != remoteChoices.Size())
        {
            return false;
        }

        for(i = 0; i < localChoices.Size(); i += 1)
        {
            if(!sceneChoiceMatches(localChoices[i], remoteChoices[i]))
            {
                return false;
            }
        }

        return true;
    }

    public function boolToString(val : bool) : string
    {
        if(val)
        {
            return "1";
        }

        return "0";
    }

    public function stringToBool(val : string) : bool
    {
        return val == "1" || val == "true";
    }

    private function parseDialogChoiceData(choiceData : string, out choice : wo_SSceneChoice) : bool
    {
        var remaining : string;
        var token : string;
        var fieldIndex : int;

        if(choiceData == "")
        {
            return false;
        }

        remaining = choiceData;
        fieldIndex = 0;

        while(StrSplitFirst(remaining, "%", token, remaining))
        {
            if(fieldIndex == 0)
            {
                choice.emphasised = stringToBool(token);
            }
            else if(fieldIndex == 1)
            {
                choice.previouslyChoosen = stringToBool(token);
            }
            else if(fieldIndex == 2)
            {
                choice.disabled = stringToBool(token);
            }
            else if(fieldIndex == 3)
            {
                choice.dialogAction = stringToDialogAction(token);
            }

            fieldIndex += 1;
        }

        if(fieldIndex == 4)
        {
            if(remaining != "" && remaining != "none")
            {
                choice.playGoChunk = remaining;
            }
            else
            {
                choice.playGoChunk = '';
            }

            return true;
        }

        return false;
    }

    private function parseDialogChoicesData(dialogChoicesData : string, out parsedChoices : array<wo_SSceneChoice>)
    {
        var remaining : string;
        var token : string;
        var choice : wo_SSceneChoice;

        parsedChoices.Clear();

        remaining = dialogChoicesData;

        while(StrSplitFirst(remaining, "|", token, remaining))
        {
            if(token != "")
            {
                if(parseDialogChoiceData(token, choice))
                {
                    parsedChoices.PushBack(choice);
                }
            }
        }

        if(remaining != "")
        {
            if(parseDialogChoiceData(remaining, choice))
            {
                parsedChoices.PushBack(choice);
            }
        }
    }

    private function isGameTimeCloseEnough(targetTime : GameTime, maxDiffSeconds : int) : bool
    {
        var currentTime : GameTime;
        var currentSeconds : int;
        var targetSeconds : int;
        var diff : int;

        currentTime = theGame.GetGameTime();

        currentSeconds = GameTimeToSeconds(currentTime);
        targetSeconds = GameTimeToSeconds(targetTime);

        diff = currentSeconds - targetSeconds;

        if(diff < 0)
        {
            diff = -diff;
        }

        return diff <= maxDiffSeconds;
    }

    private function resolvePartyTarget(playerName : string) : string
    {
        var target : r_RemotePlayer;

        if(playerName == "" || playerName == "none")
        {
            return playerName;
        }

        target = getGlobalPlayerByUsername(playerName);

        if(!target)
        {
            target = mpghosts_getPlayer(playerName);
        }

        if(target && target.inParty && target.joinedParty != "" && target.joinedParty != "none")
        {
            return target.joinedParty;
        }

        return playerName;
    }

    public function joinParty(val : string)
    {
        var finalTarget : string;

        if(val == "" || val == "none")
        {
            theGame.GetGuiManager().ShowNotification(GetLocStringById(2111114200));
            return;
        }

        finalTarget = resolvePartyTarget(val);

        if(finalTarget == "" || finalTarget == "none")
        {
            theGame.GetGuiManager().ShowNotification(GetLocStringById(2111114200));
            return;
        }

        if(finalTarget == username)
        {
            theGame.GetGuiManager().ShowNotification(GetLocStringById(2111114201));
            return;
        }

        if(inParty && joinedParty == finalTarget)
        {
            theGame.GetGuiManager().ShowNotification(GetLocStringById(2111114202) + " " + finalTarget + GetLocStringById(2111114203));
            return;
        }

        inParty = true;
        joinedParty = finalTarget;

        joinedPartyAt = theGame.GetEngineTimeAsSeconds();
        partyTargetMissingSince = -1;
        partyTargetWasMissing = false;
        nextPartyFollowTeleportAt = -999;

        theGame.GetGuiManager().ShowNotification(GetLocStringById(2111114204) + " " + finalTarget + GetLocStringById(2111114205));

        mpghosts_playSound('gui_global_panel_open');
    }

    public function leaveParty()
    {
        var oldParty : string;

        if(!inParty)
        {
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114206));
            return;
        }

        oldParty = joinedParty;

        inParty = false;
        joinedParty = "";

        theGame.GetGuiManager().ShowNotification(GetLocStringById(2111114207));

        mpghosts_playSound('gui_global_panel_close');
    }

    private function handleMissingPartyTarget() : bool
    {
        var now : float;
        var missingFor : float;
        var maxMissingTime : float;

        now = theGame.GetEngineTimeAsSeconds();

        maxMissingTime = 90.0;

        if(partyTargetMissingSince < 0)
        {
            partyTargetMissingSince = now;
            partyTargetWasMissing = true;
        }

        missingFor = now - partyTargetMissingSince;

        if(missingFor >= maxMissingTime)
        {
            leavePartyBecauseTargetLeft();
            return false;
        }

        return true;
    }

    private function updatePartyTargetSeen(globalPlayer : r_RemotePlayer)
    {
        if(!globalPlayer)
        {
            return;
        }

        partyTargetWasMissing = false;
        partyTargetMissingSince = -1;

        partyTargetLastSeenAt = theGame.GetEngineTimeAsSeconds();
        partyTargetLastKnownArea = globalPlayer.area;
        partyTargetLastKnownPos = globalPlayer.pos;
    }

    private function checkPartyRegions(globalPlayer : r_RemotePlayer) : bool
    {
        var currentArea : EAreaName;

        if(!globalPlayer)
        {
            return false;
        }

        currentArea = theGame.GetCommonMapManager().GetCurrentArea();

        if(globalPlayer.area == currentArea)
        {
            return false;
        }

        cancelPendingSyncedDialogChoice();

        if(leaderDialogReadyText != "")
        {
            leaderDialogReadyText = "";
            clearDialogPickAlert();
        }

        return true;
    }

    private function leavePartyBecauseTargetLeft()
    {
        var oldParty : string;

        if(!inParty)
        {
            return;
        }

        oldParty = joinedParty;

        inParty = false;
        joinedParty = "";
        joinedPartyAt = -999;
        nextPartyFollowTeleportAt = -999;

        cancelPendingSyncedDialogChoice();

        theGame.GetGuiManager().ShowNotification(GetLocStringById(2111114207));

        mpghosts_playSound('gui_global_panel_close');
    }

    private function getGlobalPlayerByUsername(user : string) : r_RemotePlayer
    {
        var i : int;

        if(user == "" || user == "none")
        {
            return NULL;
        }

        for(i = 0; i < globalPlayers.Size(); i += 1)
        {
            if(globalPlayers[i].username == user)
            {
                return globalPlayers[i];
            }
        }

        return NULL;
    }

    public function checkIncomingGwentRequests()
    {
        var i : int;

        if(resetGwentFlagPending && (theGame.GetEngineTimeAsSeconds() >= resetGwentFlagAt))
        {
            clearGwentRequestState();
        }

        if((theGame.GetEngineTimeAsSeconds() - gwentLastCompleted) < 3)
        {
            return;
        }

        for(i = 0; i < players.Size(); i += 1)
        {
            if(players[i].outgoingGwentTo == id)
            {
                if((players[i].outgoingGwentRequest == E_RequestTimed || players[i].outgoingGwentRequest == E_RequestNormal) && !players[i].gwentHandshake)
                {
                    if(inGwentGame || shownGwentRequestWindow || thePlayer.IsInCombat() || theGame.IsDialogOrCutscenePlaying())
                    {
                        return;
                    }

                    if(openIncomingGwentRequest(players[i]))
                    {
                        outgoingGwentTo = players[i].id;
                        outgoingGwentRequest = E_None;
                        players[i].gwentHandshake = true;
                        gwentOpponent = players[i];
                        shownGwentRequestWindow = true;
                    }
                    else
                    {
                        outgoingGwentTo = players[i].id;
                        outgoingGwentRequest = E_Decline;
                        players[i].gwentHandshake = true;
                        gwentOpponent = players[i];
                        shownGwentRequestWindow = false;
                    }

                    return;
                }
                else if(players[i].outgoingGwentRequest == E_Accept && outgoingGwentRequest != E_Ack && !inGwentGame)
                {
                    gwentOpponent = players[i];
                    startGwentGame(gwentOpponent, requestedGwentGameType, outgoingGwentBet, outgoingGwentSeed, true);

                    outgoingGwentRequest = E_Ack;
                    gwentLastCompleted = theGame.GetEngineTimeAsSeconds();
                    resetGwentFlagPending = true;
                    resetGwentFlagAt = gwentLastCompleted + 3.0;
                    return;
                }
                else if(players[i].outgoingGwentRequest == E_Decline && outgoingGwentRequest != E_Ack && !inGwentGame)
                {
                    GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114211));
                    mpghosts_playSound('gui_enchanting_runeword_remove');

                    outgoingGwentRequest = E_Ack;
                    gwentLastCompleted = theGame.GetEngineTimeAsSeconds();
                    resetGwentFlagPending = true;
                    resetGwentFlagAt = gwentLastCompleted + 3.0;
                    return;
                }
                else if(players[i].outgoingGwentRequest == E_Ack)
                {
                    outgoingGwentRequest = E_None;
                    players[i].gwentHandshake = false;
                    return;
                }
            }
        }
    }

    public function clearGwentRequestState()
    {
        outgoingGwentTo = "";
        outgoingGwentRequest = E_None;
        shownGwentRequestWindow = false;
        outgoingGwentBet = 0;
        outgoingGwentSeed = 0;
        requestedGwentGameType = GG_None;
        resetGwentFlagPending = false;
        resetGwentFlagAt = -999;
    }

    public function acceptGwentRequest()
    {
        var gameType : E_GwentGameType;

        if(!shownGwentRequestWindow || !gwentOpponent)
            return;

        if(gwentOpponent.outgoingGwentRequest == E_RequestTimed)
        {
            gameType = GG_Timed;
        }
        else
        {
            gameType = GG_Normal;
        }

        outgoingGwentRequest = E_Accept;
        outgoingGwentTo = gwentOpponent.id;
        shownGwentRequestWindow = false;

        startGwentGame(gwentOpponent, gameType, gwentOpponent.outgoingGwentBet, gwentOpponent.outgoingGwentSeed, false);
    }

    public function declineGwentRequest(override : bool)
    {
        if((!shownGwentRequestWindow || !gwentOpponent) && !override)
            return;

        outgoingGwentRequest = E_Decline;
        outgoingGwentTo = gwentOpponent.id;
        shownGwentRequestWindow = false;

        if(!override)
        {
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114212));
            mpghosts_playSound('gui_global_panel_close');
        }
    }

    public function startGwentGame(opponent : r_RemotePlayer, type : E_GwentGameType, bet : int, seed : int, host : bool)
    {
        var gwintManager : CR4GwintManager;
        var gwentGame : r_GwentGame;
        var deck : SDeckDefinition;

        lastGwentAction = "";
        lastGwentActionTime = 0.0;
        gwentActionBuffer.Clear();
        lastGwentActionWasQuit = false;
        opponent.lastGwentAction = "";
        opponent.lastGwentActionTime = 0.0;
        opponent.prevGwentActionTime = -1;

        inGwentGame = true;
        gwentOpponent = opponent;
        activeGwentBet = bet;
        activeGwentSeed = seed;

        multiplayerLocalName = username;
        multiplayerOpponentName = opponent.username;

        gwentGame = opponent.getGwentGame();
        deck = gwentGame.deck;

        gwintManager = theGame.GetGwintManager();
        gwintManager.SetEnemyDeckFromMultiplayer(deck);
        gwintManager.multiplayerSeed = seed;
        gwintManager.multiplayerIsHost = host;
        gwintManager.multiplayerIsTimed = (type == GG_Timed);
        gwintManager.gameRequested = true;
        gwintManager.testMatch = true;

        theGame.RequestMenu('GwintGame');
    }

    public function gwentGameLoop()
    {
        var action : string;
        var menu : CR4GwintGameMenu;

        if(checkForGwentAction(action))
        {
            menu = (CR4GwintGameMenu)theGame.GetGuiManager().GetRootMenu();
            if(menu)
            {
                menu.ReceiveRemoteGwentAction(action);
            }
        }
    }

    public function checkForGwentAction(out action : string) : bool
    {
        // handle incoming action
        if (gwentOpponent.prevGwentActionTime < 0.0f)
        {
            gwentOpponent.prevGwentActionTime = gwentOpponent.lastGwentActionTime;
        }
        else if (gwentOpponent.lastGwentActionTime != gwentOpponent.prevGwentActionTime)
        {   
            gwentOpponent.prevGwentActionTime = gwentOpponent.lastGwentActionTime;
            action = gwentOpponent.lastGwentAction;
            return true;
        }

        return false;
    }

    public function setLastGwentAction(val : string)
    {
        var joined : string;
        var i : int;

        gwentActionBuffer.PushBack(val);
        if (StrContains(val, "QUITGAME"))
        {
            lastGwentActionWasQuit = true;
        }
        while (gwentActionBuffer.Size() > 20)
        {
            gwentActionBuffer.Erase(0);
        }

        joined = "";
        for (i = 0; i < gwentActionBuffer.Size(); i += 1)
        {
            if (i > 0)
            {
                joined += "~";
            }
            joined += gwentActionBuffer[i];
        }

        lastGwentAction = joined;
        lastGwentActionTime = lastGwentActionTime + 1.0f;
    }

    public function getLastGwentAction() : string
    {
        return lastGwentAction;
    }

    public function getLastGwentActionTime() : float
    {
        return lastGwentActionTime;
    }

    public function getInGwentGame() : bool
    {
        return inGwentGame;
    }

    public function onGwentGameEnd(localPlayerWon : bool)
    {
        if(localPlayerWon)
        {
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114213));
        }
        else
        {
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114214));
        }

        settleGwentBet(localPlayerWon);
        clearGwentRequestState();
        inGwentGame = false;
        if (!lastGwentActionWasQuit)
        {
            lastGwentAction = "";
            lastGwentActionTime = 0.0;
            gwentActionBuffer.Clear();
        }
        gwentOpponent = NULL;
        gwentLastCompleted = theGame.GetEngineTimeAsSeconds();
        activeGwentBet = 0;
        activeGwentSeed = 0;
        theGame.GetGwintManager().ClearMultiplayerState();
    }

    public function settleGwentBet(localPlayerWon : bool)
    {
        if(activeGwentBet <= 0)
            return;

        if(localPlayerWon)
        {
            thePlayer.AddMoney(activeGwentBet);
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114215) + " " + activeGwentBet + " " + GetLocStringById(2111114216));
        }
        else
        {
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114217) + " " + activeGwentBet + " " + GetLocStringById(2111114218));

            if(activeGwentBet > thePlayer.GetMoney())
            {
                thePlayer.RemoveMoney(thePlayer.GetMoney());
            }
            else
            {
                thePlayer.RemoveMoney(activeGwentBet);
            }
        }
    }

    public function getOutgoingGwentTo() : string
    {
        return outgoingGwentTo;
    }

    public function getOutgoingGwentRequest() : E_GwentRequest
    {
        return outgoingGwentRequest;
    }

    public function getOutgoingGwentBet() : int
    {
        return outgoingGwentBet;
    }

    public function getOutgoingGwentSeed() : int
    {
        return outgoingGwentSeed;
    }
    
    public function gwentRequest(toRequest : string) : bool
    {
        var cat : array<name>;
        var m_popupData : W3ItemSelectionPopupData;
        var inventory : CInventoryComponent;
        var ids : array<SItemUniqueId>;

        if(toRequest == id)
        {
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114219));
            return false;
        }
        else if(inGwentGame)
        {
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114220));
            return false;
        }

        clearGwentRequestState();
        outgoingGwentTo = toRequest;

        inventory = new CInventoryComponent in this;
        ids = inventory.AddAnItem('wo_timed_gwent', 1);
        ids = inventory.AddAnItem('wo_notime_gwent', 1);

        m_popupData = new W3ItemSelectionPopupData in theGame.GetGuiManager();
        m_popupData.targetInventory = inventory;
        m_popupData.overrideQuestItemRestrictions = true;

        m_popupData.selectionMode = EISPM_RadialMenuSilverOil;
        m_popupData.wo_isGwent = true;
        m_popupData.wo_toGwent = toRequest;
        
        theGame.RequestPopup('ItemSelectionPopup', m_popupData);

        return true;
    }

    public function openIncomingGwentRequest(player : r_RemotePlayer) : bool
    {
        var cat : array<name>;
        var m_popupData : W3ItemSelectionPopupData;
        var inventory : CInventoryComponent;
        var ids : array<SItemUniqueId>;
        var type : E_GwentRequest;
        
        inventory = new CInventoryComponent in this;

        if(player.outgoingGwentRequest == E_RequestTimed)
        {
            ids = inventory.AddAnItem('wo_timed_gwent', 1);
        }
        else
        {
            ids = inventory.AddAnItem('wo_notime_gwent', 1);
        }

        if(theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_AutoDeclineGwent'))
        {
            declineGwentRequest(true);
            return false;
        }

        m_popupData = new W3ItemSelectionPopupData in theGame.GetGuiManager();
        m_popupData.targetInventory = inventory;
        m_popupData.overrideQuestItemRestrictions = true;

        m_popupData.selectionMode = EISPM_RadialMenuSilverOil;
        m_popupData.wo_isReceivingGwent = true;
        m_popupData.wo_toGwent = player.username;
        m_popupData.wo_betAmount = player.outgoingGwentBet;
        
        theGame.RequestPopup('ItemSelectionPopup', m_popupData);

        return true;
    }

    public function openGwentBetWindow()
    {
        var price: r_BetWindow;
        price = new r_BetWindow in theGame;
        price.openBetWindow();
    }

    public function setGwentBetAmount(amount : int)
    {
        if(amount > thePlayer.GetMoney())
        {
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114221));
            clearGwentRequestState();
            inGwentGame = false;
            return;
        }

        outgoingGwentBet = amount;
        setGwentSeed();

        if(requestedGwentGameType == GG_Timed)
        {
            outgoingGwentRequest = E_RequestTimed;
        }
        else
        {
            outgoingGwentRequest = E_RequestNormal;
        }

        GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114222) + " " + outgoingGwentTo);
        mpghosts_playSound('gui_global_highlight');
    }

    public function setGwentSeed()
    {
        outgoingGwentSeed = RandRange(999999, 1);
    }

    public function setGwentGameType(val : E_GwentGameType)
    {
        requestedGwentGameType = val;
    }

    public function getNextPlayerNum() : int
    {
        var toReturn : int;

        toReturn = nextPlayerNum;
        nextPlayerNum += 1;

        return toReturn;
    }

    function Mount(actor : CActor, itemName: name, optional notHand: bool): SItemUniqueId {
        var items: array<SItemUniqueId>;
        items = actor.GetInventory().GetItemsByName(itemName);
        if (items.Size() == 0) {
            items = actor.GetInventory().AddAnItem(itemName, 1, true, true);
        }
        actor.GetInventory().MountItem(items[0], !notHand);

        return items[0];
    }

    function MountRightTorch(actor : CActor)
    {
        var items: array<SItemUniqueId>;
        var i : int;
        items = actor.GetInventory().GetItemsByName('Torch_work_right');
        if (items.Size() == 0) {
            items = actor.GetInventory().AddAnItem('Torch_work_right', 1, true, true);
        }

        for(i = 0; i < items.Size(); i+=1)
        {
            if(actor.GetInventory().GetItemName(items[i]) == 'Torch_work_right')
            {
                actor.GetInventory().MountItem(items[i], true);
                return;
            }
        }
    }

    private function Unmount(actor : CActor, itemName: name) {
        var i: int;
        var items: array<SItemUniqueId>;

        if (itemName == '') return;

        items = actor.GetInventory().GetItemsByName(itemName);
        for (i = 0; i < items.Size(); i += 1) {
            actor.GetInventory().DespawnItem(items[i]);
            actor.GetInventory().UnmountItem(items[i], true);
        }
    }

    private function UnmountRightTorch(actor : CActor) {
        var i: int;
        var items: array<SItemUniqueId>;

        items = actor.GetInventory().GetItemsByName('Torch_work_right');
        for (i = 0; i < items.Size(); i += 1) {
            if(actor.GetInventory().GetItemName(items[i]) == 'Torch_work_right')
            {
                actor.GetInventory().DespawnItem(items[i]);
                actor.GetInventory().UnmountItem(items[i], true);
            }
        }
    }

    public function unmountItems(actor : CActor)
    {
        Unmount(actor, 'Horn');
        Unmount(actor, 'card_deck');
        Unmount(actor, 'card_single');
        Unmount(actor, 'bread_piece');
        Unmount(actor, 'Apple_01');
        Unmount(actor, 'Pipe_01'); 
        Unmount(actor, 'Meat_04'); 
        Unmount(actor, 'meat_food'); 
        Unmount(actor, 'Fishing_rod'); 
        Unmount(actor, 'Cup_01'); 
        Unmount(actor, 'Ladle_01'); 
        Unmount(actor, 'cutlery_fork'); 
        Unmount(actor, 'cutlery_rich_knife'); 
        Unmount(actor, 'Lute 01'); 
        Unmount(actor, 'fan_01'); 
        Unmount(actor, 'Spyglass'); 
        UnmountRightTorch(actor);
        Unmount(actor, 'Note_01'); 
        Unmount(actor, 'Quill'); 
        Unmount(actor, 'Broom'); 
        Unmount(actor, 'Sack'); 
        Unmount(actor, 'shovel'); 
        Unmount(actor, 'baguette'); 
        Unmount(actor, 'rich_plate_full_canapes_righthand'); 
        Unmount(actor, 'gen_veg_canapes_lefthand'); 
        Unmount(actor, 'rich_umbrella'); 
    }

    public function getOutgoingTradeTo() : string
    {
        return outgoingTradeTo.id;
    }

    public function getOutgoingTradeItem() : name
    {
        return outgoingTradeItem;
    }

    public function getOutgoingTradePrice() : int
    {
        return outgoingTradePrice;
    }

    public function getOutgoingTradeFlag() : int
    {
        return outgoingTradeFlag;
    }

    public function checkOutgoingTrades()
    {
        var i : int;

        if(resetFlagPending && (theGame.GetEngineTimeAsSeconds() >= resetFlagAt))
        {
            outgoingTradeFlag = -1;
            resetFlagPending = false;
        }

        if(tradeInProgress || ((theGame.GetEngineTimeAsSeconds() - tradeLastCompleted) < 3))
        {
            return;
        }

        if(thePlayer.IsInCombat() || theGame.IsDialogOrCutscenePlaying())
        {
            return;
        }

        for(i = 0; i < players.Size(); i+=1)
        {
            if(players[i].outgoingTradeTo == id)
            {  
                if(players[i].outgoingTradeFlag == 0 && !players[i].tradeHandshake)
                {
                    // incoming trade
                    if(openIncomingTrade(players[i].outgoingTradeItem, players[i].outgoingTradePrice, players[i].username))
                    {
                        outgoingTradeTo = players[i];
                        outgoingTradeFlag = -1; // -1 means do nothing, -2 accept, -3 decline
                        players[i].tradeHandshake = true;
                    }
                    else
                    {
                        outgoingTradeTo = players[i];
                        outgoingTradeFlag = -3; // -1 means do nothing, -2 accept, -3 decline
                        players[i].tradeHandshake = true;
                    }
                    return;
                }
                else if(players[i].outgoingTradeFlag == -2)
                {
                    // reset our outgoing trade price
                    thePlayer.GetInventory().RemoveItemByName(outgoingTradeItem, 1);
                    thePlayer.AddMoney(outgoingTradePrice);
                    mpghosts_playSound('gui_enchanting_runeword_add');
                    GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114223));
                    
                    outgoingTradeFlag = -4;
                    tradeLastCompleted = theGame.GetEngineTimeAsSeconds();
                    resetFlagPending = true;
                    resetFlagAt = tradeLastCompleted + 3.0;
                    return;
                }
                else if(players[i].outgoingTradeFlag == -3)
                {
                    // reset our outgoing trade price
                    GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114224));
                    mpghosts_playSound('gui_enchanting_runeword_remove');
                    
                    outgoingTradeFlag = -4;
                    tradeLastCompleted = theGame.GetEngineTimeAsSeconds();
                    resetFlagPending = true;
                    resetFlagAt = tradeLastCompleted + 3.0;
                    return;
                }
                else if(players[i].outgoingTradeFlag == -4)
                {
                    outgoingTradeFlag = -1;
                    players[i].tradeHandshake = false;
                    return;
                }
            }
        }
    }

    public function acceptTrade()
    {
        var i : int;

        if(!tradeInProgress)
            return;

        for(i = 0; i < players.Size(); i+=1)
        {
            if(players[i].outgoingTradeTo == id)
            {
                if(players[i].outgoingTradePrice > thePlayer.GetMoney())
                {
                    GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114225));
                    outgoingTradeFlag = -3;
                    mpghosts_playSound('gui_enchanting_runeword_remove');
                    tradeInProgress = false;
                    return;
                }
                
                thePlayer.RemoveMoney(players[i].outgoingTradePrice);
                thePlayer.GetInventory().AddAnItem(players[i].outgoingTradeItem, 1);
                break;
            }
        }

        mpghosts_playSound('gui_enchanting_runeword_add');

        GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114223));

        outgoingTradeFlag = -2;
        tradeInProgress = false;
    }

    public function declineTrade(playSound : bool)
    {
        if(!tradeInProgress)
            return;

        if(playSound)
        {
            mpghosts_playSound('gui_global_panel_close');
        }

        outgoingTradeFlag = -3;
        tradeInProgress = false;
    }

    public function openIncomingTrade(itemName : name, price : int, user : string) : bool
    {
        var cat : array<name>;
        var m_popupData : W3ItemSelectionPopupData;
        var inventory : CInventoryComponent;
        var ids : array<SItemUniqueId>;
        
        tradeInProgress = true;
        
        inventory = new CInventoryComponent in this;
        ids = inventory.AddAnItem(itemName, 1);

        if(theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_AutoDeclineTrade'))
        {
            declineTrade(false);
            return false;
        }
        
        if(!inventory.IsIdValid(ids[0]))
        {
            GetWitcherPlayer().DisplayHudMessage(user + " " + GetLocStringById(2111114226));
            declineTrade(true);
            return false;
        }

        m_popupData = new W3ItemSelectionPopupData in theGame.GetGuiManager();
        m_popupData.targetInventory = inventory;
        m_popupData.overrideQuestItemRestrictions = true;

        m_popupData.selectionMode = EISPM_RadialMenuSilverOil;
        m_popupData.wo_isReceivingTrade = true;
        m_popupData.wo_toTrade = user;
        m_popupData.wo_crownsAmount = price;
        
        theGame.RequestPopup('ItemSelectionPopup', m_popupData);

        return true;
    }

    public function getRidingPlayer() : r_RemotePlayer
    {
        return ridingPlayer;
    }

    var lastRidingType : string;

    public function getLastRidingType() : string
    {
        return lastRidingType;
    }

    public function ridePlayer(actor : CActor)
    {
        var player : r_RemotePlayer;
        player = mpghosts_getPlayerFromActor(actor);

        if(!player)
            return;

        if(player.id == id)
        {
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114227));
            return;
        }
        else if(player.isRiding && player.ridingPlayerId == serverPlayerId)
        {
            return;
        }

        ridingPlayer = player;
        ridingEnabled = true;

        thePlayer.EnableCollisions(false);
        thePlayer.SetExplCamera(false);

        theInput.IgnoreGameInput( 'GI_AxisLeftX', true );
        theInput.IgnoreGameInput( 'GI_AxisLeftY', true );
        
        if(player.isSailing)
        {
            mpghosts_emote(30);
            attachRiderBoat(thePlayer, actor);
            lastRidingType = "boat";
        }
        else if(player.isMounted && player.horse)
        {
            if(attachRiderHorse(thePlayer, player.horse))
            {
                mpghosts_emote(31);
                lastRidingType = "horse";
            }
            else
            {
                stopRiding();
                return;
            }
        }
        else
        {
            mpghosts_emote(29);
            if(ridingPlayer.lastMountType == "horse")
            {
                attachRider(thePlayer, actor, true);
                lastRidingType = "playerhorse";
            }
            else
            {
                attachRider(thePlayer, actor);
                lastRidingType = "player";
            }
        }
    }

    public function checkRidingAttachment()
    {
        if(!ridingEnabled || !ridingPlayer)
        {
            return;
        }

        if(ridingPlayer.isMounted && !ridingPlayer.horse)
        {
            return;
        }

        if(!ridingPlayer.isMounted && !ridingPlayer.ghost)
        {
            stopRiding();
            return;
        }

        if(thePlayer.HasAttachment())
        {
            if(ridingPlayer.isSailing && !ridingPlayer.isMounted && lastRidingType != "boat")
            {
                detachRiderSafe(thePlayer, false);
                attachRiderBoat(thePlayer, ridingPlayer.ghost);
                lastRidingType = "boat";
                mpghosts_emote(30);
            }
            else if(ridingPlayer.isMounted && !ridingPlayer.isSailing && lastRidingType != "horse" && ridingPlayer.horse)
            {
                detachRiderSafe(thePlayer, false);
                if(attachRiderHorse(thePlayer, ridingPlayer.horse))
                {
                    lastRidingType = "horse";
                    mpghosts_emote(31);
                }
            }
            else if(!ridingPlayer.isSailing && !ridingPlayer.isMounted && ridingPlayer.lastMountType == "horse" && lastRidingType != "playerhorse")
            {
                detachRiderSafe(thePlayer, false);
                attachRider(thePlayer, ridingPlayer.ghost, true);
                lastRidingType = "playerhorse";
                mpghosts_emote(29);
            }
            else if(!ridingPlayer.isSailing && !ridingPlayer.isMounted && ridingPlayer.lastMountType != "horse" && lastRidingType != "player")
            {
                detachRiderSafe(thePlayer, false);
                attachRider(thePlayer, ridingPlayer.ghost);
                lastRidingType = "player";
                mpghosts_emote(29);
            }
        }
        
    }

    public function attachRider(rider : CActor, toAttach : CActor, optional horseOffset : bool)
    {
        var attach_rot : EulerAngles;
        var attach_vec : Vector;
        var cpcPlayerType : ENR_PlayerType;
        var riderPlayer : r_RemotePlayer;

        cpcPlayerType = NR_GetPlayerManager().GetCurrentPlayerType();

        riderPlayer = mpghosts_getPlayerFromActor(rider);

        if(!rider || !toAttach)
            return;

        destroyRiderHorseAnchor(rider, true);

        if((rider == thePlayer && (cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)) 
            || (riderPlayer && (riderPlayer.cpcPlayerType != ENR_PlayerGeralt && riderPlayer.cpcPlayerType != ENR_PlayerWitcher && riderPlayer.cpcPlayerType != ENR_PlayerUnknown)))
        {
            // is female
            attach_rot.Roll = 0.0f;
            attach_rot.Pitch = 0.0f;
            attach_rot.Yaw = 0.0f;
            attach_vec.X = 0.0f;
            attach_vec.Y = -0.05f;
            attach_vec.Z = 1.15f;
        }
        else
        {
            attach_rot.Roll = 0.0f;
            attach_rot.Pitch = 0.0f;
            attach_rot.Yaw = 0.0f;
            attach_vec.X = 0.0f;
            attach_vec.Y = -0.2f;
            attach_vec.Z = 1.0f;
        }

        if(horseOffset)
        {
            attach_vec.Z = 2.0f;
        }
    
        rider.CreateAttachment(toAttach, , attach_vec, attach_rot);
    }

    public function attachRiderHorse(rider : CActor, toAttach : CActor) : bool
    {
        var boneRotation, attach_rot : EulerAngles;
        var bonePosition, attach_vec : Vector;
        var anchor : CEntity;
        var entryAnchor : r_RiderHorseAnchor;

        if(!rider || !toAttach)
            return false;

        attach_rot.Roll = 90.0f;
        attach_rot.Pitch = -10.0f;
        attach_rot.Yaw = -100.0f;

        attach_vec.X = 0.20f; // forward back
        attach_vec.Y = 1.45f; // up down
        attach_vec.Z = 0.05f; // left right

        anchor = (CEntity)theGame.CreateEntity(
            (CEntityTemplate)LoadResource("dlc\dlc_mpmod\data\entities\fx_ent.w2ent", true),
            toAttach.GetWorldPosition()
        );

        if(!anchor)
            return false;

        toAttach.GetBoneWorldPositionAndRotationByIndex(
            toAttach.GetBoneIndex('spine1'),
            bonePosition,
            boneRotation
        );

        anchor.CreateAttachmentAtBoneWS(toAttach, 'spine1', bonePosition, boneRotation);

        destroyRiderHorseAnchor(rider, true);

        rider.CreateAttachment(anchor, , attach_vec, attach_rot);

        entryAnchor.rider = rider;
        entryAnchor.target = toAttach;
        entryAnchor.anchor = anchor;

        riderHorseAnchors.PushBack(entryAnchor);

        return true;
    }

    public function fixAttachRotation(rider : CActor)
    {
        var attach_rot : EulerAngles;
        var attach_vec : Vector;
        var anchor : CEntity;

        if(!rider)
            return;

        attach_rot.Roll = 0.0f;
		attach_rot.Pitch = 0.0f;
		attach_rot.Yaw = 0.0f;
		attach_vec.X = 0.0f;
		attach_vec.Y = 0.0f;
		attach_vec.Z = 0.0f;

        anchor = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource("dlc\dlc_mpmod\data\entities\fx_ent.w2ent", true), rider.GetWorldPosition());

        if(!anchor)
            return;

        rider.CreateAttachment(anchor, , attach_vec, attach_rot);
        rider.BreakAttachment();

        anchor.Destroy();
    }

    public function attachRiderBoat(rider : CActor, toAttach : CActor)
    {
        var attach_rot : EulerAngles;
        var attach_vec : Vector;
        var player : r_RemotePlayer;

        if(!rider || !toAttach)
            return;

        destroyRiderHorseAnchor(rider, true);

        player = mpghosts_getPlayerFromActor(toAttach);

        attach_rot.Roll = 0.0f;
		attach_rot.Pitch = 0.0f;
		attach_rot.Yaw = 180.0f;

        if(rider != thePlayer)
        {
            attach_vec.X = 0.5f;
            attach_vec.Y = 6.0f;
            attach_vec.Z += 0.1f;
        }
        else
        {
            if(player && (player.cpcPlayerType != ENR_PlayerGeralt && player.cpcPlayerType != ENR_PlayerWitcher && player.cpcPlayerType != ENR_PlayerUnknown))
            {
                attach_vec.X = 0.5f;
                attach_vec.Y = 6.0f;
                attach_vec.Z += 0.1f;
            }
            else
            {
                attach_vec.X = 0.35f;
                attach_vec.Y = 5.5f;
                attach_vec.Z += 0.1f;
            }
        }

        if(rider != thePlayer && toAttach != thePlayer)
        {
            if(player && (player.cpcPlayerType != ENR_PlayerGeralt && player.cpcPlayerType != ENR_PlayerWitcher && player.cpcPlayerType != ENR_PlayerUnknown))
            {

            }
            else
            {
                attach_vec.X -= 0.12f;
                attach_vec.Y -= 0.5f;
            }
        }
    
        rider.CreateAttachment(toAttach, , attach_vec, attach_rot);
    }

    public function tradeWithPlayer(actor : CActor)
    {
        var player : r_RemotePlayer;
        var m_popupData : W3ItemSelectionPopupData;
        player = mpghosts_getPlayerFromActor(actor);

        if(!player)
            return;

        outgoingTradeTo = player;

        m_popupData = new W3ItemSelectionPopupData in theGame.GetGuiManager();
        m_popupData.targetInventory = thePlayer.GetInventory();
        m_popupData.overrideQuestItemRestrictions = true;

        m_popupData.selectionMode = EISPM_RadialMenuSilverOil;
        m_popupData.wo_isTrade = true;
        m_popupData.wo_toTrade = player.username;

        theGame.RequestPopup('ItemSelectionPopup', m_popupData);
    }

    public function tradeSelectItem(itemId : SItemUniqueId)
    {
        var price: r_TradeWindow;
        outgoingTradeItem = thePlayer.GetInventory().GetItemName(itemId);

        price = new r_TradeWindow in theGame;
        price.openTradeWindow();
    }

    public function setTradeAmount(amount : int)
    {
        outgoingTradePrice = amount;
        outgoingTradeFlag = 0;
        GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114228) + " " + outgoingTradeTo.username);
        mpghosts_playSound('gui_global_highlight');
    }

    function updateCamera( out moveData : SCameraMovementData, dt : float ) : bool
    {
        var camera								: CCustomCamera;
        var cameraPreset						: SCustomCameraPreset;
        
        camera = (CCustomCamera)theCamera.GetTopmostCameraObject();
        cameraPreset = camera.GetActivePreset();

        camera.ChangePivotDistanceController( 'Default' );
        camera.ChangePivotPositionController( 'Default' );
        
        moveData.pivotDistanceController = camera.GetActivePivotDistanceController();
        moveData.pivotPositionController = camera.GetActivePivotPositionController();

        moveData.pivotDistanceController.SetDesiredDistance(cameraPreset.distance + 1.0f);
        moveData.pivotPositionController.SetDesiredPosition(thePlayer.GetWorldPosition());
        return true;
    }

    public function stopRiding()
    {
        if(!ridingEnabled)
            return;

        ridingEnabled = false;
        thePlayer.EnableCollisions(true);
        detachRiderSafe(thePlayer, true);
        theInput.IgnoreGameInput( 'GI_AxisLeftX', false );
        theInput.IgnoreGameInput( 'GI_AxisLeftY', false );
        lastRidingType = "none";
    }

    public function isRiding() : bool
    {
        return ridingEnabled;
    }
    
    public function createMenu(actor : CActor)
    {
        var m_popupData : W3ItemSelectionPopupData;
        var inventory : CInventoryComponent;
        var cpcPlayerType : ENR_PlayerType;
        var player   : r_RemotePlayer;

        player = mpghosts_getPlayerFromActor(actor);
        if(!player)
            return;

        cpcPlayerType = NR_GetPlayerManager().GetCurrentPlayerType();
        
        inventory = new CInventoryComponent in theGame;
        
        if(inParty)
        {
            inventory.AddAnItem('wo_leaveParty', 1);
        }
        else
        {
            inventory.AddAnItem('wo_joinParty', 1);
        }

        inventory.AddAnItem('wo_inviteGwent', 1);

        if(player.isSailing)
        {
            inventory.AddAnItem('wo_rideBoat', 1);
        }
        else if(player.isMounted)
        {
            inventory.AddAnItem('wo_rideHorse', 1);
        }
        else
        {
            inventory.AddAnItem('wo_ride', 1);
        }
        inventory.AddAnItem('wo_trade', 1);

        m_popupData = new W3ItemSelectionPopupData in theGame.GetGuiManager();
        m_popupData.targetInventory = inventory;
        m_popupData.overrideQuestItemRestrictions = true;

        m_popupData.selectionMode = EISPM_RadialMenuSilverOil;
        m_popupData.wo_isPlayerMenu = true;
        m_popupData.wo_playerMenuPlayer = player;
        
        theGame.RequestPopup('ItemSelectionPopup', m_popupData);
    }

    public function Init()
    {
        inParty = false;
        joinedParty = "";
        joinedPartyAt = -999;
        nextPartyFollowTeleportAt = -999;

        lightAttackAnims.Clear();
        heavyAttackAnims.Clear();
        lightFistAnims.Clear();
        heavyFistAnims.Clear();
        swordBackDodgeAnims.Clear();
        swordForwardDodgeAnims.Clear();
        swordLeftDodgeAnims.Clear();
        swordRightDodgeAnims.Clear();
        swordIdleAnims.Clear();
        swordHitAnims.Clear();
        fistHitAnims.Clear();
        swordParryAnims.Clear();
        fistParryAnims.Clear();
        nameColors.Clear();

        if(!maleTemp)
        {
            maleTemp = (CEntityTemplate)LoadResource("dlc\dlc_mpmod\data\entities\geralt_npc.w2ent", true );
        }

        if(!femaleTemp)
        {
            femaleTemp = (CEntityTemplate)LoadResource("dlc\dlc_mpmod\data\entities\female_npc.w2ent", true );
        }

        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_1_lp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_1_rp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_2_lp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_2_rp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_3_lp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_3_rp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_4_lp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_4_rp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_5_lp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_5_rp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_6_lp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_6_rp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_7_lp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_7_rp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_8_rp_40ms', 1.6));
        lightAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_fast_9_lp_40ms', 1.6));

        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_1_lp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_1_rp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_10_lp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_10_rp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_2_lp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_2_rp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_3_lp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_3_rp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_4_lp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_4_rp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_5_lp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_5_rp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_6_lp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_6_rp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_7_lp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_7_rp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_8_lp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_8_rp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_9_lp_70ms', 2.0));
        heavyAttackAnims.PushBack(r_Anim('man_geralt_sword_attack_strong_9_rp_70ms', 2.0));

        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_1_lh_40ms', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_1_lh_40ms_short', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_1_rh_40ms', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_1_rh_40ms_short', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_2_lh_40ms', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_2_lh_40ms_short', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_2_rh_40ms', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_2_rh_40ms_short', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_3_lh_40ms', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_3_lh_40ms_short', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_3_rh_40ms', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_3_rh_40ms_short', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_4_lh_40ms', 1.6));
        lightFistAnims.PushBack(r_Anim('man_fistfight_attack_fast_4_lh_40ms_short', 1.6));

        heavyFistAnims.PushBack(r_Anim('man_fistfight_attack_heavy_1_lh_70ms', 2.0));
        heavyFistAnims.PushBack(r_Anim('man_fistfight_attack_heavy_1_rh_70ms', 2.0));
        heavyFistAnims.PushBack(r_Anim('man_fistfight_attack_heavy_2_lh_70ms', 2.0));
        heavyFistAnims.PushBack(r_Anim('man_fistfight_attack_heavy_2_rh_70ms', 2.0));
        heavyFistAnims.PushBack(r_Anim('man_fistfight_attack_heavy_3_lh_70ms', 2.0));
        heavyFistAnims.PushBack(r_Anim('man_fistfight_attack_heavy_4_ll_70ms', 1.6));

        fistBackDodgeAnims.PushBack(r_Anim('man_fistfight_dodge_back_350m', 1.5));
        fistBackDodgeAnims.PushBack(r_Anim('man_fistfight_dodge_back_350m_180deg', 1.5));
        fistBackDodgeAnims.PushBack(r_Anim('man_fistfight_dodge1_back_425cm', 1.5));

        fistForwardDodgeAnims.PushBack(r_Anim('man_fistfight_dodge_forward_350m', 1.5));
        fistForwardDodgeAnims.PushBack(r_Anim('man_fistfight_dodge_forward_350m_180deg', 1.5));
        fistForwardDodgeAnims.PushBack(r_Anim('man_fistfight_dodge1_forward_425cm', 1.5));

        fistLeftDodgeAnims.PushBack(r_Anim('man_fistfight_dodge_left_350m', 1.5));
        fistLeftDodgeAnims.PushBack(r_Anim('man_fistfight_dodge1_left_425cm', 1.5));

        fistRightDodgeAnims.PushBack(r_Anim('man_fistfight_dodge_right_350m', 1.5));
        fistRightDodgeAnims.PushBack(r_Anim('man_fistfight_dodge1_right_425cm', 1.5));
        
        swordRollAnims.PushBack(r_Anim('man_geralt_sword_dodge_roll_rp_b_01', 1.33));
        swordRollAnims.PushBack(r_Anim('man_geralt_sword_dodge_roll_rp_f_01', 1.33));

        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge1_back_4m', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_back_350m', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_ger_sword_dodge_b_02', 1.10));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_back_350m_lp', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_dodge_back_lp_337m', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_dodge_back_rp_337m', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_back_337m', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_back_337cm_lp_01', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_back_337cm_lp_02', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_back_337cm_lp_03', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_back_337cm_rp_01', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_back_337cm_rp_02', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_back_337cm_rp_03', 1.5));
        swordBackDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_pirouette_rp_b_01', 1.67));

        swordForwardDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_forward1_4m', 1.5));
        swordForwardDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_forward2_4m', 1.5));
        swordForwardDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_forward_350m', 1.5));
        swordForwardDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_forward_300m', 1.5));
        swordForwardDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_forward_350m_lp', 1.5));
        swordForwardDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_forward_300m_lp', 1.5));
        swordForwardDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_pirouette_rp_f_01', 2.0));

        swordLeftDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_left_350m', 1.5));
        swordLeftDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_left_350m_90deg', 1.5));
        swordLeftDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge1_left_4m', 1.5));
        swordLeftDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_pirouette_flip_left_rp_b_01', 2.5));

        swordRightDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_right_350m', 1.5));
        swordRightDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_right_350m_90deg', 1.5));
        swordRightDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge1_right_4m', 1.5));
        swordRightDodgeAnims.PushBack(r_Anim('man_geralt_sword_dodge_pirouette_flip_right_rp_b_01', 2.5));

        swordIdleAnims.PushBack(r_Anim('man_geralt_sword_alert_idle_left', 1.5));
        swordIdleAnims.PushBack(r_Anim('man_geralt_sword_alert_idle_right', 1.5));

        swordHitAnims.PushBack(r_Anim('man_geralt_sword_hit_front_left_lp_01', 1.5));
        swordHitAnims.PushBack(r_Anim('man_geralt_sword_hit_front_left_up_lp_01', 1.5));
        swordHitAnims.PushBack(r_Anim('man_geralt_sword_hit_front_lp_01', 1.5));
        swordHitAnims.PushBack(r_Anim('man_geralt_sword_hit_front_right_up_rp_01', 1.5));
        swordHitAnims.PushBack(r_Anim('man_geralt_sword_hit_front_rp_01', 1.5));
        swordHitAnims.PushBack(r_Anim('man_geralt_sword_hit_front_up_rp_01', 1.5));
        swordHitAnims.PushBack(r_Anim('man_geralt_sword_hit_front_right_down_rp_01', 1.5));
        swordHitAnims.PushBack(r_Anim('man_geralt_sword_hit_front_down_rp_01', 1.5));
        swordHitAnims.PushBack(r_Anim('man_geralt_sword_hit_front_left_down_lp_01', 1.5));

        fistHitAnims.PushBack(r_Anim('man_fistfight_hit_left_1', 1));
        fistHitAnims.PushBack(r_Anim('man_fistfight_hit_right_1', 1));
        fistHitAnims.PushBack(r_Anim('man_fistfight_hit_back_1', 1));
        fistHitAnims.PushBack(r_Anim('man_fistfight_hit_front_1', 1));

        swordParryAnims.PushBack(r_Anim('man_geralt_sword_parry_b_left_lp', 1));
        swordParryAnims.PushBack(r_Anim('man_geralt_sword_parry_b_right_lp', 1));
        swordParryAnims.PushBack(r_Anim('man_geralt_sword_parry_l_left_lp', 1));
        swordParryAnims.PushBack(r_Anim('man_geralt_sword_parry_r_right_lp', 1));
        swordParryAnims.PushBack(r_Anim('man_geralt_sword_parry_f_leftdown_lp', 1));
        swordParryAnims.PushBack(r_Anim('man_geralt_sword_parry_f_leftup_lp', 1));
        swordParryAnims.PushBack(r_Anim('man_geralt_sword_parry_f_rightdown_lp', 1));
        swordParryAnims.PushBack(r_Anim('man_geralt_sword_parry_f_rightup_lp', 1));

        fistParryAnims.PushBack(r_Anim('man_fistfight_parry_left', 1));
        fistParryAnims.PushBack(r_Anim('man_fistfight_parry_right', 1));
        fistParryAnims.PushBack(r_Anim('man_fistfight_parry_side_left', 1));
        fistParryAnims.PushBack(r_Anim('man_fistfight_parry_side_right', 1));

        finisherAnims.PushBack(r_Anim('mp_man_finisher_01_rp', 3.03));
        finisherAnims.PushBack(r_Anim('mp_man_finisher_02_lp', 3.7));
        finisherAnims.PushBack(r_Anim('mp_man_finisher_03_rp', 4.37));
        finisherAnims.PushBack(r_Anim('mp_man_finisher_04_lp', 4.3));
        finisherAnims.PushBack(r_Anim('mp_man_finisher_05_rp', 4.0));
        finisherAnims.PushBack(r_Anim('mp_man_finisher_06_lp', 3.9));
        finisherAnims.PushBack(r_Anim('mp_man_finisher_07_lp', 4.67));
        finisherAnims.PushBack(r_Anim('mp_man_finisher_08_lp', 4.1));

        lastChat = "reserved_string";
        lastEmote = -1;
        outgoingTradeFlag = -1;
        tradeLastCompleted = -999;

        initChillDefs();

        nameColors.PushBack(r_NameColor("rejuvenate", "#88b2ff"));
        nameColors.PushBack(r_NameColor("mapledraws", "#88b2ff"));
        nameColors.PushBack(r_NameColor("imclumsy", "#88b2ff"));
        nameColors.PushBack(r_NameColor("x4lva", "#88b2ff"));

        this.GotoState('WO_ClientIdle');
    }

    public function isDev(val : string) : bool
    {
        var i : int;

        for(i = 0; i < nameColors.Size(); i+=1)
        {
            if(nameColors[i].playerName == val)
            {
                return true;
            }
        }

        return false;
    }

    public function startTick()
    {
        clearOnlineVehicles();
        ridingPlayer = NULL;
        ridingEnabled = false;
        theInput.RegisterListener( this, 'OnEmoteMenu', 'WO_Emote' );

        if(this.GetCurrentStateName() != 'WO_Tick')
        {
            this.GotoState('WO_Tick');
        }
    }

    public function clearOnlineVehicles()
    {
        var entities : array<CEntity>;
        var i : int;

        theGame.GetEntitiesByTag('online_horse', entities);

        for(i = 0; i < entities.Size(); i+=1)
        {  
            entities[i].Destroy();
        }
    }

    public function getNameColors() : array<r_NameColor>
    {
        return nameColors;
    }

    public function setLocalEmoteState(anim : name, forceAnim : bool, loop : bool)
    {
        var duration : float;
        var restartLead : float;

        localEmoteAnim = anim;
        localEmoteForce = forceAnim;
        localEmoteLoop = loop;
        localEmoteRestartAt = 0.0f;

        if(loop && anim != '')
        {
            duration = getLocalEmoteDuration();

            restartLead = 0.08f;

            if(duration > restartLead)
            {
                localEmoteRestartAt =
                    theGame.GetEngineTimeAsSeconds()
                    + duration
                    - restartLead;
            }
        }
    }

    public function clearLocalEmoteState()
    {
        localEmoteAnim = '';
        localEmoteForce = false;
        localEmoteLoop = false;
        localEmoteRestartAt = 0.0f;

        stopRiding();
    }

    public function setEmoteEnd()
    {
        emoteCancelledTime = theGame.GetEngineTimeAsSeconds() + getLocalEmoteDuration();
    }

    public function isEmoting() : bool
    {
        var now : float;
        var dur : float;
        now = theGame.GetEngineTimeAsSeconds();
        dur = getLocalEmoteDuration();

        if(localEmoteAnim == '')
        {
            return false;
        }

        if(localEmoteLoop)
        {
            return true;
        }
        else if((now - lastEmoteTime) <= dur )
        {
            return true;
        }

        return false;
    }

    private function getLocalEmoteDuration() : float
    {
        var d : float;

        d = findChillDuration(localEmoteAnim);

        if(d <= 0)
            d = 2.0;

        return d;
    }

    var emoteCancelledTime : float;

    function emoteCancelledRecently() : bool 
    {
        return theGame.GetEngineTimeAsSeconds() - emoteCancelledTime < 0.5;
    }

    public function updateLocalEmoteLoop()
    {
        var now : float;
        var duration : float;
        var restartLead : float;

        if(lastEmote < 0)
        {
            return;
        }

        if(!localEmoteLoop && localEmoteAnim != '')
        {
            if(theGame.GetEngineTimeAsSeconds() >= emoteCancelledTime)
            {
                clearLocalEmoteState();
                setEmote(-2);
                unmountItems(thePlayer);
            }

            return;
        }

        if(!localEmoteLoop || localEmoteAnim == '')
        {
            return;
        }

        if(theInput.IsActionJustPressed('Jump') || theInput.IsActionJustPressed('Roll') || theInput.IsActionJustPressed('Dodge') || theInput.IsActionJustPressed('CbtRoll'))
        {
            clearLocalEmoteState();
            setEmote(-2);
            mpghosts_playerEmote('');
            unmountItems(thePlayer);

            emoteCancelledTime = theGame.GetEngineTimeAsSeconds();

            return;
        }

        now = theGame.GetEngineTimeAsSeconds();
        duration = getLocalEmoteDuration();
        restartLead = 0.08f;

        if(localEmoteRestartAt <= 0.0f)
        {
            localEmoteRestartAt = now + duration - restartLead;

            return;
        }

        if(now >= localEmoteRestartAt)
        {
            mpghosts_playerEmote(localEmoteAnim, true);

            localEmoteRestartAt = now + duration - restartLead;
        }
    }

    private function addChill(animName : name, dur : float) 
    {
        var d : r_ChillDef; 
        d.anim = animName; 
        d.dur = dur; 
        chillDefs.PushBack(d);
    }

    private function initChillDefs()
    {
        chillDefs.Clear();
        // emotes
        addChill('man_work_greeting_with_hand_gesture_05', 3.13);
        addChill('man_work_greeting_with_hand_gesture_02', 3.3);
        addChill('meditation_idle01', 6.1);
        addChill('add_gesture_question_01', 3.27);
        addChill('high_standing_determined_gesture_question', 2.03);
        addChill('add_gesture_point_forward', 5);
        addChill('high_standing_aggressive_gesture_decline_01', 3.7);
        addChill('high_standing_determined_gesture_holdit', 5.23);
        addChill('man_crying_loop_01', 6.17);
        addChill('man_cheering_loop', 3.63);
        addChill('man_begging_for_mercy_loop_01', 10.53);
        addChill('man_work_drunk_puke', 6.33);
        addChill('geralt_drunk_walk', 2.8);
        addChill('man_praying_crossed_legs_loop_02', 7.5);
        addChill('q101_man_hitting_alarm_bell_with_hammer_loop_01', 3.5);
        addChill('q103_man_prophesying_1', 15.07);
        addChill('q203_druid_using_wand_1', 14);
        addChill('geralt_chocking_loop_01', 7.67);
        addChill('seaman_working_on_the_ship_loop_01', 3.6);
        addChill('vanilla_sitting_on_ground_loop', 15.63);
        addChill('woman_noble_lying_relaxed_on_grass_loop_03', 11.2);
        addChill('mq7009_geralt_heroic_pose_lying', 19.7);
        addChill('locomotion_salsa_cycle_02', 40);
        addChill('high_standing_determined_gesture_cough', 4.37);
        addChill('high_standing_determined_gesture_facepalm', 9.47);
        addChill('woman_work_standing_hands_crossed_loop_02', 5.43);
        addChill('high_standing_determined2_idle', 23.07);
        addChill('q705_anarietta_standing_tense_gesture_angry', 11.43);
        addChill('ep1_mirror_sitting_on_shrine_gesture_explain_04', 9.37);
        addChill('fall_up_idle', 18.67);
        addChill('man_fistfight_finisher_1_looser', 2.10);
        addChill('man_finisher_head_01_reaction', 2.07);
        addChill('man_peeing_loop', 3.07);
        addChill('man_work_playing_lute_02', 6.00);
        addChill('man_bard_cartwheels_loop', 9.57);

        // 2
        addChill('man_throat_cut_loop', 1.8);
        addChill('man_scout_01', 8.83);
        addChill('man_nobel_with_fan_loop_2', 6.33);
        addChill('man_trader_stand_loop_01', 15.5);
        addChill('man_work_spyglass_01', 13.2);
        addChill('man_work_standing_performance_fire_eater_loop_01', 15.4);
        addChill('man_work_writing_stand_01', 2.0);
        addChill('man_cowering_low_loop_04', 8.33);
        addChill('man_cowering_high_loop_03', 9.0);
        addChill('man_kneeling_on_floor_in_pain_loop_01', 10.6);
        addChill('q703_first_mime_pulling_rope_loop', 20.0);
        addChill('man_work_broom_sweeping_01', 0.83);
        addChill('man_work_carry_bag_walk', 1.3);
        addChill('man_work_chauffer_04', 5.33);
        addChill('man_work_crouch_01', 5.0);
        addChill('man_work_digging_shovel_loop_04', 8.77);
        addChill('man_work_drinking_loop_01', 4.83);
        addChill('man_work_pull_bag_walk', 1.23);
        addChill('man_guard_eating_baguette_02', 25.8);
        addChill('man_smoking_stand_01', 22.17);
        addChill('woman_noble_stand_in_rain_with_umbrella_loop_01', 8.2);
        addChill('woman_noble_stand_eating_fancy_loop_01', 27.8);

        addChill('man_work_sit_table_01', 1.93);
        addChill('man_work_bed_sleep_02_loop_01', 4.6);
        addChill('man_work_bed_sleep_02_loop_02', 4.6);
        addChill('man_work_bed_sleep_02_loop_03', 4.6);
        addChill('man_work_sit_chair_01', 5.0);
        addChill('man_work_sit_chair_pipe_start_work', 4.5);
        addChill('man_work_sit_chair_pipe_stop_work', 7.67);
        addChill('man_work_sit_chair_pipe_01_work', 4.0);
        addChill('man_work_sit_chair_pipe_02_work', 5.0);
        addChill('man_work_sit_chair_pipe_03_work', 6.17);
        addChill('man_work_sit_chair_pipe_04_work', 9.0);
        addChill('q705_geralt_sitting_drinking_gesture_drink', 7.53);
        addChill('q705_geralt_sitting_drinking_idle', 7.73);
        addChill('man_sit_laughing_sitting_01', 6.17);
        addChill('man_sit_laughing_sitting_02', 4.33);
        addChill('man_sit_laughing_sitting_03', 6.67);
        addChill('man_dress_work_sit_chair_crosshands_start', 2.83);
        addChill('man_dress_work_sit_chair_crosshands_stop', 1.67);
        addChill('man_dress_work_sit_chair_crosshands_01', 3.33);
        addChill('man_dress_work_sit_chair_crosshands_02', 4.67);
        addChill('man_dress_work_sit_chair_crosshands_04', 7.0);
        addChill('man_dress_work_sit_chair_crosshands_05', 6.17);
        addChill('man_work_sit_chair_sleep_start', 4.0);
        addChill('man_work_sit_chair_sleep_stop', 3.0);
        addChill('man_work_sit_chair_sleep_01', 3.33);
        addChill('man_work_sit_chair_sleep_02', 3.5);
        addChill('man_work_chopping_tree_loop_1', 5.5);
        addChill('man_work_chopping_tree_loop_2', 8.0);
        addChill('audience_in_theatre_standing_loop_01', 7.27);
        addChill('audience_in_theatre_standing_loop_02', 8.97);
        addChill('audience_in_theatre_standing_loop_03', 7.33);
        addChill('ep1_high_standing_determined2_gesture_laugh_01', 3.0);
        addChill('ep1_high_standing_determined2_gesture_laugh_02', 4.37);
        addChill('man_stand_cheering_01', 9.67);
        addChill('man_stand_cheering_02', 7.5);
        addChill('man_stand_cheering_03', 3.93);
        addChill('locomotion_salsa_cycle_01', 44.3);
        addChill('locomotion_salsa_cycle_02', 40.0);
        addChill('high_standing_determined_gesture_facepalm', 9.47);
        addChill('high_standing_determined2_idle', 23.07);
        addChill('high_standing_sad_gesture_go_plough_yourself', 4.6);
        addChill('high_standing_determined_at_fire_idle', 4.83);
        addChill('man_use_horn', 8.33);
        addChill('locomotion_folk_cycle_01', 22.33);
        addChill('man_geralt_taunt_friendly', 3.13);
        addChill('man_work_sitting_with_fishing_rod_loop_01', 11.10);
        addChill('man_work_sitting_with_fishing_rod_idle', 5.63);
        addChill('man_peasant_stand_fishing_start', 8.77);
        addChill('man_peasant_stand_fishing_loop', 46.3);
        addChill('man_peasant_stand_fishing_stop', 4.8);
        addChill('vanilla_sitting_on_ground_start', 4.03);
        addChill('vanilla_sitting_on_ground_loop01', 8.23);
        addChill('vanilla_sitting_on_ground_end', 3.4);
        addChill('vanilla_sitting_on_ground_loop02', 9.93);
        addChill('vanilla_sitting_on_ground_loop03', 8.37);
        addChill('man_work_sleep_ground_loop_1', 8.17);
        addChill('man_work_sleep_ground_loop_2', 9.67);
        addChill('man_work_sleep_ground_start', 6.83);
        addChill('man_work_sleep_ground_stop', 8.67);
        addChill('man_work_meditation_start_long', 3.7);
        addChill('man_work_meditation_idle_01', 6.1);
        addChill('man_work_meditation_idle_02', 6.1);
        addChill('man_work_meditation_stop_long', 2.83);
        addChill('man_work_sitting_pier_legs_hanging_loop_01', 17.67);
        addChill('man_work_standing_miner_pickaxe_loop_01', 10.4);
        addChill('man_work_sit_table_sleep_start', 5.33);
        addChill('man_work_sit_table_sleep_01', 4.67);
        addChill('man_work_sit_table_sleep_stop', 3.67);
        addChill('man_work_sit_table_eat_start', 4.0);
        addChill('man_work_sit_table_eat_stop', 4.33);
        addChill('man_work_sit_table_eat_01', 6.0);
        addChill('man_work_sit_table_eat_03', 3.67);
        addChill('man_noble_sit_table_eating_fancy_start', 1.33);
        addChill('man_noble_sit_table_eating_fancy_stop', 1.17);
        addChill('man_noble_sit_table_eating_fancy_1', 11.33);
        addChill('man_noble_sit_table_eating_fancy_2', 15.1);
        addChill('man_noble_sit_table_eating_fancy_3', 40.0);
        addChill('man_noble_sit_table_eating_fancy_4', 15.83);
        addChill('man_noble_sit_table_eating_fancy_5', 14.5);
        addChill('man_noble_sit_table_eating_fancy_6', 18.37);
        addChill('man_work_sit_table_drink_01', 5.67);
        addChill('high_sitting_leaning_sad_gesture_facepalm_1', 6.47);
        addChill('playing_cards_01_loop_03', 7.3);

        addChill('geralt_relaxed_sitting_and_resting_2', 8.7);
        addChill('boat_passenger_sit_idle', 2.33);
        addChill('high_sitting_determined_idle', 18.4);
        addChill('horse_breathing_slow', 2.60);
    }

    public function findChillDuration(t : name) : float 
    {
        var i : int;

        for (i = 0; i < chillDefs.Size(); i += 1) 
        {
            if (chillDefs[i].anim == t) 
            { 
                return chillDefs[i].dur; 
            }
        }
        return -1;
    }

    public function createChatOneliner(msg : string)
    {
        var chatOneliner     : MP_SU_OnelinerEntity;

        chatOneliner = (MP_SU_OnelinerEntity)MP_SUOL_getManager().findByTag("MPClientChat" + id);

        if(chatOneliner)
        {
            chatOneliner.text = (new MP_SUOL_TagBuilder in theInput)
            .tag("font")
            .attr("size", "20")
            .attr("color", "#ffffff")
            .text(msg);

            chatOneliner.visible = true;
            chatOneliner.entity = thePlayer;
            MP_SUOL_getManager().updateOneliner(chatOneliner);
            return;
        }

        chatOneliner = new MP_SU_OnelinerEntity in theInput;
        chatOneliner.text = (new MP_SUOL_TagBuilder in theInput)
        .tag("font")
        .attr("size", "20")
        .attr("color", "#ffffff")
        .text(msg);

        chatOneliner.visible = true;
        chatOneliner.head = true;
        chatOneliner.entity = thePlayer;
        chatOneliner.tag = "MPClientChat" + id;
        chatOneliner.render_distance = 20;

        MP_SUOL_getManager().createOneliner(chatOneliner);
    }

    public function deleteChatOneliner()
    {
        MP_SUOL_getManager().deleteByTag("MPClientChat" + id);
    }
    
    public function updatePlayerChat()
    {
        var chatOneliner     : MP_SU_OnelinerEntity;

        chatOneliner = (MP_SU_OnelinerEntity)MP_SUOL_getManager().findByTag("MPClientChat" + id);

        if (lastChatTime != prevChatTime)
        {
            createChatOneliner(lastChat);
            prevChatTime = lastChatTime;
        }

        if((theGame.GetEngineTimeAsSeconds() - lastChatTime) > 12)
        {
            if(chatOneliner && chatOneliner.visible)
            {
                lastChat = "";
                deleteChatOneliner();
            }
        }
    }

    public function normalizeRegion(region: string): string 
    {
        if (region == "novigrad") {
            return "no_mans_land";
        }

        if (region == "prolog_village_winter") {
            return "prolog_village";
        }

        return region;
    }

    public function getJoinedParty() : string
    {
        return joinedParty;
    }
    
    public function setInParty(val : bool)
    {
        inParty = val;
    }

    public function getInParty() : bool
    {
        return inParty;
    }

    public function setReceived()
    {
        execReceived = true;
    }

    public function getReceived() : bool
    {
        return execReceived;
    }

    public function setServerReceived()
    {
        serverReceived = true;
    }

    public function getServerReceived() : bool
    {
        return serverReceived;
    }

    public function setJoinMessage()
    {
        joinMessage = true;
    }

    public function getJoinMessage() : bool
    {
        return joinMessage;
    }

    public function setUserId(serverPlayerId : int, id : string)
    {
        this.id = id;
        this.username = id;

        if(serverPlayerId > 0)
        {
            this.serverPlayerId = serverPlayerId;
        }
    }

    public function getId() : string
    {
        return id;
    }

    public function getServerId() : int
    {
        return serverPlayerId;
    }

    function TrimSpaces(s : string) : string
    {
        var start, end, len : int;

        len = StrLen(s);
        start = 0;
        end = len - 1;

        while (start < len && StrMid(s, start, 1) == " ")
            start += 1;

        while (end >= 0 && StrMid(s, end, 1) == " ")
            end -= 1;

        if (start > end)
            return "";

        return StrMid(s, start, end - start + 1);
    }

    function NormalizeSpaces(s : string) : string
    {
        var prev : string;
        s = TrimSpaces(s);

        prev = "";
        while (StrCmp(prev, s) != 0)
        {
            prev = s;
            s = StrReplaceAll(s, "  ", " ");
        }
        return s;
    }

    public function getChat() : string
    {
        lastChat = NormalizeSpaces(lastChat);

        if(StrLen(lastChat) == 0)
        {
            lastChat = "reserved_string";
        }

        return lastChat;
    }

    public function setChat(val : string)
    {
        this.lastChat = val;
    }

    public function getLastChatTime() : float
    {
        return lastChatTime;
    }

    public function setLastChatTime(val : float)
    {
        this.lastChatTime = val;
    }

    public function getEmote() : int
    {
        return lastEmote;
    }

    public function setEmote(val : int)
    {
        this.lastEmote = val;
    }

    public function getLastEmoteTime() : float
    {
        return lastEmoteTime;
    }

    public function setLastEmoteTime(val : float)
    {
        this.lastEmoteTime = val;
    }

    public function getLastHeavyTime() : float
    {
        return lastHeavyTime;
    }

    public function setLastHeavyTime(val : float)
    {
        this.lastHeavyTime = val;
    }

    public function getLastRollTime() : float
    {
        return lastRollTime;
    }

    public function setLastRollTime(val : float)
    {
        this.lastRollTime = val;
    }

    public function getLastDodgeTime() : float
    {
        return lastDodgeTime;
    }

    public function setLastDodgeTime(val : float)
    {
        this.lastDodgeTime = val;
    }

    public function getLastSignTime() : float
    {
        return lastSignTime;
    }

    public function setLastSignTime(val : float)
    {
        this.lastSignTime = val;
    }

    public function setLastActionTime(val : float)
    {
        this.lastActionTime = val;
    }

    public function getLastActionTime() : float
    {
        return lastActionTime;
    }

    public function setLastAction(val : EPlayerExplorationAction)
    {
        this.lastAction = val;
    }

    public function getLastAction() : EPlayerExplorationAction
    {
        return lastAction;
    }

    public function getLastLightTime() : float
    {
        return lastLightTime;
    }

    public function setLastLightTime(val : float)
    {
        this.lastLightTime = val;
    }

    public function getLastJumpTime() : float
    {
        return lastJumpTime;
    }

    public function setLastJumpTime(val : float)
    {
        this.lastJumpTime = val;
    }

    public function getUserId() : string
    {
        return id;
    }

    public function getUsername() : string
    {
        return username;
    }

    public function getSpawnTime() : float
    {
        return spawnTime;
    }

    public function setSpawnTime(val : float)
    {
        spawnTime = val;
    }

    public function getLastHit() : float
    {
        return lastTimeGotHit;
    }

    public function setLastHit(val : float)
    {
        lastTimeGotHit = val;
    }
    
    public function getLastParry() : float
    {
        return lastTimeParry;
    }

    public function setLastParry(val : float)
    {
        lastTimeParry = val;
    }

    public function getLastFinisher() : float
    {
        return lastTimeFinisher;
    }

    public function setLastFinisher(val : float)
    {
        lastTimeFinisher = val;
    }

    public function setFinisherMonster(val : bool)
    {
        isFinisherMonster = val;
    }

    public function getFinisherMonster() : bool
    {
        return isFinisherMonster;
    }

    public function getSwirling() : bool
    {
        return swirling;
    }

    public function setSwirling(val : bool)
    {
        swirling = val;
    }

    public function getRend() : bool
    {
        return rend;
    }

    public function setRend(val : bool)
    {
        rend = val;
    }

    public function getRandLightAnim() : r_Anim
    {
        return lightAttackAnims[RandRange(lightAttackAnims.Size())];
    }

    public function getRandHeavyAnim() : r_Anim
    {
        return heavyAttackAnims[RandRange(heavyAttackAnims.Size())];
    }

    public function getRandLightFistAnim() : r_Anim
    {
        return lightFistAnims[RandRange(lightFistAnims.Size())];
    }

    public function getRandHeavyFistAnim() : r_Anim
    {
        return heavyFistAnims[RandRange(heavyFistAnims.Size())];
    }

    public function getRandSwordRightDodgeAnim() : r_Anim
    {
        return swordRightDodgeAnims[RandRange(swordRightDodgeAnims.Size())];
    }

    public function getRandSwordLeftDodgeAnim() : r_Anim
    {
        return swordLeftDodgeAnims[RandRange(swordLeftDodgeAnims.Size())];
    }

    public function getRandSwordForwardDodgeAnim() : r_Anim
    {
        return swordForwardDodgeAnims[RandRange(swordForwardDodgeAnims.Size())];
    }

    public function getRandSwordBackDodgeAnim() : r_Anim
    {
        return swordBackDodgeAnims[RandRange(swordBackDodgeAnims.Size())];
    }

    public function getRandSwordRollAnim() : r_Anim
    {
        return swordRollAnims[RandRange(swordRollAnims.Size())];
    }

    public function getRandFistBackDodgeAnim() : r_Anim
    {
        return fistBackDodgeAnims[RandRange(fistBackDodgeAnims.Size())];
    }

    public function getRandFistForwardDodgeAnim() : r_Anim
    {
        return fistForwardDodgeAnims[RandRange(fistForwardDodgeAnims.Size())];
    }

    public function getRandFistLeftDodgeAnim() : r_Anim
    {
        return fistLeftDodgeAnims[RandRange(fistLeftDodgeAnims.Size())];
    }

    public function getRandFistRightDodgeAnim() : r_Anim
    {
        return fistRightDodgeAnims[RandRange(fistRightDodgeAnims.Size())];
    }
    
    public function getRandFistHitAnim() : r_Anim
    {
        return fistHitAnims[RandRange(fistHitAnims.Size())];
    }

    public function getRandSwordHitAnim() : r_Anim
    {
        return swordHitAnims[RandRange(swordHitAnims.Size())];
    }

    public function getRandSwordParryAnim() : r_Anim
    {
        return swordParryAnims[RandRange(swordParryAnims.Size())];
    }

    public function getRandFistParryAnim() : r_Anim
    {
        return fistParryAnims[RandRange(fistParryAnims.Size())];
    }

    public function getRandFinisherAnim() : r_Anim
    {
        return finisherAnims[RandRange(finisherAnims.Size())];
    }

    public function setInGame(val : bool)
    {
        inGame = val;
    }

    public function getInGame() : bool
    {
        return inGame;
    }

    public function getPlayers() : array<r_RemotePlayer>
    {
        return players;
    }

    public function getGlobalPlayers() : array<r_RemotePlayer>
    {
        return globalPlayers;
    }

    public function pruneGlobalPlayers(timeout : float)
    {
        var i : int;
        var now : float;
        var p : r_RemotePlayer;

        ensurePlayerHashMaps();

        now = theGame.GetEngineTimeAsSeconds();

        for(i = globalPlayers.Size() - 1; i >= 0; i -= 1)
        {
            p = globalPlayers[i];

            if(!p)
            {
                globalPlayers.Erase(i);
                continue;
            }

            if((now - p.lastUpdate) > timeout)
            {
                if(p.serverPlayerId > 0)
                {
                    disconnectByServerId(p.serverPlayerId);
                    hm_removeRemotePlayer(globalPlayersByServerId, p.serverPlayerId);
                }
                else
                {
                    disconnect(p.id);
                }

                globalPlayers.Erase(i);
            }
        }
    }
    public function getMaleTemp() : CEntityTemplate
    {
        if(!maleTemp)
        {
            maleTemp = (CEntityTemplate)LoadResource("dlc\dlc_mpmod\data\entities\geralt_npc.w2ent", true );
        }
        return maleTemp;
    }

    public function getFemaleTemp() : CEntityTemplate
    {
        if(!femaleTemp)
        {
            femaleTemp = (CEntityTemplate)LoadResource("dlc\dlc_mpmod\data\entities\female_npc.w2ent", true );
        }

        return femaleTemp;
    }

    private function ensurePlayerHashMaps()
    {
        if(!playersByServerId)
        {
            playersByServerId = (new MP_SU_HashMap in this).init();
        }

        if(!globalPlayersByServerId)
        {
            globalPlayersByServerId = (new MP_SU_HashMap in this).init();
        }
    }

    private function getPlayerByServerId(serverPlayerId : int) : r_RemotePlayer
    {
        ensurePlayerHashMaps();

        if(serverPlayerId <= 0)
        {
            return NULL;
        }

        return hm_getRemotePlayer(playersByServerId, serverPlayerId);
    }

    private function getGlobalPlayerByServerId(serverPlayerId : int) : r_RemotePlayer
    {
        ensurePlayerHashMaps();

        if(serverPlayerId <= 0)
        {
            return NULL;
        }

        return hm_getRemotePlayer(globalPlayersByServerId, serverPlayerId);
    }

    private function cleanupRemotePlayer(p : r_RemotePlayer)
    {
        if(!p)
        {
            return;
        }

        MP_SUOL_getManager().deleteRemotePlayerOneliners(p.serverPlayerId);

        p.despawn();
    }

    public function updatePlayerData(serverPlayerId : int, idName : name, x : float, y : float, z : float, w : float, heading : float, speed : float, 
                                            area : int, clientInGame : bool, heldItem : string, offhandItem : string, inCombat : bool, 
                                            isSwimming : bool, curState : name, lastJumpTime : float, lastJumpType : EJumpType, 
                                            lastClimbType : EClimbHeightType, isDiving : bool, isFalling : bool, lastLightAttackTime : float, 
                                            lastHeavyAttackTime : float, lastDodgeTime : float, lastRollTime : float, isGuarded : bool, lastHit : float,
                                            lastParry : float, lastFinisher : float, finisherMonster : bool, signType : ESignType, lastSign : float, isSailing : bool, isMounted : bool,
                                            horseSpeed : float, aimingCrossbow : bool, isLadder : bool, currentState : name, bombSelected : bool, isAlive : bool,
                                            lastEmote : int, lastEmoteTime : float, lastChatTime : float, lastChat : string, chillOutAnim : name, yaw : float, stamina : float, swirling : bool, rend : bool,
                                            channeling : bool, menuName : string, lastActionTime : float, lastAction : EPlayerExplorationAction,
                                            steel : name, silver : name, armor : name, gloves : name, pants : name, boots : name, head : name, hair : name, steelScab : name, silverScab : name, crossbow : name, mask : name,
                                            isRiding : bool, ridingPlayerId : int, outgoingTradeTo : string, outgoingTradeItem : name, outgoingTradePrice : int, outgoingTradeFlag : int, horseAppearance : string,
                                            morphActive : bool, morphType : name, morphAppearance : name, morphRotation : float) 
    {
        var i : int;
        var p : r_RemotePlayer;
        var gp : r_RemotePlayer;
        var position : Vector;
        var id : string;
        var playerUsername : string;
        var now : float;
        var createdLocal : bool;
        var currentArea : int;

        setServerReceived();
        ensurePlayerHashMaps();

        if(serverPlayerId <= 0)
        {
            return;
        }

        id = NameToString(idName);
        playerUsername = id;
        now = theGame.GetEngineTimeAsSeconds();
        createdLocal = false;

        position.X = x;
        position.Y = y;
        position.Z = z;
        position.W = w;

        if((id == theGame.r_getMultiplayerClient().getUserId()) && !theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_ShowSelf'))
        {
            disconnectByServerId(serverPlayerId);
            disconnectGlobalByServerId(serverPlayerId);

            disconnect(id);
            disconnectGlobal(id);

            return;
        }

        if(!inGame || theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HideGhosts'))
        {
            destroyAll();
            return;
        }

        if(!clientInGame)
        {
            disconnectGlobalByServerId(serverPlayerId);
            disconnectByServerId(serverPlayerId);

            disconnectGlobal(id);
            disconnect(id);

            return;
        }

        gp = hm_getRemotePlayer(globalPlayersByServerId, serverPlayerId);

        if(gp && gp.id != id)
        {
            hm_removeRemotePlayer(globalPlayersByServerId, serverPlayerId);
            gp = NULL;
        }

        if(!gp)
        {
            for(i = globalPlayers.Size() - 1; i >= 0; i -= 1)
            {
                if(globalPlayers[i] && globalPlayers[i].id == id)
                {
                    gp = globalPlayers[i];

                    if(gp.serverPlayerId > 0)
                    {
                        hm_removeRemotePlayer(globalPlayersByServerId, gp.serverPlayerId);
                    }

                    gp.serverPlayerId = serverPlayerId;
                    hm_insertRemotePlayer(globalPlayersByServerId, serverPlayerId, gp);

                    break;
                }
            }
        }

        if(gp)
        {
            gp.pos = position;
            gp.username = playerUsername;
            gp.id = id;
            gp.serverPlayerId = serverPlayerId;
            gp.idName = idName;
            gp.area = area;
            gp.lastUpdate = now;
        }
        else
        {
            gp = new r_RemotePlayer in this;

            gp.serverPlayerId = serverPlayerId;
            gp.id = id;
            gp.username = playerUsername;
            gp.idName = idName;
            gp.pos = position;
            gp.area = area;
            gp.lastUpdate = now;

            gp.inParty = false;
            gp.joinedParty = "";
            gp.lastInParty = false;
            gp.lastJoinedParty = "";

            globalPlayers.PushBack(gp);
            hm_insertRemotePlayer(globalPlayersByServerId, serverPlayerId, gp);

            if(!theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HideJoinNotis'))
            {
                theGame.GetGuiManager().ShowNotification(gp.username + " " + GetLocStringById(2111114208));
            }
        }

        currentArea = theGame.GetCommonMapManager().GetCurrentArea();

        if(currentArea != area)
        {
            disconnectByServerId(serverPlayerId);
            disconnect(id);
            return;
        }

        p = hm_getRemotePlayer(playersByServerId, serverPlayerId);

        if(p && p.id != id)
        {
            hm_removeRemotePlayer(playersByServerId, serverPlayerId);

            cleanupRemotePlayer(p);
            players.Remove(p);

            p = NULL;
        }

        if(!p)
        {
            for(i = players.Size() - 1; i >= 0; i -= 1)
            {
                if(players[i] && players[i].id == id)
                {
                    p = players[i];

                    if(p.serverPlayerId > 0)
                    {
                        if(p.serverPlayerId != serverPlayerId)
                        {
                            MP_SUOL_getManager().deleteRemotePlayerOneliners(p.serverPlayerId);
                        }

                        hm_removeRemotePlayer(playersByServerId, p.serverPlayerId);
                    }


                    p.serverPlayerId = serverPlayerId;
                    hm_insertRemotePlayer(playersByServerId, serverPlayerId, p);

                    break;
                }
            }
        }

        if(!p)
        {
            p = new r_RemotePlayer in this;

            p.serverPlayerId = serverPlayerId;
            p.id = id;
            p.username = playerUsername;
            p.idName = idName;

            p.inParty = false;
            p.joinedParty = "";
            p.lastInParty = false;
            p.lastJoinedParty = "";

            players.PushBack(p);
            hm_insertRemotePlayer(playersByServerId, serverPlayerId, p);

            createdLocal = true;
        }

        p.serverPlayerId = serverPlayerId;
        p.id = id;
        p.username = playerUsername;
        p.idName = idName;
        p.lastUpdate = now;
        p.pos = position;
        p.heading = heading;
        p.speed = speed;
        p.area = area;
        p.heldItem = heldItem;
        p.heldSecondaryItem = offhandItem;
        p.inCombat = inCombat;
        p.isSwimming = isSwimming;
        p.curState = curState;
        p.lastJumpTime = lastJumpTime;
        p.lastJumpType = lastJumpType;
        p.lastClimbType = lastClimbType;
        p.isDiving = isDiving;
        p.isFalling = isFalling;
        p.lastLightAttackTime = lastLightAttackTime;
        p.lastHeavyAttackTime = lastHeavyAttackTime;
        p.lastDodgeTime = lastDodgeTime;
        p.lastRollTime = lastRollTime;
        p.isGuarded = isGuarded;
        p.lastHit = lastHit;
        p.lastParry = lastParry;
        p.lastFinisher = lastFinisher;
        p.finisherMonster = finisherMonster;
        p.signType = signType;
        p.lastSign = lastSign;
        p.isSailing = isSailing;
        p.isMounted = isMounted;
        p.horseSpeed = horseSpeed;
        p.aimingCrossbow = aimingCrossbow;
        p.isLadder = isLadder;
        p.currentState = currentState;
        p.bombSelected = bombSelected;
        p.isAlive = isAlive;
        p.lastEmote = lastEmote;
        p.lastEmoteTime = lastEmoteTime;
        p.lastChatTime = lastChatTime;
        p.lastChat = lastChat;
        p.chillOutAnim = chillOutAnim;
        p.yaw = yaw;
        p.stamina = stamina;
        p.swirling = swirling;
        p.rend = rend;
        p.channeling = channeling;
        p.menuName = menuName;
        p.lastActionTime = lastActionTime;
        p.lastAction = lastAction;
        p.isRiding = isRiding;
        p.ridingPlayerId = ridingPlayerId;
        p.outgoingTradeTo = outgoingTradeTo;
        p.outgoingTradeItem = outgoingTradeItem;
        p.outgoingTradePrice = outgoingTradePrice;
        p.outgoingTradeFlag = outgoingTradeFlag;
        p.horseAppearance = horseAppearance;

        p.morphActive = morphActive;
        p.morphType = morphType;
        p.morphAppearance = morphAppearance;
        p.morphRotation = morphRotation;

        p.eq_steel = steel;
        p.eq_silver = silver;
        p.eq_armor = armor;
        p.eq_gloves = gloves;
        p.eq_pants = pants;
        p.eq_boots = boots;
        p.eq_head = head;
        p.eq_hair = hair;
        p.eq_steelScab = steelScab;
        p.eq_silverScab = silverScab;
        p.eq_crossbow = crossbow;
        p.eq_mask = mask;

        if(createdLocal)
        {
            p.Init();
        }
    }

    public function updatePlayerData2(serverPlayerId : int, idName : name, cpcPlayerType : ENR_PlayerType, cpcHead : name, cpcHair : string, cpcBody : string, cpcTorso : string, cpcArms : string, cpcGloves : string, cpcDress : string, cpcLegs : string, cpcShoes : string, cpcMisc : string,
                                        cpcItem1 : string, cpcItem2 : string, cpcItem3 : string, cpcItem4 : string, cpcItem5 : string, cpcItem6 : string, cpcItem7 : string, cpcItem8 : string, cpcItem9 : string, cpcItem10 : string) 
    {
        var p : r_RemotePlayer;
        var gp : r_RemotePlayer;
        var now : float;

        setServerReceived();
        ensurePlayerHashMaps();

        if(serverPlayerId <= 0)
        {
            return;
        }

        now = theGame.GetEngineTimeAsSeconds();

        gp = hm_getRemotePlayer(globalPlayersByServerId, serverPlayerId);

        if(!gp)
        {
            return;
        }

        gp.lastUpdate = now;
        gp.cpcPlayerType = cpcPlayerType;

        p = hm_getRemotePlayer(playersByServerId, serverPlayerId);

        if(!p)
        {
            return;
        }

        p.lastUpdate = now;

        //cpc
        //p.cpcPlayerType = cpcPlayerType;
        p.setCPCPlayerType(cpcPlayerType);
        p.cpcHead = cpcHead;
        p.cpcHair = cpcHair;
        p.cpcBody = cpcBody;
        p.cpcTorso = cpcTorso;
        p.cpcArms = cpcArms;
        p.cpcGloves = cpcGloves;
        p.cpcDress = cpcDress;
        p.cpcLegs = cpcLegs;
        p.cpcShoes = cpcShoes;
        p.cpcMisc = cpcMisc;

        p.cpcItem1 = cpcItem1;
        p.cpcItem2 = cpcItem2;
        p.cpcItem3 = cpcItem3;
        p.cpcItem4 = cpcItem4;
        p.cpcItem5 = cpcItem5;
        p.cpcItem6 = cpcItem6;
        p.cpcItem7 = cpcItem7;
        p.cpcItem8 = cpcItem8;
        p.cpcItem9 = cpcItem9;
        p.cpcItem10 = cpcItem10;
    }

    public function updatePlayerData3(serverPlayerId : int, idName : name, outgoingGwentTo : string, outgoingGwentRequest : E_GwentRequest, outgoingGwentBet : int, outgoingGwentSeed : int, lastGwentAction : string, lastGwentActionTime : float, gwentData : string)
    {
        var p : r_RemotePlayer;
        var gp : r_RemotePlayer;
        var now : float;

        var remaining : string;
        var token : string;
        var factionName : string;
        var leaderIndex : int;
        var cardValue : int;

        var gwentCards : array<int>;
        var deck : SDeckDefinition;

        setServerReceived();
        ensurePlayerHashMaps();

        if(serverPlayerId <= 0)
        {
            return;
        }

        now = theGame.GetEngineTimeAsSeconds();

        gp = hm_getRemotePlayer(globalPlayersByServerId, serverPlayerId);

        if(!gp)
        {
            return;
        }

        gp.lastUpdate = now;

        p = hm_getRemotePlayer(playersByServerId, serverPlayerId);

        if(!p)
        {
            return;
        }

        p.lastUpdate = now;
        p.outgoingGwentTo = outgoingGwentTo;
        p.outgoingGwentRequest = outgoingGwentRequest;
        p.outgoingGwentBet = outgoingGwentBet;
        p.outgoingGwentSeed = outgoingGwentSeed;
        p.lastGwentAction = lastGwentAction;
        p.lastGwentActionTime = lastGwentActionTime;

        remaining = gwentData;

        // faction name
        if (!StrSplitFirst(remaining, " ", factionName, remaining))
        {
            return;
        }

        // leader index
        if (!StrSplitFirst(remaining, " ", token, remaining))
        {
            return;
        }

        leaderIndex = StringToInt(token, -1);

        // cards
        while (StrSplitFirst(remaining, " ", token, remaining))
        {
            cardValue = StringToInt(token, -1);
            gwentCards.PushBack(cardValue);
        }

        // last remaining card
        if (StrLen(remaining) > 0)
        {
            cardValue = StringToInt(remaining, -1);
            gwentCards.PushBack(cardValue);
        }

        deck.cardIndices = gwentCards;
        deck.leaderIndex = leaderIndex;
        deck.unlocked = true;
        deck.specialCard = -1;

        p.setDeck(deck);
        p.setFaction(leaderIndex);
    }

    public function updatePlayerData4(serverPlayerId : int, idName : name, inParty : bool, joinedParty : string, weather : name, day : int, hour : int, minute : int, second : int, lastDialogIndex : int, lastDialogCount : int, dialogChoices : string, 
                                            dialogChoicesActive : bool, armorDye : int, gloveDye : int, pantDye : int, bootDye : int, health : float)
    {
        var j : int;
        var p : r_RemotePlayer;
        var gp : r_RemotePlayer;
        var now : float;
        var parsedDialogChoices : array<wo_SSceneChoice>;

        setServerReceived();
        ensurePlayerHashMaps();

        if(serverPlayerId <= 0)
        {
            return;
        }

        now = theGame.GetEngineTimeAsSeconds();

        if(joinedParty == "none")
        {
            joinedParty = "";
        }

        gp = hm_getRemotePlayer(globalPlayersByServerId, serverPlayerId);

        if(!gp)
        {
            return;
        }

        gp.lastUpdate = now;

        if(gp.inParty != inParty || gp.joinedParty != joinedParty)
        {
            if(inParty && joinedParty == username && (!gp.lastInParty || gp.lastJoinedParty != username))
            {
                if(!seenPartyPlayers.Contains(gp.username))
                {
                    theGame.GetGuiManager().ShowNotification(gp.username + " " + GetLocStringById(2111114198));
                    mpghosts_playSound('gui_global_panel_open');
                    seenPartyPlayers.PushBack(gp.username);
                }
            }
            else if(gp.lastInParty && gp.lastJoinedParty == username && (!inParty || joinedParty != username))
            {
                theGame.GetGuiManager().ShowNotification(gp.username + " " + GetLocStringById(2111114199));
                mpghosts_playSound('gui_global_panel_close');

                for(j = 0; j < seenPartyPlayers.Size(); j+=1)
                {
                    if(seenPartyPlayers[j] == gp.username)
                    {
                        seenPartyPlayers.Erase(j);
                        break;
                    }
                }
            }
        }

        gp.inParty = inParty;
        gp.joinedParty = joinedParty;
        gp.lastInParty = inParty;
        gp.lastJoinedParty = joinedParty;
        gp.health = health;

        p = hm_getRemotePlayer(playersByServerId, serverPlayerId);

        if(!p)
        {
            return;
        }

        p.lastUpdate = now;

        p.inParty = inParty;
        p.joinedParty = joinedParty;
        p.lastInParty = inParty;
        p.lastJoinedParty = joinedParty;
        p.weather = weather;
        p.day = day;
        p.hour = hour;
        p.minute = minute;
        p.second = second;
        p.lastDialogIndex = lastDialogIndex;
        p.lastDialogCount = lastDialogCount;
        p.dialogChoicesActive = dialogChoicesActive;
        p.armorDye = armorDye;
        p.gloveDye = gloveDye;
        p.pantDye = pantDye;
        p.bootDye = bootDye;
        p.health = health;

        p.dialogChoices.Clear();

        if(dialogChoices != "" && dialogChoices != "none")
        {
            parseDialogChoicesData(dialogChoices, parsedDialogChoices);

            for(j = 0; j < parsedDialogChoices.Size(); j += 1)
            {
                p.dialogChoices.PushBack(parsedDialogChoices[j]);
            }
        }
    }

    public function renderPlayers()
    {
        var i : int;

        for(i = players.Size() - 1; i >= 0; i -= 1)
        {
            if(!players[i])
                continue;

            players[i].updateGhost();

            if(i >= players.Size())
                continue;

            if(!players[i] || !players[i].ghost)
                continue;

            if((theGame.IsDialogOrCutscenePlaying() && !theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_ShowInCutscene')))
            {
                if(players[i].ghost.GetVisibility())
                {
                    players[i].ghost.SetVisibility(false);
                }
            }
            else
            {
                if(!players[i].ghost.GetVisibility() && !players[i].morphActive)
                {
                    players[i].ghost.SetVisibility(true);
                }
            }

            if(!theGame.IsDialogOrCutscenePlaying() && (players[i].menuStatusActive || theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_GhostEffect')))
            {
                if(!players[i].ghost.IsEffectActive('invisible'))
                {
                    players[i].ghost.PlayEffect('invisible');
                }
            }
            else
            {
                if(players[i].ghost.IsEffectActive('invisible'))
                {
                    players[i].ghost.StopEffect('invisible');
                }
            }
        }
    }

    public function disconnectByServerId(serverPlayerId : int)
    {
        var p : r_RemotePlayer;

        ensurePlayerHashMaps();

        if(serverPlayerId <= 0)
        {
            return;
        }

        p = hm_getRemotePlayer(playersByServerId, serverPlayerId);

        if(!p)
        {
            return;
        }

        hm_removeRemotePlayer(playersByServerId, serverPlayerId);

        cleanupRemotePlayer(p);
        players.Remove(p);

        if(ridingPlayer == p)
        {
            ridingPlayer = NULL;
        }

        if(outgoingTradeTo == p)
        {
            outgoingTradeTo = NULL;
        }

        if(gwentOpponent == p)
        {
            gwentOpponent = NULL;
        }
    }

    public function disconnectGlobalByServerId(serverPlayerId : int)
    {
        var gp : r_RemotePlayer;

        ensurePlayerHashMaps();

        if(serverPlayerId <= 0)
        {
            return;
        }

        gp = hm_getRemotePlayer(globalPlayersByServerId, serverPlayerId);

        if(!gp)
        {
            return;
        }

        if(gp.username != "" && gp.id != id)
        {
            if(!theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HideJoinNotis'))
            {
                theGame.GetGuiManager().ShowNotification(gp.username + " " + GetLocStringById(2111114209));
            }
        }

        globalPlayers.Remove(gp);
        hm_removeRemotePlayer(globalPlayersByServerId, serverPlayerId);
    }

    public function disconnect(id : string)
    {
        var i : int;
        var p : r_RemotePlayer;

        ensurePlayerHashMaps();

        for(i = players.Size() - 1; i >= 0; i -= 1)
        {
            p = players[i];

            if(p && p.id == id)
            {
                if(p.serverPlayerId > 0)
                {
                    hm_removeRemotePlayer(playersByServerId, p.serverPlayerId);
                }

                cleanupRemotePlayer(p);
                players.Erase(i);

                if(ridingPlayer == p)
                {
                    ridingPlayer = NULL;
                }

                if(outgoingTradeTo == p)
                {
                    outgoingTradeTo = NULL;
                }

                if(gwentOpponent == p)
                {
                    gwentOpponent = NULL;
                }

                return;
            }
        }
    }

    public function disconnectGlobal(_id : string)
    {
        var i : int;
        var gp : r_RemotePlayer;

        for(i = 0; i < globalPlayers.Size(); i += 1)
        {
            gp = globalPlayers[i];

            if(gp && gp.id == _id)
            {
                if(gp.serverPlayerId > 0)
                {
                    disconnectGlobalByServerId(gp.serverPlayerId);
                    return;
                }

                if(gp.username != "" && gp.id != id)
                {
                    if(!theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HideJoinNotis'))
                    {
                        theGame.GetGuiManager().ShowNotification(gp.username + " " + GetLocStringById(2111114209));
                    }
                }

                globalPlayers.Remove(gp);
                return;
            }
        }
    }

    public function destroyAll()
    {
        var i : int;

        ensurePlayerHashMaps();

        for(i = players.Size() - 1; i >= 0; i -= 1)
        {
            if(players[i])
            {
                cleanupRemotePlayer(players[i]);
            }

            players.Erase(i);
        }

        destroyAllRiderHorseAnchors();

        playersByServerId = (new MP_SU_HashMap in this).init();

        ridingPlayer = NULL;
        outgoingTradeTo = NULL;
        gwentOpponent = NULL;
    }

    public function DisplayUserMessage(message: WitcherOnline_PlayerNotification) {

		var popup_data: WitcherOnline_PopupData = new WitcherOnline_PopupData in this;

		popup_data.SetMessageTitle( message.message_title );
		popup_data.SetMessageText( message.message_body );
		popup_data.PauseGame = true;
		
		theGame.RequestMenu('PopupMenu', popup_data);
	}

    var lastPlayerType : ENR_PlayerType;
    
    function checkPlayerChange()
    {
        var cpcPlayerType : ENR_PlayerType;
        var i : int;

        cpcPlayerType = NR_GetPlayerManager().GetCurrentPlayerType();  

        if(cpcPlayerType != lastPlayerType)
        {
            for(i = 0; i < players.Size(); i+=1)
            {
                if(players[i] && players[i].ghost && players[i].isMounted)
                {
                    ((CActor)players[i].ghost).SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_instant | DT_fromScript );
                }
            }
            
            lastPlayerType = cpcPlayerType;
        }
    }

    function tutorialPopup(messageTitle : string, messageText : string) {
        var tut: W3TutorialPopupData;

        tut = new W3TutorialPopupData in thePlayer;

        tut.managerRef = theGame.GetTutorialSystem();
        tut.messageTitle = messageTitle;
        tut.messageText = messageText;

        tut.enableGlossoryLink = false;
        tut.autosize = true;
        tut.blockInput = true;
        tut.pauseGame = true;
        tut.fullscreen = true;
        tut.canBeShownInMenus = true;

        tut.duration = -1;
        tut.posX = 0;
        tut.posY = 0;
        tut.enableAcceptButton = true;

        theGame.GetTutorialSystem().ShowTutorialHint(tut);
    }

    function showUsernameTaken()
    {
        var messagetitle : string;
        var messagebody : string;
        
        messagetitle = GetLocStringById(2111114249);
        messagebody = GetLocStringById(2111114250) + " '" +usernameTakenUser + "'.<br/><br/>"
        + GetLocStringById(2111114251);

        tutorialPopup(messagetitle, messagebody);
    }

    function showBannedMsg()
    {
        var messagetitle : string;
        var messagebody : string;
        
        messagetitle = GetLocStringById(2111114249);
        messagebody = GetLocStringById(2111114252);

        tutorialPopup(messagetitle, messagebody);
    }

    function showKickedMsg()
    {
        var messagetitle : string;
        var messagebody : string;
        
        messagetitle = GetLocStringById(2111114249);
        messagebody = GetLocStringById(2111114253);

        tutorialPopup(messagetitle, messagebody);
    }

    function showNotWhitelisted()
    {
        var messagetitle : string;
        var messagebody : string;
        
        messagetitle = GetLocStringById(2111114249);
        messagebody = GetLocStringById(2111114254);

        tutorialPopup(messagetitle, messagebody);
    }

    private var usernameTakenUser : string; 
    private var usernameTaken : bool;
    private var playerBanned : bool;
    private var playerKicked : bool;
    private var playerNotWhitelisted : bool;
    private var alertedDisconnect : bool;

    function setUsernameTaken(user : string)
    {
        usernameTakenUser = user;
        usernameTaken = true;
    }

    function getUsernameTaken() : bool
    {
        return usernameTaken;
    }

    function setKicked()
    {
        playerKicked = true;
    }

    function getKicked() : bool
    {
        return playerKicked;
    }

    function setBanned()
    {
        playerBanned = true;
    }

    function getBanned() : bool
    {
        return playerBanned;
    }

    function setNotWhitelisted()
    {
        playerNotWhitelisted = true;
    }

    function getNotWhitelisted() : bool
    {
        return playerNotWhitelisted;
    }

    function setAlertedDisconnect()
    {
        alertedDisconnect = true;
    }

    function getAlertedDisconnect() : bool
    {
        return alertedDisconnect;
    }

    function checkAlerts()
    {
        if(getBanned() && !getAlertedDisconnect())
        {
            showBannedMsg();
            setAlertedDisconnect();
        }
        else if(getKicked() && !getAlertedDisconnect())
        {
            showKickedMsg();
            setAlertedDisconnect();
        }
        else if(getNotWhitelisted() && !getAlertedDisconnect())
        {
            showNotWhitelisted();
            setAlertedDisconnect();
        }
        else if(getUsernameTaken() && !getAlertedDisconnect())
        {
            showUsernameTaken();
            setAlertedDisconnect();
        }
    }

    protected var poly : bool;
    protected var toMorph : name;

    function setPoly(val : bool, type : name)
    {
        poly = val;
        toMorph = type;
    }

    function emoteMenu()
    {
        var m_popupData : W3ItemSelectionPopupData;
        var inventory : CInventoryComponent;
        var cpcPlayerType : ENR_PlayerType;

        cpcPlayerType = NR_GetPlayerManager().GetCurrentPlayerType();
        
        inventory = getEmoteInventory();

        m_popupData = new W3ItemSelectionPopupData in theGame.GetGuiManager();
        m_popupData.targetInventory = inventory;
        m_popupData.overrideQuestItemRestrictions = true;

        m_popupData.selectionMode = EISPM_RadialMenuSilverOil;
        m_popupData.wo_isEmotes = true;
        
        theGame.RequestPopup('ItemSelectionPopup', m_popupData);
    }

    event OnEmoteMenu( action : SInputAction )
	{
		if( IsPressed( action ) )
		{
            emoteMenu();
        }	
	}

    function getEmoteInventory() : CInventoryComponent
    {
        var inventory : CInventoryComponent;
        var cpcPlayerType : ENR_PlayerType;

        cpcPlayerType = NR_GetPlayerManager().GetCurrentPlayerType();
        
        inventory = new CInventoryComponent in this;
        inventory.AddAnItem('wo_emote1', 1);
        inventory.AddAnItem('wo_emote2', 1);
        inventory.AddAnItem('wo_emote3', 1);
        inventory.AddAnItem('wo_emote4', 1);
        inventory.AddAnItem('wo_emote5', 1);
        inventory.AddAnItem('wo_emote6', 1);
        inventory.AddAnItem('wo_emote7', 1);
        inventory.AddAnItem('wo_emote8', 1);
        inventory.AddAnItem('wo_emote9', 1);
        inventory.AddAnItem('wo_emote10', 1);
        inventory.AddAnItem('wo_emote11', 1);
        inventory.AddAnItem('wo_emote12', 1);
        inventory.AddAnItem('wo_emote13', 1);
        inventory.AddAnItem('wo_emote14', 1);
        inventory.AddAnItem('wo_emote15', 1);
        inventory.AddAnItem('wo_emote16', 1);
        inventory.AddAnItem('wo_emote17', 1);
        inventory.AddAnItem('wo_emote18', 1);
        inventory.AddAnItem('wo_emote19', 1);
        inventory.AddAnItem('wo_emote20', 1);
        inventory.AddAnItem('wo_emote21', 1);
        inventory.AddAnItem('wo_emote22', 1);
        inventory.AddAnItem('wo_emote23', 1);
        inventory.AddAnItem('wo_emote24', 1);
        inventory.AddAnItem('wo_emote25', 1);
        inventory.AddAnItem('wo_emote26', 1);
        inventory.AddAnItem('wo_emote27', 1);
        inventory.AddAnItem('wo_emote28', 1);
        inventory.AddAnItem('wo_emote29', 1);
        inventory.AddAnItem('wo_emote33', 1);
        inventory.AddAnItem('wo_emote34', 1);
        inventory.AddAnItem('wo_emote35', 1);
        inventory.AddAnItem('wo_emote36', 1);
        inventory.AddAnItem('wo_emote37', 1);
        inventory.AddAnItem('wo_emote38', 1);
        inventory.AddAnItem('wo_emote39', 1);
        inventory.AddAnItem('wo_emote40', 1);
        inventory.AddAnItem('wo_emote41', 1);
        inventory.AddAnItem('wo_emote42', 1);
        inventory.AddAnItem('wo_emote43', 1);
        inventory.AddAnItem('wo_emote44', 1);
        inventory.AddAnItem('wo_emote45', 1);
        inventory.AddAnItem('wo_emote46', 1);
        inventory.AddAnItem('wo_emote47', 1);
        inventory.AddAnItem('wo_emote48', 1);
        inventory.AddAnItem('wo_emote49', 1);
        inventory.AddAnItem('wo_emote50', 1);
        inventory.AddAnItem('wo_emote51', 1);
        inventory.AddAnItem('wo_emote52', 1);

        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
        {
            inventory.AddAnItem('wo_emote55', 1);
            inventory.AddAnItem('wo_emote56', 1);
        }
        else
        {
            inventory.AddAnItem('wo_emote53', 1);
            inventory.AddAnItem('wo_emote54', 1);
        }

        return inventory;
    }

    function getChatInventory() : CInventoryComponent
    {
        var inventory : CInventoryComponent;
        
        inventory = new CInventoryComponent in this;
        inventory.AddAnItem('wo_chat1', 1);
        inventory.AddAnItem('wo_chat2', 1);
        inventory.AddAnItem('wo_chat3', 1);
        inventory.AddAnItem('wo_chat4', 1);
        inventory.AddAnItem('wo_chat5', 1);
        inventory.AddAnItem('wo_chat6', 1);
        inventory.AddAnItem('wo_chat7', 1);
        inventory.AddAnItem('wo_chat8', 1);
        inventory.AddAnItem('wo_chat9', 1);
        inventory.AddAnItem('wo_chat10', 1);
        inventory.AddAnItem('wo_chat11', 1);
        inventory.AddAnItem('wo_chat12', 1);
        inventory.AddAnItem('wo_chat13', 1);

        return inventory;
    }
    
    function getMorphInventory() : CInventoryComponent
    {
        var inventory : CInventoryComponent;
        
        inventory = new CInventoryComponent in this;
        inventory.AddAnItem('wo_morph1', 1);
        inventory.AddAnItem('wo_morph2', 1);
        inventory.AddAnItem('wo_morph3', 1);
        inventory.AddAnItem('wo_morph4', 1);

        return inventory;
    }

    private function findRiderHorseAnchor(rider : CActor) : int
    {
        var i : int;

        if(!rider)
            return -1;

        for(i = 0; i < riderHorseAnchors.Size(); i += 1)
        {
            if(riderHorseAnchors[i].rider == rider)
                return i;
        }

        return -1;
    }

    public function destroyRiderHorseAnchor(rider : CActor, optional breakRiderAttachment : bool)
    {
        var i : int;
        var anchor : CEntity;

        if(!rider)
            return;

        if(breakRiderAttachment && rider.HasAttachment())
        {
            rider.BreakAttachment();
        }

        for(i = riderHorseAnchors.Size() - 1; i >= 0; i -= 1)
        {
            if(riderHorseAnchors[i].rider == rider)
            {
                anchor = riderHorseAnchors[i].anchor;

                if(anchor)
                {
                    if(anchor.HasAttachment())
                    {
                        anchor.BreakAttachment();
                    }

                    anchor.Destroy();
                }

                riderHorseAnchors.Erase(i);
            }
        }
    }

    public function destroyHorseAnchorsForTarget(target : CActor, optional breakRiders : bool)
    {
        var i : int;
        var rider : CActor;
        var anchor : CEntity;

        if(!target)
            return;

        for(i = riderHorseAnchors.Size() - 1; i >= 0; i -= 1)
        {
            if(riderHorseAnchors[i].target == target)
            {
                rider = riderHorseAnchors[i].rider;
                anchor = riderHorseAnchors[i].anchor;

                if(breakRiders && rider && rider.HasAttachment())
                {
                    rider.BreakAttachment();
                }

                if(anchor)
                {
                    if(anchor.HasAttachment())
                    {
                        anchor.BreakAttachment();
                    }

                    anchor.Destroy();
                }

                riderHorseAnchors.Erase(i);
            }
        }
    }

    public function detachRiderSafe(rider : CActor, optional fixRotation : bool)
    {
        if(!rider)
            return;

        destroyRiderHorseAnchor(rider, true);

        if(rider.HasAttachment())
        {
            rider.BreakAttachment();
        }

        if(fixRotation)
        {
            fixAttachRotation(rider);
        }
    }

    public function destroyAllRiderHorseAnchors()
    {
        var i : int;
        var rider : CActor;
        var anchor : CEntity;

        for(i = riderHorseAnchors.Size() - 1; i >= 0; i -= 1)
        {
            rider = riderHorseAnchors[i].rider;
            anchor = riderHorseAnchors[i].anchor;

            if(rider && rider.HasAttachment())
            {
                rider.BreakAttachment();
            }

            if(anchor)
            {
                if(anchor.HasAttachment())
                {
                    anchor.BreakAttachment();
                }

                anchor.Destroy();
            }

            riderHorseAnchors.Erase(i);
        }
    }
}

exec function wo_get(playerId : int, username : string)
{
    var pos : Vector;
    var list : string;
    var inv : CInventoryComponent;
    var steel, silver : SItemUniqueId;
    var ids : array<SItemUniqueId>;
    var offhandItem : bool;
    var theHorse : CActor;
    var type 		: EExplorationType;
    var selectedItemId : SItemUniqueId;
    var playerRotation      : EulerAngles;
    var rootMenu : CR4Menu;

    var id : SItemUniqueId;
    var steelName : name;
    var silverName : name;
    var armor : name;
    var gloves : name;
    var pants : name;
    var boots : name;
    var i : int;
    var acs : array< CComponent >;
	var head : name;
	var hair : name;
	var steelScab : name;
	var silverScab : name;
	var crossbow : name;
	var mask : name;

    var fallDist : float;

    var ridingPlayer : r_RemotePlayer;
    var outgoingPlayer : string;
    var outgoingTradeItem : name;

    var horseAppearance : string;

    var morphMap : NR_Map;
    var morphActive : int;
    var morphType : name;
    var morphAppearance : name;

    var transformedNPC : CActor;

    theGame.r_getMultiplayerClient().setUserId(playerId, username);
    theGame.r_getMultiplayerClient().setReceived();

    inv = thePlayer.GetInventory();
    pos = thePlayer.GetWorldPosition();

    list += pos.X;
    list += " ";

    list += pos.Y;
    list += " ";

    list += pos.Z;
    list += " ";

    list += pos.W;
    list += " ";

    list += thePlayer.GetHeading();
    list += " ";

    transformedNPC = theGame.GetActorByTag('NR_TRANSFORM_NPC');
    morphMap = NR_GetMagicManager().GetMap('none');

    morphActive = morphMap.getI("nr_polymorphysm_active");
    morphType = morphMap.getN("nr_polymorphysm_type");
    morphAppearance = morphMap.getN("nr_polymorphysm_appearance");

    if(transformedNPC && morphActive)
    {
        list += transformedNPC.GetBehaviorVariable('Editor_MovementSpeed');
    }
    else
    {
        list += thePlayer.GetMovingAgentComponent().GetRelativeMoveSpeed();
    }
    list += " ";

    list += theGame.GetCommonMapManager().GetCurrentArea();
    list += " ";

    list += theGame.r_getMultiplayerClient().getInGame();
    list += " ";

    if(!thePlayer.IsCiri())
    {
        if( inv.GetItemEquippedOnSlot(EES_SilverSword, silver) && inv.IsItemHeld(silver))
        {
            list += "silver";
        }
        else if( inv.GetItemEquippedOnSlot(EES_SteelSword, steel) && inv.IsItemHeld(steel))
        {
            list += "steel";
        }
        else
        {
            list += "none";
        }
    }
    else
    {
        if(GetCiriPlayer().inv.IsItemHeld(GetCiriPlayer().GetEquippedSword(true)))
        {
            list += "steel";
        }
        else
        {
            list += "none";
        }
    }

    list += " ";

    offhandItem = false;

    ids = inv.GetItemsByName('Torch');
    if(inv.IsItemHeld(ids[0]))
    {
        list += "torch";
        offhandItem = true;
    }

    if(!offhandItem)
    {
        list += "none";
    }
    
    list += " ";

    list += thePlayer.IsInCombat();
    list += " ";

    list += thePlayer.IsSwimming();
    list += " ";

    list += thePlayer.substateManager.GetStateCur();
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastJumpTime();
    list += " ";

    list += thePlayer.substateManager.m_SharedDataO.m_JumpTypeE;
    list += " ";

    list += ((EClimbHeightType)((int)thePlayer.GetBehaviorVariable('ClimbHeightType')));
    list += " ";

    list += thePlayer.IsDiving();
    list += " ";

    thePlayer.GetFallDist(fallDist);

    list += (fallDist > 0.05 && thePlayer.IsFalling());
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastLightTime();
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastHeavyTime();
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastDodgeTime();
    list += " ";
    
    list += theGame.r_getMultiplayerClient().getLastRollTime();
    list += " ";

    list += thePlayer.IsGuarded();
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastHit();
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastParry();
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastFinisher();
    list += " ";

    list += theGame.r_getMultiplayerClient().getFinisherMonster();
    list += " ";

    list += thePlayer.GetCurrentlyCastSign();
    list += " ";
    
    list += theGame.r_getMultiplayerClient().getLastSignTime();
    list += " ";

    list += thePlayer.IsSailing();
    list += " ";

    list += thePlayer.IsUsingHorse(true);
    list += " ";

    if ( thePlayer.IsUsingHorse(true) )
    {
		theHorse = (CActor)thePlayer.GetUsedHorseComponent().GetEntity();

        if(theHorse)
        {
            list += VecLength2D(((CActor)theHorse).GetMovingAgentComponent().GetVelocity());
        }
        else
        {
            list += "0";
        }
    }
    else
    {
        list += "0";
    }
    list += " ";

    list += thePlayer.GetIsAimingCrossbow();
    list += " ";
    
    if(thePlayer.GetTraverser().GetExplorationType( type ))
    {
        if( type == ET_Ladder )
        {
            list += "true";
        }
        else
        {
            list += "false";
        }
    }
    else
    {
        list += "false";
    }

    list += " ";

    list += thePlayer.GetCurrentStateName();
    list += " ";
	
	selectedItemId = thePlayer.GetSelectedItemId();
    if(thePlayer.inv.IsItemBomb(selectedItemId) && (thePlayer.inv.SingletonItemGetAmmo(selectedItemId) > 0) )
    {
        list += "true";
    }
    else
    {
        list += "false";
    }
	list += " ";
    
    list += thePlayer.IsAlive();
    list += " ";

    list += theGame.r_getMultiplayerClient().getEmote();
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastEmoteTime();
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastChatTime();
    list += " ";

    list += "_s ";
    list += theGame.r_getMultiplayerClient().getChat();
    list += " _e ";

    list += ((ChillOutStateCO_Action) Chill().State()).GetAnimation();
    list += " ";

    playerRotation = thePlayer.GetWorldRotation();
    list += playerRotation.Yaw;
    list += " ";

    list += thePlayer.abilityManager.GetStat(BCS_Stamina);
    list += " ";

    list += theGame.r_getMultiplayerClient().getSwirling();
    list += " ";
    
    list += theGame.r_getMultiplayerClient().getRend();
    list += " ";

    list += GetWitcherPlayer().IsCurrentSignChanneled();
    list += " ";

	rootMenu = (CR4Menu)theGame.GetGuiManager().GetRootMenu();
    if(rootMenu)
    {
        list += rootMenu.GetSubMenu().GetMenuName();
    }
    else
    {
        if(theGame.IsDialogOrCutscenePlaying() || theGame.IsCurrentlyPlayingNonGameplayScene())
        {
            list += "InCutscene";
        }
        else
        {
            list += "none";
        }
    }
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastActionTime();
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastAction();
    list += " ";

    // armor/items
    inv.GetItemEquippedOnSlot(EES_SteelSword, id);
    steelName = inv.GetItemName(id);

    inv.GetItemEquippedOnSlot(EES_SilverSword, id);
    silverName = inv.GetItemName(id);

    inv.GetItemEquippedOnSlot(EES_Armor, id);
    armor = inv.GetItemName(id);

    inv.GetItemEquippedOnSlot(EES_Gloves, id);
    gloves = inv.GetItemName(id);

    inv.GetItemEquippedOnSlot(EES_Pants, id);
    pants = inv.GetItemName(id);

    inv.GetItemEquippedOnSlot(EES_Boots, id);
    boots = inv.GetItemName(id);

    inv.GetItemEquippedOnSlot(EES_Quickslot2, id);

    if(inv.IsItemMask(id))
    {
        mask = inv.GetItemName(id);
    }

    acs = thePlayer.GetComponentsByClassName( 'CHeadManagerComponent' );
	head = ( ( CHeadManagerComponent ) acs[0] ).GetCurHeadName();

    ids = inv.GetItemsByCategory('hair');
    for( i=0; i < ids.Size(); i +=  1 )
    {
        hair = inv.GetItemName( ids[i] );
    }

    ids = inv.GetItemsByCategory('steel_scabbards');
    
    for( i=0; i < ids.Size(); i +=  1 )
    {
        if(inv.IsItemHeld(ids[i]) || GetWitcherPlayer().IsItemEquipped(ids[i]) || inv.IsItemMounted(ids[i]))
        {
            steelScab = inv.GetItemName( ids[i] );
            break;
        }
    }

    ids = inv.GetItemsByCategory('silver_scabbards');
    for( i=0; i < ids.Size(); i +=  1 )
    {
        if(inv.IsItemHeld(ids[i]) || GetWitcherPlayer().IsItemEquipped(ids[i]) || inv.IsItemMounted(ids[i]))
        {
            silverScab = inv.GetItemName( ids[i] );
            break;
        }
    }

    inv.GetItemEquippedOnSlot(EES_RangedWeapon, id);
    crossbow = inv.GetItemName(id);

     // separator
    list += "half ";

    list += "_s ";
    if(thePlayer.IsCiri() && GetCiriPlayer().HasSword())
    {
        list += 'Zireal Sword';
    }
    else
    {
        list += steelName;
    }
    list += " _e ";

    list += "_s ";
    list += silverName;
    list += " _e ";

    list += "_s ";
    list += armor;
    list += " _e ";

    list += "_s ";
    list += gloves;
    list += " _e ";

    list += "_s ";
    list += pants;
    list += " _e ";

    list += "_s ";
    list += boots;
    list += " _e ";

    list += "_s ";
    list += head;
    list += " _e ";

    list += "_s ";
    list += hair;
    list += " _e ";

    list += "_s ";
    list += steelScab;
    list += " _e ";

    list += "_s ";
    list += silverScab;
    list += " _e ";

    list += "_s ";
    list += crossbow;
    list += " _e ";

    list += "_s ";
    list += mask;
    list += " _e ";

    list += theGame.r_getMultiplayerClient().isRiding();
    list += " ";

    ridingPlayer = theGame.r_getMultiplayerClient().getRidingPlayer();

    if(ridingPlayer && ridingPlayer.serverPlayerId > 0)
    {
        list += ridingPlayer.serverPlayerId;
    }
    else
    {
        list += "0";
    }
    list += " ";

    outgoingPlayer = theGame.r_getMultiplayerClient().getOutgoingTradeTo();

    if(outgoingPlayer != "")
    {
        list += outgoingPlayer;
    }
    else
    {
        list += "none";
    }
    list += " ";

    outgoingTradeItem = theGame.r_getMultiplayerClient().getOutgoingTradeItem();

    if(outgoingTradeItem != '')
    {
        list += "_s ";
        list += outgoingTradeItem;
        list += " _e";
    }
    else
    {
        list += "none";
    }
    list += " ";

    list += theGame.r_getMultiplayerClient().getOutgoingTradePrice();
    list += " ";

    list += theGame.r_getMultiplayerClient().getOutgoingTradeFlag();
    list += " ";
    
    horseAppearance = theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HorseAppearance');

    if(horseAppearance == "0" || horseAppearance == "1" || horseAppearance == "2" || horseAppearance == "3" || horseAppearance == "4" || horseAppearance == "5")
    {
        list += horseAppearance;
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(morphActive == 1)
    {
        list += "true";
    }
    else
    {
        list += "false";
    }
    list += " ";

    if(morphType != '')
    {
        list += morphType;
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(morphAppearance != '')
    {
        list += morphAppearance;
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(transformedNPC && morphActive)
    {
        list += transformedNPC.GetBehaviorVariable('Editor_MovementRotation');
    }
    else
    {
        list += "0";
    }
    list += " ";

    Log("wo "+list);
}

exec function wo_get2(playerId : int, username : string)
{
    var pos : Vector;
    var list : string;
    var inv : CInventoryComponent;
    var user : string;
    var i : int;
    
    // cpc
    var templates : array< array<String> >;
    var appearanceItems : array< array<String> >;
    var heads : array< name >;
    var curType : ENR_PlayerType;

    theGame.r_getMultiplayerClient().setUserId(playerId, username);
    theGame.r_getMultiplayerClient().setReceived();

    inv = thePlayer.GetInventory();
    pos = thePlayer.GetWorldPosition();

    user = theGame.r_getMultiplayerClient().getUsername();

    // cpc
    templates = NR_GetPlayerManager().m_appearanceTemplates;
    appearanceItems = NR_GetPlayerManager().m_appearanceItems;
    heads = NR_GetPlayerManager().mpghosts_GetHeads();

    curType = NR_GetPlayerManager().GetCurrentPlayerType();

    list += curType;
    list += " ";

    if(heads[curType] != '')
    {
        list += heads[curType];
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(templates[curType][ENR_RSlotHair] != "")
    {
        list += templates[curType][ENR_RSlotHair];
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(templates[curType][ENR_RSlotBody] != "")
    {
        list += templates[curType][ENR_RSlotBody];
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(templates[curType][ENR_RSlotTorso] != "")
    {
        list += templates[curType][ENR_RSlotTorso];
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(templates[curType][ENR_RSlotArms] != "")
    {
        list += templates[curType][ENR_RSlotArms];
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(templates[curType][ENR_RSlotGloves] != "")
    {
        list += templates[curType][ENR_RSlotGloves];
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(templates[curType][ENR_RSlotDress] != "")
    {
        list += templates[curType][ENR_RSlotDress];
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(templates[curType][ENR_RSlotLegs] != "")
    {
        list += templates[curType][ENR_RSlotLegs];
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(templates[curType][ENR_RSlotShoes] != "")
    {
        list += templates[curType][ENR_RSlotShoes];
    }
    else
    {
        list += "none";
    }
    list += " ";

    if(templates[curType][ENR_RSlotMisc] != "")
    {
        list += templates[curType][ENR_RSlotMisc];
    }
    else
    {
        list += "none";
    }
    list += " ";

    list += "half ";

    // cpc items
    for(i = 0; i < 9; i+=1)
    {
        if(appearanceItems[curType][i] != "")
        {
            list += appearanceItems[curType][i];
        }
        else
        {
            list += "none";
        }
        list += " ";
    }

    if(NR_GetPlayerManager().IsRealEquipmentModeEnabled())
    {
        list += "EquipmentMode";
    }
    else
    {
        if(appearanceItems[curType][9] != "")
        {
            list += appearanceItems[curType][9];
        }
        else
        {
            list += "none";
        }
    }
    list += " ";

    Log("wo2 "+list);
}

exec function wo_get3(playerId : int, username : string)
{
    var manager : CR4GwintManager;
    var selectedFaction : eGwintFaction;
    var deck : SDeckDefinition;
    var i : int;
    var list : string;
    var outgoingGwentTo : string;
    var lastGwentAction : string;
    
    theGame.r_getMultiplayerClient().setUserId(playerId, username);
    theGame.r_getMultiplayerClient().setReceived();

    manager = theGame.GetGwintManager();
    selectedFaction = manager.GetSelectedPlayerDeck();
    deck = manager.GetCurrentPlayerDeck();
    
    outgoingGwentTo = theGame.r_getMultiplayerClient().getOutgoingGwentTo();

    if(outgoingGwentTo != "")
    {
        list += outgoingGwentTo;
    }
    else
    {
        list += "none";
    }
    list += " ";

    list += theGame.r_getMultiplayerClient().getOutgoingGwentRequest();
    list += " ";

    list += theGame.r_getMultiplayerClient().getOutgoingGwentBet();
    list += " ";

    list += theGame.r_getMultiplayerClient().getOutgoingGwentSeed();
    list += " ";

    //actions

    lastGwentAction = theGame.r_getMultiplayerClient().getLastGwentAction();

    if(lastGwentAction != "")
    {
        list += lastGwentAction;
    }
    else
    {
        list += "none";
    }
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastGwentActionTime();
    list += " ";

    list += selectedFaction;
    list += " ";

    list += deck.leaderIndex;
    list += " ";

    for(i = 0; i < deck.cardIndices.Size(); i+=1)
    {
        list += deck.cardIndices[i];
        list += " ";
    }

    Log("wo3 "+list);
}

exec function wo_get4(playerId : int, username : string)
{
    var list : string;
    var joinedParty : string;
    var weather : name;
    var day : int;
    var hour : int;
    var minute : int;
    var second : int;
    var dialogChoices : array<SSceneChoice>;
    var i : int;
    var id : SItemUniqueId;
    var inv : CInventoryComponent;
    var color : name;
    var limit : int;
    
    theGame.r_getMultiplayerClient().setUserId(playerId, username);
    theGame.r_getMultiplayerClient().setReceived();

    list += theGame.r_getMultiplayerClient().getInParty();
    list += " ";

    joinedParty = theGame.r_getMultiplayerClient().getJoinedParty();
    if(joinedParty != "")
    {
        list += joinedParty;
    }
    else
    {
        list += "none";
    }

    list += " ";

    weather = GetWeatherConditionName();

    if(weather != '' && weather != ' ')
    {
        list += weather;
    }
    else
    {
        list += "none";
    }
    list += " ";
    
    day = GameTimeDays(theGame.GetGameTime());
    hour = GameTimeHours(theGame.GetGameTime());
    minute = GameTimeMinutes(theGame.GetGameTime());
    second = GameTimeSeconds(theGame.GetGameTime());

    list += day;
    list += " ";

    list += hour;
    list += " ";
    
    list += minute;
    list += " ";

    list += second;
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastDialogIndex();
    list += " ";

    list += theGame.r_getMultiplayerClient().getLastDialogCount();
    list += " ";

    if(theGame.r_getMultiplayerClient().getLastDialogIndex() >= 0)
    {
        dialogChoices = theGame.r_getMultiplayerClient().getLastSelectedDialogChoices();
    }
    else
    {
        dialogChoices = theGame.r_getMultiplayerClient().getDialogChoices();
    }

    if(dialogChoices.Size() > 0)
    {
        limit = dialogChoices.Size();

        if(limit > 30)
        {
            limit = 30;
        }

        for(i = 0; i < limit; i += 1)
        {
            list += "|";

            list += theGame.r_getMultiplayerClient().boolToString(dialogChoices[i].emphasised);
            list += "%";

            list += theGame.r_getMultiplayerClient().boolToString(dialogChoices[i].previouslyChoosen);
            list += "%";

            list += theGame.r_getMultiplayerClient().boolToString(dialogChoices[i].disabled);
            list += "%";

            list += theGame.r_getMultiplayerClient().dialogActionToInt(dialogChoices[i].dialogAction);
            list += "%";

            if(dialogChoices[i].playGoChunk != '')
            {
                list += dialogChoices[i].playGoChunk;
            }
            else
            {
                list += "none";
            }
        }
    }
    else
    {
        list += "none";
    }

    list += " ";

    list += theGame.r_getMultiplayerClient().hasActiveDialogChoices();
    list += " ";

    inv = thePlayer.GetInventory();
    inv.GetItemEquippedOnSlot(EES_Armor, id);

    if(inv.IsIdValid(id))
    {
        color = inv.GetItemColor(id);

        list += theGame.r_getMultiplayerClient().colorToId(color);
    }
    else
    {
        list += "0";
    }
    list += " ";

    inv.GetItemEquippedOnSlot(EES_Gloves, id);

    if(inv.IsIdValid(id))
    {
        color = inv.GetItemColor(id);

        list += theGame.r_getMultiplayerClient().colorToId(color);
    }
    else
    {
        list += "0";
    }
    list += " ";

    inv.GetItemEquippedOnSlot(EES_Pants, id);

    if(inv.IsIdValid(id))
    {
        color = inv.GetItemColor(id);

        list += theGame.r_getMultiplayerClient().colorToId(color);
    }
    else
    {
        list += "0";
    }
    list += " ";

    inv.GetItemEquippedOnSlot(EES_Boots, id);

    if(inv.IsIdValid(id))
    {
        color = inv.GetItemColor(id);

        list += theGame.r_getMultiplayerClient().colorToId(color);
    }
    else
    {
        list += "0";
    }
    list += " ";

    list += thePlayer.GetHealthPercents();
    list += " ";

    Log("wo4 "+list);
}

exec function wo_update(serverPlayerId : int, id : name, x : float, y : float, z : float, w : float, heading : float, speed : float, area : int, 
                                        inGame : bool, heldItem : string, offhandItem : string, inCombat : bool, isSwimming : bool, curState : name, 
                                        lastJumpTime : float, lastJumpType : EJumpType, lastClimbType : EClimbHeightType, isDiving : bool, isFalling : bool,
                                        lastLightAttackTime : float, lastHeavyAttackTime : float, lastDodgeTime : float, lastRollTime : float, isGuarded : bool,
                                        lastHit : float, lastParry : float, lastFinisher : float, finisherMonster : bool, signType : ESignType, lastSign : float, isSailing : bool, isMounted : bool,
                                        horseSpeed : float, aimingCrossbow : bool, isLadder : bool, currentState : name, bombSelected : bool, isAlive : bool,
                                        lastEmote : int, lastEmoteTime : float, lastChatTime : float, lastChat : string, chillOutAnim : name, yaw : float, stamina : float, swirling : bool, rend : bool,
                                        channeling : bool, menuName : string, lastActionTime : float, lastAction : EPlayerExplorationAction,
                                        steel : name, silver : name, armor : name, gloves : name, pants : name, boots : name, head : name, hair : name, steelScab : name, silverScab : name, crossbow : name, mask : name,
                                        isRiding : bool, ridingPlayerId : int, outgoingTradeTo : string, outgoingTradeItem : name, outgoingTradePrice : int, outgoingTradeFlag : int, horseAppearance : string,
                                        morphActive : bool, morphType : name, morphAppearance : name, morphRotation : float) 
{
    theGame.r_getMultiplayerClient().updatePlayerData(serverPlayerId, id, x, y, z, w, heading, speed, area, inGame, heldItem, offhandItem, inCombat, isSwimming, 
                                                            curState, lastJumpTime, lastJumpType, lastClimbType, isDiving, isFalling, lastLightAttackTime,
                                                            lastHeavyAttackTime, lastDodgeTime, lastRollTime, isGuarded, lastHit, lastParry, lastFinisher, finisherMonster,
                                                            signType, lastSign, isSailing, isMounted, horseSpeed, aimingCrossbow, isLadder, currentState, bombSelected, isAlive,
                                                            lastEmote, lastEmoteTime, lastChatTime, lastChat, chillOutAnim, yaw, stamina, swirling, rend,
                                                            channeling, menuName, lastActionTime, lastAction,
                                                            steel, silver, armor, gloves, pants, boots, head, hair, steelScab, silverScab, crossbow, mask,
                                                            isRiding, ridingPlayerId, outgoingTradeTo, outgoingTradeItem, outgoingTradePrice, outgoingTradeFlag, horseAppearance,
                                                            morphActive, morphType, morphAppearance, morphRotation);
}

exec function wo_update2(serverPlayerId : int, id : name, cpcPlayerType : ENR_PlayerType, cpcHead : name, cpcHair : string, cpcBody : string, cpcTorso : string, cpcArms : string, cpcGloves : string, cpcDress : string, cpcLegs : string, 
                         cpcShoes : string, cpcMisc : string, cpcItem1 : string, cpcItem2 : string, cpcItem3 : string, cpcItem4 : string, cpcItem5 : string, cpcItem6 : string, cpcItem7 : string, cpcItem8 : string, 
                         cpcItem9 : string, cpcItem10 : string)
{
    theGame.r_getMultiplayerClient().updatePlayerData2(serverPlayerId, id, cpcPlayerType, cpcHead, cpcHair, cpcBody, cpcTorso, cpcArms, cpcGloves, cpcDress, cpcLegs, cpcShoes, cpcMisc,
                                                       cpcItem1, cpcItem2, cpcItem3, cpcItem4, cpcItem5, cpcItem6, cpcItem7, cpcItem8, cpcItem9, cpcItem10);
}

exec function wo_update3(serverPlayerId : int, id : name, outgoingGwentTo : string, outgoingGwentRequest : E_GwentRequest, outgoingGwentBet : int, outgoingGwentSeed : int, lastGwentAction : string, lastGwentActionTime : float, gwentData : string)
{
    theGame.r_getMultiplayerClient().updatePlayerData3(serverPlayerId, id, outgoingGwentTo, outgoingGwentRequest, outgoingGwentBet, outgoingGwentSeed, lastGwentAction, lastGwentActionTime, gwentData);
}

exec function wo_update4(serverPlayerId : int, id : name, inParty : bool, joinedParty : string, weather : name, day : int, hour : int, minute : int, second : int, lastDialogIndex : int, lastDialogCount : int, dialogChoices : string, 
                         dialogChoicesActive : bool, armorDye : int, gloveDye : int, pantDye : int, bootDye : int, health : float)
{
    theGame.r_getMultiplayerClient().updatePlayerData4(serverPlayerId, id, inParty, joinedParty, weather, day, hour, minute, second, lastDialogIndex , lastDialogCount, dialogChoices, dialogChoicesActive, armorDye, gloveDye, pantDye, bootDye, health);
}

exec function mpghosts_disconnect(id :string)
{
    theGame.r_getMultiplayerClient().disconnect(id);
    theGame.r_getMultiplayerClient().disconnectGlobal(id);
}

exec function mpghosts_destroyAll()
{
    theGame.r_getMultiplayerClient().destroyAll();
}

function mpghosts_playerEmote(anim : name, optional noSmooth : bool)
{
    if(noSmooth)
    {
        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( anim, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.0001, 0.0f) );
    }
    else
    {
        thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( anim, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.4f, 0.0f) );
    }
}

exec function wave()
{
    mpghosts_emote(0);
}

exec function bow()
{
    mpghosts_emote(1);
}

exec function point()
{
    mpghosts_emote(4);
}

exec function stop()
{
    mpghosts_emote(5);
}

exec function cry()
{
    mpghosts_emote(6);
}

exec function cheer()
{
    mpghosts_emote(7);
}

exec function beg()
{
    mpghosts_emote(8);
}

exec function clap()
{
    mpghosts_emote(9);
}

exec function vomit()
{
    mpghosts_emote(10);
}

exec function pray()
{
    mpghosts_emote(12);
}

exec function yoga()
{
    mpghosts_emote(14);
}

exec function laugh()
{
    mpghosts_emote(18);
}

exec function question()
{
    mpghosts_emote(3);
}

exec function sit()
{
    mpghosts_emote(19);
}

exec function lay()
{
    mpghosts_emote(20);
}

exec function dance()
{
    mpghosts_emote(21);
}

exec function facepalm()
{
    mpghosts_emote(22);
}

exec function cross()
{
    mpghosts_emote(23);
}

exec function flipoff()
{
    mpghosts_emote(24);
}

exec function horn()
{
    mpghosts_emote(25);
}

exec function fly()
{
    mpghosts_emote(26);
}

exec function drunk()
{
    mpghosts_emote(11);
}

exec function flop()
{
    mpghosts_emote(27);
}

exec function piss()
{
    mpghosts_emote(28);
}

exec function lute()
{
    mpghosts_emote(32);
}

exec function cartwheel()
{
    mpghosts_emote(33);
}

exec function scout()
{
    mpghosts_emote(35);
}

exec function fan()
{
    mpghosts_emote(36);
}

exec function spyglass()
{
    mpghosts_emote(38);
}

exec function eatfire()
{
    mpghosts_emote(39);
}

exec function write()
{
    mpghosts_emote(40);
}

exec function mime()
{
    mpghosts_emote(44);
}

exec function broom()
{
    mpghosts_emote(45);
}

exec function bag()
{
    mpghosts_emote(46);
}

exec function bag2()
{
    mpghosts_emote(51);
}

exec function shovel()
{
    mpghosts_emote(49);
}

exec function drink()
{
    mpghosts_emote(50);
}

exec function baguette()
{
    mpghosts_emote(52);
}

exec function pipe()
{
    mpghosts_emote(53);
}

exec function platter()
{
    mpghosts_emote(54);
}

exec function umbrella()
{
    mpghosts_emote(55);
}

function mpghosts_stopeemote()
{
    theGame.r_getMultiplayerClient().clearLocalEmoteState();
    theGame.r_getMultiplayerClient().setEmote(-2);
    mpghosts_playerEmote('');
}

exec function stopemote()
{
    mpghosts_stopeemote();
}

exec function emote(num : int)
{
    mpghosts_emote(num);
}

exec function ride(player : string)
{
    var remotePlayer : r_RemotePlayer;
    remotePlayer = mpghosts_getPlayer(player);

    if(remotePlayer && remotePlayer.ghost)
    {
        theGame.r_getMultiplayerClient().ridePlayer(remotePlayer.ghost);
        GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114230) + " " + remotePlayer.username + GetLocStringById(2111114231));
    }
    else
    {
        GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114232));
    }
}

exec function trade(player : string)
{
    var remotePlayer : r_RemotePlayer;
    remotePlayer = mpghosts_getPlayer(player);

    if(remotePlayer && remotePlayer.ghost)
    {
        theGame.r_getMultiplayerClient().tradeWithPlayer(remotePlayer.ghost);
    }
    else
    {
        GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114232));
    }
}

function mpghosts_emote(num : int)
{
    var cpcPlayerType : ENR_PlayerType;
    var anim : name;
    var force : bool;
    var loop : bool;
    cpcPlayerType = NR_GetPlayerManager().GetCurrentPlayerType();

    if(num == 54 || num == 55)
    {
        if(cpcPlayerType == ENR_PlayerGeralt || cpcPlayerType == ENR_PlayerWitcher || cpcPlayerType == ENR_PlayerUnknown)
        {
            return;
        }
    }

    anim  = '';
    force = false;

    theGame.r_getMultiplayerClient().unmountItems(thePlayer);

    if (num == 0)
    {
        anim = 'man_work_greeting_with_hand_gesture_05';
        loop = true;
    }
    else if (num == 1)
    {
        anim = 'man_work_greeting_with_hand_gesture_02';
    }
    else if (num == 2)
    {
        anim = 'meditation_idle01';
        loop = true;
    }
    else if (num == 3)
    {
        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
        {
            anim = 'add_gesture_question_01';
        }
        else
        {
            anim = 'high_standing_determined_gesture_question';
        }
    }
    else if (num == 4)
    {
        anim = 'add_gesture_point_forward';
    }
    else if (num == 5)
    {
        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
        {
            anim = 'high_standing_aggressive_gesture_decline_01';
        }
        else
        {
            anim = 'high_standing_determined_gesture_holdit';
        }
    }
    else if (num == 6)
    {
        anim = 'man_crying_loop_01';
        loop = true;
    }
    else if (num == 7)
    {
        anim = 'man_cheering_loop';
        loop = true;
    }
    else if (num == 8)
    {
        anim = 'man_begging_for_mercy_loop_01';
        loop = true;
    }
    else if (num == 9)
    {
        anim = 'audience_in_theatre_standing_loop_02';
    }
    else if (num == 10)
    {
        anim = 'man_work_drunk_puke';
    }
    else if (num == 11)
    {
        anim = 'geralt_drunk_walk';
        loop = true;
    }
    else if (num == 12)
    {
        anim = 'man_praying_crossed_legs_loop_02';
        loop = true;
    }
    else if (num == 13)
    {
        anim = 'q101_man_hitting_alarm_bell_with_hammer_loop_01';
    }
    else if (num == 14)
    {
        anim = 'q103_man_prophesying_1';
        loop = true;
    }
    else if (num == 15)
    {
        anim = 'q203_druid_using_wand_1';
    }
    else if (num == 16)
    {
        anim = 'geralt_chocking_loop_01';
    }
    else if (num == 17)
    {
        anim = 'seaman_working_on_the_ship_loop_01';
        loop = true;
    }
    else if (num == 18)
    {
        anim = 'ep1_high_standing_determined2_gesture_laugh_01';
    }
    else if (num == 19)
    {
        anim = 'vanilla_sitting_on_ground_loop';
        loop = true;
    }
    else if (num == 20)
    {
        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
        {
            anim = 'woman_noble_lying_relaxed_on_grass_loop_03';
            loop = true;
        }
        else
        {
            anim = 'mq7009_geralt_heroic_pose_lying';
            loop = true;
        }
    }
    else if (num == 21)
    {
        anim = 'locomotion_salsa_cycle_02';
        loop = true;
    }
    else if (num == 22)
    {
        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
        {
            anim = 'high_standing_determined_gesture_cough';
        }
        else
        {
            anim = 'high_standing_determined_gesture_facepalm';
        }
    }
    else if (num == 23)
    {
        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
        {
            anim = 'woman_work_standing_hands_crossed_loop_02';
            loop = true;
        }
        else
        {
            anim = 'high_standing_determined2_idle';
            loop = true;
        }
    }
    else if (num == 24)
    {
        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
        {
            anim = 'q705_anarietta_standing_tense_gesture_angry';
        }
        else
        {
            anim = 'high_standing_sad_gesture_go_plough_yourself';
        }
    }
    else if (num == 25)
    {
        anim = 'man_use_horn';
    }
    else if (num == 26)
    {
        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
        {
            anim = 'ep1_mirror_sitting_on_shrine_gesture_explain_04';
        }
        else
        {
            anim = 'fall_up_idle';
            force = true;
        }
    }
    else if (num == 27)
    {
        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
        {
            anim = 'man_fistfight_finisher_1_looser';
        }
        else
        {
            anim = 'man_finisher_head_01_reaction';
        }
    }
    else if (num == 28)
    {
        anim = 'man_peeing_loop';
        loop = true;
    }
    else if (num == 29)
    {
        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
        {
            anim = 'high_sitting_determined_idle';
        }
        else
        {
            anim = 'geralt_relaxed_sitting_and_resting_2';
        }
        
        loop = true;
    }
    else if (num == 30)
    {
        anim = 'boat_passenger_sit_idle';
        loop = true;
    }
    else if (num == 31)
    {
        anim = 'horse_breathing_slow';
        loop = true;
    }
    else if (num == 32)
    {
        anim = 'man_work_playing_lute_02';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'Lute 01');
    }
    else if (num == 33)
    {
        anim = 'man_bard_cartwheels_loop';
        loop = true;
    }
    else if (num == 34)
    {
        anim = 'man_throat_cut_loop';
        loop = true;
    }
    else if (num == 35)
    {
        anim = 'man_scout_01';
        loop = true;
    }
    else if (num == 36)
    {
        anim = 'man_nobel_with_fan_loop_2';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'fan_01');
    }
    else if (num == 37)
    {
        anim = 'man_trader_stand_loop_01';
        loop = true;
    }
    else if (num == 38)
    {
        anim = 'man_work_spyglass_01';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'Spyglass');
    }
    else if (num == 39)
    {
        anim = 'man_work_standing_performance_fire_eater_loop_01';
        loop = true;
        theGame.r_getMultiplayerClient().MountRightTorch(thePlayer);
    }
    else if (num == 40)
    {
        anim = 'man_work_writing_stand_01';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'Note_01');
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'Quill');
    }
    else if (num == 41)
    {
        anim = 'man_cowering_low_loop_04';
        loop = true;
    }
    else if (num == 42)
    {
        anim = 'man_cowering_high_loop_03';
        loop = true;
    }
    else if (num == 43)
    {
        anim = 'man_kneeling_on_floor_in_pain_loop_01';
        loop = true;
    }
    else if (num == 44)
    {
        anim = 'q703_first_mime_pulling_rope_loop';
        loop = true;
    }
    else if (num == 45)
    {
        anim = 'man_work_broom_sweeping_01';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'Broom');
    }
    else if (num == 46)
    {
        anim = 'man_work_carry_bag_walk';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'Sack');
    }
    else if (num == 47)
    {
        anim = 'man_work_chauffer_04';
        loop = true;
    }
    else if (num == 48)
    {
        anim = 'man_work_crouch_01';
        loop = true;
    }
    else if (num == 49)
    {
        anim = 'man_work_digging_shovel_loop_04';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'shovel');
    }
    else if (num == 50)
    {
        anim = 'man_work_drinking_loop_01';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'Cup_01');
    }
    else if (num == 51)
    {
        anim = 'man_work_pull_bag_walk';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'Sack');
    }
    else if (num == 52)
    {
        anim = 'man_guard_eating_baguette_02';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'baguette');
    }
    else if (num == 53)
    {
        anim = 'man_smoking_stand_01';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'Pipe_01');
    }
    else if (num == 54)
    {
        anim = 'woman_noble_stand_eating_fancy_loop_01';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'rich_plate_full_canapes_righthand');
    }
    else if (num == 55)
    {
        anim = 'woman_noble_stand_in_rain_with_umbrella_loop_01';
        loop = true;
        theGame.r_getMultiplayerClient().Mount(thePlayer, 'rich_umbrella');
    }

    theGame.r_getMultiplayerClient().setEmote(num);
    theGame.r_getMultiplayerClient().setLastEmoteTime(theGame.GetEngineTimeAsSeconds());
    theGame.r_getMultiplayerClient().setLocalEmoteState(anim, force, loop);

    if(!loop)
    {
        theGame.r_getMultiplayerClient().setEmoteEnd();
    }

    if(anim != '')
    {
        mpghosts_playerEmote(anim, force);
    }
}

function mpghosts_chat(msg : string)
{
    if (StrLen(msg) > 65)
    {
        msg = StrLeft(msg, 65);
    }

    theGame.r_getMultiplayerClient().setChat(msg);
    theGame.r_getMultiplayerClient().setLastChatTime(theGame.GetEngineTimeAsSeconds());
}

exec function chat(msg : string) 
{
    mpghosts_chat(msg);
}

function mpghosts_teleport(user :string)
{
    var players : array<r_RemotePlayer>;
    var i : int;
    players = theGame.r_getMultiplayerClient().getGlobalPlayers();

    for(i = 0; i < players.Size(); i+=1)
    {
        if(players[i].username == user)
        {
            theGame.GetGuiManager().ShowNotification(GetLocStringById(2111114210) + " " + user);
            if(players[i].area == theGame.GetCommonMapManager().GetCurrentArea())
            {
                thePlayer.Teleport(players[i].pos);
            }
            else
            {
                theGame.ScheduleWorldChangeToPosition( theGame.GetCommonMapManager().GetWorldPathFromAreaType(players[i].area), players[i].pos, thePlayer.GetWorldRotation() );
            }
            return;
        }
    }
}

function mpghosts_getPlayer(user : string) : r_RemotePlayer
{
    var players : array<r_RemotePlayer>;
    var i : int;
    players = theGame.r_getMultiplayerClient().getPlayers();

    for(i = 0; i < players.Size(); i+=1)
    {
        if(players[i].username == user)
        {
            return players[i];
        }
    }

    return NULL;
}

function mpghosts_getPlayerById(id : string) : r_RemotePlayer
{
    var players : array<r_RemotePlayer>;
    var i : int;
    players = theGame.r_getMultiplayerClient().getPlayers();

    for(i = 0; i < players.Size(); i+=1)
    {
        if(players[i].id == id)
        {
            return players[i];
        }
    }

    return NULL;
}

function mpghosts_getPlayerFromActor(actor : CActor) : r_RemotePlayer
{
    var players : array<r_RemotePlayer>;
    var i : int;
    players = theGame.r_getMultiplayerClient().getPlayers();

    for(i = 0; i < players.Size(); i+=1)
    {
        if(players[i].ghost == actor)
        {
            return players[i];
        }
    }

    return NULL;
}

exec function teleport(user : string)
{
    mpghosts_teleport(user);
}

class WitcherOnline_PopupData extends BookPopupFeedback {

	public function GetGFxData(parentFlashValueStorage : CScriptedFlashValueStorage) : CScriptedFlashObject {
		var objResult : CScriptedFlashObject;
		objResult = super.GetGFxData(parentFlashValueStorage);
		objResult.SetMemberFlashString("iconPath", "img://icons/inventory/scrolls/scroll2.dds");
		return objResult;
	}

	public function SetupOverlayRef(target : CR4MenuPopup) : void {
		super.SetupOverlayRef(target);
		PopupRef.GetMenuFlash().GetChildFlashSprite("background").SetAlpha(100.0);
	}
}

struct WitcherOnline_PlayerNotification
{
	var message_title	: string;
	var message_body	: string;
}

exec function list()
{
    var players : array<r_RemotePlayer>;
    var localPlayers : array<r_RemotePlayer>;
    var kaerMorhen : int;
    var whiteOrchard : int;
    var toussaint : int;
    var velen : int;
    var skellige : int;
    var vizima : int;
    var i : int;
    var total : int;
    var other : int;
    var messagetitle : string;
    var messagebody : string;
    var finalTotal : int;
    var localFinalTotal : int;
    var playerString : string;
    var myId : string;
    var regionName : string;
    var currentRegion : string;

    players = theGame.r_getMultiplayerClient().getGlobalPlayers();
    localPlayers = theGame.r_getMultiplayerClient().getPlayers();
    myId = theGame.r_getMultiplayerClient().getId();

    for(i = 0; i < players.Size(); i += 1)
    {
        if(players[i].id == myId)
        {
            continue;
        }

        finalTotal += 1;

        regionName = theGame.r_getMultiplayerClient().normalizeRegion(AreaTypeToName(players[i].area));

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

    for(i = 0; i < localPlayers.Size(); i += 1)
    {
        if(localPlayers[i].id == myId)
        {
            continue;
        }

        localFinalTotal += 1;
    }

    finalTotal += 1;
    localFinalTotal += 1;

    currentRegion = theGame.r_getMultiplayerClient().normalizeRegion(AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea()));

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

    total = velen + skellige + toussaint + whiteOrchard + kaerMorhen + vizima;
    other = finalTotal - total;

    if(finalTotal == 1)
    {
        playerString = "player";
    }
    else
    {
        playerString = "players";
    }

    messagetitle = "<p align=\"center\">" + GetLocStringById(2111114255) + "<br/></p>";
    messagebody =
    "<p align=\"center\">"
    + finalTotal + " " + playerString + " " + GetLocStringById(2111114256) + ", " + localFinalTotal + " " + GetLocStringById(2111114257) + "<br/><br/>"
    + whiteOrchard + " " + GetLocStringById(2111114258) + "<br/>"
    + velen + " " + GetLocStringById(2111114259) + "<br/>"
    + skellige + " " + GetLocStringById(2111114260) + "<br/>"
    + kaerMorhen + " " + GetLocStringById(2111114261) + "<br/>"
    + toussaint + " " + GetLocStringById(2111114262) + "<br/>"
    + vizima + " " + GetLocStringById(2111114263) + "<br/>"
    + other + " " + GetLocStringById(2111114264)
    + "</p>";

    theGame.r_getMultiplayerClient().DisplayUserMessage(WitcherOnline_PlayerNotification(messagetitle, messagebody));
}

state WO_ClientIdle in r_MultiplayerClient {
  event OnEnterState(previous_state_name: name) 
  {
    super.OnEnterState(previous_state_name);
  }
}

state WO_Tick in r_MultiplayerClient
{
    event OnEnterState(prevStateName : name)
	{
		this.wo_tickEntry();
        this.GotoState('WO_ClientIdle');
	}

    latent function castPoly()
    {
        var nr_manager : NR_MagicManager = NR_GetMagicManager();
        var action : NR_MagicSpecialPolymorphism;
        var morphType : name;
        var catNames : array<name>;
        var foxNames : array<name>;
        var finalMorph : name;

        if(NR_GetPlayerManager().GetCurrentPlayerType() != ENR_PlayerSorceress)
        {
            return;
        }

        morphType = parent.toMorph;

        if(morphType == 'fox')
        {
            finalMorph = 'cat';
        }
        else
        {
            finalMorph = morphType;
        }

        action = new NR_MagicSpecialPolymorphism in nr_manager;
        action.drainStaminaOnPerform = false;
        nr_manager.AddActionScripted(action);

        action.RestoreFromSave();
        action.animalType = finalMorph;

        catNames.PushBack('cat_vanilla_01');
        catNames.PushBack('cat_vanilla_02');
        catNames.PushBack('cat_vanilla_03');
        catNames.PushBack('cat_vanilla_04');
        foxNames.PushBack('fox_red');
        foxNames.PushBack('fox_silverish');
        foxNames.PushBack('fox_black');

        if(morphType == 'fox')
        {
            action.appearanceName = foxNames[ NR_GetRandomGenerator().next(foxNames.Size()) ];
        }
        else if(morphType == 'cat')
        {
            action.appearanceName = catNames[ NR_GetRandomGenerator().next(catNames.Size()) ];
        }

        action.OnInit();
        action.OnPrepare();
        action.OnPerform();
    }

    entry function wo_tickEntry()
	{
        while(true)
        {
            parent.updateCompanionIcons();

            if (!parent.getInGame())
            {
                SleepOneFrame();
                continue;
            }

            if(theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HideGhosts'))
            {
                parent.destroyAll();
                SleepOneFrame();
                continue;
            }

            // gwent loop
            if(parent.inGwentGame)
            {
                parent.gwentGameLoop();
            }

            if(parent.poly)
            {
                castPoly();
                parent.poly = false;
            }

            parent.checkAlerts();
            parent.renderPlayers();
            parent.updatePlayerChat();
            parent.updateLocalEmoteLoop();
            parent.pruneGlobalPlayers(5);
            parent.checkOutgoingTrades();
            parent.checkIncomingGwentRequests();
            parent.checkRidingAttachment();
            parent.checkPlayerChange();
            parent.updateWorldSync();
            parent.updateLeaderDialogReadyPopup();
            MP_SU_moveMinimapPins();

            SleepOneFrame();
        }
    }
}

exec function usernameTaken(username : string)
{
    theGame.r_getMultiplayerClient().setUsernameTaken(username);
}

exec function kickedMsg()
{
    theGame.r_getMultiplayerClient().setKicked();
}

exec function bannedMsg()
{
    theGame.r_getMultiplayerClient().setBanned();
}

exec function notWhitelistedMsg()
{
    theGame.r_getMultiplayerClient().setNotWhitelisted();
}

exec function unlockmagic()
{
	NR_GetMagicManager().SetActionSkillLevel(ENR_HandFx, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_Teleport, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_CounterPush, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialLumos, 1);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialWeatherChange, 1);
	NR_GetMagicManager().SetActionSkillLevel(ENR_LightAbstract, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_Slash, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_ThrowAbstract, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_Lightning, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_ProjectileWithPrepare, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_BombExplosion, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_Rock, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_RipApart, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_HeavyAbstract, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_FastTravelTeleport, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialShield, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialTornado, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialControl, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialMeteor, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialServant, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialLightningFall, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialField, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialMeteorFall, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_SpecialPolymorphism, 10);
	NR_GetMagicManager().SetActionSkillLevel(ENR_WaterTrap, 10);
}

function mpghosts_morph(type : name)
{
    var morphMap : NR_Map;
    var morphActive : int;
    var cpcPlayerType : ENR_PlayerType;

    if(theGame.r_getMultiplayerClient().isRiding() || thePlayer.IsUsingHorse(false))
    {
        mpghosts_playSound('gui_global_denied');
        GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114233));
        return;
    }

    cpcPlayerType = NR_GetPlayerManager().GetCurrentPlayerType();  
    morphMap = NR_GetMagicManager().GetMap('none');
    morphActive = morphMap.getI("nr_polymorphysm_active");

    if(cpcPlayerType == ENR_PlayerSorceress)
    {
        if(!morphActive)
        {
            theGame.r_getMultiplayerClient().setPoly(true, type);
        }
        else
        {
            mpghosts_playSound('gui_global_denied');
            GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114234));
        }
    }
    else
    {
        mpghosts_playSound('gui_global_denied');
        GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114229));
    }
}
exec function cat()
{
    mpghosts_morph('cat');
}

exec function fox()
{
    mpghosts_morph('fox');
}

exec function owl()
{
    mpghosts_morph('owl');
}

exec function crow()
{
    mpghosts_morph('crow');
}

function mpghosts_playSound(sound : name)
{
    theSound.SoundEvent(sound);
}

exec function duel(val : string)
{
    theGame.r_getMultiplayerClient().gwentRequest(val);
}

exec function endgwent()
{
    theGame.r_getMultiplayerClient().onGwentGameEnd(true);
}

exec function gwentaction(val : string)
{
    theGame.r_getMultiplayerClient().setLastGwentAction(val);
}

exec function emotes()
{
    theGame.r_getMultiplayerClient().emoteMenu();
}

exec function join(val : string)
{
    var remotePlayer : r_RemotePlayer;
    remotePlayer = mpghosts_getPlayer(val);

    if(remotePlayer)
    {
        theGame.r_getMultiplayerClient().joinParty(remotePlayer.username);
    }
    else
    {
        GetWitcherPlayer().DisplayHudMessage(GetLocStringById(2111114232));
    }
}

exec function leave()
{
    theGame.r_getMultiplayerClient().leaveParty();
}