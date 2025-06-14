randomWeapon(player)
{
	player.weaponsRandom = ["beretta_mp", "usp_mp", "deserteagle_mp", "deserteaglegold_mp", "coltanaconda_mp", "riotshield_mp","glock_mp", "beretta393_mp", "mp5k_mp", "pp2000_mp", "uzi_mp", "p90_mp", "kriss_mp", "ump45_mp", "tmp_mp","ak47_mp", "m16_mp", "m4_mp", "fn2000_mp", "masada_mp", "famas_mp", "fal_mp", "scar_mp", "tavor_mp","gl_mp", "m79_mp", "rpg_mp", "at4_mp", "stinger_mp", "javelin_mp","barrett_mp", "wa2000_mp", "m21_mp", "cheytac_mp","ranger_mp", "striker_mp", "aa12_mp", "m1014_mp", "spas12_mp","rpd_mp", "sa80_mp", "mg4_mp", "m240_mp", "aug_mp","defaultweapon_mp"];

	randomWeapon = player.weaponsRandom[randomInt(player.weaponsRandom.size)];

	if (isDefined(randomWeapon))
	{
		player takeWeapon(player getCurrentWeapon());
		player giveWeapon(randomWeapon);
		player giveMaxAmmo(randomWeapon);
		player setSpawnWeapon(randomWeapon);
		player switchToWeapon(randomWeapon);
	}
}


dropWeapon(player)
{
    player dropitem(player getcurrentweapon());
}

disableWeapons(player)
{
    player.disableWeapons = (!IsDefined(player.disableWeapons)) ? true : undefined;

    if (IsDefined(player.disableWeapons))
    {
        weapons = player getWeaponsListAll();
        primaryWeapon = player getCurrentWeapon();
        secondaryWeapon = undefined;

        foreach (weapon in weapons)
        {
            if (weapon != primaryWeapon) 
            {
                secondaryWeapon = weapon;
                break;
            }
        }

        player._currentWeapon = primaryWeapon;
        player._secondaryWeapon = secondaryWeapon;

        player endon("stop_DisableWeapons");
        player endon("disconnect");

        while (IsDefined(player.disableWeapons))
        {
            player takeweapon(player._currentWeapon);
            if (IsDefined(player._secondaryWeapon))
            player takeweapon(player._secondaryWeapon);

            player _disableOffhandWeapons();
            wait(0.1);
        }
    }
    else
    {
        player giveweapon(player._currentWeapon);
        if (IsDefined(player._secondaryWeapon))
        player giveweapon(player._secondaryWeapon);

        player notify("stop_DisableWeapons");
        player.disableWeapons = undefined;
        player _enableOffhandWeapons();
    }

}

GreedIsland_GiveWeapon(Weapon, player, category)
{
    
    if (category == "smg")
    {
        player.smg = Weapon;
    }
    else if (category == "ar")
    {
        player.Ar = Weapon;
    }
    else if (category == "shotgun")
    {
        player.shotguns = Weapon;
    }
    else if (category == "lmg")
    {
        player.Lmg = Weapon;
    }
    else if (category == "sniper")
    {
        player.SniperRifles = Weapon;
    }
    else if (category == "pistol")
    {
        player.pistols = Weapon;
    }
    else if (category == "mach_pistol")
    {
        player.machpistols = Weapon;
    }
    else if (category == "launcher")
    {
        player.Launchers = Weapon;
    }
    else if (category == "special")
    {
        player.otherSpecials = Weapon;
    }

    player takeallweapons();
    player giveweapon(Weapon);
    player givemaxammo(Weapon);
    player setspawnweapon(Weapon);
}

GreedIsland_GiveGrenade(Weapon, player, category)
{
    
    if (category == "lethal")
    {   
        
        player.grenade = Weapon;
    }
    else if (category == "tactical")
    {
        player.TacticalsGrenade = Weapon;
    }
    
    if (player getCurrentOffHand()!="none") 
    {
        player TakeWeapon(player getCurrentOffHand());
    }
    
    player giveWeapon(Weapon);
    player setWeaponAmmoStock( Weapon, 1 );
    player switchtoweaponimmediate(Weapon);
    
}

setChangeXAxe(int)
{
   self setClientDvar("cg_gun_x", int);
}

setChangeYAxe(int)
{
   self setClientDvar("cg_gun_y", int);
}

