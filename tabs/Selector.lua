Soda.Selector = class(Soda.Button) --press deactivates its siblings

function Soda.Selector:touched(t, tpos)
    if t.state == BEGAN then
        if self:pointIn(tpos.x, tpos.y) then
            self.touchId = t.id
            self:keyboardHideCheck()
            return true
        end
    elseif self.touchId and self.touchId == t.id then
        if t.state == ENDED and self:pointIn(tpos.x, tpos.y) then
    
            self:keyboardHideCheck()
            self:callback()
            self.touchId = nil
            --  self.highlighted = true
            self.parent:selectFromList(self)
            return true
        end
    end
end
