local Interactable = Object:extend()

function Interactable:new(x, y, w, h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.r = 1
    self.g = 1
    self.b = 1
    self.a = 1

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
    self.depleteRate = 0.1
end

function Interactable:update(dt)
    self:deplete()
end

function Interactable:draw()
    love.graphics.push()
    love.graphics.setColor(
        self.r, self.g, self.b, self.a)
    love.graphics.rectangle(
        "fill", self.x, self.y, self.w, self.h)
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
    -- Green fg bar.
    love.graphics.pop()
    love.graphics.push()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle(
        "fill", self:getX(), self:getY() - 10, self.w * self:getHpPercent(), 5)
    love.graphics.pop()
end

function Interactable:getHpPercent()
    return self.health / 100
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

return Interactable