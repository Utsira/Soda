--# Demo
calculator = {}
function calculator.init()
    calculator.window = Soda.Window{
        title = "Calculator",
        x = -10, y = 10, w = 350, h = 450,
        close = true,
        blurred = true,
        shadow = true,
        hidden = true,
        doNotKill = true,
        draggable = true
      --  style = {shape = {fill = color(255), stroke = color(50, 128)}, text = {fontSize = 1.25, fill = color(255), font = "HelveticaNeue-Light" }}-- Soda.style.darkBlurred
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
        style = {shape = {fill = color(200, 230, 255, 160)}, text = {fontSize = 2, font = "HelveticaNeue", fill = color(59, 240), textWrapWidth = 340, textAlign = RIGHT}}
    }
    
    local history = Soda.Frame{
        parent = display,
        x = 0, y = -0.001, w = 1, h = 30,
        label = {x = -5, y = 0}, --justify right
        title = "",
        style = {shape = {}, text = {fontSize = 0.9, font = "HelveticaNeue", fill = color(59, 240), textWrapWidth = 340}}
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
    
    local buttonStyle1 = {shape = {noFill = true, stroke = color(160,128)}, text = {fontSize = 1.5, fill = color(255), font = "HelveticaNeue"}}
    local buttonStyle2 = {
        shape = {fill = color(255, 180, 0, 200)}, 
        text = {fill = "white", fontSize = 1.5}, 
        highlight = {
            shape = {fill = "white", stroke = color(255, 180, 0)}, 
            text = {fill = color(255, 180, 0), fontSize = 1.5}
        }
    }
    local buttonStyle3 = {shape = {fill = color(255), stroke = color(128)}, text = {fontSize = 1.25, 
    fill = color(0, 49, 255, 255), font = "HelveticaNeue-Light"}}

    Soda.Button{
        parent = calculator.window,
        w = s*2, h = s,
        x = 0, y = 0,
        title = "0",
        -- style = buttonStyle1,
        subStyle = {"icon"},
        shapeArgs = {radius = 25, corners = 1},
        callback = onPress
    }
    
    Soda.Button{
        parent = calculator.window,
        w = s, h = s,
        x = s*2, y = 0,
        title = ".",
        -- style = buttonStyle1,
        subStyle = {"icon"},
        shapeArgs = {corners = 0},
        callback = onPress
    }
 
    for n = 0,8 do       
        Soda.Button{
            parent = calculator.window,
            w = s, h = s,
            x = s * (n%3), y = s * (1 + n//3),
            title = tostring(n+1),
         --   style = buttonStyle1,
            subStyle = {"icon"},
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
       --  style = buttonStyle3,
       -- subStyle = {"icon", "button"},
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
      --  style = buttonStyle3,
       -- subStyle = {"icon", "button"},
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
        blurred = true, --style = Soda.style.darkBlurred, --gaussian blurs what is underneath it
        shadow = true,
        shapeArgs = { corners = 1 | 2} --only round left-hand corners
    }

    --A menu button to show & hide the main panel
    
    local menu = Soda.MenuToggle{x = -20, y = -20, subStyle = {"darkIcon"}, --a button to activate the above panel
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
        shape = Soda.RoundedRectangle, --style = Soda.style.translucent,
        subStyle = {"translucent"}, --
    }
    
    local textEntryPanel = Soda.Frame{
        parent = panel,
        x = 20, y = 20, w = -20, h = -140,
        shape = Soda.RoundedRectangle, subStyle = {"translucent"}, --style = Soda.style.translucent,     
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
             --  style = Soda.style.darkBlurred, 
                blurred = true,
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
             --  style = Soda.style.darkBlurred, 
                blurred = true,
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
    subStyle = {"warning"}, --style = Soda.style.warning, 
    x = -20, y = 20, w = 0.4, h = 40, 
    callback = 
        function()
            Soda.Alert{ --an alert box with a single button
                title = "CONGRATULATIONS!\n\nYou held out "..string.format("%.2f", ElapsedTime).." seconds before\n succumbing to the irresistable\nallure of a big red button saying\n‘do not press’", 
                ok = "Here, have a medal",
                y=0.6, h = 0.3,
        
                --style = Soda.style.darkBlurred, 
                blurred = true, 
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
    
      local  warning = Soda.Button{parent = box, title = "Do not press", subStyle = {"warning"}, --style = Soda.style.warning, x = -20, y = 20, w = 0.3, h = 40, callback = 
        function()
            Soda.Alert{title = "CONGRATULATIONS!\n\nYou held out\n"..(ElapsedTime - t).." seconds", y=0.6, style = Soda.style.darkBlurred, blurred = true, alert = true}
        end} --blurred = true, alert = true,
    
    local  choose = Soda.Segment{parent = box, text = {"Several","options", "to choose", "between"}, x=0.5, y=-60, w=0.9, h = 40} --"options", 
    
    local   switch = Soda.Switch{parent = box, title = "Wings fall off", x = 20, y = -120}
    
  local list = Soda.List{parent = box, x = -20, y = -120, w = 0.4, h=0.5, text = {"Washington", "Adams", "Jefferson", "Madison", "Monroe", "Adams", "Jackson", "Van Buren", "Harrison", "Tyler", "Polk", "Taylor", "Fillmore", "Pierce", "Buchanan", "Lincoln", "Johnson", "Grant"} }
    
    local inkey = Soda.TextEntry{parent = box, title = "Nick-name:", x=20, y=80, w=0.7, h=40} 
end






--# Overview
function overview(t)
    local win =Soda.Window{
        title = "Soda v"..Soda.version.." Overview",
        w = 0.97, h = 0.7,
         blurred = true, 
        shadow = true, 
      --  style = Soda.style.darkBlurred, 
    }
    
    local aboutPanel = Soda.Frame{
        parent = win,
        x = 10, y = 10, w = -10, h = -110, 
    }
    
    local about = Soda.Frame{
        parent = aboutPanel,
        x = 0, y = -0.001, w = 1, h = 0.7,
        shape = Soda.RoundedRectangle, --style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16},
        title = "About Soda",
         label = { x = 0.5, y = 0.5},
        title = 
    [[Soda is a library for producing graphic user interfaces like 
    the one you are looking at now.
    
    Press the segment buttons above to see the interface elements Soda produces.   
    ]]..(t.content or "")
    }
    
    Soda.Button{
        parent = about, 
        x = 10, y = 10, h = 40,
        title = "Online Documentation",
        callback = function() openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) end
    }
   
    if t.ok then 
    Soda.Button{
        parent = about,
        x = -10, y = 10, h = 40,
      --  shapeArgs = {radius = 16},
          subStyle = {"warning"}, --style = Soda.style.warning,
        title = t.ok,
        callback = t.callback
    }
    end
    
    local demo = Soda.Frame{
        parent = aboutPanel,
        x = 0, y = 0, w = 1, h = 0.29,
        shape = Soda.RoundedRectangle, --style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16},
        title = "Demos",        
    }
    
    Soda.Button{
        parent = demo,
        x = 0.3, y = 0.4, w = 250, h = 40,
        title = "Calculator",
        callback = function() calculator.window:show(RIGHT) end
    }
    
    local buttonPanel = Soda.Frame{
        parent = win,
        x = 10, y = 10, w = -10, h = -110,
       -- shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        --shapeArgs = {radius = 16}
    }
           
    local switchPanel = Soda.Frame{
        parent = win,
        x = 10, y = 10, w = -10, h = -110,
      --  shape = Soda.RoundedRectangle, style = Soda.style.translucent,
      --  shapeArgs = {radius = 16}
    }
    
    local sliderPanel = Soda.Frame{
        parent = win,
        title = "Sliders. At slow slide speeds movement becomes more fine-grained",
        x = 10, y = 10, w = -10, h = -110,
        shape = Soda.RoundedRectangle, -- style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}
    }
    
    local dialogPanel = Soda.Frame{
        parent = win,
        x = 10, y = 10, w = -10, h = -110,
       -- shape = Soda.RoundedRectangle, style = Soda.style.translucent,
      --  shapeArgs = {radius = 16}
    }
    
    local textEntryPanel = Soda.Frame{
        parent = win,
        title = "Text Entry fields with a draggable cursor",
        x = 10, y = -110, w = -10, h = 0.6,
        shape = Soda.RoundedRectangle, -- style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}
    }
    
    local listPanel = Soda.Frame{
        parent = win,
        title = "Vertically scrolling lists are another way of selecting one choice from many",
        x = 10, y = 10, w = -10, h = -110,
        shape = Soda.RoundedRectangle, -- style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}
    }
    
    scrollPanel = Soda.TextScroll{
        parent = win,
        title = "Text Scrolls for scrolling through large bodies of text",
    
        textBody = string.rep([[
    
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus vitae massa in sem mattis ullamcorper a eget metus. Nam ac maximus nulla, vel faucibus sapien. Aenean faucibus volutpat tristique. Curabitur condimentum volutpat velit, sit amet commodo tellus placerat a. 
    
    Sed vitae metus quis mauris congue tincidunt vel sit amet lorem. Mauris lectus lorem, facilisis in dapibus et, congue quis nunc. Fusce convallis mi urna, vitae mattis felis sodales et. Aliquam et fringilla purus, eu vehicula diam. Sed facilisis mauris vitae augue sodales aliquam. In ultrices metus ut eleifend condimentum. Praesent venenatis rhoncus felis, eget vehicula orci ornare non. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vivamus eget vulputate mauris. Pellentesque id tempus sapien.
    ]], 100),
        x = 10, y = 10, w = -10, h = -110,
        shape = Soda.RoundedRectangle, --style = Soda.style.default,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}    
    }
    
    Soda.Segment{
        parent = win,
        x = 12, y = -60, w = -12, h = 40,
        text = {"About", "Buttons", "Switches", "Sliders", "Dialogs", "Text Entry", "Lists", "Scrolls"}, 
        panels = {aboutPanel, buttonPanel, switchPanel, sliderPanel, dialogPanel, textEntryPanel, listPanel, scrollPanel}, 
    }
    
    --button panel!
    
    local buttonPresets = Soda.Frame{
        parent = buttonPanel,
        title = "Presets for frequently-used buttons",
        x = 0, y = 0.5, w = 1, h = 0.32,
          shape = Soda.RoundedRectangle, --style = Soda.style.translucent,
        subStyle = {"translucent"},
          shapeArgs = {radius = 16}
    }
    
    local div = 1/9
    local div2 = div/2
    
    Soda.BackButton{
    parent = buttonPresets,
    subStyle = {"darkIcon"},
    x = div2, y = 0.4}
    
    Soda.ForwardButton{
    parent = buttonPresets,
    subStyle = {"darkIcon"},
    x = div2 + div, y = 0.4}
    
    Soda.SettingsButton{
    parent = buttonPresets,
    subStyle = {"darkIcon"},
    x = div2 + div * 2, y = 0.4}
    
    Soda.AddButton{
    parent = buttonPresets,
    subStyle = {"icon"},
    x = div2 + div * 3, y = 0.4}
    
    Soda.QueryButton{
    parent = buttonPresets,
    subStyle = {"icon"},
    x = div2 + div * 4, y = 0.4}
    
    Soda.MenuButton{
    parent = buttonPresets,
    subStyle = {"icon"},
    x = div2 + div * 5, y = 0.4}
    
    Soda.DropdownButton{
    parent = buttonPresets,
    x = div2 + div * 6, y = 0.4}
    
    Soda.CloseButton{
    parent = buttonPresets,
    x = div2 + div * 7, y = 0.4
    }
    
    Soda.DeleteButton{
    parent = buttonPresets,
    x = div2 + div * 8, y = 0.4
    }
    
    local textButtons = Soda.Frame{
        parent = buttonPanel,
        title = "Text and symbol based buttons in various shapes and styles",
        x = 0, y = -0.001, w = 1, h = 0.32,
        shape = Soda.RoundedRectangle, --style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}
    }
    
    div = 1/5
    div2 = div/2
    local w = div -0.01
    
    Soda.Button{
        parent = textButtons, 
        title = "Standard", 
        x = div2, y = 0.4, w = w, h = 40,
    }
    
    --[[
    Soda.Button{
        parent = textButtons, 
        title = "Dark", 
        --style = Soda.style.dark,
        subStyle = {"listItem"},
        x = div2 + div, y = 0.4, w = w, h = 40,
    }
      ]]
    
    Soda.Button{
        parent = textButtons, 
        title = "Warning", 
        subStyle = {"warning"}, --style = Soda.style.warning, 
        x = div2 + div , y = 0.4, w = w, h = 40, 
    }
    
    Soda.Button{
        parent = textButtons, 
        title = "Square", 
        shape = Soda.rect,
        x = div2 + div * 2, y = 0.4, w = w, h = 40,
    }
    
    Soda.Button{
        parent = textButtons, 
        title = "Lozenge", 
        shapeArgs = {radius = 20},
        x = div2 + div * 3, y = 0.4, w = w, h = 40,
    }
    
    local div3 = div/5
    local base = div2 + div * 4
    
    Soda.Button{
        parent = textButtons, 
        title = "\u{1f310}", 
       -- style = Soda.style.darkIcon,
        subStyle = {"listItem"},
        shape = Soda.ellipse,
        x = base - div3, y = 0.4, w = 40, h = 40,
    }
    
    --[[
    Soda.Button{
        parent = textButtons, 
        title = "\u{267b}", 
     --   shape = Soda.ellipse,
     --   style = Soda.style.icon,
        x = base, y = 0.4, w = 40, h = 40,
    }
      ]]
    
    Soda.Button{
        parent = textButtons, 
        title = "\u{1f374}", 
      --  shape = Soda.ellipse,
       -- style = Soda.style.darkIcon,
        subStyle = {"listItem"},
        x = base + div3, y = 0.4, w = 40, h = 40,
    }
    
    local segmentPanel = Soda.Frame{
        parent = buttonPanel,
        title = "Segmented buttons for selecting one option from many",
        x = 0, y = 0, w = 1, h = 0.32,
        shape = Soda.RoundedRectangle,-- style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}
    }
    
    Soda.Segment{
        parent = segmentPanel, 
        x = 20, y = 0.4, w = -20, h = 40,
        text = {"Only one", "segmented", "button can", "be selected", "at a time"}
    }
    
    --switch panel
    
    local switches = Soda.Frame{
        parent = switchPanel,
        title = "iOS-style switches",
        x = 0, y = -10, w = 0.49, h = 0.75,
        shape = Soda.RoundedRectangle,-- style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}
    }
    
    Soda.Switch{ --a switch to toggle the profiler stats panel
        parent = switches,
        x = 20, y = 0.75,
        title = "Use switches to toggle",

    }
    
    Soda.Switch{
        parent = switches,
        x = 20, y = 0.5,
        title = "...between two states",
        on = true
    }
    
    Soda.Switch{
        parent = switches,
        x = 20, y = 0.25,
        title = "...on and off",
    }
    
    local toggles = Soda.Frame{
        parent = switchPanel,
        title = "Text and preset-based toggles",
        x = -0.001, y = -10, w = 0.49, h = 0.75,
        shape = Soda.RoundedRectangle,-- style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}
    }
    
    Soda.Toggle{
        parent = toggles,
        x = 20, y = 0.8, w = -20, h = 40,
        title = "Standard" 
    }
    
    Soda.Toggle{
        parent = toggles,
        x = 20, y = 0.6, w = -20, h = 40,
        shape = Soda.rect,
        title = "Square" 
    }
    
    Soda.Toggle{
        parent = toggles,
        x = 20, y = 0.4, w = -20, h = 40,
        shapeArgs = {radius = 20},
        title = "Over-rounded" 
    }
    
    Soda.MenuToggle{
        parent = toggles,
        x = 20, y = 0.2,
        on = true,
    }
    
    --[[
    local sliders = Soda.Frame{
        parent = switchPanel,
        title = "Sliders",
        x = 0.5, y = 0, w = 0.49, h = 0.32,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
        shapeArgs = {radius = 16}
    }
      ]]
    
    --slider panel 
    
    Soda.Slider{
        parent = sliderPanel,
        title = "Integer slider",
        x = 0.5, y = 0.8, w = 300,
        min = 1000, max = 2000, start = 1500,
    }
    
    Soda.Slider{
        parent = sliderPanel,
        title = "Floating point slider (3 decimal places)",
        x = 0.5, y = 0.6, w = 400,
        min = -10, max = 10, start = 0,
        decimalPlaces = 3
    }
    
    Soda.Slider{
        parent = sliderPanel,
        title = "Slider with snap points",
        x = 0.5, y = 0.4, w = 500,
        min = -50, max = 150,
        decimalPlaces = 1,
        snapPoints = {0, 100}
    }
    
    Soda.Slider{
        parent = sliderPanel,
        title = "Make fine +/- adjustments by tapping either side of the lever",
        x = 0.5, y = 0.2, w = 0.9,
        min = -10000, max = 10000, start = 0,
        snapPoints = {0}
    }
    
    --dialog panel!
    
    local regularAlert = Soda.Frame{
        parent = dialogPanel,
        title = "Press the buttons to trigger alerts in the default style",
        x = 0, y = -0.001, w = 1, h = 0.32,
        shape = Soda.RoundedRectangle, --style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}
    }
    
    Soda.Button{
        parent = regularAlert, 
        title = "Proceed dialog", 
        x = 10, y = 0.4, w = 0.4, h = 40,
        callback = function() 
            Soda.Alert2{
                title = "Alert",
                content = "A 2-button\nProceed or cancel dialog",
            }
        end
    }
    
    Soda.Button{
    parent = regularAlert, 
    title = "Alert", 
    subStyle = {"warning"}, --style = Soda.style.warning, 
    x = -10, y = 0.4, w = 0.4, h = 40, 
    callback = 
        function()
            Soda.Alert{ --an alert box with a single button
                title = "Alert",
                content = "A one-button\nalert", 
                y=0.6, h = 0.3,
            }
        end
    }
    
    local blurAlert = Soda.Frame{
        parent = dialogPanel,
        title = "Press the buttons to trigger alerts with dark, blurred panels",
        x = 0, y = 0.5, w = 1, h = 0.32,
        shape = Soda.RoundedRectangle, --style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}
    }
    
    Soda.Button{
        parent = blurAlert, 
        title = "Proceed dialog (blurred)", 
        x = 10, y = 0.4, w = 0.4, h = 40,
        callback = function() 
            Soda.Alert2{
                title = "Alert",
                content = "A 2-button\nProceed or cancel dialog",
              --  style = Soda.style.darkBlurred, 
                blurred = true, 
            }
        end
    }
    
    Soda.Button{
    parent = blurAlert, 
    title = "Alert (blurred)", 
    subStyle = {"warning"}, --style = Soda.style.warning, 
    x = -10, y = 0.4, w = 0.4, h = 40, 
    callback = 
        function()
            Soda.Alert{ --an alert box with a single button
                title = "Alert",
                content = "A one-button\nalert", 
                y=0.6, h = 0.3,
             --   style = Soda.style.darkBlurred, 
                blurred = true, 
            }
        end
    }
    
    --window panel
    local windowPresets = Soda.Frame{
        parent = dialogPanel,
        title = "Press the buttons to see the window presets",
        x = 0, y = 0, w = 1, h = 0.32,
        shape = Soda.RoundedRectangle, --style = Soda.style.translucent,
        subStyle = {"translucent"},
        shapeArgs = {radius = 16}
    }
    
    Soda.Button{
        parent = windowPresets, 
        title = "Window", 
        x = 10, y = 0.4, w = 0.4, h = 40,
        callback = function() 
            Soda.Window{
                title = "Window",
                content = "A regular window with optional ok, cancel, and close buttons and optional drop-shadow",
                ok = true, cancel = true, close = true, shadow = true
            }
        end
    }
    
    Soda.Button{
        parent = windowPresets, 
        title = "Blurred Window", 
        x = -10, y = 0.4, w = 0.4, h = 40,
        callback = function() 
            Soda.Window{
                title = "Blurred Window",
                content = "A blurred window with ok, cancel, and close buttons",
                blurred = true,
                ok = true, cancel = true, close = true
            }
        end
    }
    --text entry panel
    
    Soda.TextEntry{ --text entry box
        parent = textEntryPanel,
        x = 10, y = -50, w = -10, h = 40,
        title = "Text Entry:",
        default = "Tap here to start editing this text",
    }    
    
    Soda.TextEntry{
        parent = textEntryPanel,
        x = 10, y = 0.45, w = -10, h = 40,
        title = "Text Entry:",
        default = "Double-tap a word to select it and open the selection menu"
    }
    
    Soda.TextEntry{
        parent = textEntryPanel,
        x = 10, y = 10, w = -10, h = 40,
        title = "Text Entry:",
        default = "Scroll the text left and right by pulling the cursor over to either end of the box and holding your finger there. Also, note that the interface scrolls up if the text entry box is below the height of the keyboard."
    }
    
    --list panel
    
    Soda.List{
        parent = listPanel,
        x = 10, y = 10, h = -50, w = 0.45,
        text = {"Lists", "allow", "the", "user", "to", "select", "one", "option", "from", "a", "vertically", "scrolling", "list."}
    }
    
    Soda.DropdownList{
        parent = listPanel,
        x = -10, y = -110, w = 0.45, h = 40,
        title = "A numbered list",
        enumerate = true,
        text = {"Lists", "and", "dropdown lists", "can", "be", "automatically", "enumerated", "if", "you", "wish"}
    }
      
    Soda.DropdownList{
        parent = listPanel,
        x = -10, y = -50, w = 0.45, h = 40,
        title = "A dropdown list",
        text = {"Dropdown", "lists", "are", "lists", "that", "dropdown", "from", "a", "button.", "Note", "that", "the", "button", "reports", "the", "selection", "made"}
    }
    calculator.init()
