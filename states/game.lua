local game = {}

local ControlBox = require("obj.interactable")
local Enemy = require("obj.enemy")
local Player = require("obj.player")
local Spacescroller = require("obj.spacescroller")
local Spaceship = require("obj.spaceship")

local bg
local player
local ship
local box_north
local box_east
local box_west
local paused

local DEFAULT_SPAWN_TIME = 5
local DEFAULT_WARP_TIME = 200

function game:init()
    bg = Spacescroller()
    ship = Spaceship()

    self:spawnLevelBoundaries()

    -- Enemy data.
    self.enemySpawnTime = 0.5;
    self.enemySpawnTimer = self.enemySpawnTime;
    self.enemies = {}

    -- Warp data.
    self.warpTimer = DEFAULT_WARP_TIME;

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
    paused = true
    print("INFO: Switched to scene: G_S_GAME.")

    -- Set control box starting hp values.
    box_north:setHp(100)
    box_east:setHp(100)
    box_west:setHp(100)

    -- Set the player position.
    player:setPosition((G_GAMEWIDTH / 2), (G_GAMEHEIGHT / 2) - 5)
end

function game:leave()
    -- Clean up the enemy spawn timer.
    self.warpTimer = DEFAULT_WARP_TIME
    self.enemySpawnTimer = DEFAULT_SPAWN_TIME

    -- Clean up enemies.
    --for i,v in ipairs(self.enemies) do
    --    table.remove(self.enemies, i)
    --end
    self.enemies = {}
    collectgarbage()
end

function game:update(dt)
    if paused == false then
        if self.warpTimer <= 0 then
            Gamestate.switch(G_S_WIN)
        elseif areBoxesDead() then
            Gamestate.switch(G_S_LOSE)
        end

        self:updateTimers(dt)

        bg:update(dt)
        box_north:update(dt)
        box_east:update(dt)
        box_west:update(dt)

        player:setKnownEnemies(self.enemies)
        player:update(dt)

        self:updateEnemyCollisions(dt)
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
        self:drawEnemies()
        self:drawWarpUi()
        --G_WORLD:draw()
    else
        love.graphics.setColor(1, 1, 1, 1)

        local msg = "The goal is to survive."
        msg = msg.."\n\nRecharge the generator interfaces while"
        msg = msg.."\nfighting off the space horde."
        msg = msg.."\n\n\n\n\nMove:...........................WASD"
        msg = msg.."\nRecharge Generators:...Move into it + SPACE"
        msg = msg.."\nShoot:..........................LEFT MOUSE"
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

function game:updateEnemyCollisions(dt)
    local northEnemies = {}
    local northEnemiesCount = 0
    local eastEnemies = {}
    local eastEnemiesCount = 0
    local westEnemies = {}
    local westEnemiesCount = 0

    for i,v in ipairs(self.enemies) do
        -- Update the enemy.
        v:update(dt)

        -- Check for control box collision.
        local hits = G_WORLD:queryRectangleArea(v.x - 8, v.y - 8, v.x + 8, v.y + 8)

        -- Set attachment data.
        for j,w in ipairs(hits) do
            if w == box_north.collider then
                v:setAttached()
                if v:isAttached() then
                    table.insert(northEnemies, w)
                    northEnemiesCount = northEnemiesCount + 1
                end
            end
            if w == box_east.collider then
                v:setAttached()
                if v:isAttached() then
                    table.insert(eastEnemies, w)
                    eastEnemiesCount = eastEnemiesCount + 1
                end
            end
            if w == box_west.collider then
                v:setAttached()
                if v:isAttached() then
                    table.insert(westEnemies, w)
                    westEnemiesCount = westEnemiesCount + 1
                end
            end
        end
    end
    box_north:setEnemyPenalty(northEnemiesCount)
    box_east:setEnemyPenalty(eastEnemiesCount)
    box_west:setEnemyPenalty(westEnemiesCount)
end

function game:updateTimers(dt)
    self.warpTimer = self.warpTimer - (2.0 * dt)

    self.enemySpawnTimer = self.enemySpawnTimer - (2.0 * dt)
    if self.enemySpawnTimer <= 0 then
        self:spawnEnemy()
        self.enemySpawnTimer = self.enemySpawnTime
    end
end

function game:drawEnemies()
    for i,v in ipairs(self.enemies) do
        v:draw()

        -- Draw enemy query bounds.
        --[[
        if v.attached == false then
            love.graphics.push()
            love.graphics.setColor(1, 0, 0, 1)
            love.graphics.rectangle("line", v.x - 8, v.y - 8, 16, 16)
            love.graphics.pop()
        else
            love.graphics.push()
            love.graphics.setColor(0, 1, 0, 1)
            love.graphics.rectangle("line", v.x - 8, v.y - 8, 16, 16)
            love.graphics.pop()
        end
        ]]--
    end
end

function game:drawWarpUi()
    local boxHeight = 30
    local boxTl_x = 0
    local boxTl_y = G_GAMEHEIGHT - boxHeight
    local txtOffset_x = 6
    local txtOffset_y = 8

    love.graphics.push()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, boxTl_y, G_GAMEWIDTH, boxHeight)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("WARP CHG:", boxTl_x + txtOffset_x, boxTl_y + txtOffset_y)

    -- Bar bg color.
    local bar_o_x = txtOffset_x + 75
    local bar_o_y = boxTl_y + txtOffset_y + 3
    local barPercent = (DEFAULT_WARP_TIME - self.warpTimer) / DEFAULT_WARP_TIME

    love.graphics.setColor(49.0/255.0, 92.0/255.0, 132.0/255.0, 1)
    love.graphics.rectangle("fill", bar_o_x, bar_o_y, G_GAMEWIDTH - bar_o_x, 10)

    love.graphics.setColor(81.0/255.0, 171.0/255.0, 255.0/255.0, 1)
    love.graphics.rectangle("fill", bar_o_x, bar_o_y, (G_GAMEWIDTH - bar_o_x) * barPercent, 10)
    love.graphics.pop()
end

function areBoxesDead()
    if (box_north:getHpPercent() <= 0 and
        box_east:getHpPercent() <= 0 and
        box_west:getHpPercent() <= 0) then
        return true
    end
    return false
end

return game