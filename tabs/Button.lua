Soda.Button = class(Soda.Frame) --one press, activates on release

function Soda.Button:init(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.label = t.label or { x=0.5, y=0.5, text = t.title}
    t.highlightable = true
    Soda.Frame.init(self, t)
    --[[
    self.mesh = {
        Soda.Mesh{parent = self, style = t.style, shape = shape, shapeArgs = t.shapeArgs, highlightable = true, label = { x=0.5, y=0.5, text = t.title}, mask = t.blurred}
    }
        if t.blurred then
        self.mesh[2] = Soda.Blur{parent = self}
    end
    if t.shadow then
     table.insert(self.mesh, Soda.Shadow{parent = self})
    end
      ]]
end

function Soda.Button:touched(t, tpos)
    if t.state == BEGAN then
        if self:pointIn(tpos.x, tpos.y) then
            self.highlighted = true
            self.touchId = t.id
            return true
        end
    elseif self.touchId and self.touchId == t.id then
        if t.state == MOVING then
            if not self:pointIn(tpos.x, tpos.y) then --cancelled
                self.highlighted = false
                self.touchId = nil
                return true
            end
        else --ended
            self.callback()
            self.highlighted = false
            self.touchId = nil
            return true
        end
    end
    return Soda.Frame.touched(self, t, tpos) 
end

