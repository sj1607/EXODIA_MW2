menuOptions()
{
    level notify("FIX_OVERFLOW");
    player = self.selected_player;        
    menu = self getCurrentMenu();

    self addMenu("main", "EXODIA");
    self addOpt("Main Menu" , ::newMenu, "mainMenu");
    
    if(self.status == "VIP")
    {
       self addOpt("Fun Menu" , ::newMenu, "funMenu");
       self addOpt("Settings Menu" , ::newMenu, "settingsMenu");
    }
    else if(self.status == "Admin")
    {
        self addOpt("Fun Menu", ::newMenu, "funMenu");
        self addOpt("Weapons Menu", ::newMenu, "weaponsMenu");
        self addOpt("Aimbot Menu", ::newMenu, "aimbotMenu");
        self addOpt("Settings Menu" , ::newMenu, "settingsMenu");
    }
    else if(self.status == "Co-Host")
    {
        self addOpt("Fun Menu", ::newMenu, "funMenu");
        self addOpt("Bot Menu" , ::newMenu, "botMenu");
        self addOpt("Aimbot Menu", ::newMenu, "aimbotMenu");
        self addOpt("Weapons Menu", ::newMenu, "weaponsMenu");
        self addOpt("Game Menu", ::newMenu, "gameMenu");
        self addOpt("Account Menu", ::newMenu, "accountMenu");
        self addOpt("Settings Menu" , ::newMenu, "settingsMenu");
        self addOpt("All Clients Menu" , ::newMenu, "allclientsMenu");
        self addOpt("Clients Menu", ::newMenu, "clients"); 
        
    }
    else if(self.status == "Host" || self.status == "Owner")
    {
        self addOpt("Fun Menu", ::newMenu, "funMenu");
        self addOpt("Bot Menu" , ::newMenu, "botMenu");
        self addOpt("Aimbot Menu", ::newMenu, "aimbotMenu");
        self addOpt("Weapons Menu", ::newMenu, "weaponsMenu");
        self addOpt("Game Menu", ::newMenu, "gameMenu");
        self addOpt("Account Menu", ::newMenu, "accountMenu");
        self addOpt("Settings Menu" , ::newMenu, "settingsMenu");
        self addOpt("All Clients Menu" , ::newMenu, "allclientsMenu");
        self addOpt("Clients Menu", ::newMenu, "clients"); 
    }

     
     switch(menu)
     {

        case "mainMenu":
        {
            self addMenu("mainMenu", "Main Menu");
            self addOpt("Health Menu" , ::newMenu, "healthMenu");
            self addOpt("Ammo Menu" , ::newMenu, "ammoMenu");
            self addOpt("Perks Menu" , ::newMenu, "perksMenu");
            self addOpt("Streak Menu"  , ::newMenu, "streakMenu"); 
            self addToggle("Quick Mods", self.quickMods , ::quickMods, self);
            self addSliderString("Invisible","off;invisible;invisiblev2","^1OFF;^7Invisible;Invisible V2", ::invisibleMode);
            self addSliderString("Radar" , "1;2;3", "^1OFF;^7UAV;Constant UAV;VSAT", ::setRadar , self);
            self addToggle("No Spread" , self.NoSpread , ::setNoSpread);
            self addToggle("No Recoil" , self.noRecoil , ::noRecoil);
            self addSliderValue("Change Speed" , 1 , 0 , 20 , 1 , ::setSpeed , self);
            self addSliderValue("Change FOV" , 65.0 , 0 , 120.0 , 5.0 , ::setFov , self);
            self addToggle("No Clip" , self.setNoClip , ::setNoClip , self);
            self addToggle("Change Team" , self.changeTeam , ::setChangeTeam , self);
            self addToggle("Auto Drop Shot", self.AutoDropShot , ::setAutoDropShot , self);
            self addOpt("Change Class" , ::changeClass , self);
            
        }

        case "healthMenu":
        {
            self addMenu("healthMenu","Health Menu");
            self addSliderString("GodMode", "off;god;demigod" , "^1OFF;^7GodMode;Demi GodMode", ::healthMode);
            self addSliderValue("Set Health", 100, 0, 2147483647, 100 , ::setHealth);
            self addOpt("Suicide", ::setSuicide);
            self addToggle("Health Bar" , self.healthBar , ::setHealthBar , self);
            self addOpt("Debug My Health : ^1" +self.health);
        }
        
        case "ammoMenu":
        {
            self addMenu("ammoMenu","Ammo Menu");
            self addSliderString("Unlimited Ammo","off;unlimited;reload" , "^1OFF;^7Continuous;Reload", ::ammoMode);
            self addToggle("Disable Ammo", self.disableAmmo, ::disableAmmo , self);
            self addOpt("Refill Ammo", ::refillAmmo, true , self);
        }
        
       case "perksMenu":
        {   
            
            self addMenu("perksMenu","Perks Menu");
            self addToggle("Give All Perks", self.giveAllPerks, ::giveAllPerks, self );
            
            perkData  = getPerkData();
            perkIDs   = perkData["perkID"];
            perkNames = perkData["perkName"];

            for(i = 0; i < perkIDs.size; i++)
            {
                perkID   = perkIDs[i]; 
                perkName = perkNames[i];
                
                self addToggle(perkName, self maps\mp\_utility::_HasPerk(perkID), ::givePerk, perkID);
            }
           
        }

        case "skyMenu":
        {
            self addMenu("skyMenu"  , "Sky Menu");
            self addSliderString("Change Color", "0 1 0 0;0.25 0.30 0.00;0.80 0.40 0.00;0.90 0.90 0 0;0.20 0.07 0.00;0.00 0.67 0.80;0 0 1;1 0 0;1 1 1;1 0.30 0.65;0.27 0.00 0.80;0 0 0 0", "Green;Green Army;Orange;Yellow;Brown;Cyan;Blue;Red;White;Pink;Purple;Black", ::GreedIslandSkyColor);
            self addToggle("Rainbow Sky", self.SkyRainbowRGB, ::Sky_Menu , 3, self);
            self addOpt("Reset Color"  , ::Sky_Menu , 1 , self); 
            self addToggle("Night Mode", self.GreedIsland_NightMode, ::Sky_Menu , 2 , self);
            self addToggle("Day Mode", self.GreedIsland_DayMode, ::Sky_Menu , 5 , self);
            self addToggle("Disco Mode", self.GreedIsland_DiscoMode, ::Sky_Menu , 4);  
        }

        case "streakMenu" :
        {
            self addMenu("streakMenu","Main Menu");
            self addOpt("Modded Killstreaks", ::newMenu , "moddedStreaks");
            self addToggle("Never Streaks" , self.neverStreak , ::neverStreak ,  self);
            self addSliderString("Give", "uav;counter_uav;airdrop;sentry;predator;precision_airstrike;harrier_airstrike;stealth_airstrike;airdrop_mega;helicopter_flares;helicopter_minigun;ac130;emp;nuke", "UAV;Counter UAV;Care Package;Sentry Gun;Predator Missle;Precision Airstrike;Harrier Strike;Stealth Bomber;Emergency Airdrop;Attack Helicopter;Chopper Gunner;AC130;EMP;Nuke", ::giveStreak , self);
        }

        case "moddedStreaks":
        {
            self addMenu("moddedStreaks","Modded Streaks");
            self addToggle("Ride Helicopter" , self.Init_Helicopter , ::InitHelicopter); 
            self addToggle("Ride Plane", self.ridePlane, ::ridePlane); 
        }

        case "bodyMenu":
        {
            self addMenu("bodyMenu","Body Menu");
            self addSliderString("Change Color", "0 1 0 0;0.25 0.30 0.00;0.80 0.40 0.00;0.90 0.90 0 0;0.20 0.07 0.00;0.00 0.67 0.80;0 0 1;1 0 0;1 1 1;1 0.30 0.65;0.27 0.00 0.80;0 0 0 0", "Green;Army Green;Orange;Yellow;Brown;Cyan;Blue;Red;White;Pink;Purple;Black", ::GreedIslandChangeBodyColor); 
            self addToggle("Rainbow Body", self.GreedIsland_RainbowBody, ::GreedIsland_RainBowBody);
        }

        case "funMenu":
        {
            self addMenu("funMenu", "Fun Menu");
            self addOpt("Third Person Menu"  , ::newMenu, "tpMenu");
            self addOpt("Spawn Menu"  , ::newMenu, "spawnMenu");
            self addtoggle("Super Jump", self.superJump, ::superJump);
            self addSliderString("Teleport", "0;1;2" , "^1OFF;^7Normal;Animation" , ::doTeleport , self);
            self addToggle("Lag Mode" , self.lagMode, ::setLagMode , self);
            self addSliderString("Change Visions", "default;icbm;aftermath;ac130_inverted;ac130_thermal_mp;af_caves_indoors_steamroom;enhanced;cheat_contrast;cobra_sunset1;cobra_sunset2;cobra_sunset3;grayscale;end_game;airport_green;sepia;cartoon;black;grey;white", "Default;Night;Nuke Aftermath;Inverted;Thermal;Steam Room;Enhanced;Cheat Contrast;Sunset 1;Sunset 2;Sunset 3;Grayscale;Red;Green;Sepia;Cartoon;Black;Grey;White", ::setVision , self );
            self addSliderString("Clone" , "1;2;3;4" , "Normal;Dead;T-Pose;Explode" , ::spawnClone , self);
            self addSliderString("Forcefield" , "1;2;3" , "^1OFF;^7Normal;Kill" , ::forceField , self);
            self addSliderString("Change Status" , "1;2;3" , "^1OFF;^7Dead;Connecting" , ::toggleStatus , self);
            self addToggle("Quick Dash" ,  self.quickDash , ::quickDash , self);
            self addSliderString("Propel" , "up;down;right;left;front;back" , "Up;Down;Right;Left;Front;Back" , ::propelPlayer , self);
            self addToggle("Spin Bot", self.spinBotInit ,::spinBot , self);
            self addOpt("Snake Mode",  ::snakeMode , self);
            self addToggle("Screen Rotation" , self.screenRotation , ::screenRotation);

            
        }

        case "tpMenu":
        {
            self addMenu("tpMenu"  , "Main Menu"); 
            self addToggle("Third Person" , self.rdPerson , ::_setThirdPerson , self);
            self addToggle("Go Pro Mode" , self.goPro , ::goProMode , self );
            self addToggle("POV Mode" , self.povMode , ::povMode , self );
            self addSliderValue("TP Range" , 80, 0, 1024, 20 , ::setThirdPersonRange , self );
            self addSliderValue("TP Angle" , 0, -180, 180, 10 , ::setThirdPersonAngle , self);
        }

        case "spawnMenu":
        {
            self addMenu("spawnMenu"  , "Main Menu"); 
            self addOpt("Meteore" , ::setMeteore);
            self addSliderString("Tornado" , "spawn;delete" , "Spawn;Delete" , ::setTornadoOpt);
        }

        case "botMenu":
        {
            self addMenu("botMenu" , "Main Menu"); 
            level.setNoTeamGameMode = false;
            gm                      = getDvar("g_gametype");

            foreach(gamemodes in level.noTeamGameMode)
            {
                if(gamemodes == gm)
                {
                    level.setNoTeamGameMode = true;
                    break; 
                }
            }

            
            if(level.setNoTeamGameMode)
            {
                self addOpt("Main Menu", ::newMenu ,"botMain" );
                self addSliderValue("Spawn Bot(s)", 1, 1, 12, 1, ::initTestClient , "autoassign");
                self addToggle("Freeze Bot(s)", level.freezeBots, ::freezeBots);
                self addOpt("Teleport Bot(s) To Crosshair", ::tpBot);
                self addToggle("Set Spawn Point Bot(s)",level.customBotSpawn , ::spawnPointBots);
                //self addToggle("Bot(s) Skip Killcam", self.skipKillcam, ::skipKillcam);
                self addOpt("Kill Bot(s)", ::killBots);
                self addOpt("Kick Bot(s)", ::kickBots);
            }
            else
            {
                self addOpt("Main Menu", ::newMenu ,"botMain" );
                self addSliderValue("Spawn Allies ", 1, 1, 12, 1, ::initTestClient , "same");
                self addSliderValue("Spawn Enemies ", 1, 1, 12, 1, ::initTestClient , "opposite");
                self addToggle("Freeze Bot(s)", level.freezeBots, ::freezeBots);
                self addOpt("Teleport Bot(s) To Crosshair", ::tpBot);
                self addToggle("Set Spawn Point", level.customBotSpawn , ::spawnPointBots);
                self addOpt("Kill Bot(s)", ::killBots);
                self addOpt("Kick Bot(s)", ::kickBots);
            }
            
            
        }

        case "botMain":
        {
            self addMenu("botMain", "Bot Menu"); 
            self addToggle("God Mode", level.godModeBot , ::godModeBot);
            self addSliderValue("Change Speed" , 1 , 0 , 20 , 1 , ::speedBot);
        }
        
         case "aimbotMenu" :
        {
            self addMenu("aimbotMenu" , "Aimbot Menu");
            self addSliderString("Aimbot", "OFF;j_head;j_neck;j_spineupper;j_spinelower;j_hip_le;j_hip_ri;j_shoulder_le;j_shoulder_ri;j_elbow_le;j_elbow_ri;j_wrist_le;j_wrist_ri;j_knee_le;j_knee_ri;j_ankle_le;j_ankle_ri ",  "^1OFF^7;^7Head;Neck;Spine Upper;Spine Lower;Left Hip;Right Hip;Left Shoulder;Right Shoulder;Left Elbow;Right Elbow;Left Wrist;Right Wrist;Left Knee;Right Knee;Left Ankle;Right Ankle", ::setAutoAimForPlayers);
            self addToggle("Unfair Aimbot"  , self.autoAimbotUnfairPlayers ,  ::unfairAimbot);
            //self addSliderString("Grenades Aimbot", "void;frag_grenade_mp;semtex_mp;throwingknife_mp;flare_mp;claymore_mp;c4_mp;flash_grenade_mp;concussion_grenade_mp;smoke_grenade_mp", "^1OFF^7;Frag;Semtex;Throwing Knife;Tactical Insertion;Claymore;C4;Flash Grenade;Stun Grenade;Smoke Grenade", ::setgrenadeAimbot);
            self addToggle("Anti Shield" , self.antiShield , ::antiShield);
            self addToggle("Wallbang Everything" , self.wallBangEverything , ::wallBangInit);
            self addOpt("Trickshot Menu", ::newMenu , "tsMenu");
        }

        case "tsMenu":
        {
            self addMenu("tsMenu" , "Trickshot Menu");
            self addToggle("Can Swap"  , self.titanicMode , ::titanicMode , self);
            self addToggle("Save And Load"  , self.saveAndLoad , ::saveAndLoad , self);
            self addOpt("Trickshot Class" , ::trickshotClass , self);
            self addSliderString("Slider" , "1;2" , "Spawn;Delete", ::SlideInit , self);
            self addToggle("Distance Player Killed" , self.setDistanceMeters, ::setDistance);
            self addToggle("360 Prone" , self.set360Prone, ::set360Prone);
            self addToggle("360 Ladder" , self.set360Ladder, ::set360Ladder);
            self addToggle("Disable Death Barrier" , self.disableDeathBarrier, ::disableDeathBarrier);
            if(getDvar("g_gametype") == "war")//tdm 
            {
                self addOpt("Last Kill TDM" , ::LastKill);
            }
            else if(getDvar("g_gametype") == "dm")
            {
                self addOpt("Last Kill FFA" , ::LastKill);
            }
        }


        case "weaponsMenu":
        {
            self addMenu("weaponsMenu", "Weapons Menu");
            self addOpt("Give Weapons" , ::newMenu , "giveWeapons");
            self addOpt("Weapons Positions" , ::newMenu, "weaponsPositions");
            //self addOpt("Weapons Models" , ::newMenu, "weaponsModels");
            self addOpt("Camo Menu" , ::newMenu, "camoMenu");
            self addOpt("Attachments Menu" , ::newMenu, "attachmentsMenu");
            self addOpt("Bullets Menu" , ::newMenu , "bulletsMenu");
            self addOpt("Modded Weapons" , ::newMenu , "moddedWeapons");
            self addOpt("Give Random Weapon" , ::randomWeapon , self);
            self addOpt("Drop Current Weapon", ::dropWeapon , self);
            self addToggle("Disable Weapons", self.disableWeapons , ::disableWeapons , self);
        }

        case "giveWeapons":
        {
            self addMenu("giveWeapons"  , "Give Weapons");
            self addSliderString("Give SubMachine Guns", "mp5k_mp;ump45_mp;kriss_mp;p90_mp;uzi_mp", "MP5K;UMP45;Vector;P90;Mini-Uzi", ::GreedIsland_GiveWeapon, self, "smg");
            self addSliderString("Give Assaults Rifles", "m4_mp;famas_mp;scar_mp;tavor_mp;fal_mp;m16_mp;masada_mp;fn2000_mp;ak47_mp", "M4A1;FAMAS;SCAR-H;TAR-21;FAL;M16A4;ACR;F2000;AK-47" , ::GreedIsland_GiveWeapon, self, "ar");
            self addSliderString("Give ShotGuns", "spas12_mp;aa12_mp;striker_mp;ranger_mp;m1014_mp;model1887_mp", "SPAS-12;AA-12;Striker;Ranger;M1014;Model 1887", ::GreedIsland_GiveWeapon, self,  "shotgun");
            self addSliderString("Give Light Machines", "sa80_mp;rpd_mp;mg4_mp;aug_mp;m240_mp", "L86 LSW;RPD;MG4;AUG HBAR;M240" , ::GreedIsland_GiveWeapon, self, "lmg");
            self addSliderString("Give Snipers Rifles", "cheytac_mp;barrett_mp;wa2000_mp;m21_mp", "Intervention;Barrett.50cal;WA2000;M21 EBR" , ::GreedIsland_GiveWeapon, self, "sniper");
            self addSliderString("Give Handguns", "usp_mp;coltanaconda_mp;beretta_mp;deserteagle_mp;", "USP.45;.44 Magnum;M9;Desert Eagle" , ::GreedIsland_GiveWeapon, self, "pistol");
            self addSliderString("Give Machine Pistols", "pp2000_mp;glock_mp;beretta393_mp;tmp_mp;", "PP2000;G18;M93 RAffica;TMP" , ::GreedIsland_GiveWeapon, self, "mach_pistol");
            self addSliderString("Give Launchers", "at4_mp;m79_mp;stinger_mp;javelin_mp;rpg_mp", "AT4-HS;Thumper x 2;Stinger;Javelin;RPG" , ::GreedIsland_GiveWeapon, self, "launcher");
            self addSliderString("Give Specials/Others", "riotshield_mp;deserteaglegold_mp;knife_mp", "Shield;Gold Desert Eagle;Knife" , ::GreedIsland_GiveWeapon, self, "special");
            self addSliderString("Give Equipements", "frag_grenade_mp;semtex_mp;throwingknife_mp;flare_mp;onemanarmy_mp;claymore_mp;c4_mp", "Frag;Semtex;Throwing Knife;Tactical Insertion;Blast Shield;Claymore;C4" , ::GreedIsland_GiveGrenade, self,  "lethal");
            self addSliderString("Give Special Grenade", "flash_grenade_mp;concussion_grenade_mp;smoke_grenade_mp", "Flash Grenade;Stun Grenade;Smoke Grenade" , ::GreedIsland_GiveGrenade, self, "tactical");

        }

        case "weaponsPositions":
        {
            self addMenu("weaponsPositions"  , "Weapons Positions");
            self addSliderValue("Change X Axe", 0, -100, 200, 10 , ::setChangeXAxe);
            self addSliderValue("Change Y Axe", 0, -100, 200, 10 , ::setChangeYAxe);
            self addSliderValue("Change Z Axe", 0, -100, 200, 10 , ::setChangeZAxe);
            self addOpt("Default" , ::setDefaultPos);
        }

        case "weaponsModels":
        {
            self addMenu("weaponsModels"  , "Weapons Models");
            self addSliderString("Change Weapon Model", "void;me_metal_rust_big;me_metal_rust_03;me_metal_rust_02;com_tv1", "^1Default;^7Peacekeeper;Camera;MP7 Mag;PDW Mag;HK416 Mag;XM8;AN-94;HK416;SIG556;SA58;Type95", ::changeWeaponModel);
            self addSliderString("Change Weapon Models", level.weaponModels2, "^1Default;^7X95L;Type95 LMG;LSAT;MK48;HAMR;Minigun;XPR-50;DSR50;SVU-AS;Ballista", ::changeWeaponModel);
            self addSliderString("Change Weapon Models", level.weaponModels3, "^1Default;^7FNP-45;Five-Seven;Executioner;B23R;Saiga;870MCS;SRM1216;KSG", ::changeWeaponModel);
            self addSliderString("Change Weapon Models", level.weaponModels4, "^1Default;^7Knife;SMAW;SMAW Missile;RPG Mag;RPG-7;M32;FHJ-18;FHJ-18 Stow;AT4", ::changeWeaponModel);
            self addSliderString("Change Weapon Models", level.weaponModels5, "^1Default;^7Shield Pickup;Shield Stow;Shield Carry;Shield Carry Detect;Ballistic Knife;Crossbow;Crossbow Stow;Bolt Explosive;Bolt", ::changeWeaponModel);
            self addSliderString("Change Weapon Models", level.weaponModels6, "^1Default;^7M203 Grenade;Hatchet;UAV Radio;Tablet;Sentry Gun Detect;S5 Rocket;Grenade Supply;Hunter Killer Drone;Hunter Killer Viewmodel", ::changeWeaponModel);
            self addSliderString("Change Weapon Models", level.weaponModels7, "^1Default;^7Frag Grenade;Semtex;Claymore;Claymore Stow;C4;C4 Stow;Motion Sensor Detect;Trophy System Detect;Bouncing Betty;Bouncing Betty Detect", ::changeWeaponModel);
            self addSliderString("Change Weapon Models", level.weaponModels8, "^1Default;^7Tac Insert;Tac Insert Detect;Smoke Grenade;EMP Grenade;Neutral Flag;Bomb Briefcase;Drone Tank;Drone Tank Alt;Drone Missile;Scavenger Pack", ::changeWeaponModel);
            self addSliderString("Change Weapon Models", level.weaponModels9, "^1Default;^7Hellfire Missile;Attack Heli;VTOL;VTOL Alt;Overwatch Light;Overwatch Dark;Sidewinder Missile", ::changeWeaponModel);
        }

        case "camoMenu":
        {
            
            self addMenu("camoMenu"  , "Camo Menu");
            self addToggle("Disco Camo", self.discoCamo , ::discoCamo , self);
            self addSliderString("Change Camo", "0;1;2;3;4;5;6;7;8", "^1None;^7Woodland;Desert;Artic;Digital;Red Urban;Red Tiger;Blue Tiger;Orange Fall" , ::changeCamo);
            
            if(self isHost())
            {
                self addOpt("COD Camos" , ::newMenu , "codCamos");
                self addOpt("----------------------------------");
                
                colorsPath = ["img/Colors/army_green.png" , "img/Colors/black.png" , "img/Colors/blue.png" , "img/Colors/brown.png" , "img/Colors/cyan.png" , "img/Colors/green.png" , "img/Colors/grey.png" , "img/Colors/orange.png" , "img/Colors/pink.png" , "img/Colors/purple.png" , "img/Colors/red.png" , "img/Colors/turquoise.png" , "img/Colors/white.png" , "img/Colors/yellow.png"];
                colorsName = ["Green Army" ,"Black" , "Blue" , "Brown" , "Cyan" , "Green" , "Grey" , "Orange" , "Pink" ," Purple" ,"Red" , "Turquoise" , "White" , "Yellow"];
            
                self addSliderString("Colors Camos", arrayJoin(colorsPath, ";"), arrayJoin(colorsName, ";"), ::changeCustomCamo);
                self addtoggle("Rainbow Camo", self.rainbowCustomCamo, ::rainbowCustomCamo);
                self addOpt("----------------------------------");
                
                brandPath = ["img/camos/brand/camo_gucci.png" , "img/camos/brand/camo_lv.png" , "img/camos/brand/camo_nike.jpg" , "img/camos/brand/camo_supreme.png"];
                brandName = ["Gucci" , "Louis Vuitton" , "Nike" ,"Supreme"];

                self addSliderString("Brand Camos", arrayJoin(brandPath, ";"), arrayJoin(brandName, ";"), ::changeCustomCamo);

                othersPath = ["img/camos/others/camo_milenium.png" , "img/camos/others/camo_silver.png"];
                othersName = ["Millennium" , "Silver"];

                self addSliderString("Other Camos", arrayJoin(othersPath, ";"), arrayJoin(othersName, ";"), ::changeCustomCamo);
            }
           

        }

        case "codCamos":
        {
            self addMenu("codCamos"  , "COD Camos");
            self addOpt("BO2 Camos" , ::newMenu , "bo2Camos");
            self addOpt("BO3 Camos" , ::newMenu , "bo3Camos");
        }

        case "bo2Camos":
        {
            self addMenu("bo2Camos"  , "BO2 Camos");
            origPaths = ["img/camos/_BO2/camo_artofwar.png", "img/camos/_BO2/camo_atacs.png", "img/camos/_BO2/camo_bloodshot.png", "img/camos/_BO2/camo_blossom.png", "img/camos/_BO2/camo_choco.png", "img/camos/_BO2/camo_devgru.png", "img/camos/_BO2/camo_erdl.png", "img/camos/_BO2/camo_ghostex_delta6.png", "img/camos/_BO2/camo_kryptek_typhon.png", "img/camos/_BO2/camo_ronin.png", "img/camos/_BO2/camo_siberia.png", "img/camos/_BO2/camo_skulls.png", "img/camos/_BO2/camo_tiger_blue.png", "img/camos/_BO2/camo_carbon_fiber.png" , "img/camos/_BO2/camo_gold.png" , "img/camos/_BO2/camo_diamond.png"];
            origNames = ["Art of War", "Atacs", "Bloodshot", "Blossom", "Choco", "Devgru", "ERDL", "Ghostex Delta6", "Kryptek Typhon", "Ronin", "Siberia", "Skulls", "Tiger Blue", "Carbon Fiber" , "Gold" , "Diamond"];

            self addSliderString("BO2 Camo Original", arrayJoin(origPaths, ";"), arrayJoin(origNames, ";"), ::changeCustomCamo);

            
            dlcPaths = ["img/camos/_BO2/DLC/camo_aqua.png", "img/camos/_BO2/DLC/camo_bacon.png", "img/camos/_BO2/DLC/camo_benjamins.png", "img/camos/_BO2/DLC/camo_breach.png", "img/camos/_BO2/DLC/camo_cedigital.png", "img/camos/_BO2/DLC/camo_coyote.png", "img/camos/_BO2/DLC/camo_cyborg.png", "img/camos/_BO2/DLC/camo_diademuertos.png", "img/camos/_BO2/DLC/camo_elite.png", "img/camos/_BO2/DLC/camo_ghost.png", "img/camos/_BO2/DLC/camo_glam.png", "img/camos/_BO2/DLC/camo_graffiti.png", "img/camos/_BO2/DLC/camo_junglewarfare.png", "img/camos/_BO2/DLC/camo_kawaii.png", "img/camos/_BO2/DLC/camo_packapunch.png", "img/camos/_BO2/DLC/camo_paladin.png", "img/camos/_BO2/DLC/camo_partyrock.png", "img/camos/_BO2/DLC/camo_rogue.png", "img/camos/_BO2/DLC/camo_viper.png", "img/camos/_BO2/DLC/camo_zombies.png"];
            dlcNames = ["Aqua", "Bacon", "Benjamins", "Breach", "CE Digital", "Coyote", "Cyborg", "Dia De Muertos", "Elite", "Ghost", "Camo Glam", "Graffiti", "Jungle Warfare", "Kawaii", "Pack a Punch", "Paladin", "Party Rock", "Rogue", "Viper", "Zombies"];

            self addSliderString("BO2 DLC Camo", arrayJoin(dlcPaths, ";"), arrayJoin(dlcNames, ";"), ::changeCustomCamo);

            
            dlc2Paths = ["img/camos/_BO2/DLC2/camo_beast.png", "img/camos/_BO2/DLC2/camo_comics.png", "img/camos/_BO2/DLC2/camo_deadmanshand.png", "img/camos/_BO2/DLC2/camo_dragon.png", "img/camos/_BO2/DLC2/camo_octane.png", "img/camos/_BO2/DLC2/camo_ukpunk.png", "img/camos/_BO2/DLC2/camo_weaponized115.png"];
            dlc2Names = ["Beast", "Comics", "Deadmanshand", "Dragon", "Octane", "UK Punk", "Weaponized 115"];

            self addSliderString("BO2 DLC 2 Camo", arrayJoin(dlc2Paths, ";"), arrayJoin(dlc2Names, ";"), ::changeCustomCamo);

        }

        case "bo3Camos":
        {
            self addMenu("bo3Camos"  , "BO3 Camos");
            bo3CamoBMPaths = ["img/camos/_BO3/bm/camo_contrast.png", "img/camos/_BO3/bm/camo_dust.png", "img/camos/_BO3/bm/camo_energeon.png","img/camos/_BO3/bm/camo_etching.png", "img/camos/_BO3/bm/camo_field.png", "img/camos/_BO3/bm/camo_firebrand.png","img/camos/_BO3/bm/camo_gem.png", "img/camos/_BO3/bm/camo_halcyon.png", "img/camos/_BO3/bm/camo_hallucination.png","img/camos/_BO3/bm/camo_haptic.png", "img/camos/_BO3/bm/camo_heat.png", "img/camos/_BO3/bm/camo_ice.png","img/camos/_BO3/bm/camo_inferno.png", "img/camos/_BO3/bm/camo_infrared.png", "img/camos/_BO3/bm/camo_intensity.png","img/camos/_BO3/bm/camo_jungle_party.png", "img/camos/_BO3/bm/camo_light.png", "img/camos/_BO3/bm/camo_monochrome.png","img/camos/_BO3/bm/camo_pixel.png", "img/camos/_BO3/bm/camo_prestige.png", "img/camos/_BO3/bm/camo_ritual.png","img/camos/_BO3/bm/camo_royal.png", "img/camos/_BO3/bm/camo_spark.png", "img/camos/_BO3/bm/camo_stealth.png","img/camos/_BO3/bm/camo_storm.png", "img/camos/_BO3/bm/camo_sunshine.png", "img/camos/_BO3/bm/camo_swindler.png","img/camos/_BO3/bm/camo_timber.png", "img/camos/_BO3/bm/camo_transgression.png", "img/camos/_BO3/bm/camo_verde.png","img/camos/_BO3/bm/camo_violet.png", "img/camos/_BO3/bm/camo_wartorn.png"];

            bo3CamoBMNames = "Contrast;Dust;Energeon;Etching;Field;Firebrand;Gem;Halcyon;Hallucination;Haptic;Heat;Ice;Inferno;Infrared;Intensity;Jungle Party;Light;Monochrome;Pixel;Prestige;Ritual;Royal;Spark;Stealth;Storm;Sunshine;Swindler;Timber;Transgression;Verde;Violet;Wartorn";

            self addSliderString("BO3 BM Camo", arrayJoin(bo3CamoBMPaths, ";"), bo3CamoBMNames, ::changeCustomCamo);

            bo3CamoCampaignPaths = ["img/camos/_BO3/campaign/camo_artic.png", "img/camos/_BO3/campaign/camo_huntsman.png","img/camos/_BO3/campaign/camo_jungle.png", "img/camos/_BO3/campaign/camo_mindfulness.png","img/camos/_BO3/campaign/camo_urban.png", "img/camos/_BO3/campaign/camo_woodlums.png"];

            bo3CamoCampaignNames = "Artic;Huntsman;Jungle;Mindfulness;Urban;Woodlums";

            self addSliderString("B03 Campaign Camo", arrayJoin(bo3CamoCampaignPaths, ";"), bo3CamoCampaignNames, ::changeCustomCamo);

            bo3CamoDLCPaths1 = ["img/camos/_BO3/dlc/camo_amethyst.png", "img/camos/_BO3/dlc/camo_arcane_fire.png", "img/camos/_BO3/dlc/camo_atomic_fire.png", "img/camos/_BO3/dlc/camo_bloody_valentine.png", "img/camos/_BO3/dlc/camo_blue_gorod_krovi.png", "img/camos/_BO3/dlc/camo_bo3.png", "img/camos/_BO3/dlc/camo_cherry_fizz.png", "img/camos/_BO3/dlc/camo_cloud9.png", "img/camos/_BO3/dlc/camo_code.png", "img/camos/_BO3/dlc/camo_cosmic.png", "img/camos/_BO3/dlc/camo_cwl_champions.png", "img/camos/_BO3/dlc/camo_dragon_fire.png", "img/camos/_BO3/dlc/camo_elevate.png", "img/camos/_BO3/dlc/camo_emerald.png", "img/camos/_BO3/dlc/camo_empire.png", "img/camos/_BO3/dlc/camo_epsilon_esports.png", "img/camos/_BO3/dlc/camo_excellence.png", "img/camos/_BO3/dlc/camo_faze_clan.png", "img/camos/_BO3/dlc/camo_garnet.png", "img/camos/_BO3/dlc/camo_hive.png", "img/camos/_BO3/dlc/camo_into_the_void.png", "img/camos/_BO3/dlc/camo_luck_of_the_Irish.png", "img/camos/_BO3/dlc/camo_millenium.png"];
            
            bo3CamoDLCNames1 = "Amethyst;Arcane Fire;Atomic Fire;Bloody Valentine;Blue Gorod;BO3;Cherry Fizz;Cloud9;Code;Cosmic;CWL;Dragon Fire;Elevate;Emerald;Empire;Epsilon;Excellence;Faze Clan;Garnet;Hive;Into The Void;Luck Of The Irish;Millenium";

            self addSliderString("BO3 DLC Camo", arrayJoin(bo3CamoDLCPaths1, ";"), bo3CamoDLCNames1, ::changeCustomCamo);

            bo3CamoDLCPaths2 = ["img/camos/_BO3/dlc/camo_mindfreak.png", "img/camos/_BO3/dlc/camo_nuk3town.png", "img/camos/_BO3/dlc/camo_nv.png", "img/camos/_BO3/dlc/camo_optic_gaming.png", "img/camos/_BO3/dlc/camo_orbitgg.png", "img/camos/_BO3/dlc/camo_overgrowth.png", "img/camos/_BO3/dlc/camo_rise_nation.png", "img/camos/_BO3/dlc/camo_sapphire.png", "img/camos/_BO3/dlc/camo_splyce.png", "img/camos/_BO3/dlc/camo_supremacy.png", "img/camos/_BO3/dlc/camo_tainted_minds.png", "img/camos/_BO3/dlc/camo_take_out.png", "img/camos/_BO3/dlc/camo_team_envy.png", "img/camos/_BO3/dlc/camo_team_infused.png", "img/camos/_BO3/dlc/camo_team_ldlc.png", "img/camos/_BO3/dlc/camo_topaz.png", "img/camos/_BO3/dlc/camo_true_vet.png", "img/camos/_BO3/dlc/camo_underworld.png", "img/camos/_BO3/dlc/camo_watermelon.png", "img/camos/_BO3/dlc/camo_weaponized115.png", "img/camos/_BO3/dlc/camo_xp.png"];
            
            bo3CamoDLCNames2 = "Mindfreak;Nuk3Town;NV;Optic Gaming;OrbitGG;Overgrowth;Rise Nation;Sapphire;Splyce;Supremacy;Tainted Minds;Take Out;Team Envy;Team Infused;Team LDLC;Topaz;True Vet;Underworld;Watermelon;Weaponized 115;XP";

            self addSliderString("BO3 DLC Camo 2", arrayJoin(bo3CamoDLCPaths2, ";"), bo3CamoDLCNames2, ::changeCustomCamo);

            bo3CamoMPPaths = ["img/camos/_BO3/mp/camo_6speed.png", "img/camos/_BO3/mp/camo_ardent.png", "img/camos/_BO3/mp/camo_ash.png","img/camos/_BO3/mp/camo_battle.png", "img/camos/_BO3/mp/camo_bliss.png", "img/camos/_BO3/mp/camo_burnt.png","img/camos/_BO3/mp/camo_chameleon.png", "img/camos/_BO3/mp/camo_dante.png", "img/camos/_BO3/mp/camo_dark_matter.png","img/camos/_BO3/mp/camo_diamond.png", "img/camos/_BO3/mp/camo_flectarn.png", "img/camos/_BO3/mp/camo_gold.png","img/camos/_BO3/mp/camo_heat_stroke.png", "img/camos/_BO3/mp/camo_integer.png", "img/camos/_BO3/mp/camo_jungle_tech.png","img/camos/_BO3/mp/camo_policia.png", "img/camos/_BO3/mp/camo_snow_job.png"];

            bo3CamoMPNames = "6 Speed;Ardent;Ash;Battle;Bliss;Burnt;Chameleon;Dante;Dark Matter;Diamond;Flectarn;Gold;Heat Stroke;Integer;Jungle Tech;Policia;Snow Job";

            self addSliderString("BO3 MP Camo", arrayJoin(bo3CamoMPPaths, ";"), bo3CamoMPNames, ::changeCustomCamo);

            bo3Camo_zmPaths = ["img/camos/_BO3/_zm/camo_contagious.png", "img/camos/_BO3/_zm/camo_fear.png", "img/camos/_BO3/_zm/camo_lucid.png","img/camos/_BO3/_zm/camo_red_hex.png", "img/camos/_BO3/_zm/camo_wmd.png"];

            bo3Camo_zmNames = "Contagious;Fear;Lucid;Red Hex;WMD";

            self addSliderString("BO3 ZM Camo", arrayJoin(bo3Camo_zmPaths, ";"), bo3Camo_zmNames, ::changeCustomCamo);
        }

        case "attachmentsMenu":
        {
            self addMenu("attachmentsMenu"  , "Attachments Menu");
            self addSliderString("Give Attachment", "acog;grip;gl;tactical;reflex;silencer;akimbo;thermal;shotgun;heartbeat;fmj;rof;dtap;xmags;mags;eotech", "ACOG;Grip;Grenade Launcher;Tactical Knife;Reflex;Silencer;Akimbo;Thermal;Shotgun;Heartbeat;FMJ;Rapid Fire;Double Tap;Extended Mags;Mags;EOTech", ::giveAttachments);
            self addOpt("Remove All Attachments" , ::setDefaultWeap); 
        }

        case "bulletsMenu":
        {
            self addMenu("bulletsMenu"  , "Bullets Menu");
            self addToggle("Enable Fx(s) Bullets" , self.moddedBulletsEnabled , ::toggle_modded_bullets);
            self addSliderString("Change Fx Bullets", "1;2;3;4;5;6;7;8;9;10;11;12", "Light;Green Smoke;Red Smoke;Yellow Smoke;Water;Explosive;Aerial Explosion;Snow Hit;Jet;EMP;Cash;Metal Hit" , ::changeBullets); 
            self addOpt("----------------------------------");
            self addToggle("Explosive Bullets", self.explosiveBullet , ::explosiveBullet);
            self addSliderValue("Exp Range", 0, 0, 10000, 1000, ::explosiveBulletRange);
            self addSliderValue("Exp Damage", 0, 0, 10000, 1000, ::explosiveBulletDamage);            
        }

        case "moddedWeapons":
        {
            self addMenu("moddedWeapons"  , "Modded Weapons");
            self addSliderString("Buggy Weapons", "defaultweapon_mp;;briefcase_bomb_mp" , "Default Weapon;Case Bomb" , ::giveModdedWeapons);
            self addToggle("Portal Gun" , self.portalGun , ::portalGun);
            self addToggle("Ricochet Gun" , self.ricochetGun , ::ricochetGun);
            self addToggle("One Shot" , self.oneShotPlayer , ::oneShot);
        }

        case "gameMenu":
        {
            self addMenu("gameMenu", "Game Menu");
            self addOpt("Messages Menu" , ::newMenu , "messagesMenu");
            if(self IsHost())
            {
                self addOpt("Protections Menu" , ::newMenu , "protectionsMenu");
            }
            self addOpt("Maps Menu" , ::newMenu , "mapsMenu");
            self addOpt("Gamemode Menu" , ::newMenu , "gamemodeMenu");
            self addSliderString("Hear" , "1;2;3;4;5" , "^1OFF;^7Everyone;Dead Chat With Team;Dead Hear Team Living;Dead Hear All Living", ::toggleHear);
            self addOpt("Restart" , ::doRestart);
            self addOpt("Pause" , ::pauseGame);
            self addOpt("End Game", ::endGame);
            self addToggle("Long Time KillFeed" , level.unlimitedKillfeed , ::toggleUnlimitedKillfeed);
            //self addToggle("Force Host" , self.forceHost , ::toggleForceHost);
            if(getDvar("g_gametype") == "war" || "dm" || "dom" || "conf" || "koth" || "hq")
            {
                self addToggle("Unlimited Score" , level.unlimitedScore , ::toggleUnlimitedScore);
            }
            if(getDvar("g_gametype") == "sd")
            {
                self addSliderString("Bomb","planted;defused","Plant;Defuse",::setBombStatus);
                self addSliderString("Bomb Action","drop;pickup","Drop;Pickup", ::setBombAction);
               
            }
            self addToggle("Unlimited Time" , level.infiniteTime , ::infiniteTime);
            self addToggle("Super Jump" , level.superJumpGame , ::superJumpGame);
            self addSliderValue("Change Score", 100, 0, 999999, 100, ::changePointPerKill);
            self addSliderValue("Change Timescale", 1, 0, 80, .10, ::GreedIsland_ChangeTimeScale);
            self addSliderValue("Change Speed",  1 , 0 , 20 , 1, ::speedAllClients);
            self addSliderValue("Change Melee Range", 1, 0, 10000, 100, ::GreedIsland_MeleeRange);
            self addSliderValue("Change Knockback", 1000, 0, 10000, 100, ::GreedIsland_ChangeKnockBack);
            self addSliderValue("Change Gravity", 800, 0, 5000, 100, ::GreedIsland_ChangeGravity);
        }

        case "messagesMenu":
        {
            self addMenu("messagesMenu"  , "Messages Menu");
            self addOpt("Custom Message" , ::newMenu , "customMessage" );
            self addOpt("Spam Message" , ::newMenu , "spamMessage" );
            self addOpt("Do Heart" , ::newMenu , "doHeart" );
            self addSliderString("Messages Type", "1;2;3;4;5;6", "Left;Center;Left And Center;Notify;Say;Say Team", ::toggleMessages , self);
            self addOpt("Hello" , ::sendMessage , "^2Hello" , self);
            self addOpt("Host" , ::sendMessage , level.hostname +" ^1is your host!" , self);
            self addOpt("Yes" , ::sendMessage , "^2Yes" , self);
            self addOpt("No" , ::sendMessage , "^1No" , self);
            self addOpt("Idk" , ::sendMessage , "^3Idk" , self);
            self addOpt("Fuck You" , ::sendMessage , "^4Fuck You!" , self);
            self addOpt("HvH" , ::sendMessage , "^5HvH in 2025 is wild!" , self);
            self addOpt("Youtube" , ::sendMessage ," ^1Youtube.com/^8"+level.hostname , self);
            self addOpt("Lmao" , ::sendMessage , "^6Lmao" , self);
            self addOpt("MW2" , ::sendMessage , "^9They fucked mw2..." , self);
            self addOpt("Creator" , ::sendMessage , "^2Created By Littof" , self);
        }

        case "customMessage":
        {
            self addMenu("customMessage"  , "Custom Message");
            self addSliderString("Messages Type", "1;2;3;4;5;6", "Left;Center;Left And Center;Notify;Say;Say Team", ::toggleMessagesCustom);
            self addOpt("Custom Message" , ::sendCustomMessage);
        }

        case "spamMessage":
        {
            self addMenu("spamMessage"  , "Spam Message");
            self addSliderString("Messages Type", "1;2;3;4;5;6", "Left;Center;Left And Center;Notify;Say;Say Team", ::toggleMessagesSpam);
            self addToggle("Spam Message" , self.spamMessage , ::spamMessage);
        }

        case "doHeart":
        {
            self addMenu("doHeart"  , "Do Heart");
            self addToggle("Enable" , self.DoHeart , ::Doheart);
            DoheartTextPreset2 = self.name+";"+"Exodia"+";"+"InfinityLoader"+";"+"Littof"+";"+"MW2 IS DEAD";
            self addSliderString("Preset Do Heart",  DoheartTextPreset2, self.name+";Exodia;InfinityLoader;Dev Name;MW2 IS DEAD", ::DoheartTextPass);
            self addSliderString("Choose Text Effect", "1;2;3;4;5;6;7;8;9", "Type Writer;Pulse FX;Rain;CYCL;KRDR;Moving;Pulsing;Wave;Glitch", ::SetDoheartStyle);
            self addSliderValue("Change Size Do Heart", 1.5, 0, 5, 0.5, ::changeSize);
            self addOpt("Custom Do Heart" , ::do_keyboardDoHeart);
            self addOpt("Do Heart Position" , ::newMenu , "doHeartPosition");
        }

        case "doHeartPosition":
        {
            self addMenu("doHeartPosition"  , "Do Heart Position");
            self addSliderString("Preset Do Heart Position", "1;2;3;4;5", "Top;Down;Center;Right;Left", ::setHeartPresetPos);
            self addOpt("--------------------------Custom--------------------------");
            self addSliderValue("Change X Axe", 50, -500, 500, 10, ::changeXPos);
            self addSliderValue("Change Y Axe", 50, -500, 500, 10, ::changeYPos);
        }

        case "protectionsMenu":
        {
            self addMenu("protectionsMenu"  , "Protections Menu");
            self addToggle("Anti End Game" , self.antiEndGame , ::toggleAntiEndGame);
            self addToggle("Anti Join" , self.antiJoin , ::toggleAntiJoin);
            self addToggle("Change Gamertag Detector" , self.changeGT , ::toggleChangeGT);
            self addToggle("Anti Crash Models" , self.antiObjectCrash , ::securitymodel);
            self addToggle("Anti Freeze Name" , self.antiFreezeNames , ::antiFreezeNames);
            self addToggle("Anti SpinBot (Beta)" , self.antiSpinBot , ::setAntiSpinbot);
            self addToggle("Anti Lag Name" , self.antiLagName , ::antiLagName);
        }

        case "mapsMenu":
        {
            self addMenu("mapsMenu"  , "Maps Menu");
            level.mapsOriginal = "mp_afghan;mp_derail;mp_estate;mp_favela;mp_highrise;mp_invasion;mp_checkpoint;mp_quarry;mp_rundown;mp_rust;mp_boneyard;mp_nightshift;mp_subbase;mp_terminal;mp_underpass;mp_brecourt";

            level.mapsStimulus = "mp_complex;mp_crash;mp_overgrown;mp_compact;mp_storm";

            level.mapsResurgence = "mp_abandon;mp_fuel2;mp_trailerpark;mp_strike;mp_vacant";

            self addSliderString("Change Maps", level.mapsOriginal, "Afghan;Derail;Estate;Favela;Highrise;Invasion;Karachi;Quarry;Rundown;Rust;Scrapyard;Skidrow;Sub Base;Terminal;Underpass;Wasteland", ::toggleChangeMap);
            self addSliderString("DLC Maps", level.mapsStimulus, "Bailout;Crash;Overgrown;Salvage;Storm", ::toggleChangeMap);
            self addSliderString("DLC 2 Maps", level.mapsResurgence, "Carnival;Fuel;Trailer Park;Strike;Vacant", ::toggleChangeMap);
        }

        case "gamemodeMenu":
        {
            self addMenu("gamemodeMenu"  , "Gamemode Menu");
            self addSliderString("Change Gamemode" , "war;dm;dom;dd;koth;ctf;sd;oneflag;sab;arena;gtnw" , "Team DeathMatch;Free-For-All;Domination;Demolition;HeadQuarters;Capture The Flag;Search & Destroy;One Flag CTF;Sabotage;Arena;Global Thermo-Nuclear War", ::toggleGameMode);
        }

        case "accountMenu":
         {
            self addMenu("accountMenu"  , "Account Menu");
            self addOpt("Stats Managements" , ::newMenu , "statsManagements");
            //self addOpt("Clan Tag Editor" , ::newMenu , "clanTagEditor");

            if(self isHost())
            {
                self addSliderString("Change Class Name" , "None;#Exodia;yourName",  "^1None;^7Menu Name;Your Name", ::changeClassNames , self);
                self addOpt("Rename (Not Sticky)", ::changeName);
                self addOpt("Unlock All" , ::do_all_challenges , 1 );
                self addOpt("Reset Unlock All" , ::do_all_challenges , 0 );
                self addOpt("Level 70", ::Level70 , self);
                self addOpt("Derank", ::deDrank);
                
            }
            else
            {
                self addSliderString("Change Class Name" , "None;#Exodia;yourName",  "^1None;^7Menu Name;Your Name", ::changeClassNames , self);
                self addOpt("Unlock All" , ::do_all_challenges , 1 );
                self addOpt("Reset Unlock All" , ::do_all_challenges , 0 );
                self addOpt("Level 70", ::Level70, self);
            }
          
            
        }

        case "clanTagEditor":
        {
            self addMenu("clanTagEditor" , "Clan Tag Editor");
            self addSliderString("Preset", "None;^;3arc;HACK;NO U;EXO;HvH;1v1;[];-_-;@_@;<3;:-);:-(;^_^;IL", "^1None;^7Freeze;3arc;HACK;NO U;Exodia;HvH;1v1;Co-Host Exploit;-_-;@_@;<3;:-);:-(;^_^;Infinity Loader", ::presetClanTag , self);
            self addSliderString("Colored Name", "^1;^2;^3;^4;^5;^6;^7;^8;^9;^0", "Red;Green;Yellow;Blue;Cyan;Purple;White;Pink;Gray;Black", ::colorClanTag , self);
        }

        case "statsManagements":
        {
            self addMenu("statsManagements" , "Stats Managements");
            if(self isHost())
            {
                self addSliderValue("Set Prestige", 0, 0, 100, 1, ::setPrestige);
                self addSliderValue("Set Level", 1, 1, 70, 1, ::setRankData, "experience"); 
            }
            self addSliderValue("Set Kills", 0, 0, 100000, 2500, ::_setPlayerData, "kills");
            self addSliderValue("Set Deaths", 0, 0, 100000, 2500, ::_setPlayerData, "deaths");
            self addSliderValue("Set Wins", 0, 0, 100000, 2500, ::_setPlayerData, "wins");
            self addSliderValue("Set Losses", 0, 0, 100000, 2500, ::_setPlayerData, "losses");
            self addSliderValue("Set Games Played", 0, 0, 2000, 100, ::_setPlayerData, "gamesPlayed");
            self addSliderValue("Set Hits", 0, 0, 100000, 2500, ::_setPlayerData, "hits");
            self addSliderValue("Set Misses", 0, 0, 100000, 2500, ::_setPlayerData, "misses");
            self addSliderValue("Set Ties", 0, 0, 100000, 2500, ::_setPlayerData, "ties");
            self addSliderValue("Set Score", 0, 0, 100000, 2500, ::_setPlayerData, "score");
            self addSliderValue("Set Assists", 0, 0, 100000, 2500, ::_setPlayerData, "assists");
            self addSliderValue("Set Winstreak", 0, 0, 100000, 2500, ::_setPlayerData, "winStreak");
            self addSliderValue("Set Killstreak", 0, 0, 100000, 2500, ::_setPlayerData, "killStreak");
            self addSliderValue("Set Headshots", 0, 0, 100000, 2500, ::_setPlayerData, "headshots");
        }

        case "settingsMenu":
        {
            
            self addMenu("settingsMenu", "Main Menu");
            self addOpt("Dev Menu" , ::newMenu , "devMenu");
            self addOpt("Credits" , ::setCredits); 
            self addOpt("Notes" ,::newMenu , "notes");
            self addOpt("Change Colors" ,::newMenu , "changeColors");
            self addToggle("Enable Box", self.menuBox , ::menuBox);
            self addSliderString("Change Box", "white;circle;checkbox;loader;text","^1Default;^7Circle;Checkbox;Loader;Text",::changeBoxToggle);
            self addSliderString("Change Font", "reset;objective;default;bigfixed;smallfixed;big;small;extrabig;extrasmall","^1Reset;^7Objective;Default;Bigfixed;Smallfixed;Big;Small;ExtraBig;ExtraSmall",::changeFont);
            self addSliderValue("Test", 1, 0, 50 , 1 , ::testSlider);
            self addToggle("Test Toggle", self.toggle , ::testToggle);
            
        }

       case "changeColors":
        {
            sections = strTok("Title Background;Lines;Options Background;Title & Options;Toggle & Slider", ";");
            huds     = strTok("TITLE_OPT_BG2;SCROLL_STITLE_BG;BACKGROUND;TEXT;LINETOP1", ";");

            self addMenu("changeColors", "Change Colors");

            
            for (e = 0; e < sections.size; e++) 
            self addOpt(sections[e], ::setSelectedOptionAndOpenMenu, sections[e]); 
            
            
        }
        
        case self.selectedOption:
        {
            sections = strTok("Title Background;Lines;Options Background;Title & Options;Toggle & Slider", ";");
            huds     = strTok("TITLE_OPT_BG2;SCROLL_STITLE_BG;BACKGROUND;TEXT;LINETOP1", ";");
            for (e = 0; e < sections.size; e++) 
            {
                if (self.selectedOption == sections[e]) 
                {
                    self addMenu(self.selectedOption, sections[e]); 
                    index = huds[e];
                    preset = self.presets[index];

                    self addSliderValue("Red Slider", preset[0] * 255, 0, 255, 1, ::RGB_Edit, huds[e], "R");
                    self addSliderValue("Green Slider", preset[1] * 255, 0, 255, 1, ::RGB_Edit, huds[e], "G");
                    self addSliderValue("Blue Slider", preset[2] * 255, 0, 255, 1, ::RGB_Edit, huds[e], "B");
                    self addOpt("Reset Default Color", ::reset_default_color, huds[e]);
                    break;
                }
            }
        }
            
        case "devMenu":
        {
            self addMenu("devMenu","Dev Menu");
            self addToggle("Print Current Weapon", self.printWeap , ::printMyWeapon);
            self addToggle("Print Current Grenade", self.printGrenade , ::printMyGrenade);
            self addToggle("Print Current Map", self.printMap , ::printMapName);
            self addToggle("Print Current Gamemode", self.printGameMode , ::printGameMode);
            self addToggle("Print Current Origin", self.printOrigin , ::printOrigin);
            self addToggle("Print Models", self.printModel , ::printModelLookedAt);
            self addOpt("Print Dvar Value" , ::printCustomDvar);
        }
        
        case "notes":
        {
            self addMenu("notes", "Notes");
            self addOpt("--------------------------CHANGELOG--------------------------");
            self addOpt("+ (Added)");
            self addOpt("- (Removed)");
            self addOpt("= (Fixed)");
            self addOpt("--------------------------ADDED--------------------------");
            self addOpt("Initial Build");
            self addOpt("--------------------------REMOVED--------------------------");
        
            self addOpt("--------------------------FIXED--------------------------");
            
        }

        case "allclientsMenu":
        {
            self addMenu("allclientsMenu" , "All Clients Menu");
            self addToggle("GodMode", self.godModeAllClients , ::godModeAllClients);
            self addToggle("Unlimited Ammo", self.unlimitedAmmoAllClients , ::unlimitedAmmoAllClients);
            self addToggle("All Perks", self.allPerksAllClients , ::allPerksAllClients);
            self addToggle("Constant UAV", self.constantUAVAllClients , ::constantUAVAllClients);
            self addSliderString("Teleport To", "me;cross;random", "Me;Crosshair;Random", ::allClientsTp);
            if(level._Platform == "PC")
            {
                self addSliderString("Freeze", "none;controls", "None;Controls;Game", ::allClientsFreeze);
            }
            else
            {
                self addSliderString("Freeze", "none;controls;game", "None;Controls;Game", ::allClientsFreeze);
            }
            self addSliderString("Sanction", "kick;ban", "Kick;Ban", ::allClientsSanction);
            
          
        }

         
    }


    
    self clientOptions();   
}


