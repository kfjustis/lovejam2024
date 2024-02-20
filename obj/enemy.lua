local Enemy = Object:extend()
local Selector = require("lib.beehive.selector")

-- Wait a bit of time before succeeding.
local function waitRandom(low, hi)
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

local function makeBrain()
    return (Selector{waitRandom(1, 3)})
end

function Enemy:new()
    self.brain = makeBrain()
end

function Enemy:update(dt)
    self.brain(self.brain, dt)
end

function Enemy:draw()
end

return Enemy