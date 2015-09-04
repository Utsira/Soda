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
    shadow = {shape = { fill = color(0, 90), stroke = color(0, 90)}}, --a special style used to produce shadows 20, 100
 textEntry = {fill = color(0), font = "Inconsolata", fontSize = 24}, --a special style for user input in text entry fields. Must be a fixed-width (monotype) font
}

function Soda.Assets()
    --used to darken underlying interface elements when alert flag is set.
    Soda.darken = mesh()
    local s = math.max(WIDTH, HEIGHT)
    Soda.darken:addRect(s/2, s/2, s, s)
    Soda.darken:setColors(color(0,128))
    
    --used to scroll up screen when keyboard appears
    Soda.UIoffset = 0
end

function Soda.setStyle(sty)
    for k,v in pairs(sty) do

        Soda[k](v)
    end
end

function Soda.fill(v)
    fill(v)
end

function Soda.stroke(v)
    stroke(v)
end

function Soda.font(v)
    font(v)
end

function Soda.fontSize(v)
    fontSize(v)
end

function Soda.textWrap()
    
end

function Soda.strokeWidth(v)
    strokeWidth(v)
end

function Soda.noFill()
    noFill()
end

function Soda.rect(t)
  --  rect(0, 0, self.w or self.parent.w, self.h or self.parent.h)
    rect(t.x, t.y, t.w, t.h)
end

function Soda.ellipse(t)
    ellipse(t.x, t.y, t.w)
 --   ellipse(0, 0, self.w or self.parent.w)
end

--[[
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
  ]]

--assume everything is rectMode centre (cos of mesh rect)
function Soda.parseCoord(v, len, origin, edge)
    local half = len * 0.5
    if v==0 or v>1 then return origin + v + half end --standard coordinate
    if v<0 then return edge - half + v end --eg WIDTH - 40
    return origin + (edge-origin) * v  --proportional
end

function Soda.parseSize(v, origin, edge)
    if v>=0 and v<=1 then return (edge-origin) * v end --v * edge
    return v
end

function null() end

function smoothstep(t,a,b)
    local a,b = a or 0,b or 1
    local t = math.min(1,math.max(0,(t-a)/(b-a)))
    return t * t * (3 - 2 * t)
end


function orientationChanged()
    for i,v in ipairs(Soda.items) do
        v:orientationChanged()
    end
    collectgarbage()
end