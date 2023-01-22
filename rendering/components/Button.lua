require "rendering.components.Panel"

Button = {}

function Button:new(text, x, y, w, h, onClick)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	self.text = text or ""
	self.x = x or 0
	self.y = y or 0
	self.w = w or 0
	self.h = h or 0
	self.onClick = onClick or function()
	end

	self.panel = Panel:new(x, y, w, h, 0)

	return o
end

function Button:update()
	if love.mouse.isDown(1) then
		if love.mouse.getX() > self.x and love.mouse.getY() > self.y then
			if love.mouse.getX() < self.x + self.w and love.mouse.getY() < self.y + self.h then
				if self.panel.type == 0 then
					self.panel:setType(1)
					self.onClick()
				end
			end
		end
	elseif self.panel.type == 1 then
		self.panel:setType(0)
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
	local x = self.x + self.w / 2 - GameFont:getWidth(self.text) / 2
	local y = self.y + self.h / 2 - GameFont:getHeight(self.text) / 2

	love.graphics.setColor({ 0, 0, 0 })
	love.graphics.print(self.text, x - 1, y)
	love.graphics.print(self.text, x, y - 1)
	love.graphics.print(self.text, x + 1, y)
	love.graphics.print(self.text, x, y + 1)
	local fg = {1,1,1}
	if self.panel.type == 1 then
		fg = {0.75, 0.75, 0.75}
	end
	love.graphics.setColor(fg)
	love.graphics.print(self.text, x, y)
	love.graphics.setColor({ 1, 1, 1 })
end