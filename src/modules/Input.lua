input = {
    keyboard = {},
    gamepad = {},
}

function input.keyboard.keyPressed(key)
    return keyboard.isKeyDown(key)
end

return input