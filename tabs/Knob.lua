Soda.Knob = class(Soda.Frame)

function Soda.Knob:setPosition()
    Soda.Frame.setPosition(self)
    self.offX = self.x
    self.onX = self.x+30
    if self.parent.on then self.x = self.onX end
end

function Soda.Knob:highlight()
    if self.tween then tween.stop(self.tween) end
    
    self.tween = tween(0.4, self, {x=self.onX}, tween.easing.cubicOut)
 --   local m = self.mesh[1]
    --local t1 = tween(0.2, m, {w=60, h=40}, tween.easing.cubicIn, function() m:highlight() end)
   -- local t2 = tween(0.2, m, {w=70, h=36}, tween.easing.cubicOut)
    tween.delay(0.1, function() self.parent.highlighted = true end)

   -- tween.sequence(t1, t2)
   -- self.mesh.texture = self.image[math.min(2, #self.image)]
   -- self.mesh[1]:highlight()
end

function Soda.Knob:unHighlight()
    if self.tween then tween.stop(self.tween) end

    self.tween = tween(0.4, self, {x=self.offX}, tween.easing.cubicOut)
    tween.delay(0.1, function() self.parent.highlighted = false end)
 --   self.mesh.texture = self.image[1]   
  --  self.mesh[1]:unHighlight() 
end