calculator = {}
function calculator.init()
    calculator.window = Soda.Window{
        title = "Calculator",
        x = -10, y = 10, w = 350, h = 450,
        close = true,
        blurred = true,
        shadow = true,
        style = {shape = {fill = color(255), stroke = color(50, 128)}, text = {fontSize = 25, fill = color(255), font = "HelveticaNeue-Light" }}-- Soda.style.darkBlurred
    }
    local s = 70
    local result = true
    
    local display = Soda.Frame{
        parent = calculator.window,
        x = 0, y = -50, w = 1, h = 120,
        label = {x = -5, y = 0}, --justify right
        title = "0",
        shape = Soda.rect, --Soda.RoundedRectangle,
        --style = Soda.style.darkIcon,
        style = {shape = {fill = color(200, 230, 255, 160)}, text = {fontSize = 40, font = "HelveticaNeue", fill = color(59, 240), textWrapWidth = 340}}
    }
    
    local history = Soda.Frame{
        parent = display,
        x = 0, y = -0.001, w = 1, h = 30,
        label = {x = -5, y = 0}, --justify right
        title = "",
        style = {shape = {}, text = {fontSize = 18, font = "HelveticaNeue", fill = color(59, 240), textWrapWidth = 340}}
    }
    
    local function onPress(sender)
        local inkey = sender.title
        if inkey:find("%d") then --number
            if display.title == "0" or result then --
                display.title = inkey --overwrite
                result = false
            else
                display.title = display.title..inkey --append
            end
            
        elseif inkey == "." then --decimal point
            if not result and display.title:find("%d$") and not display.title:find("%.%d-$") then --display cannot be a result,  and last character of display must be digit and last number must not already contain decimal
                result = false
                display.title = display.title..inkey 
            end
            
        else --operator    
             if display.title ~= "0" and display.title:find("%d$") then --last character of display must be digit
                result = false
                display.title = display.title..inkey 
            end           
        end
        display:setPosition() --recalculate justify right
    end
    
    local buttonStyle1 = {shape = {noFill = true, stroke = color(160,128)}, text = {fontSize = 30, fill = color(255), font = "HelveticaNeue"}}
    local buttonStyle2 = {shape = {fill = color(255, 180, 0, 200)}, text = buttonStyle1.text}
    local buttonStyle3 = {shape = {fill = color(255), stroke = color(128)}, text = {fontSize = 25, 
    fill = color(0, 49, 255, 255), font = "HelveticaNeue-Light"}}
    Soda.Button{
        parent = calculator.window,
        w = s*2, h = s,
        x = 0, y = 0,
        title = "0",
        style = buttonStyle1,
        shapeArgs = {radius = 25, corners = 1},
        callback = onPress
    }
    
    Soda.Button{
        parent = calculator.window,
        w = s, h = s,
        x = s*2, y = 0,
        title = ".",
        style = buttonStyle1,
        shapeArgs = {corners = 0},
        callback = onPress
    }
 
    for n = 0,8 do       
        Soda.Button{
            parent = calculator.window,
            w = s, h = s,
            x = s * (n%3), y = s * (1 + n//3),
            title = tostring(n+1),
            style = buttonStyle1,
            shapeArgs = {corners = 0},
           -- shape = Soda.rect,
            callback = onPress
        }
    end
    local buttons = {"\u{00F7}", "\u{00D7}", "-", "+"}
    
    for n = 0,3 do
        Soda.Button{
            parent = calculator.window,
            w = s, h = s,
            x = s * 3, y = s * n,
            title = buttons[n+1],
            style = buttonStyle2, --Soda.style.darkIcon,
            shapeArgs = {corners = 0},
            callback = onPress
        }        
    end
    
    --backspace
    Soda.Button{
        parent = calculator.window,
        w = s, h = s,
        x = s * 4, y = s * 3,
        title = "\u{232B}",
         style = buttonStyle3,
        shapeArgs = {corners = 0},
        callback = function() 
            if display.title:find("[\u{00F7}\u{00D7}]$") then
                display.title = display.title:gsub("\u{00F7}$", ""):gsub("\u{00D7}$", "") --delete multibyte unicode character
            else
                display.title = display.title:sub(1,-2) 
            end
            if display.title == "" then display.title = "0" end
            display:setPosition() --recalculate justify right
        end
    }  
    
    Soda.Button{
        parent = calculator.window,
        w = s, h = s,
        x = s * 4, y = s * 2,
        title = "AC",
        shapeArgs = {corners = 0},
        style = buttonStyle3,
        callback = function() 
            display.title = "0" 
            display:setPosition() --recalculate justify right
        end
    }  
    
    Soda.Button{
        parent = calculator.window,
        w = s, h = s * 2,
        x = s * 4, y = 0,
        title = "=",
        style = buttonStyle2,
        shapeArgs = {radius = 25, corners = 8},
        callback = function()
            if display.title:find("%d$") then --string must end with a digit
                history.title = display.title.."="
                history:setPosition()
                local out = loadstring("return "..display.title:gsub("\u{00D7}", "*"):gsub("\u{00F7}", "/"))() --substitute multiply and divide signs
                if out%1 == 0 then out = math.tointeger(out) end --lop off trailing .0
                display.title = tostring(out)
                display:setPosition() --recalculate justify right
                result = true --ie, next press will replace this output
            end
        end
    }  
end
    
function demo1()
    --[[
    You only need to give an element a temporary handle (a local variable name) if it is the parent of other elements, or you need to refer to it in a callback
    
    To define an element as a child of another, just add "parent = parentName" to its constructor
    
    x,y,w,h of elements are defined relative to their parents, according to 3 rules:
    
    1. if x,y,w, or h are positive integers, they behave as normal coordinates in rectMode CORNER (ie pixels from the origin)
    
    2. if x,y,w,or h are floating point between 0 and 1, they describe proportions in CENTER mode (x,y 0.5 is centred)
    
    3. if x,y,w, or h are negative, they describe distance in pixels from the TOP or RIGHT edge, as in CORNERS mode (ie, w,h become x2,y2 rather than width and height). if x and y are negative, they also behave the same way as w,h, describing the distance between the TOP/RIGHT edge of the parent, and the TOP/RIGHT edge of the child.
    
    the above 3 rules can be mixed together in one definition. eg a button fixed to the bottom right corner of its parent with a 20 pixel border, with a variable width of a quarter of its parent's width, and a fixed height of 40 pixels, would be: x = -20, y = 20, w = 0.25, h = 40.
    
    4. How do you fix an element to the top or right edge (or, how do you write -0)? Use -0.001
      ]]
    
    --the main panel
    
    local panel = Soda.Window{ --give parent a local handle, in this case "panel", to define children
        title = "Demonstration", 
        hidden = true, --not visible or active initially
        x=0.4, y=0.5, w=0, h=0.7, 
        blurred = true, style = Soda.style.darkBlurred, --gaussian blurs what is underneath it
        shadow = true,
        shapeArgs = { corners = 1 | 2} --only round left-hand corners
    }
    
    --A menu button to show & hide the main panel
    
    local menu = Soda.MenuToggle{x = -20, y = -20, --a button to activate the above panel
    callback = function() panel:show(RIGHT) end,
    callbackOff = function() panel:hide(RIGHT) end,
    }
    
    Soda.QueryButton{ --a button to open the help readme
        parent = panel,
        x = 10, y = -10,
        callback = function() openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) end
    }
    
    --three panels to hold various elements, and a segemented button to determine which panel is displayed.
    
    local buttonPanel = Soda.Frame{
        parent = panel,
        x = 20, y = 20, w = -20, h = -140, --20 pixel border on left, right, bottom
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
    }
    
    local textEntryPanel = Soda.Frame{
        parent = panel,
        x = 20, y = 20, w = -20, h = -140,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,     
    }
    
    local list = Soda.List{ --a vertically scrolling list of items
        parent = panel, 
        x = 20, y = 20, w = -20, h = -140,
        text = listProjectTabs(), -- text of list items taken from current project tabs
        callback = function (self, selected, txt) Soda.TextWindow{title = txt, textBody = readProjectTab(txt), shadow = true, close = true, style = Soda.style.thickStroke, shapeArgs = {radius = 25}} end --a window for scrolling through large blocks of text
    }
    
    --a segmented button to choose between the above 3 panels:
    
    Soda.Segment{
        parent = panel,
        x = 20, y = -80, w = -20, h = 40,
        text = {"Buttons", "Text Entry", "Examine Source"}, --segment labels...
        panels = { --...and their corresponding panels
        buttonPanel, textEntryPanel, list
        }
    }
    
    --a panel for displaying profiling stats (activated by a switch in the button panel)
    
    local stats = Soda.Window{
        hidden = true,
        x = 0, y = -0.001, w = 200, h = 120,
        title = "Profiler\n\n\n", --will be overridden
      --  shapeArgs = {corners = 8},
        blurred = true, shadow = true,
        update = function(self) --update will be called every frame
            self.title = string.format("Profiler\n\nFPS: %.2f\nMem: %.2f", profiler.fps, profiler.mem)
        end
    }
    
    --the textEntry panel
    
    Soda.TextEntry{ --text entry box
        parent = textEntryPanel,
        x = 10, y = -70, w = -10, h = 40,
        title = "Nick-name:",
        default = "Ice Man",
        callback = function(self, inkey)
            Soda.Alert{
                title = inkey.."?!?\n\nWas that really your nickname?",
               style = Soda.style.darkBlurred, blurred = true,
            }
        end
    }    
    
    Soda.TextEntry{
        parent = textEntryPanel,
        x = 10, y = -130, w = -10, h = 40,
        title = "Name of 1st pet:",
        default = "Percival",
        callback = function(self, inkey)
            Soda.Alert{
              title = inkey.."!\n\u{1f63b}\u{1f436}\u{1f430}\n\nAwwww. Cute name.",
               style = Soda.style.darkBlurred, blurred = true,
            }
        end
    }
    
    Soda.DropdownList{ --a dropdown list button
        parent = textEntryPanel,
        x = 10, y = -10, w = -10, h = 40,    
        title = "County",
        text = {"London", "Bedfordshire", "Buckinghamshire", "Cambridgeshire", "Cheshire", "Cornwall and Isles of Scilly", "Cumbria", "Derbyshire", "Devon", "Dorset", "Durham", "East Sussex", "Essex", "Gloucestershire", "Greater London", "Greater Manchester", "Hampshire", "Hertfordshire", "Kent", "Lancashire", "Leicestershire", "Lincolnshire", "Merseyside", "Norfolk", "North Yorkshire", "Northamptonshire", "Northumberland", "Nottinghamshire", "Oxfordshire", "Shropshire", "Somerset", "South Yorkshire", "Staffordshire", "Suffolk", "Surrey", "Tyne and Wear", "Warwickshire", "West Midlands", "West Sussex", "West Yorkshire", "Wiltshire", "Worcestershire", "Flintshire", "Glamorgan", "Merionethshire", "Monmouthshire", "Montgomeryshire", "Pembrokeshire", "Radnorshire", "Anglesey", "Breconshire", "Caernarvonshire", "Cardiganshire", "Carmarthenshire", "Denbighshire", "Kirkcudbrightshire", "Lanarkshire", "Midlothian", "Moray", "Nairnshire", "Orkney", "Peebleshire", "Perthshire", "Renfrewshire", "Ross & Cromarty", "Roxburghshire", "Selkirkshire", "Shetland", "Stirlingshire", "Sutherland", "West Lothian", "Wigtownshire", "Aberdeenshire", "Angus", "Argyll", "Ayrshire", "Banffshire", "Berwickshire", "Bute", "Caithness", "Clackmannanshire", "Dumfriesshire", "Dumbartonshire", "East Lothian", "Fife", "Inverness", "Kincardineshire", "Kinross-shire"},    
    }
    
    --the button panel:
    
    local div = 1/8
    
    Soda.BackButton{
    parent = buttonPanel,
    x = div, y = -20}
    
    Soda.SettingsButton{
    parent = buttonPanel,
    x = div * 2, y = -20}
    
    Soda.AddButton{
    parent = buttonPanel,
    x = div * 3, y = -20}
    
    Soda.QueryButton{
    parent = buttonPanel,
    x = div * 4, y = -20}
    
    Soda.MenuButton{
    parent = buttonPanel,
    x = div * 5, y = -20}
    
    Soda.DropdownButton{
    parent = buttonPanel,
    x = div * 6, y = -20}
    
    Soda.CloseButton{
    parent = buttonPanel,
    x = div * 7, y = -20
    }
    
    Soda.Switch{ --a switch to toggle the profiler stats panel
        parent = buttonPanel,
        x = 20, y = -80,
        title = "Show profiler",
        callback = function() stats:show(LEFT) end,
        callbackOff = function() stats:hide(LEFT) end
    }
    
    Soda.Switch{
        parent = buttonPanel,
        x = 20, y = -140,
        title = "Wings stay on the plane",
        on = true
    }
    
    Soda.Switch{
        parent = buttonPanel,
        x = 20, y = -200,
        title = "Afterburners",
    }
       
    Soda.Button{
        parent = buttonPanel, 
        title = "OK", 
        x = 20, y = 20, w = 0.4, h = 40,
        callback = function() 
          --  panel:hide(RIGHT) 
         --   menu:unHighlight()
            menu:switchOff()
        end
    }
    
    Soda.Button{
    parent = buttonPanel, 
    title = "Do not press", 
    style = Soda.style.warning, 
    x = -20, y = 20, w = 0.4, h = 40, 
    callback = 
        function()
            Soda.Alert{ --an alert box with a single button
                title = "CONGRATULATIONS!\n\nYou held out "..string.format("%.2f", ElapsedTime).." seconds before\n succumbing to the irresistable\nallure of a big red button saying\n‘do not press’", 
                ok = "Here, have a medal",
                y=0.6, h = 0.3,
        
                style = Soda.style.darkBlurred, blurred = true, 
            }
        end
    }
    
