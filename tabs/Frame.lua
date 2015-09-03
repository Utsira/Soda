Soda.Frame = class(Soda.Base)

function Soda.Frame:init(t)
    t.shapeArgs = t.shapeArgs or {}
    t.style = t.style or Soda.style.default
    Soda.Base.init(self, t)
    
    self.callback = t.callback or null
    
    self.child = {}
    
    self:setPosition()
    -- if not self.label then self.label = Soda.Label{parent = self, x=0.5, y=-20, text = t.title} end
    --  self:setImage()
    self.mesh = {}
    if t.blurred then
        self.mesh[#self.mesh+1] = Soda.Blur{parent = self}
        self.shapeArgs.tex = self.mesh[#self.mesh].image
    end
    if t.shadow then
        self.mesh[#self.mesh+1] = Soda.Shadow{parent = self}
    end
    
    if t.parent then
        t.parent.child[#t.parent.child+1] = self
    else
        table.insert( Soda.items, self)
    end
end

function Soda.Frame:getTextSize()
    pushStyle()
    self:setStyle(Soda.style.default.text)
    self:setStyle(self.style.text)
    local w,h = textSize(self.label.text)
    popStyle()
    return w,h
end
--[[
function Soda.Frame:setPosition()
local origin = vec2(0,0)
local edge = vec2(WIDTH, HEIGHT)
if self.parent then
origin = vec2(self.parent:left(), self.parent:bottom())
edge = vec2(self.parent:right(), self.parent:top())
end
local t = self.parameters
self.w = parseCoord(t.w, 0, edge.x)
self.h = parseCoord(t.h, 0, edge.y)
local mode1, mode2
if t.x2 then
self.x, mode1 = parseCoord(t.x2, origin.x, edge.x) -self.w
else
self.x, mode1 = parseCoord(t.x, origin.x, edge.x)
end
if t.y2 then
self.y, mode2 = parseCoord(t.y2, origin.y, edge.y) - self.h
else
self.y, mode2 = parseCoord(t.y, origin.y, edge.y)
end
self.rectMode = self.rectMode or mode1 or mode2 or CORNER
print(self.title, self.rectMode)
end
]]

function Soda.Frame:setPosition()
    local t = self.parameters
    local origin = vec2(0,0)
    local edge = vec2(WIDTH, HEIGHT)
    if self.parent then
        origin = vec2(self.parent:left(), self.parent:bottom())
        edge = vec2(self.parent:right(), self.parent:top())
    end
    
    self.w = self:parseSize(t.w or 0.4, origin.x, edge.x)
    self.h = self:parseSize(t.h or 0.3, origin.y, edge.y)
    self.x = self:parseCoord(t.x or 0.5, self.w, origin.x, edge.x)
    self.y = self:parseCoord(t.y or 0.5, self.h, origin.y, edge.y)
    
    if t.label then
        self.label.w, self.label.h = self:getTextSize()
        
        --  self.label.x = self:parseCoord(t.label.x,self.label.w,self:left(),self:right())
        --  self.label.y = self:parseCoord(t.label.y,self.label.h,self:bottom(),self:top())
        self.label.x = self:parseCoord(t.label.x,self.label.w,0,self.w)
        self.label.y = self:parseCoord(t.label.y,self.label.h,0,self.h)
        --[[
        for k,v in pairs(self.label) do
        print(k, v)
    end
        ]]
    end
    if self.shapeArgs then
        local s = self.shapeArgs
        s.w = t.shapeArgs.w or self.w
        s.h = t.shapeArgs.h or self.h
        --   s.x = self:parseCoord(t.shapeArgs.x or 0, s.w, self:left(),self:right())
        --   s.y = self:parseCoord(t.shapeArgs.y or 0, s.h, self:bottom(),self:top())
        s.x = self:parseCoord(t.shapeArgs.x or 0, s.w, 0,self.w)
        s.y = self:parseCoord(t.shapeArgs.y or 0, s.h, 0, self.h)
    end
end

function Soda.Frame:draw(breakPoint)
    if breakPoint and breakPoint == self then return true end
    
    if self.alert then
        Soda.darken:draw()
    end
    
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw()
    end
    local sty = self.style
    if self.highlighted and self.highlightable then
        sty = self.style.highlight
    end
    pushMatrix()
    
    translate(self:left(), self:bottom())
    if self.shape then
        self:drawShape(sty)
    end
    
    if self.label then
        pushStyle()
        self:setStyle(Soda.style.default.text)
        --self:setStyle(self.style.text)
        self:setStyle(sty.text)
        
        text(self.label.text, self.label.x, self.label.y)
        popStyle()
    end
    popMatrix()
    for _, v in ipairs(self.child) do
        --[[
        local ok, err = xpcall(function()  v:draw(breakPoint) end, function(trace) return debug.traceback(trace) end)
        if not ok then print(v.title, err) end
        ]]
        if v:draw(breakPoint) then return true end
        --  v:draw(breakPoint)
    end
    
end

function Soda.Frame:drawShape(sty)
    pushStyle()
    self:setStyle(Soda.style.default.shape)
    self:setStyle(sty.shape)
    self:shape(self.shapeArgs)
    popStyle()
end

function Soda.Frame:touched(t, tpos)
    for _, v in ipairs(self.child) do --children take priority over frame for touch
        if v:touched(t, tpos) then return true end
    end
    if self.alert or self:pointIn(tpos.x, tpos.y) then return true end
end

function Soda.Frame:toggleOthers(child) --method used by parents of selectors
    if self.selected then self.selected.highlighted = false end
    self.selected = child
end

function Soda.Frame:orientationChanged()
    self:setPosition()
    
    for _,v in ipairs(self.mesh) do
        --v:setImage()
        -- v:setRect()
        v:setMesh()
    end
    
    for _,v in ipairs(self.child) do
        v:orientationChanged()
    end
end

function Soda.Frame:pointIn(x,y)
    return x>self:left() and x<self:right() and y>self:bottom() and y<self:top()
end
