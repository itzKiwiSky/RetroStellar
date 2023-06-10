function love.load()
    --% third party libs --
    json = require 'libraries.json'
    --% api --
    stellarAPI = require 'src.modules.nx_stellar'

    --% initialization folders --
    love.filesystem.createDirectory("bin")

    --% initialization stuff to the package --

    if love.filesystem.isFused() then
        dataFile = love.filesystem.getInfo(love.filesystem.getSourceBaseDirectory() .. "/data.pkg")
    else
        dataFile = love.filesystem.getInfo("data.pkg")
    end

    if dataFile == nil then
        love.window.showMessageBox("[Stellar] Error", "Missing package file : 'data.pkg'", "error")
        love.event.quit()
    end

    if love.filesystem.isFused() then
        sucess = love.filesystem.mount(love.filesystem.getSourceBaseDirectory() .. "/data.pkg", "gamerom")
        print(love.filesystem.getSourceBaseDirectory() .. "/data.pkg")
        print(sucess)
    else
        sucess = love.filesystem.mount("data.pkg", "gamerom")
        print(sucess)
    end

    --% load the rom logic --
    data = love.filesystem.load("gamerom/main.lua")
    pcall(data(), _init())
end

function love.draw()
    pcall(data(), _render())
end

function love.update(elapsed)
    pcall(data(), _update())
end
