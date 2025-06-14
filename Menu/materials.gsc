progressbar( min, max, mult, time )
{        
    self endon("disconnect");
    curs     = min-1;
    cap_curs = (self getCursor() > 10) ? 9 : self getCursor();
    
    self lockMenu("lock", "open");
    self thread deleteLineInfo(); 

    while( curs <= max-1 )
    {
        curs += mult;
        math       = (98 / max) * curs;
        position_x = (max) / ((108 - 14));
        xPosition = self.menu["OPT"][cap_curs].x;

        if(IsDefined( self.eMenu[ cap_curs ].toggle ))
            xPosition -= 20;

        progress = [];
        progress[progress.size] = self createRectangle("RIGHT", "CENTER", xPosition + 210, self.menu["OPT"][cap_curs].y, 108, 14, (0,0,0), "white", 4, 1); //BG
        progress[progress.size] = self createRectangle("LEFT", "CENTER", progress[progress.size-1].x -107 + (curs / position_x), progress[progress.size-1].y, 10, 10, self.presets["SCROLL_STITLE_BG"], "white", 5, 1); //INNER
        progress[progress.size] = self createText("objective", 1, "RIGHT", "CENTER", xPosition + 126, progress[progress.size-2].y, 5, 1, curs + "/" + max, (1,1,1));
        
        wait time;
        self destroyAll( progress );
    }
    self setMenuText();
    self notify("progress_done");
    wait .05;
    self lockMenu("unlock", "open");
}

areYouSure()
{
    if( isDefined( self.was_edited ))
        return true;

    self lockMenu("lock", "open");
    self thread deleteLineInfo();
    
    cap_curs = (self getCursor() > 10) ? 9 : self getCursor();
    xPos     = self.menu["OPT"][cap_curs].x + ((IsDefined( self.eMenu[ self getCursor() ].toggle )) ? 0 : 20);
    
    youSure  = [];
    youSure[youSure.size] = self createRectangle("RIGHT", "CENTER", xPos + 175, self.menu["OPT"][cap_curs].y, 18, 14, rgb(15,14,15), "white", 5, 1); //INNER
    youSure[youSure.size] = self createRectangle("RIGHT", "CENTER", xPos + 155, self.menu["OPT"][cap_curs].y, 18, 12, self.presets["LINETOP1"], "white", 5, 1); //INNER
    youSure[youSure.size] = self createRectangle("RIGHT", "CENTER", xPos + 175, self.menu["OPT"][cap_curs].y, 39, 16, (0,0,0), "white", 4, 1); //BG
    youSure[youSure.size] = self createText("small", 1, "LEFT", "CENTER", xPos + 137, self.menu["OPT"][cap_curs].y, 6, 1, " Yes   No", (1,1,1));
    youSure[youSure.size] = self createText("small", 1, "RIGHT", "CENTER", xPos + 130, self.menu["OPT"][cap_curs].y, 5, 1, "Are You Sure?", (1,1,1));
    wait .2;
    
    curs = 0;
    while(!self.actionSlotsPressed[ "jump" ])
    {
        if( self.actionSlotsPressed[ "dpad_left" ] || self.actionSlotsPressed[ "dpad_right" ]  )
        {
            youSure[curs].color = self.presets["LINETOP1"];
            curs += self.actionSlotsPressed[ "dpad_left" ];
            curs -= self.actionSlotsPressed[ "dpad_right" ];
            
            if( curs < 0 ) curs = 1;
            if( curs > 1 ) curs = 0;
            youSure[curs].color = rgb(15,14,15);
            wait .2;
        }
        wait .05;
    }
    self destroyAll( youSure );
    wait .1;
    self lockMenu("unlock", "open"); 
    if( curs == 0 )
        return true;
    return false;    
}

deleteLineInfo()
{
    curs = (self getCursor() > 10) ? 9 : self getCursor();
    self.menu["UI_SLIDE"][curs] destroy();
    self.menu["UI_SLIDE"][curs + 10] destroy();
    self.menu["UI_SLIDE"]["VAL"] destroy();
    
    self.menu["UI_SLIDE"]["STRING_"+curs] destroy();
}


































































