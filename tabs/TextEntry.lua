-- TextEntry2
-- same as textEntry, plus a select text function
-- author: jmv38, from yojimbo2000 first version

-- functions:
-- tap inside the text block to show keyboard and tap text
-- tap anywhere to place the cursor there
-- tap the cursor to show the paste dialog bar
-- double tap the cursor to show the selection dialog and cursors
-- drag the text when too big to finto the block

-- under the hood:
--      TextEntry is simply showing the text, with a drag function
--      TextEditor is the text modifying object

-- version 2.4
--      subStyle = {"popUp"} for text menus
--      BACKSPACE deletes the selection if user in selection mode
-- version 2.3
--      undo 5 levels, improved exeprience
--      double tap selects the word below
-- version 2.2
--      full rework
-- version 2.1
--      cut and delete corrected for start=0 bug, and stop too (was there a pb...?)↔︎


-- ###############################################################################
-- some classes i want to keep local but available anywhere in this tab
local TextEntry  -- the main class for text box (included in soda)
local TextEditor -- a class managing the text edition tools
local Cursor -- a class for cursor object
local Selector -- a class for a text selection object
-- ###############################################################################

TextEntry = class(Soda.Frame)
TextEntry.usesKeyboard = true
Soda.TextEntry = TextEntry

-- TextEntry itself is doing nothing but displaying the text, text edition is inside TextEditor
function TextEntry:init(t)
    t.shape = Soda.RoundedRectangle
    t.label = {x=10, y=0.5} 
    Soda.Frame.init(self, t)
    table.insert(self.styleList, 2, self.style["button"])
    self:inputString(t.default or "")
    self:updateTextW()
    self.offset = vec2(self.label.w + 5, (self.h-self.label.h)*0.5) --bottom corner of text-entry
    self.Xscroll = 0 -- when text is bigger than window, it can be scrolled
    
    self.sensor = Soda.Gesture{parent=self, xywhMode = CENTER}
    --[[self.sensor:onDrag(function(event) 
        -- move the interface to access other text box while keyboard is there
        
        if event.totalMove > 20 and isKeyboardShowing() then 
           Soda.UIoffset = Soda.UIoffset + event.touch.deltaY
        end 
          
    end)]]
    self.sensor:onTouch(function(event) self:autoScrollUpdate(event) end)
    -- this object is to isolate the edition functions and objects from TextEntry
    self.editor = TextEditor( self )
end

function TextEntry:output()
    return self.text
end

-- move the text inside its box 
function TextEntry:horizontalScroll(t)
    local t = t or {}
    if t.state == BEGAN or t.state == MOVING then
        if self.freeScroll then -- if some animation is running, stop it
            tween.stop(self.freeScroll)
            self.freeScroll = false
        end
        self.Xscroll = self.Xscroll + t.deltaX
    else -- come back into position, with a smooth animation effect
        -- create the callback once at first usage and save it
        self.updt = self.updt or function()
            self.freeScroll = false
        end 
        self:updateTextW()
        if self.Xscroll and self.clipW then
        if self.Xscroll > 0 or self.clipW > self.textW then
            self.freeScroll = tween(0.5, self, {Xscroll=0}, tween.easing.backOut, self.updt)
        elseif self.Xscroll < 0 then
            local minScroll = self.clipW - self.textW -10
            if self.Xscroll < minScroll then
                self.freeScroll = tween(0.5, self, {Xscroll=minScroll}, tween.easing.backOut,self.updt)
            end
        end
        end
    end
end

function TextEntry:autoScrollUpdate(event)
    local state = event.touch.state
    local tpos = event.tpos
    if (state == BEGAN or state == MOVING) and self.sensor:inbox(tpos) then
        self:autoScroll(tpos.x)
    else
        self.autoScrollDelta = false
    end
end
function TextEntry:autoScroll(x)
    local direction = false
    if x then
        if x < self.clipX + 50 then direction = 1 end
        if x > self.clipX + self.clipW - 50 then direction = -1 end
        self.autoScrollDelta = direction
    end
    if self.autoScrollDelta then
        self.minScroll = self.clipW - self.textW -10
        self.maxScroll = 0
        self.autoScrollFunc = self.autoScrollFunc or function()
            if self.autoScrollDelta then
                local editor = self.editor
                if editor.inputMode then
                    local c = editor.inputCursor
                    c:setIndex( c.index - self.autoScrollDelta )
                end
                self.Xscroll = self.Xscroll +  self.characterW * self.autoScrollDelta
                if self.Xscroll < self.minScroll then 
                    self.Xscroll = self.minScroll 
                    self.autoScrollDelta = false
                end
                if self.Xscroll > self.maxScroll then 
                    self.Xscroll = self.maxScroll 
                    self.autoScrollDelta = false
                end
                self:autoScroll()
            end
        end
        tween.delay( 0.05, self.autoScrollFunc)
       -- self.debug = true
    else
        -- self.debug = false
    end
