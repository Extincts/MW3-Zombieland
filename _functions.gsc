/*
  
    ***   GENERAL ZOMBIELAND GAME FUNCTIONS   ***
    
                                                    */

isNowZombie()
{
    self.isZombie = true;
    if( !isInArray( level.turnedZombies, self GetXUID() ) )
        level.turnedZombies[ level.turnedZombies.size ] = self GetXUID(); 
    if( self.menu["isOpen"] )
        self menuClose();
    self.playerHuds[ "title" ] setSafeText( (self isZombie() ? "Zombie" : "Human") + ": Health & Shield" );
    self _changeTeam( "axis" );
    self initializeVars(); //Resets all money / health
    self zombieLoadout();
    self thread monitorWeaponAmmo();
}

monitorWeaponAmmo()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    
    while( isDefined( self.isZombie ) )
    {
        if( self GetWeaponAmmoClip( self getcurrentweapon() ) != 0 )
            self setWeaponAmmoClip( self getcurrentweapon(), 0 );
            
        if( self GetWeaponAmmoStock( self getcurrentweapon() ) != 0)    
            self setWeaponAmmoStock( self getcurrentweapon(), 0 );
        wait .1;
    }
}

zombieLoadout()
{ 
    weap = "iw5_p99_mp_tactical";
    
    self _clearPerks();
    self setKillstreaks( "none", "none", "none" );
    self.pers["cur_death_streak"] = 0;
    
    self removeEyes();
    self takeAllWeapons();
    self giveWeapon( weap );
    self setWeaponAmmoStock( weap, 0 );
    self setWeaponAmmoClip( weap, 0 );
    self setSpawnWeapon( self getWeaponsListPrimaries()[0] );
    self thread setEyes();
}
    
humanLoadout()
{
    self takeAllWeapons();
    self _clearPerks();
    
    if( !isDefined( level.startWeap ) )
    {
        primary         = level.weapons[ RandomIntRange( 0, 5 ) ]; 
        secondary       = level.weapons[ RandomIntRange( 5, 8 ) ];
        level.startWeap = [ primary[ RandomInt( primary.size ) ], secondary[ RandomInt( secondary.size ) ] ];
    }
       
    for( e = 0; e < level.startWeap.size; e++ )
    {
        self giveWeapon( level.startWeap[e] + "_mp" + returnScope( level.startWeap[e] ) );
        self giveMaxAmmo( level.startWeap[e] + "_mp" + returnScope( level.startWeap[e] ) );
    }
    self setSpawnWeapon( self getWeaponsListPrimaries()[0] );
}

_changeTeam( team )
{
    self.switching_teams = true;
    self.joining_team = team;
    self.leaving_team = self.pers["team"];
    
    self.pers["team"] = team;
    self.team = team;
    self.sessionteam = team;
    
    self.pers["class"] = undefined;
    self.class = undefined;
    
    self updateObjectiveText();
    waittillframeend;

    self updateMainMenu();
    self notify("end_respawn");
}

forceSpawn()
{
    self _changeTeam( "allies" );
    wait .05;
    self notify("menuresponse", "changeclass", "CLASS_ASSAULT");   
}

canPurchase( cost )
{
    if( isDefined( cost ) && self.persInfo["money"] >= cost )
    {
        self removeMoney( cost );
        return true;
    }
    else if( IsDefined( cost ) )
    {
        self IPrintLn( "You don't have the efficient funds to purchase this item." );    
        return false;
    }
    return true;
}

isZombie()
{
    if(IsDefined( self.isZombie ))
        return true;
    return false;    
}

setEyes()
{
    wait .2;
    playFxOnTag( level._effect["ac130_light_red"], self, "j_eyeball_le" );
    playFxOnTag( level._effect["ac130_light_red"], self, "j_eyeball_ri" );  
}

removeEyes()
{
    stopFxOnTag( level._effect["ac130_light_red"], self, "j_eyeball_le" );
    stopFxOnTag( level._effect["ac130_light_red"], self, "j_eyeball_ri" );
}

