sprite = {}

function sprite.newSprite(index, x, y)
    Sprite = {}
    Sprite.type = "sprite"
    Sprite.x = x
    Sprite.y = y
    Sprite.image = render.createImageData(16, 16, vram.buffer.bank[index])
    table.insert(vram.buffer.bank[index], Sprite)
end

return sprite