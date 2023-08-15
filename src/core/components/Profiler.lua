local profiler = {}

function profiler.measure(tbl)
    local file = love.filesystem.newFile(".profiler", "w")
    file:write(json.encode(tbl))
    file:close()
    local info = love.filesystem.getInfo(".profiler")
    love.filesystem.remove(".profiler")
    return bytesToSize(info.size)
end

---------------------------------------------

function round(num, idp)
    return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end
  
-- Convert bytes to human readable format
function bytesToSize(bytes)
    local precision = 2
    local kilobyte = 1024
    local megabyte = kilobyte * 1024
    local gigabyte = megabyte * 1024
    local terabyte = gigabyte * 1024
  
    if bytes >= 0 and bytes < kilobyte then
        return bytes .. " b"
    elseif bytes >= kilobyte and bytes < megabyte then
        return round(bytes / kilobyte, precision) .. ' kb'
    elseif bytes >= megabyte and bytes < gigabyte then
        return round(bytes / megabyte, precision) .. ' mb'
    elseif bytes >= gigabyte and bytes < terabyte then
        return round(bytes / gigabyte, precision) .. ' gb'
    else
        return bytes .. ' b';
    end
end

return profiler
