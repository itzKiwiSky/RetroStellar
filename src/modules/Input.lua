astroAPI.input = {
    keyboard = {},
    gamepad = {},
    virtualGamepad = {}
}

local gamepad = require 'src.core.virtualization.Gamepad'

function astroAPI.input.keyboard.keyPressed(key)
    return keyboard.isKeyDown(key)
end

function astroAPI.input.gamepad.buttonPressed(player, button)
    return gamepad.isButtonDown(player, button)
end

function astroAPI.input.gamepad.getTotalPlayers()
    return #_gamepads
end

function astroAPI.input.gamepad.getAxis(player, axis)
    gamepad.getAxis(player, axis)
end

function astroAPI.input.gamepad.vibrate(player, side, strength, duration)
    gamepad.vibrate(player, side, strength, duration)
end

function astroAPI.input.virtualGamepad.getPressedButton()
    return touchpad.getPressedButton()
end

return input