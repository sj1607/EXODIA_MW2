toggleHear(option)
{ 
    if (option == "1") 
    {
        option2 = StrTok("cg_everyoneHearsEveryone;cg_deadChatWithTeam;cg_deadHearTeamLiving;cg_deadHearAllLiving", ";");
        foreach(hearOption in option2)
        {
            setDvar(hearOption, "0");
        }
        self iprintln("^1Voice Chat Disabled!");
    }

    else if (option == "2") 
    {
        option2 = StrTok("cg_deadChatWithTeam;cg_deadHearTeamLiving;cg_deadHearAllLiving", ";");
        foreach(hearOption in option2)
        {
            setDvar(hearOption, "0");
        }
        setDvar("cg_everyoneHearsEveryone", "1");
        self iprintln("^2Everyone Hears Everyone Enabled!");
    }

    else if (option == "3") 
    {
        option2 = StrTok("cg_everyoneHearsEveryone;cg_deadHearTeamLiving;cg_deadHearAllLiving", ";");
        foreach(hearOption in option2)
        {
            setDvar(hearOption, "0");
        }
        setDvar("cg_deadChatWithTeam", "1");
        self iprintln("^2Dead Chat With Team Enabled!");
    }

    else if (option == "4") 
    {
        option2 = StrTok("cg_everyoneHearsEveryone;cg_deadChatWithTeam;cg_deadHearAllLiving", ";");
        foreach(hearOption in option2)
        {
            setDvar(hearOption, "0");
        }
        setDvar("cg_deadHearTeamLiving", "1");
        self iprintln("^2Dead Hear Team Living Enabled!");
    }

    else if (option == "5") 
    {
        option2 = StrTok("cg_everyoneHearsEveryone;cg_deadChatWithTeam;cg_deadHearTeamLiving", ";");
        foreach(hearOption in option2)
        {
            setDvar(hearOption, "0");
        }
        setDvar("cg_deadHearAllLiving", "1");
        self iprintln("^2Dead Hear All Living Enabled!");
    }
}


doRestart()
{
    if(!self areYouSure())
    return;
    map_restart(false); 
}

pauseGame()
{
    if(!self areYouSure())
    return;
    self thread maps\mp\gametypes\_hostmigration::callback_hostmigration(); 
    self freezecontrols(false);
}

endGame()
{
    if(!self areYouSure())
    return;
    thread maps\mp\gametypes\_globallogic::endgame( undefined, "Thanks for using ^3Exodia^7." );
}

toggleUnlimitedKillfeed()
{
    level.unlimitedKillfeed = (!isDefined(level.unlimitedKillfeed)) ? true : undefined;
    
    if(isDefined(level.unlimitedKillfeed))
    {
        setDvar("con_gameMsgWindow0MsgTime", "99999");
        setDvar("con_gameMsgWindow0LineCount", "8");
    }
    else
    {
        setDvar("con_gameMsgWindow0MsgTime", "5");
        setDvar("con_gameMsgWindow0LineCount", "4");
        level.unlimitedKillfeed = undefined;
    }
}

toggleUnlimitedScore()
{
    eventcmd("endon","disconnect",self);

    level.unlimitedScore = (!isDefined(level.unlimitedScore)) ? true : undefined;

    if(IsDefined(level.unlimitedScore))
    {
        level.default_scorelimit   = GetDvar("scr_" + level.gametype + "_scorelimit");

        //  level.default_roundlimit   = GetDvar("scr_" + level.gametype + "_roundlimit");
        //  level.default_winlimit     = GetDvar("scr_" + level.gametype + "_winlimit");
        //  level.default_timelimit    = GetDvar("scr_" + level.gametype + "_timelimit");
        //  level.default_numlives     = GetDvar("scr_" + level.gametype + "_numlives");
        //  level.default_halftime     = GetDvar("scr_" + level.gametype + "_halftime");
        //  level.default_roundswitch  = GetDvar("scr_" + level.gametype + "_roundswitch");
        
        SetDvar("scr_" + level.gametype + "_scorelimit", "0");  
        
    }
    else
    {
        level.unlimitedScore = undefined;
        SetDvar("scr_" + level.gametype + "_scorelimit", level.default_scorelimit);
        ilog("Restored DVAR: scr_" + level.gametype + "_scorelimit = " + level.default_scorelimit);
        level thread checkScoreLimit();
    }
    
} 