end

function TextEntry:updateTextW()
    pushStyle()
    Soda.setStyle(self.style.textEntry)
     --width of a character (nb fixed-width font only, to simplify creation of touchable text)
    self.characterW = textSize("a")
    self.textW = self.text:len() * self.characterW
    popStyle()
end

-- enter text and reset things
function TextEntry:inputString(txt)
    self.text = txt
    self:updateTextW()
    self:horizontalScroll()
end

function TextEntry:subText()
    -- too long strings wont draw properly => extract a smaller sustring
    -- this string is comprised between startIndex and stopIndex (included)
    self.characterW = self.characterW or self:getTextSize(self.style.textEntry, "a")
    self.startIndex = 1
    if self.Xscroll < 0 then
        self.startIndex = math.floor(-self.Xscroll/self.characterW) + 1
    end
    self.stopIndex = self.startIndex + math.floor(self.clipW/self.characterW) +1
    local nbcar = self.text:len()
    if nbcar == 0 then return "" end
    if self.startIndex > nbcar then return "" end
    if self.stopIndex > nbcar then self.stopIndex = nbcar end
    return self.text:sub(self.startIndex , self.stopIndex)
end
function TextEntry:draw(breakPoint)
    Soda.Frame.draw(self, breakPoint) -- generic stuff
    self:drawText() -- the text inside its box
    if not isKeyboardShowing() then self.editor:closeEdition() end
end

-- an extension of clip function:
--  clip(x,y,w,h) is as usual
--  clip(x,y,w,h,true) is using the current translation state to define its position
local stdClip = clip -- remember standard clip function
clip = function(x,y,w,h,relative)
    if x == nil then stdClip() return end
    if relative then -- translate the clip using current translation
        local m = modelMatrix()
        local x0,y0 = m[13],m[14]
        stdClip(x0+x,y0+y,w,h)
    else
        stdClip(x,y,w,h)
    end
end
    
function TextEntry:drawText()
    -- text is written from this position
    local x = self:left() + self.offset.x 
    local y = self:bottom()
    -- these values are used by text editor, so they must be saved ...
    self.textX = x + self.Xscroll -- the starting point for text 
    -- ... and the area where the text shows up:
    self.clipX = x
    self.clipY = y
    self.clipW = self.w-self.offset.x - 5
    self.clipH = self.h
    pushStyle()
    -- make a clip area fpr the text
    clip( self.clipX, self.clipY, self.clipW, self.clipH, true)
        if self.debug then background(255, 205, 0, 12) end -- debug: to view area
        -- inside this area, draw the text
        Soda.setStyle(self.style.textEntry)
        textAlign(LEFT)
        textMode(CORNER)
        -- draw only a subtext (too long text will not draw, due to some codea limit)
        text(self:subText(), self.textX + self.characterW *self.startIndex, y+self.offset.y)
    clip()
    popStyle()
end

-- ###############################################################################

TextEditor = class() -- manages the text edition tools life
local objectEdited -- the only one object that can be edited at a time is stored here

--  creates all the edition tools needed, and makes the reactions to events being coherent
function TextEditor:init(parent)
    self.parent = parent
    -- a cursor for entering text
    self.inputCursor = Cursor{parent=self.parent, x=0, y=0, h=self.parent.h, w=3}
    -- a selection tool
    self.selector = Selector{parent=self.parent, x=0, y=0, h=self.parent.h, w=3}
    -- on startup everything is hidden
    self.inputCursor:hide() 
    self.selector:hide() 
    -- create menus
    self:selectionMenuInit()
    self:inputMenuInit()
    
    -- tapping the parent makes the cursor show up, and the keyboard
    self.parent.sensor:onSingleTap(function(event) self:enterInputMode(event.tpos) end)
    -- double tap the cursor to enter into selection mode
    self.inputCursor.sensor:onDoubleTap(function(event) self:enterSelectionMode(event.tpos) end)
    -- single tap to open paste menu
    self.inputCursor.sensor:onSingleTap(function(event) self:openInputMenu() end)

end

-- ############## mode switching related stuff ##############

