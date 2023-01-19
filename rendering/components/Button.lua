require "rendering.components.Panel"

Button = {}

function Button:new(x, y, w, h)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	self.x = x or 0
	self.y = y or 0
	self.w = w or 0
	self.h = h or 0

	self.panel = Panel:new(x, y, w, h, 0)

	self:flush()

	return o
end

function Button:update()
	if love.mouse.getX() > self.x and love.mouse.getY() > self.y then
		if love.mouse.getX() < self.x + self.w and love.mouse.getY() < self.y + self.h then
			if love.mouse.isDown(2) then
				self.panel:setType(1)
			elseif self.panel.type == 1 then
				self.panel:setType(0)
			end
		end
	end
end

function Button:clear()
	self.panel:clear()
end

function Button:flush()
	self.panel:flush()
end

function Button:draw()

	self.panel:draw()
end