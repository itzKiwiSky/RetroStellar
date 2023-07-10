sound = {}

function sound.load(songfile)
    apu.loadSong(songfile)
end

function sound.play()
    apu.play()
end

function sound.update()
    apu.update()
end

return sound