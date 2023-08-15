astroAPI.sound = {}

function astroAPI.sound.load(songfile)
    apu.loadSong(songfile)
end

function astroAPI.sound.play()
    apu.play()
end

function astroAPI.sound.update()
    apu.update()
end

return astroAPI.sound