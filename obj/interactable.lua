local Interactable = Object:extend()

local DEFAULT_DEPLETE_RATE = 0.1

function Interactable:new(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.r = 1
    self.g = 1
    self.b = 1
    self.a = 1
    self.sprite = love.graphics.newImage("assets/generator.png")
    self.ox = 0
    self.oy = 0

    -- Set up collider so it doesn't move or rotate.
    self.collider = G_WORLD:newCollider(
        "Rectangle",
        {self.x + (self.w/2.0), self.y + (self.h/2.0),
        self.w, self.h})
    self.collider:setType("static")
    self.collider:setFixedRotation(true)

    self.health = 100
    self.healFactor = 2
    self.healRate = 1 * self.healFactor
    self.depleteRate = DEFAULT_DEPLETE_RATE
end

function Interactable:update(dt)
    self:deplete()
end

function Interactable:draw()
    love.graphics.push()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, self.ox, self.oy)
    love.graphics.pop()

    self:drawHealthBar()
end

function Interactable:loadSprite(path)
end

function Interactable:getX()
    return self.collider:getX() - (self.w/2.0)
end

function Interactable:setX(x)
    self.collider:setX(x)
end

function Interactable:getY()
    return self.collider:getY() - (self.h/2.0)
end

function Interactable:setY(y)
    self.collider:setY(y)
end

function Interactable:setColor(r, g, b, a)
    self.r = r
    self.g = g
    self.b = b
    self.a = a
end

function Interactable:drawHealthBar()
    -- Shadow.
    love.graphics.push()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle(
        "fill", self:getX() + 1, self:getY() - 9, self.w, 5)
    love.graphics.pop()
    -- Red bg bar.
    love.graphics.push()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle(
        "fill", self:getX(), self:getY() - 10, self.w, 5)
    love.graphics.pop()
    -- Green fg bar.
    love.graphics.push()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle(
        "fill", self:getX(), self:getY() - 10, self.w * self:getHpPercent(), 5)
    love.graphics.pop()
end

function Interactable:getHpPercent()
    return self.health / 100
end

function Interactable:setHp(hp)
    self.health = math.min(hp, 100)
    self.health = math.max(self.health, 0)
end

function Interactable:heal()
    local maxHealth = 100
    local updateHealth = self.health + self.healRate
    self.health = math.min(updateHealth, maxHealth)
end

function Interactable:deplete()
    local minHealth = 0
    local updateHealth = self.health - self.depleteRate
    self.health = math.max(updateHealth, minHealth)
end

function Interactable:getDepleteRate()
    return self.depleteRate
end

function Interactable:setEnemyPenalty(count)
    local penaltyFactor = 0.02
    self.depleteRate = DEFAULT_DEPLETE_RATE + (count * penaltyFactor)
end

return Interactable