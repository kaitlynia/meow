require "class"
require "constants"
require "object.Inventory"
require "client.renderutil"

Player = class(
        function(self, world, phys, name, x, y, health, hotbar_index, inventory, vx, vy)
            self.world = world
            self.name = name or "nameless cat"
            self.health = health or Constants.MAX_HEALTH
            self.hotbar_index = hotbar_index or 1
            self.inventory = inventory or Inventory(self)
            self.vx = vx or 0
            self.vy = vy or 0

            self.w = 16
            self.h = 16
            self.physics = {}
            self.physics.body = love.physics.newBody(phys, x or 0, y or 0, "dynamic")
            self.physics.body:setFixedRotation(true)
            self.physics.shape = love.physics.newCircleShape(self.w / 2)
            self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)
            self.physics.fixture:setFriction(1)

        end
)

function Player.moveHotbarIndex(self, by)
    self.hotbar_index = self.hotbar_index + (by % Constants.MAX_HOTBAR_INDEX)

    -- handle wrapping
    if self.hotbar_index < 1 then
        self.hotbar_index = self.hotbar_index + Constants.MAX_HOTBAR_INDEX
    elseif self.hotbar_index > Constants.MAX_HOTBAR_INDEX then
        self.hotbar_index = self.hotbar_index - Constants.MAX_HOTBAR_INDEX
    end
end

function Player.getName(self)
    return self.name
end

function Player.setHotbarIndex(self, index)
    self.hotbar_index = index
end

function Player.fireAt(self, x, y)
    -- local obj = self.world.getObjectAt(x, y)
    -- obj.dealDamage(self, self.inventory[self.hotbar_index].attack or Constants.BASE_ATTACK)
end

function Player.use(self, x, y)
    -- local obj = self.world.getObjectAt(x, y)
    -- obj.use(self, self.inventory[self.hotbar_index].tool or Constants.HAND_TOOL)
end
--
--function Player.impulse(self, dx, dy)
--    self.vx = dx ~= nil and self.vx + dx or self.vx
--    self.vy = dy ~= nil and self.vy + dy or self.vy
--end
--
--function Player.setSpeed(self, x, y)
--    self.vx = x ~= nil and x or self.vx
--    self.vy = y ~= nil and y or self.vy
--end
--
--function Player.move(self, dx, dy)
--    self.x = dx ~= nil and self.x + dx or self.x
--    self.y = dy ~= nil and self.y + dy or self.y
--end
--
--function Player.teleport(self, x, y)
--    self.x = x ~= nil and x or self.x
--    self.y = y ~= nil and y or self.y
--end

function Player.setX(self, x)
    self.physics.body:setX(x)
end

function Player.setY(self, y)
    self.physics.body:setX(y)
end

function Player.getX(self)
    return self.physics.body:getX()
end

function Player.getY(self)
    return self.physics.body:getY()
end

function Player.draw(self)
    if isOnScreen(self:getX(), self:getY(), self:getX() + self.w, self:getY() + self.h, camera) then
        love.graphics.push()
        love.graphics.translate(self:getX() + self.w / 2, self:getY() + self.h / 2)
        love.graphics.rotate(self.physics.body:getAngle())
        love.graphics.translate(-self:getX() - self.w / 2, -self:getY() - self.h / 2)
        love.graphics.draw(kitty, self:getX(), self:getY())
        printBorder(self.name, self:getX() - love.graphics.getFont():getWidth(self.name) / 2 + self.w / 2, self:getY() - self.h / 2)
        love.graphics.pop()

    end
end

function Player.patch(self, data)
    for k, v in pairs(data) do
        self[k] = v
    end
end