Soda.Label = class(Soda.Base)

function Soda.Label:init(t)
    Soda.Base.init(self, t)
    self.style = t.style or Soda.style.default
    self.w, self.h = self:getTextSize()
   -- self.textMode = t.textMode or CENTER
end

function Soda.Label:getTextSize()
    pushStyle()
    self:setStyle(Soda.style.default.text)
    self:setStyle(self.style.text)
    local w,h = textSize(self.text)
    popStyle()
    return w,h
end

function Soda.Label:draw(sty) --label coords are parsed relative to component owner
  --  pushStyle()
    --textMode(self.textMode)
    fill(sty.fill)
 local x = self:parseCoord(self.x,self.w,0,self.parent.w)
  local y = self:parseCoord(self.y,self.h,0,self.parent.h)
  --  self:setPosition()
    text(self.text, x, y)
  --  popStyle()
end
