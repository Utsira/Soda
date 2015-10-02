Soda.List = class(Soda.ScrollShape)

function Soda.List:init(t)
    if type(t.text)=="string" then --can also accept a comma-separated list of values instead of a table
        local tab={}
        for word in t.text:gmatch("(.-),%s*") do
            tab[#tab+1] = word
        end
        t.text = tab
    end
    t.scrollHeight = #t.text * 40
    t.h = math.min(t.h or t.scrollHeight, t.scrollHeight)
    Soda.ScrollShape.init(self, t)
    for i,v in ipairs(t.text) do
        local number, panel = ""
        if t.enumerate then number = i..") " end
        
        if t.panels then
            panel = t.panels[i]
            panel:hide() --hide the panel by default
        end
        
        local item = Soda.Selector{parent = self, idNo = i, title = number..v, label = {x = 10, y = 0.5}, style = t.style, shape = Soda.rect, highlightable = true, x = 0, y = -0.001 - (i-1)*40, w = 1, h = 42, panel = panel} --label = { text = v, x = 0, y = 0.5}, title = v,Soda.rect
        if t.default and i==t.default then
          --  item.highlighted = true
            self:selectFromList(item)
        end
    end
end

function Soda.List:clearSelection()
    if self.selected then 
        self.selected.highlighted = false 
        if self.selected.panel then self.selected.panel:hide() end
    end
    self.selected = nil
end

--- a factory for dropdown lists

Soda.DropdownList = class()

function Soda.DropdownList:init(t)
    local parent = t.parent or nil
    self.default = t.default or ""
    self.button = Soda.Button{
        parent = parent, x = t.x, y = t.y, w = t.w, h = t.h,
        title = "\u{25bc} "..t.title..": "..self.default,
        label = {x = 10, y = 0.5}
    }

    local callback = t.callback or null
    
    self.title = t.title
    
    self.list = Soda.List{
        parent = parent,
        hidden = true,
        x = t.x, y = self.button:bottom() - t.parent.h, w = t.w, h = self.button:bottom(),
        text = t.text,   
        panels = t.panels, 
        default = t.default,  
        enumerate = t.enumerate,
        callback = function(this, selected, txt) 
            self.button.title = "\u{25bc} "..t.title..": "..txt
            self.button:setPosition() --to recalculate left-justified label
            this:hide() 
            callback(this, selected, txt)
        end
    } 

    --add clear list method (...perhaps this should be a class, not a wrapper?)
    
    self.button.callback = function() self.list:toggle() end --callback has to be outside of constructor only when two elements' callbacks both refer to each-other.

end

function Soda.DropdownList:clearSelection() 
    self.list:clearSelection() 
    self.button.title = "\u{25bc} "..self.title..": "..self.default
    self.button:setPosition() --to recalculate left-justified label
end

function Soda.DropdownList:deactivate()
    self.button:deactivate()
end

function Soda.DropdownList:activate()
    self.button:activate()
end

--[[
function Soda.DropdownList(t)
    local this = Soda.Button{
        parent = t.parent, x = t.x, y = t.y, w = t.w, h = t.h,
        title = "\u{25bc} "..t.title..": Select from list",
        label = {x = 10, y = 0.5}
    }

    local callback = t.callback or null

    this.list = Soda.List{
        parent = t.parent,
        hidden = true,
        x = t.x, y = this:bottom() - t.parent.h, w = t.w, h = this:bottom(),
        text = t.text,   
        panels = t.panels, 
        default = t.default,  
        enumerate = t.enumerate,
        callback = function(self, selected, txt) 
            this.title = "\u{25bc} "..t.title..": "..txt
            this:setPosition() --to recalculate left-justified label
            self:hide() 
            callback(self, selected, txt)
        end
    } 
    
    this.clearSelection = function() 
        this.list:clearSelection() 
        this.title = "\u{25bc} "..t.title..": Select from list"
        this:setPosition() --to recalculate left-justified label
    end
    --add clear list method (...perhaps this should be a class, not a wrapper?)
    
    this.callback = function() this.list:toggle() end --callback has to be outside of constructor only when two elements' callbacks both refer to each-other.
    
    return this
end
  ]]