setChangeZAxe(int)
{
    self setClientDvar("cg_gun_z", int);
}
setDefaultPos()
{
    self setClientDvar("cg_gun_x", 0);
    self setClientDvar("cg_gun_y", 0);
    self setClientDvar("cg_gun_z", 0);
}

changeWeaponModel(model)
{
    self.weaponModels = model;
    precacheModel(model);
    self setViewModel(model); 
    
    self setClientDvar("cg_gun_x", "3");
    self setClientDvar("cg_gun_y", "-6");
    self setClientDvar("cg_gun_z", "-6");
    
    
    if(self.weaponModels == "default")
    {
        currentWeapon = self getCurrentWeapon(); 
        self setViewModel( "void" );
        self setDefaultPos();
    }
}

discoCamo(player)
{
    player endon("disconnect");
    player endon("stop_Disco_Camo");
    
 

    player.discoCamo = (!isDefined(player.discoCamo)) ? true : undefined;

    if(IsDefined(player.discoCamo))
    {
  
        while(IsDefined(player.discoCamo))
        {
            weapon = player getCurrentWeapon(); 
            self takeWeapon(weapon);
            player giveWeapon(weapon, RandomIntRange(0, 10) , 0 ); 
            player setSpawnWeapon(weapon);   
            wait(1); 
        }
    }
    else
    {
        player.discoCamo = undefined; 
        player notify("stop_Disco_Camo"); 
    }
}


changeCamo(camo)
{
    if (IsDefined(self.discoCamo))
    {
        self error("Disable disco camo.");
        return;
    }
    
    camoIndex = int(camo);
    weapon = self getCurrentWeapon();
    
    self takeWeapon(weapon);
    self giveWeapon(weapon, camoIndex, 0);  
    self setSpawnWeapon(weapon);
}


changeCustomCamo(path)
{
    camoShaders = ["weapon_camo_arctic", "weapon_camo_menu_arctic","weapon_camo_blue_tiger", "weapon_camo_menu_blue_tiger","weapon_camo_desert", "weapon_camo_menu_desert","weapon_camo_digital", "weapon_camo_menu_digital","weapon_camo_orange_fall", "weapon_camo_menu_orange_fall","weapon_camo_red_tiger", "weapon_camo_menu_red_tiger","weapon_camo_red_urban", "weapon_camo_menu_red_urban","weapon_camo_bush_dweller","weapon_camo_woodland", "weapon_camo_menu_woodland" ];
    for (i = 0; i < camoShaders.size; i++)
    replaceimage(path, camoShaders[i]);
    wait(0.1);
}

rainbowCustomCamo()
{
    self endon("disconnect");
    self endon("stop_rainbow_Camo");

    if (IsDefined(self.discoCamo))
    {
        self error("Disable disco camo.");
        return;
    }

    self.rainbowCustomCamo = (!isDefined(self.rainbowCustomCamo)) ? true : undefined;
   
    if(IsDefined(self.rainbowCustomCamo))
    {
        while(IsDefined(self.rainbowCustomCamo))
        {
            colorsPathRainbow = ["img/Colors/army_green.png" , "img/Colors/black.png" , "img/Colors/blue.png" , "img/Colors/brown.png" , "img/Colors/cyan.png" , "img/Colors/green.png" , "img/Colors/grey.png" , "img/Colors/orange.png" , "img/Colors/pink.png" , "img/Colors/purple.png" , "img/Colors/red.png" , "img/Colors/turquoise.png" , "img/Colors/white.png" , "img/Colors/yellow.png"];

            customCamoIndex = randomInt(colorsPathRainbow.size);

            changeCustomCamo(colorsPathRainbow[customCamoIndex]);
            wait(2);
        }
    }
    else
    {
        self.rainbowCustomCamo = undefined;
        self notify("stop_rainbow_Camo");
    }
}

