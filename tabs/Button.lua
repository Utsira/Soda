Soda.Button = class(Soda.Frame)

function Soda.Button:init(t)
    local shape = t.shape or Soda.roundedRect
    Soda.Frame.init(self, t)
    self.mesh = {
        Soda.Mesh{parent = self, style = t.style, shape = shape, shapeArgs = t.shapeArgs, highlightable = true, label = { x=0.5, y=0.5, text = t.title}, mask = t.frosted}
    }
        if t.frosted then
        self.mesh[2] = Soda.Frosted{parent = self}
    end
    if t.shadow then
     table.insert(self.mesh, Soda.Shadow{parent = self})
    end
end

function Soda.Button:touched(t)
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
    if Soda.Frame.touched(self, t) then return true end
end

