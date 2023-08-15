local gamepad = {}

function gamepad.isButtonDown(player, button)
    if #_gamepads > 0 then
        return _gamepads[player or 1]:isGamepadDown(button)
    end
end

function gamepad.getAxis(player, axis)
    if #_gamepads > 0 then
        return _gamepads[player or 1]:getGamepadAxis(axis)
    end
end

function gamepad.vibrate(player, side, strength, duration)
    if #_gamepads > 0 then
        if _gamepads[player or 1]:isVibrationSupported() then
            if side == "left" then
                return _gamepads[player]:setVibration(strength, 0, duration)
            end
            if side == "left" then
                return _gamepads[player]:setVibration(0, strength, duration)
            end
            if side == "both" then
                return _gamepads[player]:setVibration(strength, strength, duration)
            end
        end
    end
end

return gamepad