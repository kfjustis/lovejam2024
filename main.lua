local push = require("lib.push")

local gameWidth, gameHeight = 320, 240
local windowWidth, windowHeight = 640, 480

-- resizable and uses canvas
push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = true,
    canvas = true,
    highdpi = false
})

function love.load()
end

function love.update(dt)
end

function love.draw()
    push:start()
    --black border bars
    push:setBorderColor(0, 0, 0, 1)
    --black background
    love.graphics.clear(0,0,1,1)

    --draw here
    push:finish()
end

function love.resize(w, h)
    return push:resize(w, h)
  end