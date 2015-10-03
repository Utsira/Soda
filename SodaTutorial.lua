
--# Welcome
function setupUI()
    overview{content = [[
    
    This is a tutorial that introduces the basic features of Soda.
    
    When you're ready to start the tutorial, press "Begin Tutorial".
    ]], 
    ok = "Begin Tutorial",
    callback = function() stepSelector.list:selectFromList(stepSelector.list.child[2]) end}
end

--# HelloWorld
function setupUI()
    --all Soda elements take a table of keys as their arguments
    --in Lua, if a function's sole argument is a table or a string,
    --you can omit the enclosing () and just use "" or, in this case, {}
    
    Soda.Window{  --Soda.Window is a basic window, with rounded corners and a title.
        title = "Hello World", --title at the top of the window
        --when coordinates are between 0 and 1, they represent proportions of the parent
        --and the drawing mode is set to CENTER 
        --as there is no parent here, they are proportions of the entire screen:
        x=0.5, --Horizontally, the window is centred,
        y=-0.001, --And as we can't write -0, we fix it to the top edge with -0.001
        w=0.7, --Its dimensions cover 70% of the screen's width
        h=0.51, --and just over half of its height
    }
    --the advantage of making all coordinates relative to a parent (in this case the screen)
    --is that elements automatically resize when device orientation changes.
    --try flipping your device now.
end

--# SpecialEffects
function setupUI()
    --special effects
    Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 

        blurred = true, --add a blurred effect
    
        shadow = true, --add a drop shadow
    
        --the Style tab of the Soda library contains the Soda.style table 
        -- this defines what colours, fonts, line widths etc the buttons are drawn with.
        --if you don't supply a "style" parameter, the buttons are drawn with Soda.style.default
     
    }
end
--# Parenthood
function setupUI()
    --ok lets add some buttons to our window.
    --we need to make the window the parent of all the elements it contains
    --to do this, we need a handle to refer to it by.
    --as Soda automatically remembers all elements you create, this handle should be a local variable, not global
    --lets call our window "panel"
    local panel = Soda.Window{ --give parent a local handle, in this case "panel", to define children
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, 
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
    --lets make our button do something

    --to do this, we use the callback parameter, and assign it a function.
    --A question mark button is something you press when you want help, so we're going to make it open
    --the help file for Soda using openURL. 

    --lets define our openHelp function:

function openHelp()
    openURL("https://github.com/Utsira/Soda/blob/master/README.md", true) 
end
    
function setupUI()

    local panel = Soda.Window{ 
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, 
    }
    
    -- now we make the callback attribute point to the openHelp function (nb the openHelp function can be defined anywhere in our code, it doesn't have to be above the button definition, or in the same tab)
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = openHelp --note that when we point to a function like this, we just use the function name. Do not add () or the function will be triggered when we define the button, instead of when the button is pressed
    }
    --You can use this button if you want to check anything in the documentation. Check that it works now.
end
--# Panels
function setupUI()
    --Our window is looking a little bare still. Lets start adding some panels.
    local panel = Soda.Window{ 
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, 
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = openHelp --nb this still works, even though openHelp is in another tab
    }
    
    --this panel will eventually allow for the user to enter details about themselves, a user account. 
    --I'm calling it accountPanel.
    local accountPanel = Soda.Frame{ --Frame is a basic holder for other elements
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, -- a 10 pixel border, except at the top (to give room for the Window title and query button)
        shape = Soda.RoundedRectangle, subStyle = {"translucent"}, --omit shape to make the frame invisible
        shapeArgs = {radius = 16} --set the radius to be a little smaller than the parent window
    }
    
end
--# TextEntry
function setupUI()
    --Lets add a text entry box to our user account panel
    local panel = Soda.Window{ 
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, 
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = openHelp
    }
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
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
function setupUI()
    --Lets make our text entry box do something, so that the user knows her input has been accepted
    local panel = Soda.Window{ 
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, 
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = openHelp
    }
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
        shapeArgs = {radius = 16} 
    }
    
    --just as we did with the query button, we're going to add a callback to text entry.
    --this time however, instead of pointing to a predefined function, 
    --the callback itself will be a function. Nesting a function inside another block is called
    --a closure. 
    
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
                ok = "\u{4e86}\u{89e3}", --by default, the ok button says "ok". We can override this with the ok parameter. Here I've set it to the Japanese for "ok"
                blurred = true --add some lovely blurriness
            }
        end
    }
    
