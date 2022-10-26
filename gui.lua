require "renderutil"

function setupGuiScale()
    love.graphics.push()
    scalew = love.graphics.getWidth() / 640
    scaleh = love.graphics.getHeight() / 360
    love.graphics.scale(scalew, scaleh)
    window_width = love.graphics.getWidth() / scalew
    window_height = love.graphics.getHeight() / scaleh
end

function drawGui()
    drawHotbar()
    drawDebug()
    love.graphics.pop()
    drawCursor()
end

function drawCursor()
    gui_batch:clear()
    local cursor = love.graphics.newQuad(16, 48, 16, 16, gui_textures:getDimensions())
    gui_batch:add(cursor, love.mouse.getX() - 1, love.mouse.getY() - 1)
    love.graphics.draw(gui_batch)
    if Input["dash"] or true then
        printBorder(camera:getX() + love.mouse.getX() .. ":" .. camera:getY() + love.mouse.getY(), love.mouse.getX(), love.mouse.getY()  + 16)
    end
end

function drawBackground()
    tilemap_batch:clear()
    love.graphics.setColor({ 1, 1, 1, 0.5 })
    local bg = love.graphics.newQuad(0, 32, 16, 16, tilemap_textures:getDimensions())
    for bx = 0, window_width / 16 do
        for by = 0, window_height / 16 do
            tilemap_batch:add(bg, bx * 16, by * 16, 0, 1, 1, 8, 8)
        end
    end
    love.graphics.draw(tilemap_batch)
    love.graphics.setColor({ 1, 1, 1, 1 })
end

function drawDebug()
    love.graphics.setColor({ 0, 0, 0, 0.5 })
    love.graphics.rectangle("fill", 8, 8, 128, window_height - 16)
    love.graphics.setColor({ 1, 1, 1, 1 })
    if isWindowValidRatio() then
        printBorder(love.graphics.getWidth() .. " * " .. love.graphics.getHeight(), 16, 16, { 0, 1, 0 })
    else
        printBorder(love.graphics.getWidth() .. " * " .. love.graphics.getHeight(), 16, 16, { 1, 0, 0 })
    end
    printBorder("hotbar: " .. player.hotbar_index, 16, 36)
    local font = love.graphics.getFont()
    --printBorder("xD", window_width / 2 - font:getWidth("xD") / 2, window_height / 2 - font:getHeight() / 2, { 1.0 + math.sin(t) / 2.0, math.abs(math.cos(t)), math.abs(math.sin(t)) })
    local step = 48
    for i, v in pairs(Input) do
        step = step + 20
        printBorder(i .. ": " .. tostring(v), 16, step)
    end

end

function drawHotbar()
    love.graphics.setColor({ 1, 1, 1, 0.9 })
    gui_batch:clear()
    local hotbar_unselected = love.graphics.newQuad(0, 0, 18, 18, gui_textures:getDimensions())
    local hotbar_selected = love.graphics.newQuad(18, 0, 18, 18, gui_textures:getDimensions())
    local x = window_width * 0.5 - (18 * 9) * 0.5
    local y = window_height - 18 - 9
    for i = 0, Constants.MAX_HOTBAR_INDEX - 1 do
        local tex = hotbar_unselected
        if i == player.hotbar_index - 1 then
            tex = hotbar_selected
        end
        gui_batch:add(tex, x + i * 18, y)
    end
    love.graphics.draw(gui_batch)
    love.graphics.setColor({ 1, 1, 1, 1 })
end