-- Sensor v02
-- a class to interpret touch events
-- author: jmv38
-- usage:
--[[
    -- in setup():
    screen = {x=0,y=0,w=WIDTH,h=HEIGHT} 
    sensor = Sensor {parent=screen} -- tell the object you want to be listening to touches, here the screen
    sensor:onTap( function(event) print("tap") end )
    -- in touched(t):
    if sensor:touched(t) then return true end

    -- available:
    sensor:onDrag(callback)
    sensor:onDrop(callback)
    sensor:onTap(callback)
    sensor:onQuickTap(callback)
    sensor:onLongPress(callback)
    sensor:onSwipe(callback)
    sensor:onTouch(callback)
    sensor:onTouched(callback)
    sensor:onZoom(callback)
--]]

local Sensor = class()
-- this is a senor object, that senses and interprets touched events
-- usage is: add a sensor to your objects, pass the touches to the sensor,
-- and define the gestures that will trigger a callback. Exemple:
-- myObject.sensor = Sensor{ parent = myObject }   
-- myObject.sensor:onTap( function(event) myObject:doSomething(event) end )  
-- in you touched(t) code, check the touch by:
--      if myObject:touched(t, off) then return true end
-- this way, if your object is touched, it will fire the callback and avoid others to be touched
-- some more details about the parent:
--      parent must have x,y,w,h fields
--      they are interpreted as CORNER coordinates by default
--      but they can be CENTER or RADIUS coordinates too
--      you can specify this with the field xywhMode at creation of the sensor
--      Sensor{parent=self, xywhMode = CENTER}
-- some more details about the callback:
--      callback are closures with only one parameter, event
--      event is a table where you get whatever you need, depending on the event type
--      ex: onZoom event will contain  event.dw and event.dh so you can use it to zoom your object
--      ex: onDrag has event.touch and event.tpos cause you need to know the touch state and pos
--      see each event code to see what it contains and add information if you need to
--      event contains other fields, used for internal process:
--      at creation event = {name=eventName, callback=callback, update=update}
--      name is a string: "onTap", "onDrag"
--      callback is the closure to be fired when the event happens
--      update is the internal function that manages the touch and detect the event
--      each event type has its own dedicated update function, autonomous and independent of other types

Soda.Gesture = Sensor

function Sensor:init(t)
    self.enabled = true     -- by default, listen to touches
    self.extra = t.extra or self.extra or 0   -- enlarge sensitive zone for small dots or fat fingers
    self.touches = {}       -- keeps track of touches that began on me
    self:setParent(t)       -- parents is needed for x,y,w,h fields
    self.events = {}        -- this table stores all the events of this sensor
    -- normally touches should not pass through the sensor; this flag is to allow touches to go through
    self.doNotInterceptTouches = false -- by default, intercept the touches
end

function Sensor:touched(t,tpos)
    if not self.enabled then return end  -- skip all this is the sensor is disabled
    -- if an object has children, check if they are touched...
    if self.parent.childrenTouched and self.parent:childrenTouched( t, tpos ) then
        return true -- ... and let them intercept the touch if they want to
    end
    if t.state == BEGAN and self:inbox(tpos) then
        self.touches[t.id] = true -- remember if this touch started on me (needed for some gestures)
    end
    for i,event in ipairs(self.events) do 
        event:update(self,t,tpos) -- check all registered events you want to sense, fire them if needed
        -- note: touch is checked even if it didnt start on me: onTouch, onTouched need this
        -- events are checkd in the order they were registered, 
        -- they are all checked, because several events may fire on the same touch
    end
    local intercepted = self.touches[t.id] -- by default intercept the touch
    -- note: it is written to intercept the touch even if your finger is no longer in the object:
    -- this is a feature you in general expect (an object gets the focus for touches, until finger up)
    if self.doNotInterceptOnce then -- a flag raised by some gestures at key moments:
        -- in some cases you want an object to temporarily not intercept the touch, ex: for drag and drop,
        -- the dragged object has focus, but on ENDED it should stop intercepting, so the object
        -- below can sense it is receiving something.
        intercepted = false
        self.doNotInterceptOnce = false -- reset the flag
    end
    if t.state == ENDED or t.state == CANCELLED then
        self.touches[t.id] = nil    -- forget about this touch
    end
    -- sometimes you dont want to intercept touches at all. ex: for a demo you need the touches to show
    -- on top of the screen, so make a screenTouches object for that on top of all objects, but this one
    -- should let all the touches go through. Setting this flag to true will do the trick: you listen to 
    -- touches, but you dont block them.
    if self.doNotInterceptTouches then intercepted = false end
    -- return true when touched (or if i have the focus)
    return intercepted 
