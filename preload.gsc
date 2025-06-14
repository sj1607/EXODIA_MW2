loadarrays()
{
    shaders = StrTok( "ui_host;gradient_fadein;gradient;gradient_top;gradient_bottom;ui_scrollbar_arrow_dwn_a;ui_scrollbar_arrow_up_a;white;headicon_dead;circle;hud_remote_missile_target;hud_medals_share_aq10escort;compass_static;black;circle;hud_shoutcasting_notify_arrow;thumbsup;codtv_like;codtv_dislike;menu_mp_lobby_like;logo;emblem_bg_kingofhill;acog_36;reflex_6;reflex_2;menu_mp_lobby_sog;lui_loader_no_offset;demo_pause;menu_mp_lobby_locked;light_corona;code_warning_fps;white;$blend;faction_128_spetsnaz;hud_status_dead", ";" );
    foreach(shader in shaders)
    PreCacheShader( shader ); 
        
    models = StrTok("viewmodel_hands_no_model;com_plasticcase_enemy;german_shepherd;defaultactor;defaultvehicle;projectile_cbu97_clusterbomb;t5_weapon_minigun_turret;t5_veh_jet_u2;t5_veh_helo_hind_killstreak;vehicle_cobra_helicopter_mp_light;t5_veh_jet_f4_gearup;t5_veh_rcbomb_axis;com_plasticcase_enemy;t5_weapon_camera_head_world;vehicle_cobra_helicopter_mp_dark;mp_flag_allies_1;mp_flag_axis_1;mp_flag_red;", ";" );
    foreach(model in models)
    PrecacheModel(model);
           
    items = StrTok( "explodable_barrel_mp" , ";" ); 
    foreach(item in items)
    PrecacheItem(item);
    
    loadCustomDvars(); 

    level.checkboxOpt = StrTok( "white;circle;checkbox;loader;text", ";" );
        
    level.fontOpt = StrTok( "reset;objective;default;bigfixed;smallfixed;big;small;extrabig;extrasmall", ";" );

    level.healthOpt = StrTok( "off;god;demigod", ";" );

    level.invisibleOpt = StrTok( "off;invisible;invisiblev2", ";" );

    level.ammoOpt = StrTok( "off;unlimited;reload", ";" );

    level.Radar = StrTok( "1;2;3;4", ";" );

    level.SkyColorsPreset = StrTok("0 1 0 0;0.25 0.30 0.00;0.80 0.40 0.00;0.90 0.90 0 0;0.20 0.07 0.00;0.00 0.67 0.80;0 0 1;1 0 0;1 1 1;1 0.30 0.65;0.27 0.00 0.80;0 0 0 0" , ";");
    
    level.bodyColorsPreset = StrTok("0 1 0 0;0.25 0.30 0.00;0.80 0.40 0.00;0.90 0.90 0 0;0.20 0.07 0.00;0.00 0.67 0.80;0 0 1;1 0 0;1 1 1;1 0.30 0.65;0.27 0.00 0.80;0 0 0 0" , ";");

    level.killStreaksPreset = StrTok("radar_mp;rcbomb_mp;counteruav_mp;auto_tow_mp;supply_drop_mp;napalm_mp;autoturret_mp;mortar_mp;helicopter_comlink_mp;m220_tow_mp;airstrike_mp;helicopter_gunner_mp;dogs_mp;helicopter_player_firstperson_mp;m202_flash_mp", ";");

    level.teleportMode = StrTok("0;1;2" , ";");   

    level.Visions = StrTok( "1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23", ";" );

    level.clone = StrTok( "1;2;3;4", ";" );
        
    level.forceField = StrTok( "1;2;3", ";" );

    level.statusOpt = StrTok( "1;2;3", ";" );

    level.posVelocity = StrTok("up;down;right;left;front;back" , ";");

    level.dogModels = StrTok( "german_shepherd;defaultactor;defaultvehicle;projectile_cbu97_clusterbomb;t5_weapon_minigun_turret;t5_veh_jet_u2;t5_veh_helo_hind_killstreak;t5_weapon_camera_head_world;mp_supplydrop_ally;t5_veh_jet_f4_gearup;t5_veh_rcbomb_axis", ";" );
    
    level.tornadoOpt = StrTok("spawn;delete" , ";");

    level.noTeamGameMode = StrTok( "gun;shrp;oic;sas;dm", ";" );
    
    level.aimbotTag = StrTok("OFF;j_head;j_neck;j_spineupper;j_spinelower;j_hip_le;j_hip_ri;j_shoulder_le;j_shoulder_ri;j_elbow_le;j_elbow_ri;j_wrist_le;j_wrist_ri;j_knee_le;j_knee_ri;j_ankle_le;j_ankle_ri" ,";");

    level.grenadeNames = StrTok( "void;hatchet_mp;frag_grenade_mp;sticky_grenade_mp;claymore_mp;scrambler_mp;satchel_charge_mp;concussion_grenade_mp;acoustic_sensor_mp;flash_grenade_mp;nightingale_mp;camera_spike_mp;tabun_gas_mp;willy_pete_mp", ";" ); 

    level.slideOptions = StrTok("1;2" , ";");  

    level.smg = Strtok("mp5k_mp;skorpion_mp;mac11_mp;ak74u_mp;pm63_mp;mpl_mp;spectre_mp;kiparis_mp", ";");

    level.Ar = Strtok("m16_mp;enfield_mp;m14_mp;famas_mp;galil_mp;aug_mp;fnfal_mp;ak47_mp;commando_mp;g11_mp", ";");

    level.shotguns = Strtok("rottweil72_mp;ithaca_mp;spas_mp;hs10_mp", ";");

    level.Lmg = Strtok("hl21_mp;rpk_mp;m60_mp;stoner63_mp", ";");

    level.SniperRifles = Strtok("dragunov_mp;wa2000_mp;l96a1_mp;psg1_mp", ";");

    level.pistols = Strtok("asp_mp;m1911_mp;makarov_mp;python_mp;cz75_mp", ";");

    level.Launchers = Strtok("m72_law_mp;rpg_mp;strela_mp;china_lake_mp", ";");

    level.otherSpecials = Strtok("knife_ballistic_mp;crossbow_explosive_mp", ";");

    level.grenade = Strtok("frag_grenade_mp;sticky_grenade_mp;hachet_mp;claymore_mp;satchel_charge_mp", ";");

    level.TacticalsGrenade = Strtok("willy_pete_mp;tabun_gas_mp;flash_grenade_mp;concussion_grenade_mp;nightingale_mp", ";");

    level.equipment = Strtok("camera_spike_mp;tactical_insertion_mp;scrambler_mp;acoustic_sensor_mp;claymore_mp", ";");
    
    //level.camo = array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
   
    level.attachementsList = StrTok("+extclip;+acog;+elbit;+reflex;+silencer;+rf;+grip;+dw;+gl;+dualclip;+mk;+ft;+ir;+vzoom;+upgradesight;+snub;+speed;+auto", ";");

    level.moddedBullet = StrTok("1;2;3;4;5;6;7;8;9;10;11;12", ";");  
   
    level._effect["bombexplosion"] = loadfx("maps/mp_maps/fx_mp_exp_bomb");

    level.moddedWeapons = StrTok( "defaultweapon_mp;asplh_mp;makarovlh_mp;pythonlh_mp;cz75lh_mp;m1911lh_mp;kiparislh_mp;skorpionlh_mp;pm63lh_mp;mac11lh_mp;hs10lh_mp;minigun_mp", ";" );
        
   

    level.messagesOpt = StrTok("1;2;3;4;5;6" , ";");

    level.messagesOpt2 = StrTok("1;2;3;4;5;6" , ";");

    level.messagesOpt3 = StrTok("1;2;3;4;5;6" , ";");

    level.messagesOpt4 = StrTok("1;2;3;4" , ";");
           
    level.DoheartPresetPos = StrTok( "1;2;3;4;5", ";" );

    level.customClassName = StrTok("None;#Exodia;yourName" , ";");

    level.clanTagPreset = StrTok( "None;^H@@@;3arc;HACK;NO U;EXO;HvH;1v1;[];-_-;@_@;<3;:-);:-(;^_^;IL", ";" );
        
    level.clanTagColor = StrTok( "^1;^2;^3;^4;^5;^6;^7;^8;^9;^0", ";" );

    level.allClientsTpMode = StrTok("me;cross;random" , ";");
            
    level.allClientsFreezeMode = StrTok("none;controls;game" , ";");
            
    level.allClientsSanctionMode = StrTok("kick;ban" , ";");
        
    level.ClientsSanctionMode = StrTok("kick;ban" , ";");

    level.quitMode = StrTok("kick;ban" , ";");
    
    if(level._Platform == "PC")
    {
        level.freezeMode = StrTok("None;Controls" , ";");
    }
    else
    {
        level.freezeMode = StrTok("None;Controls;Console" , ";");
    }
    
    level.blowUpMode = StrTok("hind_rockets_firstperson_mp;hind_minigun_pilot_2_mp;explode;m220_tow_mp" , ";");

    


    level.pushInit = StrTok("Forward;Backward;Right;Left;Up" , ";");

    level.stealthbombfx = loadfx("explosions/stealth_bomb_mp");

    level.chopper_fx["damage"]["light_smoke"] = loadfx ("smoke/smoke_trail_white_heli_emitter");

    level.flagModel["allies"] = maps\mp\gametypes\_teams::getTeamFlagModel( "allies" );
    level.flagModel["axis"] = maps\mp\gametypes\_teams::getTeamFlagModel( "axis" );

    precacheModel( level.flagModel["axis"] );
    precacheModel( level.flagModel["allies"] );

    
}

