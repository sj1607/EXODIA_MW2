doTeleport(param , player)
{
    player.teleportMode = param;
    
    switch(param)
    {
        
        case "0":
        {
            break;
        }
        
        case "1":
        {
            player BeginLocationSelection("map_artillery_selector",false);
            player.selectingLocation = true; 
            player waittill("confirm_location",location);
            newLocation = BulletTrace(location+(0,0,0),location,0,player)["position"];
            player SetOrigin(newLocation);
            player endLocationSelection();
            player.selectingLocation = undefined;
            break;
        }
        
        case "2":
        {
            player BeginLocationSelection("map_artillery_selector",false);
            player.selectingLocation = true; 
            player waittill("confirm_location", location);
            player menuClose();
            newLocation = BulletTrace(location + (0, 0, 1000), location, 0, player)["position"];
            newLocation = BulletTrace(newLocation + (0, 0, 100), newLocation - (0, 0, 10000), 0, player)["position"];
            player endLocationSelection();
            player.selectingLocation = undefined;
            player thread performTeleportAnimation(newLocation);
            break;
        }
    }
} 

performTeleportAnimation(newLocation)
{
    self endon("death");
    self endon("disconnect");
    self endon("welcone_Done");

    self disableWeapons();
    self hideAllParts();
    self freezeControls(true);

     
    zoomHeight       = 3000;
    zoomBack         = 2000;
    yaw              = 55;
    origin           = self.origin;
    backwardPosition = origin + vector_scale(anglestoforward(self.angles) * -1, zoomBack); 
    highPosition     = backwardPosition + (0, 0, zoomHeight); 

    ent = spawn("script_model", (0, 0, 0));
    ent.angles = self.angles + (yaw, 0, 0);
    ent.origin = self.origin;
    ent setmodel("tag_origin");

   
    self PlayerLinkToAbsolute(ent);
    ent moveto(highPosition, 4); 
    wait(4);
    
    self disableWeapons();
    self hide();
    self freezeControls(true);

    
    self unlink();
    ent.origin = highPosition;  
    ent setmodel("tag_origin");


    self PlayerLinkToAbsolute(ent);
    ent moveto(newLocation, 4); 
    wait(4);


    ent rotateto((ent.angles[0] - yaw, ent.angles[1], 0), 3, 1, 1);
    wait (3.2);


    self unlink();
    ent delete();
    self showAllParts();
    self freezeControls(false);
    self enableWeapons();

    self notify("welcone_Done");
    
}


setLagMode(player)
{
    
    player.lagMode = (!IsDefined(player.lagMode)) ? true : undefined;
    
    if(player.lagMode)
    {
        player thread lagInit(player);
        
    }
    else
    {
        
        player.lagMode = undefined;
        eventCmd("notify", "endLagMode", player);
    }
}

lagInit(player)
{
   eventCmd("endon", "endLagMode", player);
   eventCmd("endon", "disconnect", player);
    while(IsDefined(player.lagMode))
    {
        player setVelocity((randomint(200) - 100, randomint(200) - 100, randomint(200) - 100));
        wait (0.1);
    }
}


 _setThirdPerson(player)
{
   player.rdPerson = (!IsDefined( player.rdPerson)) ? true : undefined;
           
   if(IsDefined(player.rdPerson))
   {
     player setClientDvar("cg_thirdPerson" , "1");
   }
   else
   {
      player.rdPerson = undefined; 
      player setClientDvar("cg_thirdPerson" , "0");
   } 
}


setThirdPersonRange(int , player)
{
  if(IsDefined(player.rdPerson))
  {
    player setClientDvar("cg_thirdPersonRange" , int);
  }
  else
  {
    player error("Third Person must be activate.");
  }
          
}
        
      
setThirdPersonAngle(int , player)
{
   if(IsDefined(player.rdPerson))
    {
      player setClientDvar("cg_thirdPersonAngle " , int);
    }
    else
    {
       player error("Third Person must be activate.");
    }
          
}
        
       
goProMode(player)
{
    if(!IsDefined(player.rdPerson)) 
    {
        player error("Third Person must be activate.");
      return;
    }
     
  player.goPro = (!IsDefined( player.goPro)) ? true : undefined;
           
          
  if(IsDefined(player.rdPerson))
  {
     if(IsDefined(player.goPro))
     {
                
        player setClientDvar( "cg_thirdPersonAngle", "185" );
        player setClientDvar( "cg_thirdPersonRange", "138" );
        player setfov(20.0, player);
                   
     }
                    
      else
      {
        player.goPro = undefined;
        player setClientDvar( "cg_thirdPersonAngle", "0" );
        player setClientDvar( "cg_thirdPersonRange", "80" );
        player setfov(65.0, player);
      } 
  }
  
           
           
}
       
