Soda.Segment = class(Soda.Frame)

function Soda.Segment:init(t)   

    Soda.Frame.init(self, t)
    self.mesh = {}
    local n = #t.text
    local w = 1/n
    local ww = 0.85/n --1/(n+0.5)

    for i=1,n do
        local edge
        local shape = Soda.roundedRect
        if i==1 then edge = LEFT
        elseif i==n then edge = RIGHT
        else
            shape = Soda.rect
        end
       local x = (i-0.5)*w
        Soda.SubSegment{parent = self, title = t.text[i], x = x, y = 0.5, w = ww, h=t.h, shape = shape, shapeArgs={edge=edge}}  --self.h * 0.5, 
            
    end
end

function Soda.Segment:toggleOthers(child)
    for i,v in ipairs(self.child) do
        if v == child then 
            self.selected = i
        else
            v.on = false 
            v.mesh[1]:unHighlight()
        end         
    end
end