end


--# Soda
Soda = {}
Soda.version = "0.6"
SodaIsInstalled = true
Soda.items = {} --holds all top-level ui elements (i.e. anything without a parent)

function Soda.setup()
    Soda.Assets()
    Soda.baseFontSize = 20
    Soda.theme = Soda.themes.default
    textAlign(CENTER)
    rectMode(CENTER)
end

function Soda.Assets()
    Soda.darken.assets() --used to darken underlying interface elements when alert flag is set.
    Soda.UIoffset = 0 --used to scroll up screen when keyboard appears
end

Soda.darken = {}

function Soda.darken.assets()
    Soda.darken.m = mesh()
    local s = math.max(WIDTH, HEIGHT)
    Soda.darken.m:addRect(s/2, s/2, s, s)
    Soda.darken.m:setColors(color(0,128))
end

function Soda.darken.draw()
    pushMatrix()
    resetMatrix()
    Soda.darken.m:draw()
    popMatrix()
end

function Soda.camera()
    if not isKeyboardShowing() then
        Soda.UIoffset = Soda.UIoffset * 0.9
    elseif not Soda.focus.usesKeyboard then --check whether a keyboard-using element has lost focus
        --so that touching another element will end textentry
        hideKeyboard()
    end
    translate(0, Soda.UIoffset)
end

function Soda.draw(breakPoint)
    Soda.setStyle(Soda.style.default.text)
    for i,v in ipairs(Soda.items) do --draw most recent item last
        if v.kill then
            table.remove(Soda.items, i)
        else
            if v:draw(breakPoint) then return end
        end
    end
end

function Soda.touched(t)
    local tpos = vec2(t.x, t.y-Soda.UIoffset)
    for i = #Soda.items, 1, -1 do --test most recent item first
        local v = Soda.items[i] 
        if v:touched(t, tpos) then return end
    end
end

function Soda.keyboard(key)
    if Soda.keyboardEntity then
        Soda.keyboardEntity:keyboard(key)
    end
end

function Soda.orientationChanged()
    for i,v in ipairs(Soda.items) do
        v:orientationChanged()
    end
    collectgarbage()
end

--assume everything is rectMode centre (cos of mesh rect)
function Soda.parseCoord(v, len, edge)
    local half = len * 0.5
    if v==0 or v>1 then return v + half end --standard coordinate
    if v<0 then return edge - half + v end --eg WIDTH - 40
    return edge * v  --proportional
end

function Soda.parseCoordSize(loc, size, edge)
    local pos, len
    if size>1 then
        len = size --standard length coord
    elseif size>0 then
        len = math.ceil(edge * size) --proportional length
    end --nb defer if size is negative
    if len then
        local half = len * 0.5
        if loc%1==0 and loc>=0 then
            pos = loc + half --standard coord
        elseif loc<0 then
            pos = edge - half + loc --negative coord
        else
            pos = math.ceil(edge * loc) --proportional coord
        end
    else --negative size
        if loc%1==0 and loc>=0 then 
            len = edge - loc + size --loc and size describing the two edges
            pos = loc + len * 0.5
        elseif loc>0 then  --proportional loc coord
            local x2 = edge + size
            local x1 = math.ceil(edge * loc)
            len = x2 - x1
            pos = x1 + len * 0.5
          --  pos = edge * loc 
            
            --len = (x2 - pos) * 2
        else --both negative
            local x2 = edge + size
            local x1 = edge + loc
            len = x2 - x1
            pos = x1 + len * 0.5
        end
    end
    return pos, len
end

function null() end

function smoothstep(t,a,b)
    local a,b = a or 0,b or 1
    local t = math.min(1,math.max(0,(t-a)/(b-a)))
    return t * t * (3 - 2 * t)
end

function clamp(v,low,high)
    return math.min(math.max(v, low), high)
end

function lerp(v,a,b)
    return a * (1 - v) + b * v
end

function round(number, places) --use -ve places to round to tens, hundreds etc
    local mult = 10^(places or 0)
    return math.floor(number * mult + 0.5) / mult
end

--# Main
-- Soda

saveProjectInfo("Description", "Soda v"..Soda.version)

displayMode(OVERLAY)
displayMode(FULLSCREEN)
-- Use this as a template for your projects that have Soda as a dependency. 

function setup()
    profiler.init()
    Soda.setup()
    parameter.watch("Soda.focus.title")
    overview{}
    -- demo1() --do your setting up here
end

function draw()
    --do your updating here
    pushMatrix()
    Soda.camera()
    Soda.drawing()
    popMatrix()
    profiler.draw()
end

function Soda.drawing(breakPoint) 
    --in order for gaussian blur to work, do all your drawing here
    background(40, 40, 50)
    sprite("Cargo Bot:Game Area", WIDTH*0.5, HEIGHT*0.5, WIDTH, HEIGHT)
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

--measure performance:

profiler={}

function profiler.init(quiet)    
    profiler.del=0
    profiler.c=0
    profiler.fps=0
    profiler.mem=0
    if not quiet then
        parameter.watch("profiler.fps")
        parameter.watch("profiler.mem")
    end
end

function profiler.draw()
    profiler.del = profiler.del +  DeltaTime
    profiler.c = profiler.c + 1
    if profiler.c==10 then
        profiler.fps=profiler.c/profiler.del
        profiler.del=0
        profiler.c=0
        profiler.mem=collectgarbage("count", 2)
    end
end


--# Gesture
-- Sensor v02
-- a class to interpret touch events
-- author: jmv38
-- usage:
--[[
    -- in setup():
    screen = {x=0,y=0,w=WIDTH,h=HEIGHT} 
    sensor = Sensor {parent=screen} -- tell the object you want to be listening to touches, here the screen
    sensor:onTap( function(event) print("tap") end )
    -- in touched(t):
    if sensor:touched(t) then return true end

    -- available:
    sensor:onDrag(callback)
    sensor:onDrop(callback)
    sensor:onTap(callback)
    sensor:onQuickTap(callback)
    sensor:onLongPress(callback)
    sensor:onSwipe(callback)
    sensor:onTouch(callback)
    sensor:onTouched(callback)
    sensor:onZoom(callback)
--]]

local Sensor = class()
-- this is a senor object, that senses and interprets touched events
-- usage is: add a sensor to your objects, pass the touches to the sensor,
-- and define the gestures that will trigger a callback. Exemple:
-- myObject.sensor = Sensor{ parent = myObject }   
-- myObject.sensor:onTap( function(event) myObject:doSomething(event) end )  
-- in you touched(t) code, check the touch by:
--      if myObject:touched(t, off) then return true end
-- this way, if your object is touched, it will fire the callback and avoid others to be touched
-- some more details about the parent:
--      parent must have x,y,w,h fields
--      they are interpreted as CORNER coordinates by default
--      but they can be CENTER or RADIUS coordinates too
--      you can specify this with the field xywhMode at creation of the sensor
--      Sensor{parent=self, xywhMode = CENTER}
-- some more details about the callback:
--      callback are closures with only one parameter, event
--      event is a table where you get whatever you need, depending on the event type
--      ex: onZoom event will contain  event.dw and event.dh so you can use it to zoom your object
--      ex: onDrag has event.touch and event.tpos cause you need to know the touch state and pos
--      see each event code to see what it contains and add information if you need to
--      event contains other fields, used for internal process:
--      at creation event = {name=eventName, callback=callback, update=update}
--      name is a string: "onTap", "onDrag"
--      callback is the closure to be fired when the event happens
--      update is the internal function that manages the touch and detect the event
--      each event type has its own dedicated update function, autonomous and independent of other types

