hex = {}

function _just(character, length)
    local result = ""
    for i = 1, length do
        result = result .. character
    end
    return result
end

function hex.generate(length)
    local template = _just("x", length)
    return string.gsub(template, '[x]', function (c)
        local v = (c == 'x') and love.math.random(0, 0xf) or love.math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

return hex