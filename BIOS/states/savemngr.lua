local savemnrg = {}

function savemnrg:enter()
    astroAPI.graphics.setBackgroundColor(7)
    partitions = storagedvr.getPartitions()
    --print(debug.getTableContent(partitions))

    display = partitions

    for d = 1, #display, 1 do
        display[d].selected = false
        display[d].itemClicked = false
    end

    pageCount = 1
    maxPage = 13
    pageNum = #display
    item = 1
    itemSelected = false
    eraseConfirmation = false
    erasingScreen = false
    erasingValue = 0
    erasingTimer = 0
    erasingItem = 1
    erasingWarning = {
        "Formating slots",
        "Please wait..."
    }
    timer = 0
    Color = false


    options = {
        "[f1] - delete",
        "[f2] - clone",
    }

    SW, SH = astroAPI.graphics.getScreenDimentions()
end

function savemnrg:_render()
    if not erasingScreen then
        astroAPI.graphics.newRectangle(34, 0, 0, SW, 10)
        astroAPI.graphics.newRectangle(34, 0, SH - 10, SW, 10)
        astroAPI.graphics.newRectangle(39, SW - 90, 40, 90, 190)
        astroAPI.graphics.newRectangle(35, SW - 95, 35, 90, 190)
        local nameY = 20
        local opY = 80
        if #display > 0 then
            for renderList = pageCount, maxPage, 1 do
                --print(renderList, pageNum, maxPage)
                if display[renderList].selected then
                    astroAPI.graphics.newRectangle(34, 22, nameY - 1, astroAPI.graphics.getTextSize(display[renderList].name) + 2, 9)
                    astroAPI.graphics.newRectangle(34, 4, nameY - 6, 18, 18)
                end
                if display[renderList].itemClicked then
                    if Color then
                        astroAPI.graphics.newRectangle(1, 22, nameY - 1, astroAPI.graphics.getTextSize(display[renderList].name) + 2, 9)
                        astroAPI.graphics.newRectangle(1, 4, nameY - 6, 18, 18)
                    else
                        astroAPI.graphics.newRectangle(34, 22, nameY - 1, astroAPI.graphics.getTextSize(display[renderList].name) + 2, 9)
                        astroAPI.graphics.newRectangle(34, 4, nameY - 6, 18, 18)
                    end
                end
               
                astroAPI.graphics.newText(display[renderList].name, 23, nameY, 34)
                if display[renderList].name == "__system__" then
                    astroAPI.graphics.newSprite("warning", 5, nameY - 5)
                else
                    astroAPI.graphics.newSprite("disk_icon", 5, nameY - 5)
                end 
                nameY = nameY + 19
            end
            maxY = nameY - 19
        
        
            if display[item].name == "__system__" then
                astroAPI.graphics.newText("reserved for", SW - 93, 75, 34)
                astroAPI.graphics.newText("system", SW - 93, 82, 34)
            end
        
            if itemSelected then
                for o = 1, #options, 1 do
                    astroAPI.graphics.newText(options[o], SW - 93, opY, 34)
                    opY = opY + 9
                end
            end
    
            astroAPI.graphics.newText(display[item].name, SW - 93, 45, 34)
            astroAPI.graphics.newText("size :" .. display[item]._size, SW - 93, 60, 34)
        else
            astroAPI.graphics.newText("No saves here", SW - 93, 82, 34)
        end
        if eraseConfirmation then
            astroAPI.graphics.newRectangle(39, 130, 110, 150, 100)
            astroAPI.graphics.newRectangle(35, 120, 100, 150, 100)
            astroAPI.graphics.newText("Are you sure you want", 130, 105, 34)
            astroAPI.graphics.newText("erase all save data", 136, 115, 34)
            astroAPI.graphics.newText("[f1] - yes / [f2] - no ", 125, 180, 34)
        end
        astroAPI.graphics.newText("[f3] - format save disk", 20, SH - 9, 34)
    else
        astroAPI.graphics.newText("Erasing data...", 0, 0, 34)

        local txtY = 120
        for t = 1, #erasingWarning, 1 do
            astroAPI.graphics.newText(erasingWarning[t], 160, txtY, 34)
            txtY = txtY + 9
        end

        --% progress --
        astroAPI.graphics.newRectangle(37, 10, SH - 10, SW - 20, 10)
        astroAPI.graphics.newRectangle(10, 10, SH - 10, math.floor((SW - 20) * (erasingValue / 100)), 10)
        astroAPI.graphics.newText("Progress [" .. tostring(math.floor(erasingValue)) .. "]", 30, 280, 34)
    end
