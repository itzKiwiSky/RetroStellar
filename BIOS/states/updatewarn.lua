warn = {}

function warn:enter()
    littleLogo = {
        {1, 2},
        {3, 4},
    }

    colorStates = {
        {7, 9},
        {9, 7},
    }

    cstate = 1
    timer = 0

    texts = {
        "Looks like your system is outdated",
        "Please got to the github page",
        "to get the lastest release of retrostellar",
        " ",
        " ",
        " ",
        " ",
        " ",
        "press [enter] to shutdown."
    }
end

function warn:_render()
    local txtY = 60
    for y = 1, #littleLogo, 1 do
        for x = 1, #littleLogo[y], 1 do
            stellarAPI.graphics.newSprite("logo_low" .. tostring(littleLogo[y][x]), (x * 16) - 10, (y * 16) - 10)
        end
    end
    stellarAPI.graphics.newText("RetroStellar", 48, 16, colorStates[cstate])
    for t = 1, #texts, 1 do
        stellarAPI.graphics.newText(texts[t], 30, txtY, 34)
        txtY = txtY + 9
    end
end

function warn:_update(elapsed)
    timer = timer + 1
    if timer > 10 then
        timer = 0
        cstate = cstate + 1
    end
    if cstate > #colorStates then
        cstate = 1
    end
end

function warn:_keydown(k)
    if k == "return" then
        stellarAPI.system.shutdown()
    end
end

function warn:_gamepadpressed(button)
    if button == "start" then
        stellarAPI.system.shutdown()
    end
end

function warn:_virtualpadpressed(button)
    if button == "nt_start" then
        stellarAPI.system.shutdown()
    end
end

return warn