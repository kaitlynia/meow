require "rendering.components.Panel"
require "rendering.components.Text"
require "rendering.Rendering"

Button = {}

function Button:new(text, x, y, w, h, onClick, color)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.x = x or 0
	o.y = y or 0
	o.w = w or 0
	o.h = h or 0
	o.color = color or { 1, 1, 1, 1 }
	o.onClick = onClick or function()
	end

	o.panel = Panel:new(x, y, w, h, 0)
	o.text = Text:new(text, o.x, o.y)

	return o
end

function Button:update()
	if love.mouse.isDown(1) then
		if isMouseInside(self.x, self.y, self.x + self.w, self.y + self.h) then
			if self.panel.type == 0 then
				self.panel:setType(1)
				self.onClick()
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
	love.graphics.setColor(self.color)
	self.panel:draw()
	love.graphics.setColor({ 1, 1, 1, 1 })
	self.text.fg = self.panel.type == 1 and { 0.75, 0.75, 0.75 } or { 1, 1, 1 }
	self.text:center(self.x + self.w / 2, self.y + self.h / 2)
	self.text:draw()
end