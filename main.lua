vram = require 'src.core.virtualization.VRAM'
_version = love.filesystem.read(".version")
love.filesystem.load("src/misc/Run.lua")()
love.filesystem.load("src/misc/Errhandler.lua")()
function love.load()
    --% third party libs --
    Version = require 'libraries.version'
    hex = require 'src.core.components.Hex'
    json = require 'libraries.json'
    render = require 'src.core.Render'
    memory = require 'src.core.components.Memory'
    keyboard = require 'src.core.virtualization.Keyboard'
    storagedvr = require 'src.core.virtualization.Storage'
    moonshine = require 'libraries.moonshine'
    gamestate = require 'libraries.gamestate'
    touchpad = require 'src.core.virtualization.Touchpad'
    shack = require 'libraries.shack'
    apu = require 'src.core.virtualization.APU'


    love.graphics.setDefaultFilter("nearest", "nearest")

    effect = moonshine(moonshine.effects.crt)
    .chain(moonshine.effects.glow)
    .chain(moonshine.effects.scanlines)

    effect.glow.strength = 5
    effect.glow.min_luma = 0.7
    effect.scanlines.width = 1
    effect.scanlines.opacity = 0.5

    storagedvr.init()

    --% addons loader --
    Addons = love.filesystem.getDirectoryItems("libraries/addons")
    for addon = 1, #Addons, 1 do
        require("libraries.addons." .. string.gsub(Addons[addon], ".lua", ""))
    end

    --% api --
    stellarAPI = require 'src.modules.Stellar'


    __updateShaders__()

    if stellarAPI.storage.isSaveExist("__system__") then
        systemData = stellarAPI.storage.getSaveData("__system__")
        --print(debug.getTableContent(systemData))
        love.audio.setVolume(0.1 * tonumber(systemData[1][4].value))
    end

    --% gamepad system --
    _gamepads = love.joystick.getJoysticks()

    --% cool vars --
    hasPackage = true

    DEVMODE = {
        screenBounds = false,   -- legacy
        mobileTouchPad = false,
        showTouchpadButtons = false,
        listObjects = false,
        showMemory = true,
        showFPS = true,
        crashOnF12 = false,
        convertToBinSave = true,
    }

    --% initialization folders --
    love.filesystem.createDirectory("bin")
    love.filesystem.createDirectory("bin/disks")
    love.filesystem.createDirectory("bin/disks/A")
    love.filesystem.createDirectory("bin/disks/A/projects")

    --% initialization stuff to the package --

    if love.filesystem.isFused() then
        dataFile = love.filesystem.getInfo(love.filesystem.getSourceBaseDirectory() .. "/data.pkg")
    else
        dataFile = love.filesystem.getInfo("Build/instance/data.pkg")
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
            sucess = love.filesystem.mount(love.filesystem.getSourceBaseDirectory() .. "/lumina.fmw", "baserom")
            print(love.filesystem.getSourceBaseDirectory())
            --print(sucess)
        --else
            --sucess = love.filesystem.mount("Build/instance/", "baserom")
            --print(sucess)
        end
    end
    
    --% load the default fontchr file --
    vram.buffer.font = json.decode(love.data.decompress("string", "zlib", love.filesystem.read("BIOS/FONTCHR.chr")))

    --% load the rom logic --
    data = love.filesystem.load("BIOS/boot.lua")

    --% initialize render stuff (create the first frame)
    render.init()
    touchpad.init()

    pcall(data(), _init())
end

function love.draw()
    love.graphics.push()
    shack:apply()
    render.drawCall()
    love.graphics.pop()
    pcall(data(), _render())
    touchpad.render()
    if DEVMODE.listObjects then
        local y = 15
        love.graphics.print(love.timer.getFPS())
        for _, spr in ipairs(vram.buffer.bank) do
            love.graphics.print("$" .. spr.name, 3, y)
            y = y + 15
        end
    end
    if DEVMODE.showMemory then
        memory.render()
    end
    if DEVMODE.showFPS then
        love.graphics.print(love.timer.getFPS())
    end
end

function love.update(elapsed)
    __updateShaders__()
    shack:update(elapsed)
    touchpad.update(elapsed)
    memory.update()
    pcall(data(), _update(elapsed))
end

function love.keypressed(k)
    for _, value in ipairs(keyboard.keys) do
        if value == k then
            pcall(data(), _keydown(k))
        end
    end
    if k == "f12" then
        if DEVMODE.crashOnF12 then
            error("The system causes a provisory crash")
        end
    end
end

function love.gamepadpressed(joystick, button)
    pcall(data(), _gamepadpressed(button))
end

function love.mousepressed(x, y, btn)
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" or DEVMODE.mobileTouchPad then
        touchpad.update()
        if touchpad.getPressedButton() ~= nil then
            pcall(data(), _virtualpadpressed(touchpad.getPressedButton()))
        end
    end
end

---------------------------------------------

function __updateShaders__()
    if stellarAPI.storage.isSaveExist("__system__") then
        local systemData = stellarAPI.storage.getSaveData("__system__")
        if not systemData[1][1].value then
            effect.disable("crt")
        else
            effect.enable("crt")
        end
        if not systemData[1][2].value then
            effect.disable("glow")
        else
            effect.enable("glow")
        end
        if not systemData[1][3].value then
            effect.disable("scanlines")
        else
            effect.enable("scanlines")
        end
    end
end