clientOptions()
{
    self addMenu("clients", "Clients Menu");

    
    playersInfo = [];

    foreach (player in level.players)
    {
        playerName = player getName();
        playerIndex = player getEntityNumber();
        playersInfo[playerIndex] = player;

        self addOpt(playerName, ::newMenu, "client_" + playerIndex);
    }

    
    for (i = 0; i < 18; i++) 
    {
        if (isDefined(playersInfo[i]))
        {
            player = playersInfo[i];
            playerName = player getName();
            self addMenu("client_" + i, playerName);
            
            if (self == player) 
            {
                self addOpt("Cannot be used on yourself.");
                
            }
            else if (player.status == "Owner" && self.status != "Owner") 
            {
                self addOpt("You cannot access the owner's options.");
            }
            else if (self.status == "Co-Host" && player.status == "Host") 
            {
                self addOpt("You cannot access the host's options.");
            }
            else
            {   
                self addOpt("Give Menu", ::newMenu, "give_menu_" + i);
                self addOpt("Main Menu", ::newMenu, "main_menu_" + i);
                self addOpt("Streak Menu", ::newMenu, "streak_menu_" + i);
                self addOpt("Messages Menu", ::newMenu, "message_menu_" + i);
                self addOpt("Malicious Menu", ::newMenu, "misc_menu_" + i);
                self addOpt("Info Client", ::newMenu, "info_menu_" + i);

                self addMenu("main_menu_" + i, "Main Menu");
	            self addToggle("GodMode", player.godModePlayer, ::setGodMode, player);
                self addToggle("Unlimited Ammo", player.unlimitedAmmoPlayer, ::setUnlimitedAmmo, player);
	            self addToggle("All Perks", player.giveAllPerks, ::giveAllPerks, player);
	            self addSliderString("Invisible", "off;invisible;invisiblev2", "OFF;Invisible;Invisible V2", ::invisibleMode, player);
	            self addSliderString("Radar", "1;2;3", "OFF;UAV;Constant UAV;VSAT", ::setRadar, player);
	            self addOpt("Suicide", ::setSuicide, player);
	            self addSliderValue("Change Speed", 1, 0, 20, 1, ::setSpeed, player);
	            self addSliderValue("Change FOV", 65, 0, 120, 5, ::setFov, player);
	            self addToggle("No Clip", player.setNoClip, ::setNoClip, player);
	            self addToggle("Health Bar", player.healthBar, ::setHealthBar, player);
	            self addToggle("Change Team", player.changeTeam, ::setChangeTeam, player);
	            self addToggle("Auto Drop Shot", player.AutoDropShot, ::setAutoDropShot, player);
	            self addOpt("Change Class", ::changeClass, player);

                self addMenu("streak_menu_" + i, "Streak Menu");
	            self addSliderString("Give", "uav;counter_uav;airdrop;sentry;predator;precision_airstrike;harrier_airstrike;stealth_airstrike;airdrop_mega;helicopter_flares;helicopter_minigun;ac130;emp;nuke", "UAV;Counter UAV;Care Package;Sentry Gun;Predator Missle;Precision Airstrike;Harrier Strike;Stealth Bomber;Emergency Airdrop;Attack Helicopter;Chopper Gunner;AC130;EMP;Nuke", ::giveStreak , player);  

                self addMenu("message_menu_" + i, "Message Menu");
	            self addOpt("Say Menu", ::newMenu, "say_menu_" + i);
	            self addSliderString("Messages Type", "1;2;3;4;5;6", "Left;Center;Left And Center;Notify;Say;Say All", ::toggleMessagesPlayer , player);
	            self addOpt("Hello", ::sendMessage, "^2Hello", player);
	            self addOpt("Fuck you", ::sendMessagePlayer, "^1Fuck you!", player);
	            self addOpt("I'm Cheating", ::sendMessagePlayer, "^3I'm Cheating!", player);
	            self addOpt("I'm a Camper", ::sendMessagePlayer, "^4I'm a Camper.", player);
	            self addOpt("I'm So Bad", ::sendMessagePlayer, "^6I'm So Bad lol.", player);

                self addMenu("say_menu_" + i, "Say Menu");
	            self addOpt("Fake Host", ::sayMessage, "^7is your host", player);
	            self addOpt("STFU", ::sayMessage, "^7Shut the fuck up!", player);
	            self addOpt("Fuck You", ::sayMessage, "^7fuck you!", player);
	            self addOpt("Using Infection", ::sayMessage, "^7uses infections", player);
	            self addOpt("Leave", ::sayMessage, "^7leave or kick", player);
	            self addOpt("Stay", ::sayMessage, "^7stay", player);
	            self addOpt("Duel", ::sayMessage, "^7It's time to duel!", player);

                self addMenu("misc_menu_" + i, "Malicious Menu");
	            self addToggle("Unlimited Death", player.unlimitedDeath, ::unLimitedDeath, player);
	            self addSliderString("Blow Up", "remotemissile_projectile_mp;pavelow_minigun_mp;stealth_bomb_mp;harrier_missile_mp", "Hind Rocket;Hind Minigun;Mortar;Missile", ::blowUp, player);
                if(level._Platform == "PC")
                {
                    self addSliderString("Freeze", "None;Controls;Game", "None;Controls;Game", ::freezeMode, player);
                }
                else
                {
                   self addSliderString("Freeze", "None;Controls;Console", "None;Controls;Console", ::freezeMode, player); 
                }
	            
	            self addSliderString("Sanction", "kick;ban", "Kick;Ban", ::sanctionMode, player);
	            self addToggle("Broken Controller", player.brokenController, ::brokenController, player);
	            self addToggle("Control Player", player.controlPlayer, ::controlPlayer, player);
	            self addSliderValue("Spin Speed", 0, 0, 10000, 100, ::setSpinSpeed, player);
	            self addSliderString("Teleport", "Him;Me;Crosshair;Far;Random", "Him;Me;Crosshair;Far;Random", ::teleportInit, player);
	            self addSliderString("Propel", "up;down;right;left;front;back" , "Up;Down;Right;Left;Front;Back" , ::propelPlayer , player);
	            self addToggle("Fake Freeze", player.fakeFreezePlayer, ::fakeFreezePlayer, player);
                self addToggle("Spam Sounds", self.spamSound, ::spamSound, player);


                self addMenu("info_menu_" + i, "Info Client");
                self addOpt("Name : " + player.name);
                self addOpt("Status : " + player.status);
                self addOpt("Xuid : " + (isDefined(player getXuid()) ? player getXuid() : "N/A"));
                self addOpt("Team : " + (isDefined(player.team) ? player.team : "N/A"));
                self addOpt("Kills : " + (isDefined(player.kills) ? player.kills : 0));
                self addOpt("Deaths : " + (isDefined(player.deaths) ? player.deaths : 0));
                self addOpt("K/D Ratio : " + (isDefined(player.kills) && isDefined(player.deaths) ? (player.kills / max(1, player.deaths)) : "N/A"));
                self addOpt("Score : " + (isDefined(player.score) ? player.score : 0));
                self addOpt("Assists : " + (isDefined(player.assists) ? player.assists : 0));
                self addOpt("Health : " + (isDefined(player.health) ? player.health : "N/A"));
                self addOpt("Weapon : " + (isDefined(player getCurrentWeapon()) ? player getCurrentWeapon() : "N/A"));
                self addOpt("Model : " + (isDefined(player getViewModel()) ? player getViewModel() : "N/A"));

                self addMenu("give_menu_" + i, "Give Menu");
                for (e = 0; e < level.status.size; e++)
                {
                    if (level.status[e] != "Owner" && level.status[e] != "Host")
                    {
                        self addOpt("Give " + level.status[e], ::initializeSetup, e, player);
                    }
                }
            }
        }
    }
}


