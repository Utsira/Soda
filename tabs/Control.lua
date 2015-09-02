Soda.Control = class(Soda.Frame)

function Soda.Control:init(t)
    t.shape = Soda.RoundedRectangle
    t.shapeArgs = {radius = 25}
    t.label = {x=0.5, y=-20, text = t.title}
    t.shadow = true
    Soda.Frame.init(self, t)
    --[[
    self.mesh = {
        Soda.Mesh{parent = self, label = {x=0.5, y=-20, text = t.title}},
      --  Soda.Label{parent = self, x=0.5, y=-20, style = Soda.style.switch, text = t.title}, --style = style = Soda.style.dark, 
        Soda.Mesh{parent = self, style = t.style or Soda.style.borderless, shape = Soda.roundedRect, shapeArgs = t.shapeArgs or {r = 25}, mask = t.blurred }, --, label = , 
        
        } --
    if t.blurred then
    self.mesh[3] = Soda.Blur{parent=self, mask = self.mesh[2]}
    end
    table.insert( self.mesh, Soda.Shadow{parent = self, mask = self.mesh[2]})
      ]]
end
