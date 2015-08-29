Soda.Mesh = class(Soda.Base)

function Soda.Mesh:init(t)
    self.parameters = t
    self.parent = t.parent
    self.style = t.style or Soda.style.default
    self.shape = t.shape or null
    self.shapeArgs = t.shapeArgs or {}
    self.label = t.label
    self.highlightable = t.highlightable
    self:setImage()
    if t.mask then
        self.draw = null
        self.setMesh = null
    else
         self:setMesh()  
    end
    
end

function Soda.Mesh:setImage()
    self:setPosition()
    self.image = {self:drawImage(self.style)}
    if self.highlightable then
        self.image[2] = self:drawImage(self.style.highlight, true)
    end
    
end


function Soda.Mesh:setPosition()
    
    local t = self.parameters
    local p = self.parent
    self.x = t.x or p.x
    self.y = t.y or p.y
    self.w = t.w or p.w
    self.h = t.h or p.h    
    
end


function Soda.Mesh:setMesh()

    local m=mesh()
    m.texture = self.image[1]

    local r = m:addRect(self.x, self.y, self.w, self.h) 
    self.mesh = m
   -- return m
end

function Soda.Mesh:setRect()
    
    --[[
    self.mesh:setRect(1,self.x, self.y, self.w, self.h) 
    self.mesh.texture = self.image[self.currentImage]
      ]]
end

function Soda.Mesh:drawImage(sty, highlight)
        local p = self.parent
    local x,y = p.x, p.y
    local w,h = p.w, p.h
    
    local img = image(w, h)
    setContext(img)
    pushStyle()

    self:setStyle(Soda.style.default.shape)
    self:setStyle(self.style.shape)
    self:setStyle(sty.shape)

    self:shape(self.shapeArgs, highlight)
    popStyle()

    pushStyle()

    if self.label then 
        self:setStyle(Soda.style.default.text)
        self:setStyle(self.style.text)
        self:setStyle(sty.text)
        self.label:draw(sty.text) 
    end
    
    popStyle()
    setContext()
    return img
end

function Soda.Mesh:draw()
    self.mesh:setRect(1, self.parent.x, self.parent.y, self.w, self.h)
    self.mesh:draw()
end

function Soda.Mesh:highlight()
    self.currentImage = math.min(2, #self.image)
    self.mesh.texture = self.image[self.currentImage]
end

function Soda.Mesh:unHighlight()
    self.currentImage = 1
    self.mesh.texture = self.image[self.currentImage]
end

--[[
function Soda.Frame:drawMovingParts(...)
    for _,m in ipairs({self.shadowMesh.mesh, self.mesh}) do
       -- m:setRect(1, self.x, self.y, self.w, self.h)
        m:draw()
    end
end
  ]]
