Inventory = class(
  function(self, player, items)
    self.player = player
    self.items = items or {
      -- hotbar
      nil, nil, nil, nil, nil, nil, nil, nil, nil,
      -- extra space
      nil, nil, nil, nil, nil, nil, nil, nil, nil,
      nil, nil, nil, nil, nil, nil, nil, nil, nil,
    }
  end
)

function Inventory.dropItem(index, x, y, vx, vy)
  -- local item = self.items[index]
  -- if item ~= nil then
  --   local clamped_vx = self.player.look_x < Constants.MAX_DROP_VY and self.player.look_x or Constants.MAX_DROP_VX
  --   local clamped_vy = self.player.look_y < Constants.MAX_DROP_VY and self.player.look_y or Constants.MAX_DROP_VY
  --   self.player.world.createDropAt(
  --     x ~= nil and x or self.player.x,
  --     y ~= nil and y or self.player.y,
  --     vx ~= nil and clamped_vx or Constants.MAX_DROP_VX,
  --     vy ~= nil and clamped_vy or Constants.MAX_DROP_VY,
  --   )
  --   self.items[index] = nil
  -- end
end

function Inventory.swapItem(index, index2)
  -- local item = self.items[index]
  -- self.items[index] = self.items[index2]
  -- self.items[index2] = item
end