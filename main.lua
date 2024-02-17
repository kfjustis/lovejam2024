-- Global requires.
Gamestate = require("lib.gamestate")
Object = require("lib.classic")
Push = require("lib.Push")

-- Global settings.
G_GAMEWIDTH, G_GAMEHEIGHT = 320, 240
G_WINDOWWIDTH, G_WINDOWHEIGHT = 640, 480

-- Global states.
G_S_FOCUS = require("states.focus")
G_S_GAME = require("states.game")

function love.load()
    -- Apply window and graphics settings first.
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    Push:setupScreen(G_GAMEWIDTH, G_GAMEHEIGHT, G_WINDOWWIDTH, G_WINDOWHEIGHT, {
        fullscreen = false,
        resizable = true,
        canvas = true,
        highdpi = false
    })

    -- Set the initial scene.
    Gamestate.registerEvents()
    Gamestate.switch(G_S_FOCUS)
end

function love.resize(w, h)
    return Push:resize(w, h)
end

function love.quit()
    print("INFO: Exit success.")
end