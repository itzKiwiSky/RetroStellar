graphics = {}

--% depends sprite and text
fontText = require 'src.core.components.Text'
spr = require 'src.core.components.Sprite'
rectangle = require 'src.core.components.Rectangle'

function graphics.setBackgroundColor(colorID)
    if colorID < 1 then
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
    if type(color) == "number" then
        if color < 1 then
            color = 1
        elseif color > 39 then
            color = 39
        end
    end
    fontText.newText(text, x, y, color)
end

function graphics.getTextSize(text)
    return #text * 6
end

function graphics.newRectangle(color, x, y, w, h)
    if color < 1 then
        color = 1
    elseif color > 39 then
        color = 39
    end
    if w > 0 and h > 0 then
        rectangle.newRectangle(color, x, y, w, h)
    end
end

function graphics.loadSpriteBank(name)
    vram.buffer.bank = json.decode(love.data.decompress("string", "zlib", love.filesystem.read("baserom/" .. name .. ".spr")))
end

return graphics