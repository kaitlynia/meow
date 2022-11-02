require "client.gui.gui"
require "client.camera"
require "object.Panel"

PixelResX = 640
PixelResY = 360
PixelScaleX = love.graphics.getWidth() / PixelResX
PixelScaleY = love.graphics.getHeight() / PixelResY
ScaledWindowWidth = love.graphics.getWidth() / PixelScaleX
ScaledWindowHeight = love.graphics.getHeight() / PixelScaleY

love.graphics.setDefaultFilter("nearest", "nearest", 0)
love.window.updateMode(PixelResX, PixelResY, { fullscreen = false, resizable = true, vsync = false })
love.mouse.setVisible(false)
GameFont = love.graphics.newFont("data/fonts/ProggyTinySZ.ttf", 16)
love.graphics.setFont(GameFont)
love.graphics.setWireframe(false)

local WorldObjects = {}

function addToRenderer(drawable)
    table.insert(WorldObjects, drawable)
end

function removeFromRenderer(drawable)
    if WorldObjects[drawable] then
        table.remove(WorldObjects, WorldObjects[drawable])
    end
end

function setupRendering()
    --Shaders
    ShaderRainbow = love.graphics.newShader [[
        extern number time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
            vec4 colors = vec4((1.0+sin(time))/2.0, abs(cos(time)), abs(sin(time)), 1.0);
            vec4 texcolor = Texel(texture, texture_coords);
            return texcolor * colors;
        }
    ]]

    --bg = love.graphics.newImage("data/textures/bg_1.png")
    --bg:setWrap("repeat", "clampzero", "clampzero");
    kitty = love.graphics.newImage("data/textures/kitty.png")

    --Textures
    tilemap_textures = love.graphics.newImage("data/textures/tilemap.png")
    tilemap_batch = love.graphics.newSpriteBatch(tilemap_textures)
    gui_textures = love.graphics.newImage("data/textures/gui.png")
    gui_batch = love.graphics.newSpriteBatch(gui_textures)

    --Quads
    QuadBackgroundTile = love.graphics.newQuad(0, 32, 16, 16, tilemap_textures:getDimensions())
    QuadCursor = love.graphics.newQuad(16, 48, 16, 16, gui_textures:getDimensions())
    QuadHotbarUnselected = love.graphics.newQuad(0, 0, 18, 18, gui_textures:getDimensions())
    QuadHotbarSelected = love.graphics.newQuad(18, 0, 18, 18, gui_textures:getDimensions())

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
    drawBackground()
    drawView()
    drawGui()
end

function updatePixelScaling()
    PixelScaleX = love.graphics.getWidth() / PixelResX
    PixelScaleY = love.graphics.getHeight() / PixelResY
    ScaledWindowWidth = love.graphics.getWidth() / PixelScaleX
    ScaledWindowHeight = love.graphics.getHeight() / PixelScaleY
end

function drawView()
    camera:set()
    for _, v in pairs(WorldObjects) do
        v:draw()
    end
    camera:unset()
end


