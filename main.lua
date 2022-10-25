require "constants"
require "input"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest", 0)
    love.window.updateMode(640, 360, { fullscreen = false, resizable = true })
    font = love.graphics.newFont("data/fonts/ProggyTinySZ.ttf", 16)
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
        Player.MoveHotbar(MouseWheelMovement)
        MouseWheelMovement = 0
    end

    --Toggle fullscreen
    if Input["menu"] == true and Input["dash"] == true then
        love.window.setFullscreen(not love.window.getFullscreen())
    end

    t = t + dt
    rainbow_shader:send("time", t)
end

function isWindowValidRatio()
    return love.graphics.getHeight() / love.graphics.getWidth() == 360 / 640
end

function love.draw()

    scalew = love.graphics.getWidth() / 640
    scaleh = love.graphics.getHeight() / 360
    love.graphics.scale(scalew, scaleh)

    --Draws background
    tilemap_batch:clear()
    bg = love.graphics.newQuad(0, 32, 16, 16, tilemap_textures:getDimensions())
    for bx = 0, love.graphics.getWidth() / scalew / 16 do
        for by = 0, love.graphics.getHeight() / scaleh / 16 do
            r = 0
            tilemap_batch:add(bg, bx * 16, by * 16, 0, 1, 1, 8, 8)
        end
    end
    love.graphics.draw(tilemap_batch)

    --Panel
    love.graphics.setColor({ 0, 0, 0, 0.5 })
    love.graphics.rectangle("fill", 8, 8, 128, love.graphics.getHeight() / scaleh - 16)
    love.graphics.setColor({ 1, 1, 1, 1 })

    --Resolution
    if isWindowValidRatio() then
        love.graphics.setColor({ 0, 1, 0 })
    else
        love.graphics.setColor({ 1, 0, 0 })
    end
    love.graphics.print(love.graphics.getWidth() .. " * " .. love.graphics.getHeight(), 16, 16)
    love.graphics.setColor({ 1, 1, 1 })

    love.graphics.print("hotbar: " .. Player.hotbar, 16, 36)

    --Keys
    local step = 48
    for i, v in pairs(Input) do
        step = step + 20
        love.graphics.print(i .. ": " .. tostring(v), 16, step)
    end

    --Draws hotbar
    love.graphics.setColor({ 1, 1, 1, 1 })
    gui_batch:clear()
    hotbar_unselected = love.graphics.newQuad(0, 0, 18, 18, gui_textures:getDimensions())
    hotbar_selected = love.graphics.newQuad(18, 0, 18, 18, gui_textures:getDimensions())
    x = love.graphics.getWidth() * 0.5 / scalew - (18 * 9) * 0.5
    y = love.graphics.getHeight() / scaleh - 18 - 9
    for i = 0, Constants.MAX_HOTBAR_INDEX - 1 do
        tex = hotbar_unselected
        if i == Player.hotbar - 1 then
            tex = hotbar_selected
        end
        gui_batch:add(tex, x + i * 18, y)
    end
    love.graphics.draw(gui_batch)
    love.graphics.setColor({ 1, 1, 1, 1 })
end
