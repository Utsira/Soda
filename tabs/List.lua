Soda.List = class(Soda.Segment) --vertical list of selectors, scrollable

function Soda.List:init(t)
    t.h = t.h or math.min(HEIGHT*0.8, #t.text * 20)
    t.shape = Soda.RoundedRectangle
    t.shadow = true
    Soda.Base.init(self, t)
    self:setPosition()
    self.image = image(self.w, self.h)
    setContext(self.image) background(255) setContext()
    t.shapeArgs = {radius = 16, tex = self.image}
    Soda.Frame.init(self, t)
    
    -- self.shapeArgs.tex = self.image
    -- self.mesh = {Soda.Mesh{parent = self}}
    for i,v in ipairs(t.text) do
        Soda.Selector{parent = self, label = { text = v, x = 10, y = 0.5}, style = t.style, shape = Soda.rect, shapeArgs = {edge = BOTTOMEDGE}, highlightable = true, x = 0, y = -0.001 - (i-1)*40, w = 1, h = 42} --label = { text = v, x = 0, y = 0.5}, title = v,
    end
    self.scrollH = #t.text * 40
    self.scrollVel = 0
    self.scrollY = 0
    self.elastic = 0
end

function Soda.List:orientationChanged()
    Soda.Frame.orientationChanged(self)
    self.image = image(self.w, self.h)
   -- setContext(self.image) background(255) setContext()
    self.shapeArgs.tex = self.image
    self.shapeArgs.resetTex = self.image
end

function Soda.List:draw(exception)
    if self==exception then return true end
    
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw()
    end
    local scrollH = self.scrollH -self.h
    if self.scrollY<0 then 
      --  self.scrollVel = self.scrollVel +   math.abs(self.scrollY) * 0.005
        self.scrollY = self.scrollY * 0.7
    elseif self.scrollY>scrollH then
        self.scrollY = self.scrollY - (self.scrollY-scrollH) * 0.3
    end
    self.scrollY = self.scrollY + self.scrollVel
    self.scrollVel = self.scrollVel * 0.95
    pushMatrix()
    setContext(self.image)
    background(40, 40) --self.style.shape.stroke
    
    translate(-self:left(), self.scrollY-self:bottom())

    for _, v in ipairs(self.child) do
        v:draw()
    end
    
    setContext()

    popMatrix()
    
    pushMatrix()
    translate(self:left(), self:bottom())
    self:drawShape(self.style)
    popMatrix()
end

function Soda.List:touched(t, tpos)
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

