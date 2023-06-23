vram = require 'src.core.virtualization.VRAM'
_version = "0.0.1"
function love.load()
    --% third party libs --
    json = require 'libraries.json'
    render = require 'src.core.Render'
    memory = require 'src.core.components.Memory'
    keyboard = require 'src.core.virtualization.Keyboard'
    storage = require 'src.core.virtualization.Storage'
    moonshine = require 'libraries.moonshine'
    gamestate = require 'libraries.gamestate'

    effect = moonshine(moonshine.effects.crt)
    .chain(moonshine.effects.glow)
    .chain(moonshine.effects.scanlines)
    .chain(moonshine.effects.vignette)

    effect.glow.strength = 5
    effect.glow.min_luma = 0.2
    effect.scanlines.width = 1
    effect.scanlines.opacity = 0.5
    effect.vignette.opacity = 0.3
    effect.vignette.softness = 0.7
    effect.vignette.radius = 0.4

    storage.init()

    --% addons loader --
    Addons = love.filesystem.getDirectoryItems("libraries/addons")
    for addon = 1, #Addons, 1 do
        require("libraries.addons." .. string.gsub(Addons[addon], ".lua", ""))
    end

    --% api --
    stellarAPI = require 'src.modules.Stellar'

    --% gamepad system --
    _gamepads = love.joystick.getJoysticks()

    --% cool vars --
    hasPackage = true
    errorCodes = {
        "0x0000001"
    }
    DEVMODE = true

    --% initialization folders --
    love.filesystem.createDirectory("bin")

    --% initialization stuff to the package --

    if love.filesystem.isFused() then
        dataFile = love.filesystem.getInfo(love.filesystem.getSourceBaseDirectory() .. "/data.pkg")
    else
        dataFile = love.filesystem.getInfo("data.pkg")
    end
    
    if dataFile == nil then
        hasPackage = false
    end

    if hasPackage then
        if love.filesystem.isFused() then
            sucess = love.filesystem.mount(love.filesystem.getSourceBaseDirectory() .. "/data.pkg", "baserom")
            print(love.filesystem.getSourceBaseDirectory())
            print(sucess)
        else
            sucess = love.filesystem.mount("Build/instance/data.pkg", "baserom")
            print(sucess)
        end
    else
        if love.filesystem.isFused() then
            sucess = love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "baserom")
            print(love.filesystem.getSourceBaseDirectory())
            --print(sucess)
        else
            sucess = love.filesystem.mount("Build/instance", "baserom")
            --print(sucess)
        end
    end

    --% load the default fontchr file --
    vram.buffer.font = json.decode(love.data.decompress("string", "zlib", love.filesystem.read("baserom/FONTCHR.chr")))
    --% load the rom logic --
    data = love.filesystem.load("baserom/boot.lua")
    --% initialize render stuff (create the first frame)
    render.init()
    pcall(data(), _init())
end

function love.draw()
    local y = 15
    if DEVMODE then
        love.graphics.print(love.timer.getFPS())
        for _, spr in ipairs(vram.buffer.bank) do
            love.graphics.print("$" .. spr.name, 3, y)
            y = y + 15
        end
    end
    render.drawCall()
    pcall(data(), _render())
    memory.render()
end

function love.update(elapsed)
    memory.update()
    pcall(data(), _update(elapsed))
end

function love.keypressed(k)
    for _, value in pairs(keyboard.keys) do
        if value == k then
            pcall(data(), _keydown(k))
        end
    end
end

function gamepadpressed(joystick, button)
    
end