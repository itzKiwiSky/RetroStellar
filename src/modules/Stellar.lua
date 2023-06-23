stellar = {}

return setmetatable({
    graphics = require 'src.modules.Graphics',
    storage = require 'src.modules.Storage',
}, stellarAPI)