end
--# DropdownList
function setupUI()
    --Lets add a dropdown list to our accountPanel
    local panel = Soda.Window{ 
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, 
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = openHelp
    }
    
    --account panel
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
        shapeArgs = {radius = 16} 
    }
    
    --text entry:
    Soda.TextEntry{
        parent = accountPanel, 
        x = 10, y = -60, w = -10, h = 40,
        title = "User name:",
        default = "Enter name", 
        callback = function(self, inkey) 
            Soda.Alert{ 
                title = "User name registered as \n"..inkey,
                ok = "Got it", 
                blurred = true 
            }
        end
    }
    
    --and, our dropdown list:
    Soda.DropdownList{
        parent = accountPanel,
        --we want it to tuck in below the text entry box, with a 10 pixel gap
        --so, y = -60 (the top of the textbox) -40 (height of text box) -10(gap between boxes) = -110
        x = 10, y = -110, w = -10, h=40, 
        title = "Favourite fruit",
    
        --we pass "text" an array of strings for each item in the list
        text = {"Apples", "Oranges", "Pears", "Bananas", "Strawberries", "Jack Fruit", "Dorian", "Paw paw"},
        
        --list callbacks return 3 values: self, the selected item, and the label text of the selected item
        callback = function(self, selected, txt)
            Soda.Alert{
                title = txt.." are not\nthe only fruit"
            }
        
        end
    }
end
--# AnotherButton
function setupUI()
    --Lets add a reset button to clear the values that the user has entered
    
    local panel = Soda.Window{ 
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, 
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = openHelp
    }
    
    --account panel
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
        shapeArgs = {radius = 16} 
    }
    
    --The reset button will need to be able to access the textentry and dropdown list elements, so both of these now need handles:
    local userName = Soda.TextEntry{
        parent = accountPanel, 
        x = 10, y = -60, w = -10, h = 40,
        title = "User name:",
        default = "Enter name", 
        callback = function(self, inkey) 
            Soda.Alert{ 
                title = "User name registered as \n"..inkey,
                ok = "Got it", 
                blurred = true 
            }
        end
    }
    
    --dropdown list:
    local faveFruit = Soda.DropdownList{
        parent = accountPanel,
        x = 10, y = -110, w = -10, h=40, 
        title = "Favourite fruit",
        text = {"Apples", "Oranges", "Pears", "Bananas", "Strawberries", "Jack Fruit", "Dorian", "Paw paw"},
        callback = function(self, selected, txt)
            Soda.Alert{
                title = txt.." are not\nthe only fruit"
            }       
        end
    }
    
    --our reset button
    Soda.Button{ --We're not using one of the presets, just a standard Soda.Button this time
        parent = accountPanel,
        x = -10, y = 10, h = 40, --lets put it in the bottom right corner
        title = "Reset",
    
        --as this could be wiping some data, let's make this button RED:
       subStyle = {"warning"},
    
        --and give the user a chance to cancel the operation, using an proceed/cancel 2 button alert:
        callback = function()
            Soda.Alert2{
                title = "This will reset the values\nentered in the account panel",
        
                --now we nest another callback inside the alert, to say what happens when the user selects "proceed":
                callback = function()
                    userName:inputString("") --blank the username
                    faveFruit:clearSelection() --and fave fruit
                end
                --this is one of the most powerful aspects of callbacks:
                --they store and remember the variables of the enclosing function (called "upvalues")
                --even the local variables, and can continue to access them after this function has ended.
                --Here userName and faveFruit are setupUI's local variables. Once setupUI has finished
                --executing, there's no way to access them. This stops our project's namespace geting too
                --cluttered, and stops us accidentally overwriting or reasigning them.
                --But the reset button can continue to access them, because it stores setupUI's local variables.
            }
        end
    }
    
