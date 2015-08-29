Soda.Control = class(Soda.Frame)

function Soda.Control:init(t)

    Soda.Frame.init(self, t)
    self.mesh = {
        Soda.Mesh{parent = self, style = Soda.style.borderless, shape = Soda.roundedRect, shapeArgs = {r = 25}, mask = true }, --, label = , 
        Soda.Mesh{parent = self, style = Soda.style.dark, label = {x=0.5, y=-20, text = t.title}}
      --  Soda.Label{parent = self, x=0.5, y=-20, style = Soda.style.switch, text = t.title}, --style = t.style, 
        } --
    self.mesh[3] = Soda.Frosted{parent=self}
    self.mesh[4] = Soda.Shadow{parent = self}
end
