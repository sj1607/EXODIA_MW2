quickMods(player)
{
    player.quickMods = (!IsDefined(player.quickMods)) ? true : undefined;
    
    if(IsDefined(player.quickMods))
    {
       player thread healthMode("god");
       player thread ammoMode("unlimited");
       player thread giveAllPerks(player);
       setRadar("3" , player);
    }
   else
   {
       player thread healthMode("off"); 
       player thread ammoMode("off");
       player thread giveAllPerks(player);
       perkData = getPerkData();
       perkIDs  = perkData["perkID"];
        
       for(i = 0; i < perkIDs.size; i++)
       {
            perkID = perkIDs[i];
            if(player hasPerk(perkID))
            {
                player UnsetPerk(perkID);
            }
            wait(0.1);
       }
       setRadar("1" , player);
   }
}


healthMode(cmd)
{
    self.healthOpt = cmd;
    
    switch(cmd)
    {
        case "off":
        {
            eventCmd("notify", "end_GodMode", self);
            eventCmd("notify", "end_DemiGodMode", self);
            
            self.demi_godMode = undefined;
            self.godMode = undefined;
            if(self.health > 100)
            {
                self.maxhealth = 100;
                self.health = 100;
            }
            self unsetperk("specialty_falldamage");
            break;
        }
            
        
        case "god":
        {
            if(self.demi_godMode)
            {
                self.demi_godMode = undefined;
                eventCmd("notify", "end_DemiGodMode", self);
            }
            self thread godMode();
            break;
        }
            
       
        case "demigod":
        {
            if(self.godMode)
            {
                self.godMode = undefined;
                eventCmd("notify", "end_GodMode", self);
            }
            self thread demiGodMode();
            break;
        }
            
    }
}

godMode()
{
    eventCmd("endon", "disconnect", self);
    eventCmd("endon", "end_GodMode", self);
    self maps\mp\perks\_perks::givePerk("specialty_falldamage");
    self.godMode   = true;
    self.maxhealth = 999999;
    while(self.godMode)
    {
        if(self.health < self.maxhealth)
        {
            self.health = self.maxhealth;
        }
        wait (0.1);
    }
}

demiGodMode()
{
    eventCmd("endon", "disconnect", self);
    eventCmd("endon", "end_DemiGodMode", self);
    self maps\mp\perks\_perks::givePerk("specialty_falldamage");
    self.demi_godMode = true;
    self.maxhealth    = 2000;
    
    while(self.demi_godMode)
    {
        if(self.health < 500)
        {
            self.health = self.maxhealth;
        }
        wait (0.3);
    }
}

setHealth(int)
{
    self.maxhealth = int;
    self.health    = self.maxhealth;
    
    if(int == 0)
    {
        self Suicide();
    }
}

setSuicide()
{
    if( !self areYouSure() )
    return;
    self Suicide();
}
 
ammoMode(cmd)
{
    self.ammoOpt = cmd;
    
    switch(cmd)
    {
        case "off":
        {
            eventCmd("notify", "end_UnlimitedAmmo", self);
            eventCmd("notify", "end_UnlimitedAmmoReload", self);
            self.unlimitedAmmo = undefined;
            self.unlimitedAmmoReload = undefined;
            break;
        }
        
        case "unlimited":
        {
            if(IsDefined(self.unlimitedAmmoReload))
            {
                self.unlimitedAmmoReload = undefined;
            }
            eventCmd("notify", "end_UnlimitedAmmoReload", self);
            self thread unlimitedAmmo();
            break;
        }
        
        case "reload":
        {
            if(IsDefined(self.unlimitedAmmo))
            {
                self.unlimitedAmmo = undefined;
            }
            eventCmd("notify", "end_UnlimitedAmmo", self);
            self thread unlimitedAmmoReload();
            break;
        }
    }
}

unlimitedAmmo()
{
    eventCmd("endon", "disconnect", self);
    eventCmd("endon", "end_UnlimitedAmmo", self);
    
    self.unlimitedAmmo = true;
    while(IsDefined(self.unlimitedAmmo))
    {
        if (self getCurrentWeapon()!="none")
        {
          self setWeaponAmmoClip(self getCurrentWeapon(),weaponClipSize(self getCurrentWeapon()));self giveMaxAmmo(self getCurrentWeapon());
        }
            
        if (self getCurrentOffHand()!="none") self giveMaxAmmo(self getCurrentOffHand());
            
        wait (0.01);
    }
}


