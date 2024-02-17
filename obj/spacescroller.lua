local Spacescroller = Object:extend()

function Spacescroller:new()
    self.bg_slice_1 = love.graphics.newImage("assets/bg_placeholder.png")
    self.bg_slice_2 = love.graphics.newImage("assets/bg_placeholder.png")

    self.x = 0
    self.y = 0
end

function Spacescroller:update(dt)
    self.y = self.y + (100 * dt)
    if self.y > 240 then
        self.y = 0
    end
end

function Spacescroller:draw()
    love.graphics.draw(self.bg_slice_1, self.x, self.y)
    love.graphics.draw(self.bg_slice_2, self.x, self.y - self.bg_slice_1:getHeight())
end

return Spacescroller