Soda.Gesture = Sensor

function Sensor:init(t)
    self.enabled = true     -- by default, listen to touches
    self.extra = t.extra or self.extra or 0   -- enlarge sensitive zone for small dots or fat fingers
    self.touches = {}       -- keeps track of touches that began on me
    self:setParent(t)       -- parents is needed for x,y,w,h fields
    self.events = {}        -- this table stores all the events of this sensor
    -- normally touches should not pass through the sensor; this flag is to allow touches to go through
    self.doNotInterceptTouches = false -- by default, intercept the touches
end

function Sensor:touched(t,tpos)
    if not self.enabled then return end  -- skip all this is the sensor is disabled
    -- if an object has children, check if they are touched...
    if self.parent.childrenTouched and self.parent:childrenTouched( t, tpos ) then
        return true -- ... and let them intercept the touch if they want to
    end
    if t.state == BEGAN and self:inbox(tpos) then
        self.touches[t.id] = true -- remember if this touch started on me (needed for some gestures)
    end
    for i,event in ipairs(self.events) do 
        event:update(self,t,tpos) -- check all registered events you want to sense, fire them if needed
        -- note: touch is checked even if it didnt start on me: onTouch, onTouched need this
        -- events are checkd in the order they were registered, 
        -- they are all checked, because several events may fire on the same touch
    end
    local intercepted = self.touches[t.id] -- by default intercept the touch
    -- note: it is written to intercept the touch even if your finger is no longer in the object:
    -- this is a feature you in general expect (an object gets the focus for touches, until finger up)
    if self.doNotInterceptOnce then -- a flag raised by some gestures at key moments:
        -- in some cases you want an object to temporarily not intercept the touch, ex: for drag and drop,
        -- the dragged object has focus, but on ENDED it should stop intercepting, so the object
        -- below can sense it is receiving something.
        intercepted = false
        self.doNotInterceptOnce = false -- reset the flag
    end
    if t.state == ENDED or t.state == CANCELLED then
        self.touches[t.id] = nil    -- forget about this touch
    end
    -- sometimes you dont want to intercept touches at all. ex: for a demo you need the touches to show
    -- on top of the screen, so make a screenTouches object for that on top of all objects, but this one
    -- should let all the touches go through. Setting this flag to true will do the trick: you listen to 
    -- touches, but you dont block them.
    if self.doNotInterceptTouches then intercepted = false end
    -- return true when touched (or if i have the focus)
    if intercepted then Soda.focus = self.parent end
    return intercepted 
end

function Sensor:setParent(t)
    -- a parent must have x,y,w,h coordinates (CORNER) to use the sensor
    local p = t.parent or self.parent
    if p.x and p.y and p.w and p.h then
        self.parent = p
    else
        error("Sensor parent must have x,y,w,h coordinates")
    end
    -- the coordinates may be in different modes, use the appropriate function
    -- self:xywh() returns x,y,w,h in RADIUS mode, appropriate to check if the object is touched
    self.xywhMode = t.xywhMode or self.xywhMode or CORNER
    if self.xywhMode == CENTER then self.xywh = self.xywhCENTER
    elseif self.xywhMode == CORNER then self.xywh = self.xywhCORNER
    elseif self.xywhMode == RADIUS then self.xywh = self.xywhRADIUS
    end
end

-- functions to get x, y, w, h from different coordinates systems, return in RADIUS
function Sensor:xywhCORNER()
    local p = self.parent
    local wr, hr = p.w/2.0, p.h/2.0
    local xr, yr = p.x + wr, p.y + hr
    return xr,yr,wr,hr
end
function Sensor:xywhCENTER()
    local p = self.parent
    return p.x, p.y, p.w/2, p.h/2
end
function Sensor:xywhRADIUS()
    local p = self.parent
    return p.x, p.y, p.w, p.h
end

-- check if the box is touched (a rectangle)
-- if you want a more complex shape, or rotations, adapt this fonction to your needs
local abs = math.abs
function Sensor:inbox(t)
    local x,y,w,h = self:xywh()
    return abs(t.x-x)<(w+self.extra) and abs(t.y-y)<(h+self.extra)
end

-- all gestures register themselves with this function (can also unregister an event)
function Sensor:register(eventName, update, callback)
    if callback then
        local event = {name=eventName, callback=callback, update=update}
        for i,event in ipairs(self.events) do
            -- if event already exists, modify it
            if event.name == eventName then 
                self.events[i] = event
                return
            end
        end
        -- if event does not exists, create it
        table.insert(self.events, event)
    else
        -- if callback is nil or false, then remove the event
        for i,event in ipairs(self.events) do
            if event.name == eventName then 
                table.remove(self.events,i)
                return
            end
        end
    end
end
-- get an event (i needed this for debugging only)
function Sensor:getEvent(eventName)
        for i,event in ipairs(self.events) do
            if event.name == eventName then 
                return event
            end
        end
end

-- ##################  From here, each supported gesture is defined   #################

-- Note the that, because gestures are managed individually, the
-- code is much more clear than when everything is mixed up. 
-- And only the needed computations are done.

-- zoom gesture
function Sensor:onZoom(callback)
    self:register("onZoom", self.zoomUpdate, callback)
end
-- zoom is complex because we need to manage 2 touches that begin inside the object, and no more
function Sensor.zoomUpdate(event,self,t,tpos)
    event.touches = event.touches or {} -- init table
    local touches = event.touches
    local t1 = touches[1]
    local t2 = touches[2]
    if t.state == BEGAN then -- a new finger has come, remember it
        if #touches >= 2 then
            -- this is a 3rd finger, dont use it
        else
            -- register this touch and reset
            table.insert(touches,t)
        end
    elseif t.state == MOVING then 
        -- this is a zoom, if we have exactly 2 touches and t is one of them
        if t1 and t2 and ( t1.id == t.id or t2.id == t.id ) then 
            local tm,ts -- m moving, s static
            if t1.id == t.id 
            then touches[1]=t ; tm = t ; ts = t2
            else touches[2]=t ; tm = t ; ts = t1
            end
            -- convert deltaX and deltaY into a variation in width and height (dw and dh)
            local dw,dh
            if tm.x>ts.x 
            then dw = tm.deltaX
            else dw = - tm.deltaX
            end
            if tm.y>ts.y
            then dh = tm.deltaY
            else dh = - tm.deltaY
            end
            -- store the information in event, then fire callback
            event.dw = dw
            event.dh = dh
            event:callback()
        end
    else
        -- when a finger is gone, remove it from the table of touches
        if t1 and t1.id == t.id then table.remove(touches,1) end
        if t2 and t2.id == t.id then table.remove(touches,2) end
    end
end

-- drag gesture
function Sensor:onDrag(callback)
    self:register("onDrag", self.dragUpdate, callback)
end
-- just echo the touch data and position via the callback
function Sensor.dragUpdate(event,self,t,tpos)
    if self.touches[t.id] then
        -- integrate finger movement (can be used as a threshold)
        if t.state == BEGAN then
            event.totalMove = 0
            event.startTime = ElapsedTime
        elseif t.state == MOVING then
            event.totalMove = event.totalMove + abs(t.deltaX) + abs(t.deltaY)
        end
        event.touch = t
        event.tpos = tpos
        event:callback()
    end
end

-- drop gesture
function Sensor:onDrop(callback)
    self:register("onDrop", self.dropUpdate, callback)
end
-- drop occurs when the finger is lifted from the screen (ENDED)
-- but it is complex because you want to detect 2 objects: 
--      the object that is dropped
--      the object that receive the drop
-- register both objects with onDrop, and appropriate callbacks
local droppedObject, droppedTime
function Sensor.dropUpdate(event,self,t,tpos)
    if self:inbox(tpos) and t.state == ENDED then
        -- this is a 2 branches mechanism, so 2 objects can have the onDrop, but we need to
        -- differenciate the 1rst one (dropped) from the second one (receiving the drop)
        if droppedTime ~= ElapsedTime then
            droppedTime = ElapsedTime   -- so next object will go to the other branch
            droppedObject = self.parent
            self.doNotInterceptOnce = true
        else
            event.object = droppedObject
            event:callback()
        end
    end
end

-- touched gesture (this is like CODEA touched function)
function Sensor:onTouched(callback)
    self:register("onTouched", self.touchedUpdate, callback)
end
function Sensor.touchedUpdate(event,self,t,tpos)
    if self.touches[t.id] or self:inbox(tpos) then 
        event.touch = t
        event.tpos = tpos
        event:callback()
    end
end

-- touch gesture
function Sensor:onTouch(callback)
    self:register("onTouch", self.touchUpdate, callback)
end
function Sensor.touchUpdate(event,self,t,tpos)
    self.touching = self.touching or {} -- track touches, not only BEGAN
    -- current touch
    if self:inbox(tpos) then 
        if t.state == BEGAN then 
            event.t0 = ElapsedTime
        end
        if t.state == BEGAN or t.state == MOVING then 
            self.touching[t.id] = true -- this is touching
        else
            self.touching[t.id] = nil -- this is not
        end
    else
        self.touching[t.id] = nil 
    end
    -- final state
    local state1 = false -- one touch is enough to be touched
    for i,t in pairs(self.touching) do state1= true ; break end
    --if state has changed, send callback
    if state1 ~= event.state then
        event.state = state1
        event.touch = t
        event.tpos = tpos
        event:callback()
    end
end

-- fired when the finger leaves the object
function Sensor:onLeave(callback)
    self:register("onLeave", self.leaveUpdate, callback)
end
local current
function Sensor.leaveUpdate(event,self,t,tpos)
    if self:inbox(tpos) then 
        if t.state == BEGAN or t.state == MOVING then 
            self.touching[t.id] = true -- this is touching
        else
            self.touching[t.id] = nil -- this is not
        end
    else
        self.touching[t.id] = nil 
    end
    -- final state
    local state1 = false -- one touch is enough to be touched
    for i,t in pairs(self.touching) do state1= true ; break end
    --if state has changed, send callback
    if state1 ~= event.state then
        event.state = state1
        event.touch = t
        event:callback()
    end
end

-- tap gesture, Yojimbo2000 version
function Sensor:onTap(callback)
    self:register("onTap", self.tapUpdate, callback)
end
function Sensor.tapUpdate(event,self,t,tpos)
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            self.parent.highlighted = true
        elseif t.state == MOVING then
            if not self:inbox(tpos) then --if a touch begins within the element, but then drifts off it, it is cancelled. ie the user can change their mind. This is the same as on iOS.
                self.parent.highlighted = false
                event.cancelled = true
            end
        elseif t.state == ENDED and not event.cancelled then
            self.parent.highlighted = false
            event.tpos = tpos
            event:callback()
        end
    end
    if event.cancelled and (t.state == ENDED or t.state == CANCELLED ) then
        event.cancelled = nil -- reset cancel
    end
end

-- tap gesture, jmv38 initial version, renamed quickTap
function Sensor:onQuickTap(callback)
    self:register("onQuickTap", self.quickTapUpdate, callback)
end
function Sensor.quickTapUpdate(event,self,t,tpos)
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            event.totalMove = 0
            event.t0 = ElapsedTime
        elseif t.state == MOVING then
            -- integrate finger movement
            event.totalMove = event.totalMove + abs(t.deltaX) + abs(t.deltaY)
        elseif t.state == ENDED 
        and event.totalMove < 10  -- the finger should not have moved too much ...
        and (ElapsedTime-event.t0) < 0.5 then -- and delay should not be too long
            event.touch = t
            event.tpos = tpos
            event:callback()
        end
    end
end

-- a double tap gesture
function Sensor:onDoubleTap(callback)
    self:register("onDoubleTap", self.doubleTapUpdate, callback)
end
function Sensor.doubleTapUpdate(event,self,t,tpos)
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            event.totalMove = 0
            event.t0 = ElapsedTime
        elseif t.state == MOVING then
            -- integrate finger movement
            event.totalMove = event.totalMove + abs(t.deltaX) + abs(t.deltaY)
        elseif t.state == ENDED 
        and event.totalMove < 20  -- the finger should not have moved too much ...
        and (ElapsedTime-event.t0) < 2.0 -- and delay should not be too long...
        and t.tapCount == 2 then -- and 2 taps
            event.touch = t
            event.tpos = tpos
            event:callback()
        end
    end
end

-- a single tap gesture
function Sensor:onSingleTap(callback)
    self:register("onSingleTap", self.singleTapUpdate, callback)
end
function Sensor.singleTapUpdate(event,self,t,tpos)
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            event.totalMove = 0
            event.t0 = ElapsedTime
        elseif t.state == MOVING then
            -- integrate finger movement
            event.totalMove = event.totalMove + abs(t.deltaX) + abs(t.deltaY)
        elseif t.state == ENDED 
        and event.totalMove < 10  -- the finger should not have moved too much ...
        and (ElapsedTime-event.t0) < 0.5 -- and delay should not be too long...
        and t.tapCount == 1 then -- and 2 taps
            event.touch = t
            event.tpos = tpos
            event:callback()
        end
    end
end

-- long press gesture
function Sensor:onLongPress(callback)
    self:register("onLongPress", self.longPressUpdate, callback)
end
function Sensor.longPressUpdate(event,self,t,tpos)
    local tmin = 1
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            event.totalMove = 0
            event.cancel = false
            event.id = t.id
            event.tween = tween.delay(tmin,function()
                event.tween = nil
                if event.totalMove > 10 or event.id ~= t.id then  event.cancel = true end
                if event.cancel then return end
                event.tpos = tpos
                event:callback()
            end)
        elseif t.state == MOVING and event.id == t.id then
            -- integrate finger movement
            event.totalMove = event.totalMove + abs(t.deltaX) + abs(t.deltaY)
        elseif (t.state == ENDED or t.state == CANCELLED) and event.id == t.id then
            event.cancel = true
            if event.tween then tween.stop(event.tween) end
        end
    end
end

-- swipe gesture
function Sensor:onSwipe(callback)
    self:register("onSwipe", self.swipeUpdate, callback)