end

function Sensor:setParent(t)
    -- a parent must have x,y,w,h coordinates (CORNER) to use the sensor
    local p = t.parent or self.parent
    if p.x and p.y and p.w and p.h then
        self.parent = p
    else
        error("Sensor parent must have x,y,w,h coordinates")
    end
    -- the coordinates may be in different modes, use the appropriate function
    -- self:xywh() returns x,y,w,h in RADIUS mode, appropriate to check if the object is touched
    self.xywhMode = t.xywhMode or self.xywhMode or CORNER
    if self.xywhMode == CENTER then self.xywh = self.xywhCENTER
    elseif self.xywhMode == CORNER then self.xywh = self.xywhCORNER
    elseif self.xywhMode == RADIUS then self.xywh = self.xywhRADIUS
    end
end

-- functions to get x, y, w, h from different coordinates systems, return in RADIUS
function Sensor:xywhCORNER()
    local p = self.parent
    local wr, hr = p.w/2.0, p.h/2.0
    local xr, yr = p.x + wr, p.y + hr
    return xr,yr,wr,hr
end
function Sensor:xywhCENTER()
    local p = self.parent
    return p.x, p.y, p.w/2, p.h/2
end
function Sensor:xywhRADIUS()
    local p = self.parent
    return p.x, p.y, p.w, p.h
end

-- check if the box is touched (a rectangle)
-- if you want a more complex shape, or rotations, adapt this fonction to your needs
local abs = math.abs
function Sensor:inbox(t)
    local x,y,w,h = self:xywh()
    return abs(t.x-x)<(w+self.extra) and abs(t.y-y)<(h+self.extra)
end

-- all gestures register themselves with this function (can also unregister an event)
function Sensor:register(eventName, update, callback)
    if callback then
        local event = {name=eventName, callback=callback, update=update}
        for i,event in ipairs(self.events) do
            -- if event already exists, modify it
            if event.name == eventName then 
                self.events[i] = event
                return
            end
        end
        -- if event does not exists, create it
        table.insert(self.events, event)
    else
        -- if callback is nil or false, then remove the event
        for i,event in ipairs(self.events) do
            if event.name == eventName then 
                table.remove(self.events,i)
                return
            end
        end
    end
end
-- get an event (i needed this for debugging only)
function Sensor:getEvent(eventName)
        for i,event in ipairs(self.events) do
            if event.name == eventName then 
                return event
            end
        end
end

-- ##################  From here, each supported gesture is defined   #################

-- Note the that, because gestures are managed individually, the
-- code is much more clear than when everything is mixed up. 
-- And only the needed computations are done.

-- zoom gesture
function Sensor:onZoom(callback)
    self:register("onZoom", self.zoomUpdate, callback)
end
-- zoom is complex because we need to manage 2 touches that begin inside the object, and no more
function Sensor.zoomUpdate(event,self,t,tpos)
    event.touches = event.touches or {} -- init table
    local touches = event.touches
    local t1 = touches[1]
    local t2 = touches[2]
    if t.state == BEGAN then -- a new finger has come, remember it
        if #touches >= 2 then
            -- this is a 3rd finger, dont use it
        else
            -- register this touch and reset
            table.insert(touches,t)
        end
    elseif t.state == MOVING then 
        -- this is a zoom, if we have exactly 2 touches and t is one of them
        if t1 and t2 and ( t1.id == t.id or t2.id == t.id ) then 
            local tm,ts -- m moving, s static
            if t1.id == t.id 
            then touches[1]=t ; tm = t ; ts = t2
            else touches[2]=t ; tm = t ; ts = t1
            end
            -- convert deltaX and deltaY into a variation in width and height (dw and dh)
            local dw,dh
            if tm.x>ts.x 
            then dw = tm.deltaX
            else dw = - tm.deltaX
            end
            if tm.y>ts.y
            then dh = tm.deltaY
            else dh = - tm.deltaY
            end
            -- store the information in event, then fire callback
            event.dw = dw
            event.dh = dh
            event:callback()
        end
    else
        -- when a finger is gone, remove it from the table of touches
        if t1 and t1.id == t.id then table.remove(touches,1) end
        if t2 and t2.id == t.id then table.remove(touches,2) end
    end
