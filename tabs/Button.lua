Soda.Button = class(Soda.Frame) --one press, activates on release

function Soda.Button:init(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.label = t.label or { x=0.5, y=0.5, text = t.title}
    t.highlightable = true
    Soda.Frame.init(self, t)

--
    -- #################################### <JMV38 changes>
    self.sensor = Soda.Sensor{parent=self, xywhMode = CENTER}
    self.sensor:onTap(function(event) self:callback() end)
end
function Soda.Button:touched(t, tpos)
    if self.sensor:touched(t, tpos) then return true end
end
--[[
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
            if not self:pointIn(tpos.x, tpos.y) then --if a touch begins within the element, but then drifts off it, it is cancelled. ie the user can change their mind. This is the same as on iOS.
                self.highlighted = false
                self.touchId = nil
                return true
            end
        else --ended
            self:callback()
            self.highlighted = false
            self.touchId = nil
            return true
        end
    end
   -- return Soda.Frame.touched(self, t, tpos) --a button shouldn't have children
end
--]]
    -- #################################### </JMV38 changes>

----- Some button factories:

function Soda.MenuButton(t)
    t.title = "\u{2630}" --the "hamburger" menu icon
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.BackButton(t)
    t.title = "\u{ff1c}" -- full-width less-than symbol. alt \u{276e}
    if  t.direction == RIGHT then
        t.title = "\u{ff1e}" --greater-than, in case you need a right-facing back button. alt \u{276f}
    end
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.CloseButton(t)
    t.title = "\u{2715}" --multiplication X 
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Button(t)
end

function Soda.DropdownButton(t)
    t.title = "\u{25bc}" --down triangle
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
    t.title = "?" --full-width ? \u{ff1f}
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    t.shape = t.shape or Soda.ellipse
    return Soda.Button(t)
end