-- prepare object for receiving text
function TextEditor:enterInputMode(tpos)
    self:startEdition()
    if self.selectionMode then 
        self.inputCursor.index = self.selector.infCursor.index
        self:leaveSelectionMode() 
    end
    self.inputMode = true
    -- put the cursor at good position, and show it
    if tpos then self.inputCursor:setFromPosition(tpos.x) end
    self.inputCursor:show()
    -- bring up the keyboard, if not yet here
end
-- end properly input mode
function TextEditor:leaveInputMode()
    self.inputMode = false
    self.inputCursor:hide()
    self:closeInputMenu()
end
-- enter selection mode
function TextEditor:enterSelectionMode(tpos)
    self:leaveInputMode() -- you can enter selection mode only from input mode
    self.selectionMode = true
    -- put the cursor at good position, and show it
    self.selector:selectAll()
    self.selector:setFromPosition(self.inputCursor.x)
    self.selector:show()
    self.selectionMenu:show()
end
-- end properly selection mode
function TextEditor:leaveSelectionMode(tpos)
    self.selectionMode = false
    self.selector:hide()
    self.selectionMenu:hide()
end
-- start editing an object
function TextEditor:startEdition()
    if  objectEdited ~= self.parent then 
        -- close the other object being edited, if any
        if objectEdited then objectEdited.editor:closeEdition() end
        -- update state data
        objectEdited = self.parent
    end
    -- create the undo function
    self:pushUndo()
    self:startTextInput()
end
-- end properly the edition phase
function TextEditor:closeEdition()
    if  objectEdited ~= self.parent then return end
    objectEdited = false
    if self.inputMode then self:leaveInputMode() end
    if self.selectionMode then self:leaveSelectionMode() end
    -- fire a callback when edition finished, with a delay in case the order comes from draw
    tween.delay(0.001, function() self.parent.callback(self.parent.text) end ) 
    self:endTextInput()
end
-- a stack of undo's
function TextEditor:pushUndo()
    self.undos = self.undos or {} -- table of undo's
    local txt = self.parent.text
    local func = function() self.parent:inputString(txt) end
    table.insert(self.undos,1,func)
    local maxi = 5
    if #self.undos > maxi then table.remove(self.undos,maxi+1) end -- not too many levels
end
function TextEditor:popUndo()
    local func = self.undos[1]
    -- remove undos, but the first one
    if #self.undos > 1 then table.remove(self.undos,1) end
    return func
end
-- ############## text input stuff ##############
-- i have left this part isolated because it is closely related to Soda and i dont understand everything
-- it could be merged with above function, but there is no real need for that

function TextEditor:startTextInput()
    local delay = 0.5  -- animation
    if not isKeyboardShowing() then 
        showKeyboard() 
        delay = 1.0  -- more time is needed when keyboard was not here
    end
    if Soda.keyboardEntity ~= self then
        -- adapt the interface position to this object
        local h = 0.3
        local y = self.parent:bottom() + self.parent.offset.y
        if CurrentOrientation == LANDSCAPE_LEFT or CurrentOrientation == LANDSCAPE_RIGHT then h = 0.4 end
        local typewriter = math.max(0, (HEIGHT * h) - y) -- new position
        tween(delay,Soda,{UIoffset=typewriter},tween.easing.cubicOut) -- go there smoothly
    end
    Soda.keyboardEntity = self
end

function TextEditor:endTextInput()
    Soda.keyboardEntity = nil
end

function TextEditor:keyboard(key)
    if key == RETURN then
        hideKeyboard() --hide keyboard triggers end of text input event in TextEntry:draw()
        self:closeEdition()
    elseif key == BACKSPACE then
        if self.selectionMode then
            local start = self.selector.infCursor.index
            local stop = self.selector.supCursor.index
            self:delete(start,stop)
        else
            local start = self.inputCursor.index - 1
            local stop = self.inputCursor.index
            if start >0 then
                self:delete(start,stop)
                self.inputCursor.index = self.inputCursor.index - 1   -- and move cursor back 1 char
            end
        end
    elseif key:len()==1 then
        self:paste(key)
        self.inputCursor.index = self.inputCursor.index + 1   -- and move cursor up 1 char
    end
end


-- ############## input menu related stuff ##############

function TextEditor:inputMenuInit()
    self.inputMenu = Soda.Segment{
        parent = self.parent, 
        x = 0.5, y = 50, w = 0.3, h = 40,
        subStyle = {"popUp"},
        text = {"undo","paste", "sel", "close"},
        default = 0, 
    }
    
    for i, child in ipairs(self.inputMenu.child) do
        child.callback = function() 
            self:inputMenuAction(child.title) 
            tween.delay(0.2, function() 
                child.highlighted = false
                self.inputMenu.selected = nil
            end)
        end
        child.usesKeyboard = true
    end
    self.inputMenu:hide()