giveAttachments(attachment)
{
    weapon = self getCurrentWeapon();
    if(!isDefined(weapon) || weapon == "none")
    {
        self error("No valid weapon equipped!");
        return;
    }


    getAttachmentsAllowed();
    if(!isDefined(self.compatibleAttachments) || self.compatibleAttachments.size == 0)
    {
        self error("No compatible attachments for " + weapon);
        return;
    }

    valid = false;
    for(i = 0; i < self.compatibleAttachments.size; i++)
    {
        if(self.compatibleAttachments[i] == attachment)
        {
            valid = true;
            break;
        }
    }
    if(!valid)
    {
        self error("Attachment " + attachment + " not allowed for current weapon!");
        return;
    }

    weaponParts = strTok(weapon, "_");
    baseWeapon = weaponParts[0];

    finalWeapon = baseWeapon + "_" + attachment + "_mp";


    self takeWeapon(weapon);
    self giveWeapon(finalWeapon);
    self switchToWeapon(finalWeapon);
    self giveMaxAmmo(finalWeapon);
    self setSpawnWeapon(finalWeapon);

}




setDefaultWeap()
{
    weapon = self getCurrentWeapon();

    if (!issubstr(weapon, "_mp"))
    return;

    weaponNoMp = subString(weapon, 0, weapon.size - 3);
    
    weaponParts = strTok(weaponNoMp, "_");
    baseWeapon = weaponParts[0];
    
    cleanWeapon = baseWeapon + "_mp";
    
    self takeWeapon(weapon);
    self giveWeapon(cleanWeapon);
    self giveMaxAmmo(cleanWeapon);
    self setSpawnWeapon(cleanWeapon);
}

getAttachmentsAllowed()
{
    currentWeapon = self getCurrentWeapon();

    allAttachments = [];
    allAttachments[0] = "acog";
    allAttachments[1] = "grip";
    allAttachments[2] = "gl";
    allAttachments[3] = "tactical";
    allAttachments[4] = "reflex";
    allAttachments[5] = "silencer";
    allAttachments[6] = "akimbo";
    allAttachments[7] = "thermal";
    allAttachments[8] = "shotgun";
    allAttachments[9] = "heartbeat";
    allAttachments[10] = "fmj";
    allAttachments[11] = "rof";
    allAttachments[12] = "dtap";
    allAttachments[13] = "xmags";
    allAttachments[14] = "mags";
    allAttachments[15] = "eotech";

    weaponCategory = getWeaponCategory(currentWeapon);

    compatibleAttachments = [];
    switch(weaponCategory)
    {
        case "pistol":
        case "machine_pistol":
        {
            allowedAttachments = [];
            allowedAttachments[0] = "akimbo";
            allowedAttachments[1] = "fmj";
            allowedAttachments[2] = "silencer";
            allowedAttachments[3] = "tactical";
            allowedAttachments[4] = "xmags";
            allowedAttachments[5] = "eotech";
            allowedAttachments[6] = "reflex";
            compatibleAttachments = filterAttachments(allAttachments, allowedAttachments);
            break;
        }
        case "smg":
        {
            allowedAttachments = [];
            allowedAttachments[0] = "acog";
            allowedAttachments[1] = "eotech";
            allowedAttachments[2] = "fmj";
            allowedAttachments[3] = "reflex";
            allowedAttachments[4] = "rof";
            allowedAttachments[5] = "silencer";
            allowedAttachments[6] = "thermal";
            allowedAttachments[7] = "xmags";
            allowedAttachments[8] = "akimbo";
            compatibleAttachments = filterAttachments(allAttachments, allowedAttachments);
            break;
        }
        case "assault_rifle":
        {
            allowedAttachments = [];
            allowedAttachments[0] = "acog";
            allowedAttachments[1] = "eotech";
            allowedAttachments[2] = "fmj";
            allowedAttachments[3] = "gl";
            allowedAttachments[4] = "heartbeat";
            allowedAttachments[5] = "reflex";
            allowedAttachments[6] = "shotgun";
            allowedAttachments[7] = "silencer";
            allowedAttachments[8] = "thermal";
            allowedAttachments[9] = "xmags";
            compatibleAttachments = filterAttachments(allAttachments, allowedAttachments);
            break;
        }
        case "lmg":
        {
            allowedAttachments = [];
            allowedAttachments[0] = "acog";
            allowedAttachments[1] = "eotech";
            allowedAttachments[2] = "fmj";
            allowedAttachments[3] = "grip";
            allowedAttachments[4] = "heartbeat";
            allowedAttachments[5] = "reflex";
            allowedAttachments[6] = "silencer";
            allowedAttachments[7] = "thermal";
            allowedAttachments[8] = "xmags";
            compatibleAttachments = filterAttachments(allAttachments, allowedAttachments);
            break;
        }
        case "sniper":
        {
            allowedAttachments = [];
            allowedAttachments[0] = "acog";
            allowedAttachments[1] = "fmj";
            allowedAttachments[2] = "heartbeat";
            allowedAttachments[3] = "silencer";
            allowedAttachments[4] = "thermal";
            allowedAttachments[5] = "xmags";
            compatibleAttachments = filterAttachments(allAttachments, allowedAttachments);
            break;
        }
        case "shotgun":
        {
            allowedAttachments = [];
            allowedAttachments[0] = "eotech";
            allowedAttachments[1] = "fmj";
            allowedAttachments[2] = "grip";
            allowedAttachments[3] = "reflex";
            allowedAttachments[4] = "silencer";
            allowedAttachments[5] = "xmags";
            compatibleAttachments = filterAttachments(allAttachments, allowedAttachments);
            if(getBaseWeaponName(currentWeapon) == "ranger_mp" || getBaseWeaponName(currentWeapon) == "model1887_mp")
                compatibleAttachments[compatibleAttachments.size] = "akimbo";
            break;
        }
        case "launcher":
        case "riot_shield":
        {
            compatibleAttachments = [];
            break;
        }
        default:
        {
            compatibleAttachments = [];
            break;
        }
    }
    self.compatibleAttachments = compatibleAttachments;
}


