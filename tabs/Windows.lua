--factories for various window types

--difference between dialog and window
--dialogs ok/cancel buttons occupy full width of window, like ios alerts. Are disposable (closing them kills them)
--window has discrete ok/cancel buttons. Has doNotKill option where dismissing window will hide it instead of killing it
Soda.Window = class(Soda.Frame)

function Soda.Window:init(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.shapeArgs = t.shapeArgs or {}
    t.shapeArgs.radius = 25
    t.label = t.label or {x=0.5, y=-15}
    t.content = t.content or ""
    local callback = t.callback or null
    Soda.Frame.init(self, t)
        
    if t.ok then
        local title = "OK"
        if type(t.ok)=="string" then title = t.ok end
        Soda.Button{parent = self, title = title, x = -10, y = 10, w = 0.3, h = 40, callback = function() self:closeAction() callback() end} --style = Soda.style.transparent,blurred = t.blurred,
    end
    
    if t.cancel then
        local title = "Cancel"
        if type(t.cancel)=="string" then title = t.cancel end
        Soda.Button{parent = self, title = title, x = 10, y = 10, w = 0.3, h = 40, callback = function() self:closeAction() end,  subStyle = {"warning"}} --style = Soda.style.warning 
    end
    
    local closeStyle = {"icon", "button"}
    if t.blurred then
        closeStyle = {"icon"}
    end
    if t.close then
        Soda.CloseButton{
            parent = self, 
            x = 5, y = -5, 
            shape = Soda.ellipse,
            callback = function() self:closeAction() end, 
            subStyle = closeStyle --style = Soda.style.icon
        }
    end
   -- t.shadow = true
    if t.draggable then
        self.sensor:onDrag(function(event) 
            if isKeyboardShowing() then return end -- no winsow drag when keyboard is showing
            self.x = self.x + event.touch.deltaX 
            self.y = self.y + event.touch.deltaY
        end)
    end
end

function Soda.Window:closeAction()     --do we want to hide this Window or kill it?
    if self.doNotKill then
        self:hide()
    else
        self.kill = true 
    end
end

function Soda.Window2(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.shapeArgs = t.shapeArgs or {}
    t.shapeArgs.radius = 25
    t.style = t.style or Soda.style.thickStroke
    t.label = {x=0.5, y=-10}
 --   t.shadow = true
    return Soda.Frame(t)
end

Soda.TextWindow = class(Soda.Window)

function Soda.TextWindow:init(t)
    t.x = t.x or 0.5 
    t.y = t.y or 20
    t.w = t.w or 700
    t.h = t.h or -20
    t.style = t.style or Soda.style.thickStroke
    Soda.Window.init(self, t)
    
    self.scroll = Soda.TextScroll{

     parent = self,
      x = 10, y = 1, w = -20, h = -2,
     --   x = t.x or 0.5, y = t.y or 20, w = t.w or 700, h = t.h or -20,
        textBody = t.textBody,
        priority = 1
    }  

end

function Soda.TextWindow:inputString(str)
    self.scroll:inputString(str)
end

function Soda.TextWindow:clearString()
    self.scroll:clearString()
end

function Soda.Alert2(t)
        t.shape = t.shape or Soda.RoundedRectangle
    t.shapeArgs = t.shapeArgs or {}
    t.shapeArgs.radius = 25
    t.label = t.label or {x=0.5, y=-15}

    t.h = t.h or 0.25
    t.shadow = true
 --   t.label = {x=0.5, y=0.6}
    t.alert = true  --if alert=true, underlying elements are inactive and darkened until alert is dismissed
    local callback = t.callback or null
    
    local this = Soda.Frame(t)
    
    local proceed = Soda.Button{
        parent = this, 
        title = t.ok or "Proceed", 
        x = 0.749, y = 0, w = 0.5, h = 50, 
        shapeArgs = {corners = 8, radius = 25}, 
        callback = function() this.kill = true callback() end,  
        subStyle = {"transparent"} --style = Soda.style.transparent
    } --style = Soda.style.transparent,blurred = t.blurred,
    
    local cancel = Soda.Button{
        parent = this, 
        title = t.cancel or "Cancel", 
        x = 0.251, y = 0, w = 0.5, h = 50, 
        shapeArgs = {corners = 1, radius = 25}, 
        callback = function() this.kill = true end,  
        subStyle = {"transparent"} --style = Soda.style.transparent
    } 
    
    return this
end

function Soda.Alert(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.shapeArgs = t.shapeArgs or {}
    t.shapeArgs.radius = 25
    t.label = t.label or {x=0.5, y=-15}

    t.h = t.h or 0.25
    t.shadow = true
 --   t.label = {x=0.5, y=0.6}
    t.alert = true  --if alert=true, underlying elements are inactive and darkened until alert is dismissed
    local callback = t.callback or null
    
    local this = Soda.Frame(t)
    
    local ok = Soda.Button{
        parent = this, 
        title = t.ok or "OK", 
        x = 0, y = 0, w = 1, h = 50, 
        shapeArgs = {corners = 1 | 8, radius = 25}, 
        callback = function() this.kill = true callback() end,  
        subStyle = {"transparent"} --style = Soda.style.transparent
    } --style = Soda.style.transparent,blurred = t.blurred,
    return this
end
