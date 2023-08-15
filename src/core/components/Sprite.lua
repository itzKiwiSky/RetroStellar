local sprite = {}

function sprite.newSprite(name, x, y)
    for _, spr in ipairs(vram.buffer.bank) do
        if spr.name == name then
            Sprite = {}
            Sprite.type = "sprite"
            Sprite.x = x
            Sprite.y = y
            Sprite.image = render.createImageData(16, 16, vram.buffer.bank[_].data)
            table.insert(vram.buffer.stack, Sprite)
        end
    end
end

return sprite