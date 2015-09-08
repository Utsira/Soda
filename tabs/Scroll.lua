Soda.Scroll = class(Soda.Frame) --touch methods for scrolling classes, including distinguishing scroll gesture from touching a button within the scroll area, and elastic bounce back

function Soda.Scroll:init(t)
    self.scrollHeight = t.scrollHeight
    self.scrollVel = 0
    self.scrollY = 0
    self.touchMove = 1
    Soda.Frame.init(self,t)
end

function Soda.Scroll:update()
      local scrollH = self.scrollHeight -self.h
    if self.scrollY<0 then 
      --  self.scrollVel = self.scrollVel +   math.abs(self.scrollY) * 0.005
        self.scrollY = self.scrollY * 0.7
    elseif self.scrollY>scrollH then
        self.scrollY = self.scrollY - (self.scrollY-scrollH) * 0.3
    end
    self.scrollY = self.scrollY + self.scrollVel
    self.scrollVel = self.scrollVel * 0.95
end

function Soda.Scroll:touched(t, tpos)
    if self.inactive then return end
    if self:pointIn(tpos.x, tpos.y) then
        
        if t.state == BEGAN then
            self.scrollVel = t.deltaY
            self.touchId = t.id
            self.touchMove = 0
            self:keyboardHideCheck()
        elseif self.touchId and self.touchId == t.id then
            if t.state == MOVING then
                self.scrollVel = t.deltaY
                self.touchMove = self.touchMove + math.abs(t.deltaY) --track ammount of vertical motion
            else --ended
                self.touchId = nil
            end
    
        end
        if self.touchMove<0.1 then --only test selectors if this touch was not a scroll gesture
            local off = tpos - vec2(self:left(), self:bottom() + self.scrollY)
            for _, v in ipairs(self.child) do --children take priority over frame for touch
                if v:touched(t, off) then return true end
            end
        end
        return true
    end
    return self.alert
end
