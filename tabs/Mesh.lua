Soda.Mesh = class(Soda.Base)

function Soda.Mesh:init(t)
 --   self.parameters = t
    Soda.Base.init(self, t)
    --self.parent = t.parent
    self.style = t.style or Soda.style.default
    self.shape = t.shape or null
    self.shapeArgs = t.shapeArgs or {}
    if t.label then 
        self.label.w, self.label.h = self:getTextSize()  
    end
   -- self.highlightable = t.highlightable
    self:setImage()
    if t.mask then
        self.draw = null
        self.setMesh = null
      --  self.setRect = null
    else
         self:setMesh()  
    end
    
end

function Soda.Mesh:setImage()
    self.image = {self:drawImage(self.style)}
    if self.highlightable then
        self.image[2] = self:drawImage(self.style.highlight)
    end   
end

function Soda.Mesh:getTextSize()
    pushStyle()
    self:setStyle(Soda.style.default.text)
    self:setStyle(self.style.text)
    local w,h = textSize(self.label.text)
    popStyle()
    return w,h
end
    
function Soda.Mesh:setMesh()

    local m=mesh()
    m.texture = self.image[1]
    local p = self.parent
  --  local r = m:addRect(self.x, self.y, self.w, self.h) 
    m:addRect(p.x, p.y, p.w, p.h) 
    self.mesh = m
   -- return m
end

--[[
function Soda.Mesh:setRect()
    local p = self.parent
    self.mesh.texture = self.image[self.currentImage]
  --  self.mesh:setRect(1,p.x, p.y, p.w, p.h) 
end
  ]]

function Soda.Mesh:drawImage(sty)
        local p = self.parent
    local x,y = p.x, p.y
    local w,h = p.w, p.h
    
    local img = image(w, h)
    setContext(img)
    pushStyle()

    self:setStyle(Soda.style.default.shape)
    self:setStyle(self.style.shape)
    self:setStyle(sty.shape)

    self:shape(self.shapeArgs)
    popStyle()

    pushStyle()

    if self.label then 
        self:setStyle(Soda.style.default.text)
        self:setStyle(self.style.text)
        self:setStyle(sty.text)
         local x = self:parseCoord(self.label.x,self.label.w,0,w)
        local y = self:parseCoord(self.label.y,self.label.h,0,h)
        text(self.label.text, x,y)
    end
    
    popStyle()
    setContext()
    return img
end

function Soda.Mesh:draw()
    self.mesh:setRect(1, self.parent.x, self.parent.y, self.parent.w, self.parent.h)
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
