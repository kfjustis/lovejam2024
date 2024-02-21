local Enemy = Object:extend()
local Selector = require("lib.beehive.selector")

function Enemy:new()
    self.x = 150
    self.y = 150
    self.sprite = love.graphics.newImage("assets/enemy_magenta.png")
    self.grid = Anim8.newGrid(8, 8, self.sprite:getWidth(), self.sprite:getHeight())
    self.animation = Anim8.newAnimation(self.grid("1-2", 1), 0.1)
    self.brain = self:makeBrain()
    self.rotation = 0
    self.ox = 4
    self.oy = 4
    self.scale = 2
end

function Enemy:update(dt)
    self.brain(self.brain, dt)
    self.animation:update(dt)
end

function Enemy:draw()
    love.graphics.push()
    love.graphics.setColor(0, 0, 0, 1)
    self.animation:draw(self.sprite, self.x + 1, self.y + 1, self.rotation, self.scale, self.scale, self.ox, self.oy)
    love.graphics.setColor(1, 1, 1, 1)
    self.animation:draw(self.sprite, self.x, self.y, self.rotation, self.scale, self.scale, self.ox, self.oy)
    love.graphics.pop()
end

function Enemy:makeBrain()
    -- Keeping waitRandom example for now.
    --return (Selector{self:waitRandom(1, 3)})
    return (Selector{self:rotateInPlace()})
end

-- Wait a bit of time before succeeding.
function Enemy:waitRandom(low, hi)
    local elapsed = 0
    local span = love.math.random(low, hi)

    return function(entity, dt)
        elapsed = elapsed + dt
        if elapsed >= span then
            elapsed = 0
            span = love.math.random(low, hi)
            print("waitRandom finished, span: "..span)
            return 'success'
        end
        return 'running'
    end
end

--Rotate clockwise steadily.
function Enemy:rotateInPlace()
    local rotation = 0

    return function(entity, dt)
        rotation = rotation + dt * 4.0
        if rotation > 6.28 then
            rotation = 0
        end
        self.rotation = rotation
        return 'success'
    end
end

return Enemy