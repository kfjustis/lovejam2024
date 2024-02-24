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

    self:spawnLevelBoundaries()

    -- Enemy data.
    self.enemySpawnTime = 5;
    self.enemySpawnTimer = self.enemySpawnTime;
    self.enemies = {}

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
    paused = false
    print("INFO: Switched to scene: G_S_GAME.")
end

function game:update(dt)
    if paused == false then
        -- Update timers.
        self.enemySpawnTimer = self.enemySpawnTimer - (2.0 * dt)
        if self.enemySpawnTimer <= 0 then
            self:spawnEnemy()
            self.enemySpawnTimer = self.enemySpawnTime
        end
        bg:update(dt)
        box_north:update(dt)
        box_east:update(dt)
        box_west:update(dt)
        player:update(dt)
        for i,v in ipairs(self.enemies) do
            v:update(dt)
        end
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
        player:draw()
        for i,v in ipairs(self.enemies) do
            v:draw()
        end
        --G_WORLD:draw()
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

function game:spawnLevelBoundaries()
    local barriers = {}

    local tlBarrier = G_WORLD:newCollider(
        "Polygon",
        {0,0 , 82,35 , 33,94, 0,0}
    )
    local trBarrier = G_WORLD:newCollider(
        "Polygon",
        {G_GAMEWIDTH,0 , G_GAMEWIDTH-82,35,
         G_GAMEWIDTH-33,94, G_GAMEWIDTH,0}
    )
    local topBarrier = G_WORLD:newCollider(
        "Rectangle",
        {160,24, 175, 24}
    )
    local leftBarrier = G_WORLD:newCollider(
        "Rectangle",
        {32, 192, 5, 130}
    )
    local rightBarrier = G_WORLD:newCollider(
        "Rectangle",
        {G_GAMEWIDTH-32, 170, 5, 150}
    )
    local botBarrier = G_WORLD:newCollider(
        "Rectangle",
        {G_GAMEWIDTH/2.0, G_GAMEHEIGHT+1, 260, 2}
    )

    table.insert(barriers, tlBarrier)
    table.insert(barriers, trBarrier)
    table.insert(barriers, topBarrier)
    table.insert(barriers, leftBarrier)
    table.insert(barriers, rightBarrier)
    table.insert(barriers, botBarrier)

    for i,v in ipairs(barriers) do
        v:setType("static")
        v:setFixedRotation(true)
    end
end

function game:spawnEnemy()
    local enemy = Enemy()
    table.insert(self.enemies, enemy)
end

return game