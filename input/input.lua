require "constants"
require "entity.player.player"

Input = {
    up = false,
    down = false,
    left = false,
    right = false,
    dash = false,
    jump = false,
    fire = false,
    use = false,
    inventory = false,
    drop = false,
    chat = false,
    menu = false,
}

MouseWheelMovement = 0
MouseX = 0
MouseY = 0

-- TODO: impl user-configurable binds
Binds = {
    w = "up",
    s = "down",
    a = "left",
    d = "right",
    lshift = "dash",
    space = "jump",
    mouse1 = "fire",
    mouse2 = "use",
    e = "inventory",
    q = "drop",
    ["return"] = "chat",
    escape = "menu",
}

function Action(key, state)
    local this = Binds[key]
    if this ~= nil then
        Input[this] = state
    end
end

function love.keypressed(key, scancode, isrepeat)
    if not isrepeat then
        local index = tonumber(key)
        if index ~= nil and index > 0 and index <= Constants.MAX_HOTBAR_INDEX then
            player:setHotbarIndex(index)
        else
            Action(key, true)
        end

        --moved here so its not called every frame
        --Toggle fullscreen
        if Input["menu"] and Input["dash"] then
            love.window.setFullscreen(not love.window.getFullscreen())
            updatePixelScaling()
        elseif Input["menu"] then
            --Toggle debug
            ShowDebug = not ShowDebug
        end
    end
end

function love.keyreleased(key)
    Action(key, false)
end

function love.mousepressed(x, y, button, istouch, presses)
    Action("mouse" .. button, true)
end

function love.mousereleased(x, y, button, istouch, presses)
    Action("mouse" .. button, false)
end

function love.mousemoved(x, y, dx, dy, istouch)
    MouseX = x
    MouseY = y
end

function love.wheelmoved(x, y)
    -- hotbar scrolling is handled in love.update
    MouseWheelMovement = MouseWheelMovement + y
end