Soda.Switch = class(Soda.Frame) --press toggles on/ off stats

function Soda.Switch:init(t)
    self.on = t.on or false
    local tw,_ = textSize(t.title or "")
   -- t.w, t.h = 120+tw,40

    Soda.Frame.init(self, {parent = t.parent, x = t.x, y=t.y, w = 120+tw, h = 40, on = t.on or false, style = Soda.style.switch, shape = Soda.RoundedRectangle, shapeArgs = {w = 70, h = 36, radius = 18, x = 0, y = 2}, highlightable = true, label = {x=80, y=0.5, text = t.title}})

    self.knob = Soda.Knob{parent = self, x = 0, y = 0.5, w=40, h=40, shape = Soda.ellipse, style = Soda.style.switch, shadow = true}
    
    if self.on then self.knob:highlight() end
end

function Soda.Switch:touched(t, tpos)   
    if t.state == BEGAN then
        if self:pointIn(tpos.x, tpos.y) then
            self.touchId = t.id
            self:keyboardHideCheck()
            return true
        end
    elseif self.touchId and self.touchId == t.id then
        if t.state == MOVING then
            if not self:pointIn(tpos.x, tpos.y) then --cancelled
                self.touchId = nil
                
                return true
            end
        else --ended
            self.callback()
            
            self.touchId = nil
            self.on = not self.on
                if self.on then self.knob:highlight() else self.knob:unHighlight() end
            return true
        end
        
    end
   -- return Soda.Frame.touched(self, t, tpos) ---switch shouldn't have children
end

--animates the switch handle flicking back and forth

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