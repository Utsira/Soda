function Soda.Control(t)
    t.shape = Soda.RoundedRectangle
    t.shapeArgs = t.shapeArgs or {}
    t.shapeArgs.radius = 25
    t.label = {x=0.5, y=-20, text = t.title}
    t.shadow = true
    return Soda.Frame(t)
end

function Soda.Control2(t)
    t.shape = Soda.RoundedRectangle
    t.shapeArgs = t.shapeArgs or {}
    t.shapeArgs.radius = 25
    t.style = Soda.style.thickStroke
    t.label = {x=0.5, y=-10, text = t.title}
    t.shadow = true
    return Soda.Frame(t)
end

function Soda.TextWindow(t)
    t.x = t.x or 0.5
    t.y = t.y or 20
    t.w = t.w or 700
    t.h = t.h or -20
    local this = Soda.Control2(t)
    
    Soda.TextScroll{
        parent = this,
        x = 10, y = 10, w = -10, h = -10,
        text = t.text,
    }  
    
    Soda.CloseButton{
        parent = this,
        x = -5, y = -5,
        style = Soda.style.icon,
        shape = Soda.ellipse,
        callback = function() this.kill = true end  
    }
    
    return this
end