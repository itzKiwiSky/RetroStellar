setup = {}

function setup:enter()
    stellarAPI.graphics.setBackgroundColor(7)

    currentTab = 1
    currentItem = 1
    sprY = 30
    maxY = 0

    configList = {
        tabs = {
            {
                name = "video",
                selected = true,
                content = {
                    {
                        name = "crt effect",
                        type = "boolean",
                        selected = false,
                        value = true,
                    },
                    {
                        name = "glow effect",
                        type = "boolean",
                        selected = false,
                        value = true,
                    },
                    {
                        name = "scanlines effect",
                        type = "boolean",
                        selected = false,
                        value = true,
                    },
                }
            },
            {
                name = "audio",
                selected = false,
                content = {
                    {
                        name = "master volume",
                        type = "number",
                        selected = false,
                        min = 0,
                        max = 10,
                        value = 10,
                    },
                    {
                        name = "square wave volume",
                        type = "number",
                        selected = false,
                        min = 0,
                        max = 10,
                        value = 6,
                    },
                    {
                        name = "triangle wave volume",
                        type = "number",
                        selected = false,
                        min = 0,
                        max = 10,
                        value = 6,
                    },
                    {
                        name = "sine wave volume",
                        type = "number",
                        selected = false,
                        min = 0,
                        max = 10,
                        value = 6,
                    },
                    {
                        name = "sawtooth wave volume",
                        type = "number",
                        selected = false,
                        min = 0,
                        max = 10,
                        value = 6,
                    },
                    {
                        name = "noise volume volume",
                        type = "number",
                        selected = false,
                        min = 0,
                        max = 10,
                        value = 6,
                    },
                }
            }
        }
    }
    config = {}
    if stellarAPI.storage.isSaveExist("__system__") then
        print("save exist")
        config = stellarAPI.storage.getSaveData("__system__")
        __loadConfig()
    else
        print("creating save")
        __generateConfigValues()
        stellarAPI.storage.createSave("__system__", config)
    end
end

function setup:_render()
    local tabX = 15
    local itemY = 30
    stellarAPI.graphics.newRectangle(34, 0, 16, 400, 1)
    stellarAPI.graphics.newRectangle(34, 0, 284, 400, 1)
    stellarAPI.graphics.newRectangle(34, 10, 0, 1, 300)
    stellarAPI.graphics.newRectangle(34, 390, 0, 1, 300)
    for _, item in ipairs(configList.tabs) do
        if item.selected then
            stellarAPI.graphics.newRectangle(34, tabX - 1, 4, stellarAPI.graphics.getTextSize(item.name) + 2, 9)
            for _, tabitem in ipairs(item.content) do
                if tabitem.selected then
                    stellarAPI.graphics.newRectangle(34, 34, itemY - 1, stellarAPI.graphics.getTextSize(tabitem.name .. " : " .. tostring(tabitem.value)) + 2, 9)
                end
                stellarAPI.graphics.newText(tabitem.name .. " : " .. tostring(tabitem.value), 35, itemY, 34)
                itemY = itemY + 10
            end
        end
        maxY = itemY - 10
        stellarAPI.graphics.newText(item.name, tabX, 5, 34)
        tabX = (tabX + stellarAPI.graphics.getTextSize(item.name)) + 7
    end
    stellarAPI.graphics.newSprite("arrow", 13, sprY - 4)
end

function setup:_update(elapsed)
    if currentTab < 1 then
        currentTab = 1
    elseif currentTab > 2 then
        currentTab = 2
    end

    if currentItem < 1 then
        currentItem = 1
    elseif currentItem > #configList.tabs[currentTab].content then
        currentItem = #configList.tabs[currentTab].content
    end

    if sprY < 30 then
        sprY = 30
    elseif sprY > maxY then
        sprY = maxY
    end

    if configList.tabs[currentTab].content[currentItem].type == "number" then
        if configList.tabs[currentTab].content[currentItem].value < configList.tabs[currentTab].content[currentItem].min then
            configList.tabs[currentTab].content[currentItem].value = configList.tabs[currentTab].content[currentItem].min
        end

        if configList.tabs[currentTab].content[currentItem].value > configList.tabs[currentTab].content[currentItem].max then
            configList.tabs[currentTab].content[currentItem].value = configList.tabs[currentTab].content[currentItem].max
        end
    end

    if currentTab < 1 then
        currentTab = 1
    elseif currentTab > #configList.tabs then
        currentTab = #configList.tabs
    end
    for tab = 1, #configList.tabs, 1 do
        configList.tabs[tab].selected = false
        configList.tabs[currentTab].selected = true
        for item = 1, #configList.tabs[tab].content, 1 do
            configList.tabs[tab].content[item].selected = false
            configList.tabs[currentTab].content[currentItem].selected = true
        end
    end
end

