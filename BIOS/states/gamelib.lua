local gamelib = {}

function gamelib:enter()
    astroAPI.graphics.setBackgroundColor(20)

    games = astroAPI.system.getDirItems("bin/library")
end

function gamelib:_render()
    astroAPI.graphics.newText()
end

function gamelib:_update(elapsed)

end

function gamelib:_keydown(k)
    
end

function gamelib:_gamepadpressed(button)
    
end

function gamelib:_virtualpadpressed(button)
    
end

return gamelib