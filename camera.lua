camera = {}
camera.x = 0 - love.graphics.getWidth() / 2 / (love.graphics.getWidth() / 640)
camera.y = 0 - love.graphics.getHeight() / 2 / (love.graphics.getHeight() / 360)
camera.zoom = 1

function camera:set()
    local cameraOx = love.graphics.getWidth() / 2 / (love.graphics.getWidth() / 640)
    local cameraOy = love.graphics.getHeight() / 2 / (love.graphics.getHeight() / 360)
    love.graphics.push()
    love.graphics.translate(cameraOx, cameraOy)
    love.graphics.scale(1 / self.zoom, 1 / self.zoom)
    love.graphics.translate(-self.x, -self.y)
    love.graphics.translate(-cameraOx, -cameraOy)
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

function camera:getX()
    return self.x
end

function camera:getY()
    return self.y
end