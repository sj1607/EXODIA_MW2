sanctionMode(option , player)
{
    player.ClientsSanctionMode = option;
    
    if(option == "kick")
    {
        kick(player getentitynumber());
    }
    else if(option == "ban")
    {
        kick(player getentitynumber());
        setPlayerDvar(player , "Banned_Exodia" , "1");
    }
}

toggleMessagesPlayer(option , player)
{
    player.messagesOpt4 = option;
    player iprintln("^2Option set to "+option);
}

sendMessagePlayer(message, player)
{
    target = player;
    
    if( self.messagesOpt4 == "1" )
    {
        foreach(player in level.players)
        {
            player iprintln("[^2" + target.name + "^7] : " + message);
        }
    }
    else if(self.messagesOpt4 == "2" )
    {
        foreach(player in level.players)
        {
            player iprintlnbold("[^2" + target.name + "^7] : " + message);
        }
    }
    else if(self.messagesOpt4 == "3" )
    {
        foreach(player in level.players)
        {
            player iprintln("[^2" + target.name + "^7] : " + message);
            player iprintlnbold("[^2" + target.name + "^7] : " + message);
        }
    }
    else if(self.messagesOpt4 == "4" )
    {
        foreach(player in level.players)
        {
            notifyData = spawnstruct();
            notifyData.titleText = "[^2"+target.name + "^7]" + " : " + message;
            notifyData.notifyText = "";
            notifyData.iconName = "";
            notifyData.glowColor = (0.29,0.30,0.30);
            notifyData.duration = 10;
            notifyData.font = "hudsmall";
            notifyData.hideWhenInMenu = false;
            player thread hud_message::notifyMessage(notifyData);
        }
    }
    
}

sayMessage(message , player)
{
	target = player;
	foreach(player in level.players)
	{
	  	notifyData = spawnstruct();
	    notifyData.titleText = "^2"+target.name + " " + message;
	    notifyData.notifyText = "";
	    notifyData.iconName = "";
	    notifyData.glowColor = (0.29,0.30,0.30);
	    notifyData.duration = 10;
	    notifyData.font = "hudsmall";
	    notifyData.hideWhenInMenu = false;
	    player thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
	}
}

setGodMode(player)
{
	player.godModePlayer = (!IsDefined(player.godModePlayer)) ? true : undefined;

	if(IsDefined(player.godModePlayer))
	{
		player.healthOpt = "god";
		player thread healthMode("god");
	}
	else
	{
		player.healthOpt = "off";
		player thread healthMode("off");
		player.godModePlayer = undefined;
	}
}

setUnlimitedAmmo(player)
{
	player.unlimitedAmmoPlayer = (!IsDefined(player.unlimitedAmmoPlayer)) ? true : undefined;

	if(IsDefined(player.unlimitedAmmoPlayer))
	{
		player.ammoOpt = "unlimited";
		player thread ammoMode("unlimited");
	}
	else
	{
		player.ammoOpt = "off";
		player thread ammoMode("off");
		player.unlimitedAmmoPlayer = undefined;
	}
}

unLimitedDeath(player)
{
    player.unlimitedDeath = (!IsDefined(player.unlimitedDeath)) ? true : undefined;
    
    player endon("disconnect");
    
    player endon("stop_UnlimitedDeath");
    
    if(IsDefined(player.unlimitedDeath))
    {
        while(player.unlimitedDeath)
        {
            player Suicide();
            wait(0.1);
        }
    }
    else
    {
        player.unlimitedDeath = undefined;
        player notify("stop_UnlimitedDeath");
    }
    
}

blowUp(option ,player)
{
    player.blowUpMode = option;
    
    if(option == "pavelow_minigun_mp")
    {
        for(s=0; s < 2 ; s++)
        {
            magicbullet( option , player.origin + ( 0, 0, 1 ), player.origin, self );
        }
    }
    else if(option == "explode")
    {
        bomb_velocity = vector_scale(anglestoforward(player getplayerangles()), 999);
        player launchbomb( "stealth_bomb_mp", player.origin, bomb_velocity ); 
    }
    earthquake( 0.4, 4, player.origin, 100 );
    magicbullet( option , player.origin + ( 0, 0, 1 ), player.origin, self );
}


