Soda.Selector = class(Soda.Button) --press deactivates its siblings

function Soda.Selector:init(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.label = t.label or { x=0.5, y=0.5}
    t.highlightable = true
    t.subStyle = t.subStyle or {"button"}
   Soda.Frame.init(self, t)
--    Soda.Button.init(self, t)
--
    -- #################################### yojimbo changes <JMV38 changes>
    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    self.sensor:onQuickTap(function(event) 
        self:callback() 
        self.parent:selectFromList(self) 
    end)

end

--[[
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
<<<<<<< tabs/Selector.lua
  ]]