end

function demo2()
     local t = ElapsedTime
    local box = --create a temporary handle "box" so that we can define other buttons as children
    Soda.Window{title = "Settings", w = 0.6, h = 0.6, blurred = true, style = Soda.style.darkBlurred} --
     --320
      --  instruction = Label(instruction, x+20, y+160, 640, 120),
     --   field = TextField(textfield, x+20, y+80, 640.0, 40, default, 1, test_Clicked),
    local menu = Soda.MenuButton{parent = box, x = 20, y= - 20, callback = function ()
        
    end}
      local   ok = Soda.Button{parent = box, title = "OK", x = 20, y = 20, w = 0.3, h = 40}
    
      local  warning = Soda.Button{parent = box, title = "Do not press", style = Soda.style.warning, x = -20, y = 20, w = 0.3, h = 40, callback = 
        function()
            Soda.Alert{title = "CONGRATULATIONS!\n\nYou held out\n"..(ElapsedTime - t).." seconds", y=0.6, style = Soda.style.darkBlurred, blurred = true, alert = true}
        end} --blurred = true, alert = true,
    
    local  choose = Soda.Segment{parent = box, text = {"Several","options", "to choose", "between"}, x=0.5, y=-60, w=0.9, h = 40} --"options", 
    
    local   switch = Soda.Switch{parent = box, title = "Wings fall off", x = 20, y = -120}
    
  local list = Soda.List{parent = box, x = -20, y = -120, w = 0.4, h=0.5, text = {"Washington", "Adams", "Jefferson", "Madison", "Monroe", "Adams", "Jackson", "Van Buren", "Harrison", "Tyler", "Polk", "Taylor", "Fillmore", "Pierce", "Buchanan", "Lincoln", "Johnson", "Grant"} }
    
    local inkey = Soda.TextEntry{parent = box, title = "Nick-name:", x=20, y=80, w=0.7, h=40} 
end

