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

function drawPanel(x, y, w, h, ti)
    gui_batch:clear()
    local tx = 5 * ti
    local ty = 32
    local panel_tl = love.graphics.newQuad(tx, ty, 2, 2, gui_textures:getDimensions())
    local panel_tm = love.graphics.newQuad(tx + 2, ty, 1, 2, gui_textures:getDimensions())
    local panel_tr = love.graphics.newQuad(tx + 3, ty, 2, 2, gui_textures:getDimensions())
    local panel_ml = love.graphics.newQuad(tx, ty + 2, 2, 1, gui_textures:getDimensions())
    local panel_fill = love.graphics.newQuad(tx + 2, ty + 2, 1, 1, gui_textures:getDimensions())
    local panel_mr = love.graphics.newQuad(tx + 3, ty + 2, 2, 1, gui_textures:getDimensions())
    local panel_bl = love.graphics.newQuad(tx, ty + 3, 2, 2, gui_textures:getDimensions())
    local panel_bm = love.graphics.newQuad(tx + 2, ty + 3, 1, 2, gui_textures:getDimensions())
    local panel_br = love.graphics.newQuad(tx + 3, ty + 3, 2, 2, gui_textures:getDimensions())
    for ix = 1, w - 1 do
        for iy = 1, h - 1 do
            gui_batch:add(panel_fill, x + ix, y + iy)
        end
    end
    for ix = 1, w - 1 do
        gui_batch:add(panel_tm, x + ix, y)
        gui_batch:add(panel_bm, x + ix, y + h)
    end
    for iy = 1, h - 1 do
        gui_batch:add(panel_ml, x, y + iy)
        gui_batch:add(panel_mr, x + w, y + iy)
    end
    gui_batch:add(panel_tl, x, y)
    gui_batch:add(panel_tr, x + w, y)
    gui_batch:add(panel_bl, x, y + h)
    gui_batch:add(panel_br, x + w, y + h)

    love.graphics.draw(gui_batch)
end

function isOnScreen(oX, oY, oW, oH, camera)
    local s = worldPosToScreenPos(oX, oY, camera)
    local e = worldPosToScreenPos(oW, oH, camera)
    fx = false
    fy = false

    for x = s.x, e.x do
        if x >= 0 and x <= love.graphics.getWidth() then
            fx = true
            break
        end
    end

    for y = s.y, e.y do
        if y >= 0 and y <= love.graphics.getHeight() then
            fy = true
            break
        end
    end

    if fx and fy then
        return true
    end

    return false
end

function isWindowValidRatio()
    return love.graphics.getHeight() / love.graphics.getWidth() == PixelResY / PixelResX
end

function screenPosToWorldPos(x, y, camera)
    local worldPos = {}
    worldPos.x = camera:getX() + ((x / PixelScaleX - ScaledWindowWidth / 2) * camera:getZoom())
    worldPos.y = camera:getY() + ((y / PixelScaleY - ScaledWindowHeight / 2) * camera:getZoom())
    return worldPos
end

function worldPosToScreenPos(x, y, camera)
    local screenPos = {}
    screenPos.x = (((x - camera:getX()) / camera:getZoom()) + ScaledWindowWidth / 2) * PixelScaleX
    screenPos.y = (((y - camera:getY()) / camera:getZoom()) + ScaledWindowHeight / 2) * PixelScaleY
    return screenPos
end