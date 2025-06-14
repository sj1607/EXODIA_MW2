printMyWeapon()
{
    self endon("disconnect");
    self endon("end_PrintWeapon");
    
    self.printWeap = (!IsDefined(self.printWeap)) ? true : undefined;
    
    if(self.printWeap)
    {
        while(IsDefined(self.printWeap))
        {
            self iprintln(self getCurrentWeapon());
            wait(1);
        }
    }
    else
    {
        self notify("end_PrintWeapon");
        self.printWeap = undefined;
    }
}


printMyGrenade()
{
    self endon("disconnect");
    self endon("end_PrintGrenade");
    
    self.printGrenade = (!IsDefined(self.printGrenade)) ? true : undefined;
    
    if(self.printGrenade)
    {
        while(IsDefined(self.printGrenade))
        {
            self iprintln(self getCurrentOffHand());
            wait(1);
        }
    }
    else 
    {
        self notify("end_PrintGrenade");
        self.printGrenade = undefined;
    }
}

printMapName()
{
    self endon("disconnect");
    self endon("end_PrintMap");
    
    self.printMap = (!IsDefined(self.printMap)) ? true : undefined;
    
    if(self.printMap)
    {
        while(IsDefined(self.printMap))
        {
            self iprintln(getDvar("mapname"));
            wait(1); 
        }
    }
    else
    {
        self notify("end_PrintMap");
        self.printMap = undefined;
    } 
}

printGameMode()
{
    self endon("disconnect");
    self endon("end_PrintGameMode");
    
    self.printGameMode = (!IsDefined(self.printGameMode)) ? true : undefined;
    
    if(self.printGameMode)
    {
        while(IsDefined(self.printGameMode))
        {
            self iprintln(getDvar("g_gametype"));
            wait(1);
        }
    }
    else
    {
        self notify("end_PrintGameMode");
        self.printGameMode = undefined;
    } 
}

printOrigin()
{
    self endon("disconnect");
    self endon("end_PrintOrigin");
    
    self.printOrigin = (!IsDefined(self.printOrigin)) ? true : undefined;
    
    if(self.printOrigin)
    {
        while(IsDefined(self.printOrigin))
        {
            pos = self.origin;
            self iprintln("Position: ^1X ^7: " + pos[0] + " ^1Y ^7: " + pos[1] + " ^1Z ^7: " + pos[2]);
            wait(1);
        }
    }
    else
    {
        self notify("end_PrintOrigin");
        self.printOrigin = undefined;
    } 
}

printCustomDvar()
{
    customDvar = do_keyboardDev("Put the dvar whose value you want to know.");
    
    printDvar(customDvar);
} 
 


