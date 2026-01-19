// Witcher Online by rejuvenate
// https://www.nexusmods.com/profile/rejuvenate7
struct r_AnimRequest
{
    var anim : name;
    var duration : float;
    var fadeIn : float;
    var fadeOut : float;
    var overrideNow : bool;
    var type : name;
    var loop : bool;
}

struct r_Anim
{
    var anim : name;
    var duration : float;
}

class r_RemotePlayer 
{
    public var id      : string;
    public var lastUpdate : float;
    public var username      : string;
    public var pos     : Vector;
    public var lastMoveDir : name;
    public var lastMoveDirAlt : name;
    public var lastMoveDirAltAlt : name;
    public var lastVerticalMoveDir : name;
    public var yaw     : float;
    public var heading     : float;
    public var speed     : float;
    public var area     : EAreaName;
    public var pin: MP_SU_MapPin;
    public var pinDestroyed: bool;
    public var ghost     : CActor;
    public var inGame : bool;
    public var heldItem : string;
    public var heldSecondaryItem : string;
    public var inCombat : bool;
    public var lastCombat : bool;
    public var isGuarded : bool;
    public var lastHit : float;
    public var lastParry : float;
    public var lastFinisher : float;
    public var signType : ESignType;
    public var lastSign : float;
    public var horseSpeed : float;
    public var menuName : string;
    public var menuStatusActive : bool;
    public var lastStatus : string;
    public var lastUsername : string;

    public var isSwimming : bool;
    public var isDiving : bool;
    public var isFalling : bool;
    public var isSailing : bool;
    public var isMounted : bool;
    public var lastMounted : bool;
    public var aimingCrossbow : bool;
    public var lastAimingCrossbow : bool;
    public var lastMovement : bool;
    public var lastLightAttack : bool;
    public var lastHeavyAttack : bool;
    public var smoothNext : bool;
    public var smoothDelayedNext : bool;
    public var bombActive : bool;
    public var bombSelected : bool;
    public var lastBombSelected : bool;
    public var isAlive : bool;
    public var lastAlive : bool;
    public var lastSliding : bool;
    public var isJumping : bool;
    public var isClimbing : bool;

    public var curState : name;
    public var currentState : name;
    public var lastJumpTime : float;
    public var lastJumpType : EJumpType;
    public var lastClimbType : EClimbHeightType;
    public var lastSwimType : name;
    public var lastMovementType : name;

    public var lastLightAttackTime : float;
    public var lastHeavyAttackTime : float;
    public var lastDodgeTime : float;
    public var lastRollTime : float;
    public var prevHitTime : float;
    public var prevParryTime : float;
    public var prevRollTime : float;
    public var prevDodgeTime : float;
    public var prevFinisherTime : float;
    public var prevSignTime : float;
    public var prevJumpTime : float;
    public var prevClimbTime : float;
    public var isLadder : bool;
    public var lastLadder : bool;
    public var lastLeftLadder : bool;
    public var lastFiredDir : name;
    public var lastLastFiredDir : name;
    public var lastLadderTick : float;

    public var lastAnim : name;
    public var lastEmote : int;
    public var lastEmoteTime : float;
    public var prevEmoteTime : float;
    public var emoteCancelableAt : float;

    public var lastChat : string;
    public var lastChatTime : float;
    public var prevChatTime : float;

    public var prevHeavyTime : float;
    public var prevLightTime : float;

    public var animQueue : array<r_AnimRequest>;
    public var currentAnimEndTime : float;
    public var isAnimPlaying : bool;
    public var currentType : name;

    public var chillOutAnim : name; 
    public var lastChillOutAnim : name; 
    public var lastChillOut : bool;
    public var chillRequeueLead : float;
    public var holdingTorch : bool;

    public var lastRoll : bool;
    public var lastDiving : bool;

    public var lastIdleAnim : float;
    public var lastIdle : bool;
    public var lastIdleRand : int;

    public var stamina : float;
    public var swirling : bool;
    public var lastSwirling : bool;
    public var rend : bool;
    public var lastRend : bool;
    public var channeling : bool;
    public var lastChanneling : bool;
    public var chatShownAt : float;

    public var lastActionTime : float;
    public var prevActionTime : float;
    public var lastAction : EPlayerExplorationAction;

    public var finisherMonster : bool;
    public var currentEmoteLoops : bool;
    public var currentEmoteLoopDur : float;

    public var initSmooth : bool;

    // items
    public var eq_steel : name;
    public var eq_silver : name;
    public var eq_armor : name;
    public var eq_gloves : name;
    public var eq_pants : name;
    public var eq_boots : name;
    public var eq_head : name;
    public var eq_hair : name;
    public var eq_steelScab : name;
    public var eq_silverScab : name;
    public var eq_crossbow : name;
    public var eq_mask : name;

    public var last_eq_steel : name;
    public var last_eq_silver : name;
    public var last_eq_armor : name;
    public var last_eq_gloves : name;
    public var last_eq_pants : name;
    public var last_eq_boots : name;
    public var last_eq_head : name;
    public var last_eq_hair : name;
    public var last_eq_steelScab : name;
    public var last_eq_silverScab : name;
    public var last_eq_crossbow : name;
    public var last_eq_mask : name;

    // cpc
    public var cpcPlayerType : ENR_PlayerType;
    public var cpcHead : name;
    public var cpcHair : string;
    public var cpcBody : string;
    public var cpcTorso : string;
    public var cpcArms : string;
    public var cpcGloves : string;
    public var cpcDress : string;
    public var cpcLegs : string;
    public var cpcShoes : string;
    public var cpcMisc : string;
    public var cpcItem1 : string;
    public var cpcItem2 : string;
    public var cpcItem3 : string;
    public var cpcItem4 : string;
    public var cpcItem5 : string;
    public var cpcItem6 : string;
    public var cpcItem7 : string;
    public var cpcItem8 : string;
    public var cpcItem9 : string;
    public var cpcItem10 : string;

    public var lastcpcPlayerType : ENR_PlayerType;

    public var lastcpcHead : name;
    public var lastcpcHair : string;
    public var lastcpcBody : string;
    public var lastcpcTorso : string;
    public var lastcpcArms : string;
    public var lastcpcGloves : string;
    public var lastcpcDress : string;
    public var lastcpcLegs : string;
    public var lastcpcShoes : string;
    public var lastcpcMisc : string;
    public var lastcpcItem1 : string;
    public var lastcpcItem2 : string;
    public var lastcpcItem3 : string;
    public var lastcpcItem4 : string;
    public var lastcpcItem5 : string;
    public var lastcpcItem6 : string;
    public var lastcpcItem7 : string;
    public var lastcpcItem8 : string;
    public var lastcpcItem9 : string;
    public var lastcpcItem10 : string;

    public var cpcHairTemp : CEntityTemplate;
    public var cpcBodyTemp : CEntityTemplate;
    public var cpcTorsoTemp : CEntityTemplate;
    public var cpcArmsTemp : CEntityTemplate;
    public var cpcGlovesTemp : CEntityTemplate;
    public var cpcDressTemp : CEntityTemplate;
    public var cpcLegsTemp : CEntityTemplate;
    public var cpcShoesTemp : CEntityTemplate;
    public var cpcMiscTemp : CEntityTemplate;
    public var cpcItem1Temp : CEntityTemplate;
    public var cpcItem2Temp : CEntityTemplate;
    public var cpcItem3Temp : CEntityTemplate;
    public var cpcItem4Temp : CEntityTemplate;
    public var cpcItem5Temp : CEntityTemplate;
    public var cpcItem6Temp : CEntityTemplate;
    public var cpcItem7Temp : CEntityTemplate;
    public var cpcItem8Temp : CEntityTemplate;
    public var cpcItem9Temp : CEntityTemplate;
    public var cpcItem10Temp : CEntityTemplate;

    public var hideBody : bool;
    public var headOverride : bool;
    public var hideHair : bool;

    public var nextOnelinerEnsureAt : float;

    private function updateTemplate(templateName : string, prevTemp : CEntityTemplate) : CEntityTemplate
    {
		var appearanceComponent : CAppearanceComponent;
		var            template : CEntityTemplate;
		var                   i : int;

		if (templateName == "")
			return template;

		appearanceComponent = (CAppearanceComponent)ghost.GetComponentByClassName( 'CAppearanceComponent' );

        appearanceComponent.ExcludeAppearanceTemplate(prevTemp);

		if (appearanceComponent) 
        {
			/* LOAD */
			template = (CEntityTemplate)LoadResource( templateName, true );
			if (template) {
				appearanceComponent.IncludeAppearanceTemplate(template);
			} 
        }

        return template;
	}

    private function loadHead(newHeadName : name) {
		var headManager : CHeadManagerComponent;

		headManager = (CHeadManagerComponent)(ghost.GetComponentByClassName( 'CHeadManagerComponent' ));
		//ghost.RememberCustomHead( newHeadName );
		headManager.BlockGrowing( true );
		headManager.SetCustomHead( newHeadName );
	}

    private function removeTemplate(temp : CEntityTemplate)
    {
        var appearanceComponent : CAppearanceComponent;
        appearanceComponent = (CAppearanceComponent)ghost.GetComponentByClassName( 'CAppearanceComponent' );
        appearanceComponent.ExcludeAppearanceTemplate(temp);
    }

    private function updateCPC()
    {
        if(NR_GetPlayerManager().IsPlayerTypeChangeLocked() || theGame.IsDialogOrCutscenePlaying() || thePlayer.IsInNonGameplayCutscene())
            return;
        
        if(lastcpcPlayerType != cpcPlayerType)
        {
            removeTemplate(cpcHairTemp);
            removeTemplate(cpcBodyTemp);
            removeTemplate(cpcTorsoTemp);
            removeTemplate(cpcArmsTemp);
            removeTemplate(cpcGlovesTemp);
            removeTemplate(cpcDressTemp);
            removeTemplate(cpcLegsTemp);
            removeTemplate(cpcShoesTemp);
            removeTemplate(cpcMiscTemp);
            removeTemplate(cpcItem1Temp);
            removeTemplate(cpcItem2Temp);
            removeTemplate(cpcItem3Temp);
            removeTemplate(cpcItem4Temp);
            removeTemplate(cpcItem5Temp);
            removeTemplate(cpcItem6Temp);
            removeTemplate(cpcItem7Temp);
            removeTemplate(cpcItem8Temp);
            removeTemplate(cpcItem9Temp);
            removeTemplate(cpcItem10Temp);
            hideBody = false;
            hideHair = false;
            last_eq_hair = '';
            headOverride = false;

            lastcpcHead = '';
            lastcpcHair = "";
            lastcpcBody = "";
            lastcpcTorso = "";
            lastcpcArms = "";
            lastcpcGloves = "";
            lastcpcDress = "";
            lastcpcLegs = "";
            lastcpcShoes = "";
            lastcpcMisc = "";
            lastcpcItem1 = "";
            lastcpcItem2 = "";
            lastcpcItem3 = "";
            lastcpcItem4 = "";
            lastcpcItem5 = "";
            lastcpcItem6 = "";
            lastcpcItem7 = "";
            lastcpcItem8 = "";
            lastcpcItem9 = "";
            lastcpcItem10 = "";

            spawnGhost();

            if(cpcPlayerType == ENR_PlayerCiri)
            {
                // ciri head
                EquipNewItem(ghost.GetInventory(), last_eq_head, 'nr_h_01_wa__ciri');
                headOverride = true;
                
                unmountHair();
                hideHair = true;

                //ciri hair
                cpcHairTemp = updateTemplate("characters/models/main_npc/ciri/c_01_wa__ciri.w2ent", cpcHairTemp);
                unmountHair();
                hideHair = true;

                //ciri body
                cpcBodyTemp = updateTemplate("characters/models/main_npc/ciri/body_01_wa__ciri.w2ent", cpcBodyTemp);
                hideBody = true;
            }
        }

        lastcpcPlayerType = cpcPlayerType;

        if(cpcPlayerType == ENR_PlayerGeralt || cpcPlayerType == ENR_PlayerCiri)
        {
            return;
        }

        if(lastcpcHead != cpcHead && cpcHead != 'none')
        {
            EquipNewItem(ghost.GetInventory(), last_eq_head, cpcHead);
            headOverride = true;
            
            unmountHair();
            hideHair = true;
        }

        if(lastcpcHair != cpcHair && cpcHair != "none")
        {
            cpcHairTemp = updateTemplate(cpcHair, cpcHairTemp);

            unmountHair();
            hideHair = true;
        }
        else if(cpcHair == "none")
        {
            unmountHair();
            removeTemplate(cpcHairTemp);
            hideHair = true;
        }

        if(lastcpcBody != cpcBody && cpcBody != "none")
        {
            cpcBodyTemp = updateTemplate(cpcBody, cpcBodyTemp);
            hideBody = true;
        }
        else if(cpcBody == "none")
        {
            removeTemplate(cpcBodyTemp);
        }

        if(lastcpcTorso != cpcTorso && cpcTorso != "none")
        {
            cpcTorsoTemp = updateTemplate(cpcTorso, cpcTorsoTemp);
            hideBody = true;
        }
        else if(cpcTorso == "none")
        {
            removeTemplate(cpcTorsoTemp);
        }

        if(lastcpcArms != cpcArms && cpcArms != "none")
        {
            cpcArmsTemp = updateTemplate(cpcArms, cpcArmsTemp);
            hideBody = true;
        }
        else if(cpcArms == "none")
        {
            removeTemplate(cpcArmsTemp);
        }

        if(lastcpcGloves != cpcGloves && cpcGloves != "none")
        {
            cpcGlovesTemp = updateTemplate(cpcGloves, cpcGlovesTemp);
            hideBody = true;
        }
        else if(cpcGloves == "none")
        {
            removeTemplate(cpcGlovesTemp);
        }

        if(lastcpcDress != cpcDress && cpcDress != "none")
        {
            cpcDressTemp = updateTemplate(cpcDress, cpcDressTemp);
            hideBody = true;
        }
        else if(cpcDress == "none")
        {
            removeTemplate(cpcDressTemp);
        }

        if(lastcpcLegs != cpcLegs && cpcLegs != "none")
        {
            cpcLegsTemp = updateTemplate(cpcLegs, cpcLegsTemp);
            hideBody = true;
        }
        else if(cpcLegs == "none")
        {
            removeTemplate(cpcLegsTemp);
        }

        if(lastcpcShoes != cpcShoes && cpcShoes != "none")
        {
            cpcShoesTemp = updateTemplate(cpcShoes, cpcShoesTemp);
            hideBody = true;
        }
        else if(cpcShoes == "none")
        {
            removeTemplate(cpcShoesTemp);
        }

        if(lastcpcMisc != cpcMisc && cpcMisc != "none")
        {
            cpcMiscTemp = updateTemplate(cpcMisc, cpcMiscTemp);
        }
        else if(cpcMisc == "none")
        {
            removeTemplate(cpcMiscTemp);
        }

        if(lastcpcItem1 != cpcItem1 && cpcItem1 != "none")
        {
            cpcItem1Temp = updateTemplate(cpcItem1, cpcItem1Temp);
        }
        else if(cpcItem1 == "none")
        {
            removeTemplate(cpcItem1Temp);
        }

        if(lastcpcItem2 != cpcItem2 && cpcItem2 != "none")
        {
            cpcItem2Temp = updateTemplate(cpcItem2, cpcItem2Temp);
        }
        else if(cpcItem2 == "none")
        {
            removeTemplate(cpcItem2Temp);
        }

        if(lastcpcItem3 != cpcItem3 && cpcItem3 != "none")
        {
            cpcItem3Temp = updateTemplate(cpcItem3, cpcItem3Temp);
        }
        else if(cpcItem3 == "none")
        {
            removeTemplate(cpcItem3Temp);
        }

        if(lastcpcItem4 != cpcItem4 && cpcItem4 != "none")
        {
            cpcItem4Temp = updateTemplate(cpcItem4, cpcItem4Temp);
        }
        else if(cpcItem4 == "none")
        {
            removeTemplate(cpcItem4Temp);
        }

        if(lastcpcItem5 != cpcItem5 && cpcItem5 != "none")
        {
            cpcItem5Temp = updateTemplate(cpcItem5, cpcItem5Temp);
        }
        else if(cpcItem5 == "none")
        {
            removeTemplate(cpcItem5Temp);
        }

        if(lastcpcItem6 != cpcItem6 && cpcItem6 != "none")
        {
            cpcItem6Temp = updateTemplate(cpcItem6, cpcItem6Temp);
        }
        else if(cpcItem6 == "none")
        {
            removeTemplate(cpcItem6Temp);
        }

        if(lastcpcItem7 != cpcItem7 && cpcItem7 != "none")
        {
            cpcItem7Temp = updateTemplate(cpcItem7, cpcItem7Temp);
        }
        else if(cpcItem7 == "none")
        {
            removeTemplate(cpcItem7Temp);
        }

        if(lastcpcItem8 != cpcItem8 && cpcItem8 != "none")
        {
            cpcItem8Temp = updateTemplate(cpcItem8, cpcItem8Temp);
        }
        else if(cpcItem8 == "none")
        {
            removeTemplate(cpcItem8Temp);
        }

        if(lastcpcItem9 != cpcItem9 && cpcItem9 != "none")
        {
            cpcItem9Temp = updateTemplate(cpcItem9, cpcItem9Temp);
        }
        else if(cpcItem9 == "none")
        {
            removeTemplate(cpcItem9Temp);
        }

        if(lastcpcItem10 != cpcItem10 && cpcItem10 != "none")
        {
            cpcItem10Temp = updateTemplate(cpcItem10, cpcItem10Temp);
        }
        else if(cpcItem10 == "none")
        {
            removeTemplate(cpcItem10Temp);
        }

        lastcpcHead = cpcHead;
        lastcpcHair = cpcHair;
        lastcpcBody = cpcBody;
        lastcpcTorso = cpcTorso;
        lastcpcArms = cpcArms;
        lastcpcGloves = cpcGloves;
        lastcpcDress = cpcDress;
        lastcpcLegs = cpcLegs;
        lastcpcShoes = cpcShoes;
        lastcpcMisc = cpcMisc;
        lastcpcItem1 = cpcItem1;
        lastcpcItem2 = cpcItem2;
        lastcpcItem3 = cpcItem3;
        lastcpcItem4 = cpcItem4;
        lastcpcItem5 = cpcItem5;
        lastcpcItem6 = cpcItem6;
        lastcpcItem7 = cpcItem7;
        lastcpcItem8 = cpcItem8;
        lastcpcItem9 = cpcItem9;
        lastcpcItem10 = cpcItem10;
    }