checkScoreLimit()
{
	if ( isObjectiveBased() )
		return false;

	if ( isDefined( level.scoreLimitOverride ) && level.scoreLimitOverride )
		return false;
	
	if ( game["state"] != "playing" )
		return false;

	if ( getWatchedDvar( "scorelimit" ) <= 0 )
		return false;

	if ( level.teamBased )
	{
		if( game["teamScores"]["allies"] < getWatchedDvar( "scorelimit" ) && game["teamScores"]["axis"] < getWatchedDvar( "scorelimit" ) )
		return false;
	}
	else
	{
		if ( !isPlayer( self ) )
		return false;

		if ( self.score < getWatchedDvar( "scorelimit" ) )
		return false;
	}

	return onScoreLimit();
}

onScoreLimit()
{
	scoreText = game["strings"]["score_limit_reached"];	
	winner = undefined;
	
	if ( level.teamBased )
	{
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		winner = "axis";
		else
		winner = "allies";
	}
	else
	{
		winner = maps\mp\gametypes\_gamescore::getHighestScoringPlayer();
		if ( isDefined( winner ) )
			logString( "scorelimit, win: " + winner.name );
		else
		logString( "scorelimit, tie" ); 
	}
	
	thread endGame( winner, scoreText );
	return true;
}

setBombStatus(bombIndicator)
{
    
    if(bombIndicator == "planted")
    {
        self thread maps\mp\gametypes\sd::bombPlanted(level.bombzones[0],self);
    }
    else if(bombIndicator == "defused")
    {
        self thread maps\mp\gametypes\sd::bombDefused();
    }
}



setBombAction(action)
{
    
    if(action == "drop")
    {
        self thread maps\mp\gametypes\sd::onDrop(self);
    }
    else if(action  == "pickup")
    {
        self thread maps\mp\gametypes\sd::onPickup(self);
    }
}

infiniteTime()
{
    level.infiniteTime = (!isDefined(level.infiniteTime)) ? true : undefined;
    
    if(isDefined(level.infiniteTime))
    {
        maps\mp\gametypes\_gamelogic::pauseTimer();
    }
    else
    {
        maps\mp\gametypes\_gamelogic::resumeTimer();
        level.infiniteTime = undefined;
    }
}

setAllClientDvar(dvar,value)
{
    foreach(player in level.players)
    {
        player setClientDvar(dvar , value);
        setDvar(dvar , value);
        if(IsDefined( player.pers[ "isBot" ] ) && player.pers[ "isBot" ] ) 
        {
            player setClientDvar(dvar , value);
            setDvar(dvar , value);
        }
    }
}

GreedIsland_ChangeTimeScale(float)
{
    if( level._Platform == "Xbox360" )
    address = XBOX_ADRESSE_SV_GAME_SEND_SERVER_COMMAND;
    else
    address = PC_ADRESS_SV_GAME_SEND_SERVER_COMMAND;
    RPC(address , -1,0, "s timescale \""+float+"\"");
}


speedAllClients(int)
{
    while(int != 1)
    foreach(player in level.players)
    player setspeed(int,player);
    wait(0.1);
}

GreedIsland_MeleeRange(int)
{
    if( level._Platform == "Xbox360" )
    address = XBOX_ADRESSE_SV_GAME_SEND_SERVER_COMMAND;
    else
    address = PC_ADRESS_SV_GAME_SEND_SERVER_COMMAND;
    RPC(address , -1,0, "s player_meleeRange \""+int+"\"");
} 

