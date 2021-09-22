loadEffects()
{
    //light_glow_walllight_white
    //angle_flare_geotrail
    //laserTarget
    
    level._effect[ "ac130_light_red" ] = loadfx( "misc/aircraft_light_wingtip_red" );
    level._effect[ "nuke_aftermath" ]  = loadfx( "dust/nuke_aftermath_mp" );
    
    list          = ["misc/ui_flagbase_red", "misc/ui_flagbase_black", "misc/ui_flagbase_gold", "misc/ui_flagbase_silver"];
    level.circles = [];
    foreach( fxID in list )  
        level.circles[ cutString( fxID, "_" ) ] = loadfx( fxID );
}

spawnMapEdit()
{
    if( level.script == "mp_terminal" )
    {
        bounceOriginList      = strTok( "2360,6175,192;1912,4458,192;1403,3136,40;766,2950,184;465,3310,184;128,3341,40", ";" );
        ziplineOriginsList    = StrTok( "352,4569,306;1671,4217,450;1695,2560,422;2645,3077,40;1967,3465,180;3010,3500,192", ";" );
        weaponOriginList      = strtok( "1551,7241,192;1078,7245,192;590,6972,192;188,6770,192;408,6482,192;-450,5594,192;-275,4892,193;64,4850,192;592,4971,192;613,2836,202;358,4134,304;603,4002,341;610,3083,342;244,3192,176;34,3495,112;1312,2598,156;1047,3152,176;1627,3051,184;1936,3215,120;2643,2787,40;2157,4336,304;1604,4248,168;1272,5586,192;1439,5624,192;2405,6295,192;2644,6229,372;2619,5478,192;2237,5466,192;2868,4515,192;3205,4988,192;3985,4349,192;3929,3681,192;4480,3329,192;4329,2428,192;3717,2443,192;3351,2796,192;3070,2927,192;2154,3259,48;2011,4194,48",";");   
        teleportalOriginsList = StrTok( "-895,5228,192; 2642,6229,372; -758,5064,192; 1275,5603,368; -1050,5064,192; 4319,2466,192", ";" );
        
        doorOriginsList = StrTok( "-1108,4640,222; -666,4640,222", ";" ); //OPEN;CLOSE
        doorWidthsList  = StrTok( "8", ";" ); //WIDTH 
        doorHeightsList = StrTok( "2", ";" ); //HEIGHT
                                                                                               
        wallOriginsList = StrTok( "-1149,4642,192; -1151,5440,192; -1160,4641,222; -1308,4640,222; -640,4642,192; -640,5440,192; -596,4640,222; -490,4640,222", ";" ); 
        wallHeightList  = StrTok( "3;3;3;3", ";" );
    }
    if( level.script == "mp_bootleg" )
    {
        bounceOriginList      = strTok( "1189,-28,418;-1123,-69,370", ";" );
        ziplineOriginsList    = StrTok( "1250,825,418;-1647,1529,-51;950,-396,578;-88,-490,227;-186,-62,253;-763,-64,370;-1412,-637,546;-2127,-1024,-39", ";" );
        weaponOriginList      = strtok("132,-55,-99;-398,-81,-67;-864,-158,78;181,563,-95;349,356,52;-281,1594,-95;-997,1854,-100;-1206,1439,-101;1424,-361,578;547,599,-100;780,-370,-81;358,-1229,-69;-94,-899,-73;-795,-875,-67;-1604,-1335,2;-714,-1610,0;-1245,-333,78;-1658,-444,80;-1824,-1159,3;-2372,-808,-39;-1525,360,-52;-1568,1180,-51;-1016,1818,-100;-307,1561,-95;328,1250,-104;979,1207,-87;1193,678,418;1178,305,438;1660,-213,578;1147,-525,578;-116,-396,227;-138,207,227;-143,-549,546;-1199,-529,546;-1087,292,546;-259,430,546",";");   
        teleportalOriginsList = StrTok( "-165,340,227;-901,-129,-67", ";" );
    }
    if( level.script == "mp_dome" )
    {
        bounceOriginList      = strTok( "888,-1146,-351;-802,-402,-412", ";" );
        ziplineOriginsList    = StrTok( "-639,496,-398;-511,-337,-307;1912,740,-202;410,214,-194;257,592,-180;-785,1422,-265", ";" );
        weaponOriginList      = strtok( "-637,-356,-307;-995,-168,-302;-912,-464,-411;-1166,54,-395;-1148,366,-291;-1119,186,-303;-967,-166,-302;-282,129,-194;251,347,-194;723,-319,-395;1299,-191,-388;1337,0,-394;1269,780,-328;1131,820,-329;546,1056,-312;-13,1125,-294;-605,1092,-326;-1123,889,-451;-925,621,-451;-739,233,-415;-1407,1072,-423;-1531,1360,-427;-1160,1523,-427;-413,1725,-286;217,610,-170;285,-555,-282;381,-962,-275;706,-974,-268;1166,-1002,-350;1390,-614,-372;1711,143,-341;1994,1071,-250;1997,1479,-184;1363,1951,-254;978,2369,-254;508,2351,-254;456,1762,-254;931,1376,-254;460,1424,-254;983,1119,-262",";");   
        teleportalOriginsList = StrTok( "812,1105,-262;910,1255,-254;793,1463,-254;709,1461,-254", ";" );
    }

    if( isDefined( bounceOriginList ) )
    {
        level.bouncePads   = [];
        level.bouncePadsFx = [];
        for( e = 0; e < bounceOriginList.size; e++ )
        {
            origins = strTok( bounceOriginList[e], "," );
            level.bouncePads[ level.bouncePads.size ] = modelSpawner( (int(origins[0]), int(origins[1]), int(origins[2])), "tag_origin" );
            level.bouncePads[ level.bouncePads.size - 1 ] thread createBounce( 50, 160, 1 );
            
            level.bouncePadsFx[ level.bouncePadsFx.size ] = spawnFx( level.circles[ "red" ], (int(origins[0]), int(origins[1]), int(origins[2])));
            TriggerFX( level.bouncePadsFx[ level.bouncePadsFx.size - 1 ] );
        }
    }

    if( isDefined( ziplineOriginsList ) )
    {
        level.ziplines     = [];
        level.ziplinesFx   = [];
        for( e = 0; e < (ziplineOriginsList.size) / 2; e++ )
        {
            origins = strTok( ziplineOriginsList[2 * e] + "," + ziplineOriginsList[(2 * e ) + 1], "," );
            level.ziplines[ level.ziplines.size ] = modelSpawner( (int(origins[0]), int(origins[1]), int(origins[2])), "prop_flag_neutral" ); //Flag maybe?
            level.ziplines[ level.ziplines.size ] = modelSpawner( (int(origins[3]), int(origins[4]), int(origins[5])), "prop_flag_neutral" ); //Flag maybe?
            level.ziplines[ level.ziplines.size - 1 ] thread createZipline( level.ziplines[ level.ziplines.size - 2 ], level.ziplines[ level.ziplines.size - 1 ], 50 );
            
            level.ziplinesFx[ level.ziplinesFx.size ] = spawnFx( level.circles[ "black" ], (int(origins[0]), int(origins[1]), int(origins[2])));
            level.ziplinesFx[ level.ziplinesFx.size ] = spawnFx( level.circles[ "black" ], (int(origins[3]), int(origins[4]), int(origins[5])));  
            TriggerFX( level.ziplinesFx[ level.ziplinesFx.size - 1 ] );
            TriggerFX( level.ziplinesFx[ level.ziplinesFx.size - 2 ] );
        }
    }
    
    if( isDefined( teleportalOriginsList ) )
    {
        level.teleportals   = [];
        level.teleportalsFx = [];
        for( e = 0; e < (teleportalOriginsList.size) / 2; e++ )
        {
            origins = strTok( teleportalOriginsList[2 * e] + "," + teleportalOriginsList[(2 * e ) + 1], "," );
            level.teleportals[ level.teleportals.size ] = spawnFx( level.circles[ "black" ], (int(origins[0]), int(origins[1]), int(origins[2])));
            level.teleportals[ level.teleportals.size ] = spawnFx( level.circles[ "black" ], (int(origins[3]), int(origins[4]), int(origins[5])));  
            TriggerFX( level.teleportals[ level.teleportals.size - 1 ] );
            TriggerFX( level.teleportals[ level.teleportals.size - 2 ] );
            level.teleportals[ level.teleportals.size - 1 ] thread createTeleportal( level.teleportals[ level.teleportals.size - 2 ], level.teleportals[ level.teleportals.size - 1 ], 50 );
        }
    }

    if( isDefined( weaponOriginList ) )
    {
        level.weaponSpawns   = [];
        level.weaponSpawnsFx = [];
        for( e = 0; e < weaponOriginList.size; e++ )
        {
            if( doCoinToss() )
            {
                origins    = strTok( weaponOriginList[e], "," );
                
                if( doCoinToss() )
                {
                    custom = [ "com_deploy_ballistic_vest_friend_world", "prop_suitcase_bomb" ];
                    model  = custom[ RandomInt( custom.size ) ];
                }
                else
                {
                    randomWeap = returnRandomWeapon();
                    model      = GetWeaponModel( randomWeap ); 
                
                }
                
                level.weaponSpawns[ level.weaponSpawns.size ] = modelSpawner( (int(origins[0]), int(origins[1]), int(origins[2]) + 40), model );
                level.weaponSpawnsFx[ level.weaponSpawnsFx.size ] = spawnFx( level._effect["fluorescent_glow"], (int(origins[0]), int(origins[1]), int(origins[2]) + 40));
                TriggerFX( level.weaponSpawnsFx[ level.weaponSpawnsFx.size - 1 ] );
            
                level.weaponSpawns[ level.weaponSpawns.size - 1 ] thread rotateObj();
                level.weaponSpawns[ level.weaponSpawns.size - 1 ] thread createWeaponTrigger( randomWeap, level.weaponSpawnsFx[ level.weaponSpawnsFx.size - 1] );
            }
        }
    }
    
    if( IsDefined( doorOriginsList ) )
    {
        for( e = 0; e < (doorOriginsList.size) / 2; e++ )
        {
            origins = strTok( doorOriginsList[2 * e] + "," + doorOriginsList[(2 * e ) + 1], "," );
            level thread CreateDoor("com_plasticcase_friendly", (int(origins[0]), int(origins[1]), int(origins[2])), (int(origins[3]), int(origins[4]), int(origins[5])), int(doorWidthsList[e]), int(doorHeightsList[e]), 58, 33, 1000, 1000);
        }
    }
    
    if( IsDefined( wallOriginsList ) )
    {
        for( e = 0; e < (wallOriginsList.size) / 2; e++ )
        {
            origin  = [];
            origins = strTok( wallOriginsList[2 * e] + "," + wallOriginsList[(2 * e) + 1], "," );
            origin[0] = (int(origins[0]), int(origins[1]), int(origins[2]));
            origin[1] = (int(origins[3]), int(origins[4]), int(origins[5]));
            
            distance = Distance2D( origin[0], origin[1] );
            blocks   = roundUp( distance / 58 );
            height   = int( wallHeightList[e] ); 
                
            wall = modelSpawner(origin[0], "tag_origin");
            for(b=0;b<blocks+1;b++) for(h=0;h<height;h++)
            {
                block = modelSpawner(origin[0] + (0, (b * 58), (h * 32)), "com_plasticcase_friendly", (0, 90, 0), undefined, true);
                block EnableLinkTo();
                block LinkTo( wall );
            }
            wall.angles = (0, VectorToAngles(origin[0] - origin[1])[1] + 90, 0);        
        }
    }
}

