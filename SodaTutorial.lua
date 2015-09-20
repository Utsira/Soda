
--# Main
-- Soda Tutorial
-- v1.2

displayMode(OVERLAY)
displayMode(FULLSCREEN)

function setup()
    Soda.setup()
    tutorial()
end

function draw()
    --do your updating here
    pushMatrix()
    Soda.camera()
    Soda.drawing()
    popMatrix()
end

function Soda.drawing(breakPoint) 
    --in order for gaussian blur to work, do all your drawing here
    background(40, 40, 50)
    sprite("Cargo Bot:Game Area", WIDTH*0.5, HEIGHT*0.5, WIDTH, HEIGHT)
    pushStyle()
    Soda.setStyle(Soda.style.default.text)
    fontSize(40)
    text("Output\narea", WIDTH * 0.5, HEIGHT * 0.75)
    popStyle()
    
    Soda.draw(breakPoint)
end

--user inputs:

function touched(touch)
    Soda.touched(touch)
end

function keyboard(key)
    Soda.keyboard(key)
end

function orientationChanged(ori)
    Soda.orientationChanged(ori)
end


--# Tutorial
--the tutorial interface, not part of the tutorial itself
function tutorial()
    parameter.watch("#Soda.items")

    local steps = listProjectTabs() --get the steps of the tutorial
    table.remove(steps, 1) --remove Main and this tab from the tutorial
    table.remove(steps, 1)
    
    --grab the names of each tutorial step
    local stepNames = {}
    for i,v in ipairs(steps) do
        loadstring(readProjectTab(v))()
        stepNames[i] = title 
    end
    
    local codeWindow = Soda.TextWindow{
        shapeArgs = {corners = 2 | 4, radius = 25},
        style = Soda.style.default,
        x = 0, y = 0, w = 1, h = 0.5,
         title = "",
        text = "",
    }
    
    Soda.DropdownList{
        parent = codeWindow,
        shapeArgs = {radius = 20},
        x = 0.5, y = -5, w = 400, h = 40,
        title = "Tutorial Step",
        text = stepNames, 
        enumerate = true,
        callback = function(self, obj)  
            local code = readProjectTab(steps[obj.idNo])
            codeWindow:inputString(code:match("function setupUI%(%)(.-)end%s*$"))     
            while #Soda.items>1 do
                table.remove(Soda.items)
            end
            tween.delay(0.001, function() loadstring(code)()
    setupUI() end) 
        end
    }

end

--# HelloWorld
title = "Hello World"
    
function setupUI()
    --all Soda elements take a table of keys as their arguments
    --in Lua, if a function's sole argument is a table or a string,
    --you can omit the enclosing () and just use "" or, in this case, {}
    
    Soda.Frame{  --Soda.Frame is a basic holder for other elements.
        title = "Hello World", --title at the top of the window
        --when coordinates are between 0 and 1, they represent proportions of the parent
        --and the drawing mode is set to CENTER 
        --as there is no parent here, they are proportions of the entire screen:
        x=0.5, --Horizontally, the window is centred,
        y=-0.001, --And as we can't write -0, we fix it to the top edge with -0.001
        w=0.7, --Its dimensions cover 70% of the screen's width
        h=0.51, --and just over half of its height
        shape = Soda.rect --give the frame a visible shape
    }
    --the advantage of making all coordinates relative to a parent (in this case the screen)
    --is that elements automatically resize when device orientation changes.
    --try flipping your device now.
end

--# Window
title = "A window"
    
function setupUI()
    --shapes and presets
    --Soda.Window is a basic window with a title. We're not going to set a shape argument, because Window automatically selects the Soda.roundedRectangle shape. We can override this if we want.
    Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 

    }
end

--# Effects
title = "Special effects"
    
function setupUI()
    --special effects
    Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 

        blurred = true, --add a blurred effect
        --note that because the background is slightly translucent, we can see the underlying area through the blur, creating an interesting glow effect
        shadow = true, --add a drop shadow

    }
end
--# Styles
title = "Let's get styling"
    
function setupUI()
    --lets style our panel
    Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
    
        blurred = true, 
        shadow = true, 
        --the Style tab of the Soda library contains the Soda.style table 
        -- this defines what colours, fonts, line widths etc the buttons are drawn with.
        --if you don't supply a "style" parameter, the buttons are drawn with Soda.style.default
        style = Soda.style.darkBlurred, --this is a style designed to complement the blurred effect
      
    }
end
--# Shapes
title = "Throw some shapes"
    
function setupUI()
    --throw some shapes
    Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
    
        blurred = true, 
        shadow = true, 

        style = Soda.style.darkBlurred, 
        --you can pass a table of arguments to the shape function, such as choosing which corners will be rounded
        --Corners are numbered 1,2,4,8 starting in bottom-left and proceeding clockwise. Defaults to 15 (all corners). Use bitwise operators to set. eg to only round the bottom corners set this to `1 | 8` (1 or 8). To round all but the top-right corner, use `~4` (not 4)
        shapeArgs = { corners = 1 | 8} --only round bottom corners
    }
end
--# Parenthood
title = "Parenthood"
    
