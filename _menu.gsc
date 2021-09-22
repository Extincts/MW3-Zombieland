menuOptions()
{
    self addMenu("main", "Zombieland By Extinct");
    if( !self isZombie() )
    {
        self addOpt( "Weaponry Options", ::newMenu, "weaponryOpts" );
        self addOpt( "Healing Options", ::newMenu, "healingOpts" );
        self addOpt( "Equipment", ::newMenu, "equipment" );
        self addOpt( "Perks", ::newMenu, "perks" );
        self addOpt( "Streaks", ::newMenu, "streaks" );
        self addOpt( "Clients Menu", ::newMenu, "clients" );   
        
        self addMenu( "weaponryOpts", "Weaponry Options"); 
            self addOpt( "Weapons", ::newMenu, "giveWeaps" );
            self addOpt( "Weapon Attachments", ::newMenu, "giveAttach" );
            self addOpt( "Weapon Camos", ::newMenu, "weapCamo" );
            self addOpt( "Refill Current Ammo", "$200", ::weapmax );
            self addOpt( "Reill All Weapon Ammo", "$350", ::weapmax, true );
            
        self addMenu( "healingOpts", "Healing Options");
            self addOpt( "Plus 50 Health", "$500", ::addHealth, 50 );
            self addOpt( "Plus 50 Shield", "$500", ::addShield, 50 );
            self addOpt( "Max Health", "$20000", ::addHealth, 500 ); 
            self addOpt( "Max Shield", "$20000", ::addShield, 500 );
            self addOpt( "Slurp Juice", "$600", ::slurpJuice );
            self addOpt( "Chugjug", "$35000", ::chugjug );
        
        self addMenu("equipment", "Equipment");
            self addOpt( "Lethals", ::newMenu, "lethals" );
            self addOpt( "Tacticals", ::newMenu, "tacticals" );
        
        self addMenu("tacticals", "Tacticals");
            for(e=0;e<level.equipment[1].size;e++)  
                self addOpt( level.equipment[3][e], "$100", ::buyTacitals, level.equipment[1][e] );   
            
        self addMenu("lethals", "Lethals");
            for(e=0;e<level.equipment[0].size;e++)  
                self addOpt( level.equipment[2][e], "$150", ::buyLethals, level.equipment[0][e] );  
            
        self addMenu( "perks", "Perks" );
            for( e = 1; e < 4; e++ )
                self addOpt( "Perk " + e, ::newMenu, "Perk" + e);
         
        for( e = 1; e < 4; e++ )   
        {
            self addMenu( "Perk" + e, "Perk " + e );
            for( perks = 0; perks < level.custPerks[ e - 1 ].size; perks++ )
                self addOpt( level.custPerks[ e + 2 ][ perks ], "$300", ::setPerkFunction, level.custPerks[ e - 1 ][ perks ]);
        }
            
        self addMenu( "giveAttach", "Attachments" );
            for( e = 0; e < level.attachments.size; e++ )
                self addOpt( level.attachmentNames[e], "$50", ::giveAttachment, level.attachments[e] );
            
        weapon_categories = strtok( "Assault Rifles;Submachine Guns;Shotguns;Light Machine Guns;Sniper Rifles;Launchers;Pistols;Auto Pistols", ";" );
        priceRanges       = strTok( "600;400;500;1200;700;1500;200;300", ";" );
        
        self addMenu( "giveWeaps", "Weapons");
            for(e=0;e<weapon_categories.size;e++)
                self addOpt( weapon_categories[e], ::newMenu, weapon_categories[e] );
        self addOpt( "Random Weapon", "$250", ::giveRandWeap );        
        for(e=0;e<weapon_categories.size;e++)
        {
            self addmenu( weapon_categories[e], weapon_categories[e] );
                foreach(weap in level.weapons[e])
                    self addOpt( replaceChar( returnDisplayName(weap, "iw5_", "killstreak_"), "_", " " ), "$" + priceRanges[e], ::giveWeap, weap + "_mp");
        }
            
        camos = StrTok( "none;classic;snow;multi;urban;hex;choco;snake;blue;red;autumn;gold;marine;winter", ";" );
        self addmenu( "weapCamo" ,"Weapon Camos" );
        for(e=0;e<camos.size;e++)
            self addOpt( camos[e], "$50", ::giveWeap, undefined, e, undefined, true);
            
        self addMenu( "streaks", "Streaks" );
            self addOpt( "Assault Streaks", ::newMenu, "assaultStreaks" );
            self addOpt( "Support Streaks", ::newMenu, "supportStreaks" );
        
        self addMenu( "assaultStreaks", "Assault Streaks" );
            foreach(killstreak in level.killstreaks[0])
                self addOpt( replaceChar( killstreak, "_", " " ), "$800", ::give_Killstreak, killstreak );
        self addMenu( "supportStreaks", "Support Streaks" );
            foreach(killstreak in level.killstreaks[1])
                self addOpt( replaceChar( killstreak, "_", " " ), "$500", ::give_Killstreak, killstreak );
    }
    else 
    {
        self addOpt( "General Options", ::newMenu, "generalOpts" );
        self addOpt( "Healing Options", ::newMenu, "healingOpts" );
        self addOpt( "Equipment", ::newMenu, "equipment" );
        self addOpt( "Perks", ::newMenu, "perks" );
        self addOpt( "Streaks", ::newMenu, "streaks" );
        self addOpt( "Clients Menu", ::newMenu, "clients" );   
        
        self addMenu( "generalOpts", "General Options" );
            self addOpt( "Speed For 3 Second", "$200", ::setPlayerSpeed, 1.5 );
        
        self addMenu( "healingOpts", "Healing Options" );
            self addOpt( "Plus 50 Health", "$500", ::addHealth, 50 );
            self addOpt( "Plus 50 Shield", "$500", ::addShield, 50 );
            self addOpt( "Max Health", "$20000", ::addHealth, 500 ); 
            self addOpt( "Max Shield", "$20000", ::addShield, 500 );
            self addOpt( "Slurp Juice", "$600", ::slurpJuice );
            self addOpt( "Chugjug", "$35000", ::chugjug );
        
        self addMenu("equipment", "Equipment");
            for(e=0;e<level.equipment[1].size;e++)  
                self addOpt( level.equipment[3][e], "$100", ::buyTacitals, level.equipment[1][e] ); 
            
        self addMenu( "perks", "Perks" );
            for( e = 1; e < 4; e++ )
                self addOpt( "Perk " + e, ::newMenu, "Perk" + e);
         
        for( e = 1; e < 4; e++ )   
        {
            self addMenu( "Perk" + e, "Perk " + e );  
                for( perks = 0; perks < level.custPerks[ e - 1 ].size; perks++ )
                    self addOpt( level.custPerks[ e + 2 ][ perks ], "$300", ::setPerkFunction, level.custPerks[ e - 1 ][ perks ]);
        }
                
        self addMenu( "streaks", "Streaks" );
            foreach(killstreak in level.killstreaks[1])
                self addOpt( replaceChar( killstreak, "_", " " ), "$200", ::give_Killstreak, killstreak );
    }
        
    self addmenu( "clients", "Clients Menu" );
        foreach( player in level.players )
            self addopt(player getName(), ::newmenu, "client_" + player getentitynumber());
            
    foreach(player in level.players)
    {
        self addmenu("client_" + player getentitynumber(), player getName());
        self addOpt( "Share 100 Cash", "$100", ::addMoney, 100, "$100 Has Been Added By " + self getName() + ".", player );
        self addOpt( "Share 500 Cash", "$500", ::addMoney, 500, "$500 Has Been Added By " + self getName() + ".", player );
        self addOpt( "Share 1000 Cash", "$1000", ::addMoney, 1000, "$1000 Has Been Added By " + self getName() + ".", player );
    }
}

