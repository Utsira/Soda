Soda.Button = class(Soda.Frame)

function Soda.Button:init(t)
    local shape = t.shape or Soda.roundedRect
    Soda.Frame.init(self, t)
    self.mesh = {
        Soda.Mesh{parent = self, style = t.style, shape = shape, shapeArgs = t.shapeArgs, highlightable = true, label = 
            Soda.Label{parent = self, x=0.5, y=0.5, style = t.style, text = t.title}
        }}
     self.mesh[2] = Soda.Shadow{parent = self}
end

function Soda.Button:touched(t)
    Soda.Frame.touched(self, t)
    if t.state == BEGAN then
        if self:pointIn(t.x, t.y) then
            self.mesh[1]:highlight()
            self.touchId = t.id
            return true
        end
    elseif self.touchId and self.touchId == t.id then
        if t.state == MOVING then
            if not self:pointIn(t.x, t.y) then --cancelled
                self.mesh[1]:unHighlight()
                self.touchId = nil
                return true
            end
        else --ended
            self.callback()
            self.mesh[1]:unHighlight()
            self.touchId = nil
            return true
        end
    end
end