function setup:_keydown(k)
    if k == "f1" then
        currentItem = 1
        sprY = 30
        currentTab = currentTab - 1
    end
    if k == "f2" then
        currentItem = 1
        sprY = 30
        currentTab = currentTab + 1
    end
    if k == "right" then
        if configList.tabs[currentTab].content[currentItem].type == "number" then
            configList.tabs[currentTab].content[currentItem].value = configList.tabs[currentTab].content[currentItem].value + 1
        end
    end
    if k == "left" then
        if configList.tabs[currentTab].content[currentItem].type == "number" then
            configList.tabs[currentTab].content[currentItem].value = configList.tabs[currentTab].content[currentItem].value - 1
        end
    end
    if k == "return" then
        if configList.tabs[currentTab].content[currentItem].type == "boolean" then
            if configList.tabs[currentTab].content[currentItem].value then
                configList.tabs[currentTab].content[currentItem].value = false
            else
                configList.tabs[currentTab].content[currentItem].value = true
            end
        end
    end
    if k == "up" then
        sprY = sprY - 10
        currentItem = currentItem - 1
    end
    if k == "down" then
        sprY = sprY + 10
        currentItem = currentItem + 1
    end
    if k == "escape" then
        config = {}
        __generateConfigValues()
        stellarAPI.storage.createSave("__system__", config)
        __updateShaders__()
        stellarAPI.graphics.setBackgroundColor(39)
        gamestate.switch(loader)
    end
end

function setup:_gamepadpressed(button)
    if button == "leftshoulder" then
        currentItem = 1
        sprY = 30
        currentTab = currentTab - 1
    end
    if button == "rightshoulder" then
        currentItem = 1
        sprY = 30
        currentTab = currentTab + 1
    end
    if button == "dpright" then
        if configList.tabs[currentTab].content[currentItem].type == "number" then
            configList.tabs[currentTab].content[currentItem].value = configList.tabs[currentTab].content[currentItem].value + 1
        end
    end
    if button == "dpleft" then
        if configList.tabs[currentTab].content[currentItem].type == "number" then
            configList.tabs[currentTab].content[currentItem].value = configList.tabs[currentTab].content[currentItem].value - 1
        end
    end
    if button == "a" then
        if configList.tabs[currentTab].content[currentItem].type == "boolean" then
            if configList.tabs[currentTab].content[currentItem].value then
                configList.tabs[currentTab].content[currentItem].value = false
            else
                configList.tabs[currentTab].content[currentItem].value = true
            end
        end
    end
    if button == "dpup" then
        sprY = sprY - 10
        currentItem = currentItem - 1
    end
    if button == "dpdown" then
        sprY = sprY + 10
        currentItem = currentItem + 1
    end
    if button == "b" then
        config = {}
        __generateConfigValues()
        stellarAPI.storage.createSave("__system__", config)
        __updateShaders__()
        stellarAPI.graphics.setBackgroundColor(39)
        gamestate.switch(loader)
    end
end

function setup:_virtualpadpressed(button)
    if button == "dp_left_up" then
        currentItem = 1
        sprY = 30
        currentTab = currentTab - 1
    end
    if button == "dp_right_up" then
        currentItem = 1
        sprY = 30
        currentTab = currentTab + 1
    end
    if button == "dp_right" then
        if configList.tabs[currentTab].content[currentItem].type == "number" then
            configList.tabs[currentTab].content[currentItem].value = configList.tabs[currentTab].content[currentItem].value + 1
        end
    end
    if button == "dp_left" then
        if configList.tabs[currentTab].content[currentItem].type == "number" then
            configList.tabs[currentTab].content[currentItem].value = configList.tabs[currentTab].content[currentItem].value - 1
        end
    end
    if button == "ac_a" then
        if configList.tabs[currentTab].content[currentItem].type == "boolean" then
            if configList.tabs[currentTab].content[currentItem].value then
                configList.tabs[currentTab].content[currentItem].value = false
            else
                configList.tabs[currentTab].content[currentItem].value = true
            end
        end
    end
    if button == "dp_up" then
        sprY = sprY - 10
        currentItem = currentItem - 1
    end
    if button == "dp_down" then
        sprY = sprY + 10
        currentItem = currentItem + 1
    end
    if button == "ac_b" then
        config = {}
        __generateConfigValues()
        stellarAPI.storage.createSave("__system__", config)
        __updateShaders__()
        stellarAPI.graphics.setBackgroundColor(39)
        gamestate.switch(loader)
    end
end

---------------------------------------------

function __generateConfigValues()
    --config = {}
    local data = {}
    for tabitem = 1, #configList.tabs, 1 do
        for item = 1, #configList.tabs[tabitem].content, 1 do
            local cfg = {}
            cfg.tabName = configList.tabs[tabitem].name
            cfg.itemName = configList.tabs[tabitem].content[item].name
            cfg.value = configList.tabs[tabitem].content[item].value
            table.insert(data, cfg)
        end
    end
    table.insert(config, data)
end

function __loadConfig()
    for d = 1, #config[1], 1 do
        for tabitem = 1, #configList.tabs, 1 do
            if configList.tabs[tabitem].name == config[1][d].tabName then
                for item = 1, #configList.tabs[tabitem].content, 1 do
                    if configList.tabs[tabitem].content[item].name == config[1][d].itemName then
                        configList.tabs[tabitem].content[item].value = config[1][d].value
                    end
                end
            end
        end
    end
    --print(debug.getTableContent(configList))
end

return setup