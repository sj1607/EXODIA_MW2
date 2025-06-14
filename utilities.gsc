
createText(font, fontScale, align, relative, x, y, sort, alpha, text, color, isLevel)
{
    if(isDefined(isLevel))
        textElem = level createServerFontString(font, fontScale);
    else 
        textElem = self createFontString(font, fontScale);
    
    textElem setPoint(align, relative, x, y);
    
    textElem.archived = false;
    if( self.hud_amount >= 19 ) 
    textElem.archived = true;
    
    textElem.sort           = sort; 
    textElem.alpha          = alpha;
    textElem.hideWhenInMenu = true;
    
    
    if(color != "rainbow")
        textElem.color = color;
    else
    {
        textElem.color = level.rainbowColour;
        textElem thread doRainbow();
    }
    
    self addToStringArray(text);
    textElem thread watchForOverFlow(text);
    textElem thread watchDeletion( self );  
    
    self.hud_amount++;  
    return textElem;
}


createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
{
    if(isDefined(server))
        boxElem = newHudElem();
    else
        boxElem = newClientHudElem(self);

    boxElem.elemType = "icon";
    
    if(color != "rainbow")
        boxElem.color = color;
    else 
    {
        boxElem.color = level.rainbowColour;
        boxElem thread doRainbow();
    }
    
    if(!level.splitScreen)
    {
        boxElem.x = -2;
        boxElem.y = -2;
    }
    boxElem.hideWhenInMenu = true;
    
    boxElem.archived = false;
    if( self.hud_amount >= 19 ) 
        boxElem.archived = true;
    
    boxElem.width          = width;
    boxElem.height         = height;
    boxElem.align          = align;
    boxElem.relative       = relative;
    boxElem.xOffset        = 0;
    boxElem.yOffset        = 0;
    boxElem.children       = [];
    boxElem.sort           = sort;
    boxElem.alpha          = alpha;
    boxElem.shader         = shader;
    boxElem setParent(level.uiParent);
    boxElem setShader(shader, width, height);
    boxElem.hidden = false;
    boxElem setPoint(align, relative, x, y);
    boxElem thread watchDeletion( self );
    
    self.hud_amount++;
    return boxElem;
}

setSafeText(text)
{
    self notify("stop_TextMonitor");
    self addToStringArray(text);
    self thread watchForOverFlow(text);
}

addToStringArray(text)
{
    if(!isInArray(level.strings,text))
    {
        level.strings[level.strings.size] = text;
        level notify("CHECK_OVERFLOW");
    }
}

watchForOverFlow(text)
{
    self endon("stop_TextMonitor");

    while(isDefined(self))
    {
        if(isDefined(text.size))
            self setText(text);
        else
        {
            self setText(undefined);
            self.label = text;
        }
        level waittill("FIX_OVERFLOW");
    }
}

isInArray( array, text )
{
    for(e=0;e<array.size;e++)
        if( array[e] == text )
            return true;
    return false;        
}

removeFromArray( array, text )
{
    new = [];
    foreach( index in array )
    {
        if( index != text )
            new[new.size] = index;
    }      
    return new; 
}

getName()
{
    name = self.name;
    if(name[0] != "[")
        return name;
    for(a = name.size - 1; a >= 0; a--)
        if(name[a] == "]")
            break;
    return(getSubStr(name, a + 1));
}

destroyAll(array)
{
    if(!isDefined(array))
        return;
    keys = getArrayKeys(array);
    for(a=0;a<keys.size;a++)
        if(isDefined(array[ keys[ a ] ][ 0 ]))
            for(e=0;e<array[ keys[ a ] ].size;e++)
                array[ keys[ a ] ][ e ] destroy();
    else
        array[ keys[ a ] ] destroy();
}

