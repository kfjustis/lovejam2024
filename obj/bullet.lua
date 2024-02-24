local Bullet = Object:extend()

function Bullet:new(spawn_x, spawn_y, look_x, look_y)
    self.x = spawn_x
    self.y = spawn_y
    self.look_dir_x = look_x
    self.look_dir_y = look_y
    self.speed = 400
end

function Bullet:update(dt)
    local look_x = -self.look_dir_x
    local look_y = self.look_dir_y
    if look_x == 0 then look_x = 0 end
    if look_y == 0 then look_y = 1 end
    self.x = self.x + (self.speed * dt * look_x)
    self.y = self.y + (self.speed * dt * look_y)
end

function Bullet:draw()
    love.graphics.push()

    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.circle("fill", self.x, self.y, 15)

    love.graphics.pop()
end

return Bullet