end
function Sensor.swipeUpdate(event,self,t,tpos)
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            event.dx = 0
            event.dy = 0
            event.t0 = ElapsedTime
        elseif t.state == MOVING then
            -- track net finger movement
            event.dx = event.dx + t.deltaX
            event.dy = event.dy + t.deltaY
        elseif t.state == ENDED 
        and (ElapsedTime-event.t0) < 1 then -- delay should not be too long
            -- and the finger should have moved enough:
            local minMove = 70
            if abs(event.dx) < minMove  then event.dx = 0 end
            if abs(event.dy) < minMove  then event.dy = 0 end
            if event.dx ~= 0 or event.dy ~= 0 then
                event:callback() -- use event.dx and .dy to know the swipe direction
            end
        end
    end
end


--# Style
Soda.themes = {
default = { 
white = color(249, 248, 248, 240)  ,lightGrey = color(217, 200)  ,midGrey = color(69, 200)  , 
blue = color(56, 155, 252)  , darkBlue = color(34, 94, 153)  ,
black = color(0)  ,red = color(204, 41, 41)  ,darkGrey = color(40)  , darkTrans = color(40,40),  
grey = color(128, 128) }
}

Soda.style = {
    shadow = {shape = { fill = color(0, 90), stroke = color(0, 90)}  }, --a special style used to produce shadows 20, 100
    inactive = { shape = {stroke = "lightGrey"}, text = {fill = "lightGrey"} } --greyed out elements
}

Soda.style.default = {
    shape = {fill = "white",
        stroke = "lightGrey",
        strokeWidth = 2,
        -- highlight = "blue"
    },
    text = {
        fill = "darkGrey",
        font = "HelveticaNeue-Light",
        fontSize = 1},
    title = {
        fill = "blue",
        font = "HelveticaNeue",},

--substyles
    button = {
        text = {fill = "blue",
            font = "HelveticaNeue-Light"
            },
        shape = {},
        highlight = {
            text = { fill = "white"},
            shape = {fill = "blue", noStroke = true},
        }
    },

    listItem = {
        text = {fill = "darkGrey",
            },
        shape = {},
        highlight = {
            text = { fill = "white"},
            shape = {fill = "blue", noStroke = true},
        }
    },

    icon = {
        text = { fontSize = 1.25, fill = "white"},
        shape = {noFill = true, noStroke = true}, --
        highlight = {
            text = { fill = "black", fontSize = 1.25},
            shape = {fill = "blue", noStroke = true},
        }
    },

    darkIcon = {
        text = { fontSize = 1.25, fill = "white"},
        shape = {noFill = true, strokeWidth = 1, stroke = "white"}, --
        highlight = {
            text = { fill = "white", fontSize = 1.25},
            shape = {fill = "blue", noStroke = true},
        }
    },

    warning = {
        shape = {fill = "red",
            stroke = "midGrey",
            strokeWidth = 2
            },
        text = {fill = "white"},
        highlight = {
            text = {fill = "red"},
            shape = {fill = "white", stroke = "red"}
        }
    },
        
    transparent = {
        shape = {noFill = true},
        text = {},
        highlight = {
            shape = {fill = "lightGrey"},
            text = {fill = "darkGrey"}
        }
    },

    translucent = {
        shape = {fill = "darkTrans", stroke = "grey"},
        text = {},
        title = {fill = "darkBlue"}
    },

    blurred = { --this is set automatically when the blurred flag is true
        shape = {fill = (210), stroke = "midGrey"},
        text = {},
        title = {fill = "white"}
    },

    popUp = {
        shape = {fill = "black", stroke = "grey"},
        text = {fill = "white"},
        highlight = {
            shape = {fill = "white"},
            text = {fill = "black"}
        }
    },

    switch = {
        shape = {},
        text = {},
        highlight = {
            shape = {fill = "blue", noStroke = true},
            text = {}
            }
    },
--special
    textEntry = {font = "Inconsolata", fill = "black", fontSize = 1.2},
    textBox = {font = "Inconsolata", fill = "black", fontSize = 1},
}

Soda.symbol = {menu = "\u{2630}", back = "\u{ff1c}", forward = "\u{ff1e}", close = "\u{2715}", down = "\u{25bc}", gear = "\u{2699}", add = "\u{FF0B}", delete = "\u{232B}", widen = "\u{2194}", undo = "\u{21ba}"} 

for k,v in pairs(Soda.symbol) do
    Soda.symbol[k] = v.."\u{fe0e}" --an escape code which forces preceding character to display as a symbol, not an emoji
end

function Soda.setStyle(sty)
    for k,v in pairs(sty) do
        if type(v)=="string" and Soda.theme[v] then
            Soda[k](Soda.theme[v])
        else
         local ok, err = xpcall(function() Soda[k](v) end, function(trace) return debug.traceback(trace) end) 
            if not ok then print(err) end
         --   Soda[k](v)
        end
    end
end

function Soda.fill(v)
    fill(v)
end

function Soda.stroke(v)
    stroke(v)
end

function Soda.font(v)
    font(v)
end

function Soda.fontSize(v)
    fontSize(v*Soda.baseFontSize)
end

function Soda.textWrapWidth(v)
    textWrapWidth(v)
end

function Soda.textAlign(v)
    textAlign(v)
end

function Soda.strokeWidth(v)
    strokeWidth(v)
end

function Soda.noFill()
    noFill()
end

function Soda.noStroke()
    noStroke()
end

function Soda.rect(t)
  --  rect(0, 0, self.w or self.parent.w, self.h or self.parent.h)
    rect(t.x, t.y, t.w+1, t.h+2)
end

function Soda.line(t)
    local hw, hh = t.w * 0.5, t.h * 0.5
    line(t.x - hw, t.y - hh, t.x + hw, t.y + hh)
end

function Soda.ellipse(t)
    ellipse(t.x, t.y, t.w)
 --   ellipse(0, 0, self.w or self.parent.w)
end

--Soda.setup()

--[[
LEFTEDGE, TOPEDGE, RIGHTEDGE, BOTTOMEDGE = 1,2,4,8
function Soda:outline(t) --edge 1=left, 2 = top, 4 = right, 8 = bottom
  --  background(fill())
    local edge = t.edge or 15
    local s = strokeWidth() --* 0.5
    local w, h = (self.w - s) * 0.5, (self.h - s) * 0.5
    local x,y,u,v = -w, -h, w, h
    local p = {vec2(x,y), vec2(x,v), vec2(u,v), vec2(u,y)}
    for i = 0,3 do
        local f = 2^i
        if edge & f == f then
            local a,b = p[i+1], p[((i+1)%4)+1]
            line(a.x,a.y,b.x,b.y)
        end
    end
end
  ]]






--# RoundRect
local __RRects = {}
--[[
true mesh rounded rectangle. Original by @LoopSpace
with anti-aliasing, optional fill and stroke components, optional texture that preserves aspect ratio of original image, automatic mesh caching
usage: RoundedRectangle{key = arg, key2 = arg2}
required: x;y;w;h:  dimensions of the rectangle
optional: radius:   corner rounding radius, defaults to 6; 
          corners:  bitwise flag indicating which corners to round, defaults to 15 (all corners). 
                    Corners are numbered 1,2,4,8 starting in lower-left corner proceeding clockwise
                    eg to round the two bottom corners use: 1 | 8
                    to round all the corners except the top-left use: ~ 2
          tex:      texture image
            scale:  size of rect (using scale)
use standard fill(), stroke(), strokeWidth() to set body fill color, outline stroke color and stroke width
  ]]
