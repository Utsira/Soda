Soda.Gaussian = class() --a component for nice effects like shadows and blur
--Gaussian blur
--adapted by Yojimbo2000 from http://xissburg.com/faster-gaussian-blur-in-glsl/ 

function Soda.Gaussian:setImage()
    local p = self.parent
    
    local ww,hh = p.w * self.falloff, p.h * self.falloff -- shadow image needs to be larger than the element casting the shadow, in order to capture the blurry shadow falloff
    self.ww, self.hh = ww,hh
 
    local d = math.max(ww, hh)
    local blurRad = smoothstep(d, math.max(WIDTH, HEIGHT)*1.5, 60) * 1.5
    local aspect = vec2(d/ww, d/hh) * blurRad --work out the inverse aspect ratio
   -- print(p.title, "aspect", aspect)

    local downSample = 0.25 

    local dimensions = vec2(ww, hh) * downSample --down sampled
    
    local blurTex = {} --images
    local blurMesh = {} --meshes
    for i=1,2 do --2 passes, one for horizontal, one vertical
        blurTex[i]=image(dimensions.x, dimensions.y)
        local m = mesh()
        m.texture=blurTex[i]
        m:addRect(dimensions.x/2, dimensions.y/2,dimensions.x, dimensions.y)
        m.shader=shader(Soda.Gaussian.shader.vert[i], Soda.Gaussian.shader.frag)
      --  blurred[i].shader.am = falloff
        m.shader.am = aspect
        blurMesh[i] = m
    end
    local imgOut = image(dimensions.x, dimensions.y)
    pushStyle()
    pushMatrix()
    setContext(blurTex[1])

    scale(downSample)

    self:drawImage()
    popMatrix()
    popStyle()   
    
    setContext(blurTex[2])
    blurMesh[1]:draw() --pass one
    setContext(imgOut)
    blurMesh[2]:draw() --pass two, to output
    setContext()

    return imgOut
end

function Soda.Gaussian:draw()
    local p = self.parent
    self.mesh:setRect(1, p.x + self.off, p.y - self.off, self.ww, self.hh)
    self.mesh:draw()
end

---------------------------------------------------------------------------

Soda.Blur = class(Soda.Gaussian)

function Soda.Blur:init(t)
    self.parent = t.parent
    self.falloff = 1
    self.off = 0
    self:setMesh()
  --  self.image = image(self.parent.w * 0.25, self.parent.h * 0.25)
  --  self.draw = self.setMesh --
end

function Soda.Blur:draw() end

function Soda.Blur:setMesh() 
   --     self.draw = null
    self.image = self:setImage()
    self.parent.shapeArgs.tex = self.image
    self.parent.shapeArgs.resetTex = self.image
end

function Soda.Blur:drawImage()
    pushMatrix()

    translate(-self.parent:left(), -self.parent:bottom())
 
    Soda.drawing(self.parent) --draw all elements to the blur image, with the parent set as the breakpoint (so that the parent window itself does not show up in the blurred image)
    popMatrix()
end

---------------------------------------------------------------------------

Soda.Shadow = class(Soda.Gaussian)

function Soda.Shadow:init(t)
    self.parent = t.parent

     self.falloff = 1.3
    self.off = math.max(2, self.parent.w * 0.015, self.parent.h * 0.015)
   -- print(self.parent.title, "offset", self.off)
    self.mesh = mesh()
    self.mesh:addRect(0,0,0,0)
    self:setMesh()
end

function Soda.Shadow:setMesh()
    self.mesh.texture = self:setImage()
   -- self.mesh:setRect(1, self.parent.x + self.off,self.parent.y - self.off,self.ww, self.hh)   --nb, rect is set in draw function, for animation purposes
end

function Soda.Shadow:drawImage()
    pushStyle()
    pushMatrix()

    translate((self.ww-self.parent.w)*0.45, (self.hh-self.parent.h)*0.45)
    self.parent:drawShape({Soda.style.shadow})
    popMatrix()

    popStyle()
end

