Soda = {}

Soda.items = {}
--font("HelveticaNeue-Bold")
Soda.themes = {
default = { 
fill = color(255, 200)  ,stroke = color(152, 200)  ,stroke2 = color(69, 200)  , text = color(0, 97, 255)  ,
text2 = color(0)  ,warning = color(220, 0, 0)  ,darkFill = color(40, 40)  ,darkStroke = color(70, 128)  , 
darkStroke2 = color(20,20)  ,darkText = color(195, 223, 255)  }
}

Soda.style = {
    default = {
        shape = {fill = "fill",
            stroke = "stroke",
            strokeWidth = 2},
        text = {
            fill = "text",
            font = "HelveticaNeue-Light",
            fontSize = 20},
        highlight = {
            text = { fill = "fill"},
            shape = {fill = "text",},
        }
    },
    thickStroke = {shape = { strokeWidth = 10}, text = {}},
    borderless = {
        shape = {strokeWidth = 0},
        text = {fill = "fill"}},
        highlight = {shape = {}, text = {}},
    transparent = {
        shape = {noFill = true, --color(0,0),
                stroke = "stroke2"},
        text = { fill = "darkText"},
        highlight = { 
        shape = {fill = "darkText"},
        text = {fill = "stroke2"}
        }
    },
    translucent = {
        shape = {fill = color(255, 40),
                stroke = "stroke2"},
        text = {}, -- fill = "darkText"
        highlight = { 
        shape = {},--fill = "darkText"
        text = {}--fill = "stroke2"
        }
    },
    
    warning = {
        shape = {fill = "warning",
            stroke = "stroke2",
            },
        text = {
            fill = "fill"},
        highlight = {
            shape = {fill = "fill"},
            text = { fill = "warning"}}
    },

    switch = {
        shape = {stroke = "stroke"},
        text = {fill = "fill"},
        highlight = {
             text = {fill = "fill"},
             shape = {fill = "text"}
            }
    },
    darkBlurred = {
        shape = { stroke = "darkStroke",
                fill = color(210), --this darkens the blurred section showing through
                strokeWidth = 1},
        text = { fill = "fill"},
        highlight = {
            shape = {fill = "darkText"},
            text = {fill = "stroke2"}
        }
    },
    dark = {
        shape = { stroke = "darkStroke",
                fill = "darkFill",
                strokeWidth = 1},
        text = { fill = "darkText"},
        highlight = {
            shape = {fill = "darkText"},
            text = {fill = "stroke2"}
        }
    },
    shadow = {shape = { fill = color(0, 90), stroke = color(0, 90)}}, --a special style used to produce shadows 20, 100
    textEntry = {fill = color(0), font = "Inconsolata", fontSize = 24}, --a special style for user input in text entry fields. Must be a fixed-width (monotype) font
    textBox = {fill = color(29, 61, 31, 255), font = "Inconsolata", fontSize = 16},
    darkIcon = {
        shape = {noFill = true, strokeWidth = 1, stroke = "fill"}, 
        text = {fontSize = 26, 
            --font = "HelveticaNeue-Bold", 
            fill = "fill"},
        highlight = {
            shape = {fill = "text", stroke = "text"},
            text = {fill = "fill", fontSize = 26, 
                --font = "HelveticaNeue-Bold"
            }
        }
        },
    icon = {
        shape = {noFill = true, noStroke = true}, 
        text = {fontSize = 26, 
            --font = "HelveticaNeue-Bold", 
            fill = "text"},
        highlight = {
            shape = {fill = "text", noStroke = true},
            text = {fill = "fill", fontSize = 26, 
                --font = "HelveticaNeue-Bold"
            }
        }
    },
}

function Soda.Assets()
    --used to darken underlying interface elements when alert flag is set.
    Soda.darken.assets()
    
    --used to scroll up screen when keyboard appears
    Soda.UIoffset = 0
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

function Soda.setStyle(sty)
    for k,v in pairs(sty) do
        if type(v)=="string" and Soda.theme[v] then
            Soda[k](Soda.theme[v])
        else
        Soda[k](v)
        end
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

function Soda.noStroke()
    noStroke()
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
    if v>0 and v<=1 then return (edge-origin) * v end --v * edge
    return v
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


function orientationChanged()
    for i,v in ipairs(Soda.items) do
        v:orientationChanged()
    end
    collectgarbage()
end