toUpper( string )
{
    if( !isDefined( string ) || string.size <= 0 )
        return "";
    alphabet = strTok("A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z;0;1;2;3;4;5;6;7;8;9; ;-;_", ";");
    final    = "";
    for(e=0;e<string.size;e++)
        for(a=0;a<alphabet.size;a++)
            if(IsSubStr(toLower(string[e]), toLower(alphabet[a])))         
                final += alphabet[a];
    return final;            
}

hudFade(alpha, time)
{
    self fadeOverTime(time);
    self.alpha = alpha;
    wait time;
}
 
hudMoveX(x, time)
{
    self moveOverTime(time);
    self.x = x;
    wait time;
}

hudMoveY(y, time)
{
    self moveOverTime(time);
    self.y = y;
    wait time;
}

rgb(r, g, b)
{
    return (r / 255, g / 255, b / 255);
}

watchDeletion( player )
{
    self waittill("death");
    if( player.hud_amount > 0 )
        player.hud_amount--;
}

createRainbowColor()
{
    rainbow = spawnStruct();
    rainbow.r = 255;
    rainbow.g = 0;
    rainbow.b = 0;
    rainbow.stage = 0;
    time = 5;
    level.rainbowColour = (0, 0, 0);
    for(;;)
    {
        if(rainbow.stage == 0)
        {
            rainbow.b += time;
            if(rainbow.b == 255)
                rainbow.stage = 1;
        }
        else if(rainbow.stage == 1)
        {
            rainbow.r -= time;
            if(rainbow.r == 0)
                rainbow.stage = 2;
        }
        else if(rainbow.stage == 2)
        {
            rainbow.g += time;
            if(rainbow.g == 255)
                rainbow.stage = 3;
        }
        else if(rainbow.stage == 3)
        {
            rainbow.b -= time;
            if(rainbow.b == 0)
                rainbow.stage = 4;
        }
        else if(rainbow.stage == 4)
        {
            rainbow.r += time;
            if(rainbow.r == 255)
                rainbow.stage = 5;
        }
        else if(rainbow.stage == 5)
        {
            rainbow.g -= time;
            if(rainbow.g == 0)
                rainbow.stage = 0;
        }
        level.rainbowColour = (rainbow.r / 255, rainbow.g / 255, rainbow.b / 255);
        wait .05;
    }
}

hudMoveXY(time,x,y)
{
    self moveOverTime(time);
    self.y = y;
    self.x = x;
}

RGB_Edit(slider, type, rgb) 
{
   
    vec3 = (0, 0, 0);
    R = self.presets[type][0];
    G = self.presets[type][1];
    B = self.presets[type][2];

    
   if (rgb == "R") vec3 = ((slider / 255), G, B);
    if (rgb == "G") vec3 = (R, (slider / 255), B);
    if (rgb == "B") vec3 = (R, G, (slider / 255));
    
     self thread refreshUIWelcome();
        self thread refreshMenu(true);
        
    self.presets[type] = vec3;
    
   
     
     
}


reset_default_color(type)
{
   
    self.presets[type] = get_preset(type);
    self thread refreshUIWelcome();
    self thread refreshMenu(true);

}

refreshUIWelcome()
{
    if (!isDefined(self.menu) || !isDefined(self.menu["UI_BAR"]))
        return;

    
    foreach ( value in self.menu["UI_BAR"])
    {
        value destroy();
    } 

    
    self.menu["UI_BAR"]["WELCOME_BAR2"] = self createRectangle("LEFT", "LEFT", 0, 0, 251, 50, self.presets["TITLE_OPT_BG"], "white", 1, 1);
    self.menu["UI_BAR"]["WELCOME_BAR_GREEN"] = self createRectangle("LEFT", "LEFT", 0, 0, 2, 50, self.presets["SCROLL_STITLE_BG"], "white", 2, 1);
    self.menu["UI_BAR"]["WELCOME_BAR2_GREEN"] = self createRectangle("LEFT", "LEFT", 250, 0, 2, 50, self.presets["SCROLL_STITLE_BG"], "white", 2, 1);
    self.menu["UI_BAR"]["WELCOME_BAR3_GREEN"] = self createRectangle("LEFT", "LEFT", 0, -25, 252, 2, self.presets["SCROLL_STITLE_BG"], "white", 2, 1);
    self.menu["UI_BAR"]["WELCOME_BAR4_GREEN"] = self createRectangle("LEFT", "LEFT", 0, 25, 252, 2, self.presets["SCROLL_STITLE_BG"], "white", 2, 1);

    
    if (isDefined(self.msg))
    {
        self.msg setPoint("LEFT", "LEFT", 50, 0); 
        
    }
}

