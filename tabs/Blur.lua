Soda.Blur = class() --a component for nice effects like shadows and blur
--Gaussian blur
--adapted by Yojimbo2000 from http://xissburg.com/faster-gaussian-blur-in-glsl/ 

function Soda.Blur:setMesh()
    local p = self.parent
        local w,h = p.w,p.h
  --  local d = math.max(w,h) * falloff
    local ww,hh = w * self.falloff, h * self.falloff
    self.ww, self.hh = ww,hh
    local d = math.max(ww, hh)
    local blurRad = smoothstep(d, math.max(WIDTH, HEIGHT)*1.5, 60) * 1.5
    local aspect = vec2(d/ww, d/hh) * blurRad --work out the inverse aspect ratio
   -- print(p.title, "aspect", aspect)
    local x = p.x + self.off
    local y = p.y - self.off
   
   -- self.d = d
    pushStyle()
    pushMatrix()
    local downSample = 0.5 -- going down to 0.25 actually looks pretty good!
 --   local ww, hh = t.w * 1.3, t.h * 1.3

    local dimensions = {
    vec2(ww, hh), --full size
    vec2(ww, hh) * downSample --down sampled
    }
    blur = {} --images
    blurred = {} --meshes
    for i=1,2 do --2 passes, one for horizontal, one vertical
        blur[i]=image(dimensions[i].x, dimensions[i].y)
        blurred[i]=mesh()
        blurred[i].texture=blur[i]
        local j=3-i
        blurred[i]:addRect(dimensions[j].x/2, dimensions[j].y/2,dimensions[j].x, dimensions[j].y)
        blurred[i].shader=shader(Soda.Gaussian.vs[i], Soda.Gaussian.fs)
      --  blurred[i].shader.am = falloff
        blurred[i].shader.am = aspect
    end
    blur[3]=image(dimensions[1].x, dimensions[1].y)
    setContext(blur[1])
    self:drawImage()
    setContext(blur[2])
    blurred[1]:draw() --pass one, offscreen
    setContext(blur[3])
    blurred[2]:draw() --pass two
    setContext()
    local m = mesh()
    m.texture = blur[3]

    m:addRect(x,y,ww, hh)
    self.mesh = m
    popMatrix()
    popStyle()    
end

function Soda.Blur:setImage() end

-- function Soda.Blur:setRect() end

function Soda.Blur:draw()
    local p = self.parent
    self.mesh:setRect(1, p.x + self.off, p.y - self.off, self.ww, self.hh)
    self.mesh:draw()
end

Soda.Shadow = class(Soda.Blur)

function Soda.Shadow:init(t)
    self.parent = t.parent
     self.falloff = 1.3
    self.off = math.max(1.5, self.parent.w * 0.015, self.parent.h * 0.015)
    self:setMesh()    
end

function Soda.Shadow:drawImage()
    pushStyle()
    tint(20,100)
   -- spriteMode(CORNER)
    sprite(self.parent.mesh[1].image[1], self.ww * 0.5, self.hh * 0.5)
   -- sprite(self.parent.image[1])
    popStyle()
end


profiler={}

function profiler.init(quiet)    
    profiler.del=0
    profiler.c=0
    profiler.fps=0
    profiler.mem=0
    if not quiet then
        parameter.watch("profiler.fps")
        parameter.watch("profiler.mem")
    end
end

function profiler.draw()
    profiler.del = profiler.del +  DeltaTime
    profiler.c = profiler.c + 1
    if profiler.c==10 then
        profiler.fps=profiler.c/profiler.del
        profiler.del=0
        profiler.c=0
        profiler.mem=collectgarbage("count", 2)
    end
end

Soda.Gaussian = {
vs = { -- horizontal pass vertex shader
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
fs = [[precision mediump float;
 
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
shDefault={
vs=[[
uniform mat4 modelViewProjection;

attribute vec4 position;
attribute vec4 color;
attribute vec2 texCoord;

varying lowp vec4 vColor;
varying highp vec2 vTexCoord;

void main()
{
    vColor = color;
    vTexCoord = texCoord;
    
    gl_Position = modelViewProjection * position;
}
]],
fs=[[
precision highp float;

uniform lowp sampler2D texture;

varying lowp vec4 vColor;
varying highp vec2 vTexCoord;

void main()
{
    lowp vec4 col = texture2D( texture, vTexCoord ) * vColor;

    gl_FragColor = col;
}
]]
}

--blur shader
BlurShader = {
vertexShader = [[
uniform mat4 modelViewProjection;
attribute vec4 position;
attribute vec4 color;
varying highp vec4 vPosition;

void main()
{
    gl_Position = modelViewProjection * position;
    vPosition =  position;
}
]],
fragmentShader = [[
precision highp float;
uniform vec2 centre;
varying highp vec4 vPosition;

float L = sqrt(centre.x*centre.x+centre.y*centre.y)*1.4;

void main()
{
    float f=1.0 - distance(vPosition.xy,centre)/L;
    f=f*f*f;
    gl_FragColor = vec4(f,f,f,1.0-f);
}
]]}

