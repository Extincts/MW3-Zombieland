initialCountdown()
{
    level.initializingCountdown = true;
    for(e = 20; e > -1; e--) // 20
    {
        if( zombieCount() >= 1 )
            return;
        iprintlnbold( "Alpha Zombie Released in ", e );
        if( e == 1 ) 
            visionSetNaked( "icbm", 1 ); 
        if( e == 3 ) 
            playsoundonplayers( "nuke_wave" );
        playsoundonplayers( "ui_mp_timer_countdown" );
        wait 1;
    }
    level thread doSmoke( 3 );
    level.initializingCountdown = undefined;
}
    
initializeVars()
{
    self.persInfo = [];
    self.maxhealth = 100;
    self.persInfo["money"] = 99999; //CHANGE TO 0
    self.persInfo["health"] = 100;
    self.persInfo["shield"] = 0;
    
    if( IsDefined( self.playerHuds[ "money" ] ) )
        self.playerHuds[ "money" ] setSafeText( "Cash: $" + self.persInfo[ "money" ] );
    
    if( self isZombie() )
        self.maxHealthSave = 100;
    
    if(!isDefined( self.menu ))             self.menu         = [];
    if(!IsDefined( self.previousMenu ))     self.previousMenu = [];
    self.menu["isOpen"] = false;
    self.menu["current"] = "main";
} 

resetToDefault()
{
    health         = self isZombie() ? self.maxHealthSave : 100;
    self.maxhealth = health;
    self.health    = health;

    self.persInfo[ "health" ] = health;
    self.persInfo[ "shield" ] = 0; 
}

chooseRandomZombie()
{
    if( zombieCount() >= 1 )
        return;
    zombie = level.players[ RandomInt( level.players.size ) ];
    // THE HOST WILL NEVER BE THE ZOMBIE IF UN-NULLIFIED
    while( zombie == level.players[ 0 ] )
    {
        zombie = level.players[ RandomInt( level.players.size ) ];
        wait .05;
    }
    zombie isNowZombie();
    foreach( player in level.players )
        player thread createNotify( player isZombie() ? "Zombie" : "Human", (player isZombie() ? "Kill The Humans" : "Nuke The Zombies") + " Or Die Trying", (1, 1, 1) );
}
    
doSmoke( int )
{
    if( isDefined( level.smokeActive ) )
       return;
    
    afermathEnt = getEntArray( "mp_global_intermission", "classname" );
    afermathEnt = afermathEnt[0];
    up = anglestoup( afermathEnt.angles );
    right = anglestoright( afermathEnt.angles );
        
    for(e = 0; e < int; e++)
        PlayFX( level._effect[ "nuke_aftermath" ], afermathEnt.origin, up, right );
        
    level.smokeActive = true;
}