freezeMode(option , player)
{
    player.freezeMode = option;
    
    if(option == "None")
    {
        player freezecontrols(false);
    }
    else if(option == "Controls")
    {
        player freezecontrols(true);
    }
    else if(option == "Console")
    {
        for(k = 0; k < 20; k++)
        {
            textFreeze = "^";
            player iPrintlnBold(textFreeze);
            player iprintln(textFreeze);
            wait(0.5);
        }
    }
    else if(option == "Game")
    {
        for(k = 0; k < 20; k++)
        {
            textFreeze = "^";
            player iPrintlnBold(textFreeze);
            player iprintln(textFreeze);
            wait(0.5);
        }
    }
}

brokenController(player)
{
    player.brokenController = (!IsDefined(player.brokenController)) ? true : undefined;

    if (IsDefined(player.brokenController))
    {
        player endon("disconnect");
        player endon("end_BrokenController");

        while (IsDefined(player.brokenController))
        {
            
            freezeDuration = randomFloatRange(0.05, 0.15); 
            unfreezeDelay = randomFloatRange(0.1, 0.4);    

            player freezeControlsWrapper(true);
            wait(freezeDuration);
            player freezeControlsWrapper(false);
            wait(unfreezeDelay);
        }
    }
    else
    {
        player freezeControlsWrapper(false);
        player.brokenController = undefined;
        player notify("end_BrokenController");
    }
}


controlPlayer(player)
{
    player.controlPlayer = (!IsDefined(player.controlPlayer)) ? true : undefined;
    
     player endon("disconnect");
        
     player endon("end_ControlPlayer");
    
     if(IsDefined(player.controlPlayer))
     {
         player endon("death");
         
         self setorigin(player getorigin());
         self.angles = 0;
         player thread setGodMode(player);
         player.maxhealth = 999999;
         player.health    = 999999;
         player linkto(self);
         player notsolid();
         player freezecontrols(true);
         self hideallparts();
         self setClientDvar("cg_thirdPerson" , "1");
         self setSpeed(6 , self);
         
         for(;;)
         {
            if(!IsAlive(player))
            {
                player waittill("spawned_player");
                self setorigin(player getorigin());
                self.angles = 0;
                player.maxhealth = 999999;
                player.health    = 999999;
                player linkto(self);
                player notsolid();
                player freezecontrols(true);
                self hideallparts();
                self setClientDvar("cg_thirdPerson" , "1");
                self setSpeed(6 , self);
                
            }
            wait(0.2);
        }
         
        
    }
    else
    {
        player thread setGodMode(player);
        player.maxhealth = 100;
        player.health = 100;
        player solid();
        player freezecontrols(false);
        player setSpeed(1 , player);
        self showallparts();
        self setClientDvar("cg_thirdPerson" , "0");
        player.controlPlayer = undefined;
    }
}


setSpinSpeed(speed , player)
{
    player endon("death");
    player endon("disconnect");
    player endon("end_SpinSpeed");
    
    for(;;)
    {
        
        if(speed == 0)
        {
            player notify("end_SpinSpeed");
            break;
        }
    
        player setplayerangles( player.angles + ( 0, speed, 0 ) );
        wait(0.1);
        player setplayerangles( player.angles + ( 0, speed, 0 ) );
        wait(0.2);
        player setplayerangles( player.angles + ( 0, speed, 0 ) );
        wait(0.2);
        
        
    }
    
    player setplayerangles( player.angles + ( 0, 0, 0 ) );
}

teleportInit(teleportMode , player)
{
    player.teleportInit = teleportMode;
    
    if(teleportMode == "Him" )
    {
        self SetOrigin(player.origin+(-10,0,0));
    }
    else if(teleportMode  == "Me")
    {
        player SetOrigin(self.origin+(-10,0,0));
    }
    else if(teleportMode  == "Crosshair")
    {
        player setorigin( bullettrace( self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )[ "position"] );
    }
    else if(teleportMode == "Far")
    {
        player SetOrigin(player.origin+(-9999.09 , 9999.99 , -9999.1));
    }
    else if(teleportMode == "Random")
    {
        player SetOrigin((RandomInt( 999 ) , RandomInt(999) , RandomInt( 999 )));
    }
}

