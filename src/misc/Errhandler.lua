function love.errorhandler(msg)
    print(debug.traceback(msg))
    text = require 'src.core.components.Text'
    vram = require 'src.core.virtualization.VRAM'
    render = require 'src.core.Render'
    graphics = require 'src.modules.Graphics'
    fontdata = require 'src.core.components.FontData'
    require 'libraries.addons.split'

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
    
    local traceback = {
        "The system founds an error and needs be",
        "rebooted.",
        "",
        "Check the crashLog.txt at:",
        "appdata/roaming/com.nxstudios.stellar/crashlog.txt",
        "or check the system console output.",
        "The system will automaticly shutdown in a few seconds",
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
        graphics.newText("The system found an error crashed", 70, 18, 34)
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
            end
		end

		draw()

        timer = timer + 1
        if timer > 10 then
            currentValue = currentValue + 5
        end

        if currentValue >= 110 then
            love.event.quit()
        end

		if love.timer then
			love.timer.sleep(0.1)
		end
	end
end