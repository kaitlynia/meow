require "rendering.MainMenu"
require "rendering.Camera"

PixelResX = 640
PixelResY = 360
PixelScaleX = love.graphics.getWidth() / PixelResX
PixelScaleY = love.graphics.getHeight() / PixelResY
ScaledWindowWidth = love.graphics.getWidth() / PixelScaleX
ScaledWindowHeight = love.graphics.getHeight() / PixelScaleY

love.graphics.setDefaultFilter("nearest", "nearest", 0)
love.window.updateMode(PixelResX, PixelResY, { fullscreen = false, resizable = true, vsync = false })
love.mouse.setVisible(true)
GameFont = love.graphics.newFont("resource/fonts/ProggyTinySZ.ttf", 16)
love.graphics.setFont(GameFont)
love.graphics.setWireframe(false)

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

	updatePixelScaling()
end

function love.resize(w, h)
	if not isWindowValidRatio() then
		love.window.updateMode(w, (PixelResY / PixelResX) * w)
	end
	updatePixelScaling()
end

function screenPosToWorldPos(x, y)
	local worldPos = {}
	worldPos.x = camera:getX() + ((x / PixelScaleX - ScaledWindowWidth / 2) * camera:getZoom())
	worldPos.y = camera:getY() + ((y / PixelScaleY - ScaledWindowHeight / 2) * camera:getZoom())
	return worldPos
end

function isMouseInside(x, y, x2, y2)
	local mousepos = getMousePos()
	if mousepos.x >= x and mousepos.y >= y then
		if mousepos.x <= x2 and mousepos.y <= y2 then
			return true
		end
	end
	return false
end

function getMousePos()
	local mousepos = {}
	mousepos.x = love.mouse.getX() / PixelScaleX
	mousepos.y = love.mouse.getY() / PixelScaleY
	return mousepos
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