unlimitedAmmoReload()
{
    eventCmd("endon", "disconnect", self);
    eventCmd("endon", "end_UnlimitedAmmoReload", self);
    
    self.unlimitedAmmoReload = true;
    while(IsDefined(self.unlimitedAmmoReload))
    {    
        weapon = self getcurrentweapon();
        self givemaxammo(weapon);
        wait(0.01);
    }
}

disableAmmo(player)
{
    if(IsDefined(player.unlimitedAmmo || player.unlimitedAmmoReload))
    {
        player error("disable unlimited ammo.");
        return;
    }
    
    player.disableAmmo = (!IsDefined(player.disableAmmo)) ? true: undefined;
    
    if(IsDefined(player.disableAmmo))
    {
        while(IsDefined(player.disableAmmo))
        {
            currentWeapon = player getCurrentWeapon();
            if (currentWeapon != "none")
            {
                player setWeaponAmmoClip(currentWeapon, 0);
                player setWeaponAmmoStock(currentWeapon, 0);
            }
            
            currentOffhand = player getCurrentOffhand();
            if (currentOffhand != "none")
            {
                player setWeaponAmmoClip(currentOffhand, 0);
                player setWeaponAmmoStock(currentOffhand, 0);
            }
            wait(0.1);
        }
    }
    else
    {
        refillAmmo(true ,player);
    }
}

refillAmmo(skip , player)
{
    if( !skip ) if( !self areYouSure() )
        return;
    weaponPrimary  = player getCurrentWeapon();
    weaponSecondary  = player getcurrentoffhand();
    player setweaponammoclip( weaponPrimary, 9999 );
    player setweaponammoclip( weaponSecondary, 9999 );
    player givemaxammo ( weaponPrimary);
    player givemaxammo ( weaponSecondary);
    
}

getPerkData()
{
    perkData = [];
    perkData["perkID"] = ["specialty_akimbo","specialty_amplify","specialty_armorpiercing","specialty_armorvest","specialty_automantle","specialty_blackbox","specialty_blastshield","specialty_bling","specialty_bulletaccuracy","specialty_bulletaccuracy2","specialty_bulletdamage","specialty_bulletpenetration","specialty_burstfire","specialty_carepackage","specialty_challenger","specialty_coldblooded","specialty_combathigh","specialty_concussiongrenade","specialty_copycat","specialty_dangerclose","specialty_delaymine","specialty_detectexplosive","specialty_empgrenade","specialty_explosivebullets","specialty_explosivedamage","specialty_extendedmags","specialty_extendedmelee","specialty_extraammo","specialty_extraspecialduration","specialty_falldamage","specialty_fastmantle","specialty_fastmeleerecovery","specialty_fastreload","specialty_fastsnipe","specialty_fastsprintrecovery","specialty_feigndeath","specialty_finalstand","specialty_flashgrenade","specialty_fmj","specialty_fraggrenade","specialty_freerunner","specialty_gpsjammer","specialty_grenadepulldeath","specialty_hardline","specialty_heartbreaker","specialty_holdbreath","specialty_improvedholdbreath","specialty_jumpdive","specialty_laststandoffhand","specialty_lightweight","specialty_littlebird_support","specialty_localjammer","specialty_longersprint","specialty_marathon","specialty_null","specialty_null_attachment","specialty_null_gl","specialty_null_grip","specialty_null_shotgun","specialty_omaquickchange","specialty_onemanarmy","specialty_parabolic","specialty_pistoldeath","specialty_primarydeath","specialty_quickdraw","specialty_quieter","specialty_rearview","specialty_rof","specialty_rollover","specialty_saboteur","specialty_scavenger","specialty_secondarybling","specialty_selectivehearing","specialty_shellshock","specialty_shield","specialty_siege","specialty_sitrep","specialty_smokegrenade","specialty_specialgrenade","specialty_spygame","specialty_spygame2","specialty_steelnerves","specialty_tacticalinsertion","specialty_twoprimaries","stinger_mp","throwingknife_mp"];
    perkData["perkName"] = ["Akimbo","Amplify","Armor Piercing","Armor Vest","Auto Mantle","Black Box","Blast Shield","Bling","Bullet Accuracy","Bullet Accuracy Pro","Stopping Power","Deep Impact","Burst Fire","Care Package","Challenger","Cold Blooded","Combat High","Concussion Grenade","Copycat","Danger Close","Delayed Mine","Explosive Detection","EMP Grenade","Explosive Bullets","Explosive Damage","Extended Mags","Extended Melee","Extra Ammo","Extra Special Duration","Fall Damage Reduction","Fast Mantle","Fast Melee Recovery","Fast Reload","Quick Scope","Fast Sprint Recovery","Feign Death","Final Stand","Flash Grenade","Full Metal Jacket","Frag Grenade","Freerunner","GPS Jammer","Grenade Pull Death","Hardline","Heartbreaker","Hold Breath","Improved Hold Breath","Jump Dive","Last Stand Offhand","Lightweight","Little Bird Support","Local Jammer","Longer Sprint","Marathon","Null Perk","Null Attachment","Null Grenade Launcher","Null Grip","Null Shotgun","OMA Quick Change","One Man Army","Parabolic Mic","Pistol Death","Primary Death","Quickdraw","Dead Silence","Rear View","Rapid Fire","Rollover","Saboteur","Scavenger","Secondary Bling","Selective Hearing","Shell Shock","Shield","Siege","SitRep","Smoke Grenade","Special Grenade","Spy Game","Spy Game Pro","Steel Nerves","Tactical Insertion","Overkill","Stinger Missile","Throwing Knife"];
    return perkData;
}

