graphics = {}

--% depends sprite and text
fontText = require 'src.core.components.Text'
spr = require 'src.core.components.Sprite'

function graphics.setBackgroundColor(colorID)
    if colorID <= 0 then
        colorID = 1
    end
    if colorID > 39 then
        colorID = 39
    end
    render.bgColor = colorID
end

function graphics.newSprite(index, x, y)
    spr.newSprite(index, x, y)
end

function graphics.newText(text, x, y, color)
    fontText.newText(text, x, y, color)
end

return graphics