Soda.Control = class(Soda.Frame)

function Soda.Control:init(t)

    Soda.Frame.init(self, t)
    self.mesh = {
        Soda.Mesh{parent = self, style = t.style, shape = Soda.roundedRect, shapeArgs = {r = 25}, label = Soda.Label{parent = self, x=0.5, y=-20, style = t.style, text = t.title}, mask = true}, --
        }
    self.mesh[2] = Soda.Frosted{parent=self}
    self.mesh[3] = Soda.Shadow{parent = self}
end
