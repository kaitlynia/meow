require "constants"
require "input.input"
require "rendering.object.camera"
require "rendering.object.tile"
require "entity.player.player"
require "world.World"
require "rendering.renderer"

world = World()
player = Player(world)
PhysicalWorld = love.physics.newWorld(0, 9.81*16, true)

examplep = Panel(-32, -100, 64, 64, 3)
debugtile = Tile(0, 64, 9)

function love.load()
    --Physics
    love.physics.setMeter(16)

    setupRendering()
    --addToRenderer(examplep)
    addToRenderer(debugtile)
    addToRenderer(player)
end

local t = 0
function love.update(dt)
    PhysicalWorld:update(dt)

    if MouseWheelMovement ~= 0 then
        player:moveHotbarIndex(-MouseWheelMovement)
        MouseWheelMovement = 0
    end

    --Camera movement
    local x = 0
    local y = 0
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
    x = x * 0.25
    y = y * 0.25
    player:move(x, y)
    camera:setPos(player:getPos().x, player:getPos().y)
    --camera:move(x, y)
    camera:setZoom(s)

    t = t + dt
    ShaderRainbow:send("time", t)
end
