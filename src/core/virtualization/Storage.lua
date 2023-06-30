Storage = {}

profiler = require 'src.core.components.Profiler'

saveData = {
    metaname = "Stellar-Memory-Slot",
    version = _version,
    partitions = {}
}

function Storage.init()
    local saveExist = love.filesystem.getInfo("bin/slot.dbsys")
    if saveExist == nil then
        local saveFile = love.filesystem.newFile("bin/slot.dbsys", "w")
        saveFile:write(love.data.compress("string", "gzip", json.encode(saveData)))
        saveFile:close()
    end
    saveData = json.decode(love.data.decompress("string", "gzip", love.filesystem.read("bin/slot.dbsys")))
end

function Storage.createSave(name, data)
    --% first check if save data exist
    if Storage.saveExist(name) then
        for _, save in ipairs(saveData.partitions) do
            if save.name == name then
                save.data = data
            end
        end
    else
        --% create a partition
        local Partition = {
            name = string.sub(name, 1, 16),
            _size = profiler.measure(data),
            _partitionVersion = _version,
            data = data,
        }
        table.insert(saveData.partitions, Partition)
    end

    --% sign the file --
    local saveFile = love.filesystem.newFile("bin/slot.dbsys", "w")
    saveFile:write(love.data.compress("string", "gzip", json.encode(saveData)))
    saveFile:close()
end

function Storage.removeSave(name)
    --% check if save exist --
    if Storage.saveExist(name) then
        for _, save in ipairs(saveData.partitions) do
            if save.name == name then
                table.remove(saveData.partitions, _)
            end
        end
    end
    --% sign the file --
    local saveFile = love.filesystem.newFile("bin/slot.dbsys", "w")
    saveFile:write(love.data.compress("string", "gzip", json.encode(saveData)))
    saveFile:close()
end

function Storage.cloneSave(name)
    --% check if save exist --
    if Storage.saveExist(name) then
        local data = Storage.getSaveData(name)
        Storage.createSave(name .. hex.generate(10), data)
    end
    --% sign the file --
    local saveFile = love.filesystem.newFile("bin/slot.dbsys", "w")
    saveFile:write(love.data.compress("string", "gzip", json.encode(saveData)))
    saveFile:close()
end

function Storage.removeAll()
    saveData.partitions = {}
    love.filesystem.remove("bin/slot.dbsys")
    --% sign the file --
    local saveFile = love.filesystem.newFile("bin/slot.dbsys", "w")
    saveFile:write(love.data.compress("string", "gzip", json.encode(saveData)))
    saveFile:close()
end

function Storage.getPartitions()
    return saveData.partitions
end

function Storage.getSaveData(name)
    for _, save in ipairs(saveData.partitions) do
        if save.name == name then
            return save.data
        end
    end
end

function Storage.saveExist(name)
    for _, save in ipairs(saveData.partitions) do
        if save.name == name then
            return true
        end
    end
    return false
end

return Storage