printPlayerName(player)
{
    self iprintln("Player Name : " + player getName());
}

menuMonitor()
{
    self endon("disconnect");
    self endon("end_menu");

    while( self.access != "None" )
    {
        if(!self.menu["isLocked"])
        {
            if(!self.menu["isOpen"])
            {
                if( self meleeButtonPressed() && self adsButtonPressed() )
                {
                    self menuOpen();
                    wait .2;
                }               
            }
            else 
            {
                if( self.actionSlotsPressed[ "dpad_up" ] || self.actionSlotsPressed[ "dpad_down" ] )
                {
                    self.menu[ self getCurrentMenu() + "_cursor" ] += self.actionSlotsPressed[ "dpad_down" ];
                    self.menu[ self getCurrentMenu() + "_cursor" ] -= self.actionSlotsPressed[ "dpad_up" ];
                    self scrollingSystem();
                    wait .2;
                }
                else if( self.actionSlotsPressed[ "dpad_left" ] || self.actionSlotsPressed[ "dpad_right" ] )
                {
                    if(isDefined(self.eMenu[ self getCursor() ].val) || IsDefined( self.eMenu[ self getCursor() ].ID_list ))
                    {
                        if( self.actionSlotsPressed[ "dpad_left" ] )  self updateSlider( "L2" );
                        if( self.actionSlotsPressed[ "dpad_right" ] )   self updateSlider( "R2" );
                        wait .1;
                    }
                }
                else if( self.actionSlotsPressed[ "jump" ] )
                {
                    menu = self.eMenu[self getCursor()];
                    if(isDefined(self.sliders[ self getCurrentMenu() + "_" + self getCursor() ]))
                    {
                        slider = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
                        slider = (IsDefined( menu.ID_list ) ? menu.ID_list[slider] : slider);
                        self thread [[ menu.func ]]( slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5);
                    }
                    else 
                    self thread [[ menu.func ]]( menu.p1, menu.p2, menu.p3, menu.p4, menu.p5);

                    if(IsDefined( menu.toggle ))
                    self setMenuText();
                    wait .2;
                }
                else if( self useButtonPressed() )
                {
                    level notify("FIX_OVERFLOW");
                    if( self getCurrentMenu() == "main" )
                        self menuClose();
                    else 
                        self newMenu();
                    wait .2;
                }
            }
        }
        wait .05;
    }
}

