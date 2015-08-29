Soda.Frame = class(Soda.Base)

function Soda.Frame:init(t)
    Soda.Base.init(self, t)
  --  self.style = t.style or Soda.style.default
    self.callback = t.callback or null
    
    self.child = {}
    if t.parent then
        t.parent.child[#t.parent.child+1] = self
    end
    self:setPosition()  
   -- if not self.label then self.label = Soda.Label{parent = self, x=0.5, y=-20, text = t.title} end
  --  self:setImage()
    
    table.insert( Soda.items, self)
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

    self.w = self:parseSize(t.w, edge.x)
    self.h = self:parseSize(t.h, edge.y)
    self.x = self:parseCoord(t.x, self.w, origin.x, edge.x)
    self.y = self:parseCoord(t.y, self.h, origin.y, edge.y)
end

function Soda.Frame:draw(exception)
    if self==exception then return end
   -- spriteMode(self.rectMode) --draw frame before children
  --  sprite(self.image[self.currentImage], self.x, self.y)
  --  if self.shadowMesh then self.shadowMesh:draw() end
   -- self.mesh:draw()
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw()
    end
    for _, v in pairs(self.child) do
        v:draw()
    end
end

function Soda.Frame:touched(t)
    for _, v in pairs(self.child) do --children take priority over frame for touch
       if v:touched(t) then return true end
    end   
end

function Soda.Frame:orientationChanged()
    self:setPosition()
    for i,v in ipairs(self.mesh) do
        v:setImage()
       -- v:setRect()
        v:setMesh()
    end
end

function Soda.Frame:pointIn(x,y)
    if x>self:left() and x<self:right() and y>self:bottom() and y<self:top() then return true end
end
