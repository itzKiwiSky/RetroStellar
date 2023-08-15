loader = {}

function loader:enter()
    logo = {
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 10, 11, 12},
        {13, 14, 15, 16}
    }
    stars = {}
    colorStates = {
        {7, 9},
        {9, 7},
    }
    SW, SH = astroAPI.graphics.getScreenDimentions()

    cstate = 1
    timer = 0
    curValue = 0
    for s = 1, 20, 1 do
        createStarsInit()
    end
end

function loader:_render()
    for _, star in ipairs(stars) do
        if star.variations == 1 then
            astroAPI.graphics.newSprite("star1", star.x, star.y)
        elseif star.variations == 2 then
            astroAPI.graphics.newSprite("star2", star.x, star.y)
        end
    end
    for y = 1, #logo, 1 do
        for x = 1, #logo[y], 1 do
            astroAPI.graphics.newSprite("logo" .. tostring(logo[y][x]), 155 + (x * 16), 90 + (y * 16), 1)
        end
    end
    astroAPI.graphics.newText("RetroAstro", 165, 220, colorStates[cstate])
    astroAPI.graphics.newText("[delete] [start] config", 0, SH - 8, 34)
    astroAPI.graphics.newText("[f1] [select] save manager", 0, SH - 16, 34)
    astroAPI.graphics.newText("[f4] credits", 0, SH - 24, 34)
    astroAPI.graphics.newText("[esc] shutdown", 0, SH - 32, 34)
    astroAPI.graphics.newText("[f3] gamelib", 0, SH - 39, 34)
    astroAPI.graphics.newText("No disk has found! please insert a valid disk.", 10, 10)
    astroAPI.graphics.newText("Version " .. _version, SW - astroAPI.graphics.getTextSize("Version " .. _version), SH - 8, 34)
end

function loader:_update(elapsed)
    astroAPI.sound.update(elapsed)
    timer = timer + 1
    if timer >= 30 then
        createStars()
        timer = 0
        cstate = cstate + 1
    end
    for _, star in ipairs(stars) do
        star.x = star.x - star.speed
        if star.x < 0 then
            table.remove(stars, _)
        end
    end
    if cstate > #colorStates then
        cstate = 1
    end
end

function loader:_keydown(k)
    if k == "delete" then
        gamestate.switch(setup)
    end
    if k == "f4" then
        gamestate.switch(credits)
    end
    if k == "f1" then
        gamestate.switch(savemngr)
    end
    if k == "f2" then
        gamestate.switch(debugscreen)
    end
    if k == "f3" then
        gamestate.switch(gamelib)
    end
    if k == "escape" then
        astroAPI.system.shutdown()
    end
end

function loader:_gamepadpressed(button)
    if button == "start" then
        gamestate.switch(setup)
    elseif button == "back" then
        gamestate.switch(savemngr)
    else
        for p = 1, astroAPI.input.gamepad.getTotalPlayers(), 1 do
            astroAPI.input.gamepad.vibrate(p, "both", 1, 0.5)
        end
        astroAPI.sound.load("BIOS/hit.smf")
        astroAPI.sound.play()
    end
end

function loader:_virtualpadpressed(button)
    if button == "nt_start" then
        gamestate.switch(setup)
    elseif button == "nt_select" then
        gamestate.switch(savemngr)
    else
        astroAPI.system.vibrate(1)
        astroAPI.sound.load("BIOS/hit.smf")
        astroAPI.sound.play()
    end
end

---------------------------------------------

function createStars()
    Star = {}
    Star.variations = math.random(1, 2)
    Star.speed = math.random(1, 2)
    Star.x = 400
    Star.y = math.random(16, 284)
    table.insert(stars, Star)
end

function createStarsInit()
    Star = {}
    Star.variations = math.random(1, 2)
    Star.speed = math.random(1, 2)
    Star.x = math.random(16, 384)
    Star.y = math.random(16, 284)
    table.insert(stars, Star)
end

return loader