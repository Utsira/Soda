function demo1()
    --[[
    You only need to give an element a temporary handle (a local variable name) if it is the parent of other elements, or you need to refer to it in a callback
    
    To define an element as a child of another, just add "parent = parentName" to its constructor
    
    x,y,w,h of elements are defined relative to their parents, according to 3 rules:
    
    1. if x,y,w, or h are positive integers, they behave as normal coordinates in rectMode CORNER (ie pixels from the origin)
    
    2. if x,y,w,or h are floating point between 0 and 1, they describe proportions in CENTER mode (x,y 0.5 is centred)
    
    3. if x,y,w, or h are negative, they describe distance in pixels from the TOP or RIGHT edge, as in CORNERS mode (ie, w,h become x2,y2 rather than width and height). if x and y are negative, they also behave the same way as w,h, describing the distance between the TOP/RIGHT edge of the parent, and the TOP/RIGHT edge of the child.
    
    the above 3 rules can be mixed together in one definition. eg a button fixed to the bottom right corner of its parent with a 20 pixel border, with a variable width of a quarter of its parent's width, and a fixed height of 40 pixels, would be: x = -20, y = 20, w = 0.25, h = 40.
      ]]
    
    --the main panel
    
    local panel = Soda.Control{ --give parent a local handle, in this case "panel", to define children, callbacks
        title = "Demonstration", 
        hidden = true, --not visible or active initially
        x=0.7, y=0.5, w=0, h=0.7, 
        blurred = true, style = Soda.style.darkBlurred, --gaussian blurs what is underneath it
        shapeArgs = { corners = 1 | 2} --only round left-hand corners
    }
    
    --2 navigation buttons to show & hide the main panel
    
    local menu = Soda.MenuButton{x = -20, y = -20} --a button to activate the above panel
    menu.callback = function() panel:show(RIGHT) menu:hide(RIGHT) end --n.b. if a callback refers to self, eg here "menu:hide", the callback has to be defined outside of the {} constructor
    
    Soda.BackButton{ --a button to hide "panel" and re-show "menu" button
        parent = panel, --a child of above "panel", therefore also inactive initially
        direction = RIGHT, --override the default left-pointing back icon
        x = -20, y = -20, --relative to edges of "panel"
        callback = function() panel:hide(RIGHT) menu:show(RIGHT) end --this callback does not reference itself, so can be included in {} constructor
    } 
    
    --three panels to hold various elements. All hidden initially.
    
    local buttonPanel = Soda.Frame{
        parent = panel,
        hidden = true,
        x = 20, y = 20, w = -20, h = -140, --20 pixel border on left, right, bottom
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
    }
    
    local textEntryPanel = Soda.Frame{
        parent = panel,
        hidden = true,
        x = 20, y = 20, w = -20, h = -140,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,     
    }
    
    local list = Soda.List{ --a vertically scrolling list of items
        parent = panel, 
        hidden = true,
        x = 20, y = 20, w = -20, h = -140,
        text = listProjectTabs(), -- text of list items taken from current project tabs
        callback = function (txt) Soda.TextWindow{title = txt, text = readProjectTab(txt)} end --a window for scrolling through large blocks of text
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
    
    --the textEntry panel
    
    Soda.TextEntry{ --text entry box
        parent = textEntryPanel,
        x = 10, y = -70, w = -10, h = 40,
        title = "Nick-name:",
        default = "Ice Man"
    }
    
    Soda.TextEntry{
        parent = textEntryPanel,
        x = 10, y = -130, w = -10, h = 40,
        title = "Name of 1st pet:",
    }
    
    local countyName = Soda.TextEntry{
        parent = textEntryPanel,
         x = 10, y = -10, w = -49, h = 40,
        shapeArgs = {corners = 1 | 2}, --only round left-hand corners
        title = "County:",
        default = "Select from list",
        inactive = true
    }
    
    local counties = Soda.List{
        parent = textEntryPanel,
        hidden = true,
        x = 10, y = 0, w = -10, h = -50,
        text = {"London", "Bedfordshire", "Buckinghamshire", "Cambridgeshire", "Cheshire", "Cornwall and Isles of Scilly", "Cumbria", "Derbyshire", "Devon", "Dorset", "Durham", "East Sussex", "Essex", "Gloucestershire", "Greater London", "Greater Manchester", "Hampshire", "Hertfordshire", "Kent", "Lancashire", "Leicestershire", "Lincolnshire", "Merseyside", "Norfolk", "North Yorkshire", "Northamptonshire", "Northumberland", "Nottinghamshire", "Oxfordshire", "Shropshire", "Somerset", "South Yorkshire", "Staffordshire", "Suffolk", "Surrey", "Tyne and Wear", "Warwickshire", "West Midlands", "West Sussex", "West Yorkshire", "Wiltshire", "Worcestershire", "Flintshire", "Glamorgan", "Merionethshire", "Monmouthshire", "Montgomeryshire", "Pembrokeshire", "Radnorshire", "Anglesey", "Breconshire", "Caernarvonshire", "Cardiganshire", "Carmarthenshire", "Denbighshire", "Kirkcudbrightshire", "Lanarkshire", "Midlothian", "Moray", "Nairnshire", "Orkney", "Peebleshire", "Perthshire", "Renfrewshire", "Ross & Cromarty", "Roxburghshire", "Selkirkshire", "Shetland", "Stirlingshire", "Sutherland", "West Lothian", "Wigtownshire", "Aberdeenshire", "Angus", "Argyll", "Ayrshire", "Banffshire", "Berwickshire", "Bute", "Caithness", "Clackmannanshire", "Dumfriesshire", "Dumbartonshire", "East Lothian", "Fife", "Inverness", "Kincardineshire", "Kinross-shire"},      
      --  alert = true
    }
    counties.callback = function(txt) countyName:inputString(txt) counties:hide() end --counties.selected.label.text
    
    Soda.DropdownButton{
        parent = textEntryPanel,
        style = Soda.style.default,
        x = -10, y = -10,
        shapeArgs = {corners = 4 | 8}, --only round the right-hand corners
        callback = function() counties:show() end
    }
    
    --the button panel:
    
    local div = 1/7
    
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
    
    Soda.CloseButton{
    parent = buttonPanel,
    x = div * 6, y = -20}
    
    Soda.Switch{
    parent = buttonPanel,
    x = 20, y = -80,
    title = "Turbo boost",
    }
    
    Soda.Switch{
    parent = buttonPanel,
    x = 20, y = -140,
    title = "Wings stay on the plane",
    on = true}
    
    Soda.Switch{
    parent = buttonPanel,
    x = 20, y = -200,
    title = "Afterburners",
    }
       
    Soda.Button{
    parent = buttonPanel, 
    title = "OK", 
    x = 20, y = 20, w = 0.4, h = 40}
    
    Soda.Button{
    parent = buttonPanel, 
    title = "Do not press", 
    style = Soda.style.warning, 
    x = -20, y = 20, w = 0.4, h = 40, 
    callback = 
        function()
            Soda.Alert1{ --an alert box with a single button
                title = "I warned you not to press this!", 
                y=0.6, 
                style = Soda.style.darkBlurred, blurred = true, 
                alert = true, --if alert=true, underlying elements are inactive and darkened until alert is dismissed
            }
        end
    }
    
end

function demo2()
     local t = ElapsedTime
    local box = --create a temporary handle "box" so that we can define other buttons as children
    Soda.Control{title = "Settings", w = 0.6, h = 0.6, blurred = true, style = Soda.style.darkBlurred} --
     --320
      --  instruction = Label(instruction, x+20, y+160, 640, 120),
     --   field = TextField(textfield, x+20, y+80, 640.0, 40, default, 1, test_Clicked),
    local menu = Soda.MenuButton{parent = box, x = 20, y= - 20, callback = function ()
        
    end}
      local   ok = Soda.Button{parent = box, title = "OK", x = 20, y = 20, w = 0.3, h = 40}
    
      local  warning = Soda.Button{parent = box, title = "Do not press", style = Soda.style.warning, x = -20, y = 20, w = 0.3, h = 40, callback = 
        function()
            Soda.Alert1{title = "CONGRATULATIONS!\n\nYou held out\n"..(ElapsedTime - t).." seconds", y=0.6, style = Soda.style.darkBlurred, blurred = true, alert = true}
        end} --blurred = true, alert = true,
    
    local  choose = Soda.Segment{parent = box, text = {"Several","options", "to choose", "between"}, x=0.5, y=-60, w=0.9, h = 40} --"options", 
    
    local   switch = Soda.Switch{parent = box, title = "Wings fall off", x = 20, y = -120}
    
  local list = Soda.List{parent = box, x = -20, y = -120, w = 0.4, h=0.5, text = {"Washington", "Adams", "Jefferson", "Madison", "Monroe", "Adams", "Jackson", "Van Buren", "Harrison", "Tyler", "Polk", "Taylor", "Fillmore", "Pierce", "Buchanan", "Lincoln", "Johnson", "Grant"} }
    
    local inkey = Soda.TextEntry{parent = box, title = "Nick-name:", x=20, y=80, w=0.7, h=40} 
end