giveAllPerks(player)
{
    player.giveAllPerks = (!IsDefined(player.giveAllPerks)) ? true : undefined;
    
    if (IsDefined(player.giveAllPerks))
    {
        perkData = getPerkData();
        perkIDs  = perkData["perkID"];
        
        for(i = 0; i < perkIDs.size; i++)
        {
            perkID = perkIDs[i];
            if(!player maps\mp\_utility::_HasPerk(perkID))
            {
               player maps\mp\_utility::_SetPerk(perkID);
            }
            wait(0.1);
        }
    }
    else
    {
        player maps\mp\_utility::_ClearPerks();
        player.giveAllPerks = undefined;
    }
}

givePerk(perk)
{
    if(self maps\mp\_utility::_HasPerk(perk))
    self maps\mp\_utility::_UnsetPerk(perk); 
    else
    self maps\mp\_utility::_SetPerk(perk);
}

invisibleMode(cmd)
{
    self.invisibleOpt = cmd;
    
    switch(cmd)
    {
        case "off":
        {
            self showAllParts();
            if(IsDefined(self.invisibleV2))
            {
                self setviewmodel(self.getModel);  
                self.invisibleV2 = undefined;
            }
            break;
        }
        
        case "invisible":
        {
            self hideAllParts();
            if(IsDefined(self.invisibleV2))
            {
                self setviewmodel(self.getModel);  
                self.invisibleV2 = undefined;
            }
            break;
        }
        
        case "invisiblev2":
        {
            self Hide();
            if(!IsDefined(self.invisibleV2))
            {
                self.invisibleV2 = true;
                if(!IsDefined(self.getModel))
                {
                    self.getModel = self getviewmodel();
                }
                 
                self.No_Arm = "viewmodel_hands_no_model";
                self setviewmodel(self.No_Arm);
            }
            break;
        }
    }
}

