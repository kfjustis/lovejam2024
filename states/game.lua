local game = {}

local Spacescroller = require("obj.spacescroller")
local Spaceship = require("obj.spaceship")

local bg
local ship
local ball

function game:draw()
end

function game:init()
    bg = Spacescroller()
    ship = Spaceship()
    ball = G_WORLD:newCollider("Rectangle", {100, 100, 10, 10})
    ball:setLinearDamping(10)
end

function game:enter()
    print("INFO: Switched to scene: G_S_GAME.")
end

function game:update(dt)
    bg:update(dt)

    local speed = 200
    if love.keyboard.isDown("up") then
        ball:setLinearVelocity(0, -speed)
    end
    if love.keyboard.isDown("down") then
        ball:setLinearVelocity(0, speed)
    end
    if love.keyboard.isDown("left") then
        ball:setLinearVelocity(-speed, 0)
    end
    if love.keyboard.isDown("right") then
        ball:setLinearVelocity(speed, 0)
    end

    --Round position to full pixel.
    ball:setX(math.floor(ball:getX()+0.5))
    ball:setY(math.floor(ball:getY()+0.5))
end

function game:draw()
    Push:start()

    -- Black border bars and render region.
    Push:setBorderColor(0, 0, 0, 1)
    love.graphics.clear(0,0,0,1)

    bg:draw()
    ship:draw()

    G_WORLD:draw()

    Push:finish()
end

function game:leave()
    bg = nil
    ship = nil
    ball = nil
end

return game