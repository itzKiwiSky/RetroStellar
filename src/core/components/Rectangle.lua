local rectangle = {}

function rectangle.newRectangle(color, x, y, w, h)
    local Rectangle = {}
    Rectangle.x = x
    Rectangle.y = y
    Rectangle.w = w
    Rectangle.h = h
    Rectangle.type = "shape"
    Rectangle.image = render.createClearImageData(w, h, color)
    table.insert(vram.buffer.stack, Rectangle)
end

return rectangle