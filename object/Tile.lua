require "class"

Tile = class(
		function(self, world, x, y, t, w, h)
			local ts = 16
			self.w = w or ts
			self.h = h or ts
			self.type = t

			self.texture = love.graphics.newImage("data/textures/tilemap.png")
			self.batch = love.graphics.newSpriteBatch(self.texture)

			local tx = t % (self.texture:getPixelWidth() / ts) * ts
			local ty = math.floor(t / (self.texture:getPixelHeight() / ts)) % (self.texture:getPixelWidth() / ts) * ts
			self.tile = love.graphics.newQuad(tx, ty, ts, ts, self.texture:getDimensions())

			local bodytype = "static"
			local density = 1
			if t == 25 or t == 26 then
				bodytype = "dynamic"
			end
			if t == 25 then
				density = 5
			end
			self.physics = {}
			self.physics.body = love.physics.newBody(world, x, y, bodytype)
			self.physics.shape = love.physics.newRectangleShape(self.w, self.h)
			self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, density)
			if t == 26 then
				self.physics.fixture:setRestitution(0.7)
			end

			self:flush()
		end
)

function Tile.flush(self)
	self.batch:clear()
	self.batch:add(self.tile, self:getX(), self:getY())
	self.batch:flush()
end

function Tile.draw(self)
	self:flush()
	if isOnScreen(self:getX(), self:getY(), self:getX() + self.w, self:getY() + self.h, camera) then
		love.graphics.push()
		love.graphics.translate(self:getX() + self.w / 2, self:getY() + self.h / 2)
		love.graphics.rotate(self.physics.body:getAngle())
		love.graphics.translate(-self:getX() - self.w / 2, -self:getY() - self.h / 2)
		love.graphics.draw(self.batch)
		love.graphics.pop()
	end
end

function Tile.getX(self)
	return self.physics.body:getX()
end

function Tile.getY(self)
	return self.physics.body:getY()
end