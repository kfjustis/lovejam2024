local game = {}

local Spacescroller = require("obj.spacescroller")
local Spaceship = require("obj.spaceship")
local ControlBox = require("obj.interactable")

local bg
local ship
local ball
local box_north
local box_east
local box_west

function game:draw()
end

function game:init()
    bg = Spacescroller()
    ship = Spaceship()

    -- Boxes.
    box_north = ControlBox(192, 36, 32, 32)
    box_north:setColor(0, 0.8, 1, 1)
    box_east = ControlBox(251, 176, 32, 32)
    box_east:setColor(0.8, 0, 1, 1)
    box_west = ControlBox(36, 96, 32, 32)
    box_west:setColor(1, 0.6, 0, 1)

    -- Player analog.
    ball = G_WORLD:newCollider("Rectangle", {100, 100, 10, 10})
    ball:setFixedRotation(true)
    ball:setLinearDamping(10)
    -- ball solver test
    function ball:postSolve(other)
        print("solved")
        if other == box_west.collider then
            print("\tinteraaaaaaaaaaaaa")
        end
    end
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

    -- Draw boxes.
    box_north:draw()
    box_east:draw()
    box_west:draw()

    -- Draw debug colliders.
    G_WORLD:draw()


    Push:finish()
end

return game