end

-- drag gesture
function Sensor:onDrag(callback)
    self:register("onDrag", self.dragUpdate, callback)
end
-- just echo the touch data and position via the callback
function Sensor.dragUpdate(event,self,t,tpos)
    if self.touches[t.id] then
        -- integrate finger movement (can be used as a threshold)
        if t.state == BEGAN then
            event.totalMove = 0
            event.startTime = ElapsedTime
        elseif t.state == MOVING then
            event.totalMove = event.totalMove + abs(t.deltaX) + abs(t.deltaY)
        end
        event.touch = t
        event.tpos = tpos
        event:callback()
    end
end

-- drop gesture
function Sensor:onDrop(callback)
    self:register("onDrop", self.dropUpdate, callback)
end
-- drop occurs when the finger is lifted from the screen (ENDED)
-- but it is complex because you want to detect 2 objects: 
--      the object that is dropped
--      the object that receive the drop
-- register both objects with onDrop, and appropriate callbacks
local droppedObject, droppedTime
function Sensor.dropUpdate(event,self,t,tpos)
    if self:inbox(tpos) and t.state == ENDED then
        -- this is a 2 branches mechanism, so 2 objects can have the onDrop, but we need to
        -- differenciate the 1rst one (dropped) from the second one (receiving the drop)
        if droppedTime ~= ElapsedTime then
            droppedTime = ElapsedTime   -- so next object will go to the other branch
            droppedObject = self.parent
            self.doNotInterceptOnce = true
        else
            event.object = droppedObject
            event:callback()
        end
    end
end

-- touched gesture (this is like CODEA touched function)
function Sensor:onTouched(callback)
    self:register("onTouched", self.touchedUpdate, callback)
end
function Sensor.touchedUpdate(event,self,t,tpos)
    if self.touches[t.id] or self:inbox(tpos) then 
        event.touch = t
        event.tpos = tpos
        event:callback()
    end
end

-- touch gesture
function Sensor:onTouch(callback)
    self:register("onTouch", self.touchUpdate, callback)
end
function Sensor.touchUpdate(event,self,t,tpos)
    self.touching = self.touching or {} -- track touches, not only BEGAN
    -- current touch
    if self:inbox(tpos) then 
        if t.state == BEGAN then 
            event.t0 = ElapsedTime
        end
        if t.state == BEGAN or t.state == MOVING then 
            self.touching[t.id] = true -- this is touching
        else
            self.touching[t.id] = nil -- this is not
        end
    else
        self.touching[t.id] = nil 
    end
    -- final state
    local state1 = false -- one touch is enough to be touched
    for i,t in pairs(self.touching) do state1= true ; break end
    --if state has changed, send callback
    if state1 ~= event.state then
        event.state = state1
        event.touch = t
        event.tpos = tpos
        event:callback()
    end
end

-- fired when the finger leaves the object
function Sensor:onLeave(callback)
    self:register("onLeave", self.leaveUpdate, callback)
end
local current
function Sensor.leaveUpdate(event,self,t,tpos)
    if self:inbox(tpos) then 
        if t.state == BEGAN or t.state == MOVING then 
            self.touching[t.id] = true -- this is touching
        else
            self.touching[t.id] = nil -- this is not
        end
    else
        self.touching[t.id] = nil 
    end
    -- final state
    local state1 = false -- one touch is enough to be touched
    for i,t in pairs(self.touching) do state1= true ; break end
    --if state has changed, send callback
    if state1 ~= event.state then
        event.state = state1
        event.touch = t
        event:callback()
    end
end

-- tap gesture, Yojimbo2000 version
function Sensor:onTap(callback)
    self:register("onTap", self.tapUpdate, callback)
end
function Sensor.tapUpdate(event,self,t,tpos)
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            self.parent.highlighted = true
        elseif t.state == MOVING then
            if not self:inbox(tpos) then --if a touch begins within the element, but then drifts off it, it is cancelled. ie the user can change their mind. This is the same as on iOS.
                self.parent.highlighted = false
                event.cancelled = true
            end
        elseif t.state == ENDED and not event.cancelled then
            self.parent.highlighted = false
            event.tpos = tpos
            event:callback()
        end
    end
    if event.cancelled and (t.state == ENDED or t.state == CANCELLED ) then
        event.cancelled = nil -- reset cancel
    end
