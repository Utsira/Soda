Soda.Selector = class(Soda.Button) --press deactivates its siblings

function Soda.Selector:touched(t, tpos)
    if t.state == ENDED and self:pointIn(tpos.x, tpos.y) then
        self:keyboardHideCheck()
        self:callback()
        self.highlighted = true
        self.parent:selectFromList(self)
        return true
    end
end

