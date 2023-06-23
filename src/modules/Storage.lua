save_storage = {}

function save_storage.createSave(name, data)
    storage.createSave(name, data)
end

function save_storage.getSaveData(name)
    storage.getSaveData(name)
end

function save_storage.isSaveExist(name)
    storage.saveExist(name)
end

return save_storage