refreshMenuToggles()
{
    foreach( player in level.players )
    if( player hasMenu() && player isMenuOpen() )
    player setMenuText();
}

refreshMenu(skip)
{
    if (!self hasMenu())
        return false;

    if (self isMenuOpen())
    {
        current = self getCurrentMenu();
        previous = self.previousMenu;
        for (e = previous.size; e > 0; e--)
            self newMenu();
        self menuClose();
        self.menu["isLocked"] = true;
    }

    if (!IsDefined(skip))
    {
        self waittill("reopen_menu");
        wait .1;
    }
    else wait .05;

    self menuOpen();
    if (IsDefined(previous))
    {
        foreach (menu in previous)
        {
            if (menu != "main")
                self newMenu(menu);
        }
        self newMenu(current);
        self.menu["isLocked"] = false;
    }

    self setMenuText(); 
}



hasMenu()
{
    if( IsDefined( self.access ) && self.access != "None" )
        return true;
    return false;    
}

lockMenu( which, type )
{
    if(toLower(which) == "lock")
    {
        if(self isMenuOpen() && toLower(type) != "open")
        {
            current  = self getCurrentMenu();
            previous = self.previousMenu;
            for(e = previous.size; e > 0; e--)
                self newMenu();
            self menuClose(); 
        }
        self.menu["isLocked"] = true;
    }
    else 
    {
        if(!self isMenuOpen() && toLower(type) == "open")
            self menuOpen();
        else     
            self setMenuText();    
        self.menu["isLocked"] = false;
        self notify("menu_unlocked");
    }
}

hudFadeDestroy(alpha, time)
{
    self fadeOverTime(time);
    self.alpha = alpha;
    wait time;
    self destroy();
}

doRainbow()
{
    while(IsDefined( self ))
    {
        self fadeOverTime(.05); 
        self.color = level.rainbowColour;
        wait .05;
    }
}

doOption(function, p1, p2, p3, p4, p5, p6)
{
    if(!isdefined(function))
        return;
    
    if(isdefined(p6))
        self thread [[function]](p1,p2,p3,p4,p5,p6);
    else if(isdefined(p5))
        self thread [[function]](p1,p2,p3,p4,p5);
    else if(isdefined(p4))
        self thread [[function]](p1,p2,p3,p4);
    else if(isdefined(p3))
        self thread [[function]](p1,p2,p3);
    else if(isdefined(p2))
        self thread [[function]](p1,p2);
    else if(isdefined(p1))
        self thread [[function]](p1);
    else
        self thread [[function]]();
}





exit()
{
    self endon("disconnect");
    for(;;)
    {
        if(self adsButtonPressed() && self.actionSlotsPressed[ "dpad_left"])
        {
            
            exitlevel(false);
        }
        wait(0.01); 
    }
}


hasKeysArray(array)
{
    foreach (value in array)
    {
        return true; 
    }
    return false; 
}

 
setPlayerDvar(player, dvar, value) 
{
    thedvar = player getXUID() + "_" + dvar;
    setDvar(thedvar, value);
}

resetHUD(player)
{
    player thread maps\mp\gametypes\_gamelogic::freeGameplayHudElems();
}

IsBot(player)
{
    if (IsDefined(player.pers["isBot"]))
    return player.pers["isBot"];
}

