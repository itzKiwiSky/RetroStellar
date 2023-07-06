touchpad = {}

buttons = {}

function touchpad.init()
    --% try initialization if OSes match
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or DEVMODE.mobileTouchPad then
        textures = {
            dirPad = love.graphics.newImage("resources/images/touchpad.png"),
            dirPadHover = {},
            buttons = {
                star = love.graphics.newImage("resources/images/btn_star.png"),
                heart = love.graphics.newImage("resources/images/btn_heart.png"),
                note = love.graphics.newImage("resources/images/btn_note.png"),
                diamond = love.graphics.newImage("resources/images/btn_diamond.png"),
            },
            neutral = love.graphics.newImage("resources/images/neutral_button.png"),
            neutralHover = love.graphics.newImage("resources/images/neutral_button_hover.png"),
        }
        for t = 1, 4, 1 do
            table.insert(textures.dirPadHover, love.graphics.newImage("resources/images/touchpad_hover" .. t .. ".png"))
        end

        --% DPAD --
        buttons[1] = {x = 0, y = love.graphics.getHeight() - (textures.dirPad:getHeight() / 2), w = 85, h = 85, touched = false, name = "dp_left_up"}
        buttons[2] = {x = 85, y = love.graphics.getHeight() - (textures.dirPad:getHeight() / 2), w = 85, h = 85, touched = false, name = "dp_up"}
        buttons[3] = {x = 170, y = love.graphics.getHeight() - (textures.dirPad:getHeight() / 2), w = 85, h = 85, touched = false, name = "dp_right_up"}
        buttons[4] = {x = 0, y = love.graphics.getHeight() - (textures.dirPad:getHeight() / 2) + 85, w = 85, h = 85, touched = false, name = "dp_left"}
        buttons[5] = {x = 170, y = love.graphics.getHeight() - (textures.dirPad:getHeight() / 2) + 85, w = 85, h = 85, touched = false, name = "dp_right"}
        buttons[6] = {x = 0, y = love.graphics.getHeight() - (textures.dirPad:getHeight() / 2) + 170, w = 85, h = 85, touched = false, name = "dp_left_down"}
        buttons[7] = {x = 85, y = love.graphics.getHeight() - (textures.dirPad:getHeight() / 2) + 170, w = 85, h = 85, touched = false, name = "dp_down"}
        buttons[8] = {x = 170, y = love.graphics.getHeight() - (textures.dirPad:getHeight() / 2) + 170, w = 85, h = 85, touched = false, name = "dp_right_down"}
        --% Action buttons --
        buttons[9] = {x = love.graphics.getWidth() - (256 / (2 * 0.7)), y = love.graphics.getHeight() - (384 / (2 * 0.7)), w = 89, h = 89, touched = false, name = "ac_y"}
        buttons[10] = {x = love.graphics.getWidth() - (128 / (2 * 0.7)), y = love.graphics.getHeight() - (256 / (2 * 0.7)), w = 89, h = 89, touched = false, name = "ac_b"}
        buttons[11] = {x = love.graphics.getWidth() - (384 / (2 * 0.7)), y = love.graphics.getHeight() - (256 / (2 * 0.7)), w = 89, h = 89, touched = false, name = "ac_x"}
        buttons[12] = {x = love.graphics.getWidth() - (256 / (2 * 0.7)), y = love.graphics.getHeight() - (128 / (2 * 0.7)), w = 89, h = 89, touched = false, name = "ac_a"}
        --% Neutral buttons --
        buttons[13] = {x = (love.graphics.getWidth() / 2) + (170 - 48), y = love.graphics.getHeight() - (128 - 48), w = 96, h = 32, touched = false, name = "nt_start"}
        buttons[14] = {x = (love.graphics.getWidth() / 2) - (170 + 48), y = love.graphics.getHeight() - (128 - 48), w = 96, h = 32, touched = false, name = "nt_select"}

    end
end



