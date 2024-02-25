local Bullet = Object:extend()

function Bullet:new(owner, owner_type, spawn_x, spawn_y, look_x, look_y)
    self.owner = owner
    self.x = spawn_x
    self.y = spawn_y
    self.look_dir_x = look_x
    self.look_dir_y = look_y
    self.speed = 800
    self.valid =  self.owner:is(owner_type)
end

function Bullet:update(dt)
    local look_x = -self.look_dir_x
    local look_y = self.look_dir_y

    -- Shoot the bullet in the direction the player is facing.
    if look_x == 0 and look_y == 0 then  -- no presses, shoot down
        self.x = self.x + (self.speed * dt * look_x)
        self.y = self.y + (self.speed * dt * 1)
    elseif look_x == 0 and look_y ~= 0 then -- no x component, shoot in y
        self.y = self.y + (self.speed * dt * look_y)
    elseif look_x ~= 0 and look_y == 0 then -- no y component, shoot in x
        self.x = self.x + (self.speed * dt * look_x)
    elseif look_x ~= 0 and look_y ~= 0 then -- use both components
        self.x = self.x + (self.speed * dt * look_x)
        self.y = self.y + (self.speed * dt * look_y)
    end

    if self.valid == false then
        return
    end

    -- Remove enemies that get hit.
    for i,v in ipairs(self.owner.knownEnemies) do
        local dist_x = math.abs(self.x - v.x)
        local dist_y = math.abs(self.y - v.y)
        if dist_x < 15 + 4 and dist_y < 15 + 4 then
            table.remove(self.owner.knownEnemies, i)
        end
    end
end

function Bullet:draw()
    love.graphics.push()

    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.circle("fill", self.x, self.y, 15)

    love.graphics.pop()
end

function Bullet:hide()
    -- Send way off the screen to get culled.
    self.x = -1000
    self.y = -1000
end

return Bullet