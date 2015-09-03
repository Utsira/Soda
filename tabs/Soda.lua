Soda = {}

Soda.items = {}
--font("HelveticaNeue-Light")
Soda.style = {
    default = {
        shape = {fill = color(255),
            stroke = color(152, 152, 152, 255),
            strokeWidth = 2},
        text = {
            fill = color(0, 97, 255, 255),
            font = "HelveticaNeue-Light",
            fontSize = 20},
        highlight = {
            text = { fill = color(255)},
            shape = {fill = color(0, 97, 255, 255),},
        }
    },
    borderless = {
        shape = {strokeWidth = 0},
        text = {fill = color(255)}},
        highlight = {shape = {}, text = {}},
    transparent = {
        shape = {noFill = true, --color(0,0),
                stroke = color(20, 20)},
        text = { fill = color(255)},
        highlight = { 
        shape = {fill = color(150, 201, 255, 100)},
        text = {fill = color(140)}
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
        shape = {stroke = color(180, 180, 180, 255)},
        text = {fill = color(255)},
        highlight = {
             text = {fill = color(255)},
             shape = {fill = color(0, 97, 255, 255)}
            }
    },
    darkBlurred = {
        shape = { stroke = color(70, 128),
                fill = color(210),
                strokeWidth = 1},
        text = { fill = color(255)},
        highlight = {
            shape = {fill = color(200, 223, 255, 255)},
            text = {fill = color(60, 60, 60, 255)}
        }
    },
    dark = {
        shape = { stroke = color(70, 128),
                fill = color(40,40),
                strokeWidth = 1},
        text = { fill = color(255)},
        highlight = {
            shape = {fill = color(200, 223, 255, 255)},
            text = {fill = color(60, 60, 60, 255)}
        }
    },
    shadow = {shape = { fill = color(20, 100), stroke = color(20, 100)}} --a special style used to produce shadows
}

function Soda.Assets()
    --used to darken underlying interface elements when alert flag is set.
    local m = mesh()
    local img = image(1,1)
    setContext(img)
    background(0,128)
    setContext()
    m.texture = img
    local s = math.max(WIDTH, HEIGHT)
    m:addRect(s/2, s/2, s, s)
    Soda.darken = m
end

function Soda:fill(v)
    fill(v)
end

function Soda:stroke(v)
    stroke(v)
end

function Soda:font(v)
    font(v)
end

function Soda:fontSize(v)
    fontSize(v)
end

function Soda:textWrap()
    
end

function Soda:strokeWidth(v)
    strokeWidth(v)
end

function Soda:noFill()
    noFill()
end

Soda.Base = class()

function Soda.Base:init(t)
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

function Soda:rect(t)
  --  rect(0, 0, self.w or self.parent.w, self.h or self.parent.h)
    rect(t.x, t.y, t.w, t.h)
end

function Soda:ellipse(t)
    ellipse(t.x, t.y, t.w)
 --   ellipse(0, 0, self.w or self.parent.w)
end
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

local function rRect(x,y,w,h,r,edge) --X,edgeY
    local edge = edge or 15
    local widthTrim, heightTrim = 1,1
    local edgeX, edgeY = r,r
 --   if edgeX then widthTrim = 1 end
 --   if edgeY then heightTrim = 1 end
    if edge & 5 == 5 then --both left and right are rounded
        widthTrim = 2
    elseif edge & RIGHTEDGE == RIGHTEDGE then --right NOT left are rounded
        edgeX = 0
    end
    if edge & 10 == 10 then --top and bottom rounded
        heightTrim = 2
    elseif edge & TOPEDGE == TOPEDGE then --top rounded NOT bottom
        edgeY = 0
    end
    --[[
    local edgeX = edgeX or 0
    edgeX = (1-edgeX) * r
    local edgeY = edgeY or 1
    edgeY = edgeY * r
      ]]
    translate(x,y)
    rect(edgeX,0,w-widthTrim*r,h)
    rect(0,edgeY,w,h-heightTrim*r)
    ellipse(r  ,r,r*2)
    ellipse(w-r,r,r*2)
    ellipse(r  ,h-r,r*2)
    ellipse(w-r,h-r,r*2)
    translate(-x,-y)
end

function Soda:roundedRect(t) --edge, x, y, w, h, r: omit edge for all corners rounded. edge = RIGHT rounded right edge. edge = LEFT for rounded left edge.
    local w = t.w or self.w or self.parent.w
    local h = t.h or self.h or self.parent.h
    local r = t.r or 6
    local x = t.x or 0
    local y = t.y or 0
    local oldFill = color( fill() )
    local oldStroke = color( stroke() )
    local s = strokeWidth()
    local ds = math.max(s-1,0)
    pushStyle()
   -- resetStyle()
    if s==0 then
        rRect(x,y,w,h,r,t.edge) --X, t.edgeY
    else
        noStroke()
        fill(oldStroke)
        rRect(x,y,w,h,r,t.edge) --X, t.edgeY
        fill(oldFill)
        rRect(x+ds, y+ds, w-ds*2, h-ds*2, r-ds,t.edge) --X, t.edgeY
    end
    popStyle()
end

function Soda.Base:setStyle(sty)
    for k,v in pairs(sty) do
        --[[
        local str = tostring(v)
        if not str:match("%(.-%)") then str = "("..str..")" end
       -- print(str)
        loadstring(k..str)()
          ]]
        Soda[k](self, v)
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

function Soda.Base:parseSize(v, origin, edge)
    if v>=0 and v<=1 then return (edge-origin) * v end --v * edge
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

    self.w = self:parseSize(w, edge.x)
    self.h = self:parseSize(h, edge.y)
    self.x = self:parseCoord(x, self.w, origin.x, edge.x)
    self.y = self:parseCoord(y, self.h, origin.y, edge.y)
end
  ]]


function orientationChanged()
    for i,v in ipairs(Soda.items) do
        v:orientationChanged()
    end
    collectgarbage()
end