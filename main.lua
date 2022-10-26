require "constants"
require "input.input"
require "rendering.gui"
require "rendering.camera"
require "entity.player.player"
require "world.World"

world = World()
player = Player(world)

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    love.window.updateMode(640, 360, { fullscreen = false, resizable = true, vsync = false })
    love.mouse.setVisible(false)
    local font = love.graphics.newFont("data/fonts/ProggyTinySZ.ttf", 16)
    love.graphics.setFont(font)
    love.graphics.setWireframe(false)

    rainbow_shader = love.graphics.newShader [[
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
    --kitty = love.graphics.newImage("data/textures/kitty.png")


    tilemap_textures = love.graphics.newImage("data/textures/tilemap.png")
    tilemap_batch = love.graphics.newSpriteBatch(tilemap_textures)

    gui_textures = love.graphics.newImage("data/textures/gui.png")
    gui_batch = love.graphics.newSpriteBatch(gui_textures)
end

local t = 0
function love.update(dt)
    if MouseWheelMovement ~= 0 then
        player:moveHotbarIndex(-MouseWheelMovement)
        MouseWheelMovement = 0
    end

    --Camera movement
    local x, y = 0
    local s = camera.zoom
    if Input["left"] then
        x = -1
    elseif Input["right"] then
        x = 1
    end
    if Input["up"] then
        y = -1
    elseif Input["down"] then
        y = 1
    end
    if Input["inventory"] then
        s = s * 0.99
    elseif Input["drop"] then
        s = s * 1.01
    end
    camera:move(x, y)
    camera:setZoom(s)

    t = t + dt
    rainbow_shader:send("time", t)
end

function love.draw()
    setupGuiScale()
    drawBackground()
    camera:set()
    for i = -5, 4 do
        --World Drawing
        drawPanel(0 - 32, -100, 64, 64, 0)
        printBorder("<X-   X+>", 0 - love.graphics.getFont():getWidth("<X-   X+>") / 2, -100 + 32 - love.graphics.getFont():getHeight("<X-   X+>") / 2 )
        love.graphics.push()
        love.graphics.translate(0, -100)
        love.graphics.rotate(math.rad(90))
        love.graphics.translate(0, 100)
        printBorder("<Y-   Y+>", 32 - love.graphics.getFont():getWidth("<Y-   Y+>") / 2, -100 - love.graphics.getFont():getHeight("<Y-   Y+>") / 2)
        love.graphics.pop()
        drawPanel(32 * i, -15, 30, 30, 0)
    end
    camera:unset()
    drawGui(player)
end
