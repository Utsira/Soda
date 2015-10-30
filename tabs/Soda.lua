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
