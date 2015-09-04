Soda.Frame = class()

function Soda.Frame:init(t)
    t.shapeArgs = t.shapeArgs or {}
    t.style = t.style or Soda.style.default
    self:storeParameters(t)
    
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

function Soda.Frame:storeParameters(t)
    self.parameters = {}
    for k,v in pairs(t) do
        
        if k =="label" or k=="shapeArgs" then
            self[k] = {}
            self.parameters[k] = {}
            for a,b in pairs(v) do
                self[k][a] = b
                self.parameters[k][a] = b
            end
        else
            self.parameters[k] = v
            self[k] = v
        end
        
    end
end

function Soda.Frame:getTextSize(sty, tex)
    pushStyle()
    Soda.setStyle(Soda.style.default.text)
    Soda.setStyle(sty or self.style.text)
    local w,h = textSize(tex or self.label.text)
    popStyle()
    return w,h
end

function Soda.Frame:setPosition()
    local t = self.parameters
    local origin = vec2(0,0)
    local edge = vec2(WIDTH, HEIGHT)
    if self.parent then
        origin = vec2(self.parent:left(), self.parent:bottom())
        edge = vec2(self.parent:right(), self.parent:top())
    end
    
    self.w = Soda.parseSize(t.w or 0.4, origin.x, edge.x)
    self.h = Soda.parseSize(t.h or 0.3, origin.y, edge.y)
    self.x = Soda.parseCoord(t.x or 0.5, self.w, origin.x, edge.x)
    self.y = Soda.parseCoord(t.y or 0.5, self.h, origin.y, edge.y)
    
    if t.label then
        self.label.w, self.label.h = self:getTextSize()
        
        --  self.label.x = Soda.parseCoord(t.label.x,self.label.w,self:left(),self:right())
        --  self.label.y = Soda.parseCoord(t.label.y,self.label.h,self:bottom(),self:top())
        self.label.x = Soda.parseCoord(t.label.x,self.label.w,0,self.w)
        self.label.y = Soda.parseCoord(t.label.y,self.label.h,0,self.h)
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
        --   s.x = Soda.parseCoord(t.shapeArgs.x or 0, s.w, self:left(),self:right())
        --   s.y = Soda.parseCoord(t.shapeArgs.y or 0, s.h, self:bottom(),self:top())
        s.x = Soda.parseCoord(t.shapeArgs.x or 0, s.w, 0,self.w)
        s.y = Soda.parseCoord(t.shapeArgs.y or 0, s.h, 0, self.h)
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
        Soda.setStyle(Soda.style.default.text)
        --Soda.setStyle(self.style.text)
        Soda.setStyle(sty.text)
        
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
    Soda.setStyle(Soda.style.default.shape)
    Soda.setStyle(sty.shape)
    self.shape(self.shapeArgs)
    popStyle()
end

function Soda.Frame:bottom()
    return self.y - self.h * 0.5
end

function Soda.Frame:top()
    return self.y + self.h * 0.5
end

function Soda.Frame:left()
    return self.x - self.w * 0.5
end

function Soda.Frame:right()
    return self.x + self.w * 0.5
end

function Soda.Frame:touched(t, tpos)
    for _, v in ipairs(self.child) do --children take priority over frame for touch
        if v:touched(t, tpos) then 
            if t.state==BEGAN and Soda.keyboardEntity and Soda.keyboardEntity~=v then
                hideKeyboard()
                Soda.keyboardEntity = nil
            end
            return true 
        end
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
