require "constants"
require "input.input"
require "rendering.camera"
require "entity.player.player"
require "world.World"
require "rendering.renderer"

world = World()
player = Player(world)

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    love.window.updateMode(PixelResX, PixelResY, { fullscreen = false, resizable = true, vsync = false })
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

    loadTextures()
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
