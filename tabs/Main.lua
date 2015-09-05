-- Soda
displayMode(OVERLAY)
displayMode(FULLSCREEN)
-- Use this function to perform your initial setup
-- 

function setup()
    parameter.watch("#Soda.items")
    Soda.Assets()
    Soda.theme = Soda.themes.default
    strokeWidth(2)
    textAlign(CENTER)
    textMode(CENTER)
    rectMode(CENTER)
    --[[
    print("centre=", CENTER) --2
    print("corner=", CORNER) --0
    print("left", LEFT) --0
    print("right", RIGHT) --1
      ]]
    demo2()
    profiler.init()
end

function draw()
    drawing()
    profiler.draw()
end

function drawing(breakPoint)
    background(40, 40, 50)
    if not isKeyboardShowing() then
        Soda.UIoffset = Soda.UIoffset * 0.9
        Soda.keyboardEntity = nil --catch when user presses "hide keyboard key"
    end
    translate(0, Soda.UIoffset)
    sprite("Dropbox:mountainScape2", WIDTH*0.5, HEIGHT*0.5, WIDTH, HEIGHT)
    for i,v in ipairs(Soda.items) do --draw most recent item last
        if v.kill then
            table.remove(Soda.items, i)
        else
            if v:draw(breakPoint) then return end
        end
    end
end

function touched(t)
    local tpos = vec2(t.x, t.y-Soda.UIoffset)
    for i = #Soda.items, 1, -1 do --test most recent item first
        local v = Soda.items[i] 
        if v:touched(t, tpos) then return end
    end
end

function keyboard(key)

    if Soda.keyboardEntity then
        Soda.keyboardEntity:keyboard(key)
    end
end

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