roundUp( floatVal )
{
    if ( int( floatVal ) != floatVal )
        return int( floatVal + 1 );
    else
        return int( floatVal );
}

createWeaponTrigger( weapon, fx )
{
    while( isDefined( self ) )
    {
        foreach( player in level.players )
        {
            if( Distance( self.origin, player.origin ) < 50 )
            {
                if( !isDefined( player.hintString ) )
                    player thread doHintString( "Press [{+reload}] To Pick Up Item", self.origin, 50);
                    
                if( player UseButtonPressed() && self.model == "com_deploy_ballistic_vest_friend_world" )
                {   
                    if( doCoinToss() )
                        player addHealth( 100 );
                    else player addshield( 100 );
                    delete = true;
                }
                else if( player UseButtonPressed() && self.model == "prop_suitcase_bomb" )
                {
                    player addMoney( 250 );
                    playFx( level._effect["money"], self.origin );
                    delete = true;
                }
                else if( player UseButtonPressed() && !player isZombie() )
                {
                    player thread giveWeap( weapon, 0 );
                    delete = true;
                }
                
                if( isDefined( delete ) )
                {
                    PlaySoundAtPos( self.origin, "mp_suitcase_pickup" ); 
                    fx delete(); self delete(); player.hintString destroy();
                    wait .1;
                }
            }
        }
        wait .05;
    }
}