end
--# Toggle
function setupUI()
    --Lets add a switch to toggle our entire interface on and off
    
    local panel = Soda.Window{ 
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, 
    }
    
    Soda.MenuToggle{ --menu toggle is a preset displaying the "hamburger" menu icon
    
        --no parent, top-level interface element
        x = -10, y = -10, --stick it in the top-right corner of the screen
    
        callback = function() panel:show(LEFT) end, 
        --we're going to use the :show(direction) method to make the entire interface appear.
        --direction indicates which side of the screen to animate from
        --omit direction to just have the panel appear without animation
    
        --toggles also have a callbackOff, fired when they're turned off:
        callbackOff = function() panel:hide(LEFT) end,
    
        --toggles are set to off by default. However, we want our panel to be visible at the start.
        --so we can override this with the "on" flag:
        on = true
    }
    --press the button to test!
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = openHelp
    }
    
    --account panel
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
        shapeArgs = {radius = 16} 
    }
    
    --text entry:
    local userName = Soda.TextEntry{
        parent = accountPanel, 
        x = 10, y = -60, w = -10, h = 40,
        title = "User name:",
        default = "Enter name", 
        callback = function(self, inkey) 
            Soda.Alert{ 
                title = "User name registered as \n"..inkey,
                ok = "Got it", 
                blurred = true 
            }
        end
    }
    
    --dropdown list:
    local faveFruit = Soda.DropdownList{
        parent = accountPanel,
        x = 10, y = -110, w = -10, h=40, 
        title = "Favourite fruit",
        text = {"Apples", "Oranges", "Pears", "Bananas", "Strawberries", "Jack Fruit", "Dorian", "Paw paw"},
        callback = function(self, selected, txt)
            Soda.Alert{
                title = txt.." are not\nthe only fruit"
            }       
        end
    }
    
    --reset button:
    Soda.Button{ 
        parent = accountPanel,
        x = -10, y = 10, h = 40, 
        title = "Reset",
       subStyle = {"warning"},
    
        callback = function()      
            Soda.Alert2{
                title = "This will reset the values\nentered in the account panel",
                callback = function()
                    userName:inputString("") 
                    faveFruit:clearSelection() 
                end
            }     
        end
    }
    
end
--# SegmentedButton
function setupUI()
    --Lets add a second panel, and a segmented button to switch between the panels.
    --Having different panels stops our interface from getting too cluttered
    local panel = Soda.Window{ 
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, 
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = openHelp
    }
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
        shapeArgs = {radius = 16} 
    }
    
    --this is a settings panel. Other than the handle, it is identical to the accountPanel   
    local settingsPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
        shapeArgs = {radius = 16} 
    }
    
    --now, to choose between the two panels (and stop them both appearing at once)
    --we'll add a segmented button
    Soda.Segment{
        parent = panel,
        x = 20, y = -70, w = -20, h = 40,
        text = {"Account details", "Settings"}, --like dropdownList, we pass "text" an array of strings. It contains the labels for each button segment
        panels = {accountPanel, settingsPanel}, --the panels we just defined, whch correspond to the labels in "text"
        defaultNo = 2 --display the second panel ("Settings") by default 
    }
    
    --our text entry box from the previous step:
    local userName = Soda.TextEntry{
        parent = accountPanel, 
        x = 10, y = -60, w = -10, h = 40,
        title = "User name:",
        default = "Enter name", 
        callback = function(self, inkey) 
            Soda.Alert{ 
                title = "User name registered as \n"..inkey,
                ok = "Got it", 
                blurred = true 
            }
        end
    }
    
    --the dropdown list:
    local faveFruit = Soda.DropdownList{
        parent = accountPanel,
        x = 10, y = -110, w = -10, h=40, 
        title = "Favourite fruit",
        text = {"Apples", "Oranges", "Pears", "Bananas", "Strawberries", "Jack Fruit", "Dorian", "Paw paw"},
        callback = function(self, selected, txt)
            Soda.Alert{
                title = txt.." are not\nthe only fruit"
            }       
        end
    }
    
    --reset button:
    Soda.Button{ 
        parent = accountPanel,
        x = -10, y = 10, h = 40, 
        title = "Reset",
       subStyle = {"warning"},
    
        callback = function()      
            Soda.Alert2{
                title = "This will reset the values\nentered in the account panel",
                callback = function()
                    userName:inputString("") 
                    faveFruit:clearSelection() 
                end
            }     
        end
    }
    --see how, when flicking back and forth between the panels, the states of the elements within those panels is retained
