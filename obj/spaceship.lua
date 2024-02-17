local Spaceship = Object:extend()

function Spaceship:new()
    self.sprite = love.graphics.newImage("assets/bg_ship.png")
    self.x = 0
    self.y = 0
end

function Spaceship:update(dt)
end

function Spaceship:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end

return Spaceship