redrawHUD()
{
    self destroyAll(self.menu["UI_TOG"]);
    self destroyAll(self.menu["UI_SLIDE"]);

    self setMenuText();
    ////resetHUD(self);
    
}

menuOpen()
{
    self.menu["isOpen"] = true;
    self menuOptions();
    self drawMenu();
    self drawText();
    self updateScrollbar();
    self notify("stopCycling");
    self.isCycling = false;
    self destroyAll(self.welcome["UI_BAR"]);
    self destroyElement(self.msg);
    self redrawHUD();
    
}

menuClose()
{
    self.menu["isOpen"] = false;
    self destroyAll(self.menu["UI"]);
    self destroyAll(self.menu["OPT"]);
    self destroyAll(self.menu["UI_TOG"]);
    self destroyAll(self.menu["UI_SLIDE"]);
    
    if(getDvar("menuBox") == "1")
    {
        self thread initWelcomeHUD();
    }
    else
    {
        self notify("stopCycling");
        self.isCycling = false;
        level notify("FIX_OVERFLOW");  
    }


}

drawMenu()
{
    if(!isDefined(self.menu["UI"]))
        self.menu["UI"] = [];
    if(!isDefined(self.menu["UI_TOG"]))
        self.menu["UI_TOG"] = [];    
    if(!isDefined(self.menu["UI_SLIDE"]))
        self.menu["UI_SLIDE"] = [];
        if(!isDefined(self.menu["UI_STRING"])) 
        self.menu["UI_STRING"] = [];    
        
       
        
    if(level._Platform == "PC")
    {
        self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "LEFT", 526, self.presets["Y"] - -120, 220, 20, self.presets["TITLE_OPT_BG2"], "white", 1, 1);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_RIGHT"] = self createRectangle("LEFT", "LEFT", 745, -36 , 2, 251, self.presets["SCROLL_STITLE_BG"], "white", 5, 1);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_LEFT"] = self createRectangle("LEFT", "LEFT", 525, -36 , 2, 251, self.presets["SCROLL_STITLE_BG"], "white", 5, 1);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_TOP"] = self createRectangle("LEFT", "LEFT", 525, -162 , 222, 2, self.presets["SCROLL_STITLE_BG"], "white", 2, 1);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_TOP2"] = self createRectangle("LEFT", "LEFT", 525, -110 , 222, 2, self.presets["SCROLL_STITLE_BG"], "white", 2, 2);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_DOWN"] = self createRectangle("LEFT", "LEFT", 525, 90 , 222, 2, self.presets["SCROLL_STITLE_BG"], "white", 5, 2);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_DOWN2"] = self createRectangle("LEFT", "LEFT", 525, 70 , 222, 2, self.presets["SCROLL_STITLE_BG"], "white", 5, 2);
        self.menu["UI"]["LOGO"] = self createRectangle("LEFT", "LEFT", 525, -136 , 220, 50, self.presets["TITLE_OPT_BG2"] , "white", 3, 1);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LOGO_SHADER"] = self createRectangle("LEFT", "LEFT", 610, -136 , 49, 49, self.presets["WHITE"] , "ui_host", 7, 1);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] - 35, self.presets["Y"] - 70, 100, 110, self.presets["BACKGROUND"], "white", 1, 1);    //x = -L/+R, y = -U/+D
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] - 35, self.presets["Y"] - 108, 220, 20, self.presets["SCROLL_STITLE_BG"], "white", 2, 1);//x = -L/+R, y = -U/+D
        
    }
    else
    {
        self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "LEFT", 525, self.presets["Y"] - -120, 220, 20, self.presets["TITLE_OPT_BG2"], "white", 1, 1);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_RIGHT"] = self createRectangle("LEFT", "LEFT", 745, -36 , 2, 251, self.presets["SCROLL_STITLE_BG"], "white", 5, 1);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_LEFT"] = self createRectangle("LEFT", "LEFT", 525, -36 , 2, 251, self.presets["SCROLL_STITLE_BG"], "white", 5, 1);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_TOP"] = self createRectangle("LEFT", "LEFT", 525, -162 , 222, 2, self.presets["SCROLL_STITLE_BG"], "white", 2, 1);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_TOP2"] = self createRectangle("LEFT", "LEFT", 525, -110 , 222, 2, self.presets["SCROLL_STITLE_BG"], "white", 2, 2);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_DOWN"] = self createRectangle("LEFT", "LEFT", 525, 90 , 222, 2, self.presets["SCROLL_STITLE_BG"], "white", 5, 2);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LINE_DOWN2"] = self createRectangle("LEFT", "LEFT", 525, 70 , 222, 2, self.presets["SCROLL_STITLE_BG"], "white", 5, 2);
        self.menu["UI"]["LOGO"] = self createRectangle("LEFT", "LEFT", 525, -136 , 220, 50, self.presets["TITLE_OPT_BG2"] , "white", 3, 1);//x = -L/+R, y = -U/+D
        self.menu["UI"]["LOGO_SHADER"] = self createRectangle("LEFT", "LEFT", 540, -136 , 49, 49, self.presets["WHITE"] , "hud_obit_death_falling", 7, 1);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] - 35, self.presets["Y"] - 70, 100, 110, self.presets["BACKGROUND"], "white", 1, 1);    //x = -L/+R, y = -U/+D
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] - 35, self.presets["Y"] - 108, 220, 20, self.presets["SCROLL_STITLE_BG"], "white", 2, 1);//x = -L/+R, y = -U/+D
        
    }
    self resizeMenu();
    
}

