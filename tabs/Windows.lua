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

end

function Soda.Window:closeAction()     --do we want to hide this Window or kill it?
    if self.doNotKill then
        self:hide()
    else
        self.kill = true 
    end
end

--[[
function Soda.Window(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.shapeArgs = t.shapeArgs or {}
    t.shapeArgs.radius = 25
    t.label = t.label or {x=0.5, y=-15}
    
    local callback = t.callback or null
    local this = Soda.Frame(t)
    
    --do we want to hide this Window or kill it?
    local closeAction 
    if t.doNotKill then
        closeAction = function() this:hide() end
    else
        closeAction = function() this.kill = true end
    end
    
    if t.ok then
        local title = "OK"
        if type(t.ok)=="string" then title = t.ok end
        Soda.Button{parent = this, title = title, x = -10, y = 10, w = 0.3, h = 40, callback = function() closeAction() callback() end} --style = Soda.style.transparent,blurred = t.blurred,
    end
    
    if t.cancel then
        local title = "Cancel"
        if type(t.cancel)=="string" then title = t.cancel end
        Soda.Button{parent = this, title = title, x = 10, y = 10, w = 0.3, h = 40, callback = closeAction,  subStyle = {"warning"}, --style = Soda.style.warning} 
    end
    
    if t.close then
        Soda.CloseButton{parent = this, x = 5, y = -5, callback = closeAction, style = Soda.style.icon}
    end
   -- t.shadow = true
    return this
end
  ]]

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
       -- parent = t.parent,
       -- label = {x=0.5, y=-10, text = t.title},
      --    shape = t.shape or Soda.RoundedRectangle,
     --   shapeArgs = t.shapeArgs,
     --   shadow = t.shadow,
     --   style = t.style,
     parent = self,
      x = 10, y = 1, w = -20, h = -2,
     --   x = t.x or 0.5, y = t.y or 20, w = t.w or 700, h = t.h or -20,
        textBody = t.textBody,
        priority = 1
    }  

    
    --[[
    if t.closeButton then
        Soda.CloseButton{
            parent = this,
            x = -5, y = -5,
            style = Soda.style.icon,
            shape = Soda.ellipse,
            callback = function() this.kill = true end  
        }
        end
      ]]

end

function Soda.TextWindow:inputString(str)
    self.scroll:inputString(str)
end

function Soda.TextWindow:clearString()
    self.scroll:clearString()
end

--[[
function Soda.TextWindow(t)
    t.x = t.x or 0.5 
    t.y = t.y or 20
    t.w = t.w or 700
    t.h = t.h or -20
    t.style = t.style or Soda.style.thickStroke
    local this = Soda.Window(t)
    
    local scroll = Soda.TextScroll{
       -- parent = t.parent,
       -- label = {x=0.5, y=-10, text = t.title},
      --    shape = t.shape or Soda.RoundedRectangle,
     --   shapeArgs = t.shapeArgs,
     --   shadow = t.shadow,
     --   style = t.style,
     parent = this,
      x = 10, y = 1, w = -20, h = -2,
     --   x = t.x or 0.5, y = t.y or 20, w = t.w or 700, h = t.h or -20,
        textBody = t.textBody,
    }  
    
    this.inputString = function(_, ...) scroll:inputString(...) end
    this.clearString = function() scroll:clearString() end
    --pass the textscroll's method to the enclosing wrapper (make this a subclass, not a wrapper)
    
    --[==[
    if t.closeButton then
        Soda.CloseButton{
            parent = this,
            x = -5, y = -5,
            style = Soda.style.icon,
            shape = Soda.ellipse,
            callback = function() this.kill = true end  
        }
        end
      ]==]
    return this
end
  ]]
--[[
function Soda.Alert2Dark(t)
    local this = Soda.Window{title = t.title, h = 0.2, blurred = true}
    
    local ok = Soda.Button{parent = this, title = t.ok or "OK", x = 0, y = 0, w = 0.5, h = 50, style = Soda.style.dark, shape = Soda.outline, shapeArgs = {edge = TOPEDGE | RIGHTEDGE}} --style = Soda.style.transparent,blurred = true --{edgeX = LEFT, edgeY = 1, r = 25}
    
    local cancel = Soda.Button{parent = this, title = t.cancel or "Cancel", x = 0.75, y = 0, w = 0.5, h = 50, style = Soda.style.dark, shape = Soda.outline, shapeArgs = {edge = TOPEDGE}, callback = function() this.kill = true end} --style = Soda.style.transparent,{edgeX = RIGHT, edgeY = 1, r = 25}
    return this
end

function Soda.Alert2(t)
    local this = Soda.Frame{h = 0.25} --, edge = ~BOTTOMEDGE
     
    this.mesh = {
        Soda.Mesh{parent = this, shape = Soda.roundedRect, style = Soda.style.default, shapeArgs = {r = 25}, label = {x=0.5, y=0.6, text = t.title}}}
    
    this.mesh[2] = Soda.Shadow{parent = this}
    
    local ok = Soda.Button{parent = this, title = t.ok or "OK", x = 0.251, y = 0, w = 0.5, h = 50, shapeArgs = {r = 25, edge = LEFTEDGE | BOTTOMEDGE}} --style = Soda.style.transparent,blurred = true --{edgeX = LEFT, edgeY = 1, r = 25}
    local cancel = Soda.Button{parent = this, title = t.cancel or "Cancel", x = 0.748, y = 0, w = 0.5, h = 50, shapeArgs = {r = 25, edge = RIGHTEDGE | BOTTOMEDGE}, callback = function() this.kill = true end} --style = Soda.style.transparent,{edgeX = RIGHT, edgeY = 1, r = 25}
    return this
end
  ]]

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

