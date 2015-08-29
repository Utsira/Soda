Soda.Switch = class(Soda.Frame)


function Soda.Switch:init(t)
    self.on = t.on or false
    local tw,_ = textSize(t.title or "")
    t.w, t.h = 120+tw,40

    Soda.Frame.init(self, t)
    self.mesh = {
        --Soda.Mesh{parent = self, shape = Soda.ellipse, shapeArgs = {x = 20, y = 20, w=40, h=40}},
        Soda.Mesh{parent = self, style = Soda.style.switch, shape = Soda.roundedRect, shapeArgs = {w = 70, h = 36, r = 18, x = 0, y = 2}, highlightable = true, label = 
            Soda.Label{parent = self, x=-20, y=0.5, style = t.style, text = t.title}
        }} --tw*0.7
    
        self.handle = Soda.Frame{parent = self, x = 0, y = 0.5, w=40, h=40}
    self.handle.mesh = {Soda.Mesh{parent = self.handle, shape = Soda.ellipse}}
    self.handle.mesh[2] = Soda.Shadow{parent = self.handle}

end

function Soda.Switch:highlight()
    if self.tween then tween.stop(self.tween) end
    
    local x = self.handle.x + 30
    self.tween = tween(0.4, self.handle, {x=x}, tween.easing.cubicOut)
    local m = self.mesh[1]
    --local t1 = tween(0.2, m, {w=60, h=40}, tween.easing.cubicIn, function() m:highlight() end)
   -- local t2 = tween(0.2, m, {w=70, h=36}, tween.easing.cubicOut)
     tween.delay(0.1, function() m:highlight() end)

   -- tween.sequence(t1, t2)
   -- self.mesh.texture = self.image[math.min(2, #self.image)]
   -- self.mesh[1]:highlight()
end

function Soda.Switch:unHighlight()
    if self.tween then tween.stop(self.tween) end
    
    local x = self.handle.x - 30
    self.tween = tween(0.4, self.handle, {x=x}, tween.easing.cubicOut)
    tween.delay(0.1, function() self.mesh[1]:unHighlight() end)
 --   self.mesh.texture = self.image[1]   
  --  self.mesh[1]:unHighlight() 
end

function Soda.Switch:touched(t)
    Soda.Frame.touched(self, t)
    if t.state == BEGAN then
        if self:pointIn(t.x, t.y) then
            self.touchId = t.id
            return true
        end
    elseif self.touchId and self.touchId == t.id then
        if t.state == MOVING then
            if not self:pointIn(t.x, t.y) then --cancelled
                self.touchId = nil
                
                return true
            end
        else --ended
            self.callback()
            
            self.touchId = nil
            self.on = not self.on
                if self.on then self:highlight() else self:unHighlight() end
            return true
        end
        
    end
    
end