end
function TextEditor:openInputMenu()
    self.inputMenu.x = self.inputCursor.x
    self.inputMenu:show()
end
function TextEditor:closeInputMenu()
    self.inputMenu:hide()
end
function TextEditor:inputMenuAction(action)
    if action=="close" then --
        self:closeInputMenu()
    elseif action=="paste" then
        self:paste(pasteboard.text or "")
    elseif action=="sel" then
        self:enterSelectionMode()
    elseif action=="undo" then
        self:undo()
    end
end

-- ############## selection menu related stuff ##############

-- create a tool bar for selection
function TextEditor:selectionMenuInit()
    self.selectionMenu = Soda.Segment{
        parent = self.parent, 
        x = 0.5, y = 50, w = 0.5, h = 40,
        subStyle = {"popUp"},
        text = {Soda.symbol.delete,"undo","cut", "copy", "paste", Soda.symbol.widen},
        default = 0, 
    }
    for i, child in ipairs(self.selectionMenu.child) do
        child.callback = function() 
            self:selectionAction(child.title) 
            tween.delay(0.2, function() 
                child.highlighted = false
                self.selectionMenu.selected = nil
            end)
        end
        child.usesKeyboard = true
    end
    self.selectionMenu:hide()
end
-- decode the output of selection menu
function TextEditor:selectionAction(action)
    local start = self.selector.infCursor.index
    local stop = self.selector.supCursor.index

    if action==Soda.symbol.delete then 
        self:delete(start,stop)
    --[[
    elseif action==Soda.symbol.close then 
        self:enterInputMode()
          ]]
    elseif action=="undo" then 
        self:undo()
    elseif action=="cut" then 
        self:selectionCopy()
        self:delete(start,stop)
    elseif action=="copy" then 
        self:selectionCopy()
    elseif action==Soda.symbol.widen then --"<-->"
        self.selector:selectAll()
    elseif action=="paste" then 
        self:delete(start,stop)
        self:paste(pasteboard.text or "")
    end
end
function TextEditor:selectionCopy()
    local start = self.selector.infCursor.index
    local stop = self.selector.supCursor.index-1
    local txt = self.parent.text:sub(start,stop)
    pasteboard.text = txt
end
function TextEditor:split(start,stop)
    stop = stop or start
    local str = self.parent.text
    local txt1 = ""
    if start > 1 then txt1 = str:sub(1,start-1) end
    local txt2 = ""
    if stop <= str:len() then txt2 = str:sub(stop) end
    return txt1,txt2
end
function TextEditor:paste(txt)
    if self.selectionMode then self:enterInputMode() end
    local txt1,txt2 = self:split(self.inputCursor.index)
    -- txt = "|test|" -- debug
    txt = txt1 .. txt .. txt2
    self.parent:inputString(txt)
end
function TextEditor:delete(start,stop)
    self:enterInputMode()
    local txt1,txt2 = self:split(start,stop)
    local txt = txt1 .. txt2
    self.parent:inputString(txt)
end
function TextEditor:undo()
    local func = self:popUndo()
    if func then 
        local newTxt = self.parent.text
        func() 
        if self.parent.text == newTxt then
            -- one more time, to avoid the "nothing happened?" feeling
            func = self:popUndo()
            if func then func() end
        end
        self.inputCursor:setFromPosition(self.inputCursor.x)
        self.selector.infCursor:setFromPosition(self.selector.infCursor.x)
        self.selector.supCursor:setFromPosition(self.selector.supCursor.x)
    end
end
-- ###############################################################################

-- a cursor object
-- can be a blinking cursor, or a cursor with a round tip
-- it is mainly a graphic object, plus a memory to store the current index
Cursor = class(Soda.Frame)
function Cursor:init(t)
    t.update = self.update -- because Frame.init erases this function otherwise
    Soda.Frame.init(self, t)
    -- the index is before the concerned character. It can be 1 char bigger that the string.
    self.index = self.parent.text:len() +1 -- default position is at string end
    self:update()
    self.sensor.extra = 20 -- make the sensor big enough to be draggable
    -- dragging the cursor is simple enough to be included in cursor itself
    self.sensor:onDrag(function(event) 
        if event.totalMove > 20 then self:setFromPosition(event.tpos.x) end
    end)
    self.sensor.doNotInterceptTouches = true -- let parent hear (for auto scrolling)
    self.debug = false -- for debugging
