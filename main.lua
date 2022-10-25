require "constants"
require "input"

function love.load()
  love.window.setFullscreen(true)
end

function love.update(dt)
  if MouseWheelMovement ~= 0 then
    Player.MoveHotbar(MouseWheelMovement)
    MouseWheelMovement = 0
  end
end

function love.draw()
  love.graphics.print(Player.hotbar, 16, 16)
  local step = 48
  for i, v in pairs(Input) do
    step = step + 24
    love.graphics.print(i .. ": " .. tostring(v), 16, step)
  end
end