end

function savemnrg:_update(elapsed)
    if not erasingScreen then
        if #partitions < 14 then
            maxPage = #partitions
        end
        
        if maxPage < 14 and #partitions > 14 then
            maxPage = 14
        elseif maxPage > #partitions then
            maxPage = #partitions
        end

        timer = timer + 1
        if math.floor(timer) > 10 then
            timer = 0
            if Color then
                Color = false
            else
                Color = true
            end
        end
    
        if item < 1 then
            item = 1
        elseif item > #partitions then
            item = #partitions
        end

        if pageNum > 13 then
            pageNum = 13
        end

        if pageCount < 1 then
            pageCount = 1
        end
        if pageCount > #partitions then
            pageCount = #partitions
        end

        if #display > 0 then
            for d = 1, #display, 1 do
                display[d].selected = false
                display[item].selected = true
            end
        end
    else
        erasingTimer = erasingTimer + 1
        if erasingTimer > 1 then
            erasingTimer = 0
            if #partitions < 10 then
                erasingValue = erasingValue + 1
            else
                erasingValue = erasingValue + #partitions / 100
            end
        end
        if erasingValue >= 100 then
            storagedvr.removeAll()
            display = {}
            erasingScreen = false
        end
    end
end

function savemnrg:_keydown(k)
    if not erasingScreen then
        if k == "return" then
            if #partitions > 0 then
                if partitions[item].name ~= "__system__" then
                    itemSelected = true
                    if #display > 0 then
                        for d = 1, #display, 1 do
                            display[d].itemClicked = false
                        end
                    
                        display[item].itemClicked = true
                    end
                end
            end
        end
    
        if not itemSelected then
            if k == "escape" then
                astroAPI.graphics.setBackgroundColor(39)
                gamestate.switch(loader)
            end
            if k == "up" then
                item = item - 1
                if item < maxPage - pageNum then
                    pageCount = pageCount - 1
                    maxPage = maxPage - 1
                end
            end
            if k == "down" then
                if pageCount + 13 < #partitions  then
                    item = item + 1
                    if item > maxPage then
                        pageCount = pageCount + 1
                        maxPage = maxPage + 1
                    end
                else
                    item = item + 1
                end
            end
            if k == "f3" then
                eraseConfirmation = true
            end
            if eraseConfirmation then
                if k == "f1" then
                    eraseConfirmation = false
                    erasingItem = 1
                    erasingTimer = 0
                    erasingValue = 0
                    erasingScreen = true
                end
                if k == "f2" then
                    eraseConfirmation = false
                end
            end
        else
            if k == "escape" then
                itemSelected = false
                if #display > 0 then
                    for d = 1, #display, 1 do
                        display[d].itemClicked = false
                    end
                end
            end
            if k == "f1" then
                storagedvr.removeSave(partitions[item].name)
                itemSelected = false
                if #display > 0 then
                    for d = 1, #display, 1 do
                        display[d].itemClicked = false
                    end
                end
            end
            if k == "f2" then
                storagedvr.cloneSave(partitions[item].name)
                itemSelected = false
                if #display > 0 then
                    for d = 1, #display, 1 do
                        display[d].itemClicked = false
                    end
                end
            end
        end
    end
end

