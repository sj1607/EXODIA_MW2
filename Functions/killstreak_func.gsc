giveStreak(string , player)
{
    maps\mp\killstreaks\_killstreaks::giveKillstreak( string, false, false, player );    
}

neverStreak(player)
{
    player.neverStreak = (!IsDefined(player.neverStreak)) ? true : undefined;
    
    if(IsDefined(player.neverStreak))
    {
        eventCmd("endon","disconnect",player);
        eventCmd("endon","Stop_Never_Streaks",player);
        player.storeCurrentStreaks = [];

        foreach(streak in player.pers["killstreaks"])
        {
            player.storeCurrentStreaks[player.storeCurrentStreaks.size] = streak;
        }
        
        while(IsDefined(player.neverStreak))
        {
            player.pers["killstreaks"] = undefined;
            wait(0.1);
        }
    }
    else
    {
        if(IsDefined(player.storeCurrentStreaks))
        {
            player.pers["killstreaks"] = [];
            foreach(streak in player.storeCurrentStreaks)
            {
                player.pers["killstreaks"][player.pers["killstreaks"].size] = streak;
            }
        }
        player.neverStreak = undefined;
        player.storeCurrentStreaks = undefined;
        eventCmd("notify","Stop_Never_Streaks",player);
    }
}

InitHelicopter()
{
        
if (!IsDefined(self.Init_Helicopter)) 
{
            self endon("disconnect");
            self endon("death");
            self.Init_Helicopter = true;
            MyPosition = self.origin;

            level.HelicoModel = "cobra_mp";
            level.HelicoModel2 = "vehicle_cobra_helicopter_fly_low";

           
            level.Helico       = spawnHelicopter(self, MyPosition + (12000, 0, 1500), self.angles, level.HelicoModel, level.HelicoModel2);
            level.Helico.owner = self;

            
            level.Helico Vehicle_SetSpeed(1000, 25);
            level.Helico setVehGoalPos(MyPosition + (0, 0, 1500), 1);
            wait 5;
            level.Helico Vehicle_SetSpeed(100, 20);
            level.Helico setVehGoalPos(MyPosition + (0, 0, 120), 1);

            self endon("Stop_RideHelico");
            self endon("Stop_WaitForEnter");
            
            self.EnteredIntoHelico = false;
            

            while (true) 
            {
                self.InfoHelico destroy();
                
                
                if (distance(self.origin, level.Helico.origin) < 150) 
                {
                    self.InfoHelico = self createText("objective", 1.2, "CENTER", "CENTER", 0, 0, 5, 1, "Press [{+usereload}] to enter in the helicopter", self.presets["TEXT"]);

                    if (self useButtonPressed()) 
                    {
                        self EnableHelicopterControls();
                    } 
                }  
                else if (distance(self.origin, level.Helico.origin) > 150) 
                {
                    self.InfoHelico destroy();
                }   
      
                if(self.EnteredIntoHelico == true)
                {
                    self.InfoHelico destroy(); 
                    self notify("Stop_WaitForEnter");
                }
                
                wait(0.05);
            }
        } 
        else 
        {   
            level.Helico delete();
            self notify("Stop_RideHelico");
            self setClientDvar("cg_thirdPersonRange" , "80");
            self thread disableWeapons(self);
            self showallparts();
            self thread healthMode("off");
            self setClientDvar("cg_thirdPerson" , "0");
            self freezeControlsWrapper(false);
            self.Accelerate destroy();
            self.Break_ destroy();
            self.UP destroy();
            self.Down destroy();
            self.Shoot destroy();
            self.Missile destroy();
            self.Vision destroy();
            self Suicide();
            self.Init_Helicopter = undefined;
            
        }      
      
}


EnableHelicopterControls()
{
    self thread disableWeapons(self);
    self hideallparts();
    self thread healthMode("god");
    self setClientDvar("cg_thirdPerson" , "1");
    self setClientDvar("cg_thirdPersonRange" , "500");
    self freezeControlsWrapper(true);
    self thread InitHelicopterMovement();
    self.EnteredIntoHelico = true;
    self thread ShowHelicopterInstructions();
}