menuMonitor()
{
    self endon("disconnected");

    for(;;)
    {
        if(!self.menu["isOpen"])
        {
            if( self meleeButtonPressed() && self adsButtonPressed() )
            {
                self menuOpen();
                wait .2;
            }               
        }
        else 
        {
            if( self attackButtonPressed() || self adsButtonPressed() )
            {
                self.menu[ self getCurrentMenu() + "_cursor" ] += self attackButtonPressed();
                self.menu[ self getCurrentMenu() + "_cursor" ] -= self adsButtonPressed();
                self scrollingSystem();
                self PlaySoundToPlayer( "mouse_over", self );
                wait .2;
            }
            else if( self useButtonPressed() )
            {
                if(self canPurchase( self.eMenu[self getCursor()].cost ))
                    self thread [[ self.eMenu[self getCursor()].func ]]( self.eMenu[self getCursor()].p1, self.eMenu[self getCursor()].p2, self.eMenu[self getCursor()].p3, self.eMenu[self getCursor()].p4, self.eMenu[self getCursor()].p5);
                wait .2;
            }
            else if( self meleeButtonPressed() )
            {
                if( self getCurrentMenu() == "main" )
                    self menuClose();
                else 
                    self newMenu();
                wait .2;
            }
        }
        wait .05;
    }
}

