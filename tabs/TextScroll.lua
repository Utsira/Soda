Soda.TextScroll = class(Soda.Scroll) --smooth scrolling of large text files (ie larger than screen height)

function Soda.TextScroll:init(t)
   -- t.shape = t.shape or Soda.rect
    self.characterW, self.characterH = self:getTextSize(Soda.style.textBox, "a")
    Soda.Scroll.init(self, t)
    self:inputString(t.textBody)
end

function Soda.TextScroll:inputString(txt)
    --split text into lines and wrap them
    local lines = {}
    local boxW = (self.w//self.characterW)-2 --how many characters can we fit in?
    for lin in txt:gmatch("[^\n\r]+") do
        local prefix = ""
        while lin:len()>boxW do --wrap the lines
            lines[#lines+1] = prefix..lin:sub(1, boxW)
            lin = lin:sub(boxW+1) 
            prefix = "  "    
        end
        lines[#lines+1] = prefix..lin
    end
    self.scrollHeight = #lines * self.characterH
    
    --put lines back into chunks of text, 10 lines high each
    self.chunk = {}
    local n = #lines//10
    for i = 0,n do
        local start = (i * 10)+1
        local stop = math.min(#lines, start + 9) --nb concat range is inclusive, hence +9
        self.chunk[i+1] = {y = self.h - stop * self.characterH, text = table.concat(lines, "\n", start, stop)}
    end
end

function Soda.TextScroll:drawContent()
    
    self:updateScroll()
    pushStyle()
    Soda.setStyle(Soda.style.textBox)
    textMode(CORNER)
    textAlign(LEFT)
    --[[

    translate(self:left(),self:bottom())--+self.scrollY
    self:drawShape(Soda.style.default)
      ]]
        pushMatrix()
        local mm = modelMatrix()
    translate(10, self.scrollY)

    clip(mm[13]+10, mm[14]+10, self.w-20, self.h-20) --nb translate doesnt apply to clip. (idea: grab transformation from current model matrix?) --self.parent:left()+self:left(),self.parent:bottom()+self:bottom()
    
    --calculate which chunks to draw
    local lineStart = math.max(1, math.ceil(self.scrollY/self.characterH))
    local chunkStart = math.ceil(lineStart * 0.1)
    -- if CurrentOrientation == PORTRAIT or CurrentOrientation == PORTRAIT_UPSIDE_DOWN then d
    local n = math.min(#self.chunk, chunkStart + 5)
    for i = chunkStart, n, 1 do
        text(self.chunk[i].text, 0, self.chunk[i].y)
    end
    clip()
    popStyle()
  popMatrix()
    
end
