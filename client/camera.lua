camera = {}
camera.x = 0
camera.y = 0
camera.zoom = 1

function camera:set()
	local cameraOx = love.graphics.getWidth() / 2 / (love.graphics.getWidth() / PixelResX)
	local cameraOy = love.graphics.getHeight() / 2 / (love.graphics.getHeight() / PixelResY)
	love.graphics.push()
	love.graphics.translate(cameraOx, cameraOy)
	love.graphics.scale(1 / self.zoom, 1 / self.zoom)
	love.graphics.translate(-self.x, -self.y)
	love.graphics.translate(-cameraOx, -cameraOy)
	love.graphics.translate(cameraOx, cameraOy)
end

function camera:unset()
	love.graphics.pop()
end

function camera:move(x, y)
	self.x = self.x + (x or 0)
	self.y = self.y + (y or 0)
end

function camera:setPos(x, y)
	self.x = x
	self.y = y
end

function camera:setZoom(z)
	self.zoom = z
end

function camera:getZoom()
	return self.zoom
end

function camera:getX()
	return self.x
end

function camera:getY()
	return self.y
end