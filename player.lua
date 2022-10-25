require "Constants"

Player = {
  health = Constants.MAX_HEALTH,
  hotbar = 1,
  inventory = {
    -- hotbar
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    -- inventory-only
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
    nil, nil, nil, nil, nil, nil, nil, nil, nil,
  },
  x = 0,
  y = 0,
  vx = 0,
  vy = 0,
}

function Player.MoveHotbar(by)
  Player.hotbar = Player.hotbar + (by % Constants.MAX_HOTBAR_INDEX)

  -- handle wrapping
  if Player.hotbar < 1 then
    Player.hotbar = Player.hotbar + Constants.MAX_HOTBAR_INDEX
  elseif Player.hotbar > Constants.MAX_HOTBAR_INDEX then
    Player.hotbar = Player.hotbar - Constants.MAX_HOTBAR_INDEX
  end
end

function Player.SetHotbar(index)
  Player.hotbar = index
end

function Player.FireAt(x, y)
  -- local obj = World.GetObjectAt(x, y)
  -- obj.DealDamage(Player.inventory[Player.hotbar].attack or Constants.BASE_ATTACK)
end

function Player.Use(x, y)
  -- local obj = World.GetObjectAt(x, y)
  -- obj.Use(Player.Inventory[Player.hotbar].tool or Constants.HAND_TOOL)
end

function Player.DropItem(index)
  -- local item = Player.inventory[index]
  -- if item ~= nil then
  --   World.CreateDropAt(Player.x, Player.x, item)
  --   Player.inventory[index] = nil
  -- end
end

function Player.SwapItem(index, index2)
  -- local item = Player.Inventory[index]
  -- Player.inventory[index] = Player.inventory[index2]
  -- Player.inventory[index2] = item
end

function Player.JumpImpulse()
end