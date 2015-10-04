local __RRects = {}
--[[
true mesh rounded rectangle. Original by @LoopSpace
with anti-aliasing, optional fill and stroke components, optional texture that preserves aspect ratio of original image, automatic mesh caching
usage: RoundedRectangle{key = arg, key2 = arg2}
required: x;y;w;h:  dimensions of the rectangle
optional: radius:   corner rounding radius, defaults to 6; 
          corners:  bitwise flag indicating which corners to round, defaults to 15 (all corners). 
                    Corners are numbered 1,2,4,8 starting in lower-left corner proceeding clockwise
                    eg to round the two bottom corners use: 1 | 8
                    to round all the corners except the top-left use: ~ 2
          tex:      texture image
            scale:  size of rect (using scale)
use standard fill(), stroke(), strokeWidth() to set body fill color, outline stroke color and stroke width
  ]]
function Soda.RoundedRectangle(t) 
    local s = t.radius or 8
    local c = t.corners or 15
    local w = math.max(t.w+1,2*s)+1
    local h = math.max(t.h,2*s)+2
    local hasTexture = 0
    if t.tex then hasTexture = 1 end
    local label = table.concat({w,h,s,c,hasTexture},",")
    
    if not __RRects[label] then
        local rr = mesh()
        rr.shader = shader(rrectshad.vert, rrectshad.frag)

        local v = {}
        local no = {}

        local n = math.max(3, s//2)
        local o,dx,dy
        local edge, cent = vec3(0,0,1), vec3(0,0,0)
        for j = 1,4 do
            dx = 1 - 2*(((j+1)//2)%2)
            dy = -1 + 2*((j//2)%2)
            o = vec2(dx * (w * 0.5 - s), dy * (h * 0.5 - s))
            --  if math.floor(c/2^(j-1))%2 == 0 then
            local bit = 2^(j-1)
            if c & bit == bit then
                for i = 1,n do
                    
                    v[#v+1] = o
                    v[#v+1] = o + vec2(dx * s * math.cos((i-1) * math.pi/(2*n)), dy * s * math.sin((i-1) * math.pi/(2*n)))
                    v[#v+1] = o + vec2(dx * s * math.cos(i * math.pi/(2*n)), dy * s * math.sin(i * math.pi/(2*n)))
                    no[#no+1] = cent
                    no[#no+1] = edge
                    no[#no+1] = edge
                end
            else
                v[#v+1] = o
                v[#v+1] = o + vec2(dx * s,0)
                v[#v+1] = o + vec2(dx * s,dy * s)
                v[#v+1] = o
                v[#v+1] = o + vec2(0,dy * s)
                v[#v+1] = o + vec2(dx * s,dy * s)
                local new = {cent, edge, edge, cent, edge, edge}
                for i=1,#new do
                    no[#no+1] = new[i]
                end
            end
        end
        -- print("vertices", #v)
        --  r = (#v/6)+1
        rr.vertices = v
        
        rr:addRect(0,0,w-2*s,h-2*s)
        rr:addRect(0,(h-s)/2,w-2*s,s)
        rr:addRect(0,-(h-s)/2,w-2*s,s)
        rr:addRect(-(w-s)/2, 0, s, h - 2*s)
        rr:addRect((w-s)/2, 0, s, h - 2*s)
        --mark edges
        local new = {cent,cent,cent, cent,cent,cent,
        edge,cent,cent, edge,cent,edge,
        cent,edge,edge, cent,edge,cent,
        edge,edge,cent, edge,cent,cent,
        cent,cent,edge, cent,edge,edge}
        for i=1,#new do
            no[#no+1] = new[i]
        end
        rr.normals = no
        --texture
        if t.tex then
            rr.shader.fragmentProgram = rrectshad.fragTex
            rr.texture = t.tex
            local t = {}
            local ww,hh = w*0.5, h*0.5
          --  local aspect = vec2(w,h) --vec2(w * (rr.texture.width/w), h * (rr.texture.height/h))
            
            for i,v in ipairs(rr.vertices) do
                t[i] = vec2((v.x + ww)/w, (v.y + hh)/h)
            end
            rr.texCoords = t
        end
        local sc = 1/math.max(2, s)
        rr.shader.scale = sc --set the scale, so that we get consistent one pixel anti-aliasing, regardless of size of corners
        __RRects[label] = rr
    end
    __RRects[label].shader.fillColor = color(fill())
    if strokeWidth() == 0 then
        __RRects[label].shader.strokeColor = color(fill())
    else
        __RRects[label].shader.strokeColor = color(stroke())
    end

    if t.resetTex then
        __RRects[label].texture = t.resetTex
        t.resetTex = nil
    end
    local sc = 0.25/math.max(2, s)
    __RRects[label].shader.strokeWidth = math.min( 1 - sc*3, strokeWidth() * sc)
    pushMatrix()
    translate(t.x,t.y)
    scale(t.scale or 1)
    __RRects[label]:draw()
    popMatrix()
end

rrectshad ={
vert=[[
uniform mat4 modelViewProjection;

attribute vec4 position;

//attribute vec4 color;
attribute vec2 texCoord;
attribute vec3 normal;

//varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying vec3 vNormal;

void main()
{
    //  vColor = color;
    vTexCoord = texCoord;
    vNormal = normal;
    gl_Position = modelViewProjection * position;
}
]],
frag=[[
precision highp float;

uniform lowp vec4 fillColor;
uniform lowp vec4 strokeColor;
uniform float scale;
uniform float strokeWidth;

//varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying vec3 vNormal;

void main()
{
    lowp vec4 col = mix(strokeColor, fillColor, smoothstep((1. - strokeWidth) - scale * 0.5, (1. - strokeWidth) - scale * 1.5 , vNormal.z)); //0.95, 0.92,
     col = mix(vec4(col.rgb, 0.), col, smoothstep(1., 1.-scale, vNormal.z) );
   // col *= smoothstep(1., 1.-scale, vNormal.z);
    gl_FragColor = col;
}
]],
fragTex=[[
precision highp float;

uniform lowp sampler2D texture;
uniform lowp vec4 fillColor;
uniform lowp vec4 strokeColor;
uniform float scale;
uniform float strokeWidth;

//varying lowp vec4 vColor;
varying highp vec2 vTexCoord;
varying vec3 vNormal;

void main()
{
    vec4 pixel = texture2D(texture, vTexCoord) * fillColor;
    lowp vec4 col = mix(strokeColor, pixel, smoothstep(1. - strokeWidth - scale * 0.5, 1. - strokeWidth - scale * 1.5, vNormal.z)); //0.95, 0.92,
    // col = mix(vec4(0.), col, smoothstep(1., 1.-scale, vNormal.z) );
    col *= smoothstep(1., 1.-scale, vNormal.z);
    gl_FragColor = col;
}
]]
}