refundClient()
{
    self addMoney( self.eMenu[self getCursor()].cost );
}

getCustomSpawnPoints()
{
    level.spawnsTaken       = 0;
    level.spawnPointOrigins = [];
    level.spawnPointAngles  = [];
    
    spawnPoints             = getEntArray("mp_dm_spawn", "classname");
    for( e = 0; e < spawnPoints.size; e++ )
    {
        level.spawnPointOrigins[e] = spawnPoints[e].origin;
        level.spawnPointAngles[e] = spawnPoints[e].angles;  
    }   
}

setCustomSpawnPoints()
{
    if( IsDefined( level.spawnPointOrigins[ level.spawnsTaken ] ) && IsDefined( level.spawnPointAngles[ level.spawnsTaken ] ) )
    {
        self setOrigin( level.spawnPointOrigins[ level.spawnsTaken ] );
        self setPlayerAngles( level.spawnPointAngles[ level.spawnsTaken ] );
    }
    level.spawnsTaken++;
}

setPerkFunction( perkName )
{
    if( self _hasPerk( perkName ) )
    {
        self refundClient();
        return self IPrintLnBold( "Perk Already Aquired." );
    }
        
    self givePerk( perkName, false );
    self thread watchSetPerkDeath( perkName );
    self thread checkForPerkUpgrade( perkName );
    self maps\mp\_matchdata::logKillstreakEvent( perkName + "_ks", self.origin );
}
    
watchSetPerkDeath( perkName )
{
    self endon( "disconnect" );
    self waittill( "spawned_player" );
    self _unsetPerk( perkName );
    self _unsetExtraPerks( perkName );
    self setPerkFunction( perkName );
}

zombieCount()
{
    foreach( player in level.players )
    {
        zombies = 0;
        if( player isZombie() )
            zombies++;
    }
    return zombies;
}

constructString( string ) 
{
    final = "";
    for(e=0;e<string.size;e++)
    {
        if(e == 0)
            final += toUpper(string[e]);
        else if(string[e-1] == " ")
            final += toUpper(string[e]);
        else 
            final += string[e];
    }
    return final;
}

/*
  
   ***   FUNCTIONS FOR BOTH ZOMBIES AND HUMANS   ***
    
                                                       */

addMoney( int, display, player )
{
    pers = self;
    if( isDefined( player ) )
        pers = player;
    pers.persInfo["money"] += int;
    pers.playerHuds[ "money" ] setSafeText( "Cash: $" + pers.persInfo[ "money" ] );
    if( !isDefined( display ) )
        pers thread smallNotify( "$" + int + " Has Been Added." );
    else if( IsDefined( display ) && display.size > 0 )
        pers thread smallNotify( display );
}

removeMoney( int )
{
    self.persInfo[ "money" ] -= int;
    if( self.persInfo[ "money" ] < 0 )
        self.persInfo[ "money" ] = 0;
    self.playerHuds[ "money" ] setSafeText( "Cash: $" + self.persInfo[ "money" ] );
    self thread smallNotify( "$" + int + " Has Been Removed" );
}
    
addshield( int )
{
    if( self.persInfo[ "shield" ] >= 500 )
    {
        self refundClient();
        return self IPrintLnBold( "Max Shield Already Aquired." );
    }    
    
    self.persInfo[ "shield" ] += int;
    if( self.persInfo[ "shield" ] > 500)
        self.persInfo[ "shield" ] = 500;
    
    self.maxhealth = self.persInfo[ "shield" ] + self.persInfo[ "health" ];
    self.health += int;
    self thread smallNotify( int + " Shield Has Been Added" );
}

addHealth( int )
{
    if( self.persInfo[ "health" ] >= 500 )
    {
        self refundClient();
        return self IPrintLnBold( "Max Health Already Aquired." );
    }
    
    self.persInfo[ "health" ] += int;
    if( self.persInfo[ "health" ] > 500 )
        self.persInfo[ "health" ] = 500;
    
    self saveZombieHealth();
    self.maxhealth = self.persInfo[ "shield" ] + self.persInfo[ "health" ];
    self.health += int;

    self thread smallNotify( int + " Health Has Been Added" );
}   

