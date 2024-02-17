local game = {}

local Spacescroller = require("obj.spacescroller")
local Spaceship = require("obj.spaceship")

local bg
local ship

function game:draw()
end

function game:init()
    bg = Spacescroller()
    ship = Spaceship()
end

function game:enter()
    print("INFO: Switched to scene: G_S_GAME.")
end

function game:update(dt)
    bg:update(dt)
end

function game:draw()
    Push:start()

    -- Black border bars and render region.
    Push:setBorderColor(0, 0, 0, 1)
    love.graphics.clear(0,0,0,1)

    bg:draw()
    ship:draw()

    Push:finish()
end

return game