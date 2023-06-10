soundthread = {} 
-- originally written by StrawberryChocolate, modified by AyanoTheFoxy (thanks mate <3)
function soundthread.newTone( freq, waveLength, waveType, bitTax, channel, volume, amplitude, rate)
    --I stole this shit from litium >w<
    if waveType == nil then
        waveType = 'square'
    end
    
    local length    = waveLength / 32
    local phase     = math.floor((rate or 44100) / freq)
    local soundData = love.sound.newSoundData( math.floor(length * (rate or 44100)), rate or 44100, bitTax or 16, channel or 1)
    
    for i = 0, soundData:getSampleCount() - 1 do 
        if waveType == 'noise' then
            soundData:setSample( i, math.random()) 
        elseif waveType == 'sine' then
            soundData:setSample( i, math.sin(2 * math.pi * i / phase))
        elseif waveType == 'square' then
            soundData:setSample( i, i % phase < phase / 2 and (amplitude or 1) or (-amplitude or -1))
        elseif waveType == 'triangle' then
            soundData:setSample( i, 4 * (amplitude or 1) / phase * math.abs((((i - phase / 4) % phase) + phase) % phase - phase / 2) - (amplitude or 1))
        elseif waveType == 'sawtooth' then
            soundData:setSample( i, 2 * math.atan(math.tan(i / 2)))
        end
    end
    
    snd = love.audio.newSource(soundData)
    
    snd:setVolume(volume or 1)
    return snd
 end 
  
 return soundthread