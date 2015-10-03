Soda.ScrollShape = class(Soda.Scroll) --scrolling inside a shape, eg a rounded rectangle

function Soda.ScrollShape:init(t)
    t.h = t.h or math.min(HEIGHT*0.8, #t.text * 20)
    t.shape = Soda.RoundedRectangle 
  --  self:storeParameters(t)
  --  self:setPosition()

    Soda.Scroll.init(self, t)
    
    self.image = image(self.w, self.h)
    setContext(self.image) background(255) setContext()
    self.shapeArgs.radius = t.shapeArgs.radius or 6
    self.shapeArgs.tex = self.image
    self.shapeArgs.resetTex = self.image
    
end

function Soda.ScrollShape:orientationChanged()
    Soda.Frame.orientationChanged(self)
    self.image = image(self.w, self.h)
   -- setContext(self.image) background(255) setContext()
    self.shapeArgs.tex = self.image
    self.shapeArgs.resetTex = self.image
end

function Soda.ScrollShape:draw(breakPoint)
    if breakPoint and breakPoint==self then return true end
    if self.hidden then return end
    
    if self.alert then
        Soda.darken.draw()
    end
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw()
    end
      
    self:updateScroll()

    if not breakPoint then
        --  tween.delay(0.001, function() self:drawImage() end)
        setContext(self.image)
        background(150, 180) --40,40 self.style.shape.stroke
        
        pushMatrix()
        resetMatrix()
        --if self.blurred then sprite(self.mesh[1].image, self.w*0.5, self.h*0.5, self.w, self.h) end
        translate(0, self.scrollY)
        self:drawImage()
        popMatrix()
        setContext()
    end
 
    pushMatrix()
    translate(self:left(), self:bottom())
    self:drawShape(self.styleList)
    popMatrix()
end

function Soda.ScrollShape:drawImage()

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

end