createBounce( radius, force, num )
{
    level endon("game_ended");
    
    while(isDefined(self))
    {
        foreach(player in level.players)
        {
            if( distance( self.origin, player.origin ) < radius )   
                player thread doBounce( force, num );
        }
        wait .05;
    }
}    

doBounce( force, num )
{
    PlaySoundAtPos( self.origin, "ims_launch" );
    self setOrigin( self.origin );
    pVecF = anglestoforward( self getplayerangles() );
    for(e = 0; e < num; e++)
    {
        self setVelocity(self GetVelocity() + (0,0,force));
        wait .05;
    }
}

createZipline( pointA, pointB, radius )
{
    level endon("game_ended");
    
    while(isDefined(self))
    {
        foreach(player in level.players)
        {
            if( distance( pointA.origin, player.origin ) < radius || distance( pointB.origin, player.origin ) < radius )   
            {
                if( !isDefined( player.hintString ) )
                    player thread doHintString( "Press [{+reload}] To Use Zipline", undefined, 50 );
                if( player UseButtonPressed() && !isDefined( player.isOnZipline ))
                    player thread useZipline( pointA, pointB );
            }
        }
        wait .05;
    }
}

useZipline( pointA, pointB )
{
    self.isOnZipline = true;
    location         = pointA.origin;
    if( closer( self.origin, pointA.origin, pointB.origin ) )
        location = pointB.origin;
    
    PlaySoundAtPos( location, "elev_bell_ding" );
    ziplineTag = modelSpawner( self.origin, "tag_origin" );
    ziplineTag PlayLoopSound( "elev_run_loop" );
    time       = calcDistance( 1000, ziplineTag.origin, location );
    
    self PlayerLinkTo( ziplineTag, "tag_origin" );
    ziplineTag MoveTo( location, time ); 
    ziplineTag waittill("movedone");
    PlaySoundAtPos( ziplineTag.origin, "elev_run_end" );
    self Unlink();
    ziplineTag delete(); 
    self.isOnZipline = undefined;
}

