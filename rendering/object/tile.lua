require "class"

Tile = class(
        function(self, x, y, t, w, h)
            local ts = 16
            self.w = w or ts
            self.h = h or ts
            self.x = x - self.w / 2
            self.y = y - self.h / 2
            self.type = t

            self.texture = love.graphics.newImage("data/textures/tilemap.png")
            self.batch = love.graphics.newSpriteBatch(self.texture)

            local tx = t % (self.texture:getPixelWidth() / ts + 1) * ts
            local ty = math.floor(t / (self.texture:getPixelHeight() / ts)) % (self.texture:getPixelWidth() / ts + 1) * ts
            self.tile = love.graphics.newQuad(tx, ty, ts, ts, self.texture:getDimensions())
            self:flush()
        end
)

function Tile.flush(self)
    self.batch:clear()
    self.batch:add(self.tile, self.x, self.y)
    self.batch:flush()
end

function Tile.draw(self)
    if isOnScreen(self.x, self.y, self.x + self.w, self.y + self.h, camera) then
        love.graphics.draw(self.batch)
    end
end

function Tile.getPos(self)
    return { x = self.x, y = self.y }
end

function Tile.getSize(self)
    return { w = self.w, h = self.h }
end

function Tile.setPos(self, x, y)
    self.x = x or self.x
    self.y = y or self.y
    self:flush()
end

function Tile.setSize(self, w, h)
    self.w = w or self.w
    self.h = h or self.h
    self:flush()
end

function Tile.setType(self, t)
    self.type = t
    self:flush()
end