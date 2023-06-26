save_storage = {}

function save_storage.createSave(name, data)
    storagedvr.createSave(name, data)
end

function save_storage.getSaveData(name)
    return storagedvr.getSaveData(name)
end

function save_storage.isSaveExist(name)
    return storagedvr.saveExist(name)
end

return save_storage