povMode(player)
{
    if(!IsDefined(player.rdPerson))
    {
        player error("Third Person must be activate.");
        return;
    }
    
   player.povMode = (!IsDefined( player.povMode)) ? true : undefined;
   
   if(IsDefined(player.rdPerson))
   {
       if(IsDefined(player.povMode))
       {
                
        player setClientDvar( "cg_thirdPersonAngle", "0" );
        player setClientDvar( "cg_thirdPersonRange", "0" );                
                   
       }
       else
       {
           player.povMode = undefined;
           player setClientDvar( "cg_thirdPersonAngle", "0" );
           player setClientDvar( "cg_thirdPersonRange", "80" );
           player setfov(65.0, player);
       } 
   }
         
           
}


setVision(vision , player) 
{
    if(vision == "default")
    {
        vision = "";
        WriteByte( PC_ADRESSE_CARTOON_VISION, 0x09 ); 
        WriteByte( PC_ADRESSE_MAP_COLOR_VISION, 0x01 ); 
        player VisionSetNakedForPlayer(vision , 2);
    }
    else if(vision == "cartoon")
    {
        WriteByte( PC_ADRESSE_CARTOON_VISION, 0x04 ); 
        WriteByte( PC_ADRESSE_MAP_COLOR_VISION, 0x01 ); 
        player VisionSetNakedForPlayer("", 2);
    }
    else if(vision == "black")
    {
        WriteByte( PC_ADRESSE_CARTOON_VISION, 0x09 ); 
        WriteByte( PC_ADRESSE_MAP_COLOR_VISION, 0x00 ); 
        player VisionSetNakedForPlayer("" , 2);
    }
    else if(vision == "white")
    {
        WriteByte( PC_ADRESSE_CARTOON_VISION, 0x09 );
        WriteByte( PC_ADRESSE_MAP_COLOR_VISION, 0x02 ); 
        player VisionSetNakedForPlayer("" , 2);
    }
    else if(vision == "grey")
    {
        WriteByte( PC_ADRESSE_CARTOON_VISION, 0x09 );
        WriteByte( PC_ADRESSE_MAP_COLOR_VISION, 0x03 ); 
        player VisionSetNakedForPlayer("" , 2);
    }
    else
    {
        WriteByte( PC_ADRESSE_CARTOON_VISION, 0x09 ); 
        WriteByte( PC_ADRESSE_MAP_COLOR_VISION, 0x01 ); 
        player VisionSetNakedForPlayer(vision , 2);
    }
}

spawnClone(cloneType , player )
{
    if(cloneType == "1")
    {
        player cloneplayer( 1 );
    }
    
    else if(cloneType == "2")
    {
        cloneDead = player cloneplayer( 1 );
        cloneDead  startragdoll(1);
    }
    
    else if(cloneType == "3")
    {
        clone = spawn( "script_model", player.origin );
        clone setmodel( player.model );
    }
    
    else if(cloneType == "4")
    {
        x = randomintrange(50, 100);
        y = randomintrange(50, 100);
        z = randomintrange(20, 30);
        exp_clone = player cloneplayer( 1 ); 
        exp_clone startragdoll(1);
        //exp_clone launchragdoll((x, y, z));
        
        playfx( level.stealthbombfx , player.origin );
    }
} 

forceField(mode , player)
{
    if(mode == "1")
    {
        eventCmd("notify", "GreedIsland_Stop_ForceField", player);
        
        setDvar("playerPushAmount", 1);
    }
    else if(mode == "2")
    {
        eventCmd("notify", "GreedIsland_Stop_ForceField", player);
        setDvar("playerPushAmount", 9999);
    }
    
    else if(mode == "3")
    {
        setDvar("playerPushAmount", 1);
        
        eventCmd("endon", "GreedIsland_Stop_ForceField", player);
        for(;;)
        {
            Enemy = level.players;
            for( i=0; i < Enemy.size; i++)
            {
                if(Enemy[i]!=player)
                {
                    if(Distance(Enemy[i].origin,player.origin)<120)
                    {
                        Enemy[i] thread [[level.callbackPlayerDamage]]( player, player, 100, 0, "MOD_HEAD_SHOT", player getCurrentWeapon(), (0,0,0), (0,0,0), "head", 0, 0 );
                    }
                }
            }
            wait (0.1);
        }
        wait (0.1);
    }
        
}

