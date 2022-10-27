require "rendering.renderutil"
require "input.input"

ShowDebug = true

function drawGui()
    drawHotbar()
    if ShowDebug then
        drawDebug()
    end
    love.graphics.pop()
    drawCursor()
end

function drawCursor()
    gui_batch:clear()
    gui_batch:add(QuadCursor, MouseX - 1, MouseY - 1)
    love.graphics.draw(gui_batch)
    if ShowDebug then
        local worldpos = screenPosToWorldPos(MouseX, MouseY, camera)
        printBorder("pos:" .. math.floor(worldpos.x) .. ":" .. math.floor(worldpos.y), MouseX, MouseY + 16)
        printBorder("cam:" .. camera:getX() .. ":" .. camera:getY(), MouseX, MouseY + 32)
    end
end

function drawBackground()
    tilemap_batch:clear()
    love.graphics.setColor({ 1, 1, 1, 0.5 })
    for bx = -16, ScaledWindowWidth / 16 + 16 do
        for by = -16, ScaledWindowHeight / 16 + 16 do
            tilemap_batch:add(QuadBackgroundTile, bx * 16 - camera:getX() % 16, by * 16 - camera:getY() % 16, 0, 1, 1, 8, 8)
        end
    end
    love.graphics.draw(tilemap_batch)
    love.graphics.setColor({ 1, 1, 1, 1 })
end

function drawDebug()
    love.graphics.setColor({ 0, 0, 0, 0.5 })
    love.graphics.rectangle("fill", 8, 8, 128, ScaledWindowHeight - 16)
    love.graphics.setColor({ 1, 1, 1, 1 })
    if isWindowValidRatio() then
        printBorder(love.graphics.getWidth() .. " * " .. love.graphics.getHeight(), 16, 16, { 0, 1, 0 })
    else
        printBorder(love.graphics.getWidth() .. " * " .. love.graphics.getHeight(), 16, 16, { 1, 0, 0 })
    end
    printBorder("drawcalls: " .. love.graphics.getStats().drawcalls, 16, 16 * 2)
    printBorder("t-mem: " .. string.format("%.2f MB", love.graphics.getStats().texturememory / 1024 / 1024), 16, 16 * 3)
    printBorder("hotbar: " .. player.hotbar_index, 16, 16 * 4)
    --local font = love.graphics.getFont()
    --printBorder("xD", window_width / 2 - font:getWidth("xD") / 2, window_height / 2 - font:getHeight() / 2, { 1.0 + math.sin(t) / 2.0, math.abs(math.cos(t)), math.abs(math.sin(t)) })
    local step = 48
    for i, v in pairs(Input) do
        step = step + 20
        printBorder(string.format("%-10s-%8s", i, tostring(v)), 16, step + 42)
    end

end

function drawHotbar()
    love.graphics.setColor({ 1, 1, 1, 0.9 })
    gui_batch:clear()
    local x = ScaledWindowWidth * 0.5 - (18 * 9) * 0.5
    local y = ScaledWindowHeight - 18 - 9
    for i = 0, Constants.MAX_HOTBAR_INDEX - 1 do
        local tex = QuadHotbarUnselected
        if i == player.hotbar_index - 1 then
            tex = QuadHotbarSelected
        end
        gui_batch:add(tex, x + i * 18, y)
    end
    love.graphics.draw(gui_batch)
    love.graphics.setColor({ 1, 1, 1, 1 })
end