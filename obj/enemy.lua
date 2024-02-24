local Enemy = Object:extend()
local Selector = require("lib.beehive.selector")
local Sequence = require("lib.beehive.sequence")

function Enemy:new()
    self.x = love.math.random(0, G_GAMEWIDTH)
    self.y = love.math.random(0, G_GAMEHEIGHT)
    self.last_origin_x = self.x
    self.last_origin_y = self.y
    self.goal_x = G_GAMEWIDTH / 2
    self.goal_y = G_GAMEHEIGHT / 2
    self.attached = false

    self.speed = 1.5
    self.sprite = love.graphics.newImage("assets/enemy_magenta.png")
    self.sprite_attached = love.graphics.newImage("assets/enemy_red.png")
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
    return (Selector{
        self:attachBoxOrMoveTask(),
        self:randomUpdateGoalTask(),
    })
end

function Enemy:randomUpdateGoalTask()
    return Sequence({
        self:waitRandomTask(0, 1),
        self:updateGoalTask()
    })
end

-- Wait a bit of time before succeeding.
function Enemy:waitRandomTask(low, hi)
    local elapsed = 0
    local span = love.math.random(low, hi)
    return function(entity, dt)
        elapsed = elapsed + dt
        if elapsed >= span then
            elapsed = 0
            span = love.math.random(low, hi)
            return 'success'
        end
        return 'running'
    end
end

function Enemy:attachBoxOrMoveTask()
    return function(entity, dt)
        if self:isAtGoal() == true or self.attached == true then
            return 'failure'
        end
        local dx = (self.last_origin_x - self.goal_x) / self.speed * dt
        local dy = (self.last_origin_y - self.goal_y) / self.speed * dt
        self.x = self.x - dx
        self.y = self.y - dy
        return 'success'
    end
end

function Enemy:updateGoalTask()
    return function(entity, dt)
        if self:updateGoal() == true then
            return 'success'
        end
        return 'failure'
    end
end

function Enemy:updateGoal()
    if self:isAtGoal() == true then
        self.last_origin_x = self.x
        self.last_origin_y = self.y
        self.goal_x = math.random(50, G_GAMEWIDTH - 50)
        self.goal_y = math.random(25, G_GAMEHEIGHT - 25)
        return true
    end
    return false
end

function Enemy:isAtGoal()
    local remaining_x = math.abs(self.x - self.goal_x)
    local remaining_y = math.abs(self.y - self.goal_y)
    return (remaining_x < 1.0 and remaining_y < 1.0)
end

function Enemy:setAttached()
    local rand = love.math.random(1, 300)
    if rand == 1 then
        self.attached = true
        self.sprite = self.sprite_attached
    end
end

--Rotate clockwise steadily.
function Enemy:rotateInPlaceTask()
    local rotation = 0
    local rot_speed = 4.0
    return function(entity, dt)
        rotation = rotation + dt * rot_speed
        if rotation > 6.28 then
            rotation = 0
        end
        self.rotation = rotation
        return 'success'
    end
end

return Enemy