local Player = Object:extend()
local Bullet = require("obj.bullet")
local input

function Player:new(x, y)
    self.x = x
    self.y = y
    self.ox = 10
    self.oy = 10
    self.look_dir_x = 0
    self.look_dir_y = 0
    self.rotation = 0
    self.speed = 200
    self.holdingHeal = false
    self.healBox = nil

    self.sprite = love.graphics.newImage("assets/player.png")
    self.collider = G_WORLD:newCollider("Circle", {self.x, self.y, 10})
    self.collider:setFixedRotation(true)
    self.collider:setLinearDamping(0.8)

    --This allows the player to mash Heal() when next to a control box.
    self.collider:setSleepingAllowed(false)

    -- Give player access to the enemies in the level and bullets.
    self.bullets = {}
    self.knownEnemies = {}

    input = Baton.new {
        controls = {
            up = {"key:up", "key:w"},
            down = {"key:down", "key:s"},
            left = {"key:left", "key:a"},
            right = {"key:right", "key:d"},
            heal = {"key:space"},
            attack = {"key:rshift"}
        },
        pairs = {
            move = {"left", "right", "up", "down"}
        },
        joystick = nil
    }
end

function Player:update(dt)
    -- Get input.
    input:update()

    -- Get player vector based on key presses.
    local x, y = input:get("move")

    -- Set sprite scale based on the vector.
    if x ~= self.look_dir_x then
        self.look_dir_x = x
    end
    if y ~= self.look_dir_y then
        self.look_dir_y = y
    end
    self.rotation = math.atan2(-self.look_dir_x, self.look_dir_y)

    -- Apply the velocity based on the vector.
    local xSpeed = x * self.speed;
    local ySpeed = y * self.speed;
    self.collider:setLinearVelocity(xSpeed, ySpeed)
    --Round player position to pixel grid.
    self.collider:setX(math.floor(self.collider:getX()+0.5))
    self.collider:setY(math.floor(self.collider:getY()+0.5))

    -- Handle when player is healing a control box or attacking.
    self:updateBoxHealing()
    self:updateAttacks()

    -- Update bullets.
    for i,v in ipairs(self.bullets) do
        v:update(dt)
        -- Cull to game region.
        if v.x < 0 - 30 or v.x > G_GAMEWIDTH + 30 then
            table.remove(self.bullets, i)
        elseif v.y < 0 - 30 or v.y > G_GAMEHEIGHT + 30 then
            table.remove(self.bullets, i)
        end
    end
end

function Player:draw()
    love.graphics.push()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle("fill", self.collider:getX()+1, self.collider:getY()+1, 10)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite, self.collider:getX(), self.collider:getY(), self.rotation, 1, 1, self.ox, self.oy)

    for i,v in ipairs(self.bullets) do
        v:draw()
    end
    love.graphics.pop()
end

Signal.register("player_hit_control_box", function(player_ref, box_ref)
    if (player_ref == nil) or (box_ref == nil) then
        return
    end
    input:update()
    if input:pressed("heal") then
        player_ref.holdingHeal = true
        player_ref.healBox = box_ref
    end
end)

function Player:updateAttacks()
    if input:down("attack") then
        local bullet =
            Bullet(self, Player,
                self.collider:getX(), self.collider:getY(),
                -self.look_dir_x, self.look_dir_y)
        table.insert(self.bullets, bullet)
    end
end

function Player:updateBoxHealing()
    if input:down("heal") and (self.holdingHeal and self.healBox ~= nil) then
        self.healBox:heal()
    else
        self.holdingHeal = false
        self.healBox = nil
    end
end

function Player:setKnownEnemies(enemies)
    self.knownEnemies = enemies
end

return Player