toggleStatus(status , player)
{
    if(status == "1")
    {
        player.statusicon = "";
        player success("None Status ^2Set!");
    }
    
    else if(status == "2")
    {
        player.statusicon = "hud_status_dead";
        player success("Death Status ^2Set!");
    }
    
    else if(status == "3")
    {
        player.statusicon = "hud_status_connecting";
        player success("Connecting Status ^2Set!");
    }
}
 
 quickDash(player)
{

    player.quickDash = (!IsDefined( player.quickDash)) ? true : undefined;
    
    if(isDefined(player.quickDash))
    {
        player endon("GreedIsland_QuickDash");
        self iprintln("Press [{+stance}] To Activate Dash.");
        while(isDefined(player.quickDash))
        {
        
            if(player.actionSlotsPressed[ "stance" ])
            {
                
                forward = anglestoforward(player getplayerangles());

               
                player setvelocity((forward[0] * 1000, forward[1] * 1000, 0)); 

                
                 for (i = 0; i < 10; i++)
                 {
                      player setvelocity((forward[0] * 1000, forward[1] * 1000, 0));
                     wait(0.01);
                 }

                
                player setvelocity((0, 0, 0));
            }
            
            wait(0.02);
            
        }
        
    }
    else
    {
        player.quickDash = undefined;
        player notify("GreedIsland_QuickDash");
    }
    
   
}

propelPlayer(direction, player)
{
    player.posVelocity = direction;
    
    forward = anglestoforward(player getplayerangles());
    right = anglestoright(player getplayerangles());
    
    player setorigin(player.origin + (0, 0, 5));
    
    velocity = (0, 0, 0);
    speed = 1000;
    
    if (direction == "up")
    {
        velocity = (0, 0, speed);
    }
    else if (direction == "down")
    {
        velocity = (0, 0, speed * -1);
    }
    else if (direction == "right")
    {
        velocity = (right[0] * speed, right[1] * speed, 0);
    }
    else if (direction == "left")
    {
        velocity = (right[0] * speed * -1, right[1] * speed * -1, 0);
    }
    else if (direction == "front")
    {
        velocity = (forward[0] * speed, forward[1] * speed, 0);
    }
    else if (direction == "back")
    {
        velocity = (forward[0] * speed * -1, forward[1] * speed * -1, 0);
    }
    
    player setvelocity(velocity);
    
    for (i = 0; i < 10; i++)
    {
        player setvelocity(velocity);
        player freezeControls(false);
        wait(0.01);
    }
    
    player setvelocity((0, 0, 0));
}



snakeMode(player)
{
    player.snakeMode = (!IsDefined( player.snakeMode)) ? true : undefined;
    
    if(isDefined(player.snakeMode))
    {
        eventCmd("endon", "disconnect", player);
        eventCmd("endon", "GreedIsland_Stop_SnakeMode", player);
        self iprintln("Press [{+stance}] To Activate Super Speed.");
        self iprintln("^1Press [{+frag}] To Disable.");
        while(isDefined(player.snakeMode))
        {
        
            player setStance("prone");
            player setClientDvar("bg_prone_yawcap","360");
            
            if (player.actionSlotsPressed[ "stance" ])
            {
            
                forward = anglestoforward(player getplayerangles());
                player setvelocity((forward[0] * 800, forward[1] * 800, -200)); 
                
            
            }
            
            if( player fragButtonPressed())
            {
                player.snakeMode = undefined;
                eventCmd("notify", "GreedIsland_Stop_SnakeMode", player);
                player setvelocity((0, 0, 0)); 
                player setStance("stand"); 
                player setClientDvar("bg_prone_yawcap","85");
                
            }
            
            wait(0.1);
        }
    }
    else
    {
        
        player setvelocity((0, 0, 0)); 
        player setStance("stand");
        player setClientDvar("bg_prone_yawcap","85");
    }
}