end
--# ScrollingThroughText
function setupUI()
    --Lets make our second panel a scrolling block of text
    
    local panel = Soda.Window{ 
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
        blurred = true, shadow = true, 
    }
    
    Soda.MenuToggle{ 
        x = -10, y = -10, 
        callback = function() panel:show(LEFT) end, 
        callbackOff = function() panel:hide(LEFT) end,
        on = true
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = openHelp
    }
    
    --2 panels plus the segmented selector
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
        shapeArgs = {radius = 16} 
    }
    
    --this time, the second panel will be a scrolling body of text. Codea's text command doesn't produce any output if it is bigger than either the width or height of the screen, so Soda TextWindow and TextScroll elements break large text bodies up into chunks
    local backStory = Soda.TextScroll{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
        shapeArgs = {radius = 16},
        textBody = 
[[
   
     
    
    OK, I'll talk! In third grade, I cheated on my history exam. 
                            
    In fourth grade, I stole my uncle Max's toupee and I glued it on my face when I was Moses in my Hebrew School play. 

    
    In fifth grade, I knocked my sister Edie down the stairs and I blamed it on the dog... 
    
    when my mom sent me to the summer camp for fat kids and then they served lunch I got nuts and I pigged out and they kicked me out! 
    
    
            [much later]
    
    ...but the worst thing I ever done: 
    
    I mixed up all this fake puke at home and then I went to this movie theater, hid the puke in my jacket, climbed up to the balcony and then, t-t-then, I made a noise like this: 
    
    hua-hua-hua-huaaaaaaa - 
    
    and then I dumped it over the side, all over the people in the audience. 
    
    And then, this was horrible, all the people started getting sick and throwing up all over each other. And I never felt so bad in my entire life!]]
    }
    
    Soda.Segment{
        parent = panel,
        x = 20, y = -70, w = -20, h = 40,
        text = {"Account details", "Life story"}, 
        panels = {accountPanel, backStory}, 
        defaultNo = 2
    }
    
    --text entry:
    local userName = Soda.TextEntry{
        parent = accountPanel, 
        x = 10, y = -60, w = -10, h = 40,
        title = "User name:",
        default = "Chunk", 
        callback = function(self, inkey) 
            Soda.Alert{ 
                title = "User name registered as \n"..inkey,
                ok = "Got it", 
                blurred = true 
            }
        end
    }
    
    --dropdown list:
    local faveFruit = Soda.DropdownList{
        parent = accountPanel,
        x = 10, y = -110, w = -10, h=40, 
        title = "Favourite fruit",
        text = {"Apples", "Oranges", "Pears", "Bananas", "Strawberries", "Jack Fruit", "Dorian", "Paw paw", "Babe Ruth"},
        defaultNo = 9
    }
    
    --reset button:
    Soda.Button{ 
        parent = accountPanel,
        x = -10, y = 10, h = 40, 
        title = "Truffle Shuffle",
       subStyle = {"warning"},
    
        callback = function()      
            Soda.Alert2{
                title = "This will reset the values\nentered in the account panel",
                callback = function()
                    userName:inputString("") 
                    faveFruit:clearSelection() 
                end
            }     
        end
    }
