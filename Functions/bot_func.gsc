initTestClient(int, teamIndicator)
{
    for(e = 0; e < int; e++)
    {
        bot = addtestclient();
        wait .2;
        if(!isdefined(bot))
        continue;
        bot.pers["isBot"] = true;
        
        bot setPlayerData("prestige", randomInt(11));
        bot setplayerdata("experience", randomInt(2516000));     
        bot SetRank(bot maps\mp\gametypes\_rank::getRankForXP(bot getPlayerData("experience")), bot getPlayerData("prestige"));
    
        if (teamIndicator == "same")
        {
            botTeam = self.team; 
        }
        else if (teamIndicator == "opposite")
        {
            botTeam = (self.team == "allies") ? "axis" : "allies"; 
        }
        else
        {
            botTeam = "allies"; 
        }
        
        bot thread spawnTestClient(botTeam);

        level.bot_settings = ["doMove", "doAttack", "watchKillcam", "doCrouch", "doReload"];

        bot manage_bots("doMove");
        bot manage_bots("doAttack");
        bot manage_bots("watchKillcam");
        bot manage_bots("doCrouch");
        bot manage_bots("doReload");
    }
}

spawnTestClient(team)
{
    wait .05;
    self notify("menuresponse", game["menu_team"], team);
    wait .2;
    self notify("menuresponse", "changeclass", "class" + randomInt( 5 ));
}

manage_bots( action )
{
    if(!isDefined( level.bot_settings ))
        level.bot_settings = [];
        
    if(!IsDefined( level.bot_settings[ action ] ))
    {
        level.bot_settings[ action ] = true;
        setDvar( "testClients_" + action, 1 ); 
    }
    else 
    {
        level.bot_settings[ action ] = undefined;
        setDvar( "testClients_" + action, 0 );
    }
}

kickBots()
{
    foreach( player in level.players )
    {
        if( isDefined( player.pers[ "isBot" ] ) && player.pers[ "isBot" ] ) 
        kick( player getEntityNumber(), "EXE_PLAYERKICKED" );
    }
}

killBots()
{
    foreach( player in level.players )
    {
        if( isDefined( player.pers[ "isBot" ] ) && player.pers[ "isBot" ] ) 
        player Suicide();
    }
}

freezeBots()
{
    level.freezeBots = (!IsDefined( level.freezeBots)) ? true : undefined;
    
    if(isDefined(level.freezeBots))
    {
        howManyBots = BotCounter();
        if(howManyBots >= 10)
        self thread Warning("There are a lot of bots in the game, this can crash your game.");
        while(isDefined(level.freezeBots))
        {
            foreach(player in level.players)
            {   
                player endon("GreedIsland_StopFreezeBots");
                if(isDefined(player.pers["isBot"]))
                {
                    player freezecontrols(true); 
                }
            }
            wait (0.1);      
        }
    }
    
    else
    {
        level.freezeBots = undefined; 
        foreach(player in level.players)
        {
            if(isDefined(player.pers["isBot"]) )
            {
                player freezecontrols(false);
                player notify("GreedIsland_StopFreezeBots");
            }
        }
    }
}

tpBot()
{
    foreach(player in level.players)
    {
            
      if(IsDefined(player.pers["isBot"]))
      {
        player setOrigin(bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000,0,self)["position"]);
      }
    }
}

spawnPointBots()
{
    self endon("GreedIsland_StopSpawnPoint"); 
    
    level.customBotSpawn = (!IsDefined(level.customBotSpawn)) ? true : undefined;
    
    if (isDefined(level.customBotSpawn))
    {
        self thread detectBotSpawn();  
    }
    else
    {
        self notify("GreedIsland_StopSpawnPoint"); 
        level.customBotSpawn = undefined;
    }
}

detectBotSpawn()
{
    self endon("GreedIsland_StopSpawnPoint"); 
    self BeginLocationSelection("map_artillery_selector",false);
    self.selectingLocation = true;
    self waittill("confirm_location", location);
    newLocationSpawn = BulletTrace(location + (0, 0, 10), location, 0, self)["position"]; 
    self endLocationSelection();
    self.selectingLocation = undefined;
    self success("Spawn Set!");
    
    for(;;)
    {
        
        foreach(player in level.players)
        {
            
           if(IsBot(player) && !IsAlive(player))
           {
                player waittill("spawned_player");
                player SetOrigin(newLocationSpawn); 
                player SetPlayerAngles((0, 0, 0));
                
           }
           continue; 
             
        }
         
        wait(0.01);
    }
}

godModeBot()
{
    level.godModeBot = (!IsDefined(level.godModeBot)) ? true : undefined;
    
    if(level.godModeBot)
    {
        
        eventCmd("endon","end_godModeBot", level);
        for(;;)
        {
            foreach(player in level.players)
            {
                
                if (!IsBot(player))
                {
                    continue;
                }
                
                
                eventCmd("endon", "disconnect", player);
                
               
                player.maxhealth = 999999;
                if (player.health < player.maxhealth)
                {
                    player.health = player.maxhealth;
                }
            }
            wait(0.1);
        }
        
        
    }
    else
    {
        foreach(player in level.players)
        {
           
            if (!IsBot(player))
            {
                continue;
            }
            
            
            if(player.maxhealth > 100)
            {
                
                player.maxhealth = 100;
                player.health    = player.maxhealth;
            }
            
        }
        
        eventCmd("notify", "end_godModeBot", level);
        
        level.godModeBot = undefined;
    }
}


speedBot(int)
{
    foreach(player in level.players)
    {
        if(!IsBot(player))
        {
            continue;
            
        }
        
        player setmovespeedscale(int); 
    }
}
