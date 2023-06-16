fontText = {}

function fontText.newText(text, x, y, color)
    --print("text created")
    local tx = x
    local id = 1
    for c = 1, #text, 1 do
        local TextObj = {}
        TextObj.type = "char"
        TextObj.x = tx
        TextObj.y = y
        local char = string.lower(tostring(text)):sub(c, c)
        if type(color) == "table" then
            TextObj.image = render.createImageData(6, 7, vram.buffer.font[char], color[id])
            id = id + 1
            if id > #text then
                id = 1
            end
        else
            TextObj.image = render.createImageData(6, 7, vram.buffer.font[char], color)
        end
        tx = tx + 6
        table.insert(vram.buffer.stack, TextObj)
    end
end

return fontText