getWeaponCategory(weapon)
{
    baseWeapon = getBaseWeaponName(weapon);
    ilog("Checking category for base weapon: " + baseWeapon);

    if(baseWeapon == "beretta" || baseWeapon == "usp" || baseWeapon == "deserteagle" || baseWeapon == "coltanaconda" || baseWeapon == "glock" || baseWeapon == "beretta393")
    return "pistol";

    else if(baseWeapon == "pp2000" || baseWeapon == "tmp")
    return "machine_pistol";

    else if(baseWeapon == "mp5k" || baseWeapon == "uzi" || baseWeapon == "p90" || baseWeapon == "kriss" || baseWeapon == "ump45")
    return "smg";

    else if(baseWeapon == "ak47" || baseWeapon == "m16" || baseWeapon == "m4" || baseWeapon == "fn2000" || baseWeapon == "masada" || baseWeapon == "famas" || baseWeapon == "fal" || baseWeapon == "scar" || baseWeapon == "tavor")
    return "assault_rifle";

    else if(baseWeapon == "rpd" || baseWeapon == "sa80" || baseWeapon == "mg4" || baseWeapon == "m240" || baseWeapon == "aug")
    return "lmg";

    else if(baseWeapon == "barrett" || baseWeapon == "wa2000" || baseWeapon == "m21" || baseWeapon == "cheytac")
    return "sniper";

    else if(baseWeapon == "ranger" || baseWeapon == "model1887" || baseWeapon == "striker" || baseWeapon == "aa12" || baseWeapon == "m1014" || baseWeapon == "spas12")
    return "shotgun";

    else if(baseWeapon == "m79" || baseWeapon == "rpg" || baseWeapon == "at4" || baseWeapon == "stinger" || baseWeapon == "javelin")
    return "launcher";

    else if(baseWeapon == "riotshield")
    return "riot_shield";
    else
    return "unknown";
}

getBaseWeaponName(weapon)
{
    ilog("Input weapon: " + weapon);
    weaponParts = strTok(weapon, "_");
    
    baseName = weaponParts[0];
    
    ilog("Base weapon name: " + baseName);
    return baseName;
}

filterAttachments(allAttachments, allowedAttachments)
{
    filtered = [];
    index = 0;
    ilog("All attachments size: " + allAttachments.size);
    ilog("Allowed attachments size: " + allowedAttachments.size);
    for(i = 0; i < allAttachments.size; i++)
    {
        for(j = 0; j < allowedAttachments.size; j++)
        {
            if(allAttachments[i] == allowedAttachments[j])
            {
                filtered[index] = allAttachments[i];
                ilog("Added attachment: " + allAttachments[i]);
                index++;
                break;
            }
        }
    }
    ilog("Filtered attachments size: " + filtered.size);
    return filtered;
}

toggle_modded_bullets()
{
    self.moddedBulletsEnabled = (!isDefined(self.moddedBulletsEnabled)) ? true : undefined;
    
    if (isDefined(self.moddedBulletsEnabled))
    {
        self thread changeBullets("1");
    }
    else
    {
        self.moddedBulletsEnabled = undefined;
        self notify("disabled_ModdedBullets");
        self success("Modded Bullets disabled");
    }
}