createTeleportal( pointA, pointB, radius )
{
    level endon("game_ended");
    
    while(isDefined(self))
    {
        foreach(player in level.players)
        {
            if( distance( pointA.origin, player.origin ) < radius || distance( pointB.origin, player.origin ) < radius )   
            {
                if( !isDefined( player.hintString ) )
                    player thread doHintString( "Press [{+reload}] To Use Teleportal", undefined, 50 );
                if( player UseButtonPressed() && !isDefined( player.isInPortal))
                    player thread useTeleportal( pointA, pointB );
            }
        }
        wait .05;
    }
}

useTeleportal( pointA, pointB )
{
    self.isInPortal = true;
    location         = pointA.origin;
    if( closer( self.origin, pointA.origin, pointB.origin ) )
        location = pointB.origin;
    
    PlaySoundAtPos( location, "juggernaut_breathing_sound" );
    self SetOrigin( location );
    wait .25;
    
    self.isInPortal = undefined;
}

CreateDoor(model, open, close, width, height, lengthspace, heightspace, health, price)
{
    door        = Spawn("script_origin", open);
    door.center = Spawn("script_origin", open + (0, (lengthspace / 2) + ((lengthspace * width) / 2) - (lengthspace / 2), 0));
    door.center LinkTo(door);
    door.health    = health;
    door.maxhealth = health;
    
    duration = calcDistance( 400, open, close );
    for (w = 0; w < width; w ++)
    {
        block = modelSpawner(open + (0, (lengthspace / 2) + (lengthspace * w), 0), model, (0, 90, 0), undefined, true);
        block EnableLinkTo();
        block LinkTo( door );
        block thread DoorDamageMonitor(door, open, close, duration, price);
        block thread DoorHudMonitor( door, price );
        
        for (h = 1; h < height; h ++)
        {
            block = modelSpawner(open + (0, (lengthspace / 2) + (lengthspace * w), 0) + (0, 0, ((heightspace * 2) * h)), model, (0, 90, 0), undefined, true );
            block EnableLinkTo();
            block LinkTo( door );
            block thread DoorDamageMonitor(door, open, close, duration, price);
            block thread DoorHudMonitor( door, price );
        }
    }
    door.angles = (0, VectorToAngles(close - open)[1] + 90, 0);
}

