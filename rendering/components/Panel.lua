Panel = {}

function Panel:new(x, y, w, h, type)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.x = x or 0
	o.y = y or 0
	o.w = w or 0
	o.h = h or 0
	o.type = type or 0

	o.texture = love.graphics.newImage("resource/textures/gui.png")
	o.sprite_batch = love.graphics.newSpriteBatch(o.texture)

	o:setType(o.type)


	return o
end

function Panel:update()
	
end

function Panel:setType(type)
	self.type = type
	local tx = 5 * type
	local ty = 32
	self.panel_tl = love.graphics.newQuad(tx, ty, 2, 2, self.texture:getDimensions())
	self.panel_tm = love.graphics.newQuad(tx + 2, ty, 1, 2, self.texture:getDimensions())
	self.panel_tr = love.graphics.newQuad(tx + 3, ty, 2, 2, self.texture:getDimensions())
	self.panel_ml = love.graphics.newQuad(tx, ty + 2, 2, 1, self.texture:getDimensions())
	self.panel_fill = love.graphics.newQuad(tx + 2, ty + 2, 1, 1, self.texture:getDimensions())
	self.panel_mr = love.graphics.newQuad(tx + 3, ty + 2, 2, 1, self.texture:getDimensions())
	self.panel_bl = love.graphics.newQuad(tx, ty + 3, 2, 2, self.texture:getDimensions())
	self.panel_bm = love.graphics.newQuad(tx + 2, ty + 3, 1, 2, self.texture:getDimensions())
	self.panel_br = love.graphics.newQuad(tx + 3, ty + 3, 2, 2, self.texture:getDimensions())
	self:flush()
end

function Panel:clear()
	self.sprite_batch:clear()
end

function Panel:flush()
	for ix = 1, self.w - 1 do
		for iy = 1, self.h - 1 do
			self.sprite_batch:add(self.panel_fill, self.x + ix, self.y + iy)
		end
	end
	for ix = 1, self.w - 1 do
		self.sprite_batch:add(self.panel_tm, self.x + ix, self.y)
		self.sprite_batch:add(self.panel_bm, self.x + ix, self.y + self.h)
	end
	for iy = 1, self.h - 1 do
		self.sprite_batch:add(self.panel_ml, self.x, self.y + iy)
		self.sprite_batch:add(self.panel_mr, self.x + self.w, self.y + iy)
	end
	self.sprite_batch:add(self.panel_tl, self.x, self.y)
	self.sprite_batch:add(self.panel_tr, self.x + self.w, self.y)
	self.sprite_batch:add(self.panel_bl, self.x, self.y + self.h)
	self.sprite_batch:add(self.panel_br, self.x + self.w, self.y + self.h)
	self.sprite_batch:flush()
end

function Panel:draw()
	love.graphics.draw(self.sprite_batch)
end