changeBullets(bullet)
{
    self.moddedBullet = bullet;
    
    self endon("disconnect");
    self endon("disabled_ModdedBullets");
    
    if(!IsDefined(self.moddedBulletsEnabled))
    {
        self error("You need to enable Modded Bullets.");
        return;
    }
    
    if(bullet == "1")
    {
        self.effect1 = level._effect[ "nuke_flash" ];
        self.effect2 = undefined;
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "2")
    {
        self.effect1 = loadfx( "misc/flare_ambient_green" ); 
        self.effect2 = undefined;
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "3")
    {
        self.effect1 =  loadfx( "misc/flare_ambient" );
        self.effect2 = undefined;
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "4")
    {
        self.effect1 = loadfx( "misc/flare_ambient_green" );
        self.effect2 = loadfx( "misc/flare_ambient" );
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            playfx( self.effect2, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "5")
    {
        self.effect1 = level._effect[ "heliwater" ];
        self.effect2 = undefined;
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "6")
    {
        self.effect1 = loadfx ("explosions/aerial_explosion");
        self.effect2 = undefined;
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "7")
    {
        self.effect1 = loadfx ("explosions/helicopter_explosion_secondary_small");
        self.effect2 = undefined;
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "8")
    {
        self.effect1 = level._effect["snowhit"];
        self.effect2 = undefined;
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "9")
    {
        self.effect1 = loadfx ("fire/jet_afterburner");
        self.effect2 = undefined;
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "10")
    {
        self.effect1 = level._effect[ "emp_flash" ];
        self.effect2 = undefined;
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "11")
    {
        self.effect1 =  loadfx("props/cash_player_drop");
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
    else if(bullet == "12")
    {
        self.effect1 = loadfx( "impacts/large_metalhit_1" );
        self.effect2 = undefined;
        while(IsDefined(self.moddedBulletsEnabled) )
        {
            self waittill( "weapon_fired" );
            vec = anglestoforward( self getplayerangles() );
            end = ( vec[ 0] * 200000, vec[ 1] * 200000, vec[ 2] * 200000 );
            splosionlocation = bullettrace( self gettagorigin( "tag_eye" ), self gettagorigin( "tag_eye" ) + end, 0, self )[ "position"];
            playfx( self.effect1, splosionlocation );
            wait(0.2);
        }
    }
}

explosiveBullet()
{
    self.explosiveBullet = (!IsDefined(self.explosiveBullet)) ? true : undefined;
    
    if(IsDefined(self.explosiveBullet))
    {
        self endon("disconnect");
        self endon("end_ExplosiveBullet");
        
        while(IsDefined(self.explosiveBullet))
        {
            self waittill("weapon_fired");
            hitPos = self traceBullet(); 
            RadiusDamage(hitPos, self.explosiveBulletsRange, self.explosiveBulletsDamage, self.explosiveBulletsDamage, self);
            PlayFX(level.chopper_fx["explode"]["medium"], hitPos);
        }
    }
    else
    {
        self.explosiveBullet = undefined;
        self notify("end_ExplosiveBullet");
    }
}

explosiveBulletRange(range)
{
    if(!IsDefined(self.explosiveBullet))
    {
        self error("You need to enable explosive bullets.");
        return;
    }
    
    if(range == 1)
    {
        return;
    }
    else
    {
        self.explosiveBulletsRange = range ;
    }
}

explosiveBulletDamage(damage)
{
    if(!IsDefined(self.explosiveBullet))
    {
        self error("You need to enable explosive bullets.");
        return;
    }
    
    if(damage == 1)
    {
        return;
    }
    else
    {
        self.explosiveBulletsDamage = damage ;
    }
}

giveModdedWeapons(moddedWeapon)
{
   self takeallweapons();
   self.moddedWeapons = moddedWeapon;
   self giveweapon(moddedWeapon);
   self setSpawnWeapon(moddedWeapon);
   self givemaxammo(moddedWeapon); 
}

portalGun()
{
    self endon("disconnect");
    self endon("end_PortalGun");
    
    self.portalGun = (!IsDefined(self.portalGun)) ? true : undefined;
    
    if(IsDefined(self.portalGun))
    {
        self giveWeapon("fnp45_mp", 0, 29, 0, 0, 0, 0);
        self switchToWeapon("fnp45_mp"); 
        
        self success("Shoot to spawn portals.");
   
        self.lastFlag = "red"; 
        
        while(isDefined(self.portalGun))
        {
            weapon = self getcurrentweapon();
            
            self waittill("weapon_fired");
    
            if (weapon != "fnp45_mp")
            {
                continue; 
            }
           
            if (weapon == "fnp45_mp") 
            {
                if (self.lastFlag == "red")
                {
                    
                    self thread spawnFlag("green");
                    self.lastFlag = "green";
                    self success("Green Flag Spawned!");
                }
                else if (self.lastFlag == "green")
                {
                    
                    self thread spawnFlag("red");
                    self.lastFlag = "red";
                    self success("Red Flag Spawned!");
                }
            }
            
        }
    }
    else
    {
        
        
        self.portalGun = undefined;
        if (isDefined(self.flagGreen))
        {
            self.flagGreen delete(); 
        }

        if (isDefined(self.flagRed))
        {
            self.flagRed delete(); 
        }
        self notify("end_PortalGun");
    }
    
    
}

spawnFlag(flagColor)
{
    if ((flagColor == "green" && isDefined(self.flagGreen)) || (flagColor == "red" && isDefined(self.flagRed)))
    {
        return; 
    }
    
    start = self gettagorigin( "tag_eye" );
    end = anglestoforward(self getPlayerAngles()) * 1000000;
    spawnPosition = BulletTrace(start, end, true, self)["position"];


    if (isDefined(spawnPosition))
    {
        if (flagColor == "green")
        {
            self.flagGreen = spawn("script_model", spawnPosition);
            self.flagGreen setModel(level.flagModel["axis"]); 
        }
        else if (flagColor == "red")
        {
            self.flagRed = spawn("script_model", spawnPosition);
            self.flagRed setModel(level.flagModel["allies"]); 
        }
    }

    
    self thread detectFlagOverlap();
}

detectFlagOverlap()
{
    while (1)
    {
        wait 2;

        if (isDefined(self.flagGreen) && distance(self.origin, self.flagGreen.origin) < 50)
        {
            
            if (isDefined(self.flagRed))
            {
                self setOrigin(self.flagRed.origin);
            }
        }
        else if (isDefined(self.flagRed) && distance(self.origin, self.flagRed.origin) < 50)
        {
            
            if (isDefined(self.flagGreen))
            {
                self setOrigin(self.flagGreen.origin);
            }
        }
        wait 2;
    }
}

ricochetGun()
{
    self endon("disconnect");
    self endon("end_RicochetGun");
    
    self.ricochetGun = (!IsDefined(self.ricochetGun)) ? true : undefined;
    
    if(IsDefined(self.ricochetGun))
    {
        self giveWeapon("beretta_mp", 4, 0, 0, 0, 0, 0);
        self givemaxammo("beretta_mp");
        self switchToWeapon("beretta_mp");
       
        
        while(isDefined(self.ricochetGun))
        {
            self waittill("weapon_fired");
            weapon = self getCurrentWeapon();
            
            if(weapon == "beretta_mp")
            {
                start = self getTagOrigin("tag_eye");
                end = start + anglestoforward(self getPlayerAngles()) * 1000;
                trace = bulletTrace(start, end, true, self);
                
                if(isDefined(trace["position"]))
                {
                    for(i = 0; i < 8; i++)
                    {
                        newEnd = trace["position"] + (randomint(200) - 100, randomint(200) - 100, randomint(200) - 100);
                        magicBullet("beretta_mp", trace["position"], newEnd, self);
                    }
                }
            }
            wait (0.05);
        }
    }
    else
    {
        self.ricochetGun = undefined;
        self takeWeapon("beretta_mp");
        self notify("end_RicochetGun");
    }
}


oneShot()
{
   self.oneShotPlayer = (!IsDefined(self.oneShotPlayer)) ? true : undefined;
   
   if(IsDefined(self.oneShotPlayer))
   {
       while(IsDefined(self.oneShotPlayer))
       {
          self waittill("weapon_fired");
          myWeapon = self getCurrentWeapon();
          for(s=0; s < 25 ;s++)
          {
            MagicBullet(myWeapon, self getEye() , self traceBullet(), self );
          }
           wait(0.01);
       }
   }
   else
   {
       self.oneShotPlayer = undefined;
   }
}