spinBot(player)
{
    player.spinBotInit = (!IsDefined(player.spinBotInit)) ? true : undefined;
    
    if (IsDefined(player.spinBotInit))
    {
        
        eventCmd("endon", "death", player);      
        eventCmd("endon", "stop_spinBot", player);
        
        player _setThirdPerson(player);

        angleIncrement = 8;   
        rotationDelay  = 0.05;
        
        while (IsDefined(self.spinBotInit))
        {
            currentAngles = self getPlayerAngles();
            
            newYaw = currentAngles[1] + angleIncrement;
            newAngles = (currentAngles[0], newYaw, currentAngles[2]);
            self setplayerangles(newAngles);
            wait(rotationDelay);
           
        }
    }
    else
    {
        player.spinBotInit = undefined;
        player _setThirdPerson(player);
        player setplayerangles(player.angles + (0, 0, 0));
        eventCmd("notify", "stop_spinBot", player);
        
        
    }
}

setMeteore()
{
    self beginLocationselection("map_artillery_selector", true, (level.mapSize / 5.625));
    self.selectingLocation = true; 
    self waittill("confirm_location",location);
    metoreLocation = BulletTrace(location+(0,0,0),location,0,self)["position"];
    self endLocationSelection();
    self.selectingLocation = undefined;
    
    self createLargeCrossFormationWithTilt(meteoreLocation, 30, "com_plasticcase_enemy", 50);
}


    
descendMeteor(model, targetPosition)
{
    initialHeight = 5000; 
    amplitude     = 100;
    descentSpeed  = 0.02;
    horizontalOffset = 500;
    
    
   
    self.Fx1 = Loadfx( "misc/ac130_cloud" );
    self.Fx2 = LoadFX("fire/jet_engine_ac130");
    self.Fx3 = LoadFX("trail/fx_trail_heli_killstreak_engine_smoke");
    self.Fx4 = LoadFX("explosions/artilleryExp_dirt_brown");
    self.Fx5 = LoadFX("fire/fire_smoke_trail_L");

   
    if (isDefined(model))
    {
        PlayFXOnTag(self.Fx1, model, "tag_origin");
        PlayFXOnTag(self.Fx2, model, "tag_origin");
        PlayFXOnTag(self.Fx3, model, "tag_origin");
        PlayFXOnTag(self.Fx4, model, "tag_origin");
        PlayFXOnTag(self.Fx5, model, "tag_origin");
    }

   
    t = 0;
    while (t <= 1 && isDefined(model))
    {
        newPosX = targetPosition[0] + (horizontalOffset * (0.5 - t));
        newPosY = targetPosition[1] + (amplitude * sin(t * 3.14));
        newPosZ = targetPosition[2] + initialHeight * (1 - t);

        model.origin = (newPosX, newPosY, newPosZ);

        t += descentSpeed;
        wait(0.05);
    }

   
    if (isDefined(model))
    {
        model.origin = targetPosition;
        
        self.FxFinal = LoadFX("explosions/aerial_explosion_ac130_coop");
        self maps\mp\_fx::script_playfx(self.FxFinal, model.origin, model.origin);
        self thread earthquakeEffect(model.origin);
    }

    if (isDefined(model)) 
    {
        model delete();
    }
}



loopfxstop(timeout)
{
    self endon("death");
    wait(timeout);
    self.looper delete();
}


    
createLargeCrossFormationWithTilt(centerPosition, spacing, modelName, tiltAngle)
{
    forwardTilt = (tiltAngle, 0, 0); 

    offsets = [];

    offsets[0] = (0, 0, 0);                 
    offsets[1] = (0, 0, spacing);            
    offsets[2] = (0, 0, spacing);            
    offsets[3] = (spacing, 0, 0);            
    offsets[4] = (spacing, 0, 0);           
    offsets[5] = (0, 0, 2 * spacing);        
    offsets[6] = (0, 0, 2 * spacing);        
    offsets[7] = (2 * spacing, 0, 0);        
    offsets[8] = (2 * spacing, 0, 0);        
    offsets[9] = (spacing, 0, spacing);      
    offsets[10] = (spacing, 0, spacing);    
    offsets[11] = (spacing, 0, spacing);     
    offsets[12] = (spacing, 0, spacing);    
    offsets[13] = (2 * spacing, 0, 2 * spacing); 
    offsets[14] = (2 * spacing, 0, 2 * spacing);  
    offsets[15] = (2 * spacing, 0, -2 * spacing); 
    offsets[16] = (2 * spacing, 0, -2 * spacing);  
    
    
    models = [];
    positions = [];


    for (i = 0; i < offsets.size; i++) 
    {
        positions[i] = (centerPosition[0] + offsets[i][0], centerPosition[1] + offsets[i][1], centerPosition[2] + offsets[i][2]); // Stocke la position
        models[i] = Spawn("script_model", (centerPosition[0] + offsets[i][0], centerPosition[1] + offsets[i][1], centerPosition[2] + offsets[i][2]));
        models[i] setModel(modelName);
        models[i].angles = forwardTilt; 
    }
    
    for (i = 0; i < models.size; i++) 
    {
        localIndex = i; 
        self thread descendMeteor(models[localIndex], positions[localIndex]); 
        wait(0.001); 
    } 

    
}

