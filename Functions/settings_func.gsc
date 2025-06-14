/*
*    Infinity Loader :: The Best GSC IDE!
*
*    Project : Exodia
*    Author : 
*    Game : Call of Duty: Black Ops 2
*    Description : An empty canvas for anything you want!
*    Date : 25/02/2025 21:56:30
*
*/

setCredits()
{
    if(self.menu["isOpen"] == true)
    
    
    self lockMenu("lock","open");
    if(!IsDefined(self.menu["Credits"]))
    self.menu["Credits"] = newClientHudElem(self);
    self.menu["Credits"].x = 0;
    self.menu["Credits"].y = 0;
    self.menu["Credits"].horzalign = "fullscreen";
    self.menu["Credits"].vertalign = "fullscreen";
    self.menu["Credits"].sort = 50;
    self.menu["Credits"] setShader( "black", 640, 480 );
    self.menu["Credits"].alpha = 1;
    self SetClientDvar( "hud_drawhud", 0 ); 
    
   
    creditsLines = [];
    creditsLines[0] = "Thank you for playing!";
    creditsLines[1] = "";
    creditsLines[2] = "^3Developer ^7: Littof";
    creditsLines[3] = "^8Special Thanks To^7 :";
    creditsLines[4] = "^1Extinct ^7: Gave me his base.";
    creditsLines[5] = "^4Boggy & SyGnUs^7 : Let me post my menu on Infinity Loader.";
    creditsLines[6] = "^5CF4_99 ^7: It has helped me a lot.";
    creditsLines[7] = "";
    creditsLines[8] = "^9Version^7 : 0.1 MP";
    creditsLines[9] = "^2Date Build^7 : 12/02/2025";

    if (!IsDefined(self.menu["Credits_TEXT"]))
    self.menu["Credits_TEXT"] = [];

    
    for (i = 0; i < creditsLines.size; i++)
    {
        if (!IsDefined(self.menu["Credits_TEXT"][i]))
        {
            self.menu["Credits_TEXT"][i] = self createText("hudbigboldi", 2.0, "CENTER", "CENTER", 0, 50 + (i * 30), 55, 1, creditsLines[i], self.presets["TEXT"]);
        }
    }

    self thread scrollCredits(self.menu["Credits_TEXT"], -40, 50);
    

} 

scrollCredits(creditTextArray, speed, startY)
{
    currentY = startY;

    for (;;)
    {
        currentY += speed * 0.05;

        for (i = 0; i < creditTextArray.size; i++)
        {
            if (IsDefined(creditTextArray[i]))
            creditTextArray[i] setPoint("CENTER", "CENTER", 0, currentY + (i * 30));
        }

        if (currentY + (creditTextArray.size * 30) < -220)
        break;
        wait(0.05);
    }

    self thread destroyCredits();
}
 

destroyCredits()
{
    if (IsDefined(self.menu["Credits"]))
    {
        
        foreach (element in self.menu["Credits"])
        {
            if (IsDefined(self.menu["Credits"][element]))
            {
                self.menu["Credits"][element] destroy();
            }
        }
        self.menu["Credits"].alpha = 0;
        self.menu["Credits"] = undefined;
        
       if (IsDefined(self.menu["Credits_TEXT"]))
       {
            if (IsDefined(self.menu["Credits_TEXT"]["TEXT"]))
            {
                self.menu["Credits_TEXT"]["TEXT"] destroy();
                self.menu["Credits_TEXT"]["TEXT"] = undefined;
            }
            self.menu["Credits_TEXT"] = undefined;
       }
        
        
    }

    self lockMenu("unlock", "open"); 
    self SetClientDvar( "hud_drawhud", 1 ); 
}

setSelectedOptionAndOpenMenu(option)
{
    self.selectedOption = option;
    //self iPrintLn("Selected Option Updated: " + self.selectedOption); 
    self newMenu(option);
}

menuBox()
{
    self.menuBox = (!IsDefined(self.menuBox)) ? true : undefined;
    
    if(IsDefined(self.menuBox))
    {
        SetDvar("menuBox" , "1");
    }
    else
    {
        SetDvar("menuBox" , "0");
        self.menuBox = undefined;
    }
}

changeBoxToggle(toggleBox)
{
    self.checkboxOpt = toggleBox;
    
    if(toggleBox == "white")
    {
           setDvar("toggleBoxShader" , "white");
    }
    else if(toggleBox == "circle")
    {
          setDvar("toggleBoxShader" , "circle");
    }
    else if(toggleBox == "text")
    {
        setDvar("toggleBoxShader" , "text");
    }
    else if(toggleBox == "checkbox")
    {
        setDvar("toggleBoxShader" , "checkbox");
    }
    else if(toggleBox  == "loader")
    {
        setDvar("toggleBoxShader" , "loader");
    }
      
    self thread refreshMenu(true);
}
  
changeLogo(Logo)
{
    self thread refreshMenu(true);
}
 
changeFont(font)
{
    self.fontOpt = font;
    
    if(font == "objective")
    {
        setDvar("menuFont" , "objective"); 
    }
    else if(font == "default")
    {
        setDvar("menuFont" , "default"); 
    }
    else if(font == "bigfixed")
    {
        setDvar("menuFont" , "bigfixed"); 
    }
    else if(font == "smallfixed")
    {
        setDvar("menuFont" , "smallfixed"); 
    }
    else if(font == "big")
    {
        setDvar("menuFont" , "big"); 
    }
    else if(font == "small")
    {
        setDvar("menuFont" , "small"); 
    }
    else if(font == "extrabig")
    {
        setDvar("menuFont" , "extrabig"); 
    }
    else if(font == "extrasmall")
    {
        setDvar("menuFont" , "extrasmall"); 
    }
    
    else if(font == "reset")
    {
        setDvar("menuFont" , "reset"); 
    }
    self thread refreshMenu(true);
}
