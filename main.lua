require "rendering.Rendering"
require "config"
require "rendering.Camera"
require "rendering.components.Button"

GuiDrawables = {}
WorldDrawables = {}

clientConfig = loadClientConfig("config.json")
debug_isConnected = false;

function love.load()
	setupRendering()
	table.insert(GuiDrawables, Button:new("Connect", 10, 10, 300, 80, function()

	end))

end

furnace = love.graphics.newImage("resource/textures/furnace.png")

function love.draw()
	love.graphics.push()
	love.graphics.scale(PixelScaleX, PixelScaleY)
	camera:set()

	--Draw world stuff here
	--love.graphics.draw(furnace,20,20)


	camera:unset()

	for _, v in pairs(GuiDrawables) do
		v:draw()
	end

	love.graphics.pop()
end

function love.update(dt)
	for _, v in pairs(GuiDrawables) do
		v:update()
	end
end

function love.quit()
	--client check server connect send disconnect packet
end