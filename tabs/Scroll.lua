Soda.Scroll = class(Soda.Frame) --vertical list of selectors, scrollable

function Soda.Scroll:init(t)
    t.h = t.h or math.min(HEIGHT*0.8, #t.text * 20)
    t.shape = Soda.RoundedRectangle --need to add a rect class that can accept a texture
    t.shadow = true
    Soda.Base.init(self, t)
    self:setPosition()
    self.image = image(self.w, self.h)
    setContext(self.image) background(255) setContext()
    t.shapeArgs = {radius = 16, tex = self.image}
    Soda.Frame.init(self, t)

    self.scrollHeight = t.scrollHeight
    self.scrollVel = 0
    self.scrollY = 0
    self.touchMove = 1
end

function Soda.Scroll:orientationChanged()
    Soda.Frame.orientationChanged(self)
    self.image = image(self.w, self.h)
   -- setContext(self.image) background(255) setContext()
    self.shapeArgs.tex = self.image
    self.shapeArgs.resetTex = self.image
end

function Soda.Scroll:draw(breakPoint)
    if breakPoint and breakPoint==self then return true end
    
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw()
    end
    local scrollH = self.scrollHeight -self.h
    if self.scrollY<0 then 
      --  self.scrollVel = self.scrollVel +   math.abs(self.scrollY) * 0.005
        self.scrollY = self.scrollY * 0.7
    elseif self.scrollY>scrollH then
        self.scrollY = self.scrollY - (self.scrollY-scrollH) * 0.3
    end
    self.scrollY = self.scrollY + self.scrollVel
    self.scrollVel = self.scrollVel * 0.95
    pushMatrix()
    if not breakPoint then
        setContext(self.image)
        background(40, 40) --40,40 self.style.shape.stroke
        
        translate(-self:left(), self.scrollY-self:bottom())
        
        for _, v in ipairs(self.child) do
            v:draw()
        end
        
        --[[
        if breakPoint then
        -- setContext(breakPoint.mesh[1].image)
        -- setContext(breakPoint.image)
        breakPoint.image()
    else
        ]]
        
        setContext()
    end
    popMatrix()
    
    pushMatrix()
    translate(self:left(), self:bottom())
    self:drawShape(self.style)
    popMatrix()
end

function Soda.Scroll:touched(t, tpos)
    if self:pointIn(tpos.x, tpos.y) then
        
        if t.state == BEGAN then
            self.scrollVel = t.deltaY
            self.touchId = t.id
            self.touchMove = 0
            
        elseif self.touchId and self.touchId == t.id then
            if t.state == MOVING then
                self.scrollVel = t.deltaY
                self.touchMove = self.touchMove + math.abs(t.deltaY) --track ammount of vertical motion
            else --ended
                self.touchId = nil
            end
        end
        if self.touchMove<0.1 then --only test selectors if this touch was not a scroll gesture
            local off = tpos - vec2(0,self.scrollY)
            for _, v in ipairs(self.child) do --children take priority over frame for touch
                if v:touched(t, off) then return true end
            end
        end
        
    end
    return self.alert
end