setHealthBar(player)
{
    player.healthBar = (!IsDefined(player.healthBar)) ? true : undefined;
    player endon("stopHealthBarChecking");
    if (IsDefined(player.healthBar))
    {
        
        player iprintln("^2Success : ^7Close the menu to see the health bar."); 

        for (;;)
        {
            if (!player.menu["isOpen"])
            {
                
                if (!IsDefined(player.menu["UI_BAR"]["HEALTH_BAR2"]) && !IsDefined(player.menu["OPT_BAR"]["HEALTH_BAR_TEXT"]))
                {
                    player.menu["UI_BAR"]["HEALTH_BAR2"] = [];
                    player.menu["OPT_BAR"]["HEALTH_BAR_TEXT"] = [];
                    player.menu["UI_BAR"]["HEALTH_BAR_GREEN"] = [];
                    
                    player.menu["UI_BAR"]["HEALTH_BAR2"] = player createRectangle("LEFT", "LEFT", 325, -171, 179, 20, player.presets["TITLE_OPT_BG"], "white", 100, 1);
                    player.menu["UI_BAR"]["HEALTH_BAR_GREEN"] = player createRectangle("LEFT", "LEFT", 327, -171, 175, 15, player.presets["SCROLL_STITLE_BG"], "white", 101, 2);
                    player.menu["OPT_BAR"]["HEALTH_BAR_TEXT"] = player createText("hudsmall", 1, "LEFT", "LEFT", 390, -171, 102, 1, player.health + "/" + player.maxhealth, player.presets["TEXT"]);
                    
                    //resetHUD(player);

                    if (!IsDefined(player.maxhealth) || player.maxhealth <= 0)
                    {
                        player.maxhealth = 100;
                    }

                    player thread updateHealthBar();
                }
            }
            else
            {
                
                if (IsDefined(player.menu["UI_BAR"]["HEALTH_BAR2"])) player.menu["UI_BAR"]["HEALTH_BAR2"] destroy();
                if (IsDefined(player.menu["UI_BAR"]["HEALTH_BAR_GREEN"])) player.menu["UI_BAR"]["HEALTH_BAR_GREEN"] destroy();
                if (IsDefined(player.menu["OPT_BAR"]["HEALTH_BAR_TEXT"])) player.menu["OPT_BAR"]["HEALTH_BAR_TEXT"] destroy();
            }

            wait(0.1);  
        }
    }
    else
    {
        
        if (IsDefined(player.menu["UI_BAR"]["HEALTH_BAR2"])) player.menu["UI_BAR"]["HEALTH_BAR2"] destroy();
        if (IsDefined(player.menu["UI_BAR"]["HEALTH_BAR_GREEN"])) player.menu["UI_BAR"]["HEALTH_BAR_GREEN"] destroy();
        if (IsDefined(player.menu["OPT_BAR"]["HEALTH_BAR_TEXT"])) player.menu["OPT_BAR"]["HEALTH_BAR_TEXT"] destroy();
        player notify("stopHealthBarChecking");
        player.healthBar = undefined;
    }
}

updateHealthBar()
{
    while (IsDefined(self.healthBar))
    {
        width = (self.health / self.maxhealth) * 175;
        width = int(max(width, 1));
        self.menu["UI_BAR"]["HEALTH_BAR_GREEN"] setShader("white", width, 16);
        self.menu["OPT_BAR"]["HEALTH_BAR_TEXT"] setText(self.health + "/" + self.maxhealth);
        //resetHUD(self);
        wait(0.1);
    }
}

setRadar(radar , player)
{
    
    player endon("disconnect");
    player.setRadarPlayer = radar;
    
    if(radar == "1")
    {
        player setClientDvar("g_compassShowEnemies", 0);
        player notify("stop_UAV");
        player.setUAV = undefined;
        player notify("stop_CounterUAV");
        player success("Radar Disabled.");
        
    }
    
    else if(radar == "2") 
    {
        player endon("stop_UAV");
        player endon("disconnect");
        player.setUAV = true;
        self success("UAV ^2Enabled^7.");
        player setClientDvar("g_compassShowEnemies", 0);
        while (IsDefined(player.setUAV))
        {
            player maps\mp\killstreaks\__uav::launchUAV( self, self.team, 999999, false );
            wait(60); 
        }
    }
    
    else if(radar == "3")
    {
        player.setUAV = undefined;
        player notify("stop_UAV");
        player setClientDvar("g_compassShowEnemies", 1);
        self success("Constant UAV ^2Enabled^7.");
    }
    
}

setNoSpread()
{ 
    self.noSpread = (!IsDefined(self.NoSpread)) ? true: undefined;
        
    if(IsDefined(self.noSpread))
    {
        self setClientDvar("perk_weapSpreadMultiplier","0.001");
        self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
        self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy2");
        self SetClientDvar("ui_drawCrosshair","1");
    } 
    else
    {   
        self setClientDvar("perk_weapSpreadMultiplier","1");
        self unsetperk("specialty_bulletaccuracy");
        self unsetperk("specialty_bulletaccuracy2");
        self SetClientDvar("ui_drawCrosshair","0");
        self.noSpread = undefined;
    }
}

