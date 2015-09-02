Soda.Segment = class(Soda.Frame) --horizontally segmented set of selectors

function Soda.Segment:init(t)   

    Soda.Frame.init(self, t)
   -- self.mesh = {}
    local n = #t.text
    local w = 1/n
  --  local ww = 0.85/n --1/(n+0.5)

    for i=1,n do
        local corners
        local shape = Soda.RoundedRectangle
        if i==1 then corners = 1 | 2
        elseif i==n then corners = 4 | 8
        else
            shape = Soda.rect
        end
       local x = (i-0.5)*w
        Soda.Selector{parent = self, title = t.text[i], x = x, y = 0.5, w = w+0.002, h=t.h, shape = shape, shapeArgs={corners=corners}}  --self.h * 0.5, w+0.001
            
    end
end

function Soda.Segment:toggleOthers(child)
    if self.selected then self.selected.highlighted = false end
    self.selected = child
end
