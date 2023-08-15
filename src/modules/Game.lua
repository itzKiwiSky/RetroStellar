astroAPI.game = {}

function astroAPI.game.createObjectHitbox(_x, _y, _w, _h)
    return {
        x = _x,
        y = _y,
        w = _w,
        h = _h
    }
end

return astroAPI.game