end
--# ThrowSomeShapes
function setupUI()
    --Finally, let's tweak the shape of our main window slightly. We're going to set the shapeArgs attribute so that only the bottom corners of the window are rounded
    local panel = Soda.Window{ 
        title = "Tutorial", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 
    
        blurred = true, 
        shadow = true, 

        
        --you can pass a table of arguments to the shape function, such as choosing which corners will be rounded
        --Corners are numbered 1,2,4,8 starting in bottom-left and proceeding clockwise. Defaults to 15 (all corners). Use bitwise operators to set. eg to only round the bottom corners set this to `1 | 8` (1 or 8). To round all but the top-right corner, use `~4` (not 4)
        shapeArgs = { corners = 1 | 8} --only round bottom corners
    }
    
    Soda.MenuToggle{ 
        x = -10, y = -10, 
        callback = function() panel:show(LEFT) end, 
        callbackOff = function() panel:hide(LEFT) end,
        on = true
    }
    
    Soda.QueryButton{
        parent = panel, 
        x = 10, y = -10,
        callback = openHelp
    }
    
    --2 panels plus the segmented selector
    
    local accountPanel = Soda.Frame{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
        shapeArgs = {radius = 16} 
    }
    
    --text scroll
    local backStory = Soda.TextScroll{
        parent = panel,
        x = 10, y = 10, w = -10, h = -60, 
        shape = Soda.RoundedRectangle, subStyle = {"translucent"},
        shapeArgs = {radius = 16},
        textBody = 
[[
   
     
    
    OK, I'll talk! In third grade, I cheated on my history exam. 
                            
    In fourth grade, I stole my uncle Max's toupee and I glued it on my face when I was Moses in my Hebrew School play. 

    
    In fifth grade, I knocked my sister Edie down the stairs and I blamed it on the dog... 
    
    when my mom sent me to the summer camp for fat kids and then they served lunch I got nuts and I pigged out and they kicked me out! 
    
    
            [much later]
    
    ...but the worst thing I ever done: 
    
    I mixed up all this fake puke at home and then I went to this movie theater, hid the puke in my jacket, climbed up to the balcony and then, t-t-then, I made a noise like this: 
    
    hua-hua-hua-huaaaaaaa - 
    
    and then I dumped it over the side, all over the people in the audience. 
    
    And then, this was horrible, all the people started getting sick and throwing up all over each other. And I never felt so bad in my entire life!]]
    }
    
    Soda.Segment{
        parent = panel,
        x = 20, y = -70, w = -20, h = 40,
        text = {"Account details", "Life story"}, 
        panels = {accountPanel, backStory}, 
        defaultNo = 2
    }
    
    --text entry:
    local userName = Soda.TextEntry{
        parent = accountPanel, 
        x = 10, y = -60, w = -10, h = 40,
        title = "User name:",
        default = "Chunk", 
        callback = function(self, inkey) 
            Soda.Alert{ 
                title = "User name registered as \n"..inkey,
                ok = "Got it", 
                blurred = true 
            }
        end
    }
    
    --dropdown list:
    local faveFruit = Soda.DropdownList{
        parent = accountPanel,
        x = 10, y = -110, w = -10, h=40, 
        title = "Favourite fruit",
        text = {"Apples", "Oranges", "Pears", "Bananas", "Strawberries", "Jack Fruit", "Dorian", "Paw paw", "Babe Ruth"},
        defaultNo = 9
    }
    
    --reset button:
    Soda.Button{ 
        parent = accountPanel,
        x = -10, y = 10, h = 40, 
        title = "Truffle Shuffle",
       subStyle = {"warning"},
    
        callback = function()      
            Soda.Alert2{
                title = "This will reset the values\nentered in the account panel",
                callback = function()
                    userName:inputString("") 
                    faveFruit:clearSelection() 
                end
            }     
        end
    }
