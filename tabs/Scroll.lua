Soda.Scroll = class(Soda.Frame) --touch methods for scrolling classes, including distinguishing scroll gesture from touching a button within the scroll area, and elastic bounce back

function Soda.Scroll:init(t)
    self.scrollHeight = t.scrollHeight
    self.scrollVel = 0
    self.scrollY = 0
    self.touchMove = 1
    Soda.Frame.init(self,t)
 
    self.freeScroll = false
    self.sensor:onDrag(function(event) self:verticalScroll(event.touch, event.tpos) end)
end

function Soda.Scroll:childrenTouched(t,tpos)
    local off = tpos - vec2(self:left(), self:bottom() + self.scrollY)
    for _, v in ipairs(self.child) do --children take priority over frame for touch
       if v:touched(t, off) then return true end
    end
end

function Soda.Scroll:verticalScroll(t,tpos)
  --  if (t.state == BEGAN or t.state == MOVING) and self.sensor:inbox(tpos) then
    if (t.state == BEGAN or t.state == MOVING) and self.sensor:inbox(tpos) then
        self.scrollVel = t.deltaY
        self.scrollY = self.scrollY + t.deltaY
        self.freeScroll = false
    else
        self.freeScroll = true
    end
end

function Soda.Scroll:touched(t, tpos)
    if self.inactive then return end
    if self.sensor:touched(t, tpos) then return true end
    return self.alert
end
    
function Soda.Scroll:updateScroll()
    if self.freeScroll == false then return end
 
    local scrollH = math.max(0, self.scrollHeight -self.h)
    if self.scrollY<0 then 
      --  self.scrollVel = self.scrollVel +   math.abs(self.scrollY) * 0.005
        self.scrollY = self.scrollY * 0.7
    elseif self.scrollY>scrollH then
        self.scrollY = self.scrollY - (self.scrollY-scrollH) * 0.3
    end
    if not self.touchId then
        self.scrollY = self.scrollY + self.scrollVel
        self.scrollVel = self.scrollVel * 0.94
    end
end
