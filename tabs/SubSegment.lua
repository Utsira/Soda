Soda.SubSegment = class(Soda.Button)

function Soda.SubSegment:init(t)
    Soda.Button.init(self, t)
end

function Soda.SubSegment:touched(t)
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
            self.on = true
            self.mesh[1]:highlight() 
            self.parent:toggleOthers(self)
            return true
        end
        
    end
end
