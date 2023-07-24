vram = require 'src.core.virtualization.VRAM'
_version = love.filesystem.read(".version")
--love.filesystem.load("src/misc/Run.lua")()
--love.filesystem.load("src/misc/Errhandler.lua")()

print("-===#####[ RetroStellar ]#####===-")
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
        screenBounds = false,   --:: legacy ::--
        mobileTouchPad = false,
        showTouchpadButtons = false,
        listObjects = false,
        showMemory = false,
        showFPS = false,
        crashOnF12 = true,
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
        dataFile = love.filesystem.getInfo("Build/game/boot.lua")
    end
    
    if dataFile == nil then
        hasPackage = false
    else
        hasPackage = true
    end

    if hasPackage then
        print("[EVENT] :: Cart found")
        if love.filesystem.isFused() then
            sucess = love.filesystem.mount(love.filesystem.getSourceBaseDirectory() .. "/data.pkg", "baserom")
            
            vram.buffer.font = json.decode(love.data.decompress("string", "zlib", love.filesystem.read("baserom/FONTCHR.chr")))
            print("[EVENT] :: Loaded font chars")
            vram.buffer.bank = json.decode(love.data.decompress("string", "zlib", love.filesystem.read("baserom/SPRCHR.spr")))
            print("[EVENT] :: Loaded " .. #vram.buffer.bank .. "/128 sprites")
            data = love.filesystem.load("baserom/boot.lua")
        else
            print("[EVENT] :: Cart loaded")
            sucess = love.filesystem.mount("Build/game", "baserom")

            vram.buffer.font = json.decode(love.data.decompress("string", "zlib", love.filesystem.read("baserom/FONTCHR.chr")))
            print("[EVENT] :: Loaded font chars")
            vram.buffer.bank = json.decode(love.data.decompress("string", "zlib", love.filesystem.read("baserom/SPRCHR.spr")))
            print("[EVENT] :: Loaded " .. #vram.buffer.bank .. "/128 sprites")
            data = love.filesystem.load("baserom/boot.lua")
        end
    else
        print("[EVENT] :: Initializing BIOS")
        --% load the default fontchr file --
        vram.buffer.font = json.decode(love.data.decompress("string", "zlib", love.filesystem.read("BIOS/FONTCHR.chr")))

        --% load the rom logic --
        data = love.filesystem.load("BIOS/boot.lua")
    end


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

function love.errorhandler(msg)
    print(debug.traceback(msg))
    text = require 'src.core.components.Text'
    vram = require 'src.core.virtualization.VRAM'
    render = require 'src.core.Render'
    graphics = require 'src.modules.Graphics'
    --vram.buffer.font = require 'src.core.components.FontData'
    require 'libraries.addons.split'
    require 'libraries.addons.getTableContent'

    local log = love.filesystem.newFile("crashLog.txt", "w")
    log:write(debug.traceback(msg))
    log:close()

    timer = 0
    currentValue = 0
    hex = ""

    littleLogo = {
        {1, 2},
        {3, 4},
    }

    render.init()
    
    local traceback = {
        "The system founds an error and needs be",
        "rebooted.",
        "",
        "Check the crashLog.txt at:",
        "appdata/roaming/com.nxstudios.stellar/crashlog.txt",
        "or check the system console output.",
        "Press [enter] to open the crashlog",
        "",
        "___________________________________________________",
        string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)),
        string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)),
        string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)),
        string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)),
        string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)),
        string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)),
        string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)),
        string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)) .. "  " .. string.format("[0x%X]", love.math.random(0x0000, 0xFFFF)),

    }

    SW, SH = graphics.getScreenDimentions()
    
    --local errorText = string.split(traceback, "\n")

    --vram.buffer.font = fontdata

    stellarAPI.graphics.loadFontBankFromPath("resources/data/FONTCHR")
    stellarAPI.graphics.loadSpriteBankFromPath("resources/data/SPRCHR")    

    function draw()
        local txtY = 45
        love.graphics.clear(0, 0, 0)
        graphics.setBackgroundColor(7)
        for y = 1, #littleLogo, 1 do
            for x = 1, #littleLogo[y], 1 do
                graphics.newSprite("logo_low" .. tostring(littleLogo[y][x]), (x * 16) - 10, (y * 16) - 10)
            end
        end
        graphics.newSprite("warning", 50, 15)
        graphics.newText("ops! an error happened", 70, 18, 34)
        for t = 1, #traceback, 1 do
            graphics.newText(traceback[t], 20, txtY, 34)
            txtY = txtY + 10
        end
        graphics.newRectangle(34, 0, SH - 10, math.floor(SW * (currentValue / 100)), 10)
        render.drawCall()
        love.graphics.present()
    end
    return function()
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
            elseif e == "keypressed" and a == "return" then
                love.system.openURL("file:///" .. love.filesystem.getSaveDirectory() .. "/crashLog.txt")
            end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
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