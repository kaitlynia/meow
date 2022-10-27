require "constants"
require "input.input"
require "rendering.camera"
require "entity.player.player"
require "world.World"
require "rendering.renderer"

world = World()
player = Player(world)

function love.load()
    setupRendering()
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
    ShaderRainbow:send("time", t)
end