drawText()
{
    if(!isDefined(self.menu["OPT"]))
        self.menu["OPT"] = [];
        
        
        font = getDvar("menuFont");
        switch(font)
        {
            case "reset" : 
            self.menu["OPT"]["MENU_NAME"] = self createText("hudbigboldi", 3, "CENTER", "CENTER", self.presets["X"] + 75, self.presets["Y"] - 95, 4, 1, level.menuName, self.presets["TEXT"]);  
            self.menu["OPT"]["MENU_TITLE"] = self createText("objective", 1.1, "CENTER", "CENTER", self.presets["X"] + 70, self.presets["Y"] + 120, 4, 1, self.menuTitle, self.presets["TEXT"]);
            for(e=0;e<10;e++)
            {
                self.menu["OPT"][e] = self createText("objective", 1, "LEFT", "CENTER", self.presets["X"] + 300, self.presets["Y"] - (60 - (e*18)), 4, 1, "", self.presets["TEXT"]);//x = -L/+R, y = -U/+D 
            }
            ////resetHUD(self); 
            break;
            
            case "objective":
            self.menu["OPT"]["MENU_NAME"] = self createText("objective", 3, "CENTER", "CENTER", self.presets["X"] + 70, self.presets["Y"] - 95, 4, 1, level.menuName, self.presets["TEXT"]);  
            self.menu["OPT"]["MENU_TITLE"] = self createText("objective", 1.1, "CENTER", "CENTER", self.presets["X"] + 70, self.presets["Y"] + 120, 4, 1, self.menuTitle, self.presets["TEXT"]);
            for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText("objective", 1, "LEFT", "CENTER", self.presets["X"] -60, self.presets["Y"] - (60 - (e*18)), 4, 1, "", self.presets["TEXT"]);//x = -L/+R, y = -U/+D  
            //resetHUD(self);
            break;
            
            case "default":
            self.menu["OPT"]["MENU_NAME"] = self createText("default", 3, "CENTER", "CENTER", self.presets["X"] + 75, self.presets["Y"] - 95, 4, 1, level.menuName, self.presets["TEXT"]);  
            self.menu["OPT"]["MENU_TITLE"] = self createText("default", 1.1, "CENTER", "CENTER", self.presets["X"] + 70, self.presets["Y"] + 120, 4, 1, self.menuTitle, self.presets["TEXT"]);
            for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText("default", 1, "LEFT", "CENTER", self.presets["X"] -60, self.presets["Y"] - (60 - (e*18)), 4, 1, "", self.presets["TEXT"]);//x = -L/+R, y = -U/+D 
            //resetHUD(self); 
            break;
            
            case "bigfixed":
            self.menu["OPT"]["MENU_NAME"] = self createText("bigfixed", 2, "CENTER", "CENTER", self.presets["X"] + 75, self.presets["Y"] - 95, 4, 1, level.menuName, self.presets["TEXT"]);  
            self.menu["OPT"]["MENU_TITLE"] = self createText("bigfixed", 1, "CENTER", "CENTER", self.presets["X"] + 70, self.presets["Y"] + 120, 4, 1, self.menuTitle, self.presets["TEXT"]);
            for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText("bigfixed", 1, "LEFT", "CENTER", self.presets["X"] -20, self.presets["Y"] - (60 - (e*18)), 4, 1, "", self.presets["TEXT"]);//x = -L/+R, y = -U/+D  
            //resetHUD(self);
            break;
            
            case "smallfixed":
            self.menu["OPT"]["MENU_NAME"] = self createText("smallfixed", 3, "CENTER", "CENTER", self.presets["X"] + 75, self.presets["Y"] - 95, 4, 1, level.menuName, self.presets["TEXT"]);  
            self.menu["OPT"]["MENU_TITLE"] = self createText("smallfixed", 1.1, "CENTER", "CENTER", self.presets["X"] + 70, self.presets["Y"] + 120, 4, 1, self.menuTitle, self.presets["TEXT"]);
            for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText("smallfixed", 1, "LEFT", "CENTER", self.presets["X"] -20, self.presets["Y"] - (60 - (e*18)), 4, 1, "", self.presets["TEXT"]);//x = -L/+R, y = -U/+D  
            //resetHUD(self);
            
            
            case "big":
            self.menu["OPT"]["MENU_NAME"] = self createText("big", 3, "CENTER", "CENTER", self.presets["X"] + 75, self.presets["Y"] - 95, 4, 1, level.menuName, self.presets["TEXT"]);  
            self.menu["OPT"]["MENU_TITLE"] = self createText("big", 1.1, "CENTER", "CENTER", self.presets["X"] + 70, self.presets["Y"] + 120, 4, 1, self.menuTitle, self.presets["TEXT"]);
            //resetHUD(self);
            for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText("big", 1, "LEFT", "CENTER", self.presets["X"] -20, self.presets["Y"] - (60 - (e*18)), 4, 1, "", self.presets["TEXT"]);//x = -L/+R, y = -U/+D  
            
            
            case "small":
            self.menu["OPT"]["MENU_NAME"] = self createText("small", 3, "CENTER", "CENTER", self.presets["X"] + 75, self.presets["Y"] - 95, 4, 1, level.menuName, self.presets["TEXT"]);  
            self.menu["OPT"]["MENU_TITLE"] = self createText("small", 1.1, "CENTER", "CENTER", self.presets["X"] + 70, self.presets["Y"] + 120, 4, 1, self.menuTitle, self.presets["TEXT"]);
            for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText("small", 1, "LEFT", "CENTER", self.presets["X"] -20, self.presets["Y"] - (60 - (e*18)), 4, 1, "", self.presets["TEXT"]);//x = -L/+R, y = -U/+D  
            //resetHUD(self);
            break;
            
            case "extrabig":
            self.menu["OPT"]["MENU_NAME"] = self createText("extrabig", 3, "CENTER", "CENTER", self.presets["X"] + 75, self.presets["Y"] - 95, 4, 1, level.menuName, self.presets["TEXT"]);  
            self.menu["OPT"]["MENU_TITLE"] = self createText("extrabig", 1.1, "CENTER", "CENTER", self.presets["X"] + 70, self.presets["Y"] + 120, 4, 1, self.menuTitle, self.presets["TEXT"]);
            for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText("extrabig", 1, "LEFT", "CENTER", self.presets["X"] -20, self.presets["Y"] - (60 - (e*18)), 4, 1, "", self.presets["TEXT"]);//x = -L/+R, y = -U/+D  
            //resetHUD(self);
            break;
            
            case "extrasmall":
            self.menu["OPT"]["MENU_NAME"] = self createText("extrasmall", 3, "CENTER", "CENTER", self.presets["X"] + 75, self.presets["Y"] - 95, 4, 1, level.menuName, self.presets["TEXT"]);  
            self.menu["OPT"]["MENU_TITLE"] = self createText("extrasmall", 1.1, "CENTER", "CENTER", self.presets["X"] + 70, self.presets["Y"] + 120, 4, 1, self.menuTitle, self.presets["TEXT"]);
            for(e=0;e<10;e++)
            self.menu["OPT"][e] = self createText("extrasmall", 1, "LEFT", "CENTER", self.presets["X"] -20, self.presets["Y"] - (60 - (e*18)), 4, 1, "", self.presets["TEXT"]);//x = -L/+R, y = -U/+D  
            //resetHUD(self);
            break;
           
        }
        
    
}


