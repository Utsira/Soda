Soda = {}

function Soda.setup()
    --  parameter.watch("#Soda.items")
    parameter.watch("Soda.UIoffset")
    Soda.Assets()
    Soda.theme = Soda.themes.default
    
    textAlign(CENTER)
    rectMode(CENTER)

end

function Soda.camera()
    if Soda.device.current then
        translate(Soda.device.offset.x, Soda.device.offset.y)
    end
    if not isKeyboardShowing() then
        Soda.UIoffset = Soda.UIoffset * 0.9
    end
    translate(0, Soda.UIoffset)
end

function Soda.draw(breakPoint)
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

Soda.device = { 
    name = {"iPhone4", "iPhone5", "iPhone6", "iPhone6+", "iPad"},
    size = {vec2(480, 320), vec2(568, 320),vec2(667, 375),vec2(736, 414),vec2(1024, 768)}, --x and y are width and height in landscape
    ratio = {0.5, 0.6, 0.7, 0.75, 1} --aprox ratio of width, rounding up
}

function Soda:setDevice(sel)    
    if sel.idNo == 5 then --selected iPad
        Soda.device.current = nil
    else
        Soda.device.current = sel.idNo
    end
    Soda.orientationChanged(CurrentOrientation)
end

function Soda.orientationChanged(ori)
    if Soda.device.current then
        local size = Soda.device.size[Soda.device.current]
        local iPadSize = Soda.device.size[5]
        if ori == LANDSCAPE_LEFT or ori == LANDSCAPE_RIGHT then
            WIDTH = size.x
            HEIGHT = size.y
        else
            WIDTH = size.y
            HEIGHT = size.x  
            local z = iPadSize.y
            iPadSize.y = iPadSize.x
            iPadSize.x = z      
        end
        
        Soda.device.offset = (iPadSize - size)*0.5        
    end
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
        len = edge * size --proportional length
    end --nb defer if size is negative
    if len then
        local half = len * 0.5
        if loc%1==0 and loc>=0 then
            pos = loc + half --standard coord
        elseif loc<0 then
            pos = edge - half + loc --negative coord
        else
            pos = edge * loc --proportional coord
        end
    else --negative size
        if loc%1==0 and loc>=0 then 
            len = edge - loc + size --loc and size describing the two edges
            pos = loc + len * 0.5
        elseif loc>0 then 
            pos = edge * loc --proportional loc coord
            local x2 = edge + size
            len = (x2 - pos) * 2
        else
            alert("negative length must be coupled with positive position")
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