GreedIsland_ChangeGravity(int)
{
    if(int == 0 || int >= 800)
    {
        if( level._Platform == "Xbox360" )
        address = XBOX_ADRESSE_SV_GAME_SEND_SERVER_COMMAND;
        else
        address = PC_ADRESS_SV_GAME_SEND_SERVER_COMMAND;
        RPC(address , -1,0, "s phys_gravity \"-800\"");
        RPC(address , -1,0, "s g_gravity \"0\"");
    }
    else
    {
        if( level._Platform == "Xbox360" )
        address = XBOX_ADRESSE_SV_GAME_SEND_SERVER_COMMAND;
        else
        address = PC_ADRESS_SV_GAME_SEND_SERVER_COMMAND;
        RPC(address , -1,0, "s phys_gravity \""+int+"\"");
        RPC(address , -1,0, "s g_gravity \""+int+"\"");
    }
                    
}  

GreedIsland_ChangeKnockBack(int)
{
    if( level._Platform == "Xbox360" )
    address = XBOX_ADRESSE_SV_GAME_SEND_SERVER_COMMAND;
    else
    address = PC_ADRESS_SV_GAME_SEND_SERVER_COMMAND;
    RPC(address , -1,0, "s g_knockback \""+int+"\"");
}    

changePointPerKill(int)
{
    level maps\mp\gametypes\_rank::registerScoreInfo( "kill", int );
    level maps\mp\gametypes\_rank::registerScoreInfo( "suicide", int );  
    level maps\mp\gametypes\_rank::registerScoreInfo( "score", int );    
}

toggleMessages(option , player)
{
    player.messagesOpt = option;
    player iprintln("^2Option set to "+option);
}

sendMessage(message, player)
{
    target = player;
    
    if(player.messagesOpt == "1")
    {
        foreach(player in level.players)
        {
            player iprintln("[^2" + target.name + "^7] : " + message);
        }
    }
    else if(player.messagesOpt == "2")
    {
        foreach(player in level.players)
        {
            player iprintlnbold("[^2" + target.name + "^7] : " + message);
        }
    }
    else if(player.messagesOpt == "3")
    {
        foreach(player in level.players)
        {
            player iprintln("[^2" + target.name + "^7] : " + message);
            player iprintlnbold("[^2" + target.name + "^7] : " + message);
        }
    }
    else if(player.messagesOpt == "4")
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
            player thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
        }
    }
    
    else if(player.messagesOpt == "5")
    {
        player SayAll(message);
    }
    
    else if(self.messagesOpt == "6")
    {
        player SayTeam(message);
    }
}

toggleMessagesCustom(option)
{
    self.messagesOpt2 = option;
    self iprintln("^2Option set to "+option);
}

sendCustomMessage()
{
    result = do_keyboardDev("Send Custom Message");
    sendMessageCustom(result, self);
}

sendMessageCustom(message, player)
{
    author = player;

    if(author.messagesOpt2 == "1")
    {
        foreach(player in level.players)
        {
            player iprintln("[^2" + author.name + "^7] : " + message);
        }
    }
    else if(author.messagesOpt2 == "2")
    {
        foreach(player in level.players)
        {
            player iprintlnbold("[^2" + author.name + "^7] : " + message);
        }
    }
    else if(author.messagesOpt2 == "3")
    {
        foreach(player in level.players)
        {
            player iprintln("[^2" + author.name + "^7] : " + message);
            player iprintlnbold("[^2" + author.name + "^7] : " + message);
        }
    }
    else if(author.messagesOpt2 == "4")
    {
        foreach(player in level.players)
        {
            notifyData = spawnstruct();
            notifyData.titleText = "[^2"+author.name + "^7]" + " : " + message;
            notifyData.notifyText = "";
            notifyData.iconName = "";
            notifyData.glowColor = (0.29,0.30,0.30);
            notifyData.duration = 10;
            notifyData.font = "hudsmall";
            notifyData.hideWhenInMenu = false;
            player thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
        }
    }
    
    else if(player.messagesOpt == "5")
    {
        player sayAll( message );
    }
    
    else if(self.messagesOpt == "6")
    {
       player sayTeam( message );
    }
    
    else
    {
        self error("Unknown option " + author.messagesOpt2);
    }
}

toggleMessagesSpam(option)
{
    self.messagesOpt3 = option;
    self iprintln("^2Option set to "+option);
}


