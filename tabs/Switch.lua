Soda.Switch = class(Soda.Toggle) --an iOS-style switch with a lever that moves back and forth

function Soda.Switch:init(t)

    local tw,_ = textSize(t.title or "")
   -- t.w, t.h = 120+tw,40

<<<<<<< tabs/Switch.lua
    Soda.Frame.init(self, {parent = t.parent, x = t.x, y=t.y, w = 120+tw, h = 40, on = t.on or false, style = t.style or Soda.style.switch, shape = Soda.RoundedRectangle, shapeArgs = {w = 70, h = 36, radius = 18, x = 0, y = 2}, highlightable = true, label = {x=80, y=0.5} , title = t.title})
=======
    Soda.Frame.init(self, {
        parent = t.parent, 
        x = t.x, y=t.y, w = 120+tw, h = 40, 
        on = t.on or false, 
       -- style = t.style or Soda.style.switch, 
        subStyle = {"switch"},
        shape = Soda.RoundedRectangle, 
        shapeArgs = {w = 70, h = 36, radius = 18, x = 0, y = 2}, 
        highlightable = true, 
        label = {x=80, y=0.5} , title = t.title
    })
>>>>>>> tabs/Switch.lua

    self.knob = Soda.Knob{parent = self, x = 0, y = 0.5, w=38, h=38, shape = Soda.ellipse, shadow = true}
    
    self:toggleSettings(t)
    
    -- #################################### <JMV38 changes>
    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    self.sensor:onTap(function(event) self:toggleMe() end)
    -- #################################### </JMV38 changes>
end

function Soda.Switch:switchOn()
    Soda.Toggle.switchOn(self)
    self.knob:highlight() 
end

function Soda.Switch:switchOff()
    Soda.Toggle.switchOff(self)
    self.knob:unHighlight() 
end

--animates the switch handle flicking back and forth

Soda.Knob = class(Soda.Frame) 

function Soda.Knob:setPosition()
    Soda.Frame.setPosition(self)
    self.offX = self.x - 1
    self.onX = self.x+34
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

end

function Soda.Knob:unHighlight()
    if self.tween then tween.stop(self.tween) tween.stop(self.tween2) end

    self.tween = tween(0.4, self, {x=self.offX}, tween.easing.cubicOut)
        local p = self.parent
    p.shapeArgs.scale = 1
    local t1 = tween(0.1, p.shapeArgs, {scale = 0.7}, tween.easing.cubicIn, function() p.highlighted = false end)
    local t2 = tween(0.3, p.shapeArgs, {scale = 1 }, tween.easing.cubicOut)
    self.tween2 = tween.sequence(t1, t2)

end
<<<<<<< tabs/Switch.lua




=======
>>>>>>> tabs/Switch.lua
