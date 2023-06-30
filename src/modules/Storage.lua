storage = {}

function storage.createSave(name, data)
    storagedvr.createSave(name, data)
end

function storage.getSaveData(name)
    return storagedvr.getSaveData(name)
end

function storage.isSaveExist(name)
    return storagedvr.saveExist(name)
end

return storage