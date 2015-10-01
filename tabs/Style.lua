Soda.themes = {
default = { 
fill = color(255, 240)  ,stroke = color(152, 200)  ,stroke2 = color(69, 200)  , text = color(0, 97, 255)  ,
text2 = color(0)  ,warning = color(220, 0, 0)  ,darkFill = color(40, 40)  ,darkStroke = color(70, 128)  , 
darkStroke2 = color(20,20)  ,darkText = color(195, 223, 255) , grey = color(128, 128) }
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
    title = {text = {font = "HelveticaNeue"}, shape = {}},
    thickStroke = {shape = {fill = "fill", stroke = "stroke", strokeWidth = 10}, text = {}},
    borderless = {
        shape = {strokeWidth = 0},
        text = {fill = "fill"}},
        highlight = {shape = {}, text = {}},
    transparent = {
        shape = {noFill = true, --color(0,0),
                stroke = "darkStroke"}, --stroke = "stroke2"
        text = {fill = "fill"}, --fill = "darkText"
        highlight = { 
        shape = {fill = "darkText"},
        text = {} --fill = "stroke2"
        }
    },
    translucent = {
        shape = {fill = "darkFill", --color(255, 40),
                stroke = "stroke2"},
        text = {fill = "fill"}, -- fill = "darkText"
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
    textBox = {font = "Inconsolata", fontSize = 16}, --fill = color(29, 61, 31, 255), 
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
    inactive = {
        shape = { fill = "fill", stroke = "grey"},
        text = {fill = "grey"}
    }
}

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

function Soda.line(t)
    local hw, hh = t.w * 0.5, t.h * 0.5
    line(t.x - hw, t.y - hh, t.x + hw, t.y + hh)
end

function Soda.ellipse(t)
    ellipse(t.x, t.y, t.w)
 --   ellipse(0, 0, self.w or self.parent.w)
end

--Soda.setup()

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

