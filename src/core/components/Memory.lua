local memory = {}

local memoryfont = love.graphics.newFont(15)
memory.MemoryUsage = ""

function memory.render()
    love.graphics.print(tostring(memory.MemoryUsage), memoryfont, love.graphics.getWidth() - memoryfont:getWidth(tostring(memory.MemoryUsage)), love.graphics.getHeight() - memoryfont:getHeight(tostring(memory.MemoryUsage)))
end

function memory.update(elapsed)
    memory.MemoryUsage = "Memory Usage : " .. bytesToSize(love.graphics.getStats().texturememory + collectgarbage("count"))
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
        return bytes .. " Bytes";
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

return memory