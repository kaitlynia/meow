Text = {}

function Text:new(text, x, y, text_color, border_color)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	self.text = text or ""
	self.x = x or 0
	self.y = y or 0
	self.fg = text_color or { 1, 1, 1 }
	self.bg = border_color or { 0, 0, 0 }
	return o
end

function Panel:update()

end

function Text:setText(text)
	self.text = text
end

function Text:center(x, y)
	self.x = x - GameFont:getWidth(self.text) / 2
	self.y = y - GameFont:getHeight(self.text) / 2
end

function Text:draw()
	love.graphics.setColor(self.bg)
	love.graphics.print(self.text, self.x - 1, self.y)
	love.graphics.print(self.text, self.x, self.y - 1)
	love.graphics.print(self.text, self.x + 1, self.y)
	love.graphics.print(self.text, self.x, self.y + 1)
	love.graphics.setColor(self.fg)
	love.graphics.print(self.text, self.x, self.y)
	love.graphics.setColor({ 1, 1, 1 })
end