menuOpen()
{
    self.menu["isOpen"] = true;
    
    self destroyAll( self.menu["INST"] );
    self menuOptions();
    self drawMenu();
    self drawText(); 
    self updateScrollbar();
    self resizeMenu();
    self playSoundToPlayer( "mouse_over", self );
}

menuClose()
{
    self.menu["isOpen"] = false;
    
    self destroyAll( self.menu["UI"] ); 
    self destroyAll( self.menu["OPT"] );
    
    self thread drawMenuInstruct();
    self.playerHuds[ "price" ] setSafeText( "Cost: N/A" );
    
    self PlaySoundToPlayer( "mouse_click", self );   
}

drawMenu()
{
    if(!isDefined(self.menu["UI"]))
        self.menu["UI"] = [];
        
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOP", "TOPRIGHT", -30, 33, 162, 116, (0, 0, 0), "white", 2, .8);
    self.menu["UI"]["SCROLL"] = self createRectangle("LEFT", "TOPRIGHT", -111, 55, 162, 10, (1, 1, 1), "white", 3, 1);
}

resizeMenu()
{
    opt  =  self.eMenu.size;
    if( (self.eMenu.size > 10) )
        opt  = 10;
    size = (opt*9.5) + 20;
    self.menu["UI"]["OPT_BG"] setShader("white", 162, int(size));
    self.menu["OPT"]["INSTRUCT"].y = self.menu["UI"]["OPT_BG"].y + (size - 5);
}

drawMenuInstruct()
{
    if(!isDefined(self.menu["INST"]))
        self.menu["INST"] = [];
        
    self.menu["INST"]["TITLE"] = self createText("objective", 1, "LEFT", "TOPRIGHT", -110, 38, 3, 1, "Open Menu [{+speed_throw}] & [{+melee}]", (1,1,1));    
    self.menu["INST"]["BG"] = self createRectangle("LEFT", "TOPRIGHT", -111, 38, 162, 10, (0, 0, 0), "white", 2, .8);
}

drawText()
{
    if(!isDefined(self.menu["OPT"]))
        self.menu["OPT"] = [];
        
    self.menu["OPT"]["TITLE"] = self createText("objective", 1, "LEFT", "TOPRIGHT", -110, 38, 3, 1, self.menuTitle, (1,1,1));    
    self.menu["OPT"]["INSTRUCT"] = self createText("objective", 0.8, "LEFT", "TOPRIGHT", -110, 145, 3, 1, "Scroll [{+attack}] & [{+speed_throw}] | Select [{+reload}] | Back [{+melee}]", (1,1,1));    
    self.menu["OPT"]["MENU"] = self createText("objective", 0.8, "LEFT", "TOPRIGHT", -110, 48, 4, 1, "", (1, 1, 1));
    self setMenuText();
}

refreshTitle()
{
    self.menu["OPT"]["TITLE"] setSafeText( self.menuTitle );
}

scrollingSystem()
{
    if(self getCursor() >= self.eMenu.size || self getCursor() < 0 || self getCursor() == 9)
    {
        if(self getCursor() <= 0)
            self.menu[ self getCurrentMenu() + "_cursor" ] = self.eMenu.size -1;
        else if(self getCursor() >= self.eMenu.size)
            self.menu[ self getCurrentMenu() + "_cursor" ] = 0;
        self setMenuText();
        self updateScrollbar();
    }
    if(self getCursor() >= 10)
        self setMenuText();
    else 
        self updateScrollbar();
}