function Soda.RoundedRectangle(t) 
    local s = t.radius or 8
    local c = t.corners or 15
    local w = math.max(t.w+1,2*s)+1
    local h = math.max(t.h,2*s)+2
    local hasTexture = 0
    if t.tex then hasTexture = 1 end
    local label = table.concat({w,h,s,c,hasTexture},",")
    
    if not __RRects[label] then
        local rr = mesh()
        rr.shader = shader(rrectshad.vert, rrectshad.frag)

        local v = {}
        local no = {}

        local n = math.max(3, s//2)
        local o,dx,dy
        local edge, cent = vec3(0,0,1), vec3(0,0,0)
        for j = 1,4 do
            dx = 1 - 2*(((j+1)//2)%2)
            dy = -1 + 2*((j//2)%2)
            o = vec2(dx * (w * 0.5 - s), dy * (h * 0.5 - s))
            --  if math.floor(c/2^(j-1))%2 == 0 then
            local bit = 2^(j-1)
            if c & bit == bit then
                for i = 1,n do
                    
                    v[#v+1] = o
                    v[#v+1] = o + vec2(dx * s * math.cos((i-1) * math.pi/(2*n)), dy * s * math.sin((i-1) * math.pi/(2*n)))
                    v[#v+1] = o + vec2(dx * s * math.cos(i * math.pi/(2*n)), dy * s * math.sin(i * math.pi/(2*n)))
                    no[#no+1] = cent
                    no[#no+1] = edge
                    no[#no+1] = edge
                end
            else
                v[#v+1] = o
                v[#v+1] = o + vec2(dx * s,0)
                v[#v+1] = o + vec2(dx * s,dy * s)
                v[#v+1] = o
                v[#v+1] = o + vec2(0,dy * s)
                v[#v+1] = o + vec2(dx * s,dy * s)
                local new = {cent, edge, edge, cent, edge, edge}
                for i=1,#new do
                    no[#no+1] = new[i]
                end
            end
        end
        -- print("vertices", #v)
        --  r = (#v/6)+1
        rr.vertices = v
        
        rr:addRect(0,0,w-2*s,h-2*s)
        rr:addRect(0,(h-s)/2,w-2*s,s)
        rr:addRect(0,-(h-s)/2,w-2*s,s)
        rr:addRect(-(w-s)/2, 0, s, h - 2*s)
        rr:addRect((w-s)/2, 0, s, h - 2*s)
        --mark edges
        local new = {cent,cent,cent, cent,cent,cent,
        edge,cent,cent, edge,cent,edge,
        cent,edge,edge, cent,edge,cent,
        edge,edge,cent, edge,cent,cent,
        cent,cent,edge, cent,edge,edge}
        for i=1,#new do
            no[#no+1] = new[i]
        end
        rr.normals = no
        --texture
        if t.tex then
            rr.shader.fragmentProgram = rrectshad.fragTex
            rr.texture = t.tex
            local t = {}
            local ww,hh = w*0.5, h*0.5
          --  local aspect = vec2(w,h) --vec2(w * (rr.texture.width/w), h * (rr.texture.height/h))
            
            for i,v in ipairs(rr.vertices) do
                t[i] = vec2((v.x + ww)/w, (v.y + hh)/h)
            end
            rr.texCoords = t
        end
        local sc = 1/math.max(2, s)
        rr.shader.scale = sc --set the scale, so that we get consistent one pixel anti-aliasing, regardless of size of corners
        __RRects[label] = rr
    end
    __RRects[label].shader.fillColor = color(fill())
    if strokeWidth() == 0 then
        __RRects[label].shader.strokeColor = color(fill())
    else
        __RRects[label].shader.strokeColor = color(stroke())
    end

    if t.resetTex then
        __RRects[label].texture = t.resetTex
        t.resetTex = nil
    end
    local sc = 0.25/math.max(2, s)
    __RRects[label].shader.strokeWidth = math.min( 1 - sc*3, strokeWidth() * sc)
    pushMatrix()
    translate(t.x,t.y)
    scale(t.scale or 1)
    __RRects[label]:draw()
    popMatrix()
end

rrectshad ={
vert=[[
uniform mat4 modelViewProjection;

attribute vec4 position;

//attribute vec4 color;
attribute vec2 texCoord;
attribute vec3 normal;

//varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying vec3 vNormal;

void main()
{
    //  vColor = color;
    vTexCoord = texCoord;
    vNormal = normal;
    gl_Position = modelViewProjection * position;
}
]],
frag=[[
precision highp float;

uniform lowp vec4 fillColor;
uniform lowp vec4 strokeColor;
uniform float scale;
uniform float strokeWidth;

//varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying vec3 vNormal;

void main()
{
    lowp vec4 col = mix(strokeColor, fillColor, smoothstep((1. - strokeWidth) - scale * 0.5, (1. - strokeWidth) - scale * 1.5 , vNormal.z)); //0.95, 0.92,
     col = mix(vec4(col.rgb, 0.), col, smoothstep(1., 1.-scale, vNormal.z) );
   // col *= smoothstep(1., 1.-scale, vNormal.z);
    gl_FragColor = col;
}
]],
fragTex=[[
precision highp float;

uniform lowp sampler2D texture;
uniform lowp vec4 fillColor;
uniform lowp vec4 strokeColor;
uniform float scale;
uniform float strokeWidth;

//varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying vec3 vNormal;

void main()
{
    vec4 pixel = texture2D(texture, vTexCoord) * fillColor;
    lowp vec4 col = mix(strokeColor, pixel, smoothstep(1. - strokeWidth - scale * 0.5, 1. - strokeWidth - scale * 1.5, vNormal.z)); //0.95, 0.92,
    // col = mix(vec4(0.), col, smoothstep(1., 1.-scale, vNormal.z) );
    col *= smoothstep(1., 1.-scale, vNormal.z);
    gl_FragColor = col;
}
]]
}






--# Blur
Soda.Gaussian = class() --a component for nice effects like shadows and blur
--Gaussian blur
--adapted by Yojimbo2000 from http://xissburg.com/faster-gaussian-blur-in-glsl/ 

function Soda.Gaussian:setImage()
    local p = self.parent
    
    local ww,hh = p.w * self.falloff, p.h * self.falloff -- shadow image needs to be larger than the element casting the shadow, in order to capture the blurry shadow falloff
    self.ww, self.hh = ww,hh
 
    local d = math.max(ww, hh)
    local blurRad = smoothstep(d, math.max(WIDTH, HEIGHT)*1.5, 60) * 1.5
    local aspect = vec2(d/ww, d/hh) * blurRad --work out the inverse aspect ratio
   -- print(p.title, "aspect", aspect)

    local downSample = 0.25 

    local dimensions = vec2(ww, hh) * downSample --down sampled
    
    local blurTex = {} --images
    local blurMesh = {} --meshes
    for i=1,2 do --2 passes, one for horizontal, one vertical
        blurTex[i]=image(dimensions.x, dimensions.y)
        local m = mesh()
        m.texture=blurTex[i]
        m:addRect(dimensions.x/2, dimensions.y/2,dimensions.x, dimensions.y)
        m.shader=shader(Soda.Gaussian.shader.vert[i], Soda.Gaussian.shader.frag)
      --  blurred[i].shader.am = falloff
        m.shader.am = aspect
        blurMesh[i] = m
    end
    local imgOut = image(dimensions.x, dimensions.y)
    pushStyle()
    pushMatrix()
    setContext(blurTex[1])

    scale(downSample)

    self:drawImage()
    popMatrix()
    popStyle()   
    
    setContext(blurTex[2])
    blurMesh[1]:draw() --pass one
    setContext(imgOut)
    blurMesh[2]:draw() --pass two, to output
    setContext()

    return imgOut
end

function Soda.Gaussian:draw()
    local p = self.parent
    self.mesh:setRect(1, p.x + self.off, p.y - self.off, self.ww, self.hh)
    self.mesh:draw()
end

---------------------------------------------------------------------------

Soda.Blur = class(Soda.Gaussian)

function Soda.Blur:init(t)
    self.parent = t.parent
    self.falloff = 1
    self.off = 0
    self:setMesh()
  --  self.image = image(self.parent.w * 0.25, self.parent.h * 0.25)
  --  self.draw = self.setMesh --
end

function Soda.Blur:draw() end

function Soda.Blur:setMesh() 
   --     self.draw = null
    self.image = self:setImage()
    self.parent.shapeArgs.tex = self.image
    self.parent.shapeArgs.resetTex = self.image
end

function Soda.Blur:drawImage()
    pushMatrix()

    translate(-self.parent:left(), -self.parent:bottom())
 
    Soda.drawing(self.parent) --draw all elements to the blur image, with the parent set as the breakpoint (so that the parent window itself does not show up in the blurred image)
    popMatrix()
end

---------------------------------------------------------------------------

Soda.Shadow = class(Soda.Gaussian)

function Soda.Shadow:init(t)
    self.parent = t.parent

     self.falloff = 1.3
    self.off = math.max(2, self.parent.w * 0.015, self.parent.h * 0.015)
   -- print(self.parent.title, "offset", self.off)
    self.mesh = mesh()
    self.mesh:addRect(0,0,0,0)
    self:setMesh()
end

function Soda.Shadow:setMesh()
    self.mesh.texture = self:setImage()
   -- self.mesh:setRect(1, self.parent.x + self.off,self.parent.y - self.off,self.ww, self.hh)   --nb, rect is set in draw function, for animation purposes
end

function Soda.Shadow:drawImage()
    pushStyle()
    pushMatrix()

    translate((self.ww-self.parent.w)*0.45, (self.hh-self.parent.h)*0.45)
    self.parent:drawShape({Soda.style.shadow})
    popMatrix()

    popStyle()
end

Soda.Gaussian.shader = {
vert = { -- horizontal pass vertex shader
[[
uniform mat4 modelViewProjection;
uniform vec2 am; // ammount of blur, inverse aspect ratio (so that oblong shapes still produce round blur)
attribute vec4 position;
attribute vec2 texCoord;
 
varying vec2 vTexCoord;
varying vec2 v_blurTexCoords[14];
 
void main()
{
    gl_Position = modelViewProjection * position;
    vTexCoord = texCoord;
    v_blurTexCoords[ 0] = vTexCoord + vec2(-0.028 * am.x, 0.0);
    v_blurTexCoords[ 1] = vTexCoord + vec2(-0.024 * am.x, 0.0);
    v_blurTexCoords[ 2] = vTexCoord + vec2(-0.020 * am.x, 0.0);
    v_blurTexCoords[ 3] = vTexCoord + vec2(-0.016 * am.x, 0.0);
    v_blurTexCoords[ 4] = vTexCoord + vec2(-0.012 * am.x, 0.0);
    v_blurTexCoords[ 5] = vTexCoord + vec2(-0.008 * am.x, 0.0);
    v_blurTexCoords[ 6] = vTexCoord + vec2(-0.004 * am.x, 0.0);
    v_blurTexCoords[ 7] = vTexCoord + vec2( 0.004 * am.x, 0.0);
    v_blurTexCoords[ 8] = vTexCoord + vec2( 0.008 * am.x, 0.0);
    v_blurTexCoords[ 9] = vTexCoord + vec2( 0.012 * am.x, 0.0);
    v_blurTexCoords[10] = vTexCoord + vec2( 0.016 * am.x, 0.0);
    v_blurTexCoords[11] = vTexCoord + vec2( 0.020 * am.x, 0.0);
    v_blurTexCoords[12] = vTexCoord + vec2( 0.024 * am.x, 0.0);
    v_blurTexCoords[13] = vTexCoord + vec2( 0.028 * am.x, 0.0);
}]],
-- vertical pass vertex shader
 [[
uniform mat4 modelViewProjection;
uniform vec2 am; // ammount of blur
attribute vec4 position;
attribute vec2 texCoord;
 
varying vec2 vTexCoord;
varying vec2 v_blurTexCoords[14];
 
void main()
{
    gl_Position = modelViewProjection * position;
    vTexCoord = texCoord;
    v_blurTexCoords[ 0] = vTexCoord + vec2(0.0, -0.028 * am.y);
    v_blurTexCoords[ 1] = vTexCoord + vec2(0.0, -0.024 * am.y);
    v_blurTexCoords[ 2] = vTexCoord + vec2(0.0, -0.020 * am.y);
    v_blurTexCoords[ 3] = vTexCoord + vec2(0.0, -0.016 * am.y);
    v_blurTexCoords[ 4] = vTexCoord + vec2(0.0, -0.012 * am.y);
    v_blurTexCoords[ 5] = vTexCoord + vec2(0.0, -0.008 * am.y);
    v_blurTexCoords[ 6] = vTexCoord + vec2(0.0, -0.004 * am.y);
    v_blurTexCoords[ 7] = vTexCoord + vec2(0.0,  0.004 * am.y);
    v_blurTexCoords[ 8] = vTexCoord + vec2(0.0,  0.008 * am.y);
    v_blurTexCoords[ 9] = vTexCoord + vec2(0.0,  0.012 * am.y);
    v_blurTexCoords[10] = vTexCoord + vec2(0.0,  0.016 * am.y);
    v_blurTexCoords[11] = vTexCoord + vec2(0.0,  0.020 * am.y);
    v_blurTexCoords[12] = vTexCoord + vec2(0.0,  0.024 * am.y);
    v_blurTexCoords[13] = vTexCoord + vec2(0.0,  0.028 * am.y);
}]]},
--fragment shader
frag = [[precision mediump float;
 
uniform lowp sampler2D texture;
 
varying vec2 vTexCoord;
varying vec2 v_blurTexCoords[14];
 
void main()
{
    gl_FragColor = vec4(0.0);
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 0])*0.0044299121055113265;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 1])*0.00895781211794;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 2])*0.0215963866053;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 3])*0.0443683338718;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 4])*0.0776744219933;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 5])*0.115876621105;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 6])*0.147308056121;
    gl_FragColor += texture2D(texture, vTexCoord         )*0.159576912161;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 7])*0.147308056121;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 8])*0.115876621105;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 9])*0.0776744219933;
    gl_FragColor += texture2D(texture, v_blurTexCoords[10])*0.0443683338718;
    gl_FragColor += texture2D(texture, v_blurTexCoords[11])*0.0215963866053;
    gl_FragColor += texture2D(texture, v_blurTexCoords[12])*0.00895781211794;
    gl_FragColor += texture2D(texture, v_blurTexCoords[13])*0.0044299121055113265;
}]]
}






--# FRAME
Soda.Frame = class() --the master class for all UI elements. 

function Soda.Frame:init(t)
    t.shapeArgs = t.shapeArgs or {}
    t.style = t.style or Soda.style.default
    if not t.label and t.title then
        t.label = {x=0.5, y=-10}
    end
    self:storeParameters(t)
 
    self.callback = t.callback or null --triggered on action completion
    self.update = t.update or null --triggered every draw cycle.
    
    --null = function() end. ie no need to test if callback then callback()
    
    --parenthood, baseStyle inheritance
    self.child = {} --hold any children
    if t.parent then
        local priority = t.priority or #t.parent.child+1
        table.insert(t.parent.child, priority, self) --if this has a parent, add it to the parent's list of children
        self.style = t.style or t.parent.style
  --      self.inactive = self.inactive or self.parent.inactive
    else
        local priority = t.priority or #Soda.items+1
        table.insert( Soda.items, priority, self) --no parent = top-level, added to Soda.items table
        self.style = t.style or Soda.style.default
    end
    self.styleList = {self.style}
    self.subStyle = t.subStyle or {}
    for i,v in ipairs(self.subStyle) do
        table.insert(self.styleList, self.style[v]) 
    end
    
    self:setPosition()

    self.mesh = {} --holds additional effects, such as shadow and blur
    if t.blurred then
        self.mesh[#self.mesh+1] = Soda.Blur{parent = self}
        self.shapeArgs.tex = self.mesh[#self.mesh].image
        self.shapeArgs.resetTex = self.mesh[#self.mesh].image
        table.insert(self.styleList, self.style["blurred"]) 
    end
    if t.shadow then
        self.mesh[#self.mesh+1] = Soda.Shadow{parent = self}
    end
    
    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    self:setInactive(self.inactive or self.hidden)
    --elements that are defined as hidden (invisible) are also inactive (untouchable) at initialisation    

end

function Soda.Frame:setInactive(b)
    self.inactive = b
    self.sensor.enabled = not self.inactive
end

function Soda.Frame:childrenTouched(t,tpos)
    local off = tpos - vec2(self:left(), self:bottom())
    for i = #self.child, 1, -1 do --children take priority over frame for touch
        local v = self.child[i]
        if v:touched(t, off) then return true end
    end
end

function Soda.Frame:touched(t, tpos)
    if self.inactive then return end
    if self.sensor:touched(t, tpos) then return true end
    return self.alert
end

function Soda.Frame:storeParameters(t)
    self.parameters = {}
    for k,v in pairs(t) do
        
        if k =="label" or k=="shapeArgs" then
            self[k] = {}
            self.parameters[k] = {}
            for a,b in pairs(v) do
                self[k][a] = b
                self.parameters[k][a] = b
            end
        else
            self.parameters[k] = v
            self[k] = v
        end
        
    end
end

function Soda.Frame:setPosition() --all elements defined relative to their parents. This is recalculated when orientation changes
    local t = self.parameters
    local edge = vec2(WIDTH, HEIGHT)
    if self.parent then
        edge = vec2(self.parent.w, self.parent.h)
    end
    
    self.x, self.w = Soda.parseCoordSize(t.x or 0.5, t.w or 0.4, edge.x)
    self.y, self.h = Soda.parseCoordSize(t.y or 0.5, t.h or 0.3, edge.y)
    if t.label then
        self.label.w, self.label.h = self:getTextSize()
        
        self.label.x = Soda.parseCoord(t.label.x,self.label.w,self.w)
        self.label.y = Soda.parseCoord(t.label.y,self.label.h,self.h)

    end
    if self.shapeArgs then
        local s = self.shapeArgs
        s.w = t.shapeArgs.w or self.w
        s.h = t.shapeArgs.h or self.h

        s.x = Soda.parseCoord(t.shapeArgs.x or 0, s.w, self.w)
        s.y = Soda.parseCoord(t.shapeArgs.y or 0, s.h, self.h)
    end
end

function Soda.Frame:setStyle(list, pref1, pref2)
    for i,v in ipairs(list) do
        Soda.setStyle(v[pref1] or v[pref2])
    end
end

function Soda.Frame:getTextSize(sty, tex)
    pushStyle()

   -- Soda.setStyle(Soda.style.default.text)
    Soda.setStyle(sty or self.style.text) --sty or 

    local w,h = textSize(tex or self.title)
    popStyle()
    return w,h
end

function Soda.Frame:show(direction)
    self.hidden = false --so that we can see animation

    self:setInactive(false)

    if direction then --animation
        self:setPosition()
        local targetX = self.x
        if direction==LEFT then
            self.x = - self.w * 0.5
        elseif direction==RIGHT then
            self.x = WIDTH + self.w * 0.5
        end
        tween(0.4, self, {x=targetX}, tween.easing.cubicInOut) 
    end
    if self.shapeArgs and self.shapeArgs.tex then self.shapeArgs.resetTex = self.shapeArgs.tex end --force roundedrect to switch texture (because two rects of same dimensions are cached as one mesh)
end

function Soda.Frame:hide(direction)
    --self.inactive=true --cannot touch element during deactivation animation
    if direction then
        local targetX
        if direction==LEFT then
            targetX = - self.w * 0.5
        elseif direction==RIGHT then
            targetX = WIDTH + self.w * 0.5
        end
        tween(0.4, self, {x=targetX}, tween.easing.cubicInOut, function() self.hidden = true self:setInactive(true)  end) --user cannot touch buttons until animation completes
    else
        self.hidden = true
        self:setInactive(true)
    end
end

function Soda.Frame:toggle(direction)
    if self.inactive then self:show(direction)
    else self:hide(direction)
    end
end

function Soda.Frame:activate()
        self:setInactive(false)
end

function Soda.Frame:deactivate()
        self:setInactive(true)
end

function Soda.Frame:draw(breakPoint)
    if breakPoint and breakPoint == self then return true end
    if self.hidden then return end
    self:update()
    if self.alert then
        Soda.darken.draw() --darken underlying interface elements
    end
    
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw() --draw shadow
    end
    
    local sty = {unpack(self.styleList)} --shallow copy of the lisr of styles self.style
    if self.inactive then
        sty[#sty+1] = Soda.style.inactive
    elseif self.highlighted and self.highlightable then
       -- sty[#sty+1] = self.style.highlight --self.style.highlight or Soda.style.default.highlight
        sty[#sty] = sty[#sty].highlight
    end

    pushMatrix()
    pushStyle()
    
    translate(self:left(), self:bottom())
    if self.shape then
        self:drawShape(sty)
    end
        popStyle()
    pushStyle()
    self:setStyle(sty, "body", "text")
    --Soda.setStyle(self.style.body) --(Soda.style.default.body)
 -- Soda.setStyle(sty.text)
    
    self:drawContent()
    local titleText = "text"
    if self.content then
        textWrapWidth(self.w * 0.9)
        text(self.content, self.w * 0.5, self.h * 0.6)
        textWrapWidth()
        titleText = "title"
    end
    if self.label then
        
      --  Soda.setStyle(sty.text) --(Soda.style.default.text)
       self:setStyle(sty, titleText, "text")
        
        text(self.title, self.label.x, self.label.y)
        
    end

    popStyle()
    
    for i, v in ipairs(self.child) do --nb children are drawn with parent's transformation

        if v.kill then
            table.remove(self.child, i)
        else
            if v:draw(breakPoint) then return true end
        end
    end
    popMatrix()

end

function Soda.Frame:drawContent() end --overridden by subclasses

function Soda.Frame:drawShape(sty)
    self:setStyle(sty, "shape")
    self.shape(self.shapeArgs)
end

function Soda.Frame:bottom()
    return self.y - self.h * 0.5
end

function Soda.Frame:top()
    return self.y + self.h * 0.5
end

function Soda.Frame:left()
    return self.x - self.w * 0.5
end

function Soda.Frame:right()
    return self.x + self.w * 0.5
end

function Soda.Frame:selectFromList(child) --method used by parents of selectors. 
    if child==self.selected then --pressed the one already selected
        if self.noSelectionPossible then
            child.highlighted = false
            self.selected = nil
        end
    else
        if self.selected then 

            self.selected.highlighted = false 

            if self.selected.panel then self.selected.panel:hide() end
        end
        self.selected = child
        child.highlighted = true
        if child.panel then child.panel:show() end
        tween.delay(0.1, function() self:callback(child, child.title) end) --slight delay for list animation to register before panel disappears
    end
end

function Soda.Frame:pointIn(x,y)
    return x>self:left() and x<self:right() and y>self:bottom() and y<self:top()
end

function Soda.Frame:orientationChanged()
    self:setPosition()
    
    for _,v in ipairs(self.mesh) do
        v:setMesh()
    end
    
    for _,v in ipairs(self.child) do
        v:orientationChanged()
    end
end






--# Button
Soda.Button = class(Soda.Frame) --one press, activates on release

function Soda.Button:init(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.label = t.label or { x=0.5, y=0.5}
    t.highlightable = true
    t.subStyle = t.subStyle or {"button"}
    Soda.Frame.init(self, t)
    --table.insert(self.styleList, 2, self.style["button"])
--
    -- #################################### <JMV38 changes>
    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
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
    t.title = Soda.symbol.menu --the "hamburger" menu icon
    t.w = t.w or 40
    t.h = t.h or 40
  --  t.style = t.style or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    return Soda.Button(t)
end

function Soda.BackButton(t)
    t.title = Soda.symbol.back -- full-width less-than symbol. alt \u{276e}
    t.w = t.w or 40
    t.h = t.h or 40
   -- t.style = t.style or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    return Soda.Button(t)
end

function Soda.ForwardButton(t)
    t.title = Soda.symbol.forward --greater-than, in case you need a right-facing back button. alt \u{276f}
    t.w = t.w or 40
    t.h = t.h or 40
  --  t.style = t.style or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    return Soda.Button(t)
end

function Soda.CloseButton(t)
    t.title = Soda.symbol.close --multiplication X 
    t.w = t.w or 40
    t.h = t.h or 40
  --  t.style = t.style or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    return Soda.Button(t)
end

function Soda.DropdownButton(t)
    t.title = Soda.symbol.down --down triangle
    t.w = t.w or 40
    t.h = t.h or 40
  --  t.style = t.style or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    return Soda.Button(t)
end

function Soda.SettingsButton(t)
    t.title = Soda.symbol.gear -- the "gear" icon
    t.w = t.w or 40
    t.h = t.h or 40
   -- t.style = t.style or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    t.shape = t.shape or Soda.ellipse
    return Soda.Button(t)
end

function Soda.AddButton(t)
    t.title = Soda.symbol.add -- full-width +
    t.w = t.w or 40
    t.h = t.h or 40
   -- t.style = t.style or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    t.shape = t.shape or Soda.ellipse
    return Soda.Button(t)
end

function Soda.DeleteButton(t)
    t.title = Soda.symbol.delete --backspace delete
    t.w = t.w or 40
    t.h = t.h or 40
   -- t.style = t.style or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    return Soda.Button(t)
end

function Soda.QueryButton(t)
    t.title = "?" --full-width ? \u{ff1f}
    t.w = t.w or 40
    t.h = t.h or 40
   -- t.style = t.style or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    t.shape = t.shape or Soda.ellipse
    return Soda.Button(t)
end






--# Toggle
Soda.Toggle = class(Soda.Button) --press toggles on/ off states

function Soda.Toggle:init(t)
    Soda.Button.init(self,t)
    self:toggleSettings(t)
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

function Soda.SettingsToggle(t)
    t.title = "\u{2699}" -- the "gear" icon
    t.w, t.h = 40, 40
    t.style = t.style --or Soda.style.darkIcon
    t.subStyle = t.subStyle or {"icon", "button"}
    return Soda.Toggle(t)
end

--# Switch
Soda.Switch = class(Soda.Toggle) --an iOS-style switch with a lever that moves back and forth

function Soda.Switch:init(t)

    local tw,_ = textSize(t.title or "")
   -- t.w, t.h = 120+tw,40

    Soda.Frame.init(self, {
        parent = t.parent, 
        x = t.x, y=t.y, w = 120+tw, h = 40, 
        on = t.on or false, 
       -- style = t.style or Soda.style.switch, 
        subStyle = {"switch"},
        shape = Soda.RoundedRectangle, 
        shapeArgs = {w = 70, h = 36, radius = 18, x = 0, y = 2}, 
        highlightable = true, 
        label = {x=80, y=0.5} , title = t.title
    })

    self.knob = Soda.Knob{parent = self, x = 0, y = 0.5, w=38, h=38, shape = Soda.ellipse, shadow = true}
    
    self:toggleSettings(t)
    
    self.knob.sensor.doNotInterceptTouches = true
    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    self.sensor:onTap(function(event) self:toggleMe() end)

end

function Soda.Switch:switchOn()
    Soda.Toggle.switchOn(self)
    self.knob:highlight() 
end

function Soda.Switch:switchOff()
    Soda.Toggle.switchOff(self)
    self.knob:unHighlight() 
end

--animates the switch handle flicking back and forth

Soda.Knob = class(Soda.Frame) 

function Soda.Knob:setPosition()
    Soda.Frame.setPosition(self)
    self.offX = self.x - 1
    self.onX = self.x+34
    if self.parent.on then self.x = self.onX end
end

function Soda.Knob:highlight()
    if self.tween then tween.stop(self.tween) tween.stop(self.tween2) end
    
    self.tween = tween(0.4, self, {x=self.onX}, tween.easing.cubicOut)
    local p = self.parent
    p.shapeArgs.scale = 1
    local t1 = tween(0.1, p.shapeArgs, {scale = 0.7}, tween.easing.cubicIn, function() p.highlighted = true end)
    local t2 = tween(0.3, p.shapeArgs, {scale = 1 }, tween.easing.cubicOut)
    self.tween2 = tween.sequence(t1, t2)

end

function Soda.Knob:unHighlight()
    if self.tween then tween.stop(self.tween) tween.stop(self.tween2) end

    self.tween = tween(0.4, self, {x=self.offX}, tween.easing.cubicOut)
        local p = self.parent
    p.shapeArgs.scale = 1
    local t1 = tween(0.1, p.shapeArgs, {scale = 0.7}, tween.easing.cubicIn, function() p.highlighted = false end)
    local t2 = tween(0.3, p.shapeArgs, {scale = 1 }, tween.easing.cubicOut)
    self.tween2 = tween.sequence(t1, t2)

end


--# TextEntry
-- TextEntry2
-- same as textEntry, plus a select text function
-- author: jmv38, from yojimbo2000 first version

-- functions:
-- tap inside the text block to show keyboard and tap text
-- tap anywhere to place the cursor there
-- tap the cursor to show the paste dialog bar
-- double tap the cursor to show the selection dialog and cursors
-- drag the text when too big to finto the block

-- under the hood:
--      TextEntry is simply showing the text, with a drag function
--      TextEditor is the text modifying object

-- version 2.4
--      subStyle = {"popUp"} for text menus
--      BACKSPACE deletes the selection if user in selection mode
-- version 2.3
--      undo 5 levels, improved exeprience
--      double tap selects the word below
-- version 2.2
--      full rework
-- version 2.1
--      cut and delete corrected for start=0 bug, and stop too (was there a pb...?)↔︎


-- ###############################################################################
-- some classes i want to keep local but available anywhere in this tab
local TextEntry  -- the main class for text box (included in soda)
local TextEditor -- a class managing the text edition tools
local Cursor -- a class for cursor object
local Selector -- a class for a text selection object
-- ###############################################################################

TextEntry = class(Soda.Frame)
TextEntry.usesKeyboard = true
Soda.TextEntry = TextEntry

-- TextEntry itself is doing nothing but displaying the text, text edition is inside TextEditor
function TextEntry:init(t)
    t.shape = Soda.RoundedRectangle
    t.label = {x=10, y=0.5} 
    Soda.Frame.init(self, t)
    table.insert(self.styleList, 2, self.style["button"])
    self:inputString(t.default or "")
    self:updateTextW()
    self.offset = vec2(self.label.w + 5, (self.h-self.label.h)*0.5) --bottom corner of text-entry
    self.Xscroll = 0 -- when text is bigger than window, it can be scrolled
    
    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    --[[self.sensor:onDrag(function(event) 
        -- move the interface to access other text box while keyboard is there
        
        if event.totalMove > 20 and isKeyboardShowing() then 
           Soda.UIoffset = Soda.UIoffset + event.touch.deltaY
        end 
          
    end)]]
    self.sensor:onTouch(function(event) self:autoScrollUpdate(event) end)
    -- this object is to isolate the edition functions and objects from TextEntry
    self.editor = TextEditor( self )
end

function TextEntry:output()
    return self.text
end

-- move the text inside its box 
function TextEntry:horizontalScroll(t)
    local t = t or {}
    if t.state == BEGAN or t.state == MOVING then
        if self.freeScroll then -- if some animation is running, stop it
            tween.stop(self.freeScroll)
            self.freeScroll = false
        end
        self.Xscroll = self.Xscroll + t.deltaX
    else -- come back into position, with a smooth animation effect
        -- create the callback once at first usage and save it
        self.updt = self.updt or function()
            self.freeScroll = false
        end 
        self:updateTextW()
        if self.Xscroll and self.clipW then
        if self.Xscroll > 0 or self.clipW > self.textW then
            self.freeScroll = tween(0.5, self, {Xscroll=0}, tween.easing.backOut, self.updt)
        elseif self.Xscroll < 0 then
            local minScroll = self.clipW - self.textW -10
            if self.Xscroll < minScroll then
                self.freeScroll = tween(0.5, self, {Xscroll=minScroll}, tween.easing.backOut,self.updt)
            end
        end
        end
    end
end

function TextEntry:autoScrollUpdate(event)
    local state = event.touch.state
    local tpos = event.tpos
    if (state == BEGAN or state == MOVING) and self.sensor:inbox(tpos) then
        self:autoScroll(tpos.x)
    else
        self.autoScrollDelta = false
    end
end
function TextEntry:autoScroll(x)
    local direction = false
    if x then
        if x < self.clipX + 50 then direction = 1 end
        if x > self.clipX + self.clipW - 50 then direction = -1 end
        self.autoScrollDelta = direction
    end
    if self.autoScrollDelta then
        self.minScroll = self.clipW - self.textW -10
        self.maxScroll = 0
        self.autoScrollFunc = self.autoScrollFunc or function()
            if self.autoScrollDelta then
                local editor = self.editor
                if editor.inputMode then
                    local c = editor.inputCursor
                    c:setIndex( c.index - self.autoScrollDelta )
                end
                self.Xscroll = self.Xscroll +  self.characterW * self.autoScrollDelta
                if self.Xscroll < self.minScroll then 
                    self.Xscroll = self.minScroll 
                    self.autoScrollDelta = false
                end
                if self.Xscroll > self.maxScroll then 
                    self.Xscroll = self.maxScroll 
                    self.autoScrollDelta = false
                end
                self:autoScroll()
            end
        end
        tween.delay( 0.05, self.autoScrollFunc)
       -- self.debug = true
    else
        -- self.debug = false
    end
end

function TextEntry:updateTextW()
    pushStyle()
    Soda.setStyle(self.style.textEntry)
     --width of a character (nb fixed-width font only, to simplify creation of touchable text)
    self.characterW = textSize("a")
    self.textW = self.text:len() * self.characterW
    popStyle()
end

-- enter text and reset things
function TextEntry:inputString(txt)
    self.text = txt
    self:updateTextW()
    self:horizontalScroll()
end

function TextEntry:subText()
    -- too long strings wont draw properly => extract a smaller sustring
    -- this string is comprised between startIndex and stopIndex (included)
    self.characterW = self.characterW or self:getTextSize(self.style.textEntry, "a")
    self.startIndex = 1
    if self.Xscroll < 0 then
        self.startIndex = math.floor(-self.Xscroll/self.characterW) + 1
    end
    self.stopIndex = self.startIndex + math.floor(self.clipW/self.characterW) +1
    local nbcar = self.text:len()
    if nbcar == 0 then return "" end
    if self.startIndex > nbcar then return "" end
    if self.stopIndex > nbcar then self.stopIndex = nbcar end
    return self.text:sub(self.startIndex , self.stopIndex)
end
function TextEntry:draw(breakPoint)
    Soda.Frame.draw(self, breakPoint) -- generic stuff
    self:drawText() -- the text inside its box
    if not isKeyboardShowing() then self.editor:closeEdition() end
end

-- an extension of clip function:
--  clip(x,y,w,h) is as usual
--  clip(x,y,w,h,true) is using the current translation state to define its position
local stdClip = clip -- remember standard clip function
clip = function(x,y,w,h,relative)
    if x == nil then stdClip() return end
    if relative then -- translate the clip using current translation
        local m = modelMatrix()
        local x0,y0 = m[13],m[14]
        stdClip(x0+x,y0+y,w,h)
    else
        stdClip(x,y,w,h)
    end
end
    
function TextEntry:drawText()
    -- text is written from this position
    local x = self:left() + self.offset.x 
    local y = self:bottom()
    -- these values are used by text editor, so they must be saved ...
    self.textX = x + self.Xscroll -- the starting point for text 
    -- ... and the area where the text shows up:
    self.clipX = x
    self.clipY = y
    self.clipW = self.w-self.offset.x - 5
    self.clipH = self.h
    pushStyle()
    -- make a clip area fpr the text
    clip( self.clipX, self.clipY, self.clipW, self.clipH, true)
        if self.debug then background(255, 205, 0, 12) end -- debug: to view area
        -- inside this area, draw the text
        Soda.setStyle(self.style.textEntry)
        textAlign(LEFT)
        textMode(CORNER)
        -- draw only a subtext (too long text will not draw, due to some codea limit)
        text(self:subText(), self.textX + self.characterW *self.startIndex, y+self.offset.y)
    clip()
    popStyle()
end

-- ###############################################################################

TextEditor = class() -- manages the text edition tools life
local objectEdited -- the only one object that can be edited at a time is stored here

--  creates all the edition tools needed, and makes the reactions to events being coherent
function TextEditor:init(parent)
    self.parent = parent
    -- a cursor for entering text
    self.inputCursor = Cursor{parent=self.parent, x=0, y=0, h=self.parent.h, w=3}
    -- a selection tool
    self.selector = Selector{parent=self.parent, x=0, y=0, h=self.parent.h, w=3}
    -- on startup everything is hidden
    self.inputCursor:hide() 
    self.selector:hide() 
    -- create menus
    self:selectionMenuInit()
    self:inputMenuInit()
    
    -- tapping the parent makes the cursor show up, and the keyboard
    self.parent.sensor:onSingleTap(function(event) self:enterInputMode(event.tpos) end)
    -- double tap the cursor to enter into selection mode
    self.inputCursor.sensor:onDoubleTap(function(event) self:enterSelectionMode(event.tpos) end)
    -- single tap to open paste menu
    self.inputCursor.sensor:onSingleTap(function(event) self:openInputMenu() end)

end

-- ############## mode switching related stuff ##############

-- prepare object for receiving text
function TextEditor:enterInputMode(tpos)
    self:startEdition()
    if self.selectionMode then 
        self.inputCursor.index = self.selector.infCursor.index
        self:leaveSelectionMode() 
    end
    self.inputMode = true
    -- put the cursor at good position, and show it
    if tpos then self.inputCursor:setFromPosition(tpos.x) end
    self.inputCursor:show()
    -- bring up the keyboard, if not yet here
end
-- end properly input mode
function TextEditor:leaveInputMode()
    self.inputMode = false
    self.inputCursor:hide()
    self:closeInputMenu()
end
-- enter selection mode
function TextEditor:enterSelectionMode(tpos)
    self:leaveInputMode() -- you can enter selection mode only from input mode
    self.selectionMode = true
    -- put the cursor at good position, and show it
    self.selector:selectAll()
    self.selector:setFromPosition(self.inputCursor.x)
    self.selector:show()
    self.selectionMenu:show()
end
-- end properly selection mode
function TextEditor:leaveSelectionMode(tpos)
    self.selectionMode = false
    self.selector:hide()
    self.selectionMenu:hide()
end
-- start editing an object
function TextEditor:startEdition()
    if  objectEdited ~= self.parent then 
        -- close the other object being edited, if any
        if objectEdited then objectEdited.editor:closeEdition() end
        -- update state data
        objectEdited = self.parent
    end
    -- create the undo function
    self:pushUndo()
    self:startTextInput()
end
-- end properly the edition phase
function TextEditor:closeEdition()
    if  objectEdited ~= self.parent then return end
    objectEdited = false
    if self.inputMode then self:leaveInputMode() end
    if self.selectionMode then self:leaveSelectionMode() end
    -- fire a callback when edition finished, with a delay in case the order comes from draw
    tween.delay(0.001, function() self.parent.callback(self.parent.text) end ) 
    self:endTextInput()
end
-- a stack of undo's
function TextEditor:pushUndo()
    self.undos = self.undos or {} -- table of undo's
    local txt = self.parent.text
    local func = function() self.parent:inputString(txt) end
    table.insert(self.undos,1,func)
    local maxi = 5
    if #self.undos > maxi then table.remove(self.undos,maxi+1) end -- not too many levels
end
function TextEditor:popUndo()
    local func = self.undos[1]
    -- remove undos, but the first one
    if #self.undos > 1 then table.remove(self.undos,1) end
    return func
end
-- ############## text input stuff ##############
-- i have left this part isolated because it is closely related to Soda and i dont understand everything
-- it could be merged with above function, but there is no real need for that

function TextEditor:startTextInput()
    local delay = 0.5  -- animation
    if not isKeyboardShowing() then 
        showKeyboard() 
        delay = 1.0  -- more time is needed when keyboard was not here
    end
    if Soda.keyboardEntity ~= self then
        -- adapt the interface position to this object
        local h = 0.3
        local y = self.parent:bottom() + self.parent.offset.y
        if CurrentOrientation == LANDSCAPE_LEFT or CurrentOrientation == LANDSCAPE_RIGHT then h = 0.4 end
        local typewriter = math.max(0, (HEIGHT * h) - y) -- new position
        tween(delay,Soda,{UIoffset=typewriter},tween.easing.cubicOut) -- go there smoothly
    end
    Soda.keyboardEntity = self
end

function TextEditor:endTextInput()
    Soda.keyboardEntity = nil
end

function TextEditor:keyboard(key)
    if key == RETURN then
        hideKeyboard() --hide keyboard triggers end of text input event in TextEntry:draw()
        self:closeEdition()
    elseif key == BACKSPACE then
        if self.selectionMode then
            local start = self.selector.infCursor.index
            local stop = self.selector.supCursor.index
            self:delete(start,stop)
        else
            local start = self.inputCursor.index - 1
            local stop = self.inputCursor.index
            if start >0 then
                self:delete(start,stop)
                self.inputCursor.index = self.inputCursor.index - 1   -- and move cursor back 1 char
            end
        end
    elseif key:len()==1 then
        self:paste(key)
        self.inputCursor.index = self.inputCursor.index + 1   -- and move cursor up 1 char
    end
end


-- ############## input menu related stuff ##############

function TextEditor:inputMenuInit()
    self.inputMenu = Soda.Segment{
        parent = self.parent, 
        x = 0.5, y = 50, w = 0.3, h = 40,
        subStyle = {"popUp"},
        text = {"undo","paste", "sel", "close"},
        default = 0, 
    }
    
    for i, child in ipairs(self.inputMenu.child) do
        child.callback = function() 
            self:inputMenuAction(child.title) 
            tween.delay(0.2, function() 
                child.highlighted = false
                self.inputMenu.selected = nil
            end)
        end
        child.usesKeyboard = true
    end
    self.inputMenu:hide()
end
function TextEditor:openInputMenu()
    self.inputMenu.x = self.inputCursor.x
    self.inputMenu:show()
end
function TextEditor:closeInputMenu()
    self.inputMenu:hide()
end
function TextEditor:inputMenuAction(action)
    if action=="close" then --
        self:closeInputMenu()
    elseif action=="paste" then
        self:paste(pasteboard.text or "")
    elseif action=="sel" then
        self:enterSelectionMode()
    elseif action=="undo" then
        self:undo()
    end
end

-- ############## selection menu related stuff ##############

-- create a tool bar for selection
function TextEditor:selectionMenuInit()
    self.selectionMenu = Soda.Segment{
        parent = self.parent, 
        x = 0.5, y = 50, w = 0.5, h = 40,
        subStyle = {"popUp"},
        text = {Soda.symbol.delete,"undo","cut", "copy", "paste", Soda.symbol.widen},
        default = 0, 
    }
    for i, child in ipairs(self.selectionMenu.child) do
        child.callback = function() 
            self:selectionAction(child.title) 
            tween.delay(0.2, function() 
                child.highlighted = false
                self.selectionMenu.selected = nil
            end)
        end
        child.usesKeyboard = true
    end
    self.selectionMenu:hide()
end
-- decode the output of selection menu
function TextEditor:selectionAction(action)
    local start = self.selector.infCursor.index
    local stop = self.selector.supCursor.index

    if action==Soda.symbol.delete then 
        self:delete(start,stop)
    --[[
    elseif action==Soda.symbol.close then 
        self:enterInputMode()
          ]]
    elseif action=="undo" then 
        self:undo()
    elseif action=="cut" then 
        self:selectionCopy()
        self:delete(start,stop)
    elseif action=="copy" then 
        self:selectionCopy()
    elseif action==Soda.symbol.widen then --"<-->"
        self.selector:selectAll()
    elseif action=="paste" then 
        self:delete(start,stop)
        self:paste(pasteboard.text or "")
    end
end
function TextEditor:selectionCopy()
    local start = self.selector.infCursor.index
    local stop = self.selector.supCursor.index-1
    local txt = self.parent.text:sub(start,stop)
    pasteboard.text = txt
end
function TextEditor:split(start,stop)
    stop = stop or start
    local str = self.parent.text
    local txt1 = ""
    if start > 1 then txt1 = str:sub(1,start-1) end
    local txt2 = ""
    if stop <= str:len() then txt2 = str:sub(stop) end
    return txt1,txt2
end
function TextEditor:paste(txt)
    if self.selectionMode then self:enterInputMode() end
    local txt1,txt2 = self:split(self.inputCursor.index)
    -- txt = "|test|" -- debug
    txt = txt1 .. txt .. txt2
    self.parent:inputString(txt)
end
function TextEditor:delete(start,stop)
    self:enterInputMode()
    local txt1,txt2 = self:split(start,stop)
    local txt = txt1 .. txt2
    self.parent:inputString(txt)
end
function TextEditor:undo()
    local func = self:popUndo()
    if func then 
        local newTxt = self.parent.text
        func() 
        if self.parent.text == newTxt then
            -- one more time, to avoid the "nothing happened?" feeling
            func = self:popUndo()
            if func then func() end
        end
        self.inputCursor:setFromPosition(self.inputCursor.x)
        self.selector.infCursor:setFromPosition(self.selector.infCursor.x)
        self.selector.supCursor:setFromPosition(self.selector.supCursor.x)
    end
end
-- ###############################################################################

-- a cursor object
-- can be a blinking cursor, or a cursor with a round tip
-- it is mainly a graphic object, plus a memory to store the current index
Cursor = class(Soda.Frame)
function Cursor:init(t)
    t.update = self.update -- because Frame.init erases this function otherwise
    Soda.Frame.init(self, t)
    -- the index is before the concerned character. It can be 1 char bigger that the string.
    self.index = self.parent.text:len() +1 -- default position is at string end
    self:update()
    self.sensor.extra = 20 -- make the sensor big enough to be draggable
    -- dragging the cursor is simple enough to be included in cursor itself
    self.sensor:onDrag(function(event) 
        if event.totalMove > 20 then self:setFromPosition(event.tpos.x) end
    end)
    self.sensor.doNotInterceptTouches = true -- let parent hear (for auto scrolling)
    self.debug = false -- for debugging
end

function Cursor:update()
    -- update position
    local x = self.parent.textX or 0 -- to avoid problem at init
    self.x = x + (self.index-1) * self.parent.characterW
end

function Cursor:setFromPosition(xpos)
    local x = self.parent.textX or 0 -- to avoid problem at init
    -- convert position into a char index
    local index = math.floor( (xpos - x) / self.parent.characterW + 1)
    self:setIndex(index)
end
function Cursor:setIndex(index)
    -- make sure the index is acceptable
    local maxIndex = self.parent.text:len() + 1
    if index > maxIndex then index = maxIndex end
    if index < 1 then index = 1 end
    -- this part is for there are 2 cursors blocking each other
    if self.infLimit then
        local infLimit = self.infLimit.index + 1
        if index < infLimit then index = infLimit end
    end
    if self.supLimit then
        local supLimit = self.supLimit.index - 1
        if supLimit < index then index = supLimit end
    end
    -- apply this value
    self.index = index
    self:update()
end

function Cursor:draw()
    if self.hidden then return end
    self:update()
    pushStyle()
    rectMode(CENTER)
    noStroke()
    fill(0, 201, 255, 200)
    local p = self.parent
    clip( p.clipX-10, -10, p.clipW, p.clipH+20, true) -- the cursor should disappear too
    -- background(255, 216, 0, 83) -- debug
    if self.hTip then -- if this exists, draw a dot on the cursor
        rect(self.x,self.y, self.w, self.h)
        ellipse(self.x,self.y+self.hTip,15)
    else -- blink the cursor
        if (ElapsedTime/0.4)%2<1.3 then
            rect(self.x,self.y,self.w,self.h)
        end
    end
    if self.debug then
        -- show the index value
        textMode(CENTER)
        fill(0)
        fontSize(12)
        text(tostring(self.index),self.x,self.y+ (self.hTip or self.h/3))
    end
    clip()
    popStyle()
end

-- ###############################################################################

-- a selector object
-- it is mainly a graphic object, 2 cursors and a rectangle between
Selector = class(Soda.Frame)
function Selector:init(t)
    t.update = self.update -- because Frame.init erases this function otherwise
    Soda.Frame.init(self, t)
    self.sensor.enabled = false
    -- two cursors for selecting text
    local h=self.parent.h
    self.supCursor = Cursor{parent=self.parent,x=10,y=0, h=h, w=3, hTip=-h/2}
    self.infCursor = Cursor{parent=self.parent,x=10,y=0, h=h, w=3, hTip= h/2}
    -- these cursors are bound by each other
    self.supCursor.infLimit = self.infCursor
    self.infCursor.supLimit = self.supCursor
    -- on startup all cursors are hidden
    self._hide = Soda.Frame.hide
    self._show = Soda.Frame.show
    self:hide()
    self.debug = false -- for debugging
end
function Selector:selectAll()
    self.supCursor.index = self.parent.text:len() +1
    self.infCursor.index = 1
end
function Selector:hide()
    self:_hide()
    self.supCursor:hide()
    self.infCursor:hide()
end
function Selector:show()
    self:_show()
    self.supCursor:show()
    self.infCursor:show()
end
function Selector:update()
    self.supCursor:update()
    self.infCursor:update()
end

function Selector:setFromPosition(xpos)
    self.supCursor:setFromPosition(xpos)
    self.infCursor:setFromPosition(xpos)
    local txt = self.parent.text
    local start = self.infCursor.index
    self.infCursor.index = 1
    if start >1 then
        for i = start-1, 1, -1 do
            if txt:sub(i,i) == " " then
                self.infCursor.index = i+1
                break
            end
        end
        
    end
    local stop = self.supCursor.index
    self.supCursor.index = txt:len()+1
    if stop < txt:len() then
        for i = stop+1, txt:len() do
            if txt:sub(i,i) == " " then
                self.supCursor.index = i
                break
            end
        end
    end
end

function Selector:draw()
    if self.hidden then return end
    self:update()
    pushStyle()
    noStroke()
    local x0 = self.infCursor.x
    local y0 = 0
    local x1 = self.supCursor.x
    local y1 = self.supCursor.h
    fill(0, 201, 255, 100)
    rectMode(CORNERS)
    local p = self.parent
    clip( p.clipX-10, 0, p.clipW, p.clipH, true)
    rect(x0,y0,x1,y1)
    clip()
    popStyle()
end

--# Slider
Soda.Slider = class(Soda.Frame)

function Soda.Slider:init(t)
  --  t.shape = Soda.line
    t.w = t.w or 300
    t.h = 60
    t.style = Soda.style.switch
    self.range = t.max - t.min
    self.value = t.start or t.min
    self.value = clamp(self.value, t.min, t.max)
    self.decimalPlaces = t.decimalPlaces or 0

    t.label = {x = 0, y = -0.001}
  --  t.shapeArgs = {x = 0, y = 20, h = 0}
    self.snapPoints = t.snapPoints or {}
    self.snapPos = {}
    Soda.Frame.init(self, t)

    self.knob = Soda.SliderKnob{
        parent = self, 
        x = 0, y = 0, w=35, h=35, 
        shape = Soda.ellipse, 
        style = Soda.style.switch, 
       -- highlightable = true,
        shadow = true
    }
    
    self.valueLabel = Soda.Frame{
        parent = self,
        style = Soda.style.switch,
        x = -0.001, y = -0.001,
        title = string.format("%."..self.decimalPlaces.."f", self.value),
        label = {x = -0.001, y = -0.001}
    }
    
    self.sensor:onQuickTap(function(event) self:smallChange(event.tpos) end)
    
end

function Soda.Slider:setPosition()
    Soda.Frame.setPosition(self)
    self.sliderLen = self.w - 40
    self.shapeArgs.w = self.sliderLen    
    --calculate snap positions
    for i,v in ipairs(self.snapPoints) do
        self.snapPos[i] = 20 + self:posFromValue(v)
    end
    self.snapStep = lerp(5 / self.sliderLen, 0, self.range)
end

function Soda.Slider:smallChange(tpos)
    if tpos.x < self:left() + self.knob.x then
        self.value = math.max(self.min, self.value - 1 )
    else
        self.value = math.min(self.max, self.value + 1)
    end

    self.knob.x = 20 + self:posFromValue()
    self.valueLabel.title = tostring(self.value)
    self:callback(self.value)
end

function Soda.Slider:posFromValue(val)
    local val = val or self.value
    return ((val - self.min)/(self.max-self.min)) * self.sliderLen
end

function Soda.Slider:valueFromPos(x)
    
    self.value = round(lerp((x - 20) / self.sliderLen, self.min, self.max), self.decimalPlaces)
   for _,v in ipairs(self.snapPoints) do
      if math.abs(self.value - v) < self.snapStep then
        self.value = v 

            self.knob.x = 20 + self:posFromValue()
        end
    end
      

    if self.decimalPlaces == 0 then self.value = math.tointeger( self.value ) end
  --  self.title = tostring(self.value)
    self.valueLabel.title = string.format("%."..self.decimalPlaces.."f", self.value) --tostring(self.value)
end

function Soda.Slider:drawContent()
    local x, y = self:posFromValue() + 20, 20
--  Soda.setStyle(Soda.style.switch.shape)
    pushStyle()

    stroke(Soda.themes.default.blue)
    strokeWidth(2)
    line(20, y, x,y)
    noStroke()
    fill(Soda.themes.default.blue)
    for i,v in ipairs(self.snapPos) do
        if v > x then 
            --Soda.setStyle(Soda.style.switch.shape) 
            fill(Soda.themes.default.grey)

        end
     --   line(v,y-10,v,y+10)
        ellipse(v,y,8)
    end
 --   Soda.setStyle(Soda.style.switch.shape)

    stroke(Soda.themes.default.grey)

    strokeWidth(2)
    line(x, y, self.w-20,y)
    popStyle()
end

Soda.SliderKnob = class(Soda.Frame)

function Soda.SliderKnob:init(t)
    Soda.Frame.init(self,t)
    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    self.sensor:onDrag(function(event) self:move(event.touch) end)
end

function Soda.SliderKnob:setPosition()
    Soda.Frame.setPosition(self)
    self.x = 20 + self.parent:posFromValue()
end

function Soda.SliderKnob:touched(t, tpos)
    if self.sensor:touched(t, tpos) then return true end
end
function Soda.SliderKnob:move(t)
    if t.state == BEGAN then
        self.touchId = t.id
        self.highlighted = true
        --self:keyboardHideCheck()
    end
    self.x = clamp(self.x + t.deltaX * math.min(1, (t.deltaX * 0.5)^ 2),20,20 + self.parent.sliderLen)
    self.parent:valueFromPos(self.x)
    if t.state == ENDED then
        self.highlighted = false
        self.parent:callback(self.parent.value)
    end
end   

--# Selector
Soda.Selector = class(Soda.Button) --press deactivates its siblings

function Soda.Selector:init(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.label = t.label or { x=0.5, y=0.5}
    t.highlightable = true
    t.subStyle = t.subStyle or {"button"}
   Soda.Frame.init(self, t)

    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    self.sensor:onQuickTap(function(event) 
        self:callback() 
        self.parent:selectFromList(self) 
    end)

end

--# Segment
Soda.Segment = class(Soda.Frame) --horizontally segmented set of selectors

function Soda.Segment:init(t)   
    t.h = t.h or 40
    Soda.Frame.init(self, t)
   -- self.mesh = {}
    local n = #t.text
    local w = 1/n
  --  local ww = 0.85/n --1/(n+0.5)
    local default = t.default or 1 --default to displaying the left-most panel
    for i=1,n do
        local shape = Soda.RoundedRectangle
        local corners, panel
        if i==1 then corners = 1 | 2
        elseif i==n then corners = 4 | 8
        else
            shape = Soda.rect
        end
        local x = (i-0.5)*w
        if t.panels then
            panel = t.panels[i]
            panel:hide() --hide the panel by default
        end

        local this = Soda.Selector{parent = self, idNo = i, title = t.text[i], x = x, y = 0.5, w = w, h=t.h, shape = shape, shapeArgs={corners=corners}, panel = panel, subStyle = t.subStyle}  --self.h * 0.5, w+++0.002

        if not t.noSelectionPossible and i==default then 

            self:selectFromList(this)
            --[[
            this.highlighted = true
            self.selected = this
            if this.panel then this.panel:show() end
              ]]
        end
        
    end
end






--# Scroll
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

--# ScrollShape
Soda.ScrollShape = class(Soda.Scroll) --scrolling inside a shape, eg a rounded rectangle

function Soda.ScrollShape:init(t)
    t.h = t.h or math.min(HEIGHT*0.8, #t.text * 20)
    t.shape = Soda.RoundedRectangle 
  --  self:storeParameters(t)
  --  self:setPosition()

    Soda.Scroll.init(self, t)
    
    self.image = image(self.w, self.h)
    setContext(self.image) background(255) setContext()
    self.shapeArgs.radius = t.shapeArgs.radius or 6
    self.shapeArgs.tex = self.image
    self.shapeArgs.resetTex = self.image
    
end

function Soda.ScrollShape:orientationChanged()
    Soda.Frame.orientationChanged(self)
    self.image = image(self.w, self.h)
   -- setContext(self.image) background(255) setContext()
    self.shapeArgs.tex = self.image
    self.shapeArgs.resetTex = self.image
end

function Soda.ScrollShape:draw(breakPoint)
    if breakPoint and breakPoint==self then return true end
    if self.hidden then return end
    
    if self.alert then
        Soda.darken.draw()
    end
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw()
    end
      
    self:updateScroll()

    if not breakPoint then
        --  tween.delay(0.001, function() self:drawImage() end)
        setContext(self.image)
        background(150, 180) --40,40 self.style.shape.stroke
        
        pushMatrix()
        resetMatrix()
        --if self.blurred then sprite(self.mesh[1].image, self.w*0.5, self.h*0.5, self.w, self.h) end
        translate(0, self.scrollY)
        self:drawImage()
        popMatrix()
        setContext()
    end
 
    pushMatrix()
    translate(self:left(), self:bottom())
    self:drawShape(self.styleList)
    popMatrix()
end

function Soda.ScrollShape:drawImage()

    for _, v in ipairs(self.child) do
        v:draw()
    end

end






--# TextScroll
Soda.TextScroll = class(Soda.Scroll) --smooth scrolling of large text files (ie larger than screen height)

function Soda.TextScroll:init(t)
   -- t.shape = t.shape or Soda.rect
    
    Soda.Scroll.init(self, t)

    self.content = ""
    self.characterW, self.characterH = self:getTextSize(self.style.textBox, "a") --Soda.style.textBox
    self:clearString()
    self:inputString(t.textBody or "")

end

function Soda.TextScroll:clearString()
    self.lines = {}
    self.chunk = {}
    self.cursorY = 0
    self.scrollHeight = 0    
end

function Soda.TextScroll:inputString(txt, bottom)
    --split text into lines and wrap them
  --  local lines = {}
    self.chunk = {}
    local boxW = (self.w//self.characterW)-2 --how many characters can we fit in?
    for lin in txt:gmatch("[^\n\r]+") do
      --  local prefix = ""
        while lin:len()>boxW do --wrap the lines
            local truncate = lin:sub(1, boxW)
            local wrap,_ = truncate:find("(%W)%w-$")
            self.lines[#self.lines+1] = lin:sub(1, wrap)
            lin = lin:sub(wrap+1) 
          --  prefix = "  "    
        end
        self.lines[#self.lines+1] = lin
    end
    self.scrollHeight = #self.lines * self.characterH
    if bottom then 
        --self.scrollY = self.scrollHeight -self.h 

        self.scrollVel = ((self.scrollHeight -self.h) - self.scrollY ) * 0.07

    end
    --put lines back into chunks of text, 10 lines high each
    local n = #self.lines//10
    for i = 0,n do
        local start = (i * 10)+1
        local stop = math.min(#self.lines, start + 9) --nb concat range is inclusive, hence +9
        self.chunk[#self.chunk+1] = {y = self.h - (stop * self.characterH), text = table.concat(self.lines, "\n", start, stop)} --self.cursorY + 
    end
  --  print(#self.lines, #self.chunk)
   -- self.cursorY = self.scrollHeight
end

function Soda.TextScroll:drawContent()
    
    self:updateScroll()
    pushStyle()
    Soda.setStyle(self.style.textBox)
    --self:setStyle(self.styleList, "textBox")
    textMode(CORNER)
    textAlign(LEFT)
    --[[

    translate(self:left(),self:bottom())--+self.scrollY
    self:drawShape(Soda.style.default)
      ]]
    pushMatrix()
    local mm = modelMatrix()
    translate(10, self.scrollY)

    clip(mm[13]+2, mm[14]+2, self.w-4, self.h-4) --nb translate doesnt apply to clip. 
    
    --calculate which chunks to draw
    local lineStart = math.max(1, math.ceil(self.scrollY/self.characterH))
    local chunkStart = math.ceil(lineStart * 0.1)
    -- if CurrentOrientation == PORTRAIT or CurrentOrientation == PORTRAIT_UPSIDE_DOWN then d
    local n = math.min(#self.chunk, chunkStart + 5)
    for i = chunkStart, n, 1 do
        text(self.chunk[i].text, 0, self.chunk[i].y)
    end
    clip()
    popStyle()
  popMatrix()
    
end

--# List
Soda.List = class(Soda.ScrollShape)

function Soda.List:init(t)
    if type(t.text)=="string" then --can also accept a comma-separated list of values instead of a table
        local tab={}
        for word in t.text:gmatch("(.-),%s*") do
            tab[#tab+1] = word
        end
        t.text = tab
    end
    t.scrollHeight = #t.text * 40
    t.h = math.min(t.h or t.scrollHeight, t.scrollHeight)
    Soda.ScrollShape.init(self, t)
    for i,v in ipairs(t.text) do
        local number, panel = ""
        if t.enumerate then number = i..") " end
        
        if t.panels then
            panel = t.panels[i]
            panel:hide() --hide the panel by default
        end

        local item = Soda.Selector{parent = self, idNo = i, title = number..v, label = {x = 10, y = 0.5}, subStyle = {"listItem"}, shape = Soda.rect, highlightable = true, x = 0, y = -0.001 - (i-1)*40, w = 1, h = 42, panel = panel} --label = { text = v, x = 0, y = 0.5}, title = v,Soda.rect

        item.sensor.doNotInterceptTouches = true
 
        if t.default and i==t.default then
          --  item.highlighted = true
            self:selectFromList(item)
        end
    end
    self.sensor:onDrag(function(event) self:verticalScroll(event.touch, event.tpos) end)
end

function Soda.List:clearSelection()
    if self.selected then 
        self.selected.highlighted = false 
        if self.selected.panel then self.selected.panel:hide() end
    end
    self.selected = nil
end

--- a factory for dropdown lists

Soda.DropdownList = class()

function Soda.DropdownList:init(t)
    local parent = t.parent or nil
    self.default = t.default or ""
    self.button = Soda.Button{
        parent = parent, x = t.x, y = t.y, w = t.w, h = t.h,
        title = "\u{25bc} "..t.title..": "..self.default,
        subStyle = {"listItem"},
        label = {x = 10, y = 0.5}
    }

    local callback = t.callback or null
    
    self.title = t.title
    
    self.list = Soda.List{
        parent = parent,
        hidden = true,
        x = t.x, y = self.button:bottom() - t.parent.h, w = t.w, h = self.button:bottom(),
        text = t.text,   
        panels = t.panels, 
        default = t.default,  
        enumerate = t.enumerate,
        callback = function(this, selected, txt) 
            self.button.title = "\u{25bc} "..t.title..": "..txt
            self.button:setPosition() --to recalculate left-justified label
            this:hide() 
            callback(this, selected, txt)
        end
    } 

    
    self.button.callback = function() self.list:toggle() end --callback has to be outside of constructor only when two elements' callbacks both refer to each-other.

end

function Soda.DropdownList:clearSelection() 
    self.list:clearSelection() 
    self.button.title = "\u{25bc} "..self.title..": "..self.default
    self.button:setPosition() --to recalculate left-justified label
end

function Soda.DropdownList:deactivate()
    self.button:deactivate()
end

function Soda.DropdownList:activate()
    self.button:activate()
end

--# Windows
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
