Soda.Button = class(Soda.Frame) --one press, activates on release

function Soda.Button:init(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.label = t.label or { x=0.5, y=0.5, text = t.title}
    t.highlightable = true
    Soda.Frame.init(self, t)
end

function Soda.Button:touched(t, tpos)
    if t.state == BEGAN then
        if self:pointIn(tpos.x, tpos.y) then
            self.highlighted = true
            self.touchId = t.id
            self:keyboardHideCheck()
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

----- Some button factories:

function Soda.MenuButton(t)
    t.title = "\u{2630}" --the "hamburger" menu icon
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.BackButton(t)
    t.title = "\u{ff1c}" --full-width less-than symbol
    if  t.direction == RIGHT then
        t.title = "\u{ff1e}" --greater-than, in case you need a right-facing back button
    end
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.CloseButton(t)
    t.title = "\u{ff38}" --full-width X
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.SettingsButton(t)
    t.title = "\u{2699}" -- the "gear" icon
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    t.shape = t.shape or Soda.ellipse
    return Soda.Button(t)
end

function Soda.AddButton(t)
    t.title = "\u{253c}" -- the "add" icon
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    t.shape = t.shape or Soda.ellipse
    return Soda.Button(t)
end

function Soda.QueryButton(t)
    t.title = "\u{ff1f}" --full-width ?
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    t.shape = t.shape or Soda.ellipse
    return Soda.Button(t)
end