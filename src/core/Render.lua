vram = require 'src.core.virtualization.VRAM'

render = {
    resX = 400,
    resY = 300,
    bgColor = 39
}

local screen
local buffer
local screenScale = (love.graphics.getHeight() - (render.resX / 10)) / render.resY
local screenX = love.graphics.getWidth() / 2 - (render.resX * screenScale) / 2

--% extends vram --

--% initialization stuff
function render.init()
    buffer = love.image.newImageData(render.resX, render.resY)
    render.clearFrame(render.bgColor)
    screen = love.graphics.newImage(buffer)
end 

--% the global render thread --
function render.drawCall()
    local W_Width, W_Height = love.graphics.getDimensions()
    screen = render.generateFrame()
    screen:setFilter("nearest", "nearest")
    effect(function()
        --love.graphics.draw(screen, screenX, 10, 0, screenScale)
        love.graphics.draw(screen, 0, 0, 0, W_Width / screen:getWidth(), W_Height / screen:getHeight())
    end)
    if DEVMODE.screenBounds then
        love.graphics.rectangle("line", screenX, 10, screen:getWidth() * screenScale, screen:getHeight()  * screenScale)
    end
    screen:release()
    vram.buffer.stack = {}
    collectgarbage("collect")
end

function render.clearFrame(color)
    for y = 1, render.resY, 1 do
        for x = 1, render.resX, 1 do
            if color == nil or color == 0 then
                buffer:setPixel(x, y, 0, 0, 0, 0)
            else
                local Color = vram.pallete[color]
                buffer:setPixel(x - 1, y - 1, Color[1] / 255, Color[2] / 255, Color[3] / 255)
            end
        end
    end
end

function render.generateFrame()
    render.clearFrame(render.bgColor)
    for _, obj in ipairs(vram.buffer.stack) do
        buffer:paste(obj.image, obj.x, obj.y)
    end
    return love.graphics.newImage(buffer)
end

function render.createImageData(w, h, data, colorOverride)
    local Image = love.image.newImageData(w, h)
    if colorOverride == nil then
        for y = 1, #data, 1 do
            for x = 1, #data[1], 1 do
                local color = vram.pallete[data[y][x]]
                if data[y][x] == 0 then
                    Image:setPixel(x - 1, y - 1,  vram.pallete[render.bgColor][1] / 255, vram.pallete[render.bgColor][2] / 255, vram.pallete[render.bgColor][3] / 255)
                else
                    Image:setPixel(x - 1, y - 1, color[1] / 255, color[2] / 255, color[3] / 255)
                end
            end
        end
    else
        for y = 1, #data, 1 do
            for x = 1, #data[1], 1 do
                local color = vram.pallete[colorOverride]
                if data[y][x] == 0 then
                    Image:setPixel(x - 1, y - 1, vram.pallete[render.bgColor][1] / 255, vram.pallete[render.bgColor][2] / 255, vram.pallete[render.bgColor][3] / 255)
                else
                    Image:setPixel(x - 1, y - 1, color[1] / 255, color[2] / 255, color[3] / 255)
                end
            end
        end
    end
    return Image
end

function render.createClearImageData(w, h, color)
    local Image = love.image.newImageData(w, h)
    for y = 0, h - 1, 1 do
        for x = 0, w - 1, 1 do
            Image:setPixel(x, y,  vram.pallete[color][1] / 255, vram.pallete[color][2] / 255, vram.pallete[color][3] / 255)
        end
    end
    return Image
end

return render