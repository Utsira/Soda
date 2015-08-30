function Soda.Alert2Dark(t)
    local this = Soda.Control{title = t.title, h = 0.2, frosted = true}
    
    local ok = Soda.Button{parent = this, title = "OK", x = 0, y = 0, w = 0.5, h = 50, style = Soda.style.dark, shape = Soda.outline, shapeArgs = {edge = TOPEDGE | RIGHTEDGE}} --style = Soda.style.transparent,frosted = true --{edgeX = LEFT, edgeY = 1, r = 25}
    
    local cancel = Soda.Button{parent = this, title = "Cancel", x = 0.75, y = 0, w = 0.5, h = 50, style = Soda.style.dark, shape = Soda.outline, shapeArgs = {edge = TOPEDGE}, callback = function() this.kill = true end} --style = Soda.style.transparent,{edgeX = RIGHT, edgeY = 1, r = 25}
    return this
end

function Soda.Alert2(t)
    local this = Soda.Frame{h = 0.25} --, edge = ~BOTTOMEDGE
     
    this.mesh = {
        Soda.Mesh{parent = this, shape = Soda.roundedRect, style = Soda.style.default, shapeArgs = {r = 25}, label = {x=0.5, y=0.6, text = t.title}}}
    
    this.mesh[2] = Soda.Shadow{parent = this}
    
    local ok = Soda.Button{parent = this, title = "OK", x = 0.251, y = 0, w = 0.5, h = 50, shapeArgs = {r = 25, edge = LEFTEDGE | BOTTOMEDGE}} --style = Soda.style.transparent,frosted = true --{edgeX = LEFT, edgeY = 1, r = 25}
    local cancel = Soda.Button{parent = this, title = "Cancel", x = 0.748, y = 0, w = 0.5, h = 50, shapeArgs = {r = 25, edge = RIGHTEDGE | BOTTOMEDGE}, callback = function() this.kill = true end} --style = Soda.style.transparent,{edgeX = RIGHT, edgeY = 1, r = 25}
    return this
end

function Soda.Alert1(t)
    local this = Soda.Control{title = t.title, style = Soda.style.default, h = 0.25, alert = true}
    local ok = Soda.Button{parent = this, title = "OK", x = 0, y = 0, w = 1, h = 50, shapeArgs = {edge = ~TOPEDGE, r = 25}, callback = function() this.kill = true end} --style = Soda.style.transparent,
    return this
end