end

function Cursor:update()
    -- update position
    local x = self.parent.textX or 0 -- to avoid problem at init
    self.x = x + (self.index-1) * self.parent.characterW
end

function Cursor:setFromPosition(xpos)
    local x = self.parent.textX or 0 -- to avoid problem at init
    -- convert position into a char index
    local index = math.floor( (xpos - x) / self.parent.characterW + 1)
    self:setIndex(index)
end
function Cursor:setIndex(index)
    -- make sure the index is acceptable
    local maxIndex = self.parent.text:len() + 1
    if index > maxIndex then index = maxIndex end
    if index < 1 then index = 1 end
    -- this part is for there are 2 cursors blocking each other
    if self.infLimit then
        local infLimit = self.infLimit.index + 1
        if index < infLimit then index = infLimit end
    end
    if self.supLimit then
        local supLimit = self.supLimit.index - 1
        if supLimit < index then index = supLimit end
    end
    -- apply this value
    self.index = index
    self:update()
end

function Cursor:draw()
    if self.hidden then return end
    self:update()
    pushStyle()
    rectMode(CENTER)
    noStroke()
    fill(0, 201, 255, 200)
    local p = self.parent
    clip( p.clipX-10, -10, p.clipW, p.clipH+20, true) -- the cursor should disappear too
    -- background(255, 216, 0, 83) -- debug
    if self.hTip then -- if this exists, draw a dot on the cursor
        rect(self.x,self.y, self.w, self.h)
        ellipse(self.x,self.y+self.hTip,15)
    else -- blink the cursor
        if (ElapsedTime/0.4)%2<1.3 then
            rect(self.x,self.y,self.w,self.h)
        end
    end
    if self.debug then
        -- show the index value
        textMode(CENTER)
        fill(0)
        fontSize(12)
        text(tostring(self.index),self.x,self.y+ (self.hTip or self.h/3))
    end
    clip()
    popStyle()
end

-- ###############################################################################

-- a selector object
-- it is mainly a graphic object, 2 cursors and a rectangle between
Selector = class(Soda.Frame)
function Selector:init(t)
    t.update = self.update -- because Frame.init erases this function otherwise
    Soda.Frame.init(self, t)
    self.sensor.enabled = false
    -- two cursors for selecting text
    local h=self.parent.h
    self.supCursor = Cursor{parent=self.parent,x=10,y=0, h=h, w=3, hTip=-h/2}
    self.infCursor = Cursor{parent=self.parent,x=10,y=0, h=h, w=3, hTip= h/2}
    -- these cursors are bound by each other
    self.supCursor.infLimit = self.infCursor
    self.infCursor.supLimit = self.supCursor
    -- on startup all cursors are hidden
    self._hide = Soda.Frame.hide
    self._show = Soda.Frame.show
    self:hide()
    self.debug = false -- for debugging
end
function Selector:selectAll()
    self.supCursor.index = self.parent.text:len() +1
    self.infCursor.index = 1
end
function Selector:hide()
    self:_hide()
    self.supCursor:hide()
    self.infCursor:hide()
end
function Selector:show()
    self:_show()
    self.supCursor:show()
    self.infCursor:show()
end
function Selector:update()
    self.supCursor:update()
    self.infCursor:update()
end

function Selector:setFromPosition(xpos)
    self.supCursor:setFromPosition(xpos)
    self.infCursor:setFromPosition(xpos)
    local txt = self.parent.text
    local start = self.infCursor.index
    self.infCursor.index = 1
    if start >1 then
        for i = start-1, 1, -1 do
            if txt:sub(i,i) == " " then
                self.infCursor.index = i+1
                break
            end
        end
        
    end
    local stop = self.supCursor.index
    self.supCursor.index = txt:len()+1
    if stop < txt:len() then
        for i = stop+1, txt:len() do
            if txt:sub(i,i) == " " then
                self.supCursor.index = i
                break
            end
        end
    end
end

function Selector:draw()
    if self.hidden then return end
    self:update()
    pushStyle()
    noStroke()
    local x0 = self.infCursor.x
    local y0 = 0
    local x1 = self.supCursor.x
    local y1 = self.supCursor.h
    fill(0, 201, 255, 100)
    rectMode(CORNERS)
    local p = self.parent
    clip( p.clipX-10, 0, p.clipW, p.clipH, true)
    rect(x0,y0,x1,y1)
    clip()
    popStyle()
end