InitHelicopterMovement()
{
    self endon("Stop_RideHelico");

    
    self PlayerLinkToDelta( level.Helico );
    self setPlayerAngles(level.Helico.angles + (0, 0, 0));
    self setOrigin(((level.Helico.origin + (-200, 0, 150)) + (AnglesToForward(level.Helico.angles) * 30) + (0, 0, 3)));
    
    level.Helico_Speed = 0;
    
    
    while (true)
    {
        Helico_Trace = PlayerAnglesToForward(self, 200 + level.Helico_Speed);   
        
        
        if(self attackbuttonpressed())
        {
            UpdateHelicopterSpeed(270, 90, Helico_Trace);
        }   
        
        
        if(self fragbuttonpressed())
        {
            UpdateHelicopterAltitude(270, 90, true);
        }
        
       
        if(self secondaryoffhandbuttonpressed())
        {
            UpdateHelicopterAltitude(270, 90, false);
        }
        
      
        if(self adsbuttonpressed())
        {
            level.Helico_Speed -= 5;
            level.Helico setYawSpeed(150, 80);
            level.Helico Vehicle_SetSpeed(-270, 90);
            level.Helico setVehGoalPos(level.Helico.origin + (-10, 0, 0), 1);
        }
        
        
        LimitHelicopterSpeed();
        
       
        HandleThermalVision();
        
       
        HandleMainWeapon();
        
        
        wait(0.05);    
    }   
}


UpdateHelicopterSpeed(speed, yawSpeed, targetPos)
{
    if(level.Helico_Speed < 0)
    {
        level.Helico_Speed = 0;
    } 
    
    if(level.Helico_Speed < 500)
    {
        level.Helico_Speed += 5;
        level.Helico setYawSpeed(150, 80);
        level.Helico Vehicle_SetSpeed(speed, yawSpeed);
        level.Helico setVehGoalPos(targetPos, 1);
    }
}


UpdateHelicopterAltitude(speed, yawSpeed, isClimbing)
{
    if(level.Helico_Speed < 0)
    {
        level.Helico_Speed = 0;
    }  
    
    if(level.Helico_Speed < 500)
    {
        level.Helico_Speed += 5;
        level.Helico setYawSpeed(150, 80);
        level.Helico Vehicle_SetSpeed(speed, yawSpeed);
        
        if(isClimbing)
        level.Helico setVehGoalPos(level.Helico.origin + (0, 0, level.Helico_Speed), 1);
        else 
        level.Helico setVehGoalPos(level.Helico.origin + (0, 0, -1 * level.Helico_Speed), 1);
    }
}


LimitHelicopterSpeed()
{
    if(level.Helico_Speed == 500)
    level.Helico_Speed = 400;
    
    if(level.Helico_Speed == -500)
    level.Helico_Speed = -400;
}


HandleThermalVision()
{
    if(self.actionSlotsPressed[ "change_weapon" ] == 1)
    {
        if(IsDefined(self.GreedIslandThermalVision) && self.GreedIslandThermalVision == true)
        {
            self.GreedIslandThermalVision = false;
            self VisionSetNakedForPlayer("ac130_thermal_mp" , 2);
        }
        else
        {                                
            self.GreedIslandThermalVision = true;
            self VisionSetNakedForPlayer("" , 2);
        }
    }
}


HandleMainWeapon()
{
    startPos = self getEye() + (0, 0, 70); 
    if(self useButtonPressed())
    {   
        
        MagicBullet("cobra_20mm_mp", startPos, self GetCursorPosition(), self);
        wait(0.05);    
    }
    
    if(self fragbuttonpressed())
    {       
        MagicBullet("at4_mp", startPos, self GetCursorPosition(), self);
    }
}


ShowHelicopterInstructions()
{
    self.Accelerate = self createText("objective", 1, "CENTER", "CENTER", 0, 100, 5, 1, "Press [{+attack}] to accelerate", self.presets["TEXT"]);
    self.Break_     = self createText("objective", 1, "CENTER", "CENTER", 0, 120, 5, 1, "Press [{+speed_throw}] pour brake", self.presets["TEXT"]);
    self.UP         = self createText("objective", 1, "CENTER", "CENTER", 0, 140, 5, 1, "Press [{+frag}] to go up", self.presets["TEXT"]);
    self.Down       = self createText("objective", 1, "CENTER", "CENTER", 0, 160, 5, 1, "Press [{+smoke}] to go down", self.presets["TEXT"]);
    self.Shoot      = self createText("objective", 1, "CENTER", "CENTER", 0, 180, 5, 1, "Press [{+usereload}] to shoot", self.presets["TEXT"]);
    self.Missile    = self createText("objective", 1, "CENTER", "CENTER", 0, 200, 5, 1, "Press [{+stance}] to shoot missiles", self.presets["TEXT"]);
    self.Vision     = self createText("objective", 1, "CENTER", "CENTER", 0, 220, 5, 1, "Press [{+switchseat}] to toggle thermal vision", self.presets["TEXT"]);
    
    self thread overflowfix();                  
}