contain(string, char)
{
    for (i = 0; i < string.size; i++)
    {
        if (string[i] == char)
        return true; 
    }
    return false; 
}

containsSubstr(str, sub)
{
    
    if (sub.size > str.size)
        return false;
        
    for(i = 0; i <= str.size - sub.size; i++)
    {
        match = true;
        for(j = 0; j < sub.size; j++)
        {
            if (str[i+j] != sub[j])
            {
                match = false;
                break;
            }
        }
        if (match)
            return true;
    }
    return false;
}

subString(string, start, length) 
{
    if (!isDefined(string) || string == "" || !isDefined(start) || !isDefined(length))
        return "";

    start = clamp(start, 0, string.size); 
    length = clamp(length, 0, string.size - start); 

    return getSubStrCustom(string, start, length);
}

getSubStrCustom(string, start, length) 
{
    if (!isDefined(string) || string == "" || !isDefined(start) || !isDefined(length))
        return "";

    start = clamp(start, 0, string.size);
    length = clamp(length, 0, string.size - start); 

    newString = "";
    for (i = start; i < start + length; i++) 
    {
        newString += string[i];
    }

    return newString;
}



clamp(value, min, max)
{
    if(value < min)
        return min;
    if(value > max)
        return max;
    return value;
}

TypeWriterText(text, hud)
{ 
    if(!isDefined(text) || !isDefined(hud))
        return;
        
    
    while(isDefined(hud))
    {
        hud.color = divideColor(RandomInt(255), RandomInt(255), RandomInt(255));
        string = "";
        for(a = 0; a < text.size; a++)
        {
            string2 = "";
            for(b = 0; b <= a; b++)
                string2 += text[b];
            if(string2.size == text.size)
                string = string2;
            else
                string = string2 + "|";
            hud SetSafeText(string);
            wait .1;
        }
        wait 1;
        for(a = text.size; a >= 0; a--)
        {
            string2 = "";
            for(b = 0; b < a; b++)
                string2 += text[b];
            if(string2.size == 0)
                string = "|";
            else
                string = string2 + "|";
            
            hud SetSafeText(string);
            wait .1;
        }
        wait .25;
    }
}

RainText(text, hud)
{
    if(!isDefined(text) || !isDefined(hud))
        return;
    
    while(isDefined(hud))
    {
        string = "";
        for(a = 0; a < text.size; a++)
            string += "^" + RandomInt(7) + text[a];
        hud SetSafeText(string);
        wait .1;
    } 
}

KRDRText(text, hud)
{
    if(!isDefined(text) || !isDefined(hud))
        return;

    while(isDefined(hud))
    {
        if(isDefined(col))
            OldCol = col;

        if(isDefined(OldCol))
        {
            if(OldCol == 6)
                col = 0;
            else
                col += 1;
            } 
        else
        {
            col = 0;
            OldCol = 6;
        }

        for(a = 0; a < text.size; a++)
        {
            string = "";
            for(b = 0; b < text.size; b++)
                if(b == a)
                    string += "^" + col + text[b] + "^7";
                else
                    string += text[b];
            hud SetSafeText(string);
            if(a != (text.size - 1))
                wait .1;
        }
        for(a = text.size; a >= 0; a--)
        {
            string = "";
            for(b = 0; b < text.size; b++)
                if(b == a)
                    string += "^" + col + text[b] + "^7";
                else
                    string += text[b];
            hud SetSafeText(string);
            wait .1;
        }
    }
}

CYCLText(text, hud)
{
    if(!isDefined(text) || !isDefined(hud))
        return;


    while(isDefined(hud))
    {
        if(isDefined(col))
            OldCol = col;

        if(isDefined(OldCol))
        {
            if(OldCol == 7)
                col = 0;
            else
                col += 1;
        }
        else
        {
            col = 0;
            OldCol = 7;
        }

        for(a = 0; a < text.size; a++)
        {
            string = "^" + col;
            for(b = 0; b < text.size; b++)
                if(a == b)
                    string += "^" + col + text[b] + "^" + OldCol;
                else
                    string += text[b];

            hud SetSafeText(string);
            wait .1;
        }
    }
}

