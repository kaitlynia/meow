require "rendering.gui"
require "rendering.camera"
require "rendering.panel"

PixelResX = 640
PixelResY = 360
PixelScaleX = love.graphics.getWidth() / PixelResX
PixelScaleY = love.graphics.getHeight() / PixelResY
ScaledWindowWidth = love.graphics.getWidth() / PixelScaleX
ScaledWindowHeight = love.graphics.getHeight() / PixelScaleY

examplep = Panel(-32, -100, 64, 64, 0)

function loadTextures()
    tilemap_textures = love.graphics.newImage("data/textures/tilemap.png")
    tilemap_batch = love.graphics.newSpriteBatch(tilemap_textures)

    gui_textures = love.graphics.newImage("data/textures/gui.png")
    gui_batch = love.graphics.newSpriteBatch(gui_textures)

    QuadBackgroundTile = love.graphics.newQuad(0, 32, 16, 16, tilemap_textures:getDimensions())
    QuadCursor = love.graphics.newQuad(16, 48, 16, 16, gui_textures:getDimensions())
    QuadHotbarUnselected = love.graphics.newQuad(0, 0, 18, 18, gui_textures:getDimensions())
    QuadHotbarSelected = love.graphics.newQuad(18, 0, 18, 18, gui_textures:getDimensions())

    updatePixelScaling()
    examplep:flush()
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
    drawGui(player)
end

function updatePixelScaling()
    PixelScaleX = love.graphics.getWidth() / PixelResX
    PixelScaleY = love.graphics.getHeight() / PixelResY
    ScaledWindowWidth = love.graphics.getWidth() / PixelScaleX
    ScaledWindowHeight = love.graphics.getHeight() / PixelScaleY
end

function drawView()
    camera:set()
    examplep:draw()
    --drawPanel(0 - 32, -100, 64, 64, 0)
    printBorder("<X-   X+>", 0 - love.graphics.getFont():getWidth("<X-   X+>") / 2, -100 + 32 - love.graphics.getFont():getHeight("<X-   X+>") / 2)
    love.graphics.push()
    love.graphics.translate(0, -100)
    love.graphics.rotate(math.rad(90))
    love.graphics.translate(0, 100)
    printBorder("<Y-   Y+>", 32 - love.graphics.getFont():getWidth("<Y-   Y+>") / 2, -100 - love.graphics.getFont():getHeight("<Y-   Y+>") / 2)
    love.graphics.pop()
    for i = -5, 4 do
        drawPanel(32 * i, -15, 30, 30, 0)
    end
    camera:unset()
end