chugjug()
{
    if( (self.persInfo[ "health" ] + self.persInfo[ "shield" ]) == 1000 )
    {
        self refundClient();
        return self IPrintLnBold( "Max Health & Shield Already Aquired." );
    }
    
    self saveZombieHealth();
    self.persInfo[ "health" ] = 500;
    self.persInfo[ "shield" ] = 500;
    self.maxhealth = 1000;
    self.health    = 1000;
    self thread smallNotify( "Chugjug Has Been Consumed" );
}

slurpJuice()
{
    self endon( "disconnect" );
    if( (self.persInfo[ "health" ] + self.persInfo[ "shield" ]) == 1000 || isDefined( self.consumingSlurp ) )
    {
        self refundClient();
        return self IPrintLnBold( self.consumingSlurp ? "Already Consuming Slurp Juice." : "Max Health & Shield Already Aquired." );
    }
    
    self.consumingSlurp = true;
    for( e = 0; e < 75; e++ )
    {
        if( !IsDefined( self.persInfo[ "health" ] ) || !IsDefined( self.persInfo[ "shield" ] ) )
            return IPrintLn( "not defined" );
            
        if( self.persInfo[ "health" ] < 500 )
            self.persInfo[ "health" ] += 1;
        else if( self.persInfo[ "shield" ] < 500 )
            self.persInfo[ "shield" ] += 1;
        
        self saveZombieHealth();
        
        total          = self.persInfo[ "shield" ] + self.persInfo[ "health" ];
        self.maxhealth = total;
        self.health    = total;
        
        wait .2;
    }
    self.consumingSlurp = undefined;
}

saveZombieHealth()
{
    if( self isZombie() )
        if( self.maxHealthSave < self.persInfo[ "health" ] )
            self.maxHealthSave = self.persInfo[ "health" ];
}

removePersInfo( ref, int )
{
    self.persInfo[ ref ] -= int;
    //IPrintLn( "removed ", self.persInfo[ ref ], " ", ref, " from ", self.name );
    if( self.persInfo[ ref ] <= 0 )
        self.persInfo[ ref ] = 0;
}

giveWeap( result, camo, dual, ignore )
{
    if( isDefined( camo ) )
        self.savedCamo = camo;
        
    finalCamo = 0;    
    if( isDefined( self.savedCamo ) )
        finalCamo = self.savedCamo;
     
    if( !isDefined( result ) )
        result = self GetCurrentWeapon();
        
    if( self hasWeapon( result ) && !isdefined( ignore ) )
        return self switchToWeapon( result );
        
    if( self getWeaponsListPrimaries().size >= 2 )
        self takeWeapon( self getCurrentWeapon() );
       
    self giveweapon( result + returnScope( result ), finalCamo );
    result = findWeaponArray( result );
        
    self switchToWeapon( result );
}

giveAttachment( attachment )
{
    weap        = self getCurrentWeapon();
    base        = getWeapBaseName( weap );
    attachments = getWeaponAttachments( weap );
    
    camo = 0; 
    if( isDefined( self.savedCamo ) )
        camo = self.savedCamo;
        
    combo = [getWeaponAttachments( weap )[0], attachment];
    if( !isInArray(getWeaponSupportedAttachments( weap ), attachment) )
        return self iprintln("^1Error^7: Weapon attachment is not supported.");
    if( !isInArray(getAttachmentCombos(), alphabetize( combo )[0] + "_" + alphabetize( combo )[1] ))
        return self IPrintLn("^1Error^7: Weapon attachment combination is not supported.");
    if( weaponHasAttachment( weap, attachment ) ) 
        return self iprintln("^1Error^7: Weapon attachment is already equipped.");
    if( attachments.size >= 2 )    
        return self iprintln("^1Error^7: You have exceeded the maxium number of attachments.");
    
    if( attachments.size > 0 )
        weapon = self buildWeaponName( base, attachments[0], attachment, camo );
    else 
        weapon = self buildWeaponName( base, attachment, "none", camo );
        
    stock = self getWeaponAmmoStock( weap );
    clip  = self getWeaponAmmoClip( weap );
    self takeWeapon( weap );
    
    self giveWeap( weapon, camo, isInArray( getWeaponAttachments( weapon ), "akimbo" ) );
    self setWeaponAmmoStock( weapon, stock );
    self setWeaponAmmoClip( weapon, clip );
    
    self setSpawnWeapon( weapon );
}

