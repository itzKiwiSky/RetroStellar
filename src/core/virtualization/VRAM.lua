local vram = {}

--% VRAM Specifications --
--[[
    can stack max at 64 sprites at time
    .spr files are no longer individual spritefiles, they need be stored on the new spritebank file (new .spr)
    ![DON'T] can reference to other spritebank files (.spr files | max 3))
    !when referenced, the spritebank is loaded on the fly just to decode a specific sprite, after this the bank will be released
]]--

vram.pallete = {
    {255, 0, 0},
    {170, 0, 0},
    {128, 0, 0},    --% ThSun <3
    {0, 255, 0},
    {0, 170, 0},
    {0, 128, 0},
    {0, 0, 255},
    {0, 0, 170},
    {0, 0, 128},
    {255, 255, 0},
    {170, 170, 0},
    {128, 128, 0},
    {255, 0, 255},
    {170, 0, 170},
    {128, 0, 128},
    {0, 255, 255},
    {0, 170, 170},
    {0, 128, 128},
    {255, 85, 0},   --% ayanoTheFoxy <3
    {188, 63, 0},
    {116, 39, 0},
    {113, 56, 27},
    {86, 42, 18},
    {64, 3, 12},
    {167, 62, 255},
    {126, 39, 199},
    {74, 20, 120},
    {0, 255, 162},
    {0, 165, 105},
    {0, 113, 72},
    {255, 0, 106},
    {191, 0, 80},
    {124, 0, 52},
    {255, 255, 255},
    {170, 170, 170},
    {128, 128, 128},
    {109, 109, 109},
    {67, 67, 67},
    {0, 0, 0},
}

vram.buffer = {
    bank = {},  --% this bank will store at 128 sprites of 16x16
    font = {},  --% this bank can only store font chrs at 8x8 maximum
    stack = {}
}

function vram.update()
    if #vram.buffer.stack > 512 then
        table.remove(vram.buffer.stack, 1)
    end
end

function vram.getInfo()
    return {
        chars = _countTypes("char"),
        sprites = _countTypes("sprite"),
        shapes = _countTypes("shape"),
        totalObjects = #vram.buffer.stack,
    }
end

function _countTypes(_type)
    local count = 0
    for o = 1 ,#vram.buffer.stack, 1 do
        if vram.buffer.stack[o].type == _type then
            count = count + 1
        end
    end
    return count
end

return vram