function savemnrg:_gamepadpressed(button)
    if not erasingScreen then
        if button == "a" then
            if #partitions > 0 then
                if partitions[item].name ~= "__system__" then
                    itemSelected = true
                    if #display > 0 then
                        for d = 1, #display, 1 do
                            display[d].itemClicked = false
                        end
                        display[item].itemClicked = true
                    end
                end
            end
        end
    
        if not itemSelected then
            if button == "b" then
                astroAPI.graphics.setBackgroundColor(39)
                gamestate.switch(loader)
            end
            if button == "dpup" then
                item = item - 1
                if item < maxPage - pageNum then
                    pageCount = pageCount - 1
                    maxPage = maxPage - 1
                end
            end
            if button == "dpdown" then
                if pageCount + 13 < #partitions  then
                    item = item + 1
                    if item > maxPage then
                        pageCount = pageCount + 1
                        maxPage = maxPage + 1
                    end
                else
                    item = item + 1
                end
            end
            if button == "y" then
                eraseConfirmation = true
            end
            if eraseConfirmation then
                if button == "a" then
                    eraseConfirmation = false
                    erasingItem = 1
                    erasingTimer = 0
                    erasingValue = 0
                    erasingScreen = true
                end
                if button == "b" then
                    eraseConfirmation = false
                end
            end
        else
            if button == "b" then
                itemSelected = false
                if #display > 0 then
                    for d = 1, #display, 1 do
                        display[d].itemClicked = false
                    end
                end
            end
            if button == "a" then
                storagedvr.removeSave(partitions[item].name)
                itemSelected = false
                if #display > 0 then
                    for d = 1, #display, 1 do
                        display[d].itemClicked = false
                    end
                end
            end
            if button == "x" then
                storagedvr.cloneSave(partitions[item].name)
                itemSelected = false
                if #display > 0 then
                    for d = 1, #display, 1 do
                        display[d].itemClicked = false
                    end
                end
            end
        end
    end
end

function savemnrg:_virtualpadpressed(button)
    if not erasingScreen then
        if button == "ac_a" then
            if #partitions > 0 then
                if partitions[item].name ~= "__system__" then
                    itemSelected = true
                    if #display > 0 then
                        for d = 1, #display, 1 do
                            display[d].itemClicked = false
                        end
                    
                        display[item].itemClicked = true
                    end
                end
            end
        end
    
        if not itemSelected then
            if button == "ac_b" then
                astroAPI.graphics.setBackgroundColor(39)
                gamestate.switch(loader)
            end
            if button == "dp_up" then
                item = item - 1
                if item < maxPage - pageNum then
                    pageCount = pageCount - 1
                    maxPage = maxPage - 1
                end
            end
            if button == "dp_down" then
                if pageCount + 13 < #partitions  then
                    item = item + 1
                    if item > maxPage then
                        pageCount = pageCount + 1
                        maxPage = maxPage + 1
                    end
                else
                    item = item + 1
                end
            end
            if button == "ac_y" then
                eraseConfirmation = true
            end
            if eraseConfirmation then
                if button == "ac_a" then
                    eraseConfirmation = false
                    erasingItem = 1
                    erasingTimer = 0
                    erasingValue = 0
                    erasingScreen = true
                end
                if button == "ac_b" then
                    eraseConfirmation = false
                end
            end
        else
            if button == "ac_b" then
                itemSelected = false
                if #display > 0 then
                    for d = 1, #display, 1 do
                        display[d].itemClicked = false
                    end
                end
            end
            if button == "ac_a" then
                storagedvr.removeSave(partitions[item].name)
                itemSelected = false
                if #display > 0 then
                    for d = 1, #display, 1 do
                        display[d].itemClicked = false
                    end
                end
            end
            if button == "ac_x" then
                storagedvr.cloneSave(partitions[item].name)
                itemSelected = false
                if #display > 0 then
                    for d = 1, #display, 1 do
                        display[d].itemClicked = false
                    end
                end
            end
        end
    end
end

return savemnrg