stellar = {}

modules = love.filesystem.getDirectoryItems("src/modules")
for module = 1, #modules, 1 do
    table.insert(stellar, require("src.modules." .. string.gsub(modules[module], ".lua", "")))
end

return stellar