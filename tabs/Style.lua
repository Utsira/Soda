Soda.themes = {
default = { 
white = color(249, 248, 248, 240)  ,lightGrey = color(217, 200)  ,midGrey = color(69, 200)  , 
blue = color(56, 155, 252)  , darkBlue = color(34, 94, 153)  ,
black = color(0)  ,red = color(204, 41, 41)  ,darkGrey = color(40)  , darkTrans = color(40,40),  
grey = color(128, 128) }
}

Soda.style = {
    shadow = {shape = { fill = color(0, 90), stroke = color(0, 90)}  }, --a special style used to produce shadows 20, 100
    inactive = { shape = {stroke = "lightGrey"}, text = {fill = "lightGrey"} } --greyed out elements
}

Soda.style.default = {
    shape = {fill = "white",
        stroke = "lightGrey",
        strokeWidth = 2,
        -- highlight = "blue"
    },
    text = {
        fill = "darkGrey",
        font = "HelveticaNeue-Light",
        fontSize = 1},
    title = {
        fill = "blue",
        font = "HelveticaNeue",},

--substyles
    button = {
        text = {fill = "blue",
            font = "HelveticaNeue-Light"
            },
        shape = {},
        highlight = {
            text = { fill = "white"},
            shape = {fill = "blue", noStroke = true},
        }
    },

    listItem = {
        text = {fill = "darkGrey",
            },
        shape = {},
        highlight = {
            text = { fill = "white"},
            shape = {fill = "blue", noStroke = true},
        }
    },

    icon = {
        text = { fontSize = 1.25, fill = "white"},
        shape = {noFill = true, noStroke = true}, --
        highlight = {
            text = { fill = "black", fontSize = 1.25},
            shape = {fill = "blue", noStroke = true},
        }
    },

    darkIcon = {
        text = { fontSize = 1.25, fill = "white"},
        shape = {noFill = true, strokeWidth = 1, stroke = "white"}, --
        highlight = {
            text = { fill = "white", fontSize = 1.25},
            shape = {fill = "blue", noStroke = true},
        }
    },

    warning = {
        shape = {fill = "red",
            stroke = "midGrey",
            strokeWidth = 2
            },
        text = {fill = "white"},
        highlight = {
            text = {fill = "red"},
            shape = {fill = "white", stroke = "red"}
        }
    },
        
    transparent = {
        shape = {noFill = true},
        text = {},
        highlight = {
            shape = {fill = "lightGrey"},
            text = {fill = "darkGrey"}
        }
    },

    translucent = {
        shape = {fill = "darkTrans", stroke = "grey"},
        text = {},
        title = {fill = "darkBlue"}
    },

    blurred = { --this is set automatically when the blurred flag is true
        shape = {fill = (210), stroke = "midGrey"},
        text = {},
        title = {fill = "white"}
    },

    switch = {
        shape = {},
        text = {},
        highlight = {
            shape = {fill = "blue", noStroke = true},
            text = {}
            }
    },
--special
    textEntry = {font = "Inconsolata", fill = "black", fontSize = 1.2},
    textBox = {font = "Inconsolata", fill = "black", fontSize = 1},
}

Soda.symbol = {menu = "\u{2630}", back = "\u{ff1c}", forward = "\u{ff1e}", close = "\u{2715}", down = "\u{25bc}", gear = "\u{2699}", add = "\u{FF0B}", delete = "\u{232B}"}

function Soda.setStyle(sty)
    for k,v in pairs(sty) do
        if type(v)=="string" and Soda.theme[v] then
            Soda[k](Soda.theme[v])
        else
         local ok, err = xpcall(function() Soda[k](v) end, function(trace) return debug.traceback(trace) end) 
            if not ok then print(err) end
         --   Soda[k](v)
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
    fontSize(v*Soda.baseFontSize)
end

function Soda.textWrapWidth(v)
    textWrapWidth(v)
end

function Soda.textAlign(v)
    textAlign(v)
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
    rect(t.x, t.y, t.w+1, t.h+2)
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

