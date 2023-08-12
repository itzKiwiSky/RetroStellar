nodisk = {}

function nodisk:enter()
    littleLogo = {
        {1, 2},
        {3, 4},
    }

    colorStates = {
        {7, 9},
        {9, 7},
    }

    dedications = {
        {
            name = "thsun",
            color = 3,
            heart = {
                enable = true,
                id = "th_heart",
            }
        },
        {
            name = "ayanothefoxy",
            color = 19,
            heart = {
                enable = true,
                id = "fox_heart",
            }
        },
        {
            name = "sloow",
            color = 34,
            heart = {
                enable = false,
            }
        },
        {
            name = "agua-de-pica",
            color = 34,
            heart = {
                enable = false,
            }
        },
        {
            name = "akira 43",
            color = 26,
            heart = {
                enable = true,
                id = "sapo_palhaco_tigre",
            }
        },
        {
            name = "bru",
            color = 34,
            heart = {
                enable = false,
            }
        },
        {
            name = "",
            color = 34,
            heart = {
                enable = false,
            }
        },
        {
            name = "Created by strawberryChocolate",
            color = 22,
            heart = {
                enable = true,
                id = "choco_heart"
            }
        },
    }

    cstate = 1
    timer = 0
end

function nodisk:_render()
    txtPosY = 50
    for y = 1, #littleLogo, 1 do
        for x = 1, #littleLogo[y], 1 do
            stellarAPI.graphics.newSprite("logo_low" .. tostring(littleLogo[y][x]), (x * 16) - 10, (y * 16) - 10)
        end
    end
    stellarAPI.graphics.newText("RetroStellar", 48, 16, colorStates[cstate])
    stellarAPI.graphics.newText("dedicated to:", 50, 40, 34)
    for d = 1, #dedications, 1 do
        stellarAPI.graphics.newText(dedications[d].name, 50, txtPosY + 5, dedications[d].color)
        if dedications[d].heart.enable then
            stellarAPI.graphics.newSprite(dedications[d].heart.id, stellarAPI.graphics.getTextSize(dedications[d].name) + 80, txtPosY)
        end
        txtPosY = txtPosY + 18
    end
end

function nodisk:_update(elapsed)
    timer = timer + 1
    if timer > 10 then
        timer = 0
        cstate = cstate + 1
    end
    if cstate > #colorStates then
        cstate = 1
    end
end

function nodisk:_keydown(k)
    if k == "escape" then
        gamestate.switch(loader)
    end
end

function nodisk:_gamepadpressed(button)
    if button == "b" then
        gamestate.switch(loader)
    end
end

function nodisk:_virtualpadpressed(button)
    if button == "ac_b" then
        gamestate.switch(loader)
    end
end

return nodisk