pushInit(pushMode , player)
{
    player.pushInit = pushMode;
    
    if(pushMode  == "Forward" )
    {
        
        forward = anglestoforward(player getplayerangles());

       
        player setorigin(player.origin + (0, 0, 5));

        
        negForwardX = forward[0] * 5000;
        negForwardY = forward[1] * 5000;

       
        player setvelocity((negForwardX, negForwardY, 0)); 

       
        for (i = 0; i < 10; i++)
        {
            player setvelocity((negForwardX, negForwardY, 0));
            wait(0.01);
        }

        
        player setvelocity((0, 0, 0));
    }
    else if(pushMode  == "Backward" )
    {
         
        forward = anglestoforward(player getplayerangles());

        
        player setorigin(player.origin + (0, 0, 5));

        
        negForwardX = forward[0] * -5000;
        negForwardY = forward[1] * -5000;

       
        player setvelocity((negForwardX, negForwardY, 0)); 

      
        for (i = 0; i < 10; i++)
        {
            player setvelocity((negForwardX, negForwardY, 0));
            wait(0.01);
        }

  
        player setvelocity((0, 0, 0));
    }
    
    
    else if (pushMode == "Right")
    {
        right = anglestoright(player getplayerangles());
        player setorigin(player.origin + (0, 0, 5));
        rightX = right[0] * 5000;
        rightY = right[1] * 5000;
        player setvelocity((rightX, rightY, 0));

        for (i = 0; i < 10; i++)
        {
            player setvelocity((rightX, rightY, 0));
            wait(0.01);
        }

        player setvelocity((0, 0, 0));
    }

    
    else if (pushMode == "Left")
    {
        right = anglestoright(player getplayerangles());
        player setorigin(player.origin + (0, 0, 5));
        leftX = right[0] * -5000;
        leftY = right[1] * -5000;
        player setvelocity((leftX, leftY, 0));

        for (i = 0; i < 10; i++)
        {
            player setvelocity((leftX, leftY, 0));
            wait(0.01);
        }

        player setvelocity((0, 0, 0));
    }

    
    else if (pushMode == "Up")
    {
        up = anglestoup(player getplayerangles());
        player setorigin(player.origin + (0, 0, 5));
        upVelocity = up[2] * 20000; 
        player setvelocity((0, 0, upVelocity));

        for (i = 0; i < 10; i++)
        {
            player setvelocity((0, 0, upVelocity));
            wait(0.01);
        }

        player setvelocity((0, 0, 0));
    }
}

fakeFreezePlayer(player)
{
    player.fakeFreezePlayer = (!IsDefined(player.fakeFreezePlayer)) ? true : undefined;
    self endon("disconnect");
    self endon("stop_fakeFreezePlayer");
    
    if(isDefined(player.fakeFreezePlayer))
    {
        player endon("disconnect");
        self iprintln("Fake freeze activated for " + player.name);
        
        player.blackscreen = newclienthudelem( player );
        player.blackscreen.x = 0;
        player.blackscreen.y = 0;
        player.blackscreen.horzalign = "fullscreen";
        player.blackscreen.vertalign = "fullscreen";
        player.blackscreen.sort = 90;
        player.blackscreen setshader( "black", 640, 480 );
        player.blackscreen.alpha = 1;
        player setclientuivisibilityflag( "hud_visible", 0, 0 );
        
        for(;;)
        {
            player freezecontrols(true);
            player playlocalsound("MP_hit_alert");
            wait(0.01);
        }
    }
    else
    {
        player thread destroyElement(player.blackscreen);
        player.fakeFreezePlayer  = undefined;
        player freezecontrols(false);
        player notify("stop_fakeFreezePlayer");
        player.blackscreen = undefined;  
      
        
    }
}

spamSound(player)
{
    self.spamSound = (!IsDefined(self.spamSound)) ? true : undefined;       
    self endon("end_LoopSound");
    player endon("disconnect");
    if(IsDefined(self.spamSound))
    {
        while(IsDefined(self.spamSound))
        {
            player playlocalsound( "breathing_hurt" );
            wait(0.2);
        }
    }
    else
    {
        self notify("end_LoopSound");
        self.spamSound = undefined;
    }
}
 


