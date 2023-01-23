TextBox = {}

function TextBox:new(x, y, w, h, defaultText, panelType)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.x = x or 0
	o.y = y or 0
	o.focused = false
	o.defaultText = defaultText or ""

	o.panel = Panel:new(x, y, w, h, panelType or 2)
	o.text = Text:new(o.defaultText, o.x + 5, o.y + 5, { 0.5, 0.5, 0.5 })
	return o
end

function TextBox:update()
	if love.mouse.isDown(1) then
		if isMouseInside(self.panel.x, self.panel.y, self.panel.x + self.panel.w, self.panel.y + self.panel.h) then
			self.focused = true
			return
		end
		self.focused = false
	end
end

function TextBox:setText(text)
	if self.panel.w - 5 - GameFont:getWidth(text) > 0 then
		if self.text:getText() == self.defaultText then
			self.text.fg = { 1, 1, 1 }
		end
		self.text:setText(text)
	end
	if string.len(self.defaultText) > 0 and string.len(text) <= 0 then
		self.text:setText(self.defaultText)
		self.text.fg = { 0.5, 0.5, 0.5 }
	end
end

function TextBox:getText()
	return self.text:getText() == self.defaultText and "" or self.text:getText()
end

function TextBox:draw()
	if self.focused then
		love.graphics.setColor({ 0.5, 0.5, 1 })
	else
		love.graphics.setColor({ 1, 1, 1 })
	end

	self.panel:draw()
	love.graphics.setColor({ 1, 1, 1, 1 })
	self.text:draw()
end

local utf8 = require("utf8")
function TextBox:keyPress(key)
	if self.focused then
		if key == "backspace" then
			local byteoffset = utf8.offset(self:getText(), -1)
			if byteoffset then
				self:setText(string.sub(self:getText(), 1, byteoffset - 1))
			end
		end
	end
end

function TextBox:textInput(t)
	if self.focused then
		self:setText(self:getText() .. t)
	end
end