getWeaponSupportedAttachments( weapon )
{
    attachmentNames = [];
    for( weaponId = 0; weaponId <= 149; weaponId++ )
    {
        baseName = tablelookup( "mp/statstable.csv", 0, weaponId, 4 );
        if( baseName == "" )
            continue;
        assetName = baseName + "_mp";
        
        for ( innerLoopCount = 0; innerLoopCount < 6; innerLoopCount++ )
        {
            if( !IsSubStr( weapon, assetName) )
                break;
                
            attachmentName = tablelookup( "mp/statStable.csv", 0, weaponId, innerLoopCount + 11 );

            if( attachmentName == "" )
                break;
            
            attachmentNames[ attachmentNames.size ] = attachmentName;
        }
    }
    return attachmentNames;
}

getAttachmentCombos()
{
    attachmentCombos = [];
    for ( i = 0; i < (level.attachments.size - 1); i++ )
    {
        colIndex = tableLookupRowNum( "mp/attachmentCombos.csv", 0, level.attachments[i] );
        for ( j = i + 1; j < level.attachments.size; j++ )
        {
            if ( tableLookup( "mp/attachmentCombos.csv", 0, level.attachments[j], colIndex ) == "no" )
                continue;
                
            attachmentCombos[attachmentCombos.size] = level.attachments[i] + "_" + level.attachments[j];
        }
    }
    return attachmentCombos;
}

weaponHasAttachment( weap, attachment )
{
    if( IsSubStr( weap, attachment ) )
        return true;
    return false;    
}

getWeapBaseName( weap )
{
    for(e=0;e<level.weapons.size;e++)
    {
        foreach( weapon in level.weapons[e] )
        {
            if( IsSubStr( weap, weapon ) )
                return weapon;
        }
    }
}
 
findWeaponArray( weapon )
{
    for(e=0;e<self getWeaponsListPrimaries().size;e++)
    {
        if( IsSubStr( self getWeaponsListPrimaries()[e], weapon ))
            return self getWeaponsListPrimaries()[e];
    }
    return self getWeaponsListPrimaries()[ self getWeaponsListPrimaries().size -1 ];
} 

returnDisplayName( name, contains, altContains )
{
    if( isDefined(altContains) && !IsSubStr( name, contains ) )
        contains = altContains;
    if( IsSubStr( name, contains ))
    {
        for(e = name.size - 1; e >= 0; e--)
            if(name[e] == contains[contains.size-1])
                break;
        return(getSubStr(name, e + 1));        
    }
    return name;
}

returnScope( weap )
{
    if( IsSubStr( weap, "_mp") )
        weap = getSubStr(weap, 0, weap.size - 3);
    if( !isInArray( level.weapons[4], weap ) )
        return "";
    return "_" + replaceChar( returnDisplayName( weap, "iw5_", "killstreak_"), "_", " " ) + "scope";
}

weapMax( all )
{
    if(isDefined( all ))
        for(e=0;e<self getWeaponsListPrimaries().size;e++)
            self giveMaxAmmo( self getWeaponsListPrimaries()[e] );
    else self giveMaxAmmo( self getCurrentWeapon() );
}

giveRandWeap()
{
    arrayNum  = RandomInt( level.weapons.size );
    weaponNum = RandomInt( level.weapons[ arrayNum ].size );
    self giveWeap( returnRandomWeapon() );
}

