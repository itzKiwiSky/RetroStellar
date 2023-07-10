splash = {}

function splash:enter()
    frame = 0
    timer = 0
    showText = false

    stellarAPI.sound.load("BIOS/bootloader.smf")
    stellarAPI.sound.play()
end

function splash:_render()
    stellarAPI.graphics.newText(tostring(timer), 0, 0, 34)
    stellarAPI.graphics.newText(tostring(frame), 0, 8, 34)
    if frame >= 1 then
        stellarAPI.graphics.newSprite("logo1", 155 + 16, 90 + 16)
    end
    if frame >= 2 then
        stellarAPI.graphics.newSprite("logo2", 171  + 16, 90 + 16)
    end
    if frame >= 3 then
        stellarAPI.graphics.newSprite("logo3", 187 + 16, 90 + 16)
    end
    if frame >= 4 then
        stellarAPI.graphics.newSprite("logo4", 203 + 16, 90 + 16)
    end
    if frame >= 5 then
        stellarAPI.graphics.newSprite("logo5", 155 + 16, 106 + 16)
    end
    if frame >= 6 then
        stellarAPI.graphics.newSprite("logo6", 171 + 16, 106 + 16)
    end
    if frame >= 7 then
        stellarAPI.graphics.newSprite("logo7", 187 + 16, 106 + 16)
    end
    if frame >= 8 then
        stellarAPI.graphics.newSprite("logo8", 203 + 16, 106 + 16)
    end
    if frame >= 9 then
        stellarAPI.graphics.newSprite("logo9", 155 + 16, 122 + 16)
    end
    if frame >= 10 then
        stellarAPI.graphics.newSprite("logo10", 171 + 16, 122 + 16)
    end
    if frame >= 11 then
        stellarAPI.graphics.newSprite("logo11", 187 + 16, 122 + 16)
    end
    if frame >= 12 then
        stellarAPI.graphics.newSprite("logo12", 203 + 16, 122 + 16)
    end
    if frame >= 13 then
        stellarAPI.graphics.newSprite("logo13", 155 + 16, 138 + 16)
    end
    if frame >= 14 then
        stellarAPI.graphics.newSprite("logo14", 171 + 16, 138 + 16)
    end
    if frame >= 15 then
        stellarAPI.graphics.newSprite("logo15", 187 + 16, 138 + 16)
    end
    if frame >= 16 then
        stellarAPI.graphics.newSprite("logo16", 203 + 16, 138 + 16)
        stellarAPI.graphics.newText("RetroStellar", 165, 220, {7, 9})
    end
end

function splash:_update(elapsed)
    stellarAPI.sound.update(elapsed)
    if not showText then
        timer = timer + 1
    end
    if timer > 3 then
        timer = 0
        frame = frame + 1
        if frame > 16 then
            timer = 0
            if frame > 20 then
                gamestate.switch(loader)
            end
        end
    end
end

function splash:_keypressed(k)
    
end

function splash:_gamepadpressed(button)
    
end

function splash:_virtualpadpressed(button)
    
end

return splash