vram = require 'src.core.virtualization.VRAM'
_version = "0.0.1"
function love.load()
    --% third party libs --
    json = require 'libraries.json'
    render = require 'src.core.Render'
    memory = require 'src.core.components.Memory'
    keyboard = require 'src.core.virtualization.Keyboard'
    storage = require 'src.core.virtualization.Storage'

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