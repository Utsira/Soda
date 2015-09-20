Soda.Selector = class(Soda.Button) --press deactivates its siblings

--[[
function Soda.Selector:touched(t, tpos)
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
               -- return true
            end
        elseif t.state == ENDED then
            self.touchId = nil
          --  self.on = true
            if self:pointIn(tpos.x, tpos.y) then
                self:callback()
                self.highlighted = true
                self.parent:selectFromList(self)
                return true
            end
        end
    end
   -- return Soda.Frame.touched(self, t, tpos) --a selector shouldn't have children
end
  ]]

function Soda.Selector:touched(t, tpos)
    if t.state == ENDED and self:pointIn(tpos.x, tpos.y) then
        self:keyboardHideCheck()
        self:callback()
        self.highlighted = true
        self.parent:selectFromList(self)
        return true
    end
end