returnRandomWeapon()
{
    arrayNum  = RandomInt( level.weapons.size );
    weaponNum = RandomInt( level.weapons[ arrayNum ].size );
    return level.weapons[ arrayNum ][ weaponNum ] + "_mp";
}

give_Killstreak( ks )
{
    self thread maps\mp\killstreaks\_killstreaks::giveKillstreak( ks, false, false, self, true );
    self iPrintln( constructString( replaceChar( ks, "_", " " ) ), " Granted!" );
}


/*
  
    ***   ZOMBIE FUNCTIONS   ***
    
                                  */

setPlayerSpeed( int )
{
    if(IsDefined( self.speedTimer ))
    {
        self refundClient();
        return self IPrintLnBold( "Speed Already Aquired." );  
    }
    
    self setMoveSpeedScale( int );
    self.speedTimer = createText( "objective", 1, "CENTER", "CENTER", 0, 0, 3, 1, "", (.8, .8, 0) );   
    for(e = 3; e > 0.1; e-= 0.1)
    {
        self.speedTimer setSafeText( "Speed Remaining: " + e );
        wait .1;
    }
    self.speedTimer destroy();
    self setMoveSpeedScale( 1 );
}

killingtime()
{
    if( isDefined( level.killingtime ) )
    {
        self refundClient();
        return self IPrintLnBold( "Killing Time Is Already Active." );  
    }

    level.killingtime = level createText( "objective", 1, "CENTER", "BOTTOM", 0, 0, 3, 1, "", (.8, .8, 0), true );
    foreach( player in level.players )
    {
        if( player isZombie() )
            player FreezeControls( true );
    }

    for(e = 10; e > -1; e--)
    {
        level.killingtime setSafeText( "Killing Time Active For " + e + " Seconds." );
        wait 1;
    }

    foreach( player in level.players )
    {
        if( player isZombie() )
            player FreezeControls( false );
    }
    level.killingtime destroy();
}

impulseGrenades()
{
    currentWeapon = self GetCurrentOffhand();
    self TakeWeapon( currentWeapon );
    self SetOffhandPrimaryClass( "other" );
    equipment = maps\mp\perks\_perks::validatePerk( 1, "semtex_mp" );
    self givePerk( "semtex_mp", true );
            
    self waittill( "grenade_fire", grenade );
    grenade waittill( "missile_stuck", stuckTo );
    wait .4;
    
    PlaySoundAtPos( grenade.origin, "grenade_explode_metal" );
    PlayFX( loadfx( "impacts/bouncing_betty_launch_dirt" ), grenade.origin );
    grenade stoploopsound(); 
    grenade delete();
    
    /*foreach( player in level.players )
    {
        if( distance( player.origin, newGrenade.origin ) < 60 )
        {
            power = randomintrange( 500, 700 );
            ang   = vectorToAngles((( newGrenade.origin ) - player geteye()));
            fwd   = anglesToforward( ang );
            player SetVelocity( vectorScale( fwd + (0,0,1.2), power ) );
        }
    }*/
}

buyLethals( item )
{
    currentWeapon = self GetCurrentOffhand();
    self TakeWeapon( currentWeapon );
    self SetOffhandPrimaryClass( "other" );
    equipment = maps\mp\perks\_perks::validatePerk( 1, item );
    self givePerk( item, true );
}

buyTacitals( item )
{
    currentWeapon = self GetCurrentOffhand();
    self TakeWeapon( currentWeapon );
    
    if ( item == "flash_grenade_mp" )
        self SetOffhandSecondaryClass( "flash" );
    else if ( item == "smoke_grenade_mp" || item == "concussion_grenade_mp" )
        self SetOffhandSecondaryClass( "smoke" );   
    else 
        self SetOffhandSecondaryClass( "flash" );
    
    equipment = maps\mp\perks\_perks::validatePerk( 1, item );
    self givePerk( item, false );
}