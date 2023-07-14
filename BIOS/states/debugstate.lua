debugscreen = {}

function debugscreen:enter()
    tiles = {}
    for s = 1, #vram.buffer.bank, 1 do
        print(tostring(vram.buffer.bank[s].name))
        table.insert(tiles, vram.buffer.bank[s].name)
    end
    print(debug.getTableContent(spr))
end

function debugscreen:_render()
    local x = 0
    local y = 0
    for t = 1, #tiles, 1 do
        stellarAPI.graphics.newSprite(tiles[t], x, y)
        x = x + 16
        if x >= 400 then
            x = 0
            y = y + 16
        end
    end
end

function debugscreen:_update(elapsed)

end

function debugscreen:_keydown(k)

end

function debugscreen:_gamepadpressed(button)
    
end

function debugscreen:_virtualpadpressed(button)
    
end

return debugscreen