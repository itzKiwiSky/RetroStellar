local gamelib = {}

local function _createPage(_tbl, _index, _end)
    local page = {}
    for i = _index, _end, 1 do
        table.insert(page, _tbl[i])
    end
    return page
end

local function _splitPages(_tbl)
    local pages = {}
    local pagesNum = math.ceil(#_tbl / 20)
end

function gamelib:enter()
    astroAPI.graphics.setBackgroundColor(39)

    games = astroAPI.system.getDirItems("bin/library")
    pageRender = 1
    maxPage = 20
    selection = 1
    cursorY = 30
end

function gamelib:_render()
    local gy = 30
    local bootText = "please select a package to boot"
    local sw, sh = astroAPI.graphics.getScreenDimentions()
    --% cool box %--
    astroAPI.graphics.newRectangle(34, 10, 10, sw - 20, sh - 20)
    astroAPI.graphics.newRectangle(39, 11, 11, sw - 22, sh - 22)
    --% end coolbox :( %--
    astroAPI.graphics.newRectangle(34, 10, 10, astroAPI.graphics.getTextSize(bootText) + 2, 9)
    astroAPI.graphics.newText(bootText, 11, 11, 39, 34)
    astroAPI.graphics.newRectangle(34, 29, cursorY - 1, astroAPI.graphics.getTextSize(games[selection]:gsub(".pkg", "")) + 2, 9)
    if #games > 0 then
        for g = pageRender, maxPage, 1 do
            astroAPI.graphics.newText(games[g]:gsub(".pkg", ""), 30, gy, 34)
            gy = gy + 10
        end
    end
end

function gamelib:_update(elapsed)
    if #games < 20 then
        maxPage = #games
    else
        maxPage = 20
    end
    if selection < 1 then
        selection = 1
    end
    if selection > #games then
        selection = #games
    end
    if cursorY < 30 then
        cursorY = 30
    end
    if cursorY > 220 then
        cursorY = 220
    end
end

function gamelib:_keydown(k)
    if k == "up" then
        selection = selection - 1
        cursorY = cursorY - 10        if cursorY > 220 then
            pageRender = pageRender + 1
            maxPage = maxPage + 1
        end
        if cursorY < 30 then
            pageRender = pageRender - 1
            maxPage = maxPage - 1
        end
    end
    if k == "down" then
        selection = selection + 1
        cursorY = cursorY + 10
        if cursorY > 220 then
            pageRender = pageRender + 1
            maxPage = maxPage + 1
        end
    end
    if k == "return" then
        sucess = love.filesystem.mount("bin/library/" .. games[selection], "baserom")
        data = love.filesystem.load("baserom/boot.lua")
        pcall(data(), _init())
    end
    if k == "escape" then
        gamestate.switch(loader)
    end
end

function gamelib:_gamepadpressed(button)
    
end

function gamelib:_virtualpadpressed(button)
    
end

return gamelib