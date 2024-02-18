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

    self.collider = G_WORLD:newCollider(
        "Rectangle",
        {self.x + (self.w/2.0), self.y + (self.h/2.0),
        self.w, self.h})

    -- Prevent from moving or rotating.
    self.collider:setType("static")
    self.collider:setFixedRotation(true)
end

function Interactable:update(dt)
end

function Interactable:draw()
    love.graphics.push()
    love.graphics.setColor(
        self.r, self.g, self.b, self.a)
    love.graphics.rectangle(
        "fill", self.x, self.y, self.w, self.h)
    love.graphics.pop()
end

function Interactable:loadSprite(path)
end

function Interactable:setX(x)
    self.collider:setX(x)
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

return Interactable