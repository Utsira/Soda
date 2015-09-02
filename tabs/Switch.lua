Soda.Switch = class(Soda.Frame) --press toggles on/ off stats


function Soda.Switch:init(t)
    self.on = t.on or false
    local tw,_ = textSize(t.title or "")
   -- t.w, t.h = 120+tw,40

    Soda.Frame.init(self, {parent = t.parent, x = t.x, y=t.y, w = 120+tw, h = 40, on = t.on or false, style = Soda.style.switch, shape = Soda.RoundedRectangle, shapeArgs = {w = 70, h = 36, radius = 18, x = 0, y = 2}, highlightable = true, label = {x=80, y=0.5, text = t.title}})
    --[[
    self.mesh = {
        --Soda.Mesh{parent = self, shape = Soda.ellipse, shapeArgs = {x = 20, y = 20, w=40, h=40}},
        Soda.Mesh{parent = self, style = Soda.style.switch, shape = Soda.roundedRect, shapeArgs = {w = 70, h = 36, r = 18, x = 0, y = 2}, highlightable = true, label = {x=80, y=0.5, text = t.title}}
    } --tw*0.7
      ]]
    
    self.knob = Soda.Knob{parent = self, x = 0, y = 0.5, w=40, h=40, shape = Soda.ellipse, style = Soda.style.switch, shadow = true}
    
  --  self.handle.mesh = {Soda.Mesh{parent = self.handle, shape = Soda.ellipse, style = Soda.style.switch}}
  --  self.handle.mesh[2] = Soda.Shadow{parent = self.handle}

end

function Soda.Switch:touched(t, tpos)   
    if t.state == BEGAN then
        if self:pointIn(tpos.x, tpos.y) then
            self.touchId = t.id
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
    return Soda.Frame.touched(self, t, tpos) 
end
