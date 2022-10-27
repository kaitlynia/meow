require "class"
require "constants"
require "entity.player.Inventory"
require "rendering.renderutil"

Player = class(
        function(self, world, name, health, hotbar_index, inventory, x, y, vx, vy)
            self.world = world
            self.name = name or "nameless cat"
            self.health = health or Constants.MAX_HEALTH
            self.hotbar_index = hotbar_index or 1
            self.inventory = inventory or Inventory(self)
            self.x = x or 0
            self.y = y or 0
            self.vx = vx or 0
            self.vy = vy or 0
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

function Player.impulse(self, dx, dy)
    self.vx = dx ~= nil and self.vx + dx or self.vx
    self.vy = dy ~= nil and self.vy + dy or self.vy
end

function Player.setSpeed(self, x, y)
    self.vx = x ~= nil and x or self.vx
    self.vy = y ~= nil and y or self.vy
end

function Player.move(self, dx, dy)
    self.x = dx ~= nil and self.x + dx or self.x
    self.y = dy ~= nil and self.y + dy or self.y
end

function Player.teleport(self, x, y)
    self.x = x ~= nil and x or self.x
    self.y = y ~= nil and y or self.y
end

function Player.getPos(self)
    return { x = self.x, y = self.y }
end

function Player.draw(self)
    if isOnScreen(self.x - 8, self.y - 16, self.x + 16, self.y + 16, camera) then
        love.graphics.draw(kitty, self.x - 8, self.y - 16)
    end
end