noRecoil()
{
    self.noRecoil = (!IsDefined(self.noRecoil)) ? true : undefined;
    
    if(IsDefined(self.noRecoil))
    {
       self player_recoilscaleon(true);
    }
    else
    {
        self player_recoilscaleoff(true);
        self.noRecoil = undefined;
    }
}

setSpeed(int , player)
{
    player setmovespeedscale(int); 
}

setFov(float , player)
{
    if(!player isHost())
    {
        player setClientDvar("cg_fov" , float);
        player setClientDvar("cg_fovScale" , float);
    }
    else
    {
        WriteFloat( PC_ADRESSE_FOV,  float );
    }
   
}

setNoClip(player)
{
    
    player.setNoClip = (!IsDefined(player.setNoClip)) ? true : undefined;
    if(IsDefined(player.setNoClip))
    {   
        player unlink();
        player thread noClipInit(player);   
        player iPrintln("[{+smoke}] For Fly");
        player iPrintln("[{+gostand}] For Acceleratee");
        player iPrintln("[{+stance}] For Stop Flying");      
    } 
    else
    {
        player.setNoClip = undefined;
        player unlink();
        player.originObj delete();
        player notify("GreedIsland_StopNoClip");
    } 
}


noClipInit(player) 
{
    eventCmd("endon","disconnect",player);
    player endon("GreedIsland_StopNoClip");
    player.NoClip = 0;
    for(;;)
    {
        if(player.NoClip==0 && player secondaryOffhandButtonPressed())
        {
            player.originObj=spawn("script_origin",player.origin,1);
            player.originObj.angles=player.angles;
            player playerlinkto(player.originObj,undefined);
            player.NoClip=1;
        }

        if(player secondaryOffhandButtonPressed() && player.NoClip==1)
        {
            normalized=anglesToForward(player getPlayerAngles());
            scaled=vector_scale(normalized,46);
            originpos=player.origin+scaled;
            player.originObj.origin=originpos;
        }

        if(player.actionSlotsPressed[ "jump" ] && player.NoClip==1)
        {
            normalized=anglesToForward(player getPlayerAngles());
            scaled=vector_scale(normalized,330);
            originpos=player.origin+scaled;
            player.originObj.origin=originpos;
        }

        if(self.actionSlotsPressed[ "stance" ] && player.NoClip==1)
        {

            player unlink();
            player.originObj delete();
            player.NoClip=0;                         
              
        }
        wait (0.01);
    }   
      
     
    for(;;)
    {
        player waittill("death");
        player.NoClip=0;
        player.setNoClip = undefined;
        Player unlink();
        player.originObj delete();
        player notify("GreedIsland_StopNoClip"); 
    }
}

setChangeTeam(player)
{
    player.changeTeam = (!IsDefined(player.changeTeam)) ? true : undefined;
    if(IsDefined(player.changeTeam))
    {     
        if(player.pers["team"]=="allies")
        {          
            player changeteam("axis");       
        } 
        else if(player.pers["team"]=="axis")
        {
            player changeteam("allies");
        }
    } 
    else
    {      
        player.GreedIsland_ChangeTeam = undefined;
        if(player.pers["team"]=="allies")
        {
            player changeteam("axis");
        } 
        else if(player.pers["team"]=="axis")
        {
            player changeteam("allies");
        }
    }
}
    

changeteam( team )
{
    if ( self.sessionstate != "dead" )
    {
        self.switching_teams = 1;
        self.joining_team = team;
        self.leaving_team = self.pers[ "team" ];
        
    }
    self.pers[ "team" ] = team;
    self.team = team;
    self.sessionteam = self.pers[ "team" ];
    if ( !level.teambased )
    {
        self.ffateam = team;
    }
    self updateobjectivetext();
    self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
    self openmenu( game[ "menu_class" ] );
    self notify( "end_respawn" );  
    self closeMenus();
   
}