PlayerAnglesToForward(player, distance)
{
    return player.origin + vector_scale(AnglesToForward(player getPlayerAngles()), distance);   
}  


TraceBulletModdedStreak(traceDistance, traceReturn, detectPlayers)
{
    if (!isDefined(traceDistance))
        traceDistance = 10000000;

    if (!isDefined(traceReturn))
        traceReturn = "position";

    if (!isDefined(detectPlayers))
        detectPlayers = false;

    return BulletTrace(self GetEye(), self GetEye() + AnglesToForward(self GetPlayerAngles()) * 100000, false, self)["position"];
}


GetCursorPosition() 
{
    return BulletTrace(self getTagOrigin("tag_eye"), vector_Scale(anglestoforward(self getPlayerAngles()), 1000000), 0, self)["position"];
}

ridePlane()
{
    self.ridePlane = (!IsDefined(self.ridePlane)) ? true : undefined;
    
    if(isDefined(self.ridePlane))
    {
        self.Init_Plane = true;
        
        MyPosition = self.origin;

        level.PlaneModel    = "vehicle_mig29_desert";
        level.PlaneModelAlt = "vehicle_av8b_harrier_jet_opfor_mp";
        StartPoint          = MyPosition + (0, 0, 80);
        EndPoint            = StartPoint + (0, 5000, 50);
        level.Plane         = spawnPlane( self, "script_model", StartPoint );
        
        level.Plane setModel(level.PlaneModel);
        level.Plane.angles    = self.angles;
        self.EnteredIntoPlane = false;
        
        self endon("Stop_WaitForEnterToPlane");
        
        while(true)
        {
            self.InfoPlane destroy();
            
            if (distance(self.origin, level.Plane.origin) < 150) 
            {
                self.InfoPlane = self createText("objective", 1.2, "CENTER", "CENTER", 0, 0, 5, 1, "Press [{+usereload}] to enter in the plane", self.presets["TEXT"]);

              if (self usebuttonpressed()) 
              {
                self EnablePlaneControls();
              } 
            }  
            else if (distance(self.origin, level.Plane.origin) > 150) 
            {
                self.InfoPlane destroy();
            }   
            
            if(self.EnteredIntoPlane == true)
             {
                self.InfoPlane destroy(); 
                self notify("Stop_WaitForEnterToPlane");
             }
            
            
            wait(0.05);
        }
        
        
    }
    else
    {
        level.Plane delete();
        
        self thread disableWeapons(self);
        self showallparts();
        self thread healthMode("off");
        self setClientDvar("cg_thirdPerson" , "0");
        self setClientDvar("cg_thirdPersonRange" , "80");
        self freezeControlsWrapper(false);
        self.Accelerate destroy();
        self.Missile destroy();
        self Suicide();
        self.ridePlane = undefined;
    }
}

EnablePlaneControls()
{
    self thread disableWeapons(self);
    self hideallparts();
    self thread healthMode("god");
    self setClientDvar("cg_thirdPerson" , "1");
    self setClientDvar("cg_thirdPersonRange" , "500");
    self freezeControlsWrapper(true);
    self.EnteredIntoPlane = true;
    self thread InitPlaneMovements();
    self thread ShowPlaneInstructions();
    level.Plane thread maps\mp\killstreaks\_airstrike::playPlaneFx();
}



InitPlaneMovements()
{
    self endon("Stop_RidePlane");
    self endon("disconnect");
    self endon("death");


    self PlayerLinkToDelta( level.Plane );
    
    
    while(true)
    {
        if(self attackbuttonpressed())
        {
            normalized         = anglesToForward(self getPlayerAngles());
            scaled             = vector_scale(normalized,100);
            originpos          = self.origin+scaled;
            level.Plane.origin = originpos;
            level.Plane.angles = self getPlayerAngles();
        }
        
        startPos = self getEye() + (0, 0, 70); 
        
        if(self fragbuttonpressed())
        {       
            MagicBullet("remotemissile_projectile_mp", startPos, self GetCursorPosition(), self);
        }
          
        wait(0.05);
    }
}

ShowPlaneInstructions()
{
    self.Accelerate = self createText("objective", 1, "CENTER", "CENTER", 0, 100, 5, 1, "Press [{+attack}] to accelerate", self.presets["TEXT"]);
    self.Missile    = self createText("objective", 1, "CENTER", "CENTER", 0, 120, 5, 1, "Press [{+frag}] to shoot missiles", self.presets["TEXT"]);
    
    self thread overflowfix();  
}


