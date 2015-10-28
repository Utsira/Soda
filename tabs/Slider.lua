Soda.Slider = class(Soda.Frame)

function Soda.Slider:init(t)
  --  t.shape = Soda.line
    t.w = t.w or 300
    t.h = 60
    t.style = Soda.style.switch
    self.range = t.max - t.min
    self.value = t.start or t.min
    self.value = clamp(self.value, t.min, t.max)
    self.decimalPlaces = t.decimalPlaces or 0

    t.label = {x = 0, y = -0.001}
  --  t.shapeArgs = {x = 0, y = 20, h = 0}
    self.snapPoints = t.snapPoints or {}
    self.snapPos = {}
    Soda.Frame.init(self, t)

    self.knob = Soda.SliderKnob{
        parent = self, 
        x = 0, y = 0, w=35, h=35, 
        shape = Soda.ellipse, 
        style = Soda.style.switch, 
       -- highlightable = true,
        shadow = true
    }
    
    self.valueLabel = Soda.Frame{
        parent = self,
        style = Soda.style.switch,
        x = -0.001, y = -0.001,
        title = string.format("%."..self.decimalPlaces.."f", self.value),
        label = {x = -0.001, y = -0.001}
    }
    
    self.sensor:onQuickTap(function(event) self:smallChange(event.tpos) end)
    
end

function Soda.Slider:setPosition()
    Soda.Frame.setPosition(self)
    self.sliderLen = self.w - 40
    self.shapeArgs.w = self.sliderLen    
    --calculate snap positions
    for i,v in ipairs(self.snapPoints) do
        self.snapPos[i] = 20 + self:posFromValue(v)
    end
    self.snapStep = lerp(5 / self.sliderLen, 0, self.range)
end

function Soda.Slider:smallChange(tpos)
    if tpos.x < self:left() + self.knob.x then
        self.value = math.max(self.min, self.value - 1 )
    else
        self.value = math.min(self.max, self.value + 1)
    end

    self.knob.x = 20 + self:posFromValue()
    self.valueLabel.title = tostring(self.value)
    self:callback(self.value)
end

function Soda.Slider:posFromValue(val)
    local val = val or self.value
    return ((val - self.min)/(self.max-self.min)) * self.sliderLen
end

function Soda.Slider:valueFromPos(x)
    
    self.value = round(lerp((x - 20) / self.sliderLen, self.min, self.max), self.decimalPlaces)
   for _,v in ipairs(self.snapPoints) do
      if math.abs(self.value - v) < self.snapStep then
        self.value = v 

            self.knob.x = 20 + self:posFromValue()
        end
    end
      

    if self.decimalPlaces == 0 then self.value = math.tointeger( self.value ) end
  --  self.title = tostring(self.value)
    self.valueLabel.title = string.format("%."..self.decimalPlaces.."f", self.value) --tostring(self.value)
end

function Soda.Slider:drawContent()
    local x, y = self:posFromValue() + 20, 20
--  Soda.setStyle(Soda.style.switch.shape)
    pushStyle()

    stroke(Soda.themes.default.blue)
    strokeWidth(2)
    line(20, y, x,y)
    noStroke()
    fill(Soda.themes.default.blue)
    for i,v in ipairs(self.snapPos) do
        if v > x then 
            --Soda.setStyle(Soda.style.switch.shape) 
            fill(Soda.themes.default.grey)

        end
     --   line(v,y-10,v,y+10)
        ellipse(v,y,8)
    end
 --   Soda.setStyle(Soda.style.switch.shape)

    stroke(Soda.themes.default.grey)

    strokeWidth(2)
    line(x, y, self.w-20,y)
    popStyle()
end

Soda.SliderKnob = class(Soda.Frame)

function Soda.SliderKnob:init(t)
    Soda.Frame.init(self,t)
    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    self.sensor:onDrag(function(event) self:move(event.touch) end)
end

function Soda.SliderKnob:setPosition()
    Soda.Frame.setPosition(self)
    self.x = 20 + self.parent:posFromValue()
end

function Soda.SliderKnob:touched(t, tpos)
    if self.sensor:touched(t, tpos) then return true end
end
function Soda.SliderKnob:move(t)
    if t.state == BEGAN then
        self.touchId = t.id
        self.highlighted = true
        self:keyboardHideCheck()
    end
    self.x = clamp(self.x + t.deltaX * math.min(1, (t.deltaX * 0.5)^ 2),20,20 + self.parent.sliderLen)
    self.parent:valueFromPos(self.x)
    if t.state == ENDED then
        self.highlighted = false
        self.parent:callback(self.parent.value)
    end
end   