load_presets()
{
    self.presets = [];
    
    self.presets["X"] = 135;//x = -L/+R, y = -U/+D
    self.presets["Y"] = -40;//x = -L/+R, y = -U/+D
    
    self.presets["OUTLINE"] = get_preset("OUTLINE");
    self.presets["TITLE_OPT_BG"] = get_preset("TITLE_OPT_BG");
    self.presets["TITLE_OPT_BG2"] = get_preset("TITLE_OPT_BG2");
    self.presets["LINETOP1"] = get_preset("LINETOP1");
    self.presets["SCROLL_STITLE_BG"] = get_preset("SCROLL_STITLE_BG");
    self.presets["TEXT"] = get_preset("TEXT"); 
    self.presets["OFF"] = get_preset("OFF"); 
    self.presets["BACKGROUND"] = get_preset("BACKGROUND");
}

get_preset( preset )
{
    if( preset == "OUTLINE" )
        return rgb(255,223,0);
    if( preset == "TITLE_OPT_BG" )
        return rgb(33,33,33);
        if( preset == "TITLE_OPT_BG2" )
        return rgb(74,77,74);
        if( preset == "LINETOP1" )
        return rgb(252,203,90);
    if( preset == "SCROLL_STITLE_BG" )
        return rgb(252,203,90);
    if( preset == "TEXT" )
        return (1, 1, 1);  
    if( preset == "OFF")
        return (1, 0, 0);
    if( preset == "BACKGROUND")
        return rgb(0 , 0, 0);
    if( preset == "X" )
        return 0;
    if( preset == "Y" )
        return 0;    
       if(preset  == "WHITE")
       return (1,1,1);
}


loadCustomDvars()
{
    
    if(getDvar("menuBox") != "1" && getDvar("menuBox") != "0")
    {
        SetDvar("menuBox", "1"); 
    }
    
    if(!IsDefined(getDvar("toggleBoxShader")) || !getDvar("toggleBoxShader"))
    {
        setDvar("toggleBoxShader", "white");
        self thread refreshMenu(true);
    }
    
    if(!IsDefined(getDvar("menuFont")) || !getDvar("menuFont"))
    {
        setDvar("menuFont", "reset");
        self thread refreshMenu(true);
    }
    
    
}

 