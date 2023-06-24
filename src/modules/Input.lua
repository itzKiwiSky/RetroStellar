input = {
    keyboard = {},
    gamepad = {},
    virtualGamepad = {}
}

gamepad = require 'src.core.virtualization.Gamepad'

function input.keyboard.keyPressed(key)
    return keyboard.isKeyDown(key)
end

function input.gamepad.buttonPressed(player, button)
    return gamepad.isButtonDown(player, button)
end

function input.gamepad.getAxis(player, axis)
    gamepad.getAxis(player, axis)
end

function input.gamepad.vibrate(player, side, strength, duration)
    gamepad.vibrate(player, side, strength, duration)
end

function input.virtualGamepad.getPressedButton()
    return touchpad.getPressedButton()
end

return input