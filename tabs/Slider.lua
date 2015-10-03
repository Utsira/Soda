Soda.Slider = class(Soda.Frame)

function Soda.Slider:init(t)
  --  t.shape = Soda.line
    t.w = t.w or 300
    t.h = 60
    t.style = Soda.style.switch
    self.value = t.start or t.min
    self.value = clamp(self.value, t.min, t.max)
    self.decimalPlaces = t.decimalPlaces or 0

    t.label = {x = 0, y = -0.001}
  --  t.shapeArgs = {x = 0, y = 20, h = 0}

    Soda.Frame.init(self, t)
    self.sliderLen = self.w - 40
    self.shapeArgs.w = self.sliderLen
    self.snapPoints = t.snapPoints or {}
    --calculate snap positions
    self.snapPos = {}
    for i,v in ipairs(self.snapPoints) do
        self.snapPos[i] = 20 + self:posFromValue(v)
    end
    self.range = self.max - self.min
  self.snapStep = lerp(5 / self.sliderLen, 0, self.range)
    self.knob = Soda.SliderKnob{
        parent = self, 
        x = 0, y = 0, w=35, h=35, 
        shape = Soda.ellipse, 
        style = Soda.style.switch, 
       -- highlightable = true,
        shadow = true
    }
    self.knob.x = 20 + self:posFromValue()
    
    self.valueLabel = Soda.Frame{
        parent = self,
        style = Soda.style.switch,
        x = -0.001, y = -0.001,
        title = string.format("%."..self.decimalPlaces.."f", self.value),
        label = {x = -0.001, y = -0.001}
    }
    
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
    --[[
    for i,v in ipairs(self.snapPos) do 
        if math.abs(x - v) < 5 then 
            self.value = self.snapPoints[i] ]]
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
--[[
function Soda.Slider:draw()
    
end

function Soda.Slider:draw()
    -- Codea does not automatically call this method
end
]]
function Soda.Slider:touched(t, tpos)
   if Soda.Frame.touched(self, t, tpos) then return true end
  --  Soda.Frame.touched(self, t, tpos)
    if t.state == ENDED and self:pointIn(tpos.x, tpos.y) then
        if tpos.x < self:left() + self.knob.x then
            self.value = math.max(self.min, self.value - 1 )
        else
            self.value = math.min(self.max, self.value + 1)
        end
        --  self.label.text = tostring(self.value)
        self.knob.x = 20 + self:posFromValue()
        self.valueLabel.title = tostring(self.value)
        self:callback(self.value)
    end
    
end

Soda.SliderKnob = class(Soda.Frame)

function Soda.SliderKnob:touched(t, tpos)
    if t.state == BEGAN then
        if self:pointIn(tpos.x, tpos.y) then
            self.touchId = t.id
            self.highlighted = true
            self:keyboardHideCheck()
            return true
        end
    elseif self.touchId and self.touchId == t.id then
        
        self.x = clamp(self.x + t.deltaX * math.min(1, (t.deltaX * 0.5)^ 2),20,20 + self.parent.sliderLen)
        self.parent:valueFromPos(self.x)
        if t.state == ENDED then    
            self.touchId = nil
            self.highlighted = false   
            self.parent:callback(self.parent.value)   
        end
        return true
    end

end
