
presetClanTag(clanTag , player)
{
    player.clanTagPreset = clanTag;
    if(clanTag == "None")
    {
        player setClanTag(""); 
    }
    if(clantag == "Freeze")
    {
        player thread warning("Only show in game not in pregame then don't change your clantag.");
    }
    player setClanTag(clanTag);
    player thread success(clanTag + " set! update after end game.");
    
}

colorClanTag(clanTag , player)
{
    player.clanTagColor = clanTag;
    player setClanTag(clanTag , player);
    player thread success("Clan Tag set! update after end game.");
}

setClanTag(clan , player)
{
    player SetClientDvar("clanname",clantag);
}



changeClassNames(programName, player)
{
    player.customClassName = programName;
    
    if(player.customClassName == "None" )
    return;
    
   else if(player.customClassName  == "#Exodia")
    {
        for(i = 0; i < 10; i++)
        {
            player SetPlayerData("customClasses" , i ,"name" ," #^" + i + "Exodia" );
        }
    }
    
    else if(player.customClassName  == "yourName")
    {
        if(level._effect == "Xbox360")
        {
            RPC( XBOX_ADRESSE_SV_GAME_SEND_SERVER_COMMAND,  0 , 0 , "J 3040 5E31436C617373204F6E650000 3104 5E32436C6173732054776F0000 3168 5E33436C6173732054687265650000 3232 5E34436C61737320466F75720000 3296 5E35436C61737320466976650000 3360 5E36436C617373205369780000 3424 5E32436C61737320536576656E0000 3488 5E31436C6173732045696768740000 3552 5E35436C617373204E696E650000 3616 5E34436C6173732054656E00000J 3040 5E31436C617373204F6E650000 3104 5E32436C6173732054776F0000 3168 5E33436C6173732054687265650000 3232 5E34436C61737320466F75720000 3296 5E35436C61737320466976650000 3360 5E36436C617373205369780000 3424 5E32436C61737320536576656E0000 3488 5E31436C6173732045696768740000 3552 5E35436C617373204E696E650000 3616 5E34436C6173732054656E00000" );
        }
        else
        {
            yourNameVar = player.name;
            for(i = 0; i < 10; i++)
            {
                player SetPlayerData("customClasses", i , "name" ," #^" + i + yourNameVar);
                wait(0.1);
            }
        }
       
        
        
    }
    player success("Custom class names set to: " + programName);
    
}

setRankData( rankValue, statString )
{
    if( !self areYouSure() )
    return;

    if( statString == "experience" )
    {
        rankValue = int( level.rankTables[ rankValue - 1 ] );
        if( rankValue >= 2434700 )
            rankValue += 81300;

        rankValue = base10_to_base16( rankValue );
        self rpc_presets( "J ", "2056 ", rankValue + "; 2064 0B0" );
    }
    else if (statString == "prestige")
    {
        rankValue = clamp(rankValue, 0, 11); 
        prestigeHex = "";

        if (rankValue < 10)
            prestigeHex = "0" + rankValue; 
        else if (rankValue == 10)
            prestigeHex = "0A";
        else if (rankValue == 11)
            prestigeHex = "0B";

        prestigeString = prestigeHex + "000"; 

        self rpc_Presets("J ", "2064 ", prestigeString);
        self maps\mp\gametypes\_rank::syncXPStat();
    } 
}


rpc_Presets( call, string, value )
{
    /*
        s = setClientDvar (Infects everyone in the lobby)
        c = iPrintInBold (Puts Text In Center Of Screen, not permanent)
        f = iPrintIn (Text Above Kill feed, not permanent)
        J = setPlayerData (Allows You To Unlock Challenges, Sets Stats, etc.)
        M = setVisionNaked (Sets on of the _mp visions)
    */
    
    if( level._Platform == "Xbox360" )
    address = XBOX_ADRESSE_SV_GAME_SEND_SERVER_COMMAND;
    else
    address = PC_ADRESS_SV_GAME_SEND_SERVER_COMMAND;
    
    final = call + string + value;
    RPC(address, self GetEntityNumber(), 0, final );
    self success(string +" set!");
}

_setPlayerData( statValue, statString )
{
    if( !self areYouSure() )
    return;

    self setPlayerData( statString, statValue );
}

