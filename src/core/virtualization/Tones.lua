local tones = {}
for t = 0, 520, 33 do
    table.insert(tones, math.floor(t))
end

table.sort(tones, function(a, b)
    return a > b
end)

return tones