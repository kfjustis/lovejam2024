local Player = Object:extend()
local input

function Player:new(x, y)
    self.x = x
    self.y = y
    self.speed = 200
    self.holdingHeal = false
    self.healBox = nil

    self.collider = G_WORLD:newCollider("Circle", {self.x, self.y, 10})
    self.collider:setFixedRotation(true)
    self.collider:setLinearDamping(0.8)

    --This allows the player to mash Heal() when next to a control box.
    self.collider:setSleepingAllowed(false)

    input = Baton.new {
        controls = {
            up = {"key:up", "key:w"},
            down = {"key:down", "key:s"},
            left = {"key:left", "key:a"},
            right = {"key:right", "key:d"},
            heal = {"key:lshift"}
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
    -- Apply the velocity based on the vector.
    local xSpeed = x * self.speed;
    local ySpeed = y * self.speed;
    self.collider:setLinearVelocity(xSpeed, ySpeed)
    --Round player position to pixel grid.
    self.collider:setX(math.floor(self.collider:getX()+0.5))
    self.collider:setY(math.floor(self.collider:getY()+0.5))

    self:updateBoxHealing()
end

function Player:draw()
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

function Player:updateBoxHealing()
    if input:down("heal") and (self.holdingHeal and self.healBox ~= nil) then
        self.healBox:heal()
    else
        self.holdingHeal = false
        self.healBox = nil
    end
end

return Player