PulseFXText(text, hud)
{
    if(!isDefined(text) || !isDefined(hud))
        return;



    hud SetSafeText(text);
    
    while(isDefined(hud))
    {
        hud.color = divideColor(RandomInt(255), RandomInt(255), RandomInt(255));
        hud SetPulseFx(int(1 * 25), int(2 * 1000), 500);
        wait 3;
    } 
}

RandomPosText(text, hud)
{
    if(!isDefined(text) || !isDefined(hud))
        return;



    hud SetSafeText(text);

    while(isDefined(hud))
    {
        hud FadeOverTime(2);
        hud.color = divideColor(RandomInt(255), RandomInt(255), RandomInt(255));
        hud thread hudMoveXY1(2, RandomIntRange(-300, 300), RandomIntRange(-200, 200));
        wait 1.98;
    }
}
PulsingText(text, hud)
{
    if(!isDefined(text) || !isDefined(hud))
        return;

    hud SetSafeText(text);
    savedFontScale = hud.FontScale;

    while(isDefined(hud))
    {
        hud ChangeFontscaleOverTime1(savedFontScale + .8, .6);
        hud hudFadeColor(divideColor(RandomInt(255), RandomInt(255), RandomInt(255)), .6);
        wait .6;
        hud ChangeFontscaleOverTime1(savedFontScale - .5, .6);
        hud hudFadeColor(divideColor(RandomInt(255), RandomInt(255), RandomInt(255)), .6);
        wait .6;
    }
}



divideColor(c1,c2,c3)
{
    return(c1/255,c2/255,c3/255);
}

hudMoveXY1(time,x,y)
{
    self MoveOverTime(time);
    self.y = y;
    self.x = x;
    wait time;
}

ChangeFontscaleOverTime1(scale,time)
{
    self ChangeFontscaleOverTime(time);
    self.fontScale = scale;
}

hudFadeColor(color,time)
{
    self FadeOverTime(time);
    self.color = color;
}


WaveText(text, hud)
{
    if(!isDefined(text) || !isDefined(hud))
        return;

    hud SetSafeText(text);
    while(isDefined(hud))
    {
        for(i = -500; i <= 500; i += 10)
        {
            hud.x = i;
            hud.y = 50 * sin(i * 0.1); 
            wait 0.1;
        }
    }
}


GlitchText(text, hud)
{
    if (!isDefined(text) || !isDefined(hud))
        return;

    glitchChars = [];
    glitchChars[0] = "@";
    glitchChars[1] = "#";
    glitchChars[2] = "$";
    glitchChars[3] = "%";
    glitchChars[4] = "&";
    glitchChars[5] = "*";
    glitchChars[6] = "?";
    glitchChars[7] = "!";
    glitchChars[8] = "X";
    glitchChars[9] = "Y";
    glitchChars[10] = "Z";
    glitchChars[11] = "+";
    glitchChars[12] = "-";
    glitchChars[13] = ".";
    glitchChars[14] = "_";
    glitchChars[15] = "/";

    hud SetSafeText(text);

    while (isDefined(hud))
    {
        glitch = "";
        for (i = 0; i < text.size; i++)
        {
            if (RandomInt(3) == 0) 
            {
                randomChar = glitchChars[RandomInt(glitchChars.size)];
                glitch += randomChar; 
            }
            else
            {
                glitch += text[i]; 
            }
        }
        hud SetSafeText(glitch);
        wait 0.5;
        hud SetSafeText(text); 
        wait 0.2;
    }
}

