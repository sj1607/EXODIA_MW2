godModeAllClients()
{
    
    
    self.godModeAllClients = (!IsDefined(self.godModeAllClients)) ? true : undefined;

    if (self.godModeAllClients)
    { 
       
        foreach (player in level.players)
        {
            player thread healthMode("god");
           
        }
    }
    else
    {
        foreach (player in level.players)
        {
            player thread healthMode("off");
           
        }
        
        self.godModeAllClients = undefined;
    }
}






unlimitedAmmoAllClients()
{
    self.unlimitedAmmoAllClients = (!IsDefined(self.unlimitedAmmoClients)) ? true : undefined;
    
    if(self.unlimitedAmmoAllClients)
    {
        foreach(player in level.players)
        {
            player.ammoOpt = "unlimited";
            player thread ammoMode("unlimited");
        }
    }
    else
    {
        self.unlimitedAmmoAllClients = undefined;
        foreach(player in level.players)
        {
            player.ammoOpt = "off";
            player thread ammoMode("off");
        }
       
    }
    
}


allPerksAllClients()
{
    self.allPerksAllClients = (!IsDefined(self.allPerksAllClients)) ? true : undefined;
    
    if(self.allPerksAllClients)
    {
        foreach(player in level.players)
        {
            player thread giveAllPerks(player);
            
        }
    }
    else
    {
        self.allPerksAllClients = undefined;
        foreach(player in level.players)
        {
            
            player ClearPerks();
        }
       
    }
    
}



constantUAVAllClients()
{
    self.constantUAVAllClients = (!IsDefined(self.constantUAVAllClients)) ? true : undefined;
    
    if(self.constantUAVAllClients)
    {
        foreach(player in level.players)
        {
            player thread setRadar("3" , player);
        }
    }
    else
    { 
        foreach(player in level.players)
        {
            player thread setRadar("1" , player);
        }
        self.constantUAVAllClients = undefined;
    }
    
}

allClientsTp(tpMode)
{
    self.allClientsTpMode = tpMode;
    
    if(tpMode == "me")
    {
        foreach(player in level.players)
        {
            if(player isHost())
            {
                continue;
            }
            else
            {
                myOrigin = self getOrigin();
                player setOrigin(myOrigin);
            }
        }
    }
    else if(tpMode == "cross")
    {
        foreach(player in level.players)
        {
            if(player isHost())
            {
                continue;
            }
            else
            {
                player setOrigin(BulletTrace(self gettagorigin("j_head"),self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000,0,self)["position"]);
            }
        }
         
    }
    else if(tpMode == "random")
    {
        foreach(player in level.players)
        {
            if(player isHost())
            {
                continue;
            }
            else
            {
                playerOrigin = player getOrigin();
                
                
                randomRange = 500; 
                
               
                randomX = randomInt(randomRange * 2) - randomRange;
                randomY = randomInt(randomRange * 2) - randomRange;
                randomZ = 100; 
                
               
                newPosition = (playerOrigin[0] + randomX, playerOrigin[1] + randomY, playerOrigin[2] + randomZ);
                
               
                player setOrigin(newPosition);
            }
        }
    }
}



allClientsFreeze(mode)
{ 
    self.allClientsFreezeMode = mode;
    
    if(mode == "none")
    {
        foreach(player in level.players)
        {
            player freezeControls(false);
        }
    }
    else if(mode == "controls")
    {
        foreach(player in level.players)
        {
            if(player IsHost())
            {
                continue;
            }
            player freezeControls(true);
        }
    }
    else if(mode == "game")
    {
        foreach(player in level.players)
        {
            for(f = 0; f < 10; f++)
            {
                textFreeze = "^H@@@@";
                player iPrintlnBold(textFreeze);
                player iprintln(textFreeze);
                wait(0.1);
            }
        }
    }
}

allClientsSanction(mode)
{
    self.allClientsSanctionMode = mode;
    
    if(mode == "kick")
    {
        foreach(player in level.players)
        {
            player sanctionMode("kick", player);
        }
    }
    else if(mode == "ban")
    {
        foreach(player in level.players)
        {
            player sanctionMode("ban", player);
        }
    }
}