end

-- tap gesture, jmv38 initial version, renamed quickTap
function Sensor:onQuickTap(callback)
    self:register("onQuickTap", self.quickTapUpdate, callback)
end
function Sensor.quickTapUpdate(event,self,t,tpos)
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            event.totalMove = 0
            event.t0 = ElapsedTime
        elseif t.state == MOVING then
            -- integrate finger movement
            event.totalMove = event.totalMove + abs(t.deltaX) + abs(t.deltaY)
        elseif t.state == ENDED 
        and event.totalMove < 10  -- the finger should not have moved too much ...
        and (ElapsedTime-event.t0) < 0.5 then -- and delay should not be too long
            event.touch = t
            event.tpos = tpos
            event:callback()
        end
    end
end

-- a double tap gesture
function Sensor:onDoubleTap(callback)
    self:register("onDoubleTap", self.doubleTapUpdate, callback)
end
function Sensor.doubleTapUpdate(event,self,t,tpos)
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            event.totalMove = 0
            event.t0 = ElapsedTime
        elseif t.state == MOVING then
            -- integrate finger movement
            event.totalMove = event.totalMove + abs(t.deltaX) + abs(t.deltaY)
        elseif t.state == ENDED 
        and event.totalMove < 20  -- the finger should not have moved too much ...
        and (ElapsedTime-event.t0) < 2.0 -- and delay should not be too long...
        and t.tapCount == 2 then -- and 2 taps
            event.touch = t
            event.tpos = tpos
            event:callback()
        end
    end
end

-- a single tap gesture
function Sensor:onSingleTap(callback)
    self:register("onSingleTap", self.singleTapUpdate, callback)
end
function Sensor.singleTapUpdate(event,self,t,tpos)
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            event.totalMove = 0
            event.t0 = ElapsedTime
        elseif t.state == MOVING then
            -- integrate finger movement
            event.totalMove = event.totalMove + abs(t.deltaX) + abs(t.deltaY)
        elseif t.state == ENDED 
        and event.totalMove < 10  -- the finger should not have moved too much ...
        and (ElapsedTime-event.t0) < 0.5 -- and delay should not be too long...
        and t.tapCount == 1 then -- and 2 taps
            event.touch = t
            event.tpos = tpos
            event:callback()
        end
    end
end

-- long press gesture
function Sensor:onLongPress(callback)
    self:register("onLongPress", self.longPressUpdate, callback)
end
function Sensor.longPressUpdate(event,self,t,tpos)
    local tmin = 1
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            event.totalMove = 0
            event.cancel = false
            event.id = t.id
            event.tween = tween.delay(tmin,function()
                event.tween = nil
                if event.totalMove > 10 or event.id ~= t.id then  event.cancel = true end
                if event.cancel then return end
                event.tpos = tpos
                event:callback()
            end)
        elseif t.state == MOVING and event.id == t.id then
            -- integrate finger movement
            event.totalMove = event.totalMove + abs(t.deltaX) + abs(t.deltaY)
        elseif (t.state == ENDED or t.state == CANCELLED) and event.id == t.id then
            event.cancel = true
            if event.tween then tween.stop(event.tween) end
        end
    end
end

-- swipe gesture
function Sensor:onSwipe(callback)
    self:register("onSwipe", self.swipeUpdate, callback)
end
function Sensor.swipeUpdate(event,self,t,tpos)
    if self.touches[t.id] then -- the touch must have started on me
        if t.state == BEGAN then
            event.dx = 0
            event.dy = 0
            event.t0 = ElapsedTime
        elseif t.state == MOVING then
            -- track net finger movement
            event.dx = event.dx + t.deltaX
            event.dy = event.dy + t.deltaY
        elseif t.state == ENDED 
        and (ElapsedTime-event.t0) < 1 then -- delay should not be too long
            -- and the finger should have moved enough:
            local minMove = 70
            if abs(event.dx) < minMove  then event.dx = 0 end
            if abs(event.dy) < minMove  then event.dy = 0 end
            if event.dx ~= 0 or event.dy ~= 0 then
                event:callback() -- use event.dx and .dy to know the swipe direction
            end
        end
    end
end












