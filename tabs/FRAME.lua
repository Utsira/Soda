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
    self.inactive = self.hidden --elements that are defined as hidden are also inactive at initialisation
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
       -- origin = vec2(self.parent:left(), self.parent:bottom())
       -- edge = vec2(self.parent:right(), self.parent:top())
        edge = vec2(self.parent.w, self.parent.h)
    end
    
    --[[
    self.w = Soda.parseSize(t.w or 0.4, origin.x, edge.x)
    self.h = Soda.parseSize(t.h or 0.3, origin.y, edge.y)
    self.x = Soda.parseCoord(t.x or 0.5, self.w, origin.x, edge.x)
    self.y = Soda.parseCoord(t.y or 0.5, self.h, origin.y, edge.y)
      ]]
    self.x, self.w = Soda.parseCoordSize(t.x or 0.5, t.w or 0.4, edge.x)
    self.y, self.h = Soda.parseCoordSize(t.y or 0.5, t.h or 0.3, edge.y)
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

function Soda.Frame:show(direction)
    self.hidden = false --so that we can see animation
    if direction then
        self:setPosition()
        local targetX = self.x
        if direction==LEFT then
            self.x = - self.w * 0.5
        elseif direction==RIGHT then
            self.x = WIDTH + self.w * 0.5
        end
        tween(0.4, self, {x=targetX}, tween.easing.cubicInOut, function() self.inactive=false end) --user cannot touch buttons until animation completes
    else
        self.inactive = false
    end
end

function Soda.Frame:hide(direction)
    self.inactive=true --cannot touch element during deactivation animation
    if direction then
        local targetX
        if direction==LEFT then
            targetX = - self.w * 0.5
        elseif direction==RIGHT then
            targetX = WIDTH + self.w * 0.5
        end
        tween(0.4, self, {x=targetX}, tween.easing.cubicInOut, function() self.hidden = true end) --user cannot touch buttons until animation completes
    else
        self.hidden = true
    end
end

function Soda.Frame:draw(breakPoint)
    if breakPoint and breakPoint == self then return true end
    if self.hidden then return end
    
    if self.alert then
        Soda.darken.draw()
    end
    
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw()
    end
    local sty = self.style
    if self.highlighted and self.highlightable then
        sty = self.style.highlight or Soda.style.default.highlight
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
    
    for i, v in ipairs(self.child) do --children are drawn with parent's transformation
        --[[
        local ok, err = xpcall(function()  v:draw(breakPoint) end, function(trace) return debug.traceback(trace) end)
        if not ok then print(v.title, err) end
        ]]
        if v.kill then
            table.remove(self.child, i)
        else
            if v:draw(breakPoint) then return true end
            --  v:draw(breakPoint)
        end
    end
    popMatrix()
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

function Soda.Frame:keyboardHideCheck() --put this in touch began branches of end nodes (buttons, switches, things unlikely to have children)
    if Soda.keyboardEntity and Soda.keyboardEntity~=self then
        hideKeyboard()
        Soda.keyboardEntity = nil
    end
end

function Soda.Frame:touched(t, tpos)
    if self.inactive then return end
    local trans = tpos - vec2(self:left(), self:bottom())
    for i = #self.child, 1, -1 do --children take priority over frame for touch
        local v = self.child[i]
        if v:touched(t, trans) then 
            return true 
        end
    end
    if self.alert or self:pointIn(tpos.x, tpos.y) then return true end
end

function Soda.Frame:selectFromList(child) --method used by parents of selectors
    if child==self.selected then --pressed the one already selected
        if self.noSelectionPossible then
            child.highlighted = false
            self.selected = nil
        end
    else
        if self.selected then 
            self.selected.highlighted = false 
            --[[
            for i,v in ipairs(self.child) do
                if v~=child then v.highlighted = false end
            end
              ]]
            if self.selected.panel then self.selected.panel:hide() end
        end
        self.selected = child
        if child.panel then child.panel:show() end
        self.callback(child.label.text)
    end
end

function Soda.Frame:pointIn(x,y)
    return x>self:left() and x<self:right() and y>self:bottom() and y<self:top()
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
