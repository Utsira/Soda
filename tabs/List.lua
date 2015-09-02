Soda.List = class(Soda.Segment)

function Soda.List:init(t)
    t.h = t.h or math.min(HEIGHT*0.8, #t.text * 20)
    Soda.Frame.init(self, t)
    self.mesh = {Soda.Mesh{parent = self}}
    for i,v in ipairs(t.text) do
        Soda.SubSegment{parent = self, title = v, style = t.style, shape = Soda.outline, shapeArgs = {edge = BOTTOMEDGE}, highlightable = true, x = 0, y = -i*40, w = 1, h = 40} --label = { text = v, x = 0, y = 0.5}, 
    end
end

function Soda.List:draw(exception)
    if self==exception then return true end

    if self.alert then
        pushStyle()
        noStroke()
        fill(0,128)
        rect(0,0,WIDTH,HEIGHT)
        popStyle()
    end
    --[[
    for i = #self.mesh, 1, -1 do
        self.mesh[i]:draw()
    end
      ]]
    
    pushMatrix()
    setContext(self.mesh[1].image[1])
    translate(-self:left(), -self:bottom())
    for _, v in ipairs(self.child) do
        v:draw()
    end
    setContext()
    popMatrix()
    self.mesh[1]:draw()
end
