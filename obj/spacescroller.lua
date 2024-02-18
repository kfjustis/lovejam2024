local Spacescroller = Object:extend()

function Spacescroller:new()
    self.bg_slice_1 = love.graphics.newImage("assets/bg_placeholder.png")
    self.bg_slice_2 = love.graphics.newImage("assets/bg_placeholder.png")

    self.x = 0
    self.y = 0
    self.scroll_speed = 100
end

function Spacescroller:update(dt)
    self.y = self.y + (self.scroll_speed * dt)
    if self.y > G_GAMEHEIGHT then
        self.y = 0
    end
end

function Spacescroller:draw()
    love.graphics.draw(self.bg_slice_1, self.x, self.y)
    love.graphics.draw(self.bg_slice_2, self.x, self.y - self.bg_slice_1:getHeight())
end

return Spacescroller