system = {}

function system.shutdown()
    love.event.quit()
end

function system.vibrate(intensity)
    if intensity > 1 then
        intensity = 1
    elseif intensity < 0 then
        intensity = 0
    end
    shack:setShake(intensity * 3)
end

return system