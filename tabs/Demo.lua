function demo1()
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

function demo2()
    
    --the main panel
    
    local panel = Soda.Control{ --give parent a local handle, in this case "panel", to define children, callbacks
        title = "Demonstration", 
        hidden = true, --not visible or active initially
        x=0.7, y=0.5, w=0, h=0.7, 
        blurred = true, style = Soda.style.darkBlurred, 
        shapeArgs = { corners = 1 | 2} --only round left-hand corners
    }
    
    --2 navigation buttons to show & hide the main panel
    
    local menu = Soda.MenuButton{x = -20, y = -20} --a button to activate the above panel
    menu.callback = function() panel:show(RIGHT) menu:hide(RIGHT) end --if callback refers to self, eg here "menu:hide" it has to be defined outside of the constructor
    
    Soda.BackButton{ --a button to hide "panel" and re-show "menu" button
        parent = panel, --a child of above "panel", therefore also inactive initially
        direction = RIGHT, --override the default left-pointing back icon
        x = -20, y = -20, --relative to edges of "panel"
        callback = function() panel:hide(RIGHT) menu:show(RIGHT) end --this callback does not reference self, so can be included in constructor
    } 
    
    --three panels to hold various elements
    
    local buttonPanel = Soda.Frame{
        parent = panel,
        hidden = true,
        x = 20, y = 20, w = -20, h = -140,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,
    }
    
    local textEntryPanel = Soda.Frame{
        parent = panel,
        hidden = true,
        x = 20, y = 20, w = -20, h = -140,
        shape = Soda.RoundedRectangle, style = Soda.style.translucent,     
    }
    
    local list = Soda.List{
        parent = panel, 
        hidden = true,
        x = 20, y = 20, w = -20, h = -140,
        text = listProjectTabs(), 
        callback = newWindow
    }
   -- list.callback = function(txt) Soda.TextWindow{title = txt, text = readProjectTab(txt)} end
    
    --a segmented button to choose between the above 3 panels
    
    Soda.Segment{
        parent = panel,
       -- x = 0.5, y = -80, w = 0.9,
        x = 20, y = -80, w = -20, h = 40,
        text = {"Buttons", "Text Entry", "Examine Source"},
        panels = {
        buttonPanel, textEntryPanel, list
        }
    }
    
    --the textEntry panel
    
    Soda.TextEntry{
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
         x = 90, y = -10, w = -10, h = 40,
        shapeArgs = {corners = 4 | 8},
        title = "",
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
    
    Soda.Button{
        parent = textEntryPanel,
        x = 10, y = -10, w = 81, h = 40,
        title = "County",
        shapeArgs = {corners = 1 | 2},
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
            Soda.Alert1{
                title = "I warned you not to press this!", 
                y=0.6, 
                style = Soda.style.darkBlurred, blurred = true, 
                alert = true, --if alert=true, underlying elements are inactive until alert is dismissed
            }
        end
    }
    
end

function newWindow(txt)
    local data = readProjectTab(txt)
   -- print(data)
    dialog = Soda.TextWindow{title = txt, text = data}
end
