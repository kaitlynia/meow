require "constants"
require "player"

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
      Player.SetHotbar(index)
    else
      Action(key, true)
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

function love.mousemoved()
  -- we will likely only explicitly query the mouse position during mouse actions
  -- and when updating the cursor/reticle, so this function is left unimplemented
end

function love.wheelmoved(x, y)
  -- hotbar scrolling is handled in love.update
  MouseWheelMovement = MouseWheelMovement + y
end