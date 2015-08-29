Soda = {}

Soda.items = {}
--font("HelveticaNeue-Light")
Soda.style = {
    default = {
        shape = {fill = color(255),
            stroke = color(69, 69, 69, 255),
            strokeWidth = 2},
        text = {
            fill = color(0, 97, 255, 255),
            font = [["HelveticaNeue-Light"]],
            fontSize = 20},
        highlight = {
            text = { fill = color(255)},
            shape = {fill = color(0, 97, 255, 255),},
        }
    },
    warning = {
        shape = {fill = color(255,0,0, 255),
            stroke = color(69, 69, 69, 255),
            },
        text = {
            fill = color(255)},
        highlight = {
            shape = {fill = color(255)},
            text = { fill = color(255,0,0)}}
    },
    switch = {
        highlight = {
             text = { fill = color(0, 97, 255, 255),},
             shape = {fill = color(0, 255, 77, 255)}
            }
    },
--[[
    switchOn = {
        shape = {fill = color(0, 255, 77, 255)}}
  ]]
}
Soda.style.switch.shape, Soda.style.switch.text = Soda.style.default.shape, Soda.style.default.text
--[[
function Soda.fill(sty)
    fill(sty.fill)
end

function Soda.stroke(sty)
    stroke(sty.stroke)
end

function Soda.font(sty)
    font(sty.font)
end

function Soda.textColor
  ]]

Soda.Base = class()

function Soda.Base:init(t)
    self.parameters = t --remember initial settings
    for k,v in pairs(t) do
        self[k] = v
    end
end

function Soda.Base:bottom()
  --  if self.rectMode == CORNER then return self.y end
    return self.y - self.h * 0.5
end

function Soda.Base:top()
   -- if self.rectMode == CORNER then return self.y + self.h end
    return self.y + self.h * 0.5
end

function Soda.Base:left()
  --  if self.rectMode == CORNER then return self.x end
    return self.x - self.w * 0.5
end

function Soda.Base:right()
   -- if self.rectMode == CORNER then return self.x + self.w end
    return self.x + self.w * 0.5
end

function Soda:rect()
    rect(0,0, self.w, self.h)
end

function Soda:ellipse()
    ellipse(self.w*0.5, self.h * 0.5, self.w)
end

local function rRect(x,y,w,h,r,edge) 
    local widthTrim = 2
    if edge then widthTrim = 1 end
    local edge = edge or 0
    edge = (1-edge) * r
    translate(x,y)
    rect(edge,0,w-widthTrim*r,h)
    rect(0,r,w,h-2*r)
    ellipse(r  ,r,r*2)
    ellipse(w-r,r,r*2)
    ellipse(r  ,h-r,r*2)
    ellipse(w-r,h-r,r*2)
    translate(-x,-y)
end

function Soda:roundedRect(t) --edge, x, y, w, h, r: omit edge for all corners rounded. edge = RIGHT hard right edge. edge = LEFT for hard left edge.
    local w = t.w or self.w
    local h = t.h or self.h
    local r = t.r or 6
    local x = t.x or 0
    local y = t.y or 0
    local oldFill = color( fill() )
    local oldStroke = color( stroke() )
    local s = strokeWidth()
    local ds = math.max(s-1,0)
    pushStyle()
   -- resetStyle()
    noStroke()
    fill(oldStroke)
    rRect(x,y,w,h,r,t.edge)
    fill(oldFill)
    rRect(x+ds, y+ds, w-ds*2, h-ds*2, r-ds,t.edge)
    popStyle()
end

function Soda.Base:setStyle(sty)
    for k,v in pairs(sty) do
        local str = tostring(v)
        if not str:match("%(.-%)") then str = "("..str..")" end
       -- print(str)
        loadstring(k..str)()
    end
end

function null() end

function smoothstep(t,a,b)
    local a,b = a or 0,b or 1
    local t = math.min(1,math.max(0,(t-a)/(b-a)))
    return t * t * (3 - 2 * t)
end

--assume everything is rectMode centre (cos of mesh rect)
function Soda.Base:parseCoord(v, len, origin, edge)
    local half = len * 0.5
    if v==0 or v>1 then return origin + v + half end --standard coordinate
    if v<0 then return edge - half + v end --eg WIDTH - 40
    return origin + (edge-origin) * v  --proportional
end

function Soda.Base:parseSize(v, edge)
    if v>=0 and v<=1 then return v * edge end
    return v
end

--[[
function Soda.Base:setPosition()
    local t = self.parameters
    local origin = vec2(0,0)
    local edge = vec2(WIDTH, HEIGHT)
    local w = t.w or 1
    local h = t.h or 1
    local x = t.x or 0.5
    local y = t.y or 0.5
    if self.parent then 
        origin = vec2(self.parent:left(), self.parent:bottom()) 
        edge = vec2(self.parent:right(), self.parent:top()) 
    end
    
 local ok, err = xpcall(function() self.w = self:parseSize(w, edge.x) end, function(trace) return debug.traceback(trace) end) 
    if not ok then print(err) end
    local ok, err = xpcall(function() self.h = self:parseSize(h, edge.y) end, function(trace) return debug.traceback(trace) end) 
    if not ok then print(err) end
    --self.w = self:parseSize(t.w, edge.x)
   -- self.h = self:parseSize(t.h, edge.y)
    self.x = self:parseCoord(x, self.w, origin.x, edge.x)
    self.y = self:parseCoord(y, self.h, origin.y, edge.y)
end
  ]]

function orientationChanged()
    for i,v in ipairs(Soda.items) do
        v:orientationChanged()
    end
end