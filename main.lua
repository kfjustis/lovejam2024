local push = require("lib.push")

local gameWidth, gameHeight = 320, 240
local windowWidth, windowHeight = 640, 480

-- resizable and uses canvas
love.graphics.setDefaultFilter("nearest", "nearest", 1)

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
    fullscreen = false,
    resizable = true,
    canvas = true,
    highdpi = false
})

function love.load()
    bg_slice_1 = love.graphics.newImage("assets/bg_placeholder.png")
    bg_slice_2 = love.graphics.newImage("assets/bg_placeholder.png")
end

function love.update(dt)
end

function love.draw()
    push:start()
    --black border bars and render region
    push:setBorderColor(0, 0, 0, 1)
    love.graphics.clear(0,0,1,1)

    --draw start
    love.graphics.draw(bg_slice_1, 0, 0)
    --draw end
    push:finish()
end

function love.resize(w, h)
    return push:resize(w, h)
end