end

--# AndFinally
function setupUI()
    Soda.Window{
    y = 0.75,
    title = [[ 
     
In the final step of this
tutorial you will see the Main 
tab which has the hooks needed
to connect Soda to your own
projects
    ]]
    }
end

--# Main
-- Template for projects using Soda

assert(SodaIsInstalled, "Set Soda as a dependency of this project") --produces an error if Soda not a dependency

displayMode(OVERLAY)
displayMode(FULLSCREEN)

function setup()
    Soda.setup()
    --do your setting up here:
    tutorial()
end

function draw()
    --do your updating here
    
    --end of updating
    
    pushMatrix()
    Soda.camera() --this scrolls the screen to stop the keyboard covering textEntry fields
    Soda.drawing()
    popMatrix()
end

function Soda.drawing(breakPoint) --the breakPoint variable stops a blurred window itself from being incorporated into the blurred effect: it ensure only things under the blurred area get drawn.
    
    --in order for gaussian blur to work, do all your drawing here
    background(40, 40, 50)
    sprite("Cargo Bot:Game Area", WIDTH*0.5, HEIGHT*0.5, WIDTH, HEIGHT)   
    pushStyle()
    Soda.setStyle(Soda.style.default.text)
    fontSize(40)
    text("Output\narea", WIDTH * 0.5, HEIGHT * 0.75)
    popStyle()
    --end of your drawing
    
    Soda.draw(breakPoint) --pass the breakPoint variable
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

--template ends
function setupUI()
    Soda.Window{
    y = 0.75, w = 0.4, h = 0.4,
    title = "Main",
    content = 
[[This can be used as a template
for the Main tab in your own
projects running Soda. It contains
all the hooks that you need to
connect Soda into the setup, draw,
touched, keyboard, and 
orientationChanged routines.
    ]]
    }
end

--# TutorialInterface
function tutorial()
    --  parameter.watch("#Soda.items")
    local steps = listProjectTabs() --get the steps of the tutorial
    table.remove(steps) --remove this tab
    local bookmark = readLocalData("bookmark", 1) --remember last tutorial step looked at
    --grab the names of each tutorial step
    local stepNames = {}
    for i,v in ipairs(steps) do
        stepNames[i] = v:gsub("(%w)(%u)", "%1 %2") --insert spaces into tabnames 
    end
    
    local codeWindow = Soda.TextWindow{ 
        shapeArgs = {corners = 2 | 4, radius = 25}, --just round the top corners
      --  subStyle = {"translucent"},
        blurred = true,
        x = 0, y = 0, w = 1, h = 0.5,
        title = "",
        textBody = "",
    }
    
    stepSelector = Soda.DropdownList{
        parent = codeWindow,
        shapeArgs = {radius = 20},
        x = 0.5, y = -5, w = 400, h = 40,
        title = "Tutorial Step",
        text = stepNames, 
        default = bookmark, --default to the last item looked at
        enumerate = true, --automatically numbers the steps (requires Soda 0.4)
        callback = function(self, obj)  
            saveLocalData("bookmark", obj.idNo) --save user's place in tutorial
            local code = readProjectTab(steps[obj.idNo])
            codeWindow:clearString()
            codeWindow:inputString(code)   --place new code in code window  
            while #Soda.items>1 do --remove all Soda interface elements except for the code window
                table.remove(Soda.items)
            end       
            tween.delay(0.001, function() 
                loadstring(code)() --load the code
                setupUI() --run the code
            end) 
        end
    }
end
