require "rendering.components.Panel"
require "rendering.components.Text"
require "rendering.Rendering"

Button = {}

function Button:new(text, x, y, w, h, onClick)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	self.x = x or 0
	self.y = y or 0
	self.w = w or 0
	self.h = h or 0
	self.onClick = onClick or function()
	end

	self.panel = Panel:new(x, y, w, h, 0)
	self.text = Text:new(text, self.x, self.y)

	return o
end

function Button:update()
	if love.mouse.isDown(1) then
		local mousepos = getMousePos()
		if mousepos.x >= self.x and mousepos.y >= self.y then
			if mousepos.x <= self.x + self.w and mousepos.y <= self.y + self.h then
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
	self.text.fg = self.panel.type == 1 and { 0.75, 0.75, 0.75 } or { 1, 1, 1 }
	self.text:center(self.x + self.w / 2, self.y + self.h / 2)
	self.text:draw()
end