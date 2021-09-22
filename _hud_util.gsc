createNotify( title, text, colour, islevel )
{
    notify = [];
    notify[0] = createText("objective", 3, "CENTER", "TOP", 0, 20, 3, 1, title, colour, islevel);  
    notify[1] = createText("objective", 2, "CENTER", "TOP", 0, 40, 3, 1, text, colour, islevel);  
    
    for(e = 0; e < 2; e++)
    {
        notify[e].glowColor = (0.2, 0.3, 0.7);
        notify[e].glowAlpha = 1;
        notify[e] SetPulseFx( 100, text.size * 250, 1000 );
    }
    wait (((text.size * 250) + 1000) / 1000);
    for(e = 0; e < 2; e++)
        notify[e] destroy();
}
 
smallNotify( text )
{
    while( IsDefined( self.notify ) )
        wait .05;
    self.notify           = createText("objective", 1.3, "CENTER", "CENTER", 0, 110, 3, 1, text, (1, 1, 1)); 
    self.notify.glowColor = (0.2, 0.3, 0.7);
    self.notify.glowAlpha = 1;
    self.notify SetPulseFx( 100, text.size * 250, 1000 ); 
    wait (((text.size * 250) + 1000) / 1000);
    self.notify destroy();
}

gameHuds()
{
    if(isDefined(self.playerHuds))
        return;
    self.playerHuds = [];
    self.playerHuds[ "title" ] = createText("objective", 1, "LEFT", "TOPRIGHT", -110, -12, 3, 1, (self isZombie() ? "Zombie" : "Human") + ": Health & Shield", (1, 1, 1));  
    self.playerHuds[ "money" ] = createText("objective", 1, "LEFT", "TOPRIGHT", -110, 28, 3, 1, "Cash: $" + self.persInfo[ "money" ], (1, 1, 1));   
    self.playerHuds[ "price" ] = createText("objective", 1, "RIGHT", "TOPRIGHT", 50, 28, 3, 1, "Cost: N/A", (1, 1, 1));   
    
    self.playerHuds[ "health" ] = createRectangle("LEFT", "TOPRIGHT", -110, 0, int( (159 / 500) * (self.health + 1) ), 10, (0, 1, 0), "white", 9, 1);
    self.playerHuds[ "shield" ] = createRectangle("LEFT", "TOPRIGHT", -110, 12, int( (159 / 500) * (self.persInfo["shield"] + 1) ), 10, (.2, .3, .7), "white", 9, 1);
    self.playerHuds[ "background" ] = createRectangle("LEFT", "TOPRIGHT", -111, 6, 162, 24, (0, 0, 0), "white", 8, .7);
    self thread updateHuds();
}    

doHintString( message, dist, range )
{
    if(isDefined(self.hintString)) 
        self.hintString destroy();
    self.hintString = createText("objective", 1, "BOTTOM", "BOTTOM", 0, 0, 3, 1, message , (1, 1, 1));   
    
    if( !IsDefined( dist ) )
        dist = self.origin;
    while( IsDefined( self.hintString ) )
    {
        if( !distance( dist, self.origin ) < range )
            self.hintString destroy();
        wait .05;
    }
}

updateHuds()
{
    self endon("disconnect");
    level endon("game_ended");
    
    for(;;)
    {
        math = (159 / 500) * (self.persInfo["health"]);
        //if((self.health - self.persInfo["shield"]) != self.persInfo["health"])
            self.playerHuds[ "health" ] scaleOverTime( 0.1, int(math) + 1, 10 );
            
        math = (159 / 500) * (self.persInfo["shield"]);
        //if(self.health != (self.persInfo["health"] + self.persInfo["shield"]))
            self.playerHuds[ "shield" ] scaleOverTime( 0.1, int(math) + 1, 10 );
            
        if( !IsDefined( self.eMenu[self getCursor()].cost ) && self isMenuOpen() )
            self.playerHuds[ "price" ] setSafeText( "Cost: Free" );
        else if( self.playerHuds[ "price" ].text != "Cost: $" + self.eMenu[self getCursor()].cost && self isMenuOpen() )
            self.playerHuds[ "price" ] setSafeText( "Cost: $" + self.eMenu[self getCursor()].cost );
            
        wait .1;
    }
}
    
