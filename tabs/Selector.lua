Soda.Selector = class(Soda.Button) --press deactivates its siblings

function Soda.Selector:init(t)
    t.shape = t.shape or Soda.RoundedRectangle
    t.label = t.label or { x=0.5, y=0.5}
    t.highlightable = true
    t.subStyle = t.subStyle or {"button"}
   Soda.Frame.init(self, t)

    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    self.sensor:onQuickTap(function(event) 
        self:callback() 
        self.parent:selectFromList(self) 
    end)

end
