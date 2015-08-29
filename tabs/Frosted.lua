Soda.Frosted = class(Soda.Blur)

function Soda.Frosted:init(t)
    self.parent = t.parent
    self.falloff = 1
    self.off = 0
    self.draw = Soda.Frosted.firstPass
end

function Soda.Frosted:firstPass() --just run on first pass
    local p = self.parent
    self.draw = Soda.Frosted.secondPass
    self:setMesh()
    self.mesh.shader = shader(maskShader.vert, maskShader.frag)
    self.mesh.shader.texture2 = p.mesh[1].image[1]
    self.mesh:setRect(1, p.x, p.y, p.w, p.h)
    local d = math.max(p.w, p.h)
    local texW, texH = p.w/d, p.h/d
    local texX, texY = (1 - texW)/2, (1-texH)/2
   -- self.mesh:setRectTex(1, texX, texY, texW, texH)
end

function Soda.Frosted:secondPass() --second pass
    self.draw = Soda.Blur.draw
end

function Soda.Frosted:setImage() --this is only called on orientation changed
    self.draw = Soda.Frosted.firstPass
end

function Soda.Frosted:drawImage()
   -- self.draw = Soda.Frosted.firstPass
    pushMatrix()
    translate(-self.parent:left(), -self.parent:bottom())
    drawing(self.parent)
    popMatrix()
end

-- Mask Shader
-- by Yojimbo2000

--[[
function setup()
    centre = vec2(WIDTH, HEIGHT)/2
    
    --make blur image
    local imgBlur = readImage("Cargo Bot:Pack Hard")
    w,h = imgBlur.width, imgBlur.height
    local img1 = image(w ,h)
 
    local mBlur = mesh()
    mBlur.shader = shader("Filters:Blur")
    mBlur.shader.conPixel = vec2(1,1)/150
    mBlur.shader.conWeight = 1/9
    mBlur.texture = imgBlur
    mBlur:addRect(w*0.5,h*0.5,w,h)
  
    setContext(img1)
    mBlur:draw()

    --make mask image
    local img2 = image(w, h)
    local falloff = 50 --how thickly to feather the edges of the mask
    setContext(img2)
    noStroke()
    local diameter = math.min(w,h)
    local alpha = 255/ falloff
    for i = 1, falloff do
        fill(255,i*alpha) --grey value = brightness, alpha = opacity
        ellipse(w*0.5,h*0.5,diameter - i) --or whatever drawing you want your mask to be
    end
    setContext()
    
    --build mesh
    m = mesh()
    m.shader = shader(maskShader.vert, maskShader.frag)
    m.texture = img1
    m.shader.texture2 = img2 --nb note texture2 has to be set differently
    m:addRect(centre.x, centre.y, w, h)
    
    pos = vec2(50, centre.y) --some animation
    tween(5, pos, {x=WIDTH-50}, {easing = tween.easing.sineInOut, loop = tween.loop.pingpong})
end

function draw()
    background(40, 40, 50)
    sprite("Cargo Bot:Game Area", centre.x, centre.y)
    m:setRect(1,pos.x,pos.y,w,h)
    m:draw()   
end
  ]]

maskShader={
vert=[[
uniform mat4 modelViewProjection;

attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

// varying lowp vec4 vColor;
varying highp vec2 vTexCoord;

void main()
{
    // vColor = color;
    vTexCoord = texCoord;
    
    gl_Position = modelViewProjection * position;
}
]],
frag=[[
precision highp float;

uniform lowp sampler2D texture;
uniform lowp sampler2D texture2;

//varying lowp vec4 vColor;
varying highp vec2 vTexCoord;

void main()
{
    lowp vec4 col = (vec4(0.1, 0.1, 0.1, 0.) + texture2D( texture, vTexCoord )) * texture2D( texture2, vTexCoord ); 

    gl_FragColor = col;
}
]]
}