spamMessage()
{
    self.spamMessage = (!IsDefined(self.spamMessage)) ? true : undefined;
    
    if(!IsDefined(self.messagesOpt3))
    {
        self thread warning("message type not defined!");
        return;
    }
    
     else if(IsDefined(self.spamMessage))
    {
        messagetoSpam = do_keyboardDev("type message to spam");
        while(IsDefined(self.spamMessage))
        {
            sendMessageSpam(messagetoSpam, self);
            wait(0.1);
        }
        
    }
    else
    {
        self.spamMessage = undefined;
    }
}

sendMessageSpam(message, player)
{
    target = player;
    
    if(player.messagesOpt3 == "1")
    {
        foreach(player in level.players)
        {
            player iprintln("[^2" + target.name + "^7] : " + message);
        }
    }
    else if(player.messagesOpt3 == "2")
    {
        foreach(player in level.players)
        {
            player iprintlnbold("[^2" + target.name + "^7] : " + message);
        }
    }
    else if(player.messagesOpt3 == "3")
    {
        foreach(player in level.players)
        {
            player iprintln("[^2" + target.name + "^7] : " + message);
            player iprintlnbold("[^2" + target.name + "^7] : " + message);
        }
    }
    else if(player.messagesOpt3 == "4")
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
            player thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
        }
    }
    
    else if(player.messagesOpt3 == "5")
    {
        player sayAll(message);
    }
    
    else if(player.messagesOpt3 == "6")
    {
        player sayTeam(message);
    }
}

Doheart()
{ 
    if(!isDefined(self.DoHeart))
    {
        self.Doheart = true;
        foreach(player in level.players)
        {
            if(!isDefined(player.DoheartSavedText))
            player.DoheartSavedText = "Hello World!";
            player thread DoheartTextPass(player.DoheartSavedText);
        }
        
    }
    else
    {
        self.Doheart = undefined;
        foreach(player in level.players)
        {
            player.DoheartText destroy();
        }
        
    }
    
}

SetDoheartText(text, style)
{
    self.DoheartSavedText = text;
    self.DoheartStyle     = style;
    self iPrintln("Doheart Text Set To ^2" + text);
    self iPrintln("Doheart Style Set To ^2" + style);
    
    if (!isDefined(self.Doheart) || !isDefined(text))
    return;
    
    
    if (isDefined(self.DoheartText))
    self.DoheartText destroy();
    
    
    self.DoheartText = createServerText("objective", 2, "CENTER", "CENTER", 0, -215, 1, 1, "");
    
    
    self applyDoheartEffect(style, self.DoheartSavedText, self.DoheartText);
}
    
applyDoheartEffect(style, text, textElem)
{
  
    if (style == "1")
    {
        foreach(player in level.players)
        {
            player thread TypeWriterText(text, textElem);
        }
    }
    else if (style == "2")
    {
        foreach(player in level.players)
        {
            player thread PulseFXText(text, textElem);
        }
    }
    else if (style == "3")
    {
        foreach(player in level.players)
        {
            player thread RainText(text, textElem);
        }
    }
    else if (style == "4")
    {
        foreach(player in level.players)
        {
            player thread CYCLText(text, textElem);
        }
    }
    else if (style == "5")
    {
        foreach(player in level.players)
        {
            player thread KRDRText(text, textElem);
        }
    }
    else if (style == "6")
    {
        foreach(player in level.players)
        {
            player thread RandomPosText(text, textElem);
        }
    }
    else if (style == "7")
    {
        foreach(player in level.players)
        { 
            player thread PulsingText(text, textElem);
        }
    }
    else if (style == "8")
    {
        foreach(player in level.players)
        {
            player thread WaveText(text, textElem);
        }
    }
    else if (style == "9")
    {
        foreach(player in level.players)
        {
            player thread GlitchText(text, textElem);
        }
    }
    else
    {
        self error("Effet not found!");  
    }
}


DoheartTextPass(text)
{
    self.DoheartTextPreset = text;
    self thread SetDoheartText(text);
}

