require "constants"
require "input"
require "gui"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    love.window.updateMode(640, 360, { fullscreen = false, resizable = true })
    local font = love.graphics.newFont("data/fonts/ProggyTinySZ.ttf", 16)
    love.graphics.setFont(font)

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
        Player.MoveHotbar(-MouseWheelMovement)
        MouseWheelMovement = 0
    end

    --Toggle fullscreen
    if Input["menu"] == true and Input["dash"] == true then
        love.window.setFullscreen(not love.window.getFullscreen())
    end

    t = t + dt
    rainbow_shader:send("time", t)
end

function love.draw()
    drawGui()
end
