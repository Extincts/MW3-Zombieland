deathMonitor()
{
    self endon("disconnect");
    level endon("game_ended");
    
    for(;;)
    {
        self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath );
        if( attacker.name == "" && self.health <= 0)
            self removeMoney( 10 );
        else if( attacker.name != "" && self.health <= 0)
        {
            self addMoney( 20, true );
            attacker addMoney( 100, true );
        }
        
        if( attacker.name == "" )
        {
            self removePersInfo( "health", damage );
            if( self.persInfo[ "health" ] <= 0 )
                self Suicide();
        }
        else 
        {
            health = damage - self.persInfo[ "shield" ];
            if( self.persInfo[ "shield" ] > 0 )
                self removePersInfo( "shield", damage ); 
            if( health > 0 )
                self removePersInfo( "health", health );
        }
            
        if(self.health <= 0)
        {
            if( attacker != self )
                self waittill("spawned_player");
                
            self resetToDefault();    
                
            if( !self isZombie() )
                self isNowZombie();
            else 
                self zombieLoadout();
                
            foreach( player in level.players )
                if( !player isZombie() )
                    player addMoney(150, "$150 Survivor Bonus Points Received.");
            
            visionSetNaked( "", 0 ); 
            visionSetNaked( "icbm", 0 ); 
        }    
        else 
        {
            self.maxhealth = self.persInfo[ "shield" ] + self.persInfo[ "health" ];
            self.health    = self.persInfo[ "shield" ] + self.persInfo[ "health" ];
        }
    }
}

hasFinalZombieQuit()
{
    level endon("game_ended");
    
    for(;;)
    {
        count = 0;
        foreach( player in level.players )
        {
            if( player isZombie() )
                count++;
        }
        if( count == 0 )
        {
            level initialCountdown();
            level chooseRandomZombie();
        }
        wait 1;
    }
}

hasGameFinished()
{
    level endon("game_ended");
    
    for(;;)
    {
        human = 0;
        foreach( player in level.players )
        {
            if( !player isZombie() )
                human++;
        }
        if( human == 0 && !IsDefined( level.initializingCountdown ) )
            thread endGame( "axis", "Zombies Has Successfully Eliminated All Humans." );
        else if( human == level.players.size && !IsDefined( level.initializingCountdown ) )
            thread endGame( "allies", "Humans Has Successfully Survived The Outbreak." );
        wait 1;
    }
}