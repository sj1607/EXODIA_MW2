testToggle()
{
    if(!IsDefined( self.toggle ))
        self.toggle = true;
    else 
        self.toggle = undefined;
}
    
testSlider( value )
{
    IPrintLn( value );
}



resetBooleansOnDeath()
{
    
}

warning(string) 
{
    self setClientDvar("con_gameMsgWindow0MsgTime", "10");
    self setClientDvar("con_gameMsgWindow0LineCount", "8");
    self playsound("wpn_semtex_alert");
    self iprintln("^3Warning ^7: " + string);
    wait(10);
    self setClientDvar("con_gameMsgWindow0MsgTime", "5");
    self setClientDvar("con_gameMsgWindow0LineCount", "4");
}


success(string)
{
    self setClientDvar("con_gameMsgWindow0MsgTime", "10");
    self setClientDvar("con_gameMsgWindow0LineCount", "8");
    self playsound("uin_gamble_perk");
    self iprintln("^2Success ^7: " + string);
    wait(10);
    self setClientDvar("con_gameMsgWindow0MsgTime", "5");
    self setClientDvar("con_gameMsgWindow0LineCount", "4");
}

error(string)
{
    self setClientDvar("con_gameMsgWindow0MsgTime", "10");
    self setClientDvar("con_gameMsgWindow0LineCount", "8");
    self playsound("uin_alert_lockon");
    self iprintln("^1Error ^7: " + string);
    wait(10);
    self setClientDvar("con_gameMsgWindow0MsgTime", "5");
    self setClientDvar("con_gameMsgWindow0LineCount", "4");
}

printDvar(string)
{
    self setClientDvar("con_gameMsgWindow0MsgTime", "10");
    self setClientDvar("con_gameMsgWindow0LineCount", "8");
    self playsound("uin_alert_lockon");
    self iprintln("^4Dvar Value ^7: "+getdvar(string));
    wait(10);
    self setClientDvar("con_gameMsgWindow0MsgTime", "5");
    self setClientDvar("con_gameMsgWindow0LineCount", "4");
}


menuBoxInit()
{
    
    if(getDvar("menuBox") == "1") 
    {
        self thread initWelcomeHUD();
        self.menuBox = true;
    }
    else
    {
        self.isCycling = false;
        self notify("stopCycling");
    }
}

eventCmd(cmd, cmdEvent, player)
{
    
    if(!IsDefined(cmdEvent))
    {
        self error("Event not defined.");
        return;
    }
    
    switch(cmd)
    {
        case "endon": 
        {
            player endon(cmdEvent);
            break;
        }
        
        case "notify":
        {
            player notify(cmdEvent);
            break;
        }
        
        case "wait":
        {
            return player waittill(cmdEvent);
        }
        
        default:
        {
            self warning("Unknown cmd : " + cmd);
            break;
        }
    }
}

vector_scale(vec,scale)
{
    vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale);
    return vec;
}

MoveAfterGameEnds()
{
    level waittill("game_ended");
    while(!self areControlsFrozen()) 
    wait .05;
    self freezeControls(false);
}

getPlatform()
{
    if (level.xenon)
    {
        return "Xbox360";  
    }
    else if (level.pc)
    {
        return "PC"; 
    }
    else
    {
        return "Unknown"; 
    }
}

traceBullet()
{
    return BulletTrace(self GetEye(),self GetEye()+vector_scale(AnglesToForward(self GetPlayerAngles()),1000000),0,self)["position"];
}

actionSlotButtonPressed( button ) //up, down, left, right
{
    self endon("end_menu");
    self endon("disconnect");
    level endon("game_ended");
    
    if(!isDefined( self.actionSlotsPressed ))
    {
        self.actionSlotsPressed = [];   
        self notifyOnPlayerCommand( "jump", "+gostand" );
        self notifyOnPlayerCommand( "dpad_up", "+actionslot 1" );
        self notifyOnPlayerCommand( "dpad_down", "+actionslot 2" );
        self notifyOnPlayerCommand( "dpad_left", "+actionslot 3" );
        self notifyOnPlayerCommand( "dpad_right", "+actionslot 4" );
        self notifyonplayercommand( "stance", "+stance" );
        self notifyonplayercommand( "change_weapon", "+weapnext" );
    }
    
    self.actionSlotsPressed[ button ] = false;
    for(;;)
    {
        self waittill(button);
        self.actionSlotsPressed[ button ] = true;    
        wait .1;
        self.actionSlotsPressed[ button ] = false;   
    }
}

unlockFPS()
{
    self eventCmd("endon", "disconnect", self);

    if (level._Platform == "PC")
    {
        fps_address = ReadInt(0x01B90730) + 0xC;

        for(;;)
        {
            
            fps_values = ReadInts(fps_address, 4);

            new_values = [300, 300, 300, 300]; 
            WriteInts(fps_address, new_values); 

            wait(0.1);
            
        }
        ilog( getdvar("com_maxfps") );
    }
}



