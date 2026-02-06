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

statemachine class r_MultiplayerClient
{
    private var chillDefs : array<r_ChillDef>;
    private var id, username : string;
    private var players : array<r_RemotePlayer>;
    private var globalPlayers : array<r_RemotePlayer>;
    private var inGame : bool;
    private var spawnTime : float;
    private var execReceived : bool;

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

    private var lastChat : string;
    private var lastChatTime : float;
    private var prevChatTime : float;
    private var nameColors : array<r_NameColor>;

    private var maleTemp : CEntityTemplate;
    private var femaleTemp : CEntityTemplate;
    
    public function Init()
    {
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

        initChillDefs();

        nameColors.PushBack(r_NameColor("rejuvenate", "#5f90c6"));
        nameColors.PushBack(r_NameColor("mapledraws", "#5f90c6"));
        nameColors.PushBack(r_NameColor("imclumsy", "#5f90c6"));

        this.GotoState('WO_ClientIdle');
    }

    public function startTick()
    {
        if(this.GetCurrentStateName() != 'WO_Tick')
        {
            this.GotoState('WO_Tick');
        }
    }

    public function getNameColors() : array<r_NameColor>
    {
        return nameColors;
    }

    public function SetLocalEmoteState(anim : name, forceAnim : bool, loop : bool)
    {
        localEmoteAnim = anim;
        localEmoteForce = forceAnim;
        localEmoteLoop = loop;
    }

    public function ClearLocalEmoteState()
    {
        localEmoteAnim = '';
        localEmoteForce = false;
        localEmoteLoop = false;
    }

    private function GetLocalEmoteDuration() : float
    {
        var d : float;

        d = findChillDuration(localEmoteAnim);

        if(d <= 0)
            d = 3.0;

        return d;
    }

    public function UpdateLocalEmoteLoop()
    {
        var now : float;
        var dur : float;

        if(lastEmote < 0)
            return;

        if(!localEmoteLoop || localEmoteAnim == '')
            return;

        if(theInput.IsActionJustPressed('Jump') || theInput.IsActionJustPressed('Roll') || theInput.IsActionJustPressed('Dodge') || theInput.IsActionJustPressed('CbtRoll'))
        {
            ClearLocalEmoteState();
            setEmote(-2);
            mpghosts_playerEmote('');
            return;
        }

        now = theGame.GetEngineTimeAsSeconds();
        dur = GetLocalEmoteDuration();

        if((now - lastEmoteTime) >= dur )
        {
            mpghosts_playerEmote(localEmoteAnim, true);

            lastEmoteTime = now;
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
        addChill('meditation_idle01', 6.1);
        addChill('man_crying_loop_01', 5.17);
        addChill('man_cheering_loop', 3.63);
        addChill('man_begging_for_mercy_loop_01', 10.53);
        addChill('geralt_drunk_walk', 2.8);
        addChill('man_praying_crossed_legs_loop_02', 7.5);
        addChill('q103_man_prophesying_1', 15.07);
        addChill('seaman_working_on_the_ship_loop_01', 3.6);
        addChill('vanilla_sitting_on_ground_loop', 15.63);
        addChill('woman_noble_lying_relaxed_on_grass_loop_03', 11.2);
        addChill('mq7009_geralt_heroic_pose_lying', 19.7);
        addChill('locomotion_salsa_cycle_02', 40);
        addChill('woman_work_standing_hands_crossed_loop_02', 5.43);
        addChill('high_standing_determined2_idle', 23.07);
        addChill('man_finisher_head_01_reaction', 2.07);
        addChill('man_peeing_loop', 3.07);

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
            chatOneliner.offset = Vector(0,0,1.95);
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
        chatOneliner.offset = Vector(0,0,1.95);
        chatOneliner.visible = true;
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
                deleteChatOneliner();
            }
        }
    }

    public function setReceived()
    {
        execReceived = true;
    }

    public function getReceived() : bool
    {
        return execReceived;
    }

    public function setUserId(id : string, username : string)
    {
        this.id = id;
        this.username = username;
    }

    public function getId() : string
    {
        return id;
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

        now = theGame.GetEngineTimeAsSeconds();

        for (i = globalPlayers.Size() - 1; i >= 0; i -= 1)
        {
            if ((now - globalPlayers[i].lastUpdate) > timeout)
            {
                globalPlayers.Remove(globalPlayers[i]);
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

    public function updatePlayerData(idName : name, username : string, x : float, y : float, z : float, w : float, heading : float, speed : float, 
                                        area : int, clientInGame : bool, heldItem : string, offhandItem : string, inCombat : bool, 
                                        isSwimming : bool, curState : name, lastJumpTime : float, lastJumpType : EJumpType, 
                                        lastClimbType : EClimbHeightType, isDiving : bool, isFalling : bool, lastLightAttackTime : float, 
                                        lastHeavyAttackTime : float, lastDodgeTime : float, lastRollTime : float, isGuarded : bool, lastHit : float,
                                        lastParry : float, lastFinisher : float, finisherMonster : bool, signType : ESignType, lastSign : float, isSailing : bool, isMounted : bool,
                                        horseSpeed : float, aimingCrossbow : bool, isLadder : bool, currentState : name, bombSelected : bool, isAlive : bool,
                                        lastEmote : int, lastEmoteTime : float, lastChatTime : float, lastChat : string, chillOutAnim : name, yaw : float, stamina : float, swirling : bool, rend : bool,
                                        channeling : bool, menuName : string, lastActionTime : float, lastAction : EPlayerExplorationAction,
                                        steel : name, silver : name, armor : name, gloves : name, pants : name, boots : name, head : name, hair : name, steelScab : name, silverScab : name, crossbow : name, mask : name,
                                        cpcPlayerType : ENR_PlayerType, cpcHead : name, cpcHair : string, cpcBody : string, cpcTorso : string, cpcArms : string, cpcGloves : string, cpcDress : string, cpcLegs : string, cpcShoes : string, cpcMisc : string,
                                        cpcItem1 : string, cpcItem2 : string, cpcItem3 : string, cpcItem4 : string, cpcItem5 : string, cpcItem6 : string, cpcItem7 : string, cpcItem8 : string, cpcItem9 : string, cpcItem10 : string) 
    {
        var i : int;
        var p : r_RemotePlayer;
        var position: Vector;
        var oneliner : MP_SU_Oneliner;
        var foundGlobal : bool;
        var id : string;

        id = NameToString(idName);

        if((id == theGame.r_getMultiplayerClient().getUserId()) && !theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_ShowSelf'))
        {
            disconnect(id);
            return;
        }

        if(!inGame || theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HideGhosts'))
        {
            destroyAll();
            return;
        }

        position.X = x;
        position.Y = y;
        position.Z = z;
        position.W = w;

        if(!clientInGame)
        {
            disconnectGlobal(id);
            disconnect(id);
            return;
        }

        foundGlobal = false;
        for (i = 0; i < globalPlayers.Size(); i += 1)
        {
            if (globalPlayers[i].id == id)
            {
                globalPlayers[i].pos = position;
                globalPlayers[i].username = username;
                globalPlayers[i].idName = idName;
                globalPlayers[i].area = area;
                globalPlayers[i].lastUpdate = theGame.GetEngineTimeAsSeconds(); 
                foundGlobal = true;
                break;
            }
        }

        if (!foundGlobal)
        {
            p = new r_RemotePlayer in this;
            p.id = id;
            p.username = username;
            p.idName = idName;
            p.pos = position;
            p.area = area;
            p.lastUpdate = theGame.GetEngineTimeAsSeconds();
            globalPlayers.PushBack(p);
            if(p.username == "Player")
            {
                if(!theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HideJoinNotis'))
                {       
                    theGame.GetGuiManager().ShowNotification("A player joined");
                }
            }
            else
            {
                if(!theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HideJoinNotis'))
                {
                    theGame.GetGuiManager().ShowNotification(p.username + " joined");
                }
            }
        }

        for(i = 0; i < players.Size(); i+=1)
        {
            if(players[i].id == id)
            {
                if(theGame.GetCommonMapManager().GetCurrentArea() != area)
                {
                    disconnect(id);
                    return;
                }

                players[i].username = username;
                players[i].idName = idName;
                players[i].lastUpdate = theGame.GetEngineTimeAsSeconds();
                players[i].pos = position;
                players[i].heading = heading;
                players[i].speed = speed;
                players[i].area = area;
                players[i].heldItem = heldItem;
                players[i].heldSecondaryItem = offhandItem;
                players[i].inCombat = inCombat;
                players[i].isSwimming = isSwimming;
                players[i].curState = curState;
                players[i].lastJumpTime = lastJumpTime;
                players[i].lastJumpType = lastJumpType;
                players[i].lastClimbType = lastClimbType;
                players[i].isDiving = isDiving;
                players[i].isFalling = isFalling;
                players[i].lastLightAttackTime = lastLightAttackTime;
                players[i].lastHeavyAttackTime = lastHeavyAttackTime;
                players[i].lastDodgeTime = lastDodgeTime;
                players[i].lastRollTime = lastRollTime;
                players[i].isGuarded = isGuarded;
                players[i].lastHit = lastHit;
                players[i].lastParry = lastParry;
                players[i].lastFinisher = lastFinisher;
                players[i].finisherMonster = finisherMonster;
                players[i].signType = signType;
                players[i].lastSign = lastSign;
                players[i].isSailing = isSailing;
                players[i].isMounted = isMounted;
                players[i].horseSpeed = horseSpeed;
                players[i].aimingCrossbow = aimingCrossbow;
                players[i].isLadder = isLadder;
                players[i].currentState = currentState;
                players[i].bombSelected = bombSelected;
                players[i].isAlive = isAlive;
                players[i].lastEmote = lastEmote;
                players[i].lastEmoteTime = lastEmoteTime;
                players[i].lastChatTime = lastChatTime;
                players[i].lastChat = lastChat;
                players[i].chillOutAnim = chillOutAnim;
                players[i].yaw = yaw;
                players[i].stamina = stamina;
                players[i].swirling = swirling;
                players[i].rend = rend;
                players[i].channeling = channeling;
                players[i].menuName = menuName;
                players[i].lastActionTime = lastActionTime;
                players[i].lastAction = lastAction;

                // armor
                players[i].eq_steel = steel;
                players[i].eq_silver = silver;
                players[i].eq_armor = armor;
                players[i].eq_gloves = gloves;
                players[i].eq_pants = pants;
                players[i].eq_boots = boots;
                players[i].eq_head = head;
                players[i].eq_hair = hair;
                players[i].eq_steelScab = steelScab;
                players[i].eq_silverScab = silverScab;
                players[i].eq_crossbow = crossbow;
                players[i].eq_mask = mask;

                //cpc
                players[i].cpcPlayerType = cpcPlayerType;
                players[i].cpcHead = cpcHead;
                players[i].cpcHair = cpcHair;
                players[i].cpcBody = cpcBody;
                players[i].cpcTorso = cpcTorso;
                players[i].cpcArms = cpcArms;
                players[i].cpcGloves = cpcGloves;
                players[i].cpcDress = cpcDress;
                players[i].cpcLegs = cpcLegs;
                players[i].cpcShoes = cpcShoes;
                players[i].cpcMisc = cpcMisc;

                players[i].cpcItem1 = cpcItem1;
                players[i].cpcItem2 = cpcItem2;
                players[i].cpcItem3 = cpcItem3;
                players[i].cpcItem4 = cpcItem4;
                players[i].cpcItem5 = cpcItem5;
                players[i].cpcItem6 = cpcItem6;
                players[i].cpcItem7 = cpcItem7;
                players[i].cpcItem8 = cpcItem8;
                players[i].cpcItem9 = cpcItem9;
                players[i].cpcItem10 = cpcItem10;
                return;
            }
        }

        if(!clientInGame || theGame.IsPaused() || theGame.GetPhotomodeEnabled())
        {
            return;
        }
        
        if(theGame.GetCommonMapManager().GetCurrentArea() == area)
        {
            p = new r_RemotePlayer in this;
            p.id = id;
            p.username = username;
            p.idName = idName;
            p.lastUpdate = theGame.GetEngineTimeAsSeconds();
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

            // armor
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
            p.Init();

            players.PushBack(p);
        }
    }

    public function renderPlayers()
    {
        var i : int;
        for(i = 0; i < players.Size(); i+=1)
        {
            if((theGame.IsDialogOrCutscenePlaying() && !theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_ShowInCutscene')))
            {
                if(players[i].ghost.GetVisibility())
                {
                    players[i].ghost.SetVisibility(false);
                }
            }
            else
            {
                if(!players[i].ghost.GetVisibility())
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
            
            players[i].updateGhost();
        }
    }

    public function disconnect(id : string)
    {
        var i : int;

        for(i = 0; i < players.Size(); i+=1)
        {
            if(players[i].id == id)
            {
                MP_SUOL_getManager().deleteByTag("MPGhost" + id);
                MP_SUOL_getManager().deleteByTag("MPGhostStatus" + id);
                MP_SUOL_getManager().deleteByTag("MPGhostDummy" + id);
                players[i].despawn();
                players.Remove(players[i]);
                return;
            }
        }
    }

    public function disconnectGlobal(_id : string)
    {
        var i : int;
        for(i = 0; i < globalPlayers.Size(); i+=1)
        {
            if(globalPlayers[i].id == _id)
            {
                if(globalPlayers[i].username != "" && globalPlayers[i].id != id)
                {
                    if(!theGame.GetInGameConfigWrapper().GetVarValue('MPGhosts_Main', 'MPGhosts_HideJoinNotis'))
                    {
                        theGame.GetGuiManager().ShowNotification(globalPlayers[i].username + " disconnected");
                    }
                }
                globalPlayers.Remove(globalPlayers[i]);
                return;
            }
        }
    }

    public function destroyAll()
    {
        var i : int;
        for(i = 0; i < players.Size(); i+=1)
        {
            MP_SUOL_getManager().deleteByTag("MPGhost" + players[i].id);
            MP_SUOL_getManager().deleteByTag("MPGhostStatus" + players[i].id);
            MP_SUOL_getManager().deleteByTag("MPGhostDummy" + players[i].id);
            players[i].despawn();
        }

        players.Clear();
    }

    public function setVisibilityAll(val : bool)
    {
        var i : int;
        for(i = 0; i < players.Size(); i+=1)
        {
            players[i].ghost.SetVisibility(val);
        }

        players.Clear();
    }

    public function DisplayUserMessage(message: WitcherOnline_PlayerNotification) {

		var popup_data: WitcherOnline_PopupData = new WitcherOnline_PopupData in this;

		popup_data.SetMessageTitle( message.message_title );
		popup_data.SetMessageText( message.message_body );
		popup_data.PauseGame = true;
		
		theGame.RequestMenu('PopupMenu', popup_data);
	}
}

exec function mpghosts_setUserId(playerId : string, username : string)
{
    theGame.r_getMultiplayerClient().setUserId(playerId, username);
    theGame.r_getMultiplayerClient().setReceived();
}

exec function mpghosts_getData(optional playerId : string, optional username : string)
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
    var user : string;
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

    list += "namestart ";
    if(user == "" || user == " ")
    {
        list += "Player";
    }
    else
    {
        list += user;
    }
    list += " nameend ";

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

    list += thePlayer.GetMovingAgentComponent().GetRelativeMoveSpeed();
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

    /*ids = inv.GetItemsByCategory('crossbow');
    if(!offhandItem && inv.IsItemHeld(ids[0]))
    {
        list += "crossbow";
        offhandItem = true;
    }*/

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

    list += thePlayer.IsUsingHorse();
    list += " ";

    if ( thePlayer.IsUsingHorse() )
    {
		theHorse = (CActor)thePlayer.GetUsedHorseComponent().GetEntity();

        if(theHorse)
        {
            list += theHorse.GetMovingAgentComponent().GetSpeed();
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

    list += "chatstart ";
    list += theGame.r_getMultiplayerClient().getChat();
    list += " chatend ";

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

    list += "steelstart ";
    if(thePlayer.IsCiri() && GetCiriPlayer().HasSword())
    {
        list += 'Zireal Sword';
    }
    else
    {
        list += steelName;
    }
    list += " steelend ";

    list += "silverstart ";
    list += silverName;
    list += " silverend ";

    list += "armorstart ";
    list += armor;
    list += " armorend ";

    list += "glovesstart ";
    list += gloves;
    list += " glovesend ";

    list += "pantsstart ";
    list += pants;
    list += " pantsend ";

    list += "bootsstart ";
    list += boots;
    list += " bootsend ";

    list += "headstart ";
    list += head;
    list += " headend ";

    list += "hairstart ";
    list += hair;
    list += " hairend ";

    list += "steelscabstart ";
    list += steelScab;
    list += " steelscabend ";

    list += "silverscabstart ";
    list += silverScab;
    list += " silverscabend ";

    list += "crossbowstart ";
    list += crossbow;
    list += " crossbowend ";

    list += "maskstart ";
    list += mask;
    list += " maskend ";


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

    // cpc items
    for(i = 0; i < 10; i+=1)
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

    Log("mpghosts_cli "+list);
}

exec function mpghosts_updatePlayerData(id : name, username : string, x : float, y : float, z : float, w : float, heading : float, speed : float, area : int, 
                                        inGame : bool, heldItem : string, offhandItem : string, inCombat : bool, isSwimming : bool, curState : name, 
                                        lastJumpTime : float, lastJumpType : EJumpType, lastClimbType : EClimbHeightType, isDiving : bool, isFalling : bool,
                                        lastLightAttackTime : float, lastHeavyAttackTime : float, lastDodgeTime : float, lastRollTime : float, isGuarded : bool,
                                        lastHit : float, lastParry : float, lastFinisher : float, finisherMonster : bool, signType : ESignType, lastSign : float, isSailing : bool, isMounted : bool,
                                        horseSpeed : float, aimingCrossbow : bool, isLadder : bool, currentState : name, bombSelected : bool, isAlive : bool,
                                        lastEmote : int, lastEmoteTime : float, lastChatTime : float, lastChat : string, chillOutAnim : name, yaw : float, stamina : float, swirling : bool, rend : bool,
                                        channeling : bool, menuName : string, lastActionTime : float, lastAction : EPlayerExplorationAction,
                                        steel : name, silver : name, armor : name, gloves : name, pants : name, boots : name, head : name, hair : name, steelScab : name, silverScab : name, crossbow : name, mask : name,
                                        cpcPlayerType : ENR_PlayerType, cpcHead : name, cpcHair : string, cpcBody : string, cpcTorso : string, cpcArms : string, cpcGloves : string, cpcDress : string, cpcLegs : string, cpcShoes : string, cpcMisc : string,
                                        cpcItem1 : string, cpcItem2 : string, cpcItem3 : string, cpcItem4 : string, cpcItem5 : string, cpcItem6 : string, cpcItem7 : string, cpcItem8 : string, cpcItem9 : string, cpcItem10 : string) 
{
    theGame.r_getMultiplayerClient().updatePlayerData(id, username, x, y, z, w, heading, speed, area, inGame, heldItem, offhandItem, inCombat, isSwimming, 
                                                            curState, lastJumpTime, lastJumpType, lastClimbType, isDiving, isFalling, lastLightAttackTime,
                                                            lastHeavyAttackTime, lastDodgeTime, lastRollTime, isGuarded, lastHit, lastParry, lastFinisher, finisherMonster,
                                                            signType, lastSign, isSailing, isMounted, horseSpeed, aimingCrossbow, isLadder, currentState, bombSelected, isAlive,
                                                            lastEmote, lastEmoteTime, lastChatTime, lastChat, chillOutAnim, yaw, stamina, swirling, rend,
                                                            channeling, menuName, lastActionTime, lastAction,
                                                            steel, silver, armor, gloves, pants, boots, head, hair, steelScab, silverScab, crossbow, mask,
                                                            cpcPlayerType, cpcHead, cpcHair, cpcBody, cpcTorso, cpcArms, cpcGloves, cpcDress, cpcLegs, cpcShoes, cpcMisc,
                                                            cpcItem1, cpcItem2, cpcItem3, cpcItem4, cpcItem5, cpcItem6, cpcItem7, cpcItem8, cpcItem9, cpcItem10);
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

exec function stopemote()
{
    theGame.r_getMultiplayerClient().setEmote(-1);
    theGame.r_getMultiplayerClient().ClearLocalEmoteState();
    mpghosts_playerEmote('');
}

exec function emote(num : int)
{
    mpghosts_emote(num);
}

function mpghosts_emote(num : int)
{
    var cpcPlayerType : ENR_PlayerType;
    var anim : name;
    var force : bool;
    var loop : bool;
    cpcPlayerType = NR_GetPlayerManager().GetCurrentPlayerType();

    anim  = '';
    force = false;

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

    theGame.r_getMultiplayerClient().setEmote(num);
    theGame.r_getMultiplayerClient().setLastEmoteTime(theGame.GetEngineTimeAsSeconds());
    theGame.r_getMultiplayerClient().SetLocalEmoteState(anim, force, loop);

    if(anim != '')
        mpghosts_playerEmote(anim, force);
}

function mpghosts_chat(msg : string)
{
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
            theGame.GetGuiManager().ShowNotification("Teleporting to "+user);
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

    players = theGame.r_getMultiplayerClient().getGlobalPlayers();
    localPlayers = theGame.r_getMultiplayerClient().getPlayers();

    for(i = 0; i < players.Size(); i+=1)
    {
        if(SUH_normalizeRegion(AreaTypeToName(players[i].area)) == "no_mans_land")
        {
            velen += 1;
        }
        else if(SUH_normalizeRegion(AreaTypeToName(players[i].area)) == "skellige")
        {
            skellige += 1;
        }
        else if(SUH_normalizeRegion(AreaTypeToName(players[i].area)) == "bob")
        {
            toussaint += 1;
        }
        else if(SUH_normalizeRegion(AreaTypeToName(players[i].area)) == "prolog_village")
        {
            whiteOrchard += 1;
        }
        else if(SUH_normalizeRegion(AreaTypeToName(players[i].area)) == "kaer_morhen")
        {
            kaerMorhen += 1;
        }
        else if(SUH_normalizeRegion(AreaTypeToName(players[i].area)) == "wyzima_castle")
        {
            vizima += 1;
        }
    }

    total = velen + skellige + toussaint + whiteOrchard + kaerMorhen + vizima;
    other = players.Size() - total;

    messagetitle   = "<p align=\"center\">Player List<br/></p>";
    messagebody =
    "<p align=\"center\">"
    + players.Size() + " total players connected, " + localPlayers.Size() + " in your current region<br/><br/>"
    + whiteOrchard + " in White Orchard<br/>"
    + velen + " in Novigrad/Velen<br/>"
    + skellige + " in Skellige<br/>"
    + kaerMorhen + " in Kaer Morhen<br/>"
    + toussaint + " in Toussaint<br/>"
    + vizima + " in Vizima<br/>"
    + other + " in Other/Unknown"
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

    entry function wo_tickEntry()
	{
        while(true)
        {
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

            parent.renderPlayers();
            parent.updatePlayerChat();
            parent.UpdateLocalEmoteLoop();
            parent.pruneGlobalPlayers(3);
            MP_SU_moveMinimapPins();

            SleepOneFrame();
        }
    }
}