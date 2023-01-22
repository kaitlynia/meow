require "rendering.Rendering"

Drawables = {}

function love.load()
	setupRendering()

	table.insert(Drawables, Button:new("Connect", 640 / 2 - 150, 360 / 2 - 40, 300, 80, function()

	end))
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(PixelScaleX, PixelScaleY)

	for _, v in pairs(Drawables) do
		v:draw()
	end

	love.graphics.pop()
end

function love.update(dt)
	for _, v in pairs(Drawables) do
		v:update()
	end

end

function love.quit()
	--client check server connect send disconnect packet
end