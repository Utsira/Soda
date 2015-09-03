Soda.List = class(Soda.Scroll)

function Soda.List:init(t)
    t.scrollHeight = #t.text * 40
    Soda.Scroll.init(self, t)
    for i,v in ipairs(t.text) do
        Soda.Selector{parent = self, label = { text = v, x = 10, y = 0.5}, style = t.style, shape = Soda.rect, highlightable = true, x = 0, y = -0.001 - (i-1)*40, w = 1, h = 42} --label = { text = v, x = 0, y = 0.5}, title = v,
    end
end
