render = {
    bgColor = 39
}

local screen
local buffer
local screenScale = (love.graphics.getHeight() - 30) / 200
local screenX = love.graphics.getWidth() / 2 - (300 * screenScale) / 2

--% extends vram --

--% initialization stuff
function render.init()
    buffer = love.image.newImageData(300, 200)
    render.clearFrame(render.bgColor)
    screen = love.graphics.newImage(buffer)
end 

--% the global render thread --
function render.drawCall()
    screen = render.generateFrame()
    screen:setFilter("nearest", "nearest")
    love.graphics.draw(screen, screenX, 10, 0, screenScale)
    love.graphics.rectangle("line", screenX, 10, screen:getWidth() * screenScale, screen:getHeight()  * screenScale)
    screen:release()
    vram.buffer.stack = {}
end

function render.clearFrame(color)
    for y = 0, 199, 1 do
        for x = 0, 299, 1 do
            if color == nil or color == 0 then
                buffer:setPixel(x, y, 0, 0, 0, 0)
            else
                local Color = vram.pallete[color]
                buffer:setPixel(x, y, Color[1] / 255, Color[2] / 255, Color[3] / 255)
            end
        end
    end
    --return love.graphics.newImage(buffer)
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

return render