DoorDamageMonitor( door, open, close, duration, price )
{
    self SetCanDamage( true );
    while( IsDefined( self ) )
    {
        self waittill("damage", damage, attacker, direction, point, type, tagname, modelname, partname, weaponname);
        
        if( door.health <= 0 )
        {
            if (door.origin == close )
                door MoveTo( open, duration );
        }
        else if(door.health > 0 && !IsDefined(door.moving) && type == "MOD_MELEE" && !attacker isZombie())
        {
            door.moving = true;
            
            if (door.origin == open)
                door MoveTo( close, duration );
            if (door.origin == close)   
                door MoveTo( open, duration );
                
            wait duration;
            door.moving = undefined;
        }
        if( door.health > 0 && type == "MOD_MELEE" && attacker isZombie() )
        {
            door.health -= 25;
            attacker IPrintLn( "Door Damaged By 25 " );
        }
           
    }
}
    
DoorHudMonitor( door, price )
{
    OldDoor = door.health;
    while( IsDefined( self ) )
    {
        foreach( player in level.players )
        {
            if( Distance( player.origin, self.origin ) < 110  && bullettracepassed( self.origin, player GetEye(), 0, self.origin ))
            {
                if( door.health <= 25 && !player isZombie())
                {
                    if( !isDefined( player.hintString ) )
                        player thread doHintString( "Door is currently damaged, hold [{+melee}] to repair for " + price, undefined, 110 );
                    result = player isHoldingMelee();
                    if( result && player.persInfo["money"] > 1000 && door.health <= 0 )
                    {
                        door.health = door.maxhealth;
                        player removeMoney( 1000 );
                    }
                }
                else if( !isDefined( player.hintString ) && door.health > 0 || OldDoor > door.health )
                {
                    player thread doHintString( (player isZombie() ? "[{+melee}] The door to damage, Current Door Health ["+ door.health +"]" : "To Open / Close the door press [{+melee}], Current Door Health ["+ door.health +"]"), undefined, 110 );
                    OldDoor = door.health;
                }
                wait .3;
            }
        }
        wait .05;
    }
}
    
isHoldingMelee()
{
    self endon("disconnect");
    mainCircle  = createRectangle("CENTER", "BOTTOM", 0, -20, 80, 10, (0, 0, 0), "white", 9, 1);
    innerCircle = createRectangle("CENTER", "BOTTOM", 0, -20, 0, 8, (0, 1, 0), "white", 10, 1);
    
    time = 0;
    while( self MeleeButtonPressed() )
    {
        innerCircle ScaleOverTime( .1, int(time * 4), 8 );
        time += 1;
        if(time > 20)
            break;
        wait .1;
    }
    
    mainCircle destroy();
    innerCircle destroy();
    
    if(time > 20)
        return true;
    return false;
}

rotateObj()
{
    while(isDefined(self))
    {
        self rotateTo((self.angles[0], self.angles[1]+90, self.angles[2]), .3);
        wait .3;
    }
}

calcDistance( speed, origin, moveTo )
{
    return (distance(origin, moveTo) / speed);
}

cutString( string, char )
{
    result = "";
    for(i = string.size - 1; i > 0; i--)
    {
        if( string[i] == char )
        {
            result = getSubStr(string, i + 1);
            return result;
        }
    }
    return string;
}

doCoinToss()
{
    if( randomint( 100 ) >= 50 )
        return true;
    return false;
}