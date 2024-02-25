local Spaceship = Object:extend()

function Spaceship:new()
    self.sprite_bg = love.graphics.newImage("assets/bg_ship.png")
    self.sprite_mat_controls = love.graphics.newImage("assets/mat_controls.png")
    self.x = 0
    self.y = 0
end

function Spaceship:update(dt)
end

function Spaceship:draw()
    love.graphics.draw(self.sprite_bg, self.x, self.y)
end

return Spaceship