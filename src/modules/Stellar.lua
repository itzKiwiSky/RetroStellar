stellar = {}

return setmetatable({
    callbacks = {},
    graphics = require 'src.modules.Graphics',
    storage = require 'src.modules.Storage',
    system = require 'src.modules.System',
    input = require 'src.modules.Input'
}, stellarAPI)