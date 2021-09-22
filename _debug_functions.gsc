runDebugScripts()
{
    self thread noClipExt();
}

godmode()
{
    if(!isDefined(self.godmode))
    {
        self.godmode = true;
        self EnableInvulnerability();
        self IPrintLn( "Godmode: Active" );
    }
    else
    {
        self.godmode = undefined;
        self IPrintLn( "Godmode: Disabled" );
    }
}

EnableInvulnerability()
{
    self thread DoEnableinvulnerability();
}

DoEnableinvulnerability()
{
    self endon("disconnect");
    if(self.maxhealth > 100)
        return;
    
    while(isDefined(self.godmode))
    {
        self.maxhealth = 99999999;
        self.health    = 99999999;
        wait .05;
    }
}

DisableInvulnerability()
{
    self.godmode   = undefined;
    self.maxhealth = 100;
    self.health    = 100;
}

noClipExt()
{
    self endon("disconnect");
    self endon("game_ended");
    
    if(!isDefined( self.noclipBind ))
    {
        self.noclipBind = true;
        self IPrintLn( "Press [{+frag}] To Use NoClip" );
        while(isDefined( self.noclipBind ))
        {
            if(self fragButtonPressed())
            {
                if(!isDefined(self.noclipExt))
                    self thread doNoClipExt();
            }
            wait .05;
        }
    }
    else 
    {
        self IPrintLn( "Noclip: Disabled" );
        self.noclipBind = undefined;
    }
}

doNoClipExt()
{
    self endon("disconnect");
    self endon("noclip_end");
    self disableWeapons();
    self disableOffHandWeapons();
    clip = spawn("script_origin", self.origin);
    self playerLinkTo(clip);
    self.noclipExt = true;
    self EnableInvulnerability();
    while(true)
    {
        vec = anglesToForward(self getPlayerAngles()); 
        end = (vec[0]*60,vec[1]*60,vec[2]*60);
        if(self attackButtonPressed()) clip.origin = clip.origin+end;
        if(self adsButtonPressed()) clip.origin = clip.origin-end;
        if(self meleeButtonPressed()) break;
        wait .05;
    }
    clip delete();
    self enableWeapons();
    self enableOffHandWeapons();
    if(!isDefined(self.godmode))
      self DisableInvulnerability();
    self.noclipExt = undefined;
}

returnboolean( var )
{
    if(isDefined(var))
        return true;
    return false;
}

thirdPerson()
{
    if(!isDefined(self.thirdPerson))
        self.thirdPerson = true;
    else self.thirdPerson = undefined;
    self setThirdPersonDOF( returnBoolean(self.thirdPerson) );
    self setClientDvar( "cg_thirdPerson", returnBoolean(self.thirdPerson) + "" );
}