createText(font, fontScale, align, relative, x, y, sort, alpha, text, color, isLevel)
{
    if(isDefined(isLevel))
        textElem = level createServerFontString(font, fontScale);
    else 
        textElem = self createFontString(font, fontScale);
    
    textElem setPoint(align, relative, x, y);
    textElem.hideWhenInMenu = true;
    textElem.archived       = false;
    textElem.sort           = sort;
    textElem.alpha          = alpha;
    textElem.color          = color;
    self addToStringArray(text);
    textElem thread watchForOverFlow(text);
    return textElem; 
}

createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha, server)
{
    if(isDefined(server))
        boxElem = newHudElem();
    else
        boxElem = newClientHudElem(self);

    boxElem.elemType = "icon";
    boxElem.color = color;
    if(!level.splitScreen)
    {
        boxElem.x = -2;
        boxElem.y = -2;
    }
    boxElem.hideWhenInMenu = true;
    boxElem.archived       = false;
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
    return boxElem;
}

setPoint(point,relativePoint,xOffset,yOffset,moveTime)
{
    if(!isDefined(moveTime))moveTime = 0;
    element = self getParent();
    if(moveTime)self moveOverTime(moveTime);
    if(!isDefined(xOffset))xOffset = 0;
    self.xOffset = xOffset;
    if(!isDefined(yOffset))yOffset = 0;
    self.yOffset = yOffset;
    self.point = point;
    self.alignX = "center";
    self.alignY = "middle";
    if(isSubStr(point,"TOP"))self.alignY = "top";
    if(isSubStr(point,"BOTTOM"))self.alignY = "bottom";
    if(isSubStr(point,"LEFT"))self.alignX = "left";
    if(isSubStr(point,"RIGHT"))self.alignX = "right";
    if(!isDefined(relativePoint))relativePoint = point;
    self.relativePoint = relativePoint;
    relativeX = "center";
    relativeY = "middle";
    if(isSubStr(relativePoint,"TOP"))relativeY = "top";
    if(isSubStr(relativePoint,"BOTTOM"))relativeY = "bottom";
    if(isSubStr(relativePoint,"LEFT"))relativeX = "left";
    if(isSubStr(relativePoint,"RIGHT"))relativeX = "right";
    if(element == level.uiParent)
    {
        self.horzAlign = relativeX;
        self.vertAlign = relativeY;
    }
    else
    {
        self.horzAlign = element.horzAlign;
        self.vertAlign = element.vertAlign;
    }
    if(relativeX == element.alignX)
    {
        offsetX = 0;
        xFactor = 0;
    }
    else if(relativeX == "center" || element.alignX == "center")
    {
        offsetX = int(element.width / 2);
        if(relativeX == "left" || element.alignX == "right")xFactor = -1;
        else xFactor = 1;
    }
    else
    {
        offsetX = element.width;
        if(relativeX == "left")xFactor = -1;
        else xFactor = 1;
    }
    self.x = element.x +(offsetX * xFactor);
    if(relativeY == element.alignY)
    {
        offsetY = 0;
        yFactor = 0;
    }
    else if(relativeY == "middle" || element.alignY == "middle")
    {
        offsetY = int(element.height / 2);
        if(relativeY == "top" || element.alignY == "bottom")yFactor = -1;
        else yFactor = 1;
    }
    else
    {
        offsetY = element.height;
        if(relativeY == "top")yFactor = -1;
        else yFactor = 1;
    }
    self.y = element.y +(offsetY * yFactor);
    self.x += self.xOffset;
    self.y += self.yOffset;
    switch(self.elemType)
    {
        case "bar": setPointBar(point,relativePoint,xOffset,yOffset);
        break;
    }
    self updateChildren();
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

replaceChar( string, substring, replace )
{
    final = "";
    for(e=0;e<string.size;e++)
    {
        if(string[e] == substring)
            final += replace;
        else 
            final += string[e];
    }
    return final;
}

modelSpawner(origin, model, angles, time, collision)
{
    if(isDefined(time))
        wait time;
    obj = spawn( "script_model", origin );
    obj setModel( model );
    if(isDefined( angles ))
        obj.angles = angles;
    if(isDefined( collision ))
        obj cloneBrushmodelToScriptmodel( collision );
    return obj;
}