    private function queueAnim(anim : name, duration : float, fadeIn : float, fadeOut : float, type : name, optional overrideNow : bool, optional loop : bool)
    {
        var req : r_AnimRequest;

        if (isAnimPlaying && currentType == 'emote' && type != 'emote')
            return;

        if (!isAnimPlaying && animQueue.Size() > 0 && animQueue[0].type == 'emote' && type != 'emote')
            return;

        if (!overrideNow && isAnimPlaying && currentType == type && lastAnim == anim)
            return;

        if (animQueue.Size() > 0)
        {
            if (animQueue[0].anim == anim && animQueue[0].type == type && !overrideNow)
                return;
        }

        req.anim = anim;
        req.duration = duration;
        req.fadeIn = fadeIn;
        req.fadeOut = fadeOut;
        req.type = type;
        req.overrideNow = overrideNow;
        req.loop = loop;

        if (isAnimPlaying && IsLocomotion(currentType) && IsLocomotion(type) && currentType != type)
        {
            animQueue.Clear();
            playAnimNow(req);
            return;
        }

        if ((isAnimPlaying && currentType == 'emote') || (animQueue.Size() > 0 && animQueue[0].type == 'emote'))
        {
            if (type != 'emote') 
                return;
            if (animQueue.Size() >= 5) 
                return; 

            animQueue.PushBack(req);
            return;
        }

        if(overrideNow)
        {
            animQueue.Clear();
            playAnimNow(req);
            return;
        }

        if (animQueue.Size() > 0)
        {
            if (isAnimPlaying && IsProtected(currentType) && IsLocomotion(type))
            {
                animQueue[0] = req;
                return;
            }

            if (IsLocomotion(animQueue[0].type) && IsLocomotion(type) && animQueue[0].type != type)
            {
                animQueue.Clear();
                playAnimNow(req);
                return;
            }
        }

        if(type == 'chillout' && animQueue.Size() >= 1) 
            return;

        if (animQueue.Size() >= 3) 
            return;

        animQueue.PushBack(req);
    }

    private function playAnimFromQueue()
    {
        var request : r_AnimRequest;

        if (isAnimPlaying) return;
        if (animQueue.Size() == 0) return;

        request = animQueue[0];
        animQueue.Erase(0);
        playAnimNow(request);
    }

    private function playAnimNow(request : r_AnimRequest)
    {
        var now : float;
        now = theGame.GetEngineTimeAsSeconds();
        
        ghost.GetRootAnimatedComponent().PlaySlotAnimationAsync(
            request.anim, 
            'NPC_ANIM_SLOT',
            SAnimatedComponentSlotAnimationSettings(request.fadeIn, request.fadeOut)
        );

        isAnimPlaying = true;
        currentType = request.type; 
        currentAnimEndTime = now + request.duration;

        if (currentType == 'emote')
        {
            currentEmoteLoops = request.loop;
            currentEmoteLoopDur = request.duration;

            if (emoteCancelableAt <= 0.0f)
            {
                emoteCancelableAt = now + 4.0f;
            }
        }
        else
        {
            emoteCancelableAt = 0.0f;
            currentEmoteLoops = false;
            currentEmoteLoopDur = 0.0f; 
        }

        lastAnim = request.anim;
    }