setAutoDropShot(player)   
{
   player.AutoDropShot = (!IsDefined(player.AutoDropShot)) ? true : undefined;
        
   if(IsDefined(player.AutoDropShot))
   {    
      player endon("GreedIsland_StopAutoDropShot");
      eventCmd("endon","disconnect",player);
     
       for(;;)
       {
        player waittill("weapon_fired");
        player setstance("prone");  
       }
    }
   else
   {      
       player notify("GreedIsland_StopAutoDropShot");
       for(;;)
       {
        player waittill("weapon_fired");      
       }
        player.AutoDropShot = undefined;
   }
}

changeClass(player)
{
    eventCmd("endon", "disconnect", player);

    oldClass = player.pers["class"];

    player maps\mp\gametypes\_menus::beginClassChoice();

    timeout = 99999;
    while ( timeout > 0 && player.pers["class"] == oldClass )
    {
        wait(0.1);
        timeout -= 0.1;
    }

    if ( player.pers["class"] != oldClass )
    {
        player thread maps\mp\gametypes\_class::giveloadout(player.pers["team"], player.pers["class"]);
        wait(0.1);
        player thread maps\mp\gametypes\_class::setClass(player.pers["class"]);
        player updateobjectivetext();
        player notify("end_respawn");
    }

    player closeMenus();
}

Sky_Menu(Sky_Option, self)
{
    if (Sky_Option == 1)
    {
        self setClientDvar("r_LightTweakSuncolor", "0.9 0.8 0.6 0.3"); 
        self setClientDvar("r_LightTweakSunlight", "2.2"); 
        self setClientDvar("r_clearColor", "0 0 0 0");
        self setClientDvar("r_clearColor2", "0 0 0 0");
    }

    if (Sky_Option == 2)
    {
        if (!IsDefined(self.GreedIsland_NightMode))
        {
            self.GreedIsland_NightMode = true;
            self setClientDvar("r_LightTweakSuncolor", "0 0 0 0"); 
            self setClientDvar("r_LightTweakSunlight", "0"); 
            self setClientDvar("r_FilmTweakDarktint", "0.8 0.77 1"); 
            self setClientDvar("r_FilmTweakLighttint", "1 1 0.9"); 
        }
        else
        {
            self.GreedIsland_NightMode = undefined;
            self setClientDvar("r_LightTweakSuncolor", "0.9 0.8 0.6 0.3"); 
            self setClientDvar("r_LightTweakSunlight", "2.2"); 
            self setClientDvar("r_FilmTweakDarktint", "0 0 0"); 
            self setClientDvar("r_FilmTweakLighttint", "1 1 1"); 
        }
    }

    if (Sky_Option == 3)
    {
        if (!IsDefined(self.SkyRainbowRGB))
        {
            self endon("disconnect");
            self.SkyRainbowRGB = true;
            self thread RandomRGBSky();
        }
        else
        {
            self.SkyRainbowRGB = undefined;
            self setClientDvar("r_LightTweakSuncolor", "0.9 0.8 0.6 0.3");
            self setClientDvar("r_clearColor", "0 0 0 0");
            self setClientDvar("r_clearColor2", "0 0 0 0");
            self notify("stop_RainbowSky");
        }
    }

    if (Sky_Option == 4)
    {
        if (!IsDefined(self.GreedIsland_DiscoMode))
        {
            self endon("disconnect");
            self endon("stop_RainbowSky");
            self endon("GreedIsland_StopDiscoMode");
            self.GreedIsland_DiscoMode = true;
            self thread RandomRGBSky();

            while (IsDefined(self.GreedIsland_DiscoMode))
            {
               self setClientDvar("r_LightTweakSuncolor", "1 0 0 1");
               self setClientDvar("r_clearColor", "1 0 0 0");
                wait 0.1;
               self setClientDvar("r_LightTweakSuncolor", "0 0 0 0");
               self setClientDvar("r_clearColor2", "0 1 0 0");
                wait 0.1;
               self setClientDvar("r_LightTweakSuncolor", "0 0 1 0");
               self setClientDvar("r_clearColor", "0 0 1 0");
                wait 0.1;
               self setClientDvar("r_LightTweakSuncolor", "1 0 0 0");
               self setClientDvar("r_clearColor2", "0 0 0 1");
                wait 0.1;
               self setClientDvar("r_LightTweakSuncolor", "0 1 0 0");
               self setClientDvar("r_clearColor", "1 0 0 0");
                wait 0.1;
               self setClientDvar("r_LightTweakSuncolor", "0 0 1 0");
               self setClientDvar("r_clearColor2", "0 1 0 0");
                wait 0.1;
               self setClientDvar("r_LightTweakSuncolor", "1 0 0 0");
                self setClientDvar("r_clearColor", "0 0 1 0");
                wait 0.1;
            }
        }
        else
        {
            self.GreedIsland_DiscoMode = undefined;
            self setClientDvar("r_LightTweakSuncolor", "0.9 0.8 0.6 0.3"); 
            self setClientDvar("r_clearColor", "0 0 0 0");
            self setClientDvar("r_clearColor2", "0 0 0 0");
            self notify("stop_RainbowSky");
            self notify("GreedIsland_StopDiscoMode");
        }
    }

    if (Sky_Option == 5)
    {
        if (!IsDefined(self.GreedIsland_DayMode))
        {
            self.GreedIsland_DayMode = true;
            self setClientDvar("r_LightTweakSuncolor", "1 1 1 1"); 
           self setClientDvar("r_LightTweakSunlight", "2.2"); 
           self setClientDvar("r_FilmTweakDarktint", "0 0 0");
            self setClientDvar("r_FilmTweakLighttint", "1 1 1"); 
        }
        else
        {
            self.GreedIsland_DayMode = undefined;
            self setClientDvar("r_LightTweakSuncolor", "1 0 0 1"); 
           self setClientDvar("r_LightTweakSunlight", "1"); 
        }
    }
}

