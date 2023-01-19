require "rendering.MainMenu"
require "rendering.components.Panel"

PixelResX = 640
PixelResY = 360
PixelScaleX = love.graphics.getWidth() / PixelResX
PixelScaleY = love.graphics.getHeight() / PixelResY
ScaledWindowWidth = love.graphics.getWidth() / PixelScaleX
ScaledWindowHeight = love.graphics.getHeight() / PixelScaleY

love.graphics.setDefaultFilter("nearest", "nearest", 0)
love.window.updateMode(PixelResX, PixelResY, { fullscreen = false, resizable = true, vsync = false })
love.mouse.setVisible(false)
GameFont = love.graphics.newFont("resource/fonts/ProggyTinySZ.ttf", 16)
love.graphics.setFont(GameFont)
love.graphics.setWireframe(false)

Drawables = {}

function setupRendering()
	--Shaders
	--ShaderRainbow = love.graphics.newShader [[
	--    extern number time;
	--    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
	--    {
	--        vec4 colors = vec4((1.0+sin(time))/2.0, abs(cos(time)), abs(sin(time)), 1.0);
	--        vec4 texcolor = Texel(texture, texture_coords);
	--        return texcolor * colors;
	--    }
	--]]


	--Textures
	--tilemap_textures = love.graphics.newImage("data/textures/tilemap.png")
	--tilemap_batch = love.graphics.newSpriteBatch(tilemap_textures)
	--gui_textures = love.graphics.newImage("data/textures/gui.png")
	--gui_batch = love.graphics.newSpriteBatch(gui_textures)

	--Quads
	--QuadBackgroundTile = love.graphics.newQuad(0, 32, 16, 16, tilemap_textures:getDimensions())
	--QuadCursor = love.graphics.newQuad(16, 48, 16, 16, gui_textures:getDimensions())
	--QuadHotbarUnselected = love.graphics.newQuad(0, 0, 18, 18, gui_textures:getDimensions())
	--QuadHotbarSelected = love.graphics.newQuad(18, 0, 18, 18, gui_textures:getDimensions())

	table.insert(Drawables, Panel:new(nil, 20, 20, 60, 60, 0))

	updatePixelScaling()
end

function love.resize(w, h)
	if not isWindowValidRatio() then
		love.window.updateMode(w, (PixelResY / PixelResX) * w)
	end
	updatePixelScaling()
end

function love.draw()
	love.graphics.push()
	love.graphics.scale(PixelScaleX, PixelScaleY)

	for _, v in pairs(Drawables) do
		v:draw()
	end

	love.graphics.pop()
end

function updatePixelScaling()
	PixelScaleX = love.graphics.getWidth() / PixelResX
	PixelScaleY = love.graphics.getHeight() / PixelResY
	ScaledWindowWidth = love.graphics.getWidth() / PixelScaleX
	ScaledWindowHeight = love.graphics.getHeight() / PixelScaleY
end

function isWindowValidRatio()
	return love.graphics.getHeight() / love.graphics.getWidth() == PixelResY / PixelResX
end