function setupUI()
    --ok lets add some buttons to our window.
    --we need to make the window the parent of all the elements it contains
    --to do this, we need a handle to refer to it by.
    --as Soda automatically remembers all elements you create, this handle should be a local variable, not global
    --lets call our window "panel"
    local panel = Soda.Window{ --give parent a local handle, in this case "panel", to define children
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, style = Soda.style.darkBlurred, 
        shapeArgs = { corners = 1 | 8} 
    }
    
    --lets put a button in it. It's going to be one of the pre-defined buttons, a question mark.
    Soda.QueryButton{
        parent = panel, --make the Window we just defined the parent
        --this makes all coordinates relative to the parent
        --so, if we want this button to go in the top-left corner, with a 10-pixel border, we write
        x = 10, y = -10
    }
    --the advantage of making coordinates relative to the parent is that if we decide the window is too cluttered
    --we just have to resize the parent, we don't have to change the coordinates of everything within
    --it also allows elements to resize easily eg when orientation changes. Try flipping your device.
    --oh, and try pressing your button!
end
--# Callbacks
title = "Callbacks"
    
function setupUI()
    --lets make our button do something
    local panel = Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, style = Soda.style.darkBlurred, 
        shapeArgs = { corners = 1 | 8} 
    }
    
    --to do this, we use the callback parameter, and assign it a closure (a function within a function).
    --A question mark button is something you press when you want help, so we're going to make it open
    --the help file for Soda using openURL. 
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = function() openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) end
    }
    --You can use this button if you want to check anything in the documentation. Check that it works now.
end
--# Panels
title = "Panels"
    
function setupUI()
    --Our window is looking a little bare still. Lets start adding some panels.
    local panel = Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, style = Soda.style.darkBlurred, 
        shapeArgs = { corners = 1 | 8} 
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = function() openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) end
    }
    
    --this panel will eventually allow for the user to enter details about themselves, a user account. 
    --I'm calling it accountPanel.
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, -- a 10 pixel border, except at the top (to give room for the Window title and query button)
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16} --get the radius to match that of the parent window
    }
    
end
--# TextEntry
title = "Text Entry"
    
function setupUI()
    --Lets add a text entry box to our user account panel
    local panel = Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, style = Soda.style.darkBlurred, 
        shapeArgs = { corners = 1 | 8} 
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = function() openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) end
    }
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16} 
    }
    
    --our text entry box:
    Soda.TextEntry{
        parent = accountPanel, --this time, the parent is the accountPanel (so this text entry box is the grandchild of the Window)
        x = 10, y = -60, w = -10, h = 40,
        title = "User name:",
        default = "Enter name", --some default text, in this case a prompt, that the user will overwrite
    }
    
end
--# Alert
title = "Alert!"
    
function setupUI()
    --Lets make our text entry box do something, so that the user knows her input has been accepted
    local panel = Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, style = Soda.style.darkBlurred, 
        shapeArgs = { corners = 1 | 8} 
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = function() openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) end
    }
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16} 
    }
    
    --just as we did with the query button, we're going to add a callback to text entry.
    --text entry callbacks are triggered when the user hits return or the close keyboard button.
    --our callback is going to produce an alert dialog acknowledging the users input.
    --callbacks always pass the sender (ie this particular text entry box, its "self") as the first argument.
    --textentry callbacks are passed the entered text as the second argument.
    Soda.TextEntry{
        parent = accountPanel, 
        x = 10, y = -60, w = -10, h = 40,
        title = "User name:",
        default = "Enter name", 
        callback = function(self, inkey) --in this case, we're not using the "self" variable
            Soda.Alert{ --brings up an alert dialog, with a single button to dismiss it
                title = "User name registered as \n"..inkey,
                ok = "Got it", --by default, the ok button says "ok". We can override this with the ok parameter
                style = Soda.style.darkBlurred, blurred = true --add some lovely blurriness
            }
        end
    }
    
end
--# Segment
title = "Segmented Button"
    
function setupUI()
    --Lets add a second panel, and a segmented button to switch between the panels.
    --Having different panels stops our interface from getting too cluttered
    local panel = Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, style = Soda.style.darkBlurred, 
        shapeArgs = { corners = 1 | 8} 
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = function() openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) end
    }
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16} 
    }
    
    --this is a settings panel. Other than the handle, it is identical to the accountPanel   
    local settingsPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16} 
    }
    
    --now, to choose between the two panels (and stop them both appearing at once)
    --we'll add a segmented button
    Soda.Segment{
        parent = panel,
        x = 20, y = -70, w = -20, h = 40,
        text = {"Account details", "Settings"}, --the labels for each panel
        panels = {accountPanel, settingsPanel}, --the panels we just defined
        defaultNo = 2 --display the second panel by default
    }
    
    --our text entry box from the previous step:
    Soda.TextEntry{
        parent = accountPanel, 
        x = 10, y = -60, w = -10, h = 40,
        title = "User name:",
        default = "Enter name", 
        callback = function(self, inkey) 
            Soda.Alert{ 
                title = "User name registered as \n"..inkey,
                ok = "Got it", 
                style = Soda.style.darkBlurred, blurred = true 
            }
        end
    }
    --see how, when flicking back and forth between the panels, the states of the elements within those panels is retained
end