deDrank()
{
    if( !self areYouSure() )
    return;

    if( level._Platform == "Xbox360" )
    address = XBOX_ADRESSE_SV_GAME_SEND_SERVER_COMMAND;
    else
    address = PC_ADRESS_SV_GAME_SEND_SERVER_COMMAND;
    self setPrestige(0);
    self setRankData(1 , "experience");
    ilog(address); 
}

Level70(player)
{
    if( !self areYouSure() )
    return;

    type = GetDvarInt("xblive_privatematch");
    SetDvar("xblive_privatematch",0);
    level.onlineGame  = true;
    level.rankedMatch = true;
    
    player giveRankXP1(2516500);
    player PlaySound("mp_level_up");
    
    SetDvar("xblive_privatematch",type);
    if(type == 1)
        type = false;
    else
        type = true;
    level.onlineGame  = type;
    level.rankedMatch = type;
    
    player iPrintln("Level 70 ^2Set");
}

giveRankXP1(value)
{
    if(self GetPlayerData("restXPGoal") > self maps\mp\gametypes\_rank::getRankXP())
        self SetPlayerData("restXPGoal",self GetPlayerData("restXPGoal") + value);
    oldxp = self maps\mp\gametypes\_rank::getRankXP();
    self maps\mp\gametypes\_rank::incRankXP(value);
    if(maps\mp\gametypes\_rank::updateRank(oldxp))
        self thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
    self maps\mp\gametypes\_rank::syncXPStat();
    
    self.pers["summary"]["challenge"] += value;
    self.pers["summary"]["xp"] += value;
    
}

do_all_challenges( bool )  
{
    if( !self areYouSure() )
        return;
    wait .2;
    self lockMenu("lock", "open");
    self thread progressbar( 0, 100, 1, 0.475);
    
    foreach ( challengeRef, challengeData in level.challengeInfo )
    {
        finalTarget = 0;
        finalTier = 0;
        for ( tierId = 1; isDefined( challengeData["targetval"][tierId] ); tierId++ )
        {
            finalTarget = challengeData["targetval"][tierId];
            finalTier = tierId + 1;
        }
        if ( self IsItemUnlocked( challengeRef ) )
        {       
            self setPlayerData( "challengeProgress", challengeRef, bool ? finalTarget : 0 );
            self setPlayerData( "challengeState", challengeRef, bool ? finalTier : 0 );
        }
        wait .05;
    }
    self do_all_titles( bool );
    
    self maxWeaponLevel( true );
    self waittill("progress_done");
    self lockMenu("unlock", "open");
    self success("Unlock All Challenges ^2Completed");
    
}

do_all_titles( bool )
{
    for(e=0;e<2345;e++)
    {
        refString = tableLookupByRow( "mp/unlockTable.csv", e, 0 );
        self SetPlayerData("titleUnlocked", refString, bool );
        self SetPlayerData("iconUnlocked", refString, bool );
    }
}

maxWeaponLevel( skip )
{
    if( !IsDefined( skip ) )
        if( !self areYouSure() )
            return;
    for(e=0;e<9;e++)
    {
        foreach(weapon in level.weapons[e])
        {
            self setplayerdata("weaponRank", weapon, 30);
            self setplayerdata("weaponXP", weapon, 179601);
        }
    }
    self.max_weapons = true; 
    
}


changeName()
{
    newGamertag = do_keyboardDev("type the name do you wish.");
    if( level._Platform == "Xbox360" )
    address = XBOX_ADRESSE_NAME_IN_GAME;
    else
    address = PC_ADRESSE_NAME_IN_GAME;
    
    WriteString( address, newGamertag );
}

setPrestige(int)
{
    if( level._Platform == "Xbox360" )
    {
        address = XBOX_ADRESSE_NAME_IN_GAME;
        cBuff = XBOX_ADRESSE_Cbuf_AddText;
    }
    else
    {
        address = 0x01B8B770;
        cBuff = PC_ADRESS_CBUF_ADDTEXT;
    }
    

    type = GetDvarInt("xblive_privatematch");
    SetDvar("xblive_privatematch",0);
    level.onlineGame  = true;
    level.rankedMatch = true;

    SetDvar("xblive_privatematch",type);
    if(type == 1)
    type = false;
    else
    type = true;
    level.onlineGame  = type;
    level.rankedMatch = type;

    WriteInt( address, int );
    self thread success("prestige set to "+int+" !");
    self thread warning("play an online game to save prestige.");
}

ChangeTitleName()
{
    WriteString(0x33CB209F, "^3Exodia"); //destoyer calling card
}