astroAPI.storage = {}

function astroAPI.storage.createSave(name, data)
    storagedvr.createSave(name, data)
end

function astroAPI.storage.getSaveData(name)
    return storagedvr.getSaveData(name)
end

function astroAPI.storage.isSaveExist(name)
    return storagedvr.saveExist(name)
end

return astroAPI.storage