RandomRGBSky()
{
    self endon("stop_RainbowSky");
    self endon("disconnect");

    SkyColors = strTok("0 1 0 0;0.25 0.30 0.00;0.80 0.40 0.00;0.90 0.90 0 0;0.20 0.07 0.00;0.00 0.67 0.80;0 0 1;1 0 0;1 1 1;1 0.30 0.65;0.27 0.00 0.80;0 0 0 0", ";");
    colorIndex = 0;
    maxIndex = SkyColors.size;

    for (;;)
    {
        self setClientDvar("r_clearColor", SkyColors[colorIndex]);
       self setClientDvar("r_clearColor2", SkyColors[colorIndex]);

        colorIndex = (colorIndex + 1) % maxIndex;

        wait 0.1;
    }
}


GreedIslandSkyColor(SkyColors)
{ 
    self setClientDvar("r_clearColor" , SkyColors); 
    self setClientDvar("r_clearColor2" , SkyColors);
}  

GreedIslandChangeBodyColor(BodyColor)
{
    if( level._Platform == "Xbox360" )
    address = XBOX_ADRESSE_SV_GAME_SEND_SERVER_COMMAND;
    else
    address = PC_ADRESS_SV_GAME_SEND_SERVER_COMMAND;
    RPC(address , -1,0, "v r_heroLightingEnabled 1");
    RPC(address , -1,0, "v r_heroLighting \"1 0 0\"");
    RPC(address , -1,0, "s \ cg_drawFPS \ 2\"");
}

GreedIsland_RainBowBody()
{
    if(!IsDefined(self.GreedIsland_RainbowBody))
    {                
        self endon("Stop_RainBowBody");
        self endon("disconnect"); 
        
       self.GreedIsland_RainbowBody = true;
       
      for(;;)
      {          
        BodyColor = StrTok("0 1 0 0;0.25 0.30 0.00;0.80 0.40 0.00;0.90 0.90 0 0;0.20 0.07 0.00;0.00 0.67 0.80;0 0 1;1 0 0;1 1 1;1 0.30 0.65;0.27 0.00 0.80;0 0 0 0", ";");
        self setClientDvar("r_heroLighting" ,BodyColor[randomint(BodyColor.size)]);  
        wait (0.5);
      } 
    }
    else
    {
        self.GreedIsland_RainbowBody = undefined;
        self setClientDvar("r_heroLighting" , "1 1 1 1"); 
        self notify("Stop_RainBowBody");
    }
}