function touchpad.render()
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or DEVMODE.mobileTouchPad then
        love.graphics.draw(textures.dirPad, 0, love.graphics.getHeight() - (textures.dirPad:getHeight() / 2), 0, 0.5, 0.5)
        if touchpad.getPressedButton() == "dp_left_up" then
            love.graphics.draw(textures.dirPadHover[1], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
            love.graphics.draw(textures.dirPadHover[4], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
        elseif touchpad.getPressedButton() == "dp_up" then
            love.graphics.draw(textures.dirPadHover[1], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
        elseif touchpad.getPressedButton() == "dp_right_up" then
            love.graphics.draw(textures.dirPadHover[1], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
            love.graphics.draw(textures.dirPadHover[2], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
        elseif touchpad.getPressedButton() == "dp_left" then
            love.graphics.draw(textures.dirPadHover[4], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
        elseif touchpad.getPressedButton() == "dp_right" then
            love.graphics.draw(textures.dirPadHover[2], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
        elseif touchpad.getPressedButton() == "dp_left_down" then
            love.graphics.draw(textures.dirPadHover[3], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
            love.graphics.draw(textures.dirPadHover[4], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
        elseif touchpad.getPressedButton() == "dp_down" then
            love.graphics.draw(textures.dirPadHover[3], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
        elseif touchpad.getPressedButton() == "dp_right_down" then
            love.graphics.draw(textures.dirPadHover[3], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
            love.graphics.draw(textures.dirPadHover[2], 0, love.graphics.getHeight() - (textures.dirPadHover[1]:getHeight() / 2), 0, 0.5, 0.5)
        end

        if touchpad.getPressedButton() == "nt_start" then
            love.graphics.draw(textures.neutralHover, (love.graphics.getWidth() / 2) + 170, love.graphics.getHeight() - 128, 0, 1, 1, textures.neutral:getWidth() / 2)
        else
            love.graphics.draw(textures.neutral, (love.graphics.getWidth() / 2) + 170, love.graphics.getHeight() - 128, 0, 1, 1, textures.neutral:getWidth() / 2)
        end

        if touchpad.getPressedButton() == "nt_select" then
            love.graphics.draw(textures.neutralHover, (love.graphics.getWidth() / 2) - 170, love.graphics.getHeight() - 128, 0, 1, 1, textures.neutral:getWidth() / 2)
        else
            love.graphics.draw(textures.neutral, (love.graphics.getWidth() / 2) - 170, love.graphics.getHeight() - 128, 0, 1, 1, textures.neutral:getWidth() / 2)
        end

        if touchpad.getPressedButton() == "ac_y" then
            love.graphics.setColor(0.5, 0.5, 0.5)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.draw(textures.buttons.star, love.graphics.getWidth() - (256 / (2 * 0.7)), love.graphics.getHeight() - (384 / (2 * 0.7)), 0, 0.7, 0.7)
        love.graphics.setColor(1, 1, 1)

        if touchpad.getPressedButton() == "ac_b" then
            love.graphics.setColor(0.5, 0.5, 0.5)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.draw(textures.buttons.diamond, love.graphics.getWidth() - (128 / (2 * 0.7)), love.graphics.getHeight() - (256 / (2 * 0.7)), 0, 0.7, 0.7)
        love.graphics.setColor(1, 1, 1)
        if touchpad.getPressedButton() == "ac_x" then
            love.graphics.setColor(0.5, 0.5, 0.5)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.draw(textures.buttons.note, love.graphics.getWidth() - (384 / (2 * 0.7)), love.graphics.getHeight() - (256 / (2 * 0.7)), 0, 0.7, 0.7)
        love.graphics.setColor(1, 1, 1)
        if touchpad.getPressedButton() == "ac_a" then
            love.graphics.setColor(0.5, 0.5, 0.5)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.draw(textures.buttons.heart, love.graphics.getWidth() - (256 / (2 * 0.7)), love.graphics.getHeight() - (128 / (2 * 0.7)), 0, 0.7, 0.7)
        love.graphics.setColor(1, 1, 1)

        if DEVMODE.showTouchpadButtons then
            for _, btn in ipairs(buttons) do
                if btn.touched then
                    love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h)
                else
                    love.graphics.rectangle("line", btn.x, btn.y, btn.w, btn.h)
                end
            end

        end
    end
end

function touchpad.update(elapsed)
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or DEVMODE.mobileTouchPad then
        local mx, my = love.mouse.getPosition()
        for _, btn in ipairs(buttons) do
            btn.touched = checkButtonTouch(mx, my, buttons[_])
        end
    end
end

function touchpad.getPressedButton()
    for _, btn in ipairs(buttons) do
        if btn.touched then
            return btn.name
        end
    end
end

function checkButtonTouch(tx, ty, button)
    if love.mouse.isDown(1) and tx >= button.x and ty >= button.y and tx <= button.x + button.w and ty <= button.y + button.h then
         return true
    else
        return false
    end
end

return touchpad