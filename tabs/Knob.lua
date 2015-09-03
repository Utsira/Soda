Soda.Knob = class(Soda.Frame)

function Soda.Knob:setPosition()
    Soda.Frame.setPosition(self)
    self.offX = self.x - 2
    self.onX = self.x+32
    if self.parent.on then self.x = self.onX end
end

function Soda.Knob:highlight()
    if self.tween then tween.stop(self.tween) tween.stop(self.tween2) end
    
    self.tween = tween(0.4, self, {x=self.onX}, tween.easing.cubicOut)
    local p = self.parent
    p.shapeArgs.scale = 1
    local t1 = tween(0.1, p.shapeArgs, {scale = 0.7}, tween.easing.cubicIn, function() p.highlighted = true end)
    local t2 = tween(0.3, p.shapeArgs, {scale = 1 }, tween.easing.cubicOut)
    self.tween2 = tween.sequence(t1, t2)
    -- tween.delay(0.1, function() self.parent.highlighted = true end)
   -- self.mesh.texture = self.image[math.min(2, #self.image)]
   -- self.mesh[1]:highlight()
end

function Soda.Knob:unHighlight()
    if self.tween then tween.stop(self.tween) tween.stop(self.tween2) end

    self.tween = tween(0.4, self, {x=self.offX}, tween.easing.cubicOut)
        local p = self.parent
    p.shapeArgs.scale = 1
    local t1 = tween(0.1, p.shapeArgs, {scale = 0.7}, tween.easing.cubicIn, function() p.highlighted = false end)
    local t2 = tween(0.3, p.shapeArgs, {scale = 1 }, tween.easing.cubicOut)
    self.tween2 = tween.sequence(t1, t2)
--    tween.delay(0.1, function() self.parent.highlighted = false end)
 --   self.mesh.texture = self.image[1]   
  --  self.mesh[1]:unHighlight() 
end