function math.multiply(z, size) return math.floor(n / size) * n end

function math.lerp(a, b, t) return a + (b - a) * t end

function math.isPercent(a, b) return a / b * 100 end

function math.round(n, idp) return tonumber(string.format( '%.' .. (idp or 0) .. 'f', n)) end

function math.byteToSize(byte)
    local kb = byte / 1024
    local mb = kb / 1024
    local gb = mb / 1024
    local tb = gb / 1024
    
    if byte > 1024 and kb < 1024 then
        return math.round(kb, 2) .. "kb"
    elseif kb > 1024 and mb < 1024 then
        return math.round(mb, 2) .. "mb"
    elseif mb > 1024 and gb < 1024 then
        return math.round(gb, 2) .. "gb"
    elseif gb > 1024 then
        return math.round(tb, 2) .. "tb"
    end
end

function math.dist(x1, x2, y1, y2) return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 2 end

function math.clamp(low, n, high) return math.min(math.max(low, n), high) end

function math.root(n, e, i) return n ^ (e / i) end

return math.multiply, math.lerp, math.round, math.dist, math.root, math.isPercent