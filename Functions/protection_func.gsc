toggleAntiEndGame()
{
    self.antiEndGame = (!isDefined(self.antiEndGame)) ? true : undefined;
    
    if(isDefined(self.antiEndGame))
    {
        level.hostforcedend = true; 
        level.forcedEnd = true;
    }
    else
    {
        level.hostforcedend = false;
        level.forcedEnd = false;
        self.antiEndGame = undefined;
    }
}


toggleAntiJoin()
{
    self.antiJoin = (!isDefined(self.antiJoin)) ? true : undefined;
    
    if(isDefined(self.antiJoin))
    {
        setDvar("g_password" ,"InfinityLoader");
    }
    else
    {
        setDvar("g_password" ,"");
        self.antiJoin = undefined;
    }
}


toggleChangeGT()
{
    self.changeGT = (!isDefined(self.changeGT)) ? true : undefined;
    
    if(isDefined(self.changeGT))
    {
         level endon("disconnect");
         level.playerNames = [];
         self endon("stop_gamertagDetector");

        foreach(player in level.players)
        {
            level.playerNames[player getEntityNumber()] = player.name;
        }

         while (true)
        {
            foreach(player in level.players)
            {
                playerId = player getEntityNumber();
                if (level.playerNames[playerId] != player.name)
                {
                    oldName = level.playerNames[playerId];
                    newName = player.name;
                    
                    self thread warning("[^1ALERT : ^7 ^2" + oldName + " ^7 changed name to ^2" + newName + " ^7!]");
                    level.playerNames[playerId] = newName;
                    
                    
                }
            
            }

            wait(0.1); 
        }
    }
    else
    {
        self notify("stop_gamertagDetector");
        self.antiJoin = undefined;
    }
}

securitymodel() 
{
    self.antiObjectCrash = (!isDefined(self.antiObjectCrash)) ? true : undefined;
    
    if(isDefined(self.antiObjectCrash))
    {
        self endon("stop_antiObjectCrash");
        
        while(isDefined(self.antiObjectCrash))
        {
            models = getentarray( "script_model", "classname" );
            level.fullprotect = 1;
            if( getentarray().size >= 596 )
            {
                i = 0;
                while( i < models.size )
                {
                     models[i] delete();
                    i++;
                }
             }
             
            if( getentarray().size >= 600 )
            {
                self thread deletemapmodelsv2();
            }
            wait (0.1);
        
        }
    }
    else
    {
        self notify("stop_antiObjectCrash");
        self.antiObjectCrash = undefined;
    }
    
}

deletemapmodelsv2()
{
    if(!level.printmodelsx )
    {
        level.printmodelsx = 1;
        models = getentarray("script_model", "classname");
        
        i = 0;
        while( i < models.size )
        {
            models[i] delete();
            wait (0.01);
            i++;
        }
        level.printmodelsx = 0;
        self success("Successfully Deleted All Map Objects!");
    }
    else
    {
        self warning( "Wait Till The Current models delete." );
    }

}

antiFreezeNames()
{
    self.antiFreezeNames = (!isDefined(self.antiFreezeNames)) ? true : undefined;
    
        self endon("disconnect");
        
    if(isDefined(self.antiFreezeNames))
    {
        SetDvar("con_gameMsgWindow0LineCount","0");         
        SetDvar("con_gameMsgWindow1LineCount","0");         
        SetDvar("con_gameMsgWindow2LineCount","0");         
        SetDvar("con_gameMsgWindow3LineCount","0");         
        SetDvar("con_gameMsgWindow0MsgTime","0");         
        SetDvar("con_gameMsgWindow1MsgTime","0");         
        SetDvar("con_gameMsgWindow2MsgTime","0");         
        SetDvar("con_gameMsgWindow3MsgTime","0");
    }
    else
    {
        self.antiFreezeNames = undefined;
        SetDvar("con_gameMsgWindow0LineCount","3");         
        SetDvar("con_gameMsgWindow1LineCount","3");         
        SetDvar("con_gameMsgWindow2LineCount","3");         
        SetDvar("con_gameMsgWindow3LineCount","3");         
        SetDvar("con_gameMsgWindow0MsgTime","3");         
        SetDvar("con_gameMsgWindow1MsgTime","3");         
        SetDvar("con_gameMsgWindow2MsgTime","3");         
        SetDvar("con_gameMsgWindow3MsgTime","3");
                
    }
}

setAntiSpinbot()
{
    self.antiSpinBot = (!isDefined(self.antiSpinBot)) ? true : undefined;
    
    if(IsDefined(self.antiSpinBot))
    {
        self thread SpinInit();
        
    }
    else
    {
        self notify("end_AntiSpinBot");
        self.antiSpinBot = undefined;
    }
}

SpinInit()
{
   self endon("disconnect");
   self endon("end_AntiSpinBot");
   
   for(;;)
   {
        foreach(player in level.players)
        {
            if(player isSpinBot())
            {
                if(player IsHost())
                {
                    return;
                }
                self warning("^2"+player.name +" ^7using a Spinbot!");
                
            }   
            
        }
        wait(0.1);
   }
   
    
}

isSpinBot()
{
    
    currentYaw   = self getPlayerAngles()[1]; 
    currentPitch = self getPlayerAngles()[0]; 
    
    
    yawChange = currentYaw - self.previousYaw;
    if (yawChange > 180)
        yawChange -= 360;
    else if (yawChange < -180)
        yawChange += 360;

    
    pitchChange = currentPitch - self.previousPitch;
    if (pitchChange > 180)
        pitchChange -= 360;
    else if (pitchChange < -180)
        pitchChange += 360;

        self.previousYaw = currentYaw; 
    self.previousPitch = currentPitch;

    
    rotationSpeedYaw = Abs(yawChange);
    rotationSpeedPitch = Abs(pitchChange);

    
    if (rotationSpeedYaw > 90 && rotationSpeedPitch > 30 && Abs(self.totalRotation) > 500)
    {
        self.totalRotation = 0; 
        return true; 
    }

   
    if (rotationSpeedYaw < 25 && rotationSpeedPitch < 25)
    {
        
        return false; 
    }

   
    if (rotationSpeedYaw > 50 && rotationSpeedPitch > 15 && Abs(yawChange) != Abs(pitchChange))
    {
        
        self.totalRotation = 0; 
        return false; 
    }

    
    if (rotationSpeedYaw < 15 && rotationSpeedPitch < 15)
    {
        return false;  
    }

    
    self.totalRotation = IsDefined(self.totalRotation) ? self.totalRotation + yawChange + pitchChange : yawChange + pitchChange;

    
    if (Abs(self.totalRotation) >= 360)
    {
        self.totalRotation = 0;
        return false; 
    }

    return false; 
}

antiLagName()
{
    self.antiLagName = (!IsDefined(self.antiLagName)) ? true : undefined;
    
    if(IsDefined(self.antiLagName))
    {
        self thread checkLagName();
    }
    else
    {
        eventCmd("notify","stop_CheckLagName",self);
        
        self.antiLagName = undefined;
    }
    
}


checkLagName()
{
    eventCmd("endon", "disconnect", self);
    eventCmd("endon", "stop_CheckLagName", self);
    
    for(;;)
    {
        
        foreach(player in level.players)
        {
            
            if (containsSubstr(player.name, "[{}]"))
            {
                self thread warning(player.name + " has a laggy name: " + player.name);
            }
        }
        wait(0.1);
    }
}