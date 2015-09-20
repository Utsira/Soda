
--# Main
-- Soda Tutorial

displayMode(OVERLAY)
displayMode(FULLSCREEN_NO_BUTTONS )

function setup()
    Soda.setup()
    tutorial()
end

function draw()
    Soda.drawing()
end

function Soda.drawing(breakPoint) --in order for gaussian blur to work, do all your drawing here
    Soda.camera()
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
    stepFuncs = {Step1, Step2, Step3, Step4, Step5, Step6, Step7}
    stepTabs = {"Step1", "Step2", "Step3", "Step4", "Step5", "Step6", "Step7"}
    
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
        text = {"1: Hello World", "2: A window", "3: Special effects", "4: Let's get styling", "5: Throw some shapes", "6: Parenthood","7: Callbacks"},
        callback = function(self, obj)  
            codeWindow:inputString(readProjectTab(stepTabs[obj.idNo]))     
            while #Soda.items>1 do
                table.remove(Soda.items)
            end
            tween.delay(0.001, function() stepFuncs[obj.idNo]() end)
        end
    }

end

--# Step1
function Step1()
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

--# Step2
function Step2()
    --shapes and presets
    --Soda.Window is a basic window with a title. We're not going to set a shape argument, because Window automatically selects the Soda.roundedRectangle shape. We can override this if we want.
    Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 

    }
end

--# Step3
function Step3()
    --special effects
    Soda.Window{ 
        title = "Hello World", 
        x=0.5, y=-0.001, w=0.7, h=0.51, 

        blurred = true, --add a blurred effect
        --note that because the background is slightly translucent, we can see the underlying area through the blur, creating an interesting glow effect
        shadow = true, --add a drop shadow

    }
end
--# Step4
function Step4()
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
--# Step5
function Step5()
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
--# Step6
function Step6()
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
--# Step7
function Step7()
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

