gamepad = {}

function gamepad.isButtonDown(player, button)
    if #_gamepads > 0 then
        assert(type(player) == "number", "[ERROR] :: Invalid type | Expected 'Number' got " .. type(player))
        assert(type(button) == "string", "[ERROR] :: Invalid type | Expected 'String' got " .. type(player))
        assert(player < 1 and player > #_gamepads, "[ERROR] :: Out of range of players | Expect number between 1 and " .. #_gamepads)
        return _gamepads[player or 1]:isGamepadDown(button)
    end
end

function gamepad.getAxis(player, axis)
    if #_gamepads > 0 then
        assert(type(player) == "number", "[ERROR] :: Invalid type | Expected 'Number' got " .. type(player))
        assert(player < 1 and player > #_gamepads, "[ERROR] :: Out of range of players | Expect number between 1 and " .. #_gamepads)
        return _gamepads[player or 1]:getGamepadAxis(axis)
    end
end

function gamepad.vibrate(player, side, strength, duration)
    if #_gamepads > 0 then
        assert(type(player) ~= "number", "[ERROR] :: Invalid type | Expected 'Number' got " .. type(player))
        assert(player < 1 or player > #_gamepads, "[ERROR] :: Out of range of players | Expect number between" .. #_gamepads)
        if _gamepads[player or 1]:isVibrationSupported() then
            if side == "left" then
                return _gamepads[player]:setVibration(Strength, 0, duration)
            end
            if side == "left" then
                return _gamepads[player]:setVibration(0, Strength, duration)
            end
            if side == "both" then
                return _gamepads[player]:setVibration(Strength, Strength, duration)
            end
        end
    end
end

return gamepad