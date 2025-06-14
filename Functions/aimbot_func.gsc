setAutoAimForPlayers(tag)
{

    if (isDefined(self.autoAimbotUnfairPlayers))
    {
        self error("Disable Unfair Aimbot first.");
        return;
    }
    
    

    if (isDefined(self.autoAimPlayers))
    {
        self notify("EndAutoAim");
        wait(0.1); 
    }

   
    self.autoAimTag = tag;


    if (self.autoAimTag == "OFF")
    {
        self.autoAimPlayers = undefined;
        self notify("EndAutoAim");
        return;
    }


    self.autoAimPlayers = (!IsDefined(self.autoAimPlayers)) ? true : undefined;

    if (IsDefined(self.autoAimPlayers))
    {
        self endon("disconnect");
        self endon("EndAutoAim");

        for (;;)
        {
            aimAt = undefined;

            
            foreach(player in level.players)
            {
                if((player == self) || (!isAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"])) 
                    continue;

                if (isDefined(aimAt))
                {
                    if (closer(self.origin, player.origin, aimAt.origin))
                        aimAt = player;
                }
                    
                else 
                { 
                    aimAt = player;
                }
                
                
            }

            
            if (isDefined(aimAt))
            {
                if (self adsButtonPressed()) 
                {
                    
                    currentTagOrigin = self getTagOrigin("j_head"); 
                    aimTagOrigin = aimAt getTagOrigin(self.autoAimTag); 

                    
                    self setplayerangles(VectorToAngles(aimTagOrigin - currentTagOrigin));
                    
                 
                    distanceToTarget = distance(self.origin, aimAt.origin);
            
                    
                    if (self attackbuttonpressed() && isVisible(currentTagOrigin, aimTagOrigin) && distanceToTarget < 100)
                    {
                        modType = getModTypeForTag(self.autoAimTag); 
                        aimAt thread [[level.callbackPlayerDamage]](self, self, 100, 0, modType, self getCurrentWeapon(), (0,0,0), (0,0,0), self.autoAimTag, 0, 0);
                        wait(0.2);
                    }
                }
            }

            wait(0.01); 
        }
    }
    else
    {
       
        self.autoAimPlayers = undefined;
        self notify("EndAutoAim");
    }
}


isVisible(startPoint, endPoint)
{
    return !bullettracepassed(startPoint, endPoint, 0, undefined);
}



closer(origin, targetOrigin, currentOrigin)
{
    return distance(origin, targetOrigin) < distance(origin, currentOrigin);
}


getModTypeForTag(tag)
{
    if (tag == "j_head")
    {
        return "MOD_HEAD_SHOT";
    }
    else if (tag == "j_neck" || tag == "j_spineupper" || tag == "j_spinelower")
    {
        return "MOD_RIFLE_BULLET";
    }
    else if (tag == "j_hip_le" || tag == "j_hip_ri" || tag == "j_shoulder_le" || tag == "j_shoulder_ri" ||
             tag == "j_elbow_le" || tag == "j_elbow_ri" || tag == "j_wrist_le" || tag == "j_wrist_ri")
    {
        return "MOD_RIFLE_BULLET";
    }
    else if (tag == "j_knee_le" || tag == "j_knee_ri" || tag == "j_ankle_le" || tag == "j_ankle_ri")
    {
        return "MOD_LEG_SHOT";
    }
    else
    {
        return "MOD_PISTOL_BULLET";
    }
}

unfairAimbot()
{
    self endon("disconnect");
    self endon("death");
    self endon("GreedIsland_StopUnfair");

    if (isDefined(self.autoAimPlayers)) 
    {
        self.autoAimbotUnfairPlayers = undefined;
        self notify("GreedIsland_StopUnfair");
        self error("Disable Aimbot first.");
        return;
    } 
    
   
    self.autoAimbotUnfairPlayers = (!IsDefined(self.autoAimbotUnfairPlayers)) ? true : undefined;

    if (isDefined(self.autoAimbotUnfairPlayers))
    {
        self endon("death");
        self endon("disconnect");
        self endon("GreedIsland_StopUnfair");

        for (;;)
        {
            aimAt = undefined;

            foreach(player in level.players)
            {
                if ((player == self) || (!isAlive(player)) || (level.teamBased && self.pers["team"] == player.pers["team"]))
                    continue;

                if (isDefined(aimAt))
                {
                    if (closer(self.origin, player.origin, aimAt.origin))
                        aimAt = player;
                }
                else 
                {
                    aimAt = player;
                }
            }

            if (isDefined(aimAt))
            {
                if (self attackbuttonpressed())
                {
                    modType = getModTypeForTag(self.autoAimTag);
                    wait 0.05;

                    if (isAlive(aimAt))
                    {
                        aimAt thread [[level.callbackPlayerDamage]](self, self, 9999, 0, modType, self getCurrentWeapon(), (0,0,0), (0,0,0), "j_head", 0, 0);
                    }

                    
                   
                }
            }

            wait 0.01;
        }
    }
    else
    {
        self.autoAimbotUnfairPlayers = undefined;
        self notify("GreedIsland_StopUnfair");
    }
}

setgrenadeAimbot(weaponName)
{
    self.grenadeNames =  weaponName;
    self endon("endGrenadeAimbot");
    if(!IsDefined(self.oldWeapon))
    {
        self.oldWeapon = self getcurrentweapon();
    }
    
    
    
    if( weaponName == "void")
    
    {
        
        self takeallweapons();
        self giveWeapon(self.oldWeapon);
        self switchToWeapon(self.oldWeapon);
        //self setoffhandvisible(0);
        self.oldWeapon = undefined;
        self notify("endGrenadeAimbot"); 
        return;
    }
    else
    {
        self takeallweapons(); 
        self giveWeapon(weaponName);
        self giveMaxAmmo(self getCurrentOffHand());
       // self setoffhandvisible(1);
    
        viable_targets = [];
        enemy = self;
        time_to_target = 0;
        velocity = 500;
    
        while(1)
        {
            self waittill( "grenade_fire", grenade, weaponName );
        
            viable_targets = array_copy( level.players );
            arrayremovevalue( viable_targets, self );
            if( level.teambased )
            {
                foreach( player in level.players )
                {
                    if( player.team == self.team )
                    {
                        arrayremovevalue( viable_targets, player );
                    }
                }
            }
            enemy = thread maps\mp\explosive_barrels::getClosestEnt( grenade getorigin(), viable_targets ); 
            grenade thread trackplayer( enemy, self ,  weaponName  );
        }
    }
    
   
}



trackPlayer(enemy, host,  weaponName)
{
    attempts = 0;
    if (enemy != host && isDefined(enemy)) 
    {
        while (attempts < 25 && isAlive(enemy) && isDefined(enemy) && isDefined(self) && !(self isTouching(enemy)))
        {
            
            self.origin = ((self.origin + enemy getOrigin()) + (randomintrange(-50, 50), randomintrange(-50, 50), randomintrange(25, 90))) - self getOrigin() * (attempts / 35);
            wait 0.1;
            attempts++;
        }
        
        
        inflictDamage(enemy, 9999, host,  weaponName, "MOD_GRENADE", "none");
        wait 0.2;
        self delete(); 
    }
}

antiShield()
{
    self.antiShield = (!IsDefined(self.antiShield)) ? true : undefined;
    self endon("death");
    self endon("disconnect");
  
    self endon("EndAntiShield");
    if(IsDefined(self.antiShield))
    {
        while(IsDefined(self.antiShield))
        {
            foreach(player in level.players)
            {
                
                if(player getcurrentweapon() == "riotshield_mp" || player getCurrentOffHand() == "riotshield_mp" )
                {
                    player takeweapon("riotshield_mp");
                }
                
            }
            wait(0.2);
        }
    }
    else
    {
        self notify("EndAntiShield");
        self.antiShield = undefined;
    }
}

wallBangInit()
{
    self.wallBangEverything = (!IsDefined(self.wallBangEverything)) ? true : undefined;
    
    
    if(IsDefined(self.wallBangEverything))
    {
        self thread wallBangEverything();
    }
    else
    {
        self.wallBangEverything = undefined;
        self notify("endWallbang");
    }
}

wallBangEverything()
{
    self endon("disconnect");
    self endon("endWallbang");

    while (true)
    {
        self waittill("weapon_fired", weapon);

        if (!isdamageweapon(weapon) || self.pers["isBot"] && isDefined(self.pers["isBot"]))
        {
            continue;
        }

        anglesf  = anglestoforward(self getplayerangles());
        eye      = self geteye();
        savedpos = [];
        savedpos[0] = bullettrace(eye, vector_scale(anglesf, 1000000), 0, self)["position"];
        
        for (a = 1; a < 10; a++)
        {
            savedpos[a] = bullettrace(savedpos[a - 1], vector_scale(anglesf, 500), 1, self)["position"];
            
           
            if (distance(savedpos[a - 1], savedpos[a]) < 1)
            {
                savedpos[a] += vector_scale(anglesf, 0.5);
            }
            
            
            if (savedpos[a] != savedpos[a - 1])
            {
                magicbullet(self getcurrentweapon(), savedpos[a], vector_scale(anglesf, 500), self);
            }
        }

        wait(0.05);
    }
}


isdamageweapon(weapon)
{
    if (!isDefined(weapon))
    {
        return 0;
    }

    weapon_class = getweaponclass(weapon);

   
    if (weapon == "hatchet_mp" || issubstr(weapon, "saritch") || issubstr(weapon, "sa58_") || weapon_class == "weapon_sniper")
    {
        return 1;
    }

}

toggleOneSHot()
{
    self.oneShot = (!IsDefined(self.oneShot)) ? true : undefined;
    
    
    if(IsDefined(self.oneShot))
    {
        self thread oneShotInit();
    }
    else
    {
        self.oneShot = undefined;
        self notify("end_OneShot");
    }
}

oneShotInit()
{
   
    self endon("disconnect");
    self endon("end_OneShot");
    
    
    for(;;)
    {
        start = self getTagOrigin("tag_eye");
        end = start + anglestoforward(self getPlayerAngles()) * 10000;
        
        
        bullet = magicBullet(self getCurrentWeapon(), start, end, self);
        
        
        if(isDefined(bullet.victim))
        bullet.victim thread [[level.callbackPlayerDamage]](self, self, 1000000, 0, "MOD_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "none", 0); 
        wait 0.05;
    }
    
}

titanicMode(player)
{
  player.titanicMode = (!IsDefined(self.titanicMode)) ? true : undefined;
  player endon("death");
  player endon("disconnect");
  
  player endon("EndTitanicMode");
  
  if(isDefined(player.titanicMode))
  {
  
    while(isDefined(player.titanicMode))
    {
        player waittill("weapon_fired");
        random = RandomIntRange( 0, 9 );
        weap = player getcurrentweapon();
        player takeweapon( player getcurrentweapon() );
        player giveweapon( weap, 0, random, 0, 0, 0, 0 );
        player switchtoweapon( weap );
        
    }
    
  }
  else
  {
    player.titanicMode = undefined;
    player notify("EndTitanicMode");
  }
  
}

saveAndLoad(player)
{
    
    player.saveAndLoad  = (!IsDefined(self.saveAndLoad)) ? true : undefined;
    
    if(isDefined(player.saveAndLoad))
    {
        player endon("disconnect");

        player endon("SaveandLoad");
        

       player iprintln("Press [{+actionslot 2}] To Save");

       player iprintln("Press [{+actionslot 1}] To Load");


        load = 0;
        
        for(;;)
        {

            if(player.actionSlotsPressed[ "dpad_down" ] )
            {

                player.o = player.origin;
                player.a = player.angles;
                load = 1;

                player iprintln("^3Position Saved");
                wait 2;
            }

            if (player.actionSlotsPressed[ "dpad_up" ] && load == 1)
            {
                player setplayerangles(player.a);

                player setorigin(player.o);
            }
            wait 0.05;
        }
    }
    else
    {
        player.saveAndLoad = undefined;

        player notify("SaveandLoad");

    }

}

trickshotClass(player)
{
    player takeallweapons();
    player maps\mp\perks\_perks::givePerk("specialty_falldamage");
    player maps\mp\perks\_perks::givePerk("specialty_laststandoffhand");
    player maps\mp\perks\_perks::givePerk("specialty_lightweight");
    player maps\mp\perks\_perks::givePerk("specialty_finalstand");
    player maps\mp\perks\_perks::givePerk("specialty_combathigh");
    player giveweapon( "knife_mp" );
    player giveweapon( "cheytac_fmj_mp", 8, 0, 0, 0, 0, 0 );
    player switchtoweapon( "cheytac_fmj_mp" );
    player givemaxammo( "cheytac_fmj_mp" );
    player giveweapon( "spas12_mp", 8, 0, 0, 0, 0, 0 );
    player setweaponammostock( "spas12_mp", 999 );
    player setweaponammoclip( "spas12_mp", 999 );
    player giveweapon( "throwingknife_mp" );
    player setweaponammostock( "throwingknife_mp", 1 );
    player giveweapon( "concussion_grenade_mp" );
    player setweaponammostock( "concussion_grenade_mp", 1 );
}


LastKill()
{
    
    if(getDvar("g_gametype") == "war")
    {
        foreach(player in level.players)
        {
            if(player.team == self.team)
            {
                player.kills     += randomIntRange(15 , 60); 
                player.assists   += randomIntRange(0, player.kills);
                player.pers["score"]   += (player.kills * 100) + (player.assists * 15);
                player.headshots += (randomIntRange(0, player.kills / 6));
                player.deaths    += player.kills / 2;
            }
        }
        thread maps\mp\gametypes\_gamescore::_setTeamScore( self.team, getWatchedDvar( "scorelimit" ) -1 );
        thread maps\mp\gametypes\_gamelogic::checkScoreLimit();
        thread maps\mp\gametypes\_gamescore::sendUpdatedTeamScores();

    }
    else if(getDvar("g_gametype") == "dm")
    {
        self.pointstowin = getWatchedDvar( "scorelimit" ) - 1;
        self.pers["pointstowin"] = getWatchedDvar( "scorelimit" ) - 1;
        variantScore = randomInt(130);
        self.score = ((level.scorelimit - 1) * 100) + variantScore * 10;
        self.pers["score"] = self.score;
        self.kills = level.scorelimit - 1;
        self.deaths = randomIntRange(12,20);
        self.headshots = randomInt(0, 5);
        self.pers["kills"] = getWatchedDvar( "scorelimit" ) - 1;
        self.pers["deaths"] = self.deaths;
        self.pers["headshots"] = self.headshots;
        self maps\mp\gametypes\_gamescore::_setPlayerScore( self, self.pointstowin );
    }

}


SlideInit(option, player)
{
    self.slideOptions = option;

    if (option == "1") 
    {
        player thread manageSlides();
        player success("Slider ^2Spawned !");
    }
    else if (option == "2")
    {
        
        if (isDefined(self.slide) && self.slide.size > 0)
        {
            for (i = 0; i < self.slide.size; i++)
            {
                if (isDefined(self.slide[i]))
                {
                    self.slide[i] delete();
                    player success("Slider ^1Deleted !");
                }
            }
            self.slide = [];
        }

        else
        {
            player error("No sliders to delete!"); 
        }
    }
}


manageSlides()
{
    self endon("death");
    self endon("disconnect");

    start = self getTagOrigin("tag_eye");
    end = anglestoforward(self getPlayerAngles()) * 1000000;
    slidePos = BulletTrace(start, end, true, self)["position"] + (0, 0, 15);
    slideAng = self getPlayerAngles();


    if (!isDefined(self.slide))
    {
        self.slide = [];  
        
    }
    
        newSlider = spawn("script_model", slidePos);
        self.slide[self.slide.size] = newSlider;
        newSlider.angles = (0, slideAng[1] - 90, 70);
        newSlider setModel("com_plasticcase_enemy");
        newSlider cloneBrushmodelToScriptmodel(level.airDropCrateCollision);
    
        
        newSlider RotateTo((0, slideAng[1] - 90, 70), 0.1, 0, 0);
        newSlider MoveTo(slidePos, 0.1, 0, 0);
        //self.slide[0] notify("restartSlideThink"); 
    


    newSlider thread slideThink(slidePos, slideAng);
}


slideThink(origin, angles)
{
    self endon("restartSlideThink");

    for (;;)
    {
        foreach(player in level.players)
        {
            
            if (distance(player.origin, origin) < 100 && player meleeButtonPressed() && length(anglesXY(player getPlayerAngles() - angles)) < 90)
            {
                vec = anglesToForward(player.angles);
                for(i = 0; i < 10; i++)
                {
                    player setVelocity(player getVelocity() + (vec[0] * 50, vec[1] * 50, 200));
                    wait .01; 
                }
            }
        }
        wait .1; 
    }
}


anglesXY(angles)
{
    return (angles[0], angles[1], 0);
}


onPlayerKilled(eInflictor, attacker, iDamage, meansOfDeath, sWeapon, vDir, hitLoc, psOffsetTime, deathAnimDuration)
{
    if (IsDefined(attacker) && IsDefined(self) && attacker != self)
    {
        
        distance = int(calculateDistance(self.origin, attacker.origin) / 39.37);
        if(meansOfDeath == "MOD_HEAD_SHOT")
        foreach(player in level.players)
        player iprintln("[^3EXODIA ^1LOGS^7] : ^3"+attacker.name + "^7 headshotted ^1" + self.name + "^7 at " + distance + "m");
        else
        foreach(player in level.players)
        player iprintln("[^3EXODIA ^1LOGS^7] : ^3"+attacker.name + "^7 killed ^1" + self.name + "^7 at " + distance + "m");
    }
}

calculateDistance(pos1, pos2)
{
    dx = pos2[0] - pos1[0];
    dy = pos2[1] - pos1[1];
    dz = pos2[2] - pos1[2];

    return sqrt(dx * dx + dy * dy + dz * dz);
}

setDistance()
{
    self.setDistanceMeters = (!isDefined(self.setDistanceMeters)) ? true : undefined;
    
    if(IsDefined(self.setDistanceMeters))
    {
        level.onplayerkilled = ::onPlayerKilled;
    }
    else
    {
        level.onplayerkilled   = undefined;
        self.setDistanceMeters = undefined;
        
    }
}


set360Prone()
{
    self.set360Prone = (!IsDefined(self.set360Prone)) ? true : undefined;
    
    if(self.set360Prone)
    {
        self SetClientDvar("bg_prone_yawcap","360"); 
    }
    else
    {
       self SetClientDvar("bg_prone_yawcap","85");
       self.set360Prone = undefined;
    }
}


set360Ladder()
{
    self.set360Ladder = (!IsDefined(self.set360Ladder)) ? true : undefined;
    
    if(self.set360Ladder)
    {
        self setClientDvar("bg_ladder_yawcap" , "360");
    }
    else
    { 
        self setClientDvar("bg_ladder_yawcap" , "100");
        self.set360Ladder = undefined;
    }
}


disableDeathBarrier()
{
    self.disableDeathBarrier = (!IsDefined(self.disableDeathBarrier)) ? true : undefined;
    
    if(IsDefined(self.disableDeathBarrier))
    {
        hurtTriggers = getEntArray( "trigger_hurt", "classname" );
        foreach(hurtTrigger in hurtTriggers)
        hurtTrigger.origin += (0,0,9999999);
        
    }
    else
    { 
        self.disableDeathBarrier = undefined;
        hurtTriggers = getEntArray( "trigger_hurt", "classname" );
        foreach(hurtTrigger in hurtTriggers)
        hurtTrigger.origin = (0, 0, 1000);
    }
}