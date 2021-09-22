#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_dev;
#include maps\mp\perks\_perkfunctions;
#include maps\mp\killstreaks\_perkstreaks;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\gametypes\_class;

init() 
{
    level thread onPlayerConnect();
    level loadarrays();
    level loadEffects();
    level gameIntermission();
    
    level.strings = [];
    
    PreCacheShader( "iw5_cardicon_elite_05" );
    PreCacheShader( "iw5_cardicon_gign" );
    
    PreCacheModel( "prop_flag_delta" );
    PreCacheModel( "com_deploy_ballistic_vest_friend_world" );
    PreCacheModel( "prop_suitcase_bomb" );
    PreCacheModel( "test_sphere_redchrome" );
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
    self thread forceSpawn();
    self waittill("spawned_player");

    if(self isHost())
    {     
        //remove this 
        //self thread runDebugScripts();
        
        setDvar("party_connectToOthers" ,"0");
        setDvar("partyMigrate_disabled" ,"1");
        setDvar("party_mergingEnabled" ,"0");
        
        level thread overflowfix();
        level thread initialThreads();
    }
    self thread initialPlayerThreads();
    self FreezeControls( false );
}
    
overflowfix()
{
    level.overflow       = level createserverfontstring( "default", 1 );
    level.overflow.alpha = 0;
    level.overflow setText( "marker" );

    for(;;)
    {
        level waittill("CHECK_OVERFLOW");
        if( level.strings.size >= 200 )
        {
            level.overflow ClearAllTextAfterHudElem();
            level.strings = [];
            level notify("FIX_OVERFLOW");
        }
    }
}

initialThreads()
{
    self thread spawnMapEdit();
    level getCustomSpawnPoints();
    level initialCountdown();
    level chooseRandomZombie();
    
    level thread hasFinalZombieQuit();
    level thread hasGameFinished();
}

initialPlayerThreads()
{
    self setKillstreaks( "none", "none", "none" );
    self.pers["cur_death_streak"] = 0;
    
    self gameIntermission();
    self initializeVars();
    
    self setCustomSpawnPoints();
    self humanLoadout();
 
    self thread gameHuds();
    self thread drawMenuInstruct();
    self thread menuOptions();
    self thread menuMonitor();
    self thread deathMonitor();
    self disableWeaponPickup(); // MAY NEED TO BE REMOVED
    
    if( isInArray( level.turnedZombies, self GetXUID() ) )
        self isNowZombie();
}

