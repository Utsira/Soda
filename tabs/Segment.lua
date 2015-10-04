Soda.Segment = class(Soda.Frame) --horizontally segmented set of selectors

function Soda.Segment:init(t)   
    t.h = t.h or 40
    Soda.Frame.init(self, t)
   -- self.mesh = {}
    local n = #t.text
    local w = 1/n
  --  local ww = 0.85/n --1/(n+0.5)
    local default = t.default or 1 --default to displaying the left-most panel
    for i=1,n do
        local shape = Soda.RoundedRectangle
        local corners, panel
        if i==1 then corners = 1 | 2
        elseif i==n then corners = 4 | 8
        else
            shape = Soda.rect
        end
        local x = (i-0.5)*w
        if t.panels then
            panel = t.panels[i]
            panel:hide() --hide the panel by default
        end
<<<<<<< tabs/Segment.lua
        local this = Soda.Selector{parent = self, idNo = i, title = t.text[i], x = x, y = 0.5, w = w+0.002, h=t.h, shape = shape, shapeArgs={corners=corners}, panel = panel}  --self.h * 0.5, w++0.004
        
        if not t.noSelectionPossible and i==defaultNo then 
=======
        local this = Soda.Selector{parent = self, idNo = i, title = t.text[i], x = x, y = 0.5, w = w, h=t.h, shape = shape, shapeArgs={corners=corners}, panel = panel}  --self.h * 0.5, w+++0.002
        
        if not t.noSelectionPossible and i==default then 
>>>>>>> tabs/Segment.lua
            self:selectFromList(this)
            --[[
            this.highlighted = true
            self.selected = this
            if this.panel then this.panel:show() end
              ]]
        end
        
    end
end

<<<<<<< tabs/Segment.lua



=======
>>>>>>> tabs/Segment.lua
