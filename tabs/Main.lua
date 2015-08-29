-- Soda

-- Use this function to perform your initial setup
function setup()
    strokeWidth(2)
    print("centre=", CENTER)
    print("corner=", CORNER)
    box = Soda.Control{title = "Settings", x = 0.5, y = 0.5, w = 0.8, h = 0.4} --320
      --  instruction = Label(instruction, x+20, y+160, 640, 120),
     --   field = TextField(textfield, x+20, y+80, 640.0, 40, default, 1, test_Clicked),

         ok = Soda.Button{parent = box, title = "OK", x = 20, y = 20, w = 0.3, h = 40, callback = function() alert("ok") end}
        cancel = Soda.Button{parent = box, title = "Cancel", style = Soda.style.warning, x = -20, y = 20, w = 0.3, h = 40}
       choose = Soda.Segment{parent = box, text = {"Several different","options", "to choose", "between"}, x=0.5, y=0.6, w=0.8, h = 40} --"options", 
       switch = Soda.Switch{parent = box, title = "Wings fall off", x = 20, y = -20}

end

function draw()
    drawing()
end

function drawing(exception)
    background(40, 40, 50)
    sprite("Dropbox:mountainScape2", WIDTH*0.5, HEIGHT*0.5, WIDTH, HEIGHT)
    box:draw(exception)
end

function touched(t)
    box:touched(t)
end