do_keyboardDev(title2)
{ 
    self playSoundToPlayer("uin_pip_close", self);
    self.menu["isOpen"] = false;
    self destroyAll(self.menu["UI"]);
    self destroyAll(self.menu["OPT"]);
    self destroyAll(self.menu["UI_TOG"]);
    self destroyAll(self.menu["UI_SLIDE"]);
    wait (0.02);
    title = title2;
    
    keys = [];
    keys[0] = "0AN:";
    keys[1] = "1BO;";
    keys[2] = "2CP>";
    keys[3] = "3DQ$"; 
    keys[4] = "4ER#";
    keys[5] = "5FS-";
    keys[6] = "6GT*";
    keys[7] = "7HU+";
    keys[8] = "8IV@";
    keys[9] = "9JW/"; 
    keys[10] = "^KX_";
    keys[11] = "!LY[";
    keys[12] = "?MZ]";
    
    UI = [];
    for(i=0;i<13;i++)
    {
        row = "";
        for(e=0;e<4;e++)
            row += keys[i][e] + "\n";
        UI["keys_"+i] = createText( "objective", 1.2, "LEFT", "CENTER", -125 + (i*20), -30, 4, 1, row, (1,1,1) );
    }
    
    UI["TITLE"] = createText("objective", 1.4, "TOP", "CENTER", 0, -82, 4, 1, toUpper(title), (1,1,1));
    UI["PREVIEW"] = createText("objective", 1.2, "TOP", "CENTER", 0, -55, 4, 1, "", (1,1,1));
    UI["INSRUCT_0"] = createText("objective", 1, "TOP", "CENTER", 0, 30, 4, 1, "Up - [{+actionslot 1}] : Down - [{+actionslot 2}] : Left - [{+actionslot 3}] : Right - [{+actionslot 4}]", (1,1,1));
    UI["INSRUCT_1"] = createText("objective", 1, "TOP", "CENTER", 0, 40, 4, 1, "Select - [{+gostand}] : Confirm - [{+reload}] : Space - [{+switchseat}]", (1,1,1));
    UI["INSRUCT_2"] = createText("objective", 1, "TOP", "CENTER", 0, 50, 4, 1, "Capitals - [{+frag}] : Lower - [{+smoke}] : Backspace - [{+melee}] : Cancel - [{+stance}]", (1,1,1));


    
    UI["BG"] = createRectangle("TOP", "CENTER", 0, -90, 300, 120, (0,0,0), "white", 0, .7);
    UI["RESULT"] = createRectangle("TOP", "CENTER", 0, -59, 300, 20, (0,0,0), "white", 1, .7);
    UI["CURSOR"] = createRectangle("LEFT", "CENTER", UI["keys_0"].x - 1, UI["keys_0"].y, 12, 12, self.presets["LINETOP1"], "white", 2, .7);
    
    result   = "";
    curs_x   = 0;
    curs_y   = 0;
    capitals = 0;
    lower    = 0;

    wait(0.2);
    while(true)
    {
        if (self.actionSlotsPressed["dpad_left"])
        curs_x = minus_keyboard_curs(curs_x, 0, 12);
        else if (self.actionSlotsPressed["dpad_right"])
        curs_x = plus_keyboard_curs(curs_x, 0, 12);
        else if (self.actionSlotsPressed["dpad_up"])
        curs_y = minus_keyboard_curs(curs_y, 0, 3);
        else if (self.actionSlotsPressed["dpad_down"])
        curs_y = plus_keyboard_curs(curs_y, 0, 3);

        else if(self UseButtonPressed()) 
            break;
        else if(self.actionSlotsPressed[ "stance"]) 
            return self destroyAll(UI);
        
        if(self.actionSlotsPressed[ "jump"])
        {
            result += (capitals ? toUpper( keys[curs_x][curs_y] ) : (lower ? toLower( keys[curs_x][curs_y] ) : keys[curs_x][curs_y] ));
            wait (0.02);
        }
        else if(self MeleeButtonPressed() && result.size > 0)
        {
             temp = "";
            for(e=0;e<result.size-1;e++)
                temp += result[e];
            result = temp;
           wait (0.02);
        }
        else if(self FragButtonPressed())
        {
            capitals = capitals ? 0 : 1; 
            for(i=0;i<13;i++)
            {
                row = "";
                for(e=0;e<4;e++)
                    row += (capitals ? toUpper( keys[i][e] ) : keys[i][e] ) + "\n";
                UI["keys_"+i] setSafeText( row );
            }
            wait (0.02);
        } 
        else if(self SecondaryOffhandButtonPressed())
        {
            lower = lower ? 0 : 1; 
            for(i=0;i<13;i++)
            {
                row = "";
                for(e=0;e<4;e++)
                row += (lower ? ToLower( keys[i][e] ) : keys[i][e] ) + "\n";
                UI["keys_"+i] setSafeText( row );
            }
            wait (0.02);
        }
        
        else if(self.actionSlotsPressed["change_weapon"]) 
        {
            result += " ";  
            wait (0.02);
        }
        
        UI["CURSOR"].x = UI["keys_0"].x + (curs_x * 20) - 1;
        UI["CURSOR"].y = UI["keys_0"].y + (curs_y * 15); 
        UI["PREVIEW"] setSafeText(result);
        
        wait (0.05);
    }
    
    
    self destroyAll(UI);
    self menuClose();
    return result;
    wait (0.02);
    self menuOpen();
}

plus_keyboard_curs( curs, min, max ) 
{
    curs++;
    if( curs > max )
        curs = min;
    wait .2; 
    return curs;
}

minus_keyboard_curs( curs, max, min ) 
{
    curs--;
    if( curs < max )
        curs = min;
    wait .2; 
    return curs;    
}


printModelLookedAt()
{
    self endon("disconnect");
    self endon("end_PrintModelLookedAt");

    
    self.printModel = (!isDefined(self.printModel)) ? true : undefined;

    if (self.printModel)
    {
        while (isDefined(self.printModel))
        {
            
            start = self getTagOrigin("tag_eye");
            end   = start + anglestoforward(self getPlayerAngles()) * 1000; 
            trace = BulletTrace(start, end, true, self);

            
            if (isDefined(trace["entity"]))
            {
                entity = trace["entity"];
                if (isDefined(entity.model)) 
                {
                    self iprintln("^2Model Found: ^7" + entity.model);
                }
                else
                {
                    self iprintln("^1No Model Found in View!");
                }
            }
            else
            {
                self iprintln("^1No Entity in View!");
            }

            wait(1); 
        }
    }
    else
    {
        self notify("end_PrintModelLookedAt");
        self.printModel = undefined;
    }
}