updateScrollbar()
{
    curs = self getCursor();
    if(curs >= 10)
        curs = 9;    
        self.menu["UI"]["SCROLL"].y = (self.menu["OPT"]["MENU"].y + (curs * 9.5));
    self setMenuText();
}

setMenuText()
{
    ary = 0;
    if(self getCursor() >= 10)
        ary = self getCursor() - 9;
    final = "";
    for(e=0;e<10;e++)
    {
        if(isDefined(self.eMenu[ ary + e ].opt))
        {
            if(self getCursor() == e )
                final += "^0" + toUpper( self.eMenu[ ary + e ].opt ) + "^7\n";
            else if(self getCursor() == e || self.eMenu.size > 9 && e == 9 && self getCursor() > 9)
                final += "^0" + toUpper( self.eMenu[ ary + e ].opt ) + "^7\n";
            else
                final += toUpper( self.eMenu[ ary + e ].opt ) + "^7\n";
        }
    }
    self.menu["OPT"]["MENU"] setSafeText( final );
}
        
newMenu( menu )
{
    if(!isDefined( menu ))
    {
        menu = self.previousMenu[ self.previousMenu.size -1 ];
        self.previousMenu[ self.previousMenu.size -1 ] = undefined;
    }
    else 
        self.previousMenu[ self.previousMenu.size ] = self getCurrentMenu();
        
    self setCurrentMenu( menu );
    self menuOptions();
    self setMenuText();
    self refreshTitle();
    self updateScrollbar();
    self resizeMenu();
    self PlaySoundToPlayer( "mouse_click", self );
}

addMenu( menu, title )
{
    self.storeMenu = menu;
    if(self getCurrentMenu() != menu)
        return;
        
    self.eMenu = [];
    self.menuTitle = title;
    if(!isDefined(self.menu[ menu + "_cursor"]))
        self.menu[ menu + "_cursor"] = 0;
}

addOpt( opt, cost, func, p1, p2, p3, p4, p5 )
{
    if(self.storeMenu != self getCurrentMenu())
        return;
        
    if( isDefined( cost ) && !IsSubStr( cost, "$" ))
        return self addOpt( opt, undefined, cost, func, p1, p2, p3, p4, p5 );
        
    option      = spawnStruct();
    option.opt  = opt;
    option.cost = int( getSubStr(cost, 1) );
    option.func = func;
    option.p1   = p1;
    option.p2   = p2;
    option.p3   = p3;
    option.p4   = p4;
    option.p5   = p5;
    self.eMenu[self.eMenu.size] = option;
}

setCurrentMenu( menu )
{
    self.menu["current"] = menu;
}

getCurrentMenu( menu )
{
    return self.menu["current"];
}

getCursor()
{
    return self.menu[ self getCurrentMenu() + "_cursor" ];
}

destroyAll(array)
{
    if(!isDefined(array))
        return;
    keys = getArrayKeys(array);
    for(a=0;a<keys.size;a++)
    {
        if(isDefined(array[ keys[ a ] ][ 0 ]))
        {
            for(e=0;e<array[ keys[ a ] ].size;e++)
            {
                array[ keys[ a ] ][ e ] destroy();
                array[ keys[ a ] ][ e ] = undefined;
            }
        }
        else
        {
            array[ keys[ a ] ] destroy();
            array[ keys[ a ] ] = undefined;
        }
    }
}

toUpper( string )
{
    alphabet = strTok("A;B;C;D;E;F;G;H;I;J;K;L;M;N;O;P;Q;R;S;T;U;V;W;X;Y;Z;0;1;2;3;4;5;6;7;8;9; ;-;_", ";");
    final    = "";
    for(e=0;e<string.size;e++)
        for(a=0;a<alphabet.size;a++)
            if(IsSubStr(toLower(string[e]), toLower(alphabet[a])))         
                final += alphabet[a];
    return final;            
}

isMenuOpen()
{
    if( isDefined( self.menu["isOpen"] ) && self.menu["isOpen"] )
        return true;
    return false;
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