    private function stopAllAnims()
    {
        animQueue.Clear();

        isAnimPlaying = false;
        currentAnimEndTime = 0.0f;
        currentType = 'none';
        lastAnim = '';

        currentEmoteLoops = false;
        currentEmoteLoopDur = 0.0f;
        emoteCancelableAt = 0.0f;

        ghost.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.7f, 0.7f) );

        smoothNext = true;
    }

    private function updateAnimState()
    {
        var now : float = theGame.GetEngineTimeAsSeconds();
        var req : r_AnimRequest;

        if (isAnimPlaying && now >= currentAnimEndTime)
        {
            if (currentType == 'emote' && currentEmoteLoops && animQueue.Size() == 0)
            {
                req.anim = lastAnim;
                req.duration = currentEmoteLoopDur;
                req.fadeIn = 0.4f;
                req.fadeOut = 0.0f;
                req.type = 'emote';
                req.overrideNow = true;
                req.loop = true;

                playAnimNow(req);
                return;
            }

            isAnimPlaying = false;

            if (animQueue.Size() == 0)
            {
                if (currentType == 'emote')
                {
                    unmountItems();
                    smoothNext = true;
                }

                currentType = 'none';
                currentEmoteLoops = false;
                currentEmoteLoopDur = 0.0f;
                emoteCancelableAt = 0.0f;  
            }
        }

        if (isAnimPlaying && currentType == 'emote')
        {
            if(lastEmote == -2)
            {
                stopAllAnims();
                lastEmote = -1;
            }
        }

        if (isAnimPlaying && currentType == 'emote' && lastMoveDirAlt != 'none')
        {
            if (emoteCancelableAt > 0.0f && now >= emoteCancelableAt)
            {
                if(lastAnim != 'fall_up_idle' && lastAnim != 'ep1_mirror_sitting_on_shrine_gesture_explain_04' && lastAnim != 'locomotion_salsa_cycle_02' && 
                    lastAnim != 'seaman_working_on_the_ship_loop_01' && lastAnim != 'geralt_drunk_walk')
                {
                    stopAllAnims();
                }
            }
        }

        if (isAnimPlaying && currentType == 'emote' && lastMoveDirAltAlt != 'none')
        {
            if (emoteCancelableAt > 0.0f && now >= emoteCancelableAt)
            {
                if(lastAnim != 'fall_up_idle')
                {
                    stopAllAnims();
                }
            }
        }

        if (!isAnimPlaying && animQueue.Size() > 0)
        {
            playAnimFromQueue();
        }
    }

    private function IsLocomotion(t : name) : bool
    {
        return (t == 'forward' || t == 'backward' || t == 'left' || t == 'right' 
                || t == 'fistidle' || t == 'swordidle' || t == 'parryswordidle' || t == 'parryfistidle'
                || t == 'swim_idle' || t == 'swim_idle_underwater' || t == 'swim_fast_f' || t == 'swim_fast_l' || t == 'swim_fast_r' || t == 'swim_slow_f' || t == 'swim_slow_l' || t == 'swim_slow_r' || t == 'swim_up_f' || t == 'swim_up_l' || t == 'swim_up_r' || t == 'swim_down_f' || t == 'swim_down_l' || t == 'swim_down_r' || t == 'swim_underwater_f' || t == 'swim_underwater_l' || t == 'swim_underwater_r'
                || t == 'sailing' 
                || t == 'mounted_0' || t == 'mounted_1' || t == 'mounted_2' || t == 'mounted_3' 
                || t == 'mounted_4' || t == 'mounted_5'
                || t == 'crossbow_forward' || t == 'crossbow_backward' || t == 'crossbow_left' || t == 'crossbow_right' || t == 'crossbow_idle' || t == 'swim_crossbow_idle'
                || t == 'falling'
                || t == 'movement_idle' || t == 'movement_slow_walk' || t == 'movement_walk' || t == 'movement_run' || t == 'movement_sprint'
                || t == 'sword_movement_idle' || t == 'sword_movement_slow_walk' || t == 'sword_movement_walk' || t == 'sword_movement_run' || t == 'sword_movement_sprint'
                || t == 'ladder_up' || t == 'ladder_down' || t == 'bomb'
                || t == 'chillout' || t == 'slide' || t == 'swirl');
    }

    private function IsProtected(t : name) : bool
    {
        return (t == 'dodge' || t == 'roll' || t == 'attack' || t == 'hit' || t == 'parry' || t == 'finisher'
                || t == 'sign' || t == 'jump' || t == 'climb' || t == 'dead' || t == 'rend');
    }

    private function ensureOneliners()
    {
        var tag : string = "MPGhost" + id;
        var statusTag : string = "MPGhostStatus" + id;

        MP_SUOL_getManager().deleteByTag(tag);
        MP_SUOL_getManager().deleteByTag(statusTag);
        //MP_SUOL_getManager().deleteOneliner(oneliner);
        //MP_SUOL_getManager().deleteOneliner(chatOneliner);

        createOneliner();
        createStatusOneliner();
    }

    private function getUsernameColor() : string
    {
        var colors : array<r_NameColor>;
        var i : int;

        colors = theGame.r_getMultiplayerClient().getNameColors();

        for(i = 0; i < colors.Size(); i += 1)
        {
            if(colors[i].playerName == username)
            {
                return colors[i].color;
            }
        }

        return "#EDCBA3";
    }

    private function createOneliner()
    {
        var tag : string;
        var oneliner     : MP_SU_OnelinerEntity;

        tag = "MPGhost" + id;

        oneliner = (MP_SU_OnelinerEntity)MP_SUOL_getManager().findByTag(tag);

        if(oneliner)
        {
            oneliner.entity = ghost;
            oneliner.visible = true;
            return;
        }

        oneliner = new MP_SU_OnelinerEntity in theInput;
        oneliner.text = (new MP_SUOL_TagBuilder in theInput)
        .tag("font")
        .attr("size", "20")
        .attr("color", getUsernameColor())
        .text(username);
        oneliner.visible = true;
        oneliner.entity = ghost;
        oneliner.tag = tag;
        oneliner.render_distance = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_RenderDistance'));
        MP_SUOL_getManager().createOneliner(oneliner);
    }

    private function createStatusOneliner()
    {
        var tag : string;
        var chatOneliner     : MP_SU_OnelinerEntity;

        tag = "MPGhostStatus" + id;

        lastStatus = "";
        chatOneliner = (MP_SU_OnelinerEntity)MP_SUOL_getManager().findByTag(tag);

        if(chatOneliner)
        {
            chatOneliner.entity = ghost;
            chatOneliner.visible = false;
            return;
        }
        
        chatOneliner = new MP_SU_OnelinerEntity in theInput;
        chatOneliner.offset = Vector(0,0,1.95);
        chatOneliner.visible = false;
        chatOneliner.entity = ghost;
        chatOneliner.tag = tag;
        chatOneliner.render_distance = 100;
        MP_SUOL_getManager().createOneliner(chatOneliner);
    }

    private function updateUsername()
    {
        var oneliner     : MP_SU_OnelinerEntity;
        var tag : string;

        tag = "MPGhost" + id;

        if(lastUsername != username)
        {
            lastUsername = username;

            oneliner = (MP_SU_OnelinerEntity)MP_SUOL_getManager().findByTag(tag);
        
            if(!oneliner)
                return;

            oneliner.text = (new MP_SUOL_TagBuilder in theInput)
            .tag("font")
            .attr("size", "20")
            .attr("color", getUsernameColor())
            .text(username);

            oneliner.visible = true;
            MP_SUOL_getManager().updateOneliner(oneliner);
        }
    }

    private function updateStatus(msg : string)
    {
        var tag : string;
        var chatOneliner     : MP_SU_OnelinerEntity;

        tag = "MPGhostStatus" + id;

        chatOneliner = (MP_SU_OnelinerEntity)MP_SUOL_getManager().findByTag(tag);

        if(!chatOneliner)
            return;

        chatOneliner.text = (new MP_SUOL_TagBuilder in theInput)
        .tag("font")
        .attr("size", "20")
        .attr("color", "#ffffff")
        .text(msg);

        MP_SUOL_getManager().updateOneliner(chatOneliner);
    }

    private function createPin()
    {
        pin = new MP_SU_MapPin in thePlayer;
        pin.tag = "MPGhost_" + id;
        pin.position = ghost.GetWorldPosition();
        pin.description = username + "'s current location.";
        pin.label = username;
        pin.type = "Player";
        pin.radius = 0;
        pin.region = area;
        pin.appears_on_minimap = true;
        pin.highlighted = false;
        pin.pointed_by_arrow = false;
        pin.is_fast_travel = true;

        MP_SUMP_addCustomPin(pin);
    }

    private function updatePin()
    {
        var playerAngle         : float;
        playerAngle = -yaw;

        if(!pin && !pinDestroyed)
        {
            createPin();
        }

        if ( playerAngle < 0 )
		{
			playerAngle += 360.0;
		}

        pin.position = ghost.GetWorldPosition();
        pin.rotation = playerAngle;
        pin.description = username + "'s current location.";
        pin.label = username;
        pin.region = area;
        MP_SU_updateMinimapPins();
    }

    public function destroyPin()
    {
        pinDestroyed = true;
        MP_SU_removeCustomPinByTag("MPGhost_" + id);
    }

    public function Init()
    {
        spawnGhost();
        createPin();
        isAlive = true;

        prevJumpTime = 0;
        chatShownAt = -1;

        prevLightTime = -1;
        prevHeavyTime = -1;
        prevHitTime = -1;
        prevParryTime = -1;
        prevRollTime = -1;
        prevDodgeTime = -1;
        prevFinisherTime = -1;
        prevSignTime = -1;
        prevEmoteTime = -1;
        prevChatTime = -1;

        lastMoveDir = 'none';
        lastVerticalMoveDir = 'none';
        currentType = 'none';
        lastSwimType = 'none';
        lastMovementType = 'none';
        lastEmote = -1;
        chillRequeueLead = 0.12;
        
        smoothNext = true;

        lastcpcPlayerType = ENR_PlayerGeralt;

        lastIdleAnim = theGame.GetEngineTimeAsSeconds();
    }

    private function ClassifyMoveDirRelativeToCamera(entpos : Vector, targpos : Vector, camYawDeg : float) : name
    {
        var moveVec : Vector;
        var moveHeadingDeg, d : float;

        moveVec = targpos - entpos;

        if (VecLength(moveVec) < 0.05f)
            return 'none';

        moveHeadingDeg = VecHeading(moveVec);
        d = AngleDistance(moveHeadingDeg, camYawDeg);

        if (AbsF(d) <= 45.0f)      
            return 'forward';
        if (AbsF(d) >= 135.0f)     
            return 'backward';
        if (d > 0.0f)              
            return 'left';

        return 'right';
    }

    private function ClassifyVerticalMoveDir(entpos : Vector, targpos : Vector) : name
    {
        var deltaZ : float;
        deltaZ = targpos.Z - entpos.Z;

        if (AbsF(deltaZ) < 0.05f)
            return 'none';

        if (deltaZ > 0.0f)
            return 'up';

        return 'down';
    }

    private function spawnGhost()
    {
        var rot : EulerAngles;
        var ids : array<SItemUniqueId>;
        var inv : CInventoryComponent;

        if(ghost)
        {
            ghost.Destroy();
        }

        initSmooth = false;

        if(cpcPlayerType == ENR_PlayerGeralt || cpcPlayerType == ENR_PlayerWitcher || cpcPlayerType == ENR_PlayerUnknown)
        {
            ghost = (CActor)theGame.CreateEntity((CEntityTemplate)LoadResource("dlc\dlc_mpmod\data\entities\geralt_npc.w2ent", true ), pos, rot, true, true, false, PM_DontPersist );
        }
        else
        {
            ghost = (CActor)theGame.CreateEntity((CEntityTemplate)LoadResource("dlc\dlc_mpmod\data\entities\female_npc.w2ent", true ), pos, rot, true, true, false, PM_DontPersist );
        }

        ghost.AddTag('MPEntity');
        ghost.EnableCollisions(false);
        ghost.EnableCharacterCollisions(false); 
        ghost.SetGameplayVisibility( false );
        ghost.SetCanPlayHitAnim(false);
        ghost.SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

        ghost.SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
        ghost.SetAttitude(thePlayer, AIA_Friendly);

        if(!ghost.HasAbility('IsNotScaredOfMonsters')) ghost.AddAbility('IsNotScaredOfMonsters', true); 

        inv = ghost.GetInventory();

        ids = inv.AddAnItem('Torch_work', 1); 
        ghost.EquipItem(ids[0]);

        if(cpcPlayerType == ENR_PlayerCiri)
        {
            ids = inv.AddAnItem('Zireael Sword', 1); 
        }

        ensureOneliners();
    }

    private function updateOneliners()
    {
        var tag : string;
        var statusTag : string; 
        var now : float = theGame.GetEngineTimeAsSeconds();
        var oneliner     : MP_SU_OnelinerEntity;
        var chatOneliner     : MP_SU_OnelinerEntity;

        if (now < nextOnelinerEnsureAt) return;

        nextOnelinerEnsureAt = now + 0.25;

        tag = "MPGhost" + id;
        statusTag = "MPGhostStatus" + id;

        oneliner = (MP_SU_OnelinerEntity)MP_SUOL_getManager().findByTag(tag);
        chatOneliner = (MP_SU_OnelinerEntity)MP_SUOL_getManager().findByTag(statusTag);
        
        if (!oneliner)
        {
            createOneliner();
        }

        if(!chatOneliner)
        {
            createStatusOneliner();
        }
    }

    private function repairGhost()
    {
        if(!ghost)
        {
            spawnGhost();
        }
    }

    public function updateGhost()
    {
        var actors : array<CActor>;
        var i : int;

        repairGhost();
        updateAnimState();
        updateChillOut();
        updateGeraltAnims();
        updateHeldItems();
        updateEquippedItems();
        playEmotes();
        updateMenuStatus();
        updateChat();
        updateCPC();
        moveEntity(ghost, pos);
        updatePin();
        fixGeraltAppearance();
        updateUsername();
        updateOneliners();
        prune();
    }

    private function prune()
    {
        if((theGame.GetEngineTimeAsSeconds() - lastUpdate) > 10)
        {
            theGame.r_getMultiplayerClient().disconnect(id);
            theGame.r_getMultiplayerClient().disconnectGlobal(id);
        }
    }

    private function Unmount(itemName: name) {
        var i: int;
        var items: array<SItemUniqueId>;

        if (itemName == '') return;

        items = ghost.GetInventory().GetItemsByName(itemName);
        for (i = 0; i < items.Size(); i += 1) {
            ghost.GetInventory().DespawnItem(items[i]);
            ghost.GetInventory().UnmountItem(items[i], true);
        }
    }

    private function unmountItems()
    {
        Unmount('Horn');
        Unmount('card_deck');
        Unmount('card_single');
        Unmount('bread_piece');
        Unmount('Apple_01');
        Unmount('Pipe_01'); 
        Unmount('Meat_04'); 
        Unmount('meat_food'); 
        Unmount('Fishing_rod'); 
        Unmount('Cup_01'); 
        Unmount('Ladle_01'); 
        Unmount('cutlery_fork'); 
        Unmount('cutlery_rich_knife'); 
    }

    private function updateChillOut()
    {
        var chillDur : float;
        var now : float = theGame.GetEngineTimeAsSeconds();

        if ((now - theGame.r_getMultiplayerClient().getSpawnTime()) < 2) return;

        if (chillOutAnim != '')
        {
            chillDur = theGame.r_getMultiplayerClient().findChillDuration(chillOutAnim);

            if (!lastChillOut || currentType != 'chillout')
            {
                queueAnim(chillOutAnim, chillDur, 0.3, 0, 'chillout', true);
                lastChillOutAnim = chillOutAnim;
                lastChillOut = true;
                return;
            }

            if (lastChillOutAnim != chillOutAnim)
            {
                queueAnim(chillOutAnim, chillDur, 0.3, 0, 'chillout', true);
                lastChillOutAnim = chillOutAnim;
                return;
            }

            if (chillDur != -1 && isAnimPlaying && currentType == 'chillout' && animQueue.Size() == 0 && now >= (currentAnimEndTime - chillRequeueLead))
            {
                queueAnim(chillOutAnim, chillDur, 0, 0, 'chillout');
            }
        }
        else
        {
            if (lastChillOut)
            {
                stopAllAnims();
                unmountItems();
                lastJumpTime = 99;
                lastChillOut = false;
                smoothNext = true;
            }
        }
    }

    private function updateChat()
    {
        var chatOneliner     : MP_SU_OnelinerEntity;

        if((theGame.GetEngineTimeAsSeconds() - theGame.r_getMultiplayerClient().getSpawnTime()) < 2)
        {
            return;
        }

        if(menuName != "none")
        {
            return;
        }

        chatOneliner = (MP_SU_OnelinerEntity)MP_SUOL_getManager().findByTag("MPGhostStatus" + id);

        if(!chatOneliner)
        {
            return;
        }

        if (prevChatTime < 0.0f)
        {
            prevChatTime = lastChatTime;
        }
        else if (lastChatTime != prevChatTime)
        {
            updateStatus(lastChat);
            chatOneliner.visible = true;
            prevChatTime = lastChatTime;
            chatShownAt = theGame.GetEngineTimeAsSeconds();
        }

        if (chatOneliner && chatOneliner.visible && chatShownAt >= 0.0f)
        {
            if ((theGame.GetEngineTimeAsSeconds() - chatShownAt) > 12.0f)
            {
                chatOneliner.visible = false;
                chatShownAt = -1.0f;
            }
        }
    }

    private function updateMenuStatus()
    {
        var status : string;
        var chatOneliner     : MP_SU_OnelinerEntity;

        if((theGame.GetEngineTimeAsSeconds() - theGame.r_getMultiplayerClient().getSpawnTime()) < 2)
        {
            return;
        }  

        chatOneliner = (MP_SU_OnelinerEntity)MP_SUOL_getManager().findByTag("MPGhostStatus" + id);

        if(!chatOneliner)
        {
            return;
        }

        if(menuName == "none")
        {
            if(menuStatusActive)
            {
                chatOneliner.visible = false;
                menuStatusActive = false;
                lastStatus = "";
            }
            
            return;
        }

        if (menuName == "IngameMenu")
			status = "Game paused";
        else if (menuName == "GlossaryBestiaryMenu")
            status = "In the bestiary menu";
        else if (menuName == "GlossaryTutorialsMenu")
            status = "In the tutorial menu";
        else if (menuName == "GlossaryEncyclopediaMenu")
            status = "In the characters menu";
        else if (menuName == "GlossaryBooksMenu")
            status = "In the books menu";
        else if (menuName == "CraftingMenu")
            status = "In the crafting menu";
        else if (menuName == "AlchemyMenu")
            status = "In the alchemy menu";
        else if (menuName == "InventoryMenu")
            status = "In the inventory menu";
        else if (menuName == "MapMenu")
            status = "In the map menu";
        else if (menuName == "JournalQuestMenu")
            status = "In the quests menu";
        else if (menuName == "CharacterMenu")
            status = "In the character menu";
        else if (menuName == "MeditationClockMenu")
            status = "In the mediation menu";
        else if (menuName == "BlacksmithMenu")
            status = "In the blacksmith menu";

        if(status == "")
        {
            return;
        }

        if(lastStatus != status)
        {
            lastStatus = status;
            menuStatusActive = true;

            updateStatus(status);
            chatOneliner.visible = true;
        }
    }

    private function playEmotes()
    {
        if((theGame.GetEngineTimeAsSeconds() - theGame.r_getMultiplayerClient().getSpawnTime()) < 2)
        {
            return;
        }

        if (prevEmoteTime < 0.0f)
        {
            prevEmoteTime = lastEmoteTime;
        }
        else if (lastEmoteTime != prevEmoteTime)
        {
            if (lastEmote == 0)
            {
                queueAnim('man_work_greeting_with_hand_gesture_05', 3.13, 0.4, 0, 'emote', true, true);
            }
            else if (lastEmote == 1)
            {
                queueAnim('man_work_greeting_with_hand_gesture_02', 3.3, 0.4, 0, 'emote', true);
            }
            else if (lastEmote == 2)
            {
                //queueAnim('meditation_start_long', 3.7, 0.4, 0, 'emote', true);
                queueAnim('meditation_idle01', 6.1, 0.4, 0, 'emote', true, true);
                //queueAnim('meditation_stop_long', 2.83, 0, 0, 'emote');
            }
            else if (lastEmote == 3)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('add_gesture_question_01', 3.27, 0.4, 0, 'emote', true);
                }
                else
                {
                    queueAnim('high_standing_determined_gesture_question', 2.03, 0.4, 0, 'emote', true);
                }
            }
            else if (lastEmote == 4)
            {
                queueAnim('add_gesture_point_forward', 5, 0.4, 0, 'emote', true);
            }
            else if (lastEmote == 5)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('high_standing_aggressive_gesture_decline_01', 3.7, 0.4, 0, 'emote', true);
                }
                else
                {
                    queueAnim('high_standing_determined_gesture_holdit', 5.23, 0.4, 0, 'emote', true);
                }
            }
            else if (lastEmote == 6)
            {
                queueAnim('man_crying_loop_01', 5.17, 0.4, 0, 'emote', true, true);
            }
            else if (lastEmote == 7)
            {
                queueAnim('man_cheering_loop', 3.63, 0.4, 0, 'emote', true, true);
            }
            else if (lastEmote == 8)
            {
                //queueAnim('man_begging_for_mercy_start', 5.00, 0.4, 0, 'emote', true);
                queueAnim('man_begging_for_mercy_loop_01', 10.53, 0.4, 0, 'emote', true, true);
            }
            else if (lastEmote == 9)
            {
                queueAnim('audience_in_theatre_standing_loop_02', 8.97, 0.4, 0, 'emote', true);
            }
            else if (lastEmote == 10)
            {
                queueAnim('man_work_drunk_puke', 6.33, 0.4, 0, 'emote', true);
            }
            else if (lastEmote == 11)
            {
                queueAnim('geralt_drunk_walk', 2.8, 0.4, 0, 'emote', true, true);
            }
            else if (lastEmote == 12)
            {
                queueAnim('man_praying_crossed_legs_loop_02', 7.5, 0.4, 0, 'emote', true, true);
            }
            else if (lastEmote == 13)
            {
                queueAnim('q101_man_hitting_alarm_bell_with_hammer_loop_01', 3.5, 0.4, 0, 'emote', true);
            }
            else if (lastEmote == 14)
            {
                queueAnim('q103_man_prophesying_1', 15.07, 0.4, 0, 'emote', true, true);
            }
            else if (lastEmote == 15)
            {
                queueAnim('q203_druid_using_wand_1', 14, 0.4, 0, 'emote', true);
            }
            else if (lastEmote == 16)
            {
                queueAnim('geralt_chocking_loop_01', 7.67, 0.4, 0, 'emote', true);
            }
            else if (lastEmote == 17)
            {
                queueAnim('seaman_working_on_the_ship_loop_01', 3.6, 0.4, 0, 'emote', true, true);
            }
            else if (lastEmote == 18)
            {
                queueAnim('ep1_high_standing_determined2_gesture_laugh_01', 3, 0.4, 0, 'emote', true);
            }
            else if (lastEmote == 19)
            {
                queueAnim('vanilla_sitting_on_ground_loop', 15.63, 0.4, 0, 'emote', true, true);
            }
            else if (lastEmote == 20)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('woman_noble_lying_relaxed_on_grass_loop_03', 11.2, 0.4, 0, 'emote', true, true);
                }
                else
                {
                    queueAnim('mq7009_geralt_heroic_pose_lying', 19.7, 0.4, 0, 'emote', true, true);
                }
            }
            else if (lastEmote == 21)
            {
                queueAnim('locomotion_salsa_cycle_02', 40, 0.4, 0, 'emote', true, true);
            }
            else if (lastEmote == 22)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('high_standing_determined_gesture_cough', 4.37, 0.4, 0, 'emote', true);
                }
                else
                {
                    queueAnim('high_standing_determined_gesture_facepalm', 9.47, 0.4, 0, 'emote', true);
                }
            }
            else if (lastEmote == 23)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('woman_work_standing_hands_crossed_loop_02', 5.43, 0.4, 0, 'emote', true, true);
                }
                else
                {
                    queueAnim('high_standing_determined2_idle', 23.07, 0.4, 0, 'emote', true, true);
                }
            }
            else if (lastEmote == 24)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('q705_anarietta_standing_tense_gesture_angry', 11.43, 0.4, 0, 'emote', true);
                }
                else
                {
                    queueAnim('high_standing_sad_gesture_go_plough_yourself', 4.6, 0.4, 0, 'emote', true);
                }
            }
            else if (lastEmote == 25)
            {
                queueAnim('man_use_horn', 8.33, 0.4, 0, 'emote', true);
            }
            else if (lastEmote == 26)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('ep1_mirror_sitting_on_shrine_gesture_explain_04', 9.37, 0.4, 0, 'emote', true);
                }
                else
                {
                    queueAnim('fall_up_idle', 18.67, 0.4, 0, 'emote', true);
                }
            }
            else if (lastEmote == 27)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_fistfight_finisher_1_looser', 2.10, 0.4, 0, 'emote', true);
                }
                else
                {
                    queueAnim('man_finisher_head_01_reaction', 2.07, 0.4, 0, 'emote', true);
                }
            }
            else if (lastEmote == 28)
            {
                queueAnim('man_peeing_loop', 3.07, 0.4, 0, 'emote', true, true);
            }

            lastEmote = -1;
            prevEmoteTime = lastEmoteTime;
        }
    }

    private function unmountHair()
    {
        var ids : array<SItemUniqueId>;
        var inv : CInventoryComponent;
        var size : int;
        var i : int;

        inv = ghost.GetInventory();
        ids = inv.GetItemsByCategory( 'hair' );
		size = ids.Size();
		
		if( size > 0 )
		{
			for( i = 0; i < size; i+=1 )
			{
				if(inv.IsItemMounted( ids[i] ) )
					inv.DespawnItem(ids[i]);

                inv.RemoveItem(ids[i], 1);
			}
			
		}
    }

    private function fixGeraltAppearance()
    {
        if(cpcPlayerType != ENR_PlayerGeralt)
        {
            giveBodyItem(true, 'Body feet 01');
            giveBodyItem(true, 'Body palms 01');
            giveBodyItem(true, 'Body underwear 01');
            giveBodyItem(true, 'Body torso medalion');
        }
        else
        {
            giveBodyItem(false, 'Body feet 01');
            giveBodyItem(false, 'Body palms 01');
            giveBodyItem(false, 'Body underwear 01');
            giveBodyItem(false, 'Body torso medalion');
        }
    }

    private function giveBodyItem(clear : bool, item : name)
    {
        var inv : CInventoryComponent;
        var ids : array<SItemUniqueId>;
        var i : int;
        var ent : CEntity;

        inv = ghost.GetInventory();

        ids = inv.GetItemsByName(item);
        if(clear)
        {
            for( i = 0; i < ids.Size(); i+=1 )
            {
                inv.DespawnItem(ids[i]);
            }	

            ent = inv.GetItemEntityUnsafe(ids[0]);
            if (ent)
            {
                ent.SetHideInGame(true);
            }
        }
        else
        {
            if(ids.Size() == 0)
            {
                ids = inv.AddAnItem(item);
				inv.MountItem(ids[0]);
            }

            ent = inv.GetItemEntityUnsafe(ids[0]);
            if (ent)
            {
                ent.SetHideInGame(false);
            }
        }
    }

    private function EquipNewItem(inv : CInventoryComponent, out lastItem : name, newItem : name, optional mount : bool, optional hide : bool)
    {
        var ids : array<SItemUniqueId>;
        var ent : CEntity;

        if (lastItem != '' && lastItem != newItem)
        {
            ids = inv.GetItemsByName(lastItem);
            if (ids.Size() > 0)
            {
                if(mount)
                {   
                    inv.UnmountItem(ids[0], true);
                }
                else
                {
                    ghost.UnequipItem(ids[0]);
                }

                inv.RemoveItemByName(lastItem, 1);
            }
        }

        ids = inv.GetItemsByName(newItem);
        if (ids.Size() == 0)
        {
            ids = inv.AddAnItem(newItem, 1);
            if(mount)
            {
                inv.MountItem(ids[0]);
            }
            else
            {
                ghost.EquipItem(ids[0]);
            }
        }

        ent = inv.GetItemEntityUnsafe(ids[0]);
        if (ent)
        {
            ent.SetHideInGame(hide);
        }

        lastItem = newItem;
    }

    private function updateEquippedItems()
    {
        var ids : array<SItemUniqueId>;
        var id : SItemUniqueId;
        var inv : CInventoryComponent;
        var acs : array< CComponent >;
        var head : name;
        var hair : name;

        acs = ghost.GetComponentsByClassName( 'CHeadManagerComponent' );
	    head = ( ( CHeadManagerComponent ) acs[0] ).GetCurHeadName();

        inv = ghost.GetInventory();

        EquipNewItem(inv, last_eq_steel, eq_steel);
        EquipNewItem(inv, last_eq_silver, eq_silver);
        EquipNewItem(inv, last_eq_armor, eq_armor, false, hideBody);
        EquipNewItem(inv, last_eq_gloves, eq_gloves, false, hideBody);
        EquipNewItem(inv, last_eq_pants, eq_pants, false, hideBody);
        EquipNewItem(inv, last_eq_boots, eq_boots, false, hideBody);
        EquipNewItem(inv, last_eq_steelScab, eq_steelScab);
        EquipNewItem(inv, last_eq_silverScab, eq_silverScab);
        EquipNewItem(inv, last_eq_crossbow, eq_crossbow);

        if(!hideHair)
        {
            EquipNewItem(inv, last_eq_hair, eq_hair, true);
        }

        if(!headOverride)
        {
            EquipNewItem(inv, last_eq_head, eq_head);
        }

        EquipNewItem(inv, last_eq_mask, eq_mask);
    }

    private function isLastSwordMovement() : bool
    {
        return (lastMovementType == 'sword_idle' || lastMovementType == 'sword_slow_walk' || lastMovementType == 'sword_walk' || lastMovementType == 'sword_run' || lastMovementType == 'sword_sprint');
    }

    private function isLastNonSwordMovement() : bool
    {
        return (lastMovementType == 'idle' || lastMovementType == 'slow_walk' || lastMovementType == 'walk' || lastMovementType == 'run' || lastMovementType == 'sprint');
    }

    private function swim()
    {
        // woman complete
        if(curState == 'Swim' && speed == 0)
        {
            if(isDiving)
            {
                if(lastSwimType == 'idle')
                {
                    queueAnim('swim_idle_to_underwater', 1.83, 0.2, 0, 'none', true);
                }

                lastSwimType = 'swim_underwater';

                if(lastVerticalMoveDir == 'up')
                {
                    if(lastAnim != 'swim_underwater_u')
                    {
                        queueAnim('swim_underwater_u', 1.17, 0.2, 0, 'swim_up_f');
                    }

                    queueAnim('swim_underwater_u', 1.17, 0, 0, 'swim_up_f');
                }
                else if(lastVerticalMoveDir == 'down')
                {
                    if(lastAnim != 'swim_underwater_d')
                    {
                        queueAnim('swim_underwater_d', 1.17, 0.2, 0, 'swim_down_f');
                    }

                    queueAnim('swim_underwater_d', 1.17, 0, 0, 'swim_down_f');
                }
                else
                {
                    if(lastAnim != 'swim_underwater_idle')
                    {
                        queueAnim('swim_underwater_idle', 1.5, 0.2, 0, 'swim_idle_underwater');
                    }

                    queueAnim('swim_underwater_idle', 1.5, 0, 0, 'swim_idle_underwater');
                }
            }
            else
            {
                if(lastSwimType == 'swim' || lastSwimType == 'swim_underwater')
                {
                    queueAnim('swim_stop_left_arm', 1.0, 0.2, 0, 'none', true);
                }

                lastSwimType = 'idle';

                if(lastAnim != 'swim_idle')
                {
                    queueAnim('swim_idle', 1.5, 0.2, 0, 'swim_idle');
                }

                queueAnim('swim_idle', 1.5, 0, 0, 'swim_idle');
            }
        }
        else if(curState == 'Swim' && speed > 0 && !isDiving)
        {
            if(lastSwimType == 'idle')
            {
                queueAnim('swim_start', 0.83, 0.2, 0, 'none', true);
            }
            else if(lastSwimType == 'none')
            {
                queueAnim('man_swimming_walk_jump_water', 2.0, 0.2, 0, 'none', true);
            }

            lastSwimType = 'swim';

            if(speed > 1)
            {
                if(lastMoveDir == 'forward')
                {
                    if(lastAnim != 'swim_fast_f')
                    {
                        queueAnim('swim_fast_f', 1.07, 0.2, 0, 'swim_fast_f');
                    }

                    queueAnim('swim_fast_f', 1.07, 0, 0, 'swim_fast_f');
                }
                else if(lastMoveDir == 'left')
                {
                    if(lastAnim != 'swim_fast_l')
                    {
                        queueAnim('swim_fast_l', 1.07, 0.2, 0, 'swim_fast_l');
                    }

                    queueAnim('swim_fast_l', 1.07, 0, 0, 'swim_fast_l');
                }
                else if(lastMoveDir == 'right')
                {
                    if(lastAnim != 'swim_fast_r')
                    {
                        queueAnim('swim_fast_r', 1.07, 0.2, 0, 'swim_fast_r');
                    }

                    queueAnim('swim_fast_r', 1.07, 0, 0, 'swim_fast_r');
                }
                else
                {
                    if(lastAnim != 'swim_fast_f')
                    {
                        queueAnim('swim_fast_f', 1.07, 0.2, 0, 'swim_fast_f');
                    }

                    queueAnim('swim_fast_f', 1.07, 0, 0, 'swim_fast_f');
                }
            }
            else
            {
                if(lastMoveDir == 'forward')
                {
                    if(lastAnim != 'swim_slow_f')
                    {
                        queueAnim('swim_slow_f', 1.4, 0.2, 0, 'swim_slow_f');
                    }

                    queueAnim('swim_slow_f', 1.4, 0, 0, 'swim_slow_f');
                }
                else if(lastMoveDir == 'left')
                {
                    if(lastAnim != 'swim_slow_l')
                    {
                        queueAnim('swim_slow_l', 1.4, 0.2, 0, 'swim_slow_l');
                    }

                    queueAnim('swim_slow_l', 1.4, 0, 0, 'swim_slow_l');
                }
                else if(lastMoveDir == 'right')
                {
                    if(lastAnim != 'swim_slow_r')
                    {
                        queueAnim('swim_slow_r', 1.4, 0.2, 0, 'swim_slow_r');
                    }

                    queueAnim('swim_slow_r', 1.4, 0, 0, 'swim_slow_r');
                }
                else
                {
                    if(lastAnim != 'swim_slow_f')
                    {
                        queueAnim('swim_slow_f', 1.4, 0.2, 0, 'swim_slow_f');
                    }

                    queueAnim('swim_slow_f', 1.4, 0, 0, 'swim_slow_f');
                }
            }
        }
        else if(curState == 'Swim' && speed > 0 && isDiving)
        {
            if(lastSwimType == 'idle')
            {
                queueAnim('swim_idle_to_underwater', 1.83, 0.2, 0, 'none', true);
            }
            else if(lastSwimType == 'swim')
            {
                queueAnim('swim_underwater_start_r45', 1.5, 0.2, 0, 'none', true);
            }

            lastSwimType = 'swim_underwater';

            if(lastVerticalMoveDir == 'up')
            {
                if(lastMoveDir == 'forward')
                {
                    if(lastAnim != 'swim_underwater_u')
                    {
                        queueAnim('swim_underwater_u', 1.17, 0.2, 0, 'swim_up_f');
                    }

                    queueAnim('swim_underwater_u', 1.17, 0, 0, 'swim_up_f');
                }
                else if(lastMoveDir == 'left')
                {
                    if(lastAnim != 'swim_underwater_lu')
                    {
                        queueAnim('swim_underwater_lu', 1.17, 0.2, 0, 'swim_up_l');
                    }

                    queueAnim('swim_underwater_lu', 1.17, 0, 0, 'swim_up_l');
                }
                else if(lastMoveDir == 'right')
                {
                    if(lastAnim != 'swim_underwater_ru')
                    {
                        queueAnim('swim_underwater_ru', 1.17, 0.2, 0, 'swim_up_r');
                    }

                    queueAnim('swim_underwater_ru', 1.17, 0, 0, 'swim_up_r');
                }
                else
                {
                    if(lastAnim != 'swim_underwater_u')
                    {
                        queueAnim('swim_underwater_u', 1.17, 0.2, 0, 'swim_up_f');
                    }

                    queueAnim('swim_underwater_u', 1.17, 0, 0, 'swim_up_f');
                }
            }
            else if(lastVerticalMoveDir == 'down')
            {
                if(lastMoveDir == 'forward')
                {
                    if(lastAnim != 'swim_underwater_d')
                    {
                        queueAnim('swim_underwater_d', 1.17, 0.2, 0, 'swim_down_f');
                    }

                    queueAnim('swim_underwater_d', 1.17, 0, 0, 'swim_down_f');
                }
                else if(lastMoveDir == 'left')
                {
                    if(lastAnim != 'swim_underwater_ld')
                    {
                        queueAnim('swim_underwater_ld', 1.17, 0.2, 0, 'swim_down_l');
                    }

                    queueAnim('swim_underwater_ld', 1.17, 0, 0, 'swim_down_l');
                }
                else if(lastMoveDir == 'right')
                {
                    if(lastAnim != 'swim_underwater_rd')
                    {
                        queueAnim('swim_underwater_rd', 1.17, 0.2, 0, 'swim_down_r');
                    }

                    queueAnim('swim_underwater_rd', 1.17, 0, 0, 'swim_down_r');
                }
                else
                {
                    if(lastAnim != 'swim_underwater_d')
                    {
                        queueAnim('swim_underwater_d', 1.17, 0.2, 0, 'swim_down_f');
                    }

                    queueAnim('swim_underwater_d', 1.17, 0, 0, 'swim_down_f');
                }
            }
            else
            {
                if(lastMoveDir == 'forward')
                {
                    if(lastAnim != 'swim_underwater_f')
                    {
                        queueAnim('swim_underwater_f', 1.17, 0.2, 0, 'swim_underwater_f');
                    }

                    queueAnim('swim_underwater_f', 1.17, 0, 0, 'swim_underwater_f');
                }
                else if(lastMoveDir == 'left')
                {
                    if(lastAnim != 'swim_underwater_l')
                    {
                        queueAnim('swim_underwater_l', 1.17, 0.2, 0, 'swim_underwater_l');
                    }

                    queueAnim('swim_underwater_l', 1.17, 0, 0, 'swim_underwater_l');
                }
                else if(lastMoveDir == 'right')
                {
                    if(lastAnim != 'swim_underwater_r')
                    {
                        queueAnim('swim_underwater_r', 1.17, 0.2, 0, 'swim_underwater_r');
                    }

                    queueAnim('swim_underwater_r', 1.17, 0, 0, 'swim_underwater_r');
                }
                else
                {
                    if(lastAnim != 'swim_underwater_f')
                    {
                        queueAnim('swim_underwater_f', 1.17, 0.2, 0, 'swim_underwater_f');
                    }

                    queueAnim('swim_underwater_f', 1.17, 0, 0, 'swim_underwater_f');
                }
            }
        }
        else
        {
            if(lastSwimType != 'none')
            {
                queueAnim('swim_to_walk_lef_arm', 1, 0.2, 0, 'none', true);
                smoothDelayedNext = true;
            }
            lastSwimType = 'none';
        }
    }

    private function updateGeraltAnims()
    {
        var anim : r_Anim;
        var ids : array<SItemUniqueId>;
        var inv : CInventoryComponent;
        var rand : int;

        if(!initSmooth)
        {
            if(heldItem == "silver" || heldItem == "steel")
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('combat_locomotion_man_geralt_ex_idle', 5.27, 0.4, 0, 'sword_movement_idle', true);
                }
                else
                {
                    queueAnim('combat_locomotion_man_geralt_ex_idle', 2.67, 0.4, 0, 'sword_movement_idle', true);
                }
            }
            else
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('mp_locomotion_idle', 5.27, 0.4, 0, 'movement_idle', true);
                }
                else
                {
                    queueAnim('mp_locomotion_idle', 5.00, 0.4, 0, 'movement_idle', true);
                }
            }
            initSmooth = true;
        }

        if((theGame.GetEngineTimeAsSeconds() - theGame.r_getMultiplayerClient().getSpawnTime()) < 2)
        {
            return;
        }

        if(lastChillOut || chillOutAnim != '')
        {
            lastIdleAnim = theGame.GetEngineTimeAsSeconds();
            return;
        }

        inv = ghost.GetInventory();

        bombActive = (currentState == 'AimThrow' && bombSelected);

        if(currentType == 'emote')
        {
            lastIdleAnim = theGame.GetEngineTimeAsSeconds();
        }
        
        // default anims
        if(!holdingTorch && !lastLadder && isAlive && animQueue.Size() == 0 && !isAnimPlaying)
        {
            if(heldItem == "silver" || heldItem == "steel")
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('combat_locomotion_man_geralt_ex_idle', 5.27, 0.4, 0, 'sword_movement_idle');
                }
                else
                {
                    queueAnim('combat_locomotion_man_geralt_ex_idle', 2.67, 0.4, 0, 'sword_movement_idle');
                }
            }
            else
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    if(lastAnim == 'mp_locomotion_idle')
                    {
                        queueAnim('mp_locomotion_idle', 5.27, 0, 0, 'movement_idle');
                    }
                    else
                    {
                        queueAnim('mp_locomotion_idle', 5.27, 0.4, 0, 'movement_idle');
                    }
                }
                else
                {
                    if(lastAnim == 'mp_locomotion_idle')
                    {
                        queueAnim('mp_locomotion_idle', 5.00, 0, 0, 'movement_idle');
                    }
                    else
                    {
                        queueAnim('mp_locomotion_idle', 5.00, 0.4, 0, 'movement_idle');
                    }
                }
            }
        }

        // idle anims
        if(((theGame.GetEngineTimeAsSeconds() - lastIdleAnim) > 13) && lastIdle && !inCombat && !lastLadder && !isMounted && !isFalling && !isSailing && !aimingCrossbow && !bombActive && !holdingTorch && isAlive && currentState != 'AimThrow' && curState == 'Idle' && !isJumping && !swirling && !rend && !channeling)
        {
            if(heldItem == "silver" || heldItem == "steel")
            {
                rand = RandDifferent(lastIdleRand, 3);

                if(rand == 0)
                {
                    queueAnim('inventory_sword_check1', 6.23, 0.4, 0, 'afk', true);
                }
                else if(rand == 1)
                {
                    queueAnim('inventory_sword_check2', 6.67, 0.4, 0, 'afk', true);
                }
                else if(rand == 2)
                {
                    queueAnim('inventory_heavy_melee_check1', 5.6, 0.4, 0, 'afk', true);
                }
            }
            else
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                }
                else
                {
                    if(rand == 0)
                    {
                        rand = RandDifferent(lastIdleRand, 6);

                        if(rand == 0)
                        {
                            queueAnim('inventory_noequipment_armor', 4.17, 0.4, 0, 'afk', true);
                        }
                        else if(rand == 1)
                        {
                            queueAnim('inventory_noequipment_armor_flex1', 6.33, 0.4, 0, 'afk', true);
                        }
                        else if(rand == 2)
                        {
                            queueAnim('inventory_noequipment_armor_flex2', 5.03, 0.4, 0, 'afk', true);
                        }
                        else if(rand == 3)
                        {
                            queueAnim('inventory_noequipment_boots', 4.9, 0.4, 0, 'afk', true);
                        }
                        else if(rand == 4)
                        {
                            queueAnim('inventory_noequipment_gloves', 5.67, 0.4, 0, 'afk', true);
                        }
                        else if(rand == 5)
                        {
                            queueAnim('inventory_noequipment_pants', 5.27, 0.4, 0, 'afk', true);
                        }
                    }
                }
            }   

            lastIdleRand = rand;
            smoothDelayedNext = true;
            lastIdleAnim = theGame.GetEngineTimeAsSeconds();
        }

        if(speed != 0)
        {
            lastIdle = false;
        }

        // woman complete
        if(!inCombat && !isMounted && !isFalling && !isSailing && !aimingCrossbow && !bombActive && !holdingTorch && isAlive && currentState != 'AimThrow' && curState == 'Idle' && !isJumping && !swirling && !rend && !channeling)
        {
            if(heldItem == "silver" || heldItem == "steel")
            {
                if(speed == 0)
                {
                    if(!lastIdle)
                    {
                        lastIdleAnim = theGame.GetEngineTimeAsSeconds();
                        lastIdle = true;
                    }

                    if(lastMoveDirAlt != 'none')
                    {
                        // ghost still moving
                        if(lastMovementType == 'sword_sprint')
                        {
                            queueAnim('combat_locomotion_sprint_cycle_forward', 0.60, 0, 0, 'sword_movement_sprint');
                        }
                        else if(lastMovementType == 'sword_run')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('combat_locomotion_run_cycle_fast_forward_triple_01', 1.8, 0, 0, 'sword_movement_run');
                            }
                            else
                            {
                                queueAnim('combat_locomotion_run_cycle_fast_forward', 2.0, 0, 0, 'sword_movement_run');
                            }
                        }
                        else if(lastMovementType != 'sword_idle')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 2.6, 0, 0, 'sword_movement_walk');
                            }
                            else
                            {
                                queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 3.00, 0, 0, 'sword_movement_walk');
                            }
                        }
                        return;
                    }

                    if(lastAnim == 'dialogue_jump_idle' || smoothNext || isLastNonSwordMovement())
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 5.27, 0.4, 0, 'sword_movement_idle', true);
                        }
                        else
                        {
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 2.67, 0.4, 0, 'sword_movement_idle', true);
                        }
                        lastMovementType = 'sword_idle';
                        smoothNext = false;
                        return;
                    }

                    if(smoothDelayedNext)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 5.27, 0.4, 0, 'sword_movement_idle');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 2.67, 0.4, 0, 'sword_movement_idle');
                        }
                        
                        lastMovementType = 'sword_idle';
                        smoothDelayedNext = false;
                        return;
                    }

                    if(lastMovementType == 'sword_sprint')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_sprint_rightforward_to_idle', 1.9, 0.2, 0, 'none', true);
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 5.27, 0.7, 0, 'sword_movement_idle');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_sprint_rightforward_to_idle', 2.17, 0.2, 0, 'none', true);
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 2.67, 0.7, 0, 'sword_movement_idle');
                        }
                    }
                    if(lastMovementType == 'sword_walk' || lastMovementType == 'sword_slow_walk')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_walk_rightup_to_idle', 1.5, 0.2, 0, 'none', true);
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 5.27, 0.7, 0, 'sword_movement_idle');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_walk_rightup_to_idle', 1.5, 0.2, 0, 'none', true);
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 2.67, 0.7, 0, 'sword_movement_idle');
                        }
                        
                    }
                    else if(lastMovementType == 'sword_run')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_run_rightup_to_idle', 1.1, 0.2, 0, 'none', true);
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 5.27, 0.7, 0, 'sword_movement_idle');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_run_rightup_to_idle', 1.1, 0.2, 0, 'none', true);
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 2.67, 0.7, 0, 'sword_movement_idle');
                        }
                        
                    }
                    else
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 5.27, 0, 0, 'sword_movement_idle');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_man_geralt_ex_idle', 2.67, 0, 0, 'sword_movement_idle');
                        }
                    }
                    lastMovementType = 'sword_idle';
                }
                else if(speed <= 0.4)
                {
                    if(lastAnim == 'dialogue_jump_idle' || smoothNext || isLastNonSwordMovement())
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_walk_cycle_slow_forward_triple_01', 3, 0.4, 0, 'sword_movement_slow_walk', true);
                        }
                        else
                        {
                            queueAnim('combat_locomotion_walk_cycle_slow_forward_triple_01', 3.7, 0.4, 0, 'sword_movement_slow_walk', true);
                        }
                        lastMovementType = 'sword_slow_walk';
                        smoothNext = false;
                        return;
                    }

                    if(smoothDelayedNext)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_walk_cycle_slow_forward_triple_01', 3, 0.4, 0, 'sword_movement_slow_walk');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_walk_cycle_slow_forward_triple_01', 3.7, 0.4, 0, 'sword_movement_slow_walk');
                        }
                        
                        lastMovementType = 'sword_slow_walk';
                        smoothDelayedNext = false;
                        return;
                    }

                    if(lastMovementType == 'sword_run' || lastMovementType == 'sword_sprint' ||lastMovementType == 'sword_idle' || lastMovementType == 'sword_walk' || lastAnim == 'dialogue_jump_idle')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_walk_cycle_slow_forward_triple_01', 3, 0.4, 0, 'sword_movement_slow_walk');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_walk_cycle_slow_forward_triple_01', 3.7, 0.4, 0, 'sword_movement_slow_walk');
                        }
                    }
                    else
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_walk_cycle_slow_forward_triple_01', 3, 0, 0, 'sword_movement_slow_walk');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_walk_cycle_slow_forward_triple_01', 3.7, 0, 0, 'sword_movement_slow_walk');
                        }
                    }

                    lastMovementType = 'sword_slow_walk';
                }
                else if(speed <= 0.7)
                {
                    if(lastAnim == 'dialogue_jump_idle' || smoothNext || isLastNonSwordMovement())
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 2.6, 0.4, 0, 'sword_movement_walk', true);
                        }
                        else
                        {
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 3.00, 0.4, 0, 'sword_movement_walk', true);
                        }
                        lastMovementType = 'sword_walk';
                        smoothNext = false;
                        return;
                    }

                    if(smoothDelayedNext)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 2.6, 0.4, 0, 'sword_movement_walk');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 3.00, 0.4, 0, 'sword_movement_walk');
                        }
                        
                        lastMovementType = 'sword_walk';
                        smoothDelayedNext = false;
                        return;
                    }

                    if(lastMovementType == 'sword_sprint')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 2.6, 0.4, 0, 'sword_movement_walk');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 3.00, 0.4, 0, 'sword_movement_walk');
                        }
                    }
                    else if(lastMovementType == 'sword_run')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_run_cycle_slow_forward', 1, 0.2, 0, 'none', true);
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 2.6, 0.4, 0, 'sword_movement_walk');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_run_cycle_slow_forward', 0.8, 0.2, 0, 'none', true);
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 3.00, 0.4, 0, 'sword_movement_walk');
                        }
                    }
                    else if(lastMovementType == 'sword_idle' || lastMovementType == 'sword_slow_walk' || lastAnim == 'dialogue_jump_idle')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 2.6, 0.7, 0, 'sword_movement_walk');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 3.00, 0.7, 0, 'sword_movement_walk');
                        }
                    }
                    else
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 2.6, 0, 0, 'sword_movement_walk');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_walk_cycle_fast_forward_triple_01', 3.00, 0, 0, 'sword_movement_walk');
                        }
                    }

                    lastMovementType = 'sword_walk';
                }
                else if(speed <= 1)
                {
                    if(lastAnim == 'dialogue_jump_idle' || smoothNext || isLastNonSwordMovement())
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward_triple_01', 1.8, 0.4, 0, 'sword_movement_run', true);
                        }
                        else
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward', 2.0, 0.4, 0, 'sword_movement_run', true);
                        }
                        
                        lastMovementType = 'sword_run';
                        smoothNext = false;
                        return;
                    }

                    if(smoothDelayedNext)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward_triple_01', 1.8, 0.4, 0, 'sword_movement_run');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward', 2.0, 0.4, 0, 'sword_movement_run');
                        }
                        
                        lastMovementType = 'sword_run';
                        smoothDelayedNext = false;
                        return;
                    }

                    if(lastMovementType == 'sword_idle')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward_triple_01', 1.8, 0.8, 0, 'sword_movement_run');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward', 2.0, 0.8, 0, 'sword_movement_run');
                        }
                    }
                    else if(lastMovementType == 'sword_sprint')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward_triple_01', 1.8, 0.4, 0, 'sword_movement_run');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward', 2.0, 0.4, 0, 'sword_movement_run');
                        }
                    }
                    else if(lastMovementType == 'sword_walk' || lastMovementType == 'sword_slow_walk' || lastAnim == 'dialogue_jump_idle')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward_triple_01', 1.8, 0.6, 0, 'sword_movement_run');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward', 2.0, 0.6, 0, 'sword_movement_run');
                        }
                    }
                    else
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward_triple_01', 1.8, 0, 0, 'sword_movement_run');
                        }
                        else
                        {
                            queueAnim('combat_locomotion_run_cycle_fast_forward', 2.0, 0, 0, 'sword_movement_run');
                        }
                    }

                    lastMovementType = 'sword_run';
                }
                else
                {
                    if(lastAnim == 'dialogue_jump_idle' || smoothNext || isLastNonSwordMovement())
                    {
                        queueAnim('combat_locomotion_sprint_cycle_forward', 0.60, 0.3, 0, 'sword_movement_sprint', true);
                        lastMovementType = 'sword_sprint';
                        smoothNext = false;
                        return;
                    }

                    if(smoothDelayedNext)
                    {
                        queueAnim('combat_locomotion_sprint_cycle_forward', 0.60, 0.3, 0, 'sword_movement_sprint');
                        lastMovementType = 'sword_sprint';
                        smoothDelayedNext = false;
                        return;
                    }

                    if(lastMovementType == 'sword_idle')
                    {
                        queueAnim('combat_locomotion_sprint_cycle_forward', 0.60, 0.8, 0, 'sword_movement_sprint');
                    }
                    else if(lastMovementType == 'sword_walk' || lastMovementType == 'sword_slow_walk' || lastMovementType == 'sword_run' || lastAnim == 'dialogue_jump_idle')
                    {
                        queueAnim('combat_locomotion_sprint_cycle_forward', 0.60, 0.3, 0, 'sword_movement_sprint');
                    }
                    else
                    {
                        queueAnim('combat_locomotion_sprint_cycle_forward', 0.60, 0, 0, 'sword_movement_sprint');
                    }

                    lastMovementType = 'sword_sprint';
                }
            }
            else
            {
                if(speed == 0)
                {
                    if(!lastIdle)
                    {
                        lastIdleAnim = theGame.GetEngineTimeAsSeconds();
                        lastIdle = true;
                    }

                    if(lastMoveDirAlt != 'none')
                    {
                        // ghost still moving
                        if(lastMovementType == 'sprint')
                        {
                            queueAnim('mp_locomotion_sprint_cycle_forward', 0.60, 0, 0, 'movement_sprint');
                        }
                        else if(lastMovementType == 'run')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('mp_locomotion_run_cycle_fast_forward', 0.6, 0, 0, 'movement_run');
                            }
                            else
                            {
                                queueAnim('mp_locomotion_run_cycle_fast_forward', 0.67, 0, 0, 'movement_run');
                            }
                        }
                        else if(lastMovementType != 'idle')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('mp_walk', 0.97, 0, 0, 'movement_walk');
                            }
                            else
                            {
                                queueAnim('mp_walk', 1.00, 0, 0, 'movement_walk');
                            }
                        }
                        return;
                    }
                    if(lastAnim == 'dialogue_jump_idle' || smoothNext || isLastSwordMovement())
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_idle', 5.27, 0.4, 0, 'movement_idle', true);
                        }
                        else
                        {
                            queueAnim('mp_locomotion_idle', 5.00, 0.4, 0, 'movement_idle', true);
                        }
                        lastMovementType = 'idle';
                        smoothNext = false;
                        return;
                    }

                    if(smoothDelayedNext)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_idle', 5.27, 0.4, 0, 'movement_idle');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_idle', 5.00, 0.4, 0, 'movement_idle');
                        }
                        lastMovementType = 'idle';
                        smoothDelayedNext = false;
                        return;
                    }

                    if(lastMovementType == 'sprint')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_sprint_rightforward_to_idle', 1.9, 0.2, 0, 'none', true);
                            queueAnim('mp_locomotion_idle', 5.27, 0.7, 0, 'movement_idle');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_sprint_rightforward_to_idle', 2.57, 0.2, 0, 'none', true);
                            queueAnim('mp_locomotion_idle', 5.00, 0.7, 0, 'movement_idle');
                        }
                    }
                    if(lastMovementType == 'walk' || lastMovementType == 'slow_walk')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_walk_rightup_to_idle', 1.5, 0.2, 0, 'none', true);
                            queueAnim('mp_locomotion_idle', 5.27, 0.7, 0, 'movement_idle');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_walk_rightup_to_idle', 1.5, 0.2, 0, 'none', true);
                            queueAnim('mp_locomotion_idle', 5.00, 0.7, 0, 'movement_idle');
                        }
                    }
                    else if(lastMovementType == 'run')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_run_rightup_to_idle', 1.23, 0.2, 0, 'none', true);
                            queueAnim('mp_locomotion_idle', 5.27, 0.7, 0, 'movement_idle');
                        }
                        else
                        {
                            queueAnim('locomotion_run_rightup_to_idle_02', 1.53, 0.2, 0, 'none', true);
                            queueAnim('mp_locomotion_idle', 5.00, 0.7, 0, 'movement_idle');
                        }
                    }
                    else
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_idle', 5.27, 0, 0, 'movement_idle');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_idle', 5.00, 0, 0, 'movement_idle');
                        }
                    }
                    lastMovementType = 'idle';
                }
                else if(speed <= 0.4)
                {
                    if(lastAnim == 'dialogue_jump_idle' || smoothNext || isLastSwordMovement())
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_walk_cycle_slow_forward_triple_01', 3, 0.4, 0, 'movement_slow_walk', true);
                        }
                        else
                        {
                            queueAnim('mp_locomotion_walk_cycle_slow_forward_triple_01', 3.7, 0.4, 0, 'movement_slow_walk', true);
                        }
                        
                        lastMovementType = 'slow_walk';
                        smoothNext = false;
                        return;
                    }

                    if(smoothDelayedNext)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_walk_cycle_slow_forward_triple_01', 3, 0.4, 0, 'movement_slow_walk');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_walk_cycle_slow_forward_triple_01', 3.7, 0.4, 0, 'movement_slow_walk');
                        }
                        lastMovementType = 'slow_walk';
                        smoothDelayedNext = false;
                        return;
                    }

                    if(lastMovementType == 'sprint' || lastMovementType == 'run' || lastMovementType == 'idle' || lastMovementType == 'walk' || lastAnim == 'dialogue_jump_idle')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_walk_cycle_slow_forward_triple_01', 3, 0.4, 0, 'movement_slow_walk');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_walk_cycle_slow_forward_triple_01', 3.7, 0.4, 0, 'movement_slow_walk');
                        }
                    }
                    else
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_walk_cycle_slow_forward_triple_01', 3, 0, 0, 'movement_slow_walk');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_walk_cycle_slow_forward_triple_01', 3.7, 0, 0, 'movement_slow_walk');
                        }
                    }

                    lastMovementType = 'slow_walk';
                }
                else if(speed <= 0.7)
                {
                    if(lastAnim == 'dialogue_jump_idle' || smoothNext || isLastSwordMovement())
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_walk', 0.97, 0.7, 0, 'movement_walk', true);
                        }
                        else
                        {
                            queueAnim('mp_walk', 1.00, 0.7, 0, 'movement_walk', true);
                        }
                        lastMovementType = 'walk';
                        smoothNext = false;
                        return;
                    }

                    if(smoothDelayedNext)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_walk', 0.97, 0.7, 0, 'movement_walk');
                        }
                        else
                        {
                            queueAnim('mp_walk', 1.00, 0.7, 0, 'movement_walk');
                        }
                        lastMovementType = 'walk';
                        smoothDelayedNext = false;
                        return;
                    }

                    if(lastMovementType == 'sprint')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_walk', 0.97, 0.4, 0, 'movement_walk');
                        }
                        else
                        {
                            queueAnim('mp_walk', 1.00, 0.4, 0, 'movement_walk');
                        }
                    }
                    if(lastMovementType == 'run')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_run_cycle_slow_forward', 1.0, 0.2, 0, 'none', true);
                            queueAnim('mp_walk', 0.97, 0.4, 0, 'movement_walk');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_run_cycle_slow_forward', 0.8, 0.2, 0, 'none', true);
                            queueAnim('mp_walk', 1.00, 0.4, 0, 'movement_walk');
                        }
                    }
                    else if(lastMovementType == 'idle' || lastMovementType == 'slow_walk'|| lastAnim == 'dialogue_jump_idle')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_walk', 0.97, 0.7, 0, 'movement_walk');
                        }
                        else
                        {
                            queueAnim('mp_walk', 1.00, 0.7, 0, 'movement_walk');
                        }
                        
                    }
                    else
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_walk', 0.97, 0, 0, 'movement_walk');
                        }
                        else
                        {
                            queueAnim('mp_walk', 1.00, 0, 0, 'movement_walk');
                        }
                    }

                    lastMovementType = 'walk';
                }
                else if(speed <= 1)
                {
                    if(lastAnim == 'dialogue_jump_idle' || smoothNext || isLastSwordMovement())
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_run_cycle_fast_forward', 0.6, 0.4, 0, 'movement_run', true);
                        }
                        else
                        {
                            queueAnim('mp_locomotion_run_cycle_fast_forward', 0.67, 0.4, 0, 'movement_run', true);
                        }
                        lastMovementType = 'run';
                        smoothNext = false;
                        return;
                    }

                    if(smoothDelayedNext)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_run_cycle_fast_forward', 0.6, 0.4, 0, 'movement_run');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_run_cycle_fast_forward', 0.67, 0.4, 0, 'movement_run');
                        }
                        lastMovementType = 'run';
                        smoothDelayedNext = false;
                        return;
                    }

                    if(lastMovementType == 'idle')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_run_cycle_fast_forward', 0.6, 0.8, 0, 'movement_run');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_run_cycle_fast_forward', 0.67, 0.8, 0, 'movement_run');
                        }
                    }
                    else if(lastMovementType == 'sprint' || lastMovementType == 'walk' || lastMovementType == 'slow_walk' || lastAnim == 'dialogue_jump_idle')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_run_cycle_fast_forward', 0.6, 0.4, 0, 'movement_run');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_run_cycle_fast_forward', 0.67, 0.4, 0, 'movement_run');
                        }
                    }
                    else
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('mp_locomotion_run_cycle_fast_forward', 0.6, 0, 0, 'movement_run');
                        }
                        else
                        {
                            queueAnim('mp_locomotion_run_cycle_fast_forward', 0.67, 0, 0, 'movement_run');
                        }
                    }

                    lastMovementType = 'run';
                }
                else
                {
                    if(lastAnim == 'dialogue_jump_idle' || smoothNext || isLastSwordMovement())
                    {
                        queueAnim('mp_locomotion_sprint_cycle_forward', 0.60, 0.3, 0, 'movement_sprint', true);
                        lastMovementType = 'sprint';
                        smoothNext = false;
                        return;
                    }

                    if(smoothDelayedNext)
                    {
                        queueAnim('mp_locomotion_sprint_cycle_forward', 0.60, 0.3, 0, 'movement_sprint');
                        lastMovementType = 'sprint';
                        smoothDelayedNext = false;
                        return;
                    }

                    if(lastMovementType == 'idle')
                    {
                        queueAnim('mp_locomotion_sprint_cycle_forward', 0.60, 0.8, 0, 'movement_sprint');
                    }
                    else if(lastMovementType == 'walk' || lastMovementType == 'slow_walk' || lastMovementType == 'run' || lastAnim == 'dialogue_jump_idle')
                    {
                        queueAnim('mp_locomotion_sprint_cycle_forward', 0.60, 0.3, 0, 'movement_sprint');
                    }
                    else
                    {
                        queueAnim('mp_locomotion_sprint_cycle_forward', 0.60, 0, 0, 'movement_sprint');
                    }

                    lastMovementType = 'sprint';
                }
            }

            lastMovement = true;
        }
        else
        {
            if(lastMovement)
            {
                smoothNext = true;
                lastMovement = false;
            }
        }

        if(swirling && (heldItem == "silver" || heldItem == "steel"))
        {
            if(!lastSwirling)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_geralt_sword_special_fast_attack_loop_1', 2.53, 0.2, 0, 'swirl', true);
                }
                else
                {
                    queueAnim('man_geralt_sword_special_fast_attack_loop_1', 2.5, 0.2, 0, 'swirl', true);
                }
                lastSwirling = true;
            }

            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
            {
                queueAnim('man_geralt_sword_special_fast_attack_loop_1', 2.53, 0, 0, 'swirl');
            }
            else
            {
                queueAnim('man_geralt_sword_special_fast_attack_loop_1', 2.5, 0, 0, 'swirl');
            }
        }
        else
        {
            if(lastSwirling)
            {
                lastSwirling = false;
            }
        }

        if(rend)
        {
            if(!lastRend)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_geralt_sword_attack_heavy_special_rp_start', 2.17, 0.2, 0, 'rend', true);
                    queueAnim('man_geralt_sword_attack_heavy_special_rp_end', 1.7, 0, 0, 'rend');
                }
                else
                {
                    queueAnim('man_geralt_sword_attack_heavy_special_rp_start', 2.12, 0.2, 0, 'rend', true);
                    queueAnim('man_geralt_sword_attack_heavy_special_rp_end', 1.67, 0, 0, 'rend');
                }
                lastRend = true;
            }
        }
        else
        {
            if(lastRend)
            {
                lastRend = false;
            }
        }

        // woman complete
        if(curState == 'Slide')
        {
            if(!lastSliding)
            {
                queueAnim('slide_right_45degrees', 2.46, 0.4, 0, 'slide');
            }

            queueAnim('slide_right_45degrees', 2.46, 0, 0, 'slide');

            lastSliding = true;
            smoothNext = true;
        }
        else
        {
            if(lastSliding)
            {
                lastSliding = false;
            }
        }

        // woman complete
        if(bombActive)
        {
            if(!lastBombSelected)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_geralt_petard_aim_start_rp', 0.73, 0.2, 0, 'none', true);
                }
                else
                {
                    queueAnim('man_geralt_petard_aim_start_rp', 0.7, 0.2, 0, 'none', true);
                }
            }

            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
            {
                queueAnim('man_geralt_petard_aim_idle_rp', 1.03, 0, 0, 'bomb');
            }
            else
            {
                queueAnim('man_geralt_petard_aim_idle_rp', 1, 0, 0, 'bomb');
            }
            

            lastBombSelected = true;
        }
        else
        {
            if(lastBombSelected)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_geralt_petard_aim_shoot_rp', 1.03, 0, 0, 'none', true);
                }
                else
                {
                    queueAnim('man_geralt_petard_aim_shoot_rp', 1, 0, 0, 'none', true);
                }
                
                lastBombSelected = false;
                smoothDelayedNext = true;
            }
        }

        // woman complete
        if(!isAlive)
        {
            if(!lastAlive)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_ger_sword_death_1', 2.4, 0.2, 0, 'none', true);
                }
                else
                {
                    queueAnim('man_ger_sword_death_1', 2.37, 0.2, 0, 'none', true);
                }
            }

            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
            {
                queueAnim('q704_syanna_dead_pose', 5.0, 0.2, 0, 'dead');
            }
            else
            {
                queueAnim('low_lying_dead_idle', 5.0, 0.2, 0, 'dead');
            }
            
            lastAlive = true;
        }
        else
        {
            if(lastAlive)
            {
                lastAlive = false;
                smoothNext = true;
            }
        }

        // woman complete
        if (isLadder)
        {
            if ((lastVerticalMoveDir == 'up' || lastVerticalMoveDir == 'down'))
            {
                if (lastVerticalMoveDir != lastFiredDir || theGame.GetEngineTimeAsSeconds() >= lastLadderTick)
                {
                    if (lastVerticalMoveDir == 'up')
                    {
                        if (!lastLeftLadder)
                        {
                            queueAnim('ladder_left_up_40', 0.43, 0.2, 0, 'ladder_up');
                        }
                        else
                        {
                            queueAnim('ladder_right_up_40', 0.43, 0.2, 0, 'ladder_up');
                        }
                    }
                    else
                    {
                        if (!lastLeftLadder)
                        {
                            queueAnim('ladder_left_down_40', 0.43, 0.2, 0, 'ladder_down');
                        }
                        else
                        {
                            queueAnim('ladder_right_down_40', 0.43, 0.2, 0, 'ladder_down');
                        }
                    }

                    lastLeftLadder = !lastLeftLadder;
                    lastFiredDir = lastVerticalMoveDir;
                    lastLadderTick = theGame.GetEngineTimeAsSeconds() + 0.43;
                }
            }
            else
            {
                if(lastFiredDir != 'none' || !lastLadder)
                {
                    if (!lastLeftLadder)
                    {
                        queueAnim('ladder_left_up_40', 0, 0.2, 0, 'none');
                    }
                    else
                    {
                        queueAnim('ladder_right_up_40', 0, 0.2, 0, 'none');
                    }

                    lastLastFiredDir = lastFiredDir;
                }

                lastFiredDir = 'none';
                lastLadderTick = 0.0;

                if (!lastLeftLadder)
                {
                    if(lastLastFiredDir == 'up')
                    {
                        queueAnim('ladder_left_up_40', 0, 0, 0, 'none');
                    }
                    else
                    {
                        queueAnim('ladder_left_down_40', 0, 0, 0, 'none');
                    }
                }
                else
                {
                    if(lastLastFiredDir == 'up')
                    {
                        queueAnim('ladder_right_up_40', 0, 0, 0, 'none');
                    }
                    else
                    {
                        queueAnim('ladder_right_down_40', 0, 0, 0, 'none');
                    }
                }
            }

            lastLadder = true;
        }
        else
        {
            if(lastLadder)
            {
                lastLadder = false;
            }
        }

        // woman complete
        if(curState == 'Jump' && lastJumpType == EJT_ToWater)
        {
            if(!lastDiving)
            {
                queueAnim('jump_run_lf_to_water', 1.33, 0.2, 0, 'jump', true);
                lastDiving = true;
            }
            else
            {
                queueAnim('jump_to_water_loop', 0.7, 0, 0, 'jump');
            }
            
        }
        else if(curState == 'Jump' && !isFalling && lastJumpTime != prevJumpTime)
        {
            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
            {
                queueAnim('dialogue_jump_idle', 2, 0.2, 0, 'jump', true);
            }
            else
            {
                queueAnim('dialogue_jump_idle', 1.98, 0.2, 0, 'jump', true);
            }
            prevJumpTime = lastJumpTime;
            isJumping = true;
        }
        else
        {
            if(isJumping)
            {
                smoothNext = true;
                isJumping = false;
            }
        }

        if(curState != 'Jump' || lastJumpType != EJT_ToWater)
        {
            lastDiving = false;
        }
        
        // woman complete
        if(curState == 'Climb')
        {
            if(!isClimbing)
            {
                if(lastClimbType == ECHT_Step)
                {                    
                    queueAnim('climb_idle_30', 2.00, 0.2, 0, 'climb', true);
                    isClimbing = true;
                }
                else if(lastClimbType == ECHT_VerySmall)
                {
                    queueAnim('climb_idle_100', 2.00, 0.2, 0, 'climb', true);
                    isClimbing = true;
                }
                else if(lastClimbType == ECHT_Small)
                {
                    queueAnim('climb_idle_150', 2.63, 0.2, 0, 'climb', true);
                    isClimbing = true;
                }
                else if(lastClimbType == ECHT_Medium)
                {
                    queueAnim('climb_idle_200', 2.77, 0.2, 0, 'climb', true);
                    isClimbing = true;
                }
                else if(lastClimbType == ECHT_High)
                {
                    queueAnim('climb_idle_250', 2.63, 0.2, 0, 'climb', true);
                    isClimbing = true;
                }
                else if(lastClimbType == ECHT_VeryHigh)
                {
                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim('climb_idle_300', 4.67, 0.2, 0, 'climb', true);
                    }
                    else
                    {
                        queueAnim('climb_idle_300', 3.37, 0.2, 0, 'climb', true);
                    }
                    isClimbing = true;
                } 
            }
        }
        else
        {
            if(isClimbing)
            {
                prevClimbTime = theGame.GetEngineTimeAsSeconds();
                smoothNext = true;
                isClimbing = false;
            }
        }

        // woman complete
        if(curState == 'Roll')
        {
            if(!lastRoll)
            {
                queueAnim('ex_jump_land_roll_walk', 1.47, 0.2, 0, 'roll', true);
                lastRoll = true;
            }
        }
        else
        {
            lastRoll = false;
        }

        // woman complete
        if(isFalling && !lastDiving && (curState != 'Swim' && curState != 'Climb'))
        {
            if(!isJumping && (theGame.GetEngineTimeAsSeconds() - prevJumpTime) > 2.2 && (theGame.GetEngineTimeAsSeconds() - prevClimbTime) > 0.5)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('jump_falling_loop_c', 1.0, 0.2, 0, 'falling');
                }
                else
                {
                    queueAnim('jump_falling_loop_c', 0.70, 0.2, 0, 'falling');
                }
            }
        }

        // woman complete
        if(isMounted)
        {
            if(!lastMounted)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('horse_mount_L', 1.37, 0.2, 0, 'none', true);
                }
                else
                {
                    queueAnim('horse_mount_L', 1.4, 0.2, 0, 'none', true);
                }
            }

            if(horseSpeed == 0)
            {
                if(lastAnim != 'horse_standing_idle01')
                {
                    queueAnim('horse_standing_idle01', 7.33, 0.4, 0, 'mounted_0');
                }

                queueAnim('horse_standing_idle01', 7.33, 0, 0, 'mounted_0');
            }
            else if(horseSpeed <= 1)
            {
                if(lastAnim != 'horse_walk')
                {
                    queueAnim('horse_walk', 1.27, 0.4, 0, 'mounted_1');
                }

                queueAnim('horse_walk', 1.27, 0, 0, 'mounted_1');
            }
            else if(horseSpeed <= 2)
            {
                if(lastAnim != 'horse_walk')
                {
                    queueAnim('horse_walk', 1.27, 0.4, 0, 'mounted_2');
                }

                queueAnim('horse_walk', 1.27, 0, 0, 'mounted_2');
            }
            else if(horseSpeed <= 3.5)
            {
                if(lastAnim != 'horse_trot')
                {
                    queueAnim('horse_trot', 0.7, 0.4, 0, 'mounted_3');
                }

                queueAnim('horse_trot', 0.7, 0, 0, 'mounted_3');
            }
            else if(horseSpeed <= 6.5)
            {
                if(lastAnim != 'horse_gallop')
                {
                    queueAnim('horse_gallop', 0.5, 0.4, 0, 'mounted_4');
                }

                queueAnim('horse_gallop', 0.5, 0, 0, 'mounted_4');
            }
            else
            {
                if(lastAnim != 'horse_canter')
                {
                    queueAnim('horse_canter', 0.5, 0.4, 0, 'mounted_5');
                }

                queueAnim('horse_canter', 0.5, 0, 0, 'mounted_5');
            }

            lastMounted = true;
        }
        else
        {
            if(lastMounted)
            {
                queueAnim('horse_dismount_rf_01', 1.9, 0.2, 0.4, 'none', true);
                lastMounted = false;
                lastIdleAnim = theGame.GetEngineTimeAsSeconds();
            }
        }

        // woman complete
        if(isSailing)
        {
            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
            {
                queueAnim('boat_sail_loop', 19.13, 0.2, 0, 'sailing');
            }
            else
            {
                queueAnim('boat_sail_idle', 2.33, 0.2, 0, 'sailing');
            }
        }
        
        swim();
        
        // woman complete
        if(aimingCrossbow)
        {
            if(!lastAimingCrossbow)
            {
                ids = inv.GetItemsByName(eq_crossbow);
                if (ids.Size() > 0)
                {
                    inv.MountItem(ids[0], true);
                }

                if(curState == 'Swim' && speed == 0)
                {
                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim('man_geralt_gabriel_swim_idle_aim_start_lp', 0.77, 0.2, 0, 'none', true);
                    }
                    else
                    {
                        queueAnim('man_geralt_gabriel_swim_idle_aim_start_lp', 0.73, 0.2, 0, 'none', true);
                    }
                }
                else
                {
                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim('man_geralt_gabriel_aim_start_rp', 0.57, 0.2, 0, 'none', true);
                    }
                    else
                    {
                        queueAnim('man_geralt_gabriel_aim_start_rp', 0.53, 0.2, 0, 'none', true);
                    }
                }
            }

            if(curState == 'Swim' && speed == 0)
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_geralt_gabriel_swim_aimpose_aim_cycle', 1.53, 0.2, 0, 'swim_crossbow_idle');
                }
                else
                {
                    queueAnim('man_geralt_gabriel_swim_aimpose_aim_cycle', 1.5, 0.2, 0, 'swim_crossbow_idle');
                }
                lastAimingCrossbow = true;
                return;
            }

            if(lastMoveDir == 'forward')
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_geralt_gabriel_strafe_f', 1.37, 0.2, 0, 'crossbow_forward');
                }
                else
                {
                    queueAnim('man_geralt_gabriel_strafe_f', 1.33, 0.2, 0, 'crossbow_forward');
                }
            }
            else if(lastMoveDir == 'backward')
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_geralt_gabriel_strafe_b', 1.37, 0.2, 0, 'crossbow_backward');
                }
                else
                {
                    queueAnim('man_geralt_gabriel_strafe_b', 1.33, 0.2, 0, 'crossbow_backward');
                }
            }
            else if(lastMoveDir == 'left')
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_geralt_gabriel_strafe_b_45l', 1.37, 0.2, 0, 'crossbow_left');
                }
                else
                {
                    queueAnim('man_geralt_gabriel_strafe_b_45l', 1.33, 0.2, 0, 'crossbow_left');
                }
            }
            else if(lastMoveDir == 'right')
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_geralt_gabriel_strafe_b_45r', 1.37, 0.2, 0, 'crossbow_right');
                }
                else
                {
                    queueAnim('man_geralt_gabriel_strafe_b_45r', 1.33, 0.2, 0, 'crossbow_right');
                }
            }
            else
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    queueAnim('man_geralt_gabriel_aim_idle_rp', 1.07, 0.2, 0, 'crossbow_idle');
                }
                else
                {
                    queueAnim('man_geralt_gabriel_aim_idle_rp', 1.03, 0.2, 0, 'crossbow_idle');
                }
            }

            lastAimingCrossbow = true;

            return;
        }
        else
        {
            if(lastAimingCrossbow)
            {
                ids = inv.GetItemsByName(eq_crossbow);
                if (ids.Size() > 0)
                {
                    ghost.EquipItem(ids[0]);
                    inv.UnmountItem(ids[0], true);

                    ghost.EquipItem(ids[0]);
                }

                if(curState == 'Swim' && speed == 0)
                {
                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim('man_geralt_gabriel_swim_idle_aim_end_rp', 1.03, 0.2, 0.5, 'none', true);
                    }
                    else
                    {
                        queueAnim('man_geralt_gabriel_swim_idle_aim_end_rp', 1, 0.2, 0.5, 'none', true);
                    }
                }
                else
                {
                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim('man_geralt_gabriel_aim_end_rp', 0.73, 0.2, 0.5, 'none', true);
                    }
                    else
                    {
                        queueAnim('man_geralt_gabriel_aim_end_rp', 0.7, 0.2, 0.5, 'none', true);
                    }
                }
                lastAimingCrossbow = false;
                smoothNext = true;
            }
        }
        
        // woman complete*
        if (prevLightTime < 0.0f)
        {
            prevLightTime = lastLightAttackTime;
        }
        else if (lastLightAttackTime != prevLightTime)// && (theGame.GetEngineTimeAsSeconds() - prevLightTime) > 1)
        {   
            if(!lastLightAttack)
            {
                if(heldItem == "silver" || heldItem == "steel")
                {
                    anim = theGame.r_getMultiplayerClient().getRandLightAnim();
                    queueAnim(anim.anim, anim.duration, 0.2, 0, 'attack', true);
                }
                else if(heldItem == "none")
                {
                    anim = theGame.r_getMultiplayerClient().getRandLightFistAnim();
                    queueAnim(anim.anim, anim.duration, 0.2, 0, 'attack', true);
                }

                lastLightAttack = true;
                prevLightTime = lastLightAttackTime;
            }
        }
        else
        {
            if(lastLightAttack)
            {
                lastLightAttack = false;
            }
        }

        if (prevHeavyTime < 0.0f)
        {
            prevHeavyTime = lastHeavyAttackTime;
        }
        else if (lastHeavyAttackTime != prevHeavyTime)// && (theGame.GetEngineTimeAsSeconds() - prevHeavyTime) > 1)
        {
            if(!lastHeavyAttack)
            {
                if(heldItem == "silver" || heldItem == "steel")
                {
                    anim = theGame.r_getMultiplayerClient().getRandHeavyAnim();
                    queueAnim(anim.anim, anim.duration, 0.2, 0, 'attack', true);
                }
                else if(heldItem == "none")
                {
                    anim = theGame.r_getMultiplayerClient().getRandHeavyFistAnim();
                    queueAnim(anim.anim, anim.duration, 0.2, 0, 'attack', true);
                }

                lastHeavyAttack = true;
                prevHeavyTime = lastHeavyAttackTime;
            }
        }
        else
        {
            if(lastHeavyAttack)
            {
                lastHeavyAttack = false;
            }
        }
        
        // woman complete
        if (prevDodgeTime < 0.0f)
        {
            prevDodgeTime = lastDodgeTime;
        }
        else if (lastDodgeTime != prevDodgeTime)
        {
            if(heldItem == "silver" || heldItem == "steel")
            {
                if(lastMoveDir == 'forward')
                {
                    anim = theGame.r_getMultiplayerClient().getRandSwordForwardDodgeAnim();

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim(anim.anim, anim.duration + 0.03, 0.4, 0, 'dodge', true);
                    }
                    else
                    {
                        queueAnim(anim.anim, anim.duration, 0.4, 0, 'dodge', true);
                    }
                }
                else if(lastMoveDir == 'backward')
                {
                    anim = theGame.r_getMultiplayerClient().getRandSwordBackDodgeAnim();

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim(anim.anim, anim.duration + 0.03, 0.4, 0, 'dodge', true);
                    }
                    else
                    {
                        queueAnim(anim.anim, anim.duration, 0.4, 0, 'dodge', true);
                    }
                }
                else if(lastMoveDir == 'left')
                {
                    anim = theGame.r_getMultiplayerClient().getRandSwordLeftDodgeAnim();

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim(anim.anim, anim.duration + 0.03, 0.4, 0, 'dodge', true);
                    }
                    else
                    {
                        queueAnim(anim.anim, anim.duration, 0.4, 0, 'dodge', true);
                    }
                }
                else if(lastMoveDir == 'right')
                {
                    anim = theGame.r_getMultiplayerClient().getRandSwordRightDodgeAnim();

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim(anim.anim, anim.duration + 0.03, 0.4, 0, 'dodge', true);
                    }
                    else
                    {
                        queueAnim(anim.anim, anim.duration, 0.4, 0, 'dodge', true);
                    }
                }
                else
                {
                    anim = theGame.r_getMultiplayerClient().getRandSwordBackDodgeAnim();
                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim(anim.anim, anim.duration + 0.03, 0.4, 0, 'dodge', true);
                    }
                    else
                    {
                        queueAnim(anim.anim, anim.duration, 0.4, 0, 'dodge', true);
                    }
                }
                
            }
            else if(heldItem == "none")
            {
                if(lastMoveDir == 'forward')
                {
                    anim = theGame.r_getMultiplayerClient().getRandFistForwardDodgeAnim();

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim(anim.anim, 1.53, 0.4, 0, 'dodge', true);
                    }
                    else
                    {
                        queueAnim(anim.anim, anim.duration, 0.4, 0, 'dodge', true);
                    }
                }
                else if(lastMoveDir == 'backward')
                {
                    anim = theGame.r_getMultiplayerClient().getRandFistBackDodgeAnim();

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim(anim.anim, 1.53, 0.4, 0, 'dodge', true);
                    }
                    else
                    {
                        queueAnim(anim.anim, anim.duration, 0.4, 0, 'dodge', true);
                    }
                }
                else if(lastMoveDir == 'left')
                {
                    anim = theGame.r_getMultiplayerClient().getRandFistLeftDodgeAnim();

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim(anim.anim, 1.53, 0.4, 0, 'dodge', true);
                    }
                    else
                    {
                        queueAnim(anim.anim, anim.duration, 0.4, 0, 'dodge', true);
                    }
                }
                else if(lastMoveDir == 'right')
                {
                    anim = theGame.r_getMultiplayerClient().getRandFistRightDodgeAnim();

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim(anim.anim, 1.53, 0.4, 0, 'dodge', true);
                    }
                    else
                    {
                        queueAnim(anim.anim, anim.duration, 0.4, 0, 'dodge', true);
                    }
                }
                else
                {
                    anim = theGame.r_getMultiplayerClient().getRandFistBackDodgeAnim();

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim(anim.anim, 1.53, 0.4, 0, 'dodge', true);
                    }
                    else
                    {
                        queueAnim(anim.anim, anim.duration, 0.4, 0, 'dodge', true);
                    }
                }
            }

            prevDodgeTime = lastDodgeTime;
        } 

        // woman complete*
        if (prevRollTime < 0.0f)
        {
            prevRollTime = lastRollTime;
        }
        else if (lastRollTime != prevRollTime)
        {
            if(heldItem == "silver" || heldItem == "steel")
            {
                if(lastMoveDir == 'forward')
                {
                    queueAnim('man_geralt_sword_dodge_roll_rp_f_01', 1.33, 0.4, 0, 'roll', true);
                }
                else if(lastMoveDir == 'backward')
                {
                    queueAnim('man_geralt_sword_dodge_roll_rp_b_01', 1.33, 0.4, 0, 'roll', true);
                }
                else if(lastMoveDir == 'left')
                {
                    queueAnim('man_ger_sword_roll_start_l', 0.57, 0.4, 0, 'roll', true);
                    queueAnim('man_ger_sword_roll_end_l', 0.87, 0, 0, 'roll', false);
                }
                else if(lastMoveDir == 'right')
                {
                    queueAnim('man_ger_sword_roll_start_r', 0.57, 0.4, 0, 'roll', true);
                    queueAnim('man_ger_sword_roll_end_r', 0.86, 0, 0, 'roll', false);
                }
                else
                {
                    queueAnim('man_geralt_sword_dodge_roll_rp_b_01', 1.33, 0.4, 0, 'roll', true);
                }
            }
            else if(heldItem == "none")
            {
                if(lastMoveDir == 'forward')
                {
                    queueAnim('man_geralt_sword_dodge_roll_rp_f_01_fist', 1.33, 0.4, 0, 'roll', true);
                }
                else if(lastMoveDir == 'backward')
                {
                    queueAnim('man_geralt_sword_dodge_roll_rp_b_01_fist', 1.33, 0.4, 0, 'roll', true);
                }
                else if(lastMoveDir == 'left')
                {
                    queueAnim('man_geralt_sword_dodge_roll_rp_f_01_fist', 1.33, 0.4, 0, 'roll', true);
                }
                else if(lastMoveDir == 'right')
                {
                    queueAnim('man_geralt_sword_dodge_roll_rp_f_01_fist', 1.33, 0.4, 0, 'roll', true);
                }
                else
                {
                    queueAnim('man_geralt_sword_dodge_roll_rp_b_01_fist', 1.33, 0.4, 0, 'roll', true);
                }
            }
            prevRollTime = lastRollTime;
        }

        // woman complete
        if(channeling)
        {
            if(signType == ST_Igni)
            {
                if(!lastChanneling)
                {
                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim('man_ger_sword_ignii_start_rp', 0.73, 0.2, 0, 'sign', true);
                    }
                    else
                    {
                        queueAnim('man_ger_sword_ignii_start_rp', 0.7, 0.2, 0, 'sign', true);
                    }
                    lastChanneling = true;
                }

                if(speed > 0)
                {
                    if(lastMoveDir == 'forward')
                    {
                        if(lastAnim != 'man_geralt_sword_strafe_f_igni')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('man_geralt_sword_strafe_f_igni', 1.37, 0.3, 0, 'forward', true);
                            }
                            else
                            {
                                queueAnim('man_geralt_sword_strafe_f_igni', 1.33, 0.3, 0, 'forward', true);
                            }
                        }

                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_sword_strafe_f_igni', 1.37, 0, 0, 'forward');
                        }
                        else
                        {
                            queueAnim('man_geralt_sword_strafe_f_igni', 1.33, 0, 0, 'forward');
                        }
                    }
                    else if(lastMoveDir == 'left')
                    {
                        if(lastAnim != 'man_geralt_sword_strafe_f_45l_igni')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('man_geralt_sword_strafe_f_45l_igni', 1.37, 0.3, 0, 'left', true);
                            }
                            else
                            {
                                queueAnim('man_geralt_sword_strafe_f_45l_igni', 1.33, 0.3, 0, 'left', true);
                            }   
                        }

                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_sword_strafe_f_45l_igni', 1.37, 0, 0, 'left');
                        }
                        else
                        {
                            queueAnim('man_geralt_sword_strafe_f_45l_igni', 1.33, 0, 0, 'left');
                        }
                    }
                    else if(lastMoveDir == 'right')
                    {
                        if(lastAnim != 'man_geralt_sword_strafe_f_45r_igni')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('man_geralt_sword_strafe_f_45r_igni', 1.37, 0.3, 0, 'right', true);
                            }
                            else
                            {
                                queueAnim('man_geralt_sword_strafe_f_45r_igni', 1.33, 0.3, 0, 'right', true);
                            }
                        }

                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_sword_strafe_f_45r_igni', 1.37, 0, 0, 'right');
                        }
                        else
                        {
                            queueAnim('man_geralt_sword_strafe_f_45r_igni', 1.33, 0, 0, 'right');
                        }
                    }
                    else
                    {
                        if(lastAnim != 'man_geralt_sword_strafe_b_igni')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('man_geralt_sword_strafe_b_igni', 1.37, 0.3, 0, 'backward', true);
                            }
                            else
                            {
                                queueAnim('man_geralt_sword_strafe_b_igni', 1.33, 0.3, 0, 'backward', true);
                            }
                        }

                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_sword_strafe_b_igni', 1.37, 0, 0, 'backward');
                        }
                        else
                        {
                            queueAnim('man_geralt_sword_strafe_b_igni', 1.33, 0, 0, 'backward');
                        }
                    }
                }
                else
                {
                    if(lastAnim != 'man_ger_sword_ignii_loop_rp')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_ger_sword_ignii_loop_rp', 2.27, 0.3, 0, 'swordidle');
                        }
                        else
                        {
                            queueAnim('man_ger_sword_ignii_loop_rp', 2.23, 0.3, 0, 'swordidle');
                        }
                    }

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim('man_ger_sword_ignii_loop_rp', 2.27, 0, 0, 'swordidle');
                    }
                    else
                    {
                        queueAnim('man_ger_sword_ignii_loop_rp', 2.23, 0, 0, 'swordidle');
                    }
                }
            }
            else if(signType == ST_Quen)
            {
                if(!lastChanneling)
                {
                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim('man_ger_sword_quen_start_rp', 0.73, 0.2, 0, 'sign', true);
                    }
                    else
                    {
                        queueAnim('man_ger_sword_quen_start_rp', 0.7, 0.2, 0, 'sign', true);
                    }
                    lastChanneling = true;
                }

                if(speed > 0)
                {
                    if(lastMoveDir == 'forward')
                    {
                        if(lastAnim != 'man_geralt_sword_strafe_f_quen')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('man_geralt_sword_strafe_f_quen', 1.37, 0.3, 0, 'forward', true);
                            }
                            else
                            {
                                queueAnim('man_geralt_sword_strafe_f_quen', 1.33, 0.3, 0, 'forward', true);
                            }
                        }

                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_sword_strafe_f_quen', 1.37, 0, 0, 'forward');
                        }
                        else
                        {
                            queueAnim('man_geralt_sword_strafe_f_quen', 1.33, 0, 0, 'forward');
                        }
                    }
                    else if(lastMoveDir == 'left')
                    {
                        if(lastAnim != 'man_geralt_sword_strafe_f_45l_quen')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('man_geralt_sword_strafe_f_45l_quen', 1.37, 0.3, 0, 'left', true);
                            }
                            else
                            {
                                queueAnim('man_geralt_sword_strafe_f_45l_quen', 1.33, 0.3, 0, 'left', true);
                            }
                        }

                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_sword_strafe_f_45l_quen', 1.37, 0, 0, 'left');
                        }
                        else
                        {
                            queueAnim('man_geralt_sword_strafe_f_45l_quen', 1.33, 0, 0, 'left');
                        }
                    }
                    else if(lastMoveDir == 'right')
                    {
                        if(lastAnim != 'man_geralt_sword_strafe_f_45r_quen')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('man_geralt_sword_strafe_f_45r_quen', 1.37, 0.3, 0, 'right', true);
                            }
                            else
                            {
                                queueAnim('man_geralt_sword_strafe_f_45r_quen', 1.33, 0.3, 0, 'right', true);
                            }
                        }

                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_sword_strafe_f_45r_quen', 1.37, 0, 0, 'right');
                        }
                        else
                        {
                            queueAnim('man_geralt_sword_strafe_f_45r_quen', 1.33, 0, 0, 'right');
                        }
                    }
                    else
                    {
                        if(lastAnim != 'man_geralt_sword_strafe_b_quen')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                queueAnim('man_geralt_sword_strafe_b_quen', 1.37, 0.3, 0, 'backward', true);
                            }
                            else
                            {
                                queueAnim('man_geralt_sword_strafe_b_quen', 1.33, 0.3, 0, 'backward', true);
                            }
                        }

                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_sword_strafe_b_quen', 1.37, 0, 0, 'backward');
                        }
                        else
                        {
                            queueAnim('man_geralt_sword_strafe_b_quen', 1.33, 0, 0, 'backward');
                        }
                    }
                }
                else
                {
                    if(lastAnim != 'man_ger_sword_quen_loop_rp')
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_ger_sword_quen_loop_rp', 2, 0.3, 0, 'swordidle');
                        }
                        else
                        {
                            queueAnim('man_ger_sword_quen_loop_rp', 1.97, 0.3, 0, 'swordidle');
                        }
                    }

                    if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                    {
                        queueAnim('man_ger_sword_quen_loop_rp', 2, 0, 0, 'swordidle');
                    }
                    else
                    {
                        queueAnim('man_ger_sword_quen_loop_rp', 1.97, 0, 0, 'swordidle');
                    }
                }
            }
        }
        else
        {
            if(lastChanneling)
            {
                animQueue.Clear();
                smoothNext = true;
                lastChanneling = false;
            }
        }
        
        // woman complete
        if(inCombat && !isMounted && !swirling && !rend && !channeling)
        {
            if(speed > 0)
            {
                if(heldItem == "silver" || heldItem == "steel")
                {
                    if(isGuarded)
                    {
                        if(lastMoveDir == 'forward')
                        {
                            if(lastAnim != 'man_longsword_guard_strafe_walk_f_rp')
                            {
                                queueAnim('man_longsword_guard_strafe_walk_f_rp', 1, 0.3, 0, 'forward');
                            }

                            queueAnim('man_longsword_guard_strafe_walk_f_rp', 1, 0, 0, 'forward');
                        }
                        else if(lastMoveDir == 'backward')
                        {
                            if(lastAnim != 'man_longsword_guard_strafe_walk_b_rp')
                            {
                                queueAnim('man_longsword_guard_strafe_walk_b_rp', 1, 0.3, 0, 'backward');
                            }

                            queueAnim('man_longsword_guard_strafe_walk_b_rp', 1, 0, 0, 'backward');
                        }
                        else if(lastMoveDir == 'left')
                        {
                            if(lastAnim != 'man_longsword_guard_strafe_walk_fl_rp')
                            {
                                queueAnim('man_longsword_guard_strafe_walk_fl_rp', 1, 0.3, 0, 'left');
                            }

                            queueAnim('man_longsword_guard_strafe_walk_fl_rp', 1, 0, 0, 'left');
                        }
                        else if(lastMoveDir == 'right')
                        {
                            if(lastAnim != 'man_longsword_guard_strafe_walk_fr_rp')
                            {
                                queueAnim('man_longsword_guard_strafe_walk_fr_rp', 1, 0.3, 0, 'right');
                            }

                            queueAnim('man_longsword_guard_strafe_walk_fr_rp', 1, 0, 0, 'right');
                        }
                        else
                        {
                            if(lastAnim != 'man_longsword_guard_strafe_walk_b_rp')
                            {
                                queueAnim('man_longsword_guard_strafe_walk_b_rp', 1, 0.3, 0, 'backward');
                            }

                            queueAnim('man_longsword_guard_strafe_walk_b_rp', 1, 0, 0, 'backward');
                        }
                    }
                    else
                    {
                        if(lastMoveDir == 'forward')
                        {
                            if(lastAnim != 'man_longsword_strafe_walk_f')
                            {
                                queueAnim('man_longsword_strafe_walk_f', 1, 0.3, 0, 'forward');
                            }

                            queueAnim('man_longsword_strafe_walk_f', 1, 0, 0, 'forward');
                        }
                        else if(lastMoveDir == 'backward')
                        {
                            if(lastAnim != 'man_longsword_strafe_walk_b')
                            {
                                queueAnim('man_longsword_strafe_walk_b', 1, 0.3, 0, 'backward');
                            }

                            queueAnim('man_longsword_strafe_walk_b', 1, 0, 0, 'backward');
                        }
                        else if(lastMoveDir == 'left')
                        {
                            if(lastAnim != 'man_longsword_strafe_walk_bl')
                            {
                                queueAnim('man_longsword_strafe_walk_bl', 1, 0.3, 0, 'left');
                            }

                            queueAnim('man_longsword_strafe_walk_bl', 1, 0, 0, 'left');
                        }
                        else if(lastMoveDir == 'right')
                        {
                            if(lastAnim != 'man_longsword_strafe_walk_br')
                            {
                                queueAnim('man_longsword_strafe_walk_br', 1, 0.3, 0, 'right');
                            }

                            queueAnim('man_longsword_strafe_walk_br', 1, 0, 0, 'right');
                        }
                        else
                        {
                            if(lastAnim != 'man_longsword_strafe_walk_b')
                            {
                                queueAnim('man_longsword_strafe_walk_b', 1, 0.3, 0, 'backward');
                            }

                            queueAnim('man_longsword_strafe_walk_b', 1, 0, 0, 'backward');
                        }
                    }
                }
                else if(heldItem == "none")
                {
                    if(isGuarded)
                    {
                        if(lastMoveDir == 'forward')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                if(lastAnim != 'man_fistfight_parry_strafe_walk_f')
                                {
                                    queueAnim('man_fistfight_parry_strafe_walk_f', 0.8, 0.3, 0, 'forward');
                                }

                                queueAnim('man_fistfight_parry_strafe_walk_f', 0.8, 0, 0, 'forward');
                            }
                            else
                            {
                                if(lastAnim != 'man_fistfight_parry_strafe_walk_f')
                                {
                                    queueAnim('man_fistfight_parry_strafe_walk_f', 0.77, 0.3, 0, 'forward');
                                }

                                queueAnim('man_fistfight_parry_strafe_walk_f', 0.77, 0, 0, 'forward');
                            }
                        }
                        else if(lastMoveDir == 'backward')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                if(lastAnim != 'man_fistfight_parry_strafe_walk_b')
                                {
                                    queueAnim('man_fistfight_parry_strafe_walk_b', 0.8, 0.3, 0, 'backward');
                                }

                                queueAnim('man_fistfight_parry_strafe_walk_b', 0.8, 0, 0, 'backward');
                            }
                            else
                            {
                                if(lastAnim != 'man_fistfight_parry_strafe_walk_b')
                                {
                                    queueAnim('man_fistfight_parry_strafe_walk_b', 0.77, 0.3, 0, 'backward');
                                }

                                queueAnim('man_fistfight_parry_strafe_walk_b', 0.77, 0, 0, 'backward');
                            }
                        }
                        else if(lastMoveDir == 'left')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                if(lastAnim != 'man_fistfight_parry_strafe_walk_l')
                                {
                                    queueAnim('man_fistfight_parry_strafe_walk_l', 0.8, 0.3, 0, 'left');
                                }

                                queueAnim('man_fistfight_parry_strafe_walk_l', 0.8, 0, 0, 'left');
                            }
                            else
                            {
                                if(lastAnim != 'man_fistfight_parry_strafe_walk_l')
                                {
                                    queueAnim('man_fistfight_parry_strafe_walk_l', 0.77, 0.3, 0, 'left');
                                }

                                queueAnim('man_fistfight_parry_strafe_walk_l', 0.77, 0, 0, 'left');
                            }
                        }
                        else if(lastMoveDir == 'right')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                if(lastAnim != 'man_fistfight_parry_strafe_walk_r')
                                {
                                    queueAnim('man_fistfight_parry_strafe_walk_r', 0.8, 0.3, 0, 'right');
                                }

                                queueAnim('man_fistfight_parry_strafe_walk_r', 0.8, 0, 0, 'right');
                            }
                            else
                            {
                                if(lastAnim != 'man_fistfight_parry_strafe_walk_r')
                                {
                                    queueAnim('man_fistfight_parry_strafe_walk_r', 0.77, 0.3, 0, 'right');
                                }

                                queueAnim('man_fistfight_parry_strafe_walk_r', 0.77, 0, 0, 'right');
                            }
                        }
                        else
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                if(lastAnim != 'man_fistfight_parry_strafe_walk_b')
                                {
                                    queueAnim('man_fistfight_parry_strafe_walk_b', 0.8, 0.3, 0, 'backward');
                                }

                                queueAnim('man_fistfight_parry_strafe_walk_b', 0.8, 0, 0, 'backward');
                            }
                            else
                            {
                                if(lastAnim != 'man_fistfight_parry_strafe_walk_b')
                                {
                                    queueAnim('man_fistfight_parry_strafe_walk_b', 0.77, 0.3, 0, 'backward');
                                }

                                queueAnim('man_fistfight_parry_strafe_walk_b', 0.77, 0, 0, 'backward');
                            }
                        }
                    }
                    else
                    {
                        if(lastMoveDir == 'forward')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                if(lastAnim != 'man_fistfight_strafe_walk_f')
                                {
                                    queueAnim('man_fistfight_strafe_walk_f', 0.8, 0.3, 0, 'forward');
                                }

                                queueAnim('man_fistfight_strafe_walk_f', 0.8, 0, 0, 'forward');
                            }
                            else
                            {
                                if(lastAnim != 'man_fistfight_strafe_walk_f')
                                {
                                    queueAnim('man_fistfight_strafe_walk_f', 0.77, 0.3, 0, 'forward');
                                }

                                queueAnim('man_fistfight_strafe_walk_f', 0.77, 0, 0, 'forward');
                            }
                        }
                        else if(lastMoveDir == 'backward')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                if(lastAnim != 'man_fistfight_strafe_walk_b')
                                {
                                    queueAnim('man_fistfight_strafe_walk_b', 0.8, 0.3, 0, 'backward');
                                }

                                queueAnim('man_fistfight_strafe_walk_b', 0.8, 0, 0, 'backward');
                            }
                            else
                            {
                                if(lastAnim != 'man_fistfight_strafe_walk_b')
                                {
                                    queueAnim('man_fistfight_strafe_walk_b', 0.77, 0.3, 0, 'backward');
                                }

                                queueAnim('man_fistfight_strafe_walk_b', 0.77, 0, 0, 'backward');
                            }
                        }
                        else if(lastMoveDir == 'left')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                if(lastAnim != 'man_fistfight_strafe_walk_l')
                                {
                                    queueAnim('man_fistfight_strafe_walk_l', 0.8, 0.3, 0, 'left');
                                }

                                queueAnim('man_fistfight_strafe_walk_l', 0.8, 0, 0, 'left');
                            }
                            else
                            {
                                if(lastAnim != 'man_fistfight_strafe_walk_l')
                                {
                                    queueAnim('man_fistfight_strafe_walk_l', 0.77, 0.3, 0, 'left');
                                }

                                queueAnim('man_fistfight_strafe_walk_l', 0.77, 0, 0, 'left');
                            }
                        }
                        else if(lastMoveDir == 'right')
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                if(lastAnim != 'man_fistfight_strafe_walk_r')
                                {
                                    queueAnim('man_fistfight_strafe_walk_r', 0.8, 0.3, 0, 'right');
                                }

                                queueAnim('man_fistfight_strafe_walk_r', 0.8, 0, 0, 'right');
                            }
                            else
                            {
                                if(lastAnim != 'man_fistfight_strafe_walk_r')
                                {
                                    queueAnim('man_fistfight_strafe_walk_r', 0.77, 0.3, 0, 'right');
                                }

                                queueAnim('man_fistfight_strafe_walk_r', 0.77, 0, 0, 'right');
                            }
                        }
                        else
                        {
                            if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                            {
                                if(lastAnim != 'man_fistfight_strafe_walk_b')
                                {
                                    queueAnim('man_fistfight_strafe_walk_b', 0.8, 0.3, 0, 'backward');
                                }

                                queueAnim('man_fistfight_strafe_walk_b', 0.8, 0, 0, 'backward');
                            }
                            else
                            {
                                if(lastAnim != 'man_fistfight_strafe_walk_b')
                                {
                                    queueAnim('man_fistfight_strafe_walk_b', 0.77, 0.3, 0, 'backward');
                                }

                                queueAnim('man_fistfight_strafe_walk_b', 0.77, 0, 0, 'backward');
                            }
                        }
                    }
                }
            }
            else
            {
                if(heldItem == "silver" || heldItem == "steel")
                {
                    if(isGuarded)
                    {
                        if(lastAnim != 'man_geralt_sword_parry_idle_rp')
                        {
                            queueAnim('man_geralt_sword_parry_idle_rp', 1, 0.3, 0, 'parryswordidle');
                        }

                        queueAnim('man_geralt_sword_parry_idle_rp', 1, 0, 0, 'parryswordidle');
                    }
                    else
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            if(lastAnim != 'man_geralt_sword_alert_idle_left')
                            {
                                queueAnim('man_geralt_sword_alert_idle_left', 3.0, 0.3, 0, 'swordidle');
                            }

                            queueAnim('man_geralt_sword_alert_idle_left', 3.0, 0, 0, 'swordidle');
                        }
                        else
                        {
                            if(lastAnim != 'man_geralt_sword_alert_idle_left')
                            {
                                queueAnim('man_geralt_sword_alert_idle_left', 1.5, 0.3, 0, 'swordidle');
                            }

                            queueAnim('man_geralt_sword_alert_idle_left', 1.5, 0, 0, 'swordidle');
                        }
                    }
                }
                else if(heldItem == "none")
                {
                    if(isGuarded)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            if(lastAnim != 'man_fistfight_idle_guarded')
                            {
                                queueAnim('man_fistfight_idle_guarded', 1.1, 0.3, 0, 'parryfistidle');
                            }

                            queueAnim('man_fistfight_idle_guarded', 1.1, 0, 0, 'parryfistidle');
                        }
                        else
                        {
                            if(lastAnim != 'man_fistfight_idle_guarded')
                            {
                                queueAnim('man_fistfight_idle_guarded', 1.06, 0.3, 0, 'parryfistidle');
                            }

                            queueAnim('man_fistfight_idle_guarded', 1.06, 0, 0, 'parryfistidle');
                        }
                    }
                    else
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            if(lastAnim != 'man_fistfight_idle')
                            {
                                queueAnim('man_fistfight_idle', 11.93, 0.3, 0, 'fistidle');
                            }

                            queueAnim('man_fistfight_idle', 11.93, 0.3, 0, 'fistidle');
                        }
                        else
                        {
                            if(lastAnim != 'man_fistfight_idle')
                            {
                                queueAnim('man_fistfight_idle', 11.92, 0.3, 0, 'fistidle');
                            }

                            queueAnim('man_fistfight_idle', 11.92, 0, 0, 'fistidle');
                        }
                    }
                }
            }  

            lastCombat = true;          
        }
        else
        {
            if(lastCombat && !rend)
            {
                animQueue.Clear();
                smoothNext = true;
                lastCombat = false;
            }
        }

        // woman complete
        if (prevHitTime < 0.0f)
        {
            prevHitTime = lastHit;
        }
        else if (lastHit != prevHitTime)
        {
            if(heldItem == "silver" || heldItem == "steel")
            {
                anim = theGame.r_getMultiplayerClient().getRandSwordHitAnim();
                queueAnim(anim.anim, anim.duration, 0.2, 0, 'hit', true);
            }
            else if(heldItem == "none")
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    anim = theGame.r_getMultiplayerClient().getRandFistHitAnim();
                    queueAnim(anim.anim, 1.03, 0.2, 0, 'hit', true);
                }
                else
                {
                    anim = theGame.r_getMultiplayerClient().getRandFistHitAnim();
                    queueAnim(anim.anim, anim.duration, 0.2, 0, 'hit', true);
                }
            }

            prevHitTime = lastHit;
        }

        // woman complete
        if (prevParryTime < 0.0f)
        {
            prevParryTime = lastParry;
        }
        else if (lastParry != prevParryTime)
        {
            if(heldItem == "silver" || heldItem == "steel")
            {
                anim = theGame.r_getMultiplayerClient().getRandSwordParryAnim();
                queueAnim(anim.anim, anim.duration, 0.2, 0, 'parry', true);
            }
            else if(heldItem == "none")
            {
                if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                {
                    anim = theGame.r_getMultiplayerClient().getRandFistParryAnim();
                    queueAnim(anim.anim, 1.03, 0.2, 0, 'parry', true);
                }
                else
                {
                    anim = theGame.r_getMultiplayerClient().getRandFistParryAnim();
                    queueAnim(anim.anim, anim.duration, 0.2, 0, 'parry', true);
                }
            }

            prevParryTime = lastParry;
        }

        // woman complete*
        if (prevFinisherTime < 0.0f)
        {
            prevFinisherTime = lastFinisher;
        }
        else if (lastFinisher != prevFinisherTime)
        {
            if(heldItem == "silver" || heldItem == "steel")
            {
                if(finisherMonster)
                {
                    queueAnim('man_ger_crawl_finish', 2.3, 0.2, 0, 'finisher', true);
                }
                else
                {
                    anim = theGame.r_getMultiplayerClient().getRandFinisherAnim();
                    queueAnim(anim.anim, anim.duration, 0.2, 0, 'finisher', true);
                }
            }

            prevFinisherTime = lastFinisher;
        }

        // woman complete
        if (prevSignTime < 0.0f)
        {
            prevSignTime = lastSign;
        }
        else if (lastSign != prevSignTime && !channeling)
        {
            if(inCombat)
            {
                if(heldItem == "silver" || heldItem == "steel")
                {
                    if(signType == ST_Igni)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_ger_sword_ignii_front_lp', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_ger_sword_ignii_front_lp', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Aard)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_ger_sword_aard_front_lp', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_ger_sword_aard_front_lp', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Axii)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_ger_sword_axii_draw_lp', 1.4, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_ger_sword_axii_draw_lp', 1.37, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Quen)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_ger_sword_quen_front_lp', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_ger_sword_quen_front_lp', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Yrden)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_ger_sword_yrden_ground_lp', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_ger_sword_yrden_ground_lp', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                }
                else if(heldItem == "none")
                {
                    if(signType == ST_Igni)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_fistfight_ignii_front', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_fistfight_ignii_front', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Aard)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_fistfight_aard_front', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_fistfight_aard_front', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Axii)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_fistfight_axii_release', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_fistfight_axii_release', 1.37, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Quen)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_fistfight_quen_front', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_fistfight_quen_front', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Yrden)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_fistfight_yrden_ground', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_fistfight_yrden_ground', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                }
            }
            else
            {
                if(heldItem == "silver" || heldItem == "steel")
                {
                    if(signType == ST_Igni)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_ignii_front_sword', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_geralt_ignii_front_sword', 1.70, 0.4, 0, 'sign', true);
                        } 

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Aard)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_aard_front_sword', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_geralt_aard_front_sword', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Axii)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_ger_sword_axii_release_lp_sword', 1.37, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_ger_sword_axii_release_lp_sword', 1.33, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Quen)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_quen_front_sword', 1.73, 0.4, 0, 'sign', true); 
                        }
                        else
                        {
                           queueAnim('man_geralt_quen_front_sword', 1.70, 0.4, 0, 'sign', true); 
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Yrden)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_yrden_ground_sword', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_geralt_yrden_ground_sword', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                }
                else if(heldItem == "none")
                {
                    if(signType == ST_Igni)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_ignii_front', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_geralt_ignii_front', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Aard)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_aard_front', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_geralt_aard_front', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Axii)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_axii_release', 1.37, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_geralt_axii_release', 1.33, 0.4, 0, 'sign', true);
                        }     

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Quen)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_quen_front', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_geralt_quen_front', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                    else if(signType == ST_Yrden)
                    {
                        if(cpcPlayerType != ENR_PlayerGeralt && cpcPlayerType != ENR_PlayerWitcher && cpcPlayerType != ENR_PlayerUnknown)
                        {
                            queueAnim('man_geralt_yrden_ground', 1.73, 0.4, 0, 'sign', true);
                        }
                        else
                        {
                            queueAnim('man_geralt_yrden_ground', 1.70, 0.4, 0, 'sign', true);
                        }

                        smoothDelayedNext = true;
                    }
                }
            }
            
            prevSignTime = lastSign;
        }

        if (prevActionTime < 0.0f)
        {
            prevActionTime = lastActionTime;
        }
        else if (lastActionTime != prevActionTime)
        {
            if(lastAction == PEA_Meditation)
            {
                queueAnim('meditation_start_long', 3.7, 0.4, 0, 'emote', true);
                queueAnim('meditation_idle01', 6.1, 0, 0, 'emote');
                queueAnim('meditation_stop_long', 2.83, 0, 0, 'emote');
            }
            else if(lastAction == PEA_ExamineGround)
            {
                queueAnim('work_kneeling_start', 2.37, 0.4, 0, 'emote', true);
                queueAnim('work_kneeling_loop', 3.23, 0, 0, 'emote');
                queueAnim('work_kneeling_end', 3.0, 0, 0, 'emote');
            }
            else if(lastAction == PEA_ExamineEyeLevel)
            {
                queueAnim('finding_clues_standing_start', 1.0, 0.4, 0, 'emote', true);
                queueAnim('finding_clues_standing_loop1', 2.0, 0, 0, 'emote');
                queueAnim('finding_clues_standing_stop', 1.0, 0, 0, 'emote');
            }
            else if(lastAction == PEA_SmellHigh)
            {
                queueAnim('geralt_finding_clues_high_smell', 5.07, 0.4, 0, 'emote', true);
            }
            else if(lastAction == PEA_SmellMid)
            {
                queueAnim('geralt_finding_clues_mid_smell', 5.0, 0.4, 0, 'emote', true);
            }
            else if(lastAction == PEA_SmellLow)
            {
                queueAnim('geralt_finding_clues_low_start', 1.0, 0.4, 0, 'emote', true);
                queueAnim('geralt_finding_clues_low_smell', 2.83, 0, 0, 'emote');
                queueAnim('geralt_finding_clues_low_end', 1.0, 0, 0, 'emote');
            }
            else if(lastAction == PEA_InspectHigh)
            {
                queueAnim('geralt_finding_clues_high_loop', 2.0, 0.4, 0, 'emote', true);
            }
            else if(lastAction == PEA_InspectMid)
            {
                queueAnim('geralt_finding_clues_mid_loop', 2.93, 0.4, 0, 'emote', true);
            }
            else if(lastAction == PEA_InspectLow)
            {
                queueAnim('geralt_finding_clues_low_start', 1.0, 0.4, 0, 'emote', true);
                queueAnim('geralt_finding_clues_low_loop', 2.0, 0, 0, 'emote');
                queueAnim('geralt_finding_clues_low_end', 1.0, 0, 0, 'emote');
            }
            else if(lastAction == PEA_IgniLight)
            {
                queueAnim('man_ger_idle_sign_igni_light', 2.0, 0.4, 0, 'emote', true);
            }
            else if(lastAction == PEA_AardLight)
            {
                queueAnim('man_ger_idle_sign_aard_light', 2.0, 0.4, 0, 'emote', true);
            }
            else if(lastAction == PEA_SetBomb)
            {
                queueAnim('geralt_blow_up_nest_001', 3.8, 0.4, 0, 'emote', true);
            }
            else if(lastAction == PEA_DispelIllusion)
            {
                queueAnim('geralt_use_illusion_2', 6.0, 0.4, 0, 'emote', true);
            }
            else if(lastAction == PEA_GoToSleep)
            {
                queueAnim('man_bandit_sitting01_start', 5.33, 0.4, 0, 'emote', true);
                queueAnim('man_bandit_sitting01_loop01', 11.73, 0, 0, 'emote');
                queueAnim('man_bandit_sitting01_stop', 1.67, 0, 0, 'emote');
            }

            prevActionTime = lastActionTime;
        }
    }

    private function updateHeldItems()
    {
        var inv : CInventoryComponent;
        var steel, silver : SItemUniqueId;
        var ids : array<SItemUniqueId>;
        var ids2 : array<SItemUniqueId>;

        inv = ghost.GetInventory();

        if( heldItem == "steel")
        {
            ids = inv.GetItemsByCategory('steelsword');
            inv.MountItem( ids[0], true );
        }
        else if(heldItem == "silver")
        {
            ids = inv.GetItemsByCategory('silversword');
            inv.MountItem( ids[0], true );
        }
        else if(heldItem == "none")
        {
            ids = inv.GetItemsByCategory('steelsword');
            ids2 = inv.GetItemsByCategory('silversword');

            ghost.EquipItem(ids[0]);
            ghost.EquipItem(ids2[0]);
        }

        if(heldSecondaryItem == "torch")
        {
            ids = inv.GetItemsByName('Torch_work');

            if(cpcPlayerType == ENR_PlayerGeralt || cpcPlayerType == ENR_PlayerWitcher)
            {
                inv.MountItem(ids[0], true);

                if(!holdingTorch)
                {
                    stopAllAnims();
                }
                
                holdingTorch = true;
            }
        }
        else if(heldSecondaryItem == "none")
        {
            ids = inv.GetItemsByName('Torch_work');
            ghost.EquipItem(ids[0]);

            ids = inv.GetItemsByName('Torch_work');
            inv.UnmountItem(ids[0], true);

            holdingTorch = false;
        }
    }

    private function setMoveType(entity:CActor, st:int)
    {
        ((CActor)entity).GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(st);
    }

    private function moveEntity(entity:CActor , targpos:Vector)
    {
        var dist, verticalDist, waterLevel : float;
        var entpos : Vector;
        var adjustor : CMovementAdjustor; 
        var ticket : SMovementAdjustmentRequestTicket; 
        var entityPAC : CMovingPhysicalAgentComponent;
        entpos = entity.GetWorldPosition();
        dist = VecDistance(entpos, targpos);
        adjustor = entity.GetMovingAgentComponent().GetMovementAdjustor();
        verticalDist = AbsF(targpos.Z - entpos.Z);

        if (dist > 0.01f)
            lastMoveDir = ClassifyMoveDirRelativeToCamera(entpos, targpos, heading);
        else
            lastMoveDir = 'none';

        if (dist > 0.5f)
            lastMoveDirAlt = ClassifyMoveDirRelativeToCamera(entpos, targpos, heading);
        else
            lastMoveDirAlt = 'none';

        if (dist > 1.0f)
            lastMoveDirAltAlt = ClassifyMoveDirRelativeToCamera(entpos, targpos, heading);
        else
            lastMoveDirAltAlt = 'none';

        if (verticalDist > 0.25f)
            lastVerticalMoveDir = ClassifyVerticalMoveDir(entpos, targpos);
        else
            lastVerticalMoveDir = 'none';

        if(isLadder)
        {
            if (verticalDist > 0.15f)
                lastVerticalMoveDir = ClassifyVerticalMoveDir(entpos, targpos);
            else
                lastVerticalMoveDir = 'none';
        }

        setHeading(entity, targpos);

        if(holdingTorch)
        {
            if(speed == 0)
            {
                setMoveType(entity, 0); 
            }
            else if(speed <= 0.7)
            {
                setMoveType(entity, 1);
            }
            else if(speed <= 1)
            {
                setMoveType(entity, 2);
            }
            else
            {
                setMoveType(entity, 4);
            }
        }
        else
        {
            setMoveType(entity, 0);
        }
        
        adjustor.Cancel(adjustor.GetRequest('w3mp_ghost'));
        ticket = adjustor.CreateNewRequest('w3mp_ghost');

        adjustor.AdjustmentDuration(ticket, 1);
        adjustor.AdjustLocationVertically(ticket, true);
        adjustor.ScaleAnimationLocationVertically(ticket, true);
        adjustor.RotateTo(ticket, heading); 
        adjustor.SlideTo(ticket, targpos);
        
        if(!lastDiving && dist > 200) 
            teleport(entity, targpos);
    }

    private function setHeading(entity:CActor , targpos:Vector)
    {
        ((CActor)entity).GetMovingAgentComponent().SetGameplayMoveDirection(VecHeading(targpos - entity.GetWorldPosition()));
    }

    private function teleport(entity:CActor , pos:Vector)
    {
        ((CActor)entity).Teleport(pos);
    }
}