refreshTitle()
{
    self.menu["OPT"]["MENU_TITLE"] setSafeText(self.menuTitle);
}
    
scrollingSystem()
{
    if(self getCursor() >= self.eMenu.size || self getCursor() < 0 || self getCursor() == 9)
    {
        if(self getCursor() <= 0)
            self.menu[ self getCurrentMenu() + "_cursor" ] = self.eMenu.size -1;
        else if(self getCursor() >= self.eMenu.size)
            self.menu[ self getCurrentMenu() + "_cursor" ] = 0;
    }
    
    self setMenuText();
    self updateScrollbar();
}

updateScrollbar()
{
    curs = (self getCursor() >= 10) ? 9 : self getCursor();  
    self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);
    
    size       = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
    height     = int(18*size);
    math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
    position_Y = (self.eMenu.size-1) / ((height - 15) - math);
    
    if( self.eMenu.size > 10 )
        self.menu["UI"]["SIDE_SCR"].y = self.presets["Y"] - 62 + (self getCursor() / position_Y); 
    else self.menu["UI"]["SIDE_SCR"].y = self.presets["Y"] - 62;  
} 

setMenuText()
{
    self endon("disconnect");
    self  menuOptions(); 
    self resizeMenu();
    

    ary = (self getCursor() >= 10) ? (self getCursor() - 9) : 0;  
    self destroyAll(self.menu["UI_TOG"]);
    self destroyAll(self.menu["UI_SLIDE"]);
    //resetHUD(self);
    for(e=0;e<10;e++)
    {
        self.menu["OPT"][e].x = self.presets["X"] -30; 
        
        if(isDefined(self.eMenu[ ary + e ].opt))
            self.menu["OPT"][e] setSafeText(self.eMenu[ ary + e ].opt);
        else 
            self.menu["OPT"][e] setSafeText("");
            
        if(IsDefined( self.eMenu[ ary + e ].toggle ))
        {
            
            if(getDvar("toggleBoxShader") == "white")
            {
                self.menu["OPT"][e].x -= 0; 
                self.menu["UI_TOG"][e] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 195, self.menu["OPT"][e].y, 12, 12, (0,0,0), "white", 6, 1); //BG //x = -L/+R, y = -U/+D
                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["UI_TOG"][e].x + 6, self.menu["UI_TOG"][e].y, 10, 10, (self.eMenu[ ary + e ].toggle) ? self.presets["LINETOP1"] : self.presets["BACKGROUND"], "white", 7, 1); //INNER
            }
            
           else if(getDvar("toggleBoxShader") == "circle")
            {
                self.menu["OPT"][e].x -= 0; 
                self.menu["UI_TOG"][e] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 195, self.menu["OPT"][e].y, 12, 12, (0,0,0), "circle", 6, 1); //BG //x = -L/+R, y = -U/+D
                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["UI_TOG"][e].x + 6, self.menu["UI_TOG"][e].y, 10, 10, (self.eMenu[ ary + e ].toggle) ? self.presets["LINETOP1"] : self.presets["BACKGROUND"], "circle", 7, 1); //INNER
            }
            
            else if(getDvar("toggleBoxShader") == "text")
            {
                self.menu["OPT"][e].x -= 0; 
                
               
                 if (self.eMenu[ary + e].toggle)
                {
                    self.menu["UI_TOG"][e] = self createText("objective", 1, "LEFT", "CENTER", self.menu["OPT"][e].x + 195, self.menu["OPT"][e].y, 6, 1, "^2ON", self.presets["TEXT"]); // Mettre ON en vert
                }
                else
                {
                    self.menu["UI_TOG"][e] = self createText("objective", 1, "LEFT", "CENTER", self.menu["OPT"][e].x + 195, self.menu["OPT"][e].y, 6, 1, "^1OFF", self.presets["TEXT"]); // Mettre OFF en rouge
                }
                
            }
            
            else if(getDvar("toggleBoxShader") == "checkbox")
            {
                self.menu["OPT"][e].x -= 0; 
                
                if (self.eMenu[ary + e].toggle)
                {
                    self.menu["UI_TOG"][e] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 195, self.menu["OPT"][e].y, 12, 10, self.presets["LINETOP1"], "thumbsup", 7, 1); 
                }
                else
                {
                    self.menu["UI_TOG"][e] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 195, self.menu["OPT"][e].y, 12, 12, (1,1,1), "menu_mp_lobby_locked", 6, 1);
                }
                
            }
            
            else if(getDvar("toggleBoxShader") == "loader")
            {
                self.menu["OPT"][e].x -= 0; 
                self.menu["UI_TOG"][e] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 195, self.menu["OPT"][e].y, 12, 12, (0,0,0), "lui_loader_no_offset", 6, 1); //BG //x = -L/+R, y = -U/+D
                self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["UI_TOG"][e].x + 6, self.menu["UI_TOG"][e].y, 12, 12, (self.eMenu[ ary + e ].toggle) ? self.presets["LINETOP1"] : self.presets["BACKGROUND"], "lui_loader_no_offset", 7, 1); //INNER
            }

        }
        if(IsDefined( self.eMenu[ ary + e ].val ))
        {
            
            if(getDvar("toggleBoxShader") == "white" || getDvar("toggleBoxShader") == "text" || getDvar("toggleBoxShader") == "checkbox" || getDvar("toggleBoxShader") == "social" )
            {
                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 209, self.menu["OPT"][e].y, 108, 12, (0,0,0), "white", 4, 1); //BG
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 209, self.menu["UI_SLIDE"][e].y, 10, 10, self.presets["LINETOP1"], "white", 5, 1); //INNER
                if( self getCursor() == ( ary + e ) )
                self.menu["UI_SLIDE"]["VAL"] = self createText("objective", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 126, self.menu["OPT"][e].y, 9, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["TEXT"]);
                self updateSlider( "", e, ary + e );
            }
            
           else if(getDvar("toggleBoxShader") == "circle")
            {
                self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 239, self.menu["OPT"][e].y, 108, 12, (0,0,0), "white", 4, 1); //BG
                self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 239, self.menu["UI_SLIDE"][e].y, 10, 10, self.presets["LINETOP1"], "circle", 5, 1); //INNER
                if( self getCursor() == ( ary + e ) )
                self.menu["UI_SLIDE"]["VAL"] = self createText("objective", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 126, self.menu["OPT"][e].y, 9, 1, self.sliders[ self getCurrentMenu() + "_" + self getCursor() ] + "", self.presets["TEXT"]);
                self updateSlider( "", e, ary + e );
            }
            
            
        }
        if( IsDefined( self.eMenu[ (ary + e) ].ID_list ) )
        {
            if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + (ary + e)] ))
                self.sliders[ self getCurrentMenu() + "_" + (ary + e) ] = 0;
                
            self.menu["UI_SLIDE"]["STRING_"+e] = self createText("objective", 1, "CENTER", "CENTER", self.menu["OPT"][e].x + 162, self.menu["OPT"][e].y, 6, 1, "", self.presets["TEXT"]);
        
            self updateSlider( "", e, ary + e );
        }
        if( self.eMenu[ ary + e ].func == ::newMenu && IsDefined( self.eMenu[ ary + e ].func ) )
        self.menu["UI_SLIDE"]["SUBMENU"+e] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 209, self.menu["OPT"][e].y, 6, 1, ">", self.presets["TEXT"]);
    }
}

    
resizeMenu()
{
    size   = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
    height = int(18*size);
    math   = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
    
    self.menu["UI"]["SIDE_SCR"] SetShader( "white", 4, int(math));
    self.menu["UI"]["SIDE_SCR_BG"] SetShader( "white", 9, height + 2);
    self.menu["UI"]["OPT_BG"] SetShader( "white", 220, 180 );
    self.menu["UI"]["OUTLINE"] SetShader( "white", 225, height + 54 );
    self.menu["UI"]["SIDE_SCR_DW"].y = self.presets["Y"] - 75 + height;
}