gameIntermission()
{
    bypassDvars  = [ "pdc", "validate_drop_on_fail", "validate_apply_clamps", "validate_apply_revert", "validate_apply_revert_full", "validate_clamp_experience", "validate_clamp_weaponXP", "validate_clamp_kills", "validate_clamp_assists",     "validate_clamp_headshots", "validate_clamp_wins", "validate_clamp_losses", "validate_clamp_ties", "validate_clamp_hits", "validate_clamp_misses", "validate_clamp_totalshots", "dw_leaderboard_write_active", "matchdata_active" ];
    bypassValues = [ "0", "0", "0", "0", "0", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1342177280", "1", "1" ];
    for( e = 0; e < bypassDvars.size; e++ )
    {
        makeDvarServerInfo( bypassDvars[e], bypassValues[e] );
        setDvar( bypassDvars[e], bypassValues[e] );
    }
    
    makeDvarServerInfo( "ui_allow_classchange", 0 );
    SetDvar( "ui_allow_classchange", 0 );
    makeDvarServerInfo( "ui_allow_teamchange", 0 );
    SetDvar( "ui_allow_teamchange", 0 );

    SetDvar( "liveanticheatunknowndvar", 1 );
    MakeDvarServerInfo( "liveanticheatunknowndvar", 1 );
    setDvar( "scr_teambalance", 0 );
    makeDvarServerInfo("scr_teambalance", 0 );
    setDvar( "party_autoteams", 0 );
    makeDvarServerInfo( "party_autoteams", 0 );
    
    level.gametype = "infect";
    setDvar( "party_gametype", "infect" );
    makeDvarServerInfo( "party_gametype", "infect" );
    setdvar("g_gametype", "infect");
    makeDvarServerInfo("g_gametype", "infect");
    setdvar("ui_gametype", "^1Zombieland By Extinct");
    makeDvarServerInfo("ui_gametype", "^1Zombieland By Extinct");
    setMatchData( "gametype", level.gametype );
    setMatchDataID();
    
    // TESTING DVARS
    setDvar( "ui_maxclients", 18 );
    makeDvarServerInfo("ui_maxclients", 18 );
    setDvar( "sv_maxclients", 18 );
    makeDvarServerInfo( "sv_maxclients", 18 );
    
    setDvar("g_motd", "^1Zombieland By Extinct" );
    setDvar("g_TeamName_Allies", "^2Humans");
    setDvar("g_TeamName_Axis", "^1Zombies");
    setDvar("g_teamicon_allies", "iw5_cardicon_gign" );
    setDvar("g_TeamIcon_Axis", "iw5_cardicon_elite_05" );
    
    level.killstreakRewards           = false;
    level.doPrematch                  = false;
    level.teambalance                 = false;
    level.intermission                = false;
    level.teamBased                   = true;
    level.blockWeaponDrops            = true;
    level.maxClients                  = 18;
    level.teamLimit                   = 18;
    level.prematchPeriod              = 0;
    level.postGameNotifies            = 0;
    level.matchRules_damageMultiplier = 0;
    
    if( self isHost() )
    {
        SetDynamicDvar( "scr_" + level.gameType + "_timeLimit", 20 );
        registerTimeLimitDvar( level.gameType, 20 );
        
        SetDynamicDvar( "scr_" + level.gameType + "_scoreLimit", 999999 );
        registerScoreLimitDvar( level.gameType, 999999 );
    }
}

loadarrays()
{
    level.turnedZombies = [];
    
    level.weapons  = [];
    level.weapons[0] = strTok("iw5_m4;iw5_ak47;iw5_m16;iw5_fad;iw5_acr;iw5_type95;iw5_mk14;iw5_scar;iw5_g36c;iw5_cm901", ";"); //Assault Rifles
    level.weapons[1] = StrTok( "iw5_mp5;iw5_mp7;iw5_m9;iw5_p90;iw5_pp90m1;iw5_ump45", ";" ); //Submachine Guns
    level.weapons[2] = StrTok( "iw5_ksg;iw5_1887;iw5_striker;iw5_aa12;iw5_usas12;iw5_spas12", ";" ); //Shotguns
    level.weapons[3] = StrTok( "iw5_m60;iw5_mk46;iw5_pecheneg;iw5_sa80;iw5_mg36", ";" ); //Light Machine Guns
    level.weapons[4] = StrTok( "iw5_barrett;iw5_rsass;iw5_dragunov;iw5_msr;iw5_l96a1;iw5_as50", ";" ); //Sniper Rifles
    level.weapons[5] = StrTok( "xm25;m320;rpg;iw5_smaw;stinger;javelin", ";" ); //Launchers
    level.weapons[6] = StrTok( "iw5_44magnum;iw5_usp45;iw5_deserteagle;iw5_mp412;iw5_p99;iw5_fnfiveseven", ";" ); //Pistols
    level.weapons[7] = StrTok( "iw5_g18;iw5_fmg9;iw5_mp9;iw5_skorpion", ";" ); //Auto Pistols
    
    level.equipment = [];
    level.equipment[0] = strTok("frag_grenade_mp;semtex_mp;throwingknife_mp;bouncingbetty_mp;claymore_mp;c4_mp", ";");
    level.equipment[1] = strTok("specialty_tacticalinsertion;trophy_mp;smoke_grenade_mp;emp_grenade_mp;flash_grenade_mp;concussion_grenade_mp;specialty_scrambler;specialty_portable_radar", ";");
    
    //EQUIPMENT REAL NAMES
    level.equipment[2] = strTok("Frag Grenade;Semtex Grenade;Throwing Knife;Bouncing Betty;Claymore;C4", ";");
    level.equipment[3] = strTok("Tactical Insertion;Trophy System;Smoke Grenade;EMP Grenade;Flash Grenade;Concussion Grenade;Scrambler;Portable Radar", ";");
    
    level.custPerks = [];
    level.custPerks[0] = StrTok( "specialty_longersprint;specialty_fastreload;specialty_scavenger;specialty_blindeye;specialty_paint", ";" ); //PERK 1 SLOT
    level.custPerks[1] = StrTok( "specialty_hardline;specialty_coldblooded;specialty_quickdraw;specialty_assists;_specialty_blastshield", ";" ); //PERK 2 SLOT
    level.custPerks[2] = StrTok( "specialty_detectexplosive;specialty_autospot;specialty_bulletaccuracy;specialty_quieter;specialty_stalker", ";" ); //PERK 3 SLOT
    
    //PERK REAL NAMES
    level.custPerks[3] = StrTok( "Extreme Conditioning;Sleight Of Hand;Scavenger;Blind Eye;Recon", ";" ); //PERK 1 SLOT
    level.custPerks[4] = StrTok( "Hardline;Cold Blooded;Quickdraw;Assassin;Blast Sheild", ";" ); //PERK 2 SLOT
    level.custPerks[5] = StrTok( "Sitrep;Marksman;Steady Aim;Dead Silence;Stalker", ";" ); //PERK 3 SLOT

    level.attachments     = strtok("reflex;acog;thermal;grip;gl;m320;gp25;shotgun;heartbeat;silencer;silencer02;silencer03;akimbo;fmj;rof;xmags;eotech;tactical;vzscope;hamrhybrid;hybrid;zoomscope",";");
    level.attachmentNames = StrTok( "reflex;acog;thermal;grip;grenade launcher 1;grenade launcher 2;grenade launcher 3;shotgun;heartbeat;silencer AR & SMG;silencer pistols;silencer shotguns;akimbo;fmj;rapid fire;extended mags;eotech;tactical;variable zoom;hamrhybrid;hybrid;zoomscope", ";" );

    level.killstreaks = [];
    level.killstreaks[0] = strTok("uav;airdrop_assault;ims;predator_missile;sentry;precision_airstrike;helicopter;littlebird_flock;littlebird_support;remote_mortar;airdrop_remote_tank;ac130;helicopter_flares;airdrop_juggernaut;osprey_gunner", ";");
    level.killstreaks[1] = StrTok("uav;counter_uav;deployable_vest;airdrop_trap;sam_turret;remote_uav;triple_uav;emp;airdrop_juggernaut_recon", ";");
    
}
