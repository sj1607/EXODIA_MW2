#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;



init()
{
    level thread onPlayerConnect();
    level loadarrays();
    
    level.strings  = [];
    level.status   = strtok("None;VIP;Admin;Co-Host;Host;Owner" , ";");
    level.menuName = "";
    
    level._Platform = getPlatform();
    setExodiaIMG();
    //setExodiaTest();
    //setExodiaTransparentIMG();
    
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
       
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    level endon("game_ended");
    self waittill("spawned_player");
        
    if(self isHost())
    {
        self.status = "Host";
        self FreezeControls( false );
        
        self thread initializeSetup( 4 , self );
        self thread exit();
        self thread menuBoxInit();

        if(level._Platform == "PC")
        {
            WriteString(PC_ADRESSE_START_MATCH_MESSAGE , "Start the hack." );
            RPC(PC_ADRESS_CBUF_ADDTEXT, 0, "r_vsync 0;com_maxfps 1000");
        }
        //ChangeTitleName();
        
      
    }
    else
    {
        self.status = "None";
    }
    
}



overflowfix()
{
    level.overflow       = newHudElem();
    level.overflow.alpha = 0;
    level.overflow setText( "marker" );

    for(;;)
    {
        level waittill("CHECK_OVERFLOW");
        if(level.strings.size >= 20)
        {
            
            level.overflow ClearAllTextAfterHudElem();
            level.strings = [];
            level notify("FIX_OVERFLOW");
           
        }
        
       
    }
}

initWelcomeHUD()
{
    
    if (!isDefined(self.welcome))
    {
        self.welcome = [];
    }

    if (!isDefined(self.welcome["UI_BAR"]))
    {
        self.welcome["UI_BAR"] = [];
    }

       
    if (!isDefined(self.presets) || !hasKeysArray(self.presets))
    {
        load_presets();
    }

    self.welcome["UI_BAR"]["WELCOME_BAR2"] = self createRectangle("LEFT", "LEFT", 0, 0, 251, 50, self.presets["TITLE_OPT_BG"], "white", 1, 1); //x = -L/+R, y = -U/+D
    self.welcome["UI_BAR"]["WELCOME_BAR_GREEN"] = self createRectangle("LEFT", "LEFT", 0, 0, 2, 50, self.presets["SCROLL_STITLE_BG"], "white", 2, 1); //x = -L/+R, y = -U/+D
    self.welcome["UI_BAR"]["WELCOME_BAR2_GREEN"] = self createRectangle("LEFT", "LEFT", 250, 0, 2, 50, self.presets["SCROLL_STITLE_BG"], "white", 2, 1); //x = -L/+R, y = -U/+D
    self.welcome["UI_BAR"]["WELCOME_BAR3_GREEN"] = self createRectangle("LEFT", "LEFT", 0, -25, 252, 2, self.presets["SCROLL_STITLE_BG"], "white", 2, 1); //x = -L/+R, y = -U/+D
    self.welcome["UI_BAR"]["WELCOME_BAR4_GREEN"] = self createRectangle("LEFT", "LEFT", 0, 25, 252, 2, self.presets["SCROLL_STITLE_BG"], "white", 2, 1); //x = -L/+R, y = -U/+D
  
        
    self.msg = self createFontString("default", 1.4);
    self.msg setPoint("LEFT", "LEFT", 60, 0); 
    self.msg.foreground     = true;
    self.msg.sort           = 0; 
    self.msg.hidewheninmenu = true;
    self.msg.archived       = false;
    self.msg setText("Welcome To ^3Exodia ^7" + self.name);
       
        
    if (!isDefined(self.isCycling) || !self.isCycling)
    {
        self.isCycling = true;
        self thread cycleTextMessages();
    }
    


}

cycleTextMessages()
{ 
    self endon("disconnect");
    self endon("stopCycling");
   
    
    while (self.isCycling)
    {

        if(level._Platform == "PC")
        {
            self.msg setPoint("LEFT", "LEFT", 60, 0);
            self.msg setText("Welcome To ^3Exodia ^7" + self.name);
            
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 30, 0);
            self.msg setText("Press [{+speed_throw}] & [{+melee}] To Open Menu.");
            
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 8, 0);//x = -L/+R, y = -U/+D
            
            self.msg setText("Press [{+gostand}] To Select Or [{+usereload}] To Go Back.");
            
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 30, 0);//x = -L/+R, y = -U/+D
            
            
            self.msg setText("Press [{+actionslot 1}] To Sroll Up or [{+actionslot 2}] To Scroll Down.");
            
            wait 5;
            self.msg setPoint("LEFT", "LEFT", 30, 0);
            self.msg setText("Press [{+actionslot 3}] To Sroll Right or [{+actionslot 4}] To Scroll Left.");
        
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 40, 0);//x = -L/+R, y = -U/+D
            
            self.msg setText("^3Download ^7: ^1I^7nfinity^1L^7oader.com");
            
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 80, 0);//x = -L/+R, y = -U/+D
            self.msg setText("^6Discord ^7: ^7Littof");
            
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 40, 0);//x = -L/+R, y = -U/+D
            self.msg setText("^7MW2 MP Version : Public Build 0.1");
            
            wait 5;
        }
        else
        {
            
            self.msg setPoint("LEFT", "LEFT", 40, 0);
            self.msg setText("Welcome To ^3Exodia ^7" + self.name);
            
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 40, 0);
            self.msg setText("Press [{+speed_throw}] & [{+melee}] To Open Menu.");
            
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 10, 0);//x = -L/+R, y = -U/+D
            
            self.msg setText("Press [{+gostand}] To Select Or [{+usereload}] To Go Back.");
            
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 10, 0);//x = -L/+R, y = -U/+D
            
            self.msg setText("Press [{+actionslot 1}] To Sroll Up or [{+actionslot 2}] To Scroll Down.");
            
            wait 5;
            self.msg setPoint("LEFT", "LEFT", 10, 0);
            self.msg setText("Press [{+actionslot 3}] To Sroll Right or [{+actionslot 4}] To Scroll Left.");
        
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 30, 0);//x = -L/+R, y = -U/+D
            
            self.msg setText("^3Download ^7: ^1I^7nfinity^1L^7oader.com");
            
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 80, 0);//x = -L/+R, y = -U/+D
            self.msg setText("^6Discord ^7: ^8Littof");
            
            wait 5;
            
            self.msg setPoint("LEFT", "LEFT", 20, 0);//x = -L/+R, y = -U/+D
            self.msg setText("^8MW2 MP Version : Public Build 0.1");
            
            wait 5;
        }
       
    }
}

setExodiaIMG()
{
    replaceimage("img/exodia.png", "ui_host");
    ilog( "^2Succes ^7: Image Replaced!" );
}

setExodiaTest()
{
    replaceimage("img/yu.jpg", "menu_background");
    ilog( "^2Succes ^7: Image Replaced!" );
}

setExodiaTransparentIMG()
{
    replaceimage("img/transparent.png", "menu_cloud_overlay");
    ilog( "^2Succes ^7: Image Replaced!" );
}

destroyElement(element)
{
    if (isDefined(element))
    {
        element destroy();
    }
}





   


























