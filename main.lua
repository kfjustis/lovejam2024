--global requires
Object = require("lib.classic")
local push = require("lib.push")

local Spacescroller = require("obj.spacescroller")
local Spaceship = require("obj.spaceship")

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

local bg = Spacescroller()
local ship = Spaceship()

function love.load()
end

function love.update(dt)
    bg:update(dt)
end

function love.draw()
    push:start()


    --black border bars and render region
    push:setBorderColor(0, 0, 0, 1)
    love.graphics.clear(0,0,1,1)

    bg:draw()
    ship:draw()


    push:finish()
end

function love.resize(w, h)
    return push:resize(w, h)
end