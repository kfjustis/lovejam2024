local game = {}

local ControlBox = require("obj.interactable")
local Enemy = require("obj.enemy")
local Player = require("obj.player")
local Spacescroller = require("obj.spacescroller")
local Spaceship = require("obj.spaceship")

local bg
local enemy
local player
local ship
local box_north
local box_east
local box_west
local paused

function game:draw()
end

function game:init()
    bg = Spacescroller()
    ship = Spaceship()
    enemy = Enemy()

    -- Boxes.
    box_north = ControlBox(192, 36, 32, 32)
    box_north:setColor(0, 0.8, 1, 1)
    box_east = ControlBox(251, 176, 32, 32)
    box_east:setColor(0.8, 0, 1, 1)
    box_west = ControlBox(36, 96, 32, 32)
    box_west:setColor(1, 0.6, 0, 1)

    -- Set up player.
    player = Player(100, 100)

    function player.collider:postSolve(other)
        --print("solved")
        if other == box_north.collider then
            Signal.emit("player_hit_control_box", player, box_north)
        elseif other == box_east.collider then
            Signal.emit("player_hit_control_box", player, box_east)
        elseif other == box_west.collider then
            Signal.emit("player_hit_control_box", player, box_west)
        end
    end
end

function game:enter()
    paused = true
    print("INFO: Switched to scene: G_S_GAME.")
end

function game:update(dt)
    if paused == false then
        bg:update(dt)
        box_north:update(dt)
        box_east:update(dt)
        box_west:update(dt)
        player:update(dt)
        enemy:update(dt)
    else
        if love.keyboard.isDown("space") then
            paused = false
        end
    end
end

function game:draw()
    Push:start()


    -- Black border bars and render region.
    Push:setBorderColor(0, 0, 0, 1)
    love.graphics.clear(0,0,0,1)

    if paused == false then
        bg:draw()
        ship:draw()
        box_north:draw()
        box_east:draw()
        box_west:draw()
        enemy:draw()
        player:draw()
        G_WORLD:draw()
    else
        love.graphics.setColor(1, 1, 1, 1)

        local msg = "The goal is to survive."
        msg = msg.."\n\nRecharge the generator interfaces while"
        msg = msg.."\nfighting off the space horde."
        msg = msg.."\n\n\n\n\nMove:..........................WASD or ARROWS"
        msg = msg.."\nRecharge Generator:...Move into it + SPACE"
        msg = msg.."\nShoot:.........................LEFT MOUSE"
        msg = msg.."\n\nPress SPACE to  start."
        love.graphics.print(msg, 25, 25)
    end


    Push:finish()
end

return game