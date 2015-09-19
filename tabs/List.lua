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
    Soda.ScrollShape.init(self, t)
    for i,v in ipairs(t.text) do
        Soda.Selector{parent = self, idNo = i, label = { text = v, x = 10, y = 0.5}, style = t.style, shape = Soda.rect, highlightable = true, x = 0, y = -0.001 - (i-1)*40, w = 1, h = 42} --label = { text = v, x = 0, y = 0.5}, title = v,Soda.rect
    end
end
