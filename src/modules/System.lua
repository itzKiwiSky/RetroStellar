astroAPI.system = {
    vram = {}
}

function astroAPI.system.shutdown()
    love.event.quit()
end

function astroAPI.system.vibrate(_intensity)
    if intensity > 1 then
        intensity = 1
    elseif intensity < 0 then
        intensity = 0
    end
    shack:setShake(_intensity * 3)
end

function astroAPI.system.vram.getVRAMInfo()
    return vram.getInfo()
end

function astroAPI.system.getDirItems(_dir)
    return love.filesystem.getDirectoryItems(_dir)
end

function astroAPI.system.getFileInfo(_file)
    return love.filesystem.getInfo(_file)
end

return astroAPI.system