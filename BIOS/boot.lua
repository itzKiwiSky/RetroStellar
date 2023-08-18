function _init()
    _curVersion = Version(_version)
    _needUpdate = false
    if Version("0.0.2") > _curVersion then
        _needUpdate = true
    else
        _needUpdate = false
    end

    --% states --
    splash = require 'BIOS.states.Bootsplash'
    loader = require 'BIOS.states.Bootloader'
    setup = require 'BIOS.states.Setup'
    credits = require 'BIOS.states.Credits'
    savemngr = require 'BIOS.states.Savemngr'
    updatewarn = require 'BIOS.states.Updatewarn'
    debugscreen = require 'BIOS.states.Debugstate'
    gamelib = require 'BIOS.states.Gamelib'

    astroAPI.graphics.loadSpriteBankFromPath("BIOS/SPRCHR")

    gamestate.registerEvents()
    if _needUpdate then
        gamestate.switch(updatewarn)
    else
        gamestate.switch(gamelib)
    end
end

function _render()
    gamestate.current():_render()
end

function _update(elapsed)
    gamestate.current():_update(elapsed)
end

function _keydown(k)
    gamestate.current():_keydown(k)
end

function _gamepadpressed(button)
    gamestate.current():_gamepadpressed(button)
end

function _virtualpadpressed(button)
    gamestate.current():_virtualpadpressed(button)
end