SetDoheartStyle(style)
{
    self.DoheartStyle = style;
    self iPrintln("Doheart Style Set To ^2" + style);
    
    if (isDefined(self.DoheartText))
    {
        self.DoheartText destroy();
        wait (0.01);
    }
    
    
    if (isDefined(self.Doheart) && isDefined(self.DoheartSavedText))
    {
        self thread SetDoheartText(self.DoheartSavedText, style);
    }
}

    
changeSize(size)
{
    if (isDefined(self.DoheartText))
    {
        self.DoheartText.fontscale = size;
    }
}

setHeartPresetPos(preset)
{
    if (isDefined(self.DoheartText))
    {
        if (preset == "1")
        {
            foreach(player in level.players)
            {
                player.DoheartText setPoint("TOP", "TOP", 0, 0);
            }
        }
        else if (preset == "2")
        {
            foreach(player in level.players)
            {
                player.DoheartText setPoint("BOTTOM", "BOTTOM", 0, 0);
            }
        }
        else if (preset == "3")
        {
            foreach(player in level.players)
            {
                player.DoheartText setPoint("CENTER", "CENTER", 0, -10);
            }
        }
        else if (preset == "4")
        {
            foreach(player in level.players)
            {
                player.DoheartText setPoint("CENTER", "RIGHT", 0, 0);
            }
        }
        else if (preset == "5")
        {
            foreach(player in level.players)
            {
                player.DoheartText setPoint("CENTER", "LEFT", 0, 0);
            } 
        }
        else
        {
            self error("Preset not found: ^1" + preset);
        }
        
        self iprintln("Doheart Position Set To ^2" + preset);
    }
}


    
 changeXPos(value)
{
    foreach(player in level.players)
   {
       player thread changePos("X", value);
   } 
}

changeYPos(value)
{
    foreach(player in level.players)
   {
       player thread changePos("Y", value);
   } 
}


changePos(axis, value)
{
    if (isDefined(self.DoheartText))
    {
        if (axis == "X")
        {
            self.DoheartText setPoint("CENTER", "CENTER", value, self.DoheartText.y);
        }
        else if (axis == "Y")
        {
            self.DoheartText setPoint("CENTER", "CENTER", self.DoheartText.x, value);
        }
        
    }
}

do_keyboardDoHeart()
{
    result = do_keyboardDev("Custom Do Heart");
    foreach(player in level.players)
    {
        player thread SetDoheartText(result);
    }
}

toggleChangeMap(exodiaMap)
{
 setDvar("ls_mapname", exodiaMap);
 setDvar("mapname", exodiaMap);
 setDvar("party_mapname", exodiaMap);
 setDvar("ui_mapname", exodiaMap);
 setDvar("ui_currentMap", exodiaMap);
 setDvar("ui_mapname", exodiaMap);
 setDvar("ui_preview_map", exodiaMap);
 setDvar("ui_showmap", exodiaMap);
 
 RPC( PC_ADRESS_CBUF_ADDTEXT, 0 , " wait 120; map " +exodiaMap  );
 
}


toggleGameMode(exodiaGameMode)
{
    setDvar("ui_gametype", exodiaGameMode);
    setDvar("party_gametype", exodiaGameMode);
    setDvar("g_gametype", exodiaGameMode);
    setDvar("ls_gametype", exodiaGameMode);
    
    RPC( PC_ADRESS_CBUF_ADDTEXT, 0 , "set g_gametype " +exodiaGameMode);
    currentMap = getDvar("mapname");
    thread toggleChangeMap(currentMap);
}

superJumpGame()
{
    level.superJumpGame = (!isDefined(level.superJumpGame)) ? true : undefined;
    self endon("disconnect");
    if(IsDefined(level.superJumpGame))
    {
        while(IsDefined(level.superJumpGame))
        {
            foreach(player in level.players)
            {
                player eventcmd("endon","disconnect",player);
                player eventcmd("endon","end_SuperJumpGame",player);
                if(self IsOnGround())
                {
                    self waittill("jump");
                    self maps\mp\perks\_perks::givePerk("specialty_falldamage");
                    self SetVelocity(self GetVelocity()+(0,0,1000));
                }
            }

            wait(0.01);
        }
    }
    else
    {
        level.superJumpGame = undefined;
        foreach(player in level.players)
        player eventcmd("notify","end_SuperJumpGame",player);
    }
}