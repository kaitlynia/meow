require "class"

Panel = class(
        function(self, x, y, w, h, t)
            self.x = x
            self.y = y
            self.w = w
            self.h = h
            self.type = t

            self.texture = love.graphics.newImage("data/textures/gui.png")
            self.batch = love.graphics.newSpriteBatch(self.texture)

            local tx = 5 * self.type
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
        end
)

function Panel.flush(self)
    self.batch:clear()
    for ix = 1, self.w - 1 do
        for iy = 1, self.h - 1 do
            self.batch:add(self.panel_fill, self.x + ix, self.y + iy)
        end
    end
    for ix = 1, self.w - 1 do
        self.batch:add(self.panel_tm, self.x + ix, self.y)
        self.batch:add(self.panel_bm, self.x + ix, self.y + self.h)
    end
    for iy = 1, self.h - 1 do
        self.batch:add(self.panel_ml, self.x, self.y + iy)
        self.batch:add(self.panel_mr, self.x + self.w, self.y + iy)
    end
    self.batch:add(self.panel_tl, self.x, self.y)
    self.batch:add(self.panel_tr, self.x + self.w, self.y)
    self.batch:add(self.panel_bl, self.x, self.y + self.h)
    self.batch:add(self.panel_br, self.x + self.w, self.y + self.h)
    self.batch:flush()
end

function Panel.draw(self)
    love.graphics.draw(self.batch)
end