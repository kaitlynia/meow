require "rendering.Rendering"
require "config"
require "rendering.Camera"
require "rendering.components.Button"
require "rendering.components.TextBox"

GuiDrawables = {}
GuiInputs = {}
WorldDrawables = {}

clientConfig = loadClientConfig("config.json")
debug_isConnected = false

function love.load()
	setupRendering()
	love.keyboard.setKeyRepeat(true)

	table.insert(GuiDrawables, Button:new("Connect", 320, 328, 310, 20, function()

	end, { 0, 1, 0 }))

	table.insert(GuiDrawables, Button:new("Quit", 10, 328, 300, 20, function()
		love.event.quit()
	end, { 1, 0, 0 }))

	table.insert(GuiDrawables, Text:new("IP:", 30, 30))
	ipTextbox = TextBox:new(70, 24, 200, 19, "Type here...")
	table.insert(GuiInputs, ipTextbox)
	table.insert(GuiDrawables, ipTextbox)

	table.insert(GuiDrawables, Text:new("Name:", 30, 60))
	nameTextBox = TextBox:new(70, 54, 200, 19, "Type here...")
	table.insert(GuiInputs, nameTextBox)
	table.insert(GuiDrawables, nameTextBox)


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
		v:update(dt)
	end
end

function love.textinput(t)
	for _, v in pairs(GuiInputs) do
		v:textInput(t)
	end
end

function love.keypressed(key)
	for _, v in pairs(GuiInputs) do
		v:keyPress(key)
	end
end

function love.quit()
	--client check server connect send disconnect packet
end