earthquakeEffect(epicenter)
{
    maxDistance = 500; 
    maxDamage   = 150; 
    burnRadius  = 200; 
    
    foreach(player in level.players)
    {
        distance = Distance(player.origin, epicenter);
        player playlocalsound("wpn_rocket_explode_rock");
        
        if(distance <= maxDistance)
        {
            intensity = 1 - (distance / maxDistance);
            multiplication = intensity * 1.2; 
            earthquake(multiplication, 4, player.origin, 100); 
            
            if(distance <= burnRadius)
            {
                player RadiusDamage(epicenter, 150, 75, 25); 
            }
            
            damage = int(maxDamage * (1 - (distance / maxDistance)));
            player maps\mp\gametypes\_globallogic_player::finishPlayerDamageWrapper(player, player, damage, 0, "MOD_EXPLOSIVE", "", epicenter, (0,0,0), "none", 0, 0);
            
            if(distance <= burnRadius)
            {
                player shellshock("mp_radiation_high" , 5);
            }
        }
    }
}

spawnTornado()
{
    start         = self gettagorigin("tag_eye");
    end           = anglestoforward(self getPlayerAngles()) * 1000000;
    spawnPosition = BulletTrace(start, end, true, self)["position"];
    self.effectTornado = level.chopper_fx["damage"]["light_smoke"];

    if (isDefined(spawnPosition))
    {
        
        self.tornado = spawn("script_model", spawnPosition);
        self.tornado setModel("tag_origin");
        self.tornadoFXHandles = [];
        self.tornadoSpawnPosition = spawnPosition;
        
        self thread createTornadoFx(spawnPosition);
        
        self success("Tornado Spawned!");
        self thread applyTornadoForce(self.tornadoSpawnPosition);
        //wait(0.5);
        // self thread moveTornado();
    }
}


createTornadoFx(position)
{
    
    if(isDefined(self.tornadoFXHandles) && self.tornadoFXHandles.size > 0)
    {
        for(i = 0; i < self.tornadoFXHandles.size; i++)
        {
            if(isDefined(self.tornadoFXHandles[i]))
            {
                self.tornadoFXHandles[i] delete();
            }
        }
    }
    
    
    self.tornadoFXHandles = [];
    for (i = 0; i < 20; i++) 
    {
        angle = i * 24; 
        offsetX = 100 * cos(angle);
        offsetY = 100 * sin(angle);
        effectPosition = position + (offsetX, offsetY, i * 50);
        fxHandle = PlayFX(level.chopper_fx["damage"]["light_smoke"], effectPosition); 
        self.tornadoFXHandles[i] = fxHandle;
    }
}

applyTornadoForce(spawnPosition) 
{
    radius          = 150;
    topHeight       = spawnPosition[2] + 1000;
    liftSpeed       = 20;
    attractionDelay = 0.05;
    rotationSpeed   = 15;
    
    self endon("end_Tornado");
    
    while (isDefined(self.tornado))
    {
        wait(0.05);
        currentSpawnPosition = self.tornadoSpawnPosition; 
        
      
        foreach (player in level.players)
        {
            dist = Distance(player.origin, currentSpawnPosition);
            if (dist < radius && !isDefined(player.OnTornado))
            {
                player.OnTornado = true;
                currentHeight = player.origin[2];
                currentAngle  = 0;
                while (currentHeight < topHeight && isDefined(self.tornado))
                {
                    currentHeight += liftSpeed;
                    currentAngle += rotationSpeed;
                    if (currentAngle >= 360)
                        currentAngle -= 360;
                    
                    offsetX = cos(currentAngle * (3.14159 / 180)) * radius;
                    offsetY = sin(currentAngle * (3.14159 / 180)) * radius;
                    newPos = (currentSpawnPosition[0] + offsetX, currentSpawnPosition[1] + offsetY, currentHeight);
                    player setOrigin(newPos);
                    wait(attractionDelay);
                }
                player setVelocity((0, 0, 300));
                wait(5);
                player.OnTornado = undefined;
            }
        }
        
        foreach (obj in level.script_model)
        {
            if(obj == self.tornado) 
                continue;
                
            dist = Distance(obj.origin, currentSpawnPosition);
            if (dist < radius) 
            {
                currentAngle = vectortoangles(currentSpawnPosition - obj.origin)[1];
                currentHeight = obj.origin[2];
                while (currentHeight < topHeight && isDefined(self.tornado))
                {
                    currentHeight += liftSpeed;
                    currentAngle += rotationSpeed;
                    if (currentAngle >= 360)
                        currentAngle -= 360;
                    
                    offsetX = cos(currentAngle * (3.14159 / 180)) * radius;
                    offsetY = sin(currentAngle * (3.14159 / 180)) * radius;
                    newPos = (currentSpawnPosition[0] + offsetX, currentSpawnPosition[1] + offsetY, currentHeight);
                    obj setOrigin(newPos);
                    wait(attractionDelay);
                }
            }
        }
    }
}

moveTornado()
{
    if (!isDefined(self.tornado))
    {
        self error("The tornado does not exist.");
        return;
    }

    self endon("end_MoveTornado");

    while (isDefined(self.tornado))
    {
        
        newPos = (self.tornado.origin[0] + randomint(2000) - 1000, self.tornado.origin[1] + randomint(2000) - 1000, self.tornado.origin[2]);
        
        
        self.tornado moveTo(newPos, 2);  
        
        
        self.tornadoSpawnPosition = newPos;
        
        
        wait(2);
        
        
        self thread createTornadoFx(newPos);

        wait(1); 
    }
}

deleteTornado()
{
    
    self notify("end_Tornado");
    self notify("end_MoveTornado");
    
   
    wait(0.2);
    
    if (isDefined(self.tornadoEffectModels))
    {
        
        for (i = 0; i < self.tornadoEffectModels.size; i++)
        {
            if (isDefined(self.tornadoEffectModels[i]))
            {
                self.tornadoEffectModels[i] delete();
            }
        }
        self.tornadoEffectModels = undefined;
    }
    
    
    if (isDefined(self.tornado))
    {
        self.tornado delete();
        self.tornado = undefined;
        self.effectTornado = undefined;
        
        self success("Tornado deleted!");
    }
    else
    {
        self error("No tornado to delete!");
    }
}

setTornadoOpt(opt)
{
    if(opt == "spawn")
    {
        self thread spawnTornado();
    }
    else if(opt == "delete")
    {
        self thread deleteTornado();
    }
}

superJump()
{

    if(IsDefined(level.superJumpGame)) 
    {
        self error("super jump for all is already activated!"); 
        return;
    }

    self.superJump = (!IsDefined(self.superJump)) ? true : undefined;

    self eventcmd("endon","disconnect",self);
    self eventcmd("endon","end_superJump",self);

    if(IsDefined(self.superJump))
    {
        while(IsDefined(self.superJump))
        {
            if(self IsOnGround())
            {
                self waittill("jump");
                self maps\mp\perks\_perks::givePerk("specialty_falldamage");
                self SetVelocity(self GetVelocity()+(0,0,1000));
            }
            wait(0.01);
        }
    }
    else
    {
        self.superJump = undefined;
        self eventcmd("notify","end_superJump",self);
    }
}


screenRotation()
{
    self.screenRotation = (!IsDefined(self.screenRotation)) ? true : undefined;
    
    if(IsDefined(self.screenRotation))
    {
        RPC( PC_ADRESS_CBUF_ADDTEXT, 0 ,"sv_cheats 1;SelectStringTableEntryInDvar S J player_view_pitch_down;SelectStringTableEntryInDvar S J player_view_pitch_up" );     
    }
    else
    {
        RPC( PC_ADRESS_CBUF_ADDTEXT, 0 ,"sv_cheats 0;reset player_view_pitch_down;reset player_view_pitch_up" );
        self.screenRotation = undefined;
        
    }
}