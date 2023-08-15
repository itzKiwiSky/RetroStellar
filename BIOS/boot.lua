function _init()
    _curVersion = Version(_version)
    _needUpdate = false
    if Version("0.0.2") > _curVersion then
        _needUpdate = true
    else
        _needUpdate = false
    end

    --% states --
    splash = require 'BIOS.states.bootsplash'
    loader = require 'BIOS.states.bootloader'
    setup = require 'BIOS.states.setup'
    credits = require 'BIOS.states.credits'
    savemngr = require 'BIOS.states.savemngr'
    updatewarn = require 'BIOS.states.updatewarn'
    debugscreen = require 'BIOS.states.debugstate'
    gamelib = require 'BIOS.states.gamelib'

    astroAPI.graphics.loadSpriteBankFromPath("BIOS/SPRCHR")

    gamestate.registerEvents()
    if _needUpdate then
        gamestate.switch(updatewarn)
    else
        gamestate.switch(splash)
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