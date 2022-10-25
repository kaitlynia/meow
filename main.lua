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

function printBorder(text, x, y, forecolor, backcolor)
    if forecolor == nil then
        forecolor = { 1, 1, 1 }
    end
    if backcolor == nil then
        backcolor = { 0, 0, 0 }
    end
    love.graphics.setColor(backcolor)
    love.graphics.print(text, x - 1, y)
    love.graphics.print(text, x, y - 1)
    love.graphics.print(text, x + 1, y)
    love.graphics.print(text, x, y + 1)
    love.graphics.setColor(forecolor)
    love.graphics.print(text, x, y)
    love.graphics.setColor({ 1, 1, 1 })
end

function love.draw()

    local scalew = love.graphics.getWidth() / 640
    local scaleh = love.graphics.getHeight() / 360
    love.graphics.scale(scalew, scaleh)
    local window_width = love.graphics.getWidth() / scalew
    local window_height = love.graphics.getHeight() / scaleh


    --Draws background
    tilemap_batch:clear()
    local bg = love.graphics.newQuad(0, 32, 16, 16, tilemap_textures:getDimensions())
    for bx = 0, window_width / 16 do
        for by = 0, window_height / 16 do
            tilemap_batch:add(bg, bx * 16, by * 16, 0, 1, 1, 8, 8)
        end
    end
    love.graphics.draw(tilemap_batch)

    --Panel
    love.graphics.setColor({ 0, 0, 0, 0.5 })
    love.graphics.rectangle("fill", 8, 8, 128, window_height - 16)
    love.graphics.setColor({ 1, 1, 1, 1 })

    if isWindowValidRatio() then
        printBorder(love.graphics.getWidth() .. " * " .. love.graphics.getHeight(), 16, 16, { 0, 1, 0 })
    else
        printBorder(love.graphics.getWidth() .. " * " .. love.graphics.getHeight(), 16, 16, { 1, 0, 0 })
    end

    printBorder("hotbar: " .. Player.hotbar, 16, 36)

    local font = love.graphics.getFont()
    printBorder("xD", window_width / 2 - font:getWidth("xD") / 2, window_height / 2 - font:getHeight() / 2, { 1.0 + math.sin(t) / 2.0, math.abs(math.cos(t)), math.abs(math.sin(t)) })

    local step = 48
    for i, v in pairs(Input) do
        step = step + 20
        printBorder(i .. ": " .. tostring(v), 16, step)
    end

    --Draws hotbar
    love.graphics.setColor({ 1, 1, 1, 0.9 })
    gui_batch:clear()
    local hotbar_unselected = love.graphics.newQuad(0, 0, 18, 18, gui_textures:getDimensions())
    local hotbar_selected = love.graphics.newQuad(18, 0, 18, 18, gui_textures:getDimensions())
    local x = window_width * 0.5 - (18 * 9) * 0.5
    local y = window_height - 18 - 9
    for i = 0, Constants.MAX_HOTBAR_INDEX - 1 do
        local tex = hotbar_unselected
        if i == Player.hotbar - 1 then
            tex = hotbar_selected
        end
        gui_batch:add(tex, x + i * 18, y)
    end
    love.graphics.draw(gui_batch)
    love.graphics.setColor({ 1, 1, 1, 1 })
end