createServerText(font, fontScale, align, relative, x, y, sort, alpha, text, color)
{
    if (!isDefined(font) || !isDefined(text))
    {
        self iPrintlnBold("Error : font not found!");
        return;
    }

    textElem = CreateServerFontString(font, fontScale);
    textElem.hideWhenInMenu = true;
    textElem.archived       = true;
    textElem.sort           = sort;
    textElem.alpha          = alpha;
    
    
    if (isDefined(color))
    {
        textElem.color = color;
    }
    else
    {
        textElem.color = (1, 1, 1);  
    }

    textElem.foreground     = true;
    textElem setPoint(align, relative, x, y);

    
    self addToStringArray(text);
    
    
    textElem thread watchForOverFlow(text);
    
    return textElem;
}

splitString(str, delimiter)
{
    if (!isDefined(str) || str == "")
        return []; 
    
    array = [];
    while (true)
    {
       
        idx = strStr(str, delimiter);
        
        if (idx == -1) 
        {
            array[array.size] = str;
            break;
        }
        else
        {
            
            array[array.size] = substring(str, 0, idx);
            
            
            str = substring(str, idx + delimiter.size, str.size - (idx + delimiter.size));
        }
    }
    return array;
}

isArrayLocal(obj) 
{
    return isDefined(obj) && obj.size != undefined;
}

strStr(haystack, needle)
{
    if (!isDefined(haystack) || !isDefined(needle))
    return -1;

    haystack_len = haystack.size;
    needle_len = needle.size;

    if (needle_len == 0 || haystack_len < needle_len)
        return -1;

    for (i = 0; i <= haystack_len - needle_len; i++)
    {
        if (substring(haystack, i, needle_len) == needle)
            return i;
    }
    
    return -1; 
}

arrayremovevalue(array, value)
{
    newArray = [];

    for(i = 0; i < array.size; i++)
    {
        if(array[i] != value)
        newArray[newArray.size] = array[i];
    }

    return newArray;
}

array_copy(array)
{
    newArray = [];

    for(i = 0; i < array.size; i++)
    {
        newArray[newArray.size] = array[i];
    }

    return newArray;
}

arrayJoin(arr, sep)
{
    result = "";
    for(i = 0; i < arr.size; i++)
    {
        result = result + arr[i];
        if(i < arr.size - 1)
        {
            result = result + sep;
        }
    }
    return result;
}

base10_to_base16( value ) 
{
    base = [];
    base[0] = do_base10( value );
    while( true )
    {
        value = int( StrTok( base[base.size-1], "|" )[0] );
        if( value > 0 )
            base[base.size] = do_base10( value );
        else break;
    }
    
    while( base.size < 6 )
    {
        base[base.size] = "0|0";
        wait .05;
    }
    
    hexadecimal = [ "A", "B", "C", "D", "E", "F" ];
    
    final = "";
    for(e=base.size-1;e>-1;e--)
    {
        hex = StrTok( base[e], "|" );
        if( int( hex[1] ) > 9 )
            final += hexadecimal[ (int( hex[1] ) - 10) ]; 
        else 
            final += hex[1];
    }
        
    flipped = "";
    size    = final.size-1;
    for(e=0;e<size;e+=2)
        flipped += final[size - (e + 1)] + final[ size - e ];
    return toUpper( flipped ); 
}

do_base10( value ) 
{
    divide        = value / 16;
    divide_string = divide + "";
    
    r = "";
    for(e=0;e<divide_string.size;e++)
    {
        if( divide_string[e] == "." )
            break; 
        r += divide_string[e];
    }
    if( r == "" )
        r = 0;
        
    remainder = (divide - int( r )) * 16; 
    if( remainder < 0 )
        remainder *= -1; 
        
    return divide + "|" + remainder;
}

BotCounter()
{
    numberBots = 0; 
    foreach(player in level.players)
    {
        if(player IsBot())
        {
            numberBots++;
        }
    }
    return numberBots;  
  
}