Soda.Gaussian.shader = {
vert = { -- horizontal pass vertex shader
[[
uniform mat4 modelViewProjection;
uniform vec2 am; // ammount of blur, inverse aspect ratio (so that oblong shapes still produce round blur)
attribute vec4 position;
attribute vec2 texCoord;
 
varying vec2 vTexCoord;
varying vec2 v_blurTexCoords[14];
 
void main()
{
    gl_Position = modelViewProjection * position;
    vTexCoord = texCoord;
    v_blurTexCoords[ 0] = vTexCoord + vec2(-0.028 * am.x, 0.0);
    v_blurTexCoords[ 1] = vTexCoord + vec2(-0.024 * am.x, 0.0);
    v_blurTexCoords[ 2] = vTexCoord + vec2(-0.020 * am.x, 0.0);
    v_blurTexCoords[ 3] = vTexCoord + vec2(-0.016 * am.x, 0.0);
    v_blurTexCoords[ 4] = vTexCoord + vec2(-0.012 * am.x, 0.0);
    v_blurTexCoords[ 5] = vTexCoord + vec2(-0.008 * am.x, 0.0);
    v_blurTexCoords[ 6] = vTexCoord + vec2(-0.004 * am.x, 0.0);
    v_blurTexCoords[ 7] = vTexCoord + vec2( 0.004 * am.x, 0.0);
    v_blurTexCoords[ 8] = vTexCoord + vec2( 0.008 * am.x, 0.0);
    v_blurTexCoords[ 9] = vTexCoord + vec2( 0.012 * am.x, 0.0);
    v_blurTexCoords[10] = vTexCoord + vec2( 0.016 * am.x, 0.0);
    v_blurTexCoords[11] = vTexCoord + vec2( 0.020 * am.x, 0.0);
    v_blurTexCoords[12] = vTexCoord + vec2( 0.024 * am.x, 0.0);
    v_blurTexCoords[13] = vTexCoord + vec2( 0.028 * am.x, 0.0);
}]],
-- vertical pass vertex shader
 [[
uniform mat4 modelViewProjection;
uniform vec2 am; // ammount of blur
attribute vec4 position;
attribute vec2 texCoord;
 
varying vec2 vTexCoord;
varying vec2 v_blurTexCoords[14];
 
void main()
{
    gl_Position = modelViewProjection * position;
    vTexCoord = texCoord;
    v_blurTexCoords[ 0] = vTexCoord + vec2(0.0, -0.028 * am.y);
    v_blurTexCoords[ 1] = vTexCoord + vec2(0.0, -0.024 * am.y);
    v_blurTexCoords[ 2] = vTexCoord + vec2(0.0, -0.020 * am.y);
    v_blurTexCoords[ 3] = vTexCoord + vec2(0.0, -0.016 * am.y);
    v_blurTexCoords[ 4] = vTexCoord + vec2(0.0, -0.012 * am.y);
    v_blurTexCoords[ 5] = vTexCoord + vec2(0.0, -0.008 * am.y);
    v_blurTexCoords[ 6] = vTexCoord + vec2(0.0, -0.004 * am.y);
    v_blurTexCoords[ 7] = vTexCoord + vec2(0.0,  0.004 * am.y);
    v_blurTexCoords[ 8] = vTexCoord + vec2(0.0,  0.008 * am.y);
    v_blurTexCoords[ 9] = vTexCoord + vec2(0.0,  0.012 * am.y);
    v_blurTexCoords[10] = vTexCoord + vec2(0.0,  0.016 * am.y);
    v_blurTexCoords[11] = vTexCoord + vec2(0.0,  0.020 * am.y);
    v_blurTexCoords[12] = vTexCoord + vec2(0.0,  0.024 * am.y);
    v_blurTexCoords[13] = vTexCoord + vec2(0.0,  0.028 * am.y);
}]]},
--fragment shader
frag = [[precision mediump float;
 
uniform lowp sampler2D texture;
 
varying vec2 vTexCoord;
varying vec2 v_blurTexCoords[14];
 
void main()
{
    gl_FragColor = vec4(0.0);
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 0])*0.0044299121055113265;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 1])*0.00895781211794;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 2])*0.0215963866053;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 3])*0.0443683338718;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 4])*0.0776744219933;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 5])*0.115876621105;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 6])*0.147308056121;
    gl_FragColor += texture2D(texture, vTexCoord         )*0.159576912161;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 7])*0.147308056121;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 8])*0.115876621105;
    gl_FragColor += texture2D(texture, v_blurTexCoords[ 9])*0.0776744219933;
    gl_FragColor += texture2D(texture, v_blurTexCoords[10])*0.0443683338718;
    gl_FragColor += texture2D(texture, v_blurTexCoords[11])*0.0215963866053;
    gl_FragColor += texture2D(texture, v_blurTexCoords[12])*0.00895781211794;
    gl_FragColor += texture2D(texture, v_blurTexCoords[13])*0.0044299121055113265;
}]]
}

