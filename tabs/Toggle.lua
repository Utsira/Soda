Soda.Toggle = class(Soda.Button) --press toggles on/ off states

function Soda.Toggle:init(t)
    Soda.Button.init(self,t)
    self:toggleSettings(t)
    -- #################################### <JMV38 changes>
    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    self.sensor:onTap(function(event) self:toggleMe() end)
end
function Soda.Toggle:toggleMe()
    self.on = not self.on
    if self.on then
        self:switchOn()
    else
        self:switchOff()
    end
end
    -- #################################### </JMV38 changes>

function Soda.Toggle:toggleSettings(t)
    self.on = t.on or false    
    self.callback = t.callback or null
    self.callbackOff = t.callbackOff or null
    if self.on then 
        self:switchOn() 
    else
        self:switchOff()
    end
end

function Soda.Toggle:switchOn()
    self.on = true
    self.highlighted = true
    self:callback()
end

function Soda.Toggle:switchOff()
    self.on = false
    self.highlighted = false
    self:callbackOff()
end

----- Some toggle factories:

function Soda.MenuToggle(t)
    t.title = "\u{2630}" --the "hamburger" menu icon
    t.w, t.h = 40, 40
    t.style = t.style or Soda.style.darkIcon
    return Soda.Toggle(t)
end


    -- #################################### <JMV38 changes>

--[[
function Soda.Toggle:touched(t, tpos)   
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
                
                return true
            end
        else --ended     
            self.touchId = nil
            self.on = not self.on
            if self.on then 
                self:switchOn() 
                
            else 
                self:switchOff() 
                
            end
            return true
        end
        
    end
   -- return Soda.Frame.touched(self, t, tpos) ---switch shouldn't have children
end
--]]
    -- #################################### </JMV38 changes>



function Soda.SettingsToggle(t)
    t.title = "\u{2699}" -- the "gear" icon
    t.w, t.h = 40, 40
    t.style = t.style --or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    return Soda.Toggle(t)
end



