storage = {}

saveData = {
    metaname = "Stellar-Memory-Slot",
    version = _version,
    partitions = {}
}

function storage.init()
    local saveExist = love.filesystem.getInfo("bin/slot.ssf")
    if saveExist == nil then
        local saveFile = love.filesystem.newFile("bin/slot.ssf", "w")
        saveFile:write(love.data.compress("string", "gzip", json.encode(saveData)))
        saveFile:close()
    end
    saveData = json.decode(love.data.decompress("string", "gzip", love.filesystem.read("bin/slot.ssf")))
end

function storage.createSave(name, data)
    assert(type(name) ~= "string", "[ERROR] :: Invalid type | expected 'String' got " .. type(name))
    assert(type(data) ~= "table", "[ERROR] :: Invalid type | expected 'Table' got " .. type(data))
    --% first check if save data exist
    if storage.saveExist(name) then
        for _, save in ipairs(saveData.partitions) do
            if save.name == name then
                save.data = data
            end
        end
    else
        --% create a partition
        local Partition = {
            name = name,
            data = data
        }

        table.insert(saveData, Partition)
    end
end

function storage.getSaveData(name)
    for _, save in ipairs(saveData.partitions) do
        if save.name == name then
            return save.data
        end
    end
end

function storage.saveExist(name)
    for _, save in ipairs(saveData.partitions) do
        if save.name == name then
            return true
        end
    end
    return false
end

return storage