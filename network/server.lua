-- TODO: impl

-- example from https://leafo.net/lua-enet/#tutorial
require "enet"

require "../entity/player/Player"
require "../world/World"

local host = enet.host_create("localhost:6789")
local world = World:from_config("file://") --TODO: specify config location, fallback to World:random()
local players = {}

while true do
  local event = host:service(100)
  if event then
    if event.type == "connect" then
      -- TODO: impl net_str methods for all entities the server handles.
      --   we can extend this to include players, but we should also limit our use of the monolithic net_str
      --   for other, smaller payloads (for updating things like player position, stats, state, connections,
      --   world data like tile updates, tile data updates, auxillary updates like finishing world quests)

      -- TODO: figure out how to retrieve user data from simple auth like IP/name and pass to constructor
      local player = Player(world)
      host:broadcast(player:net_str())
      table.insert(players, player)
    elseif event.type == "receive" then
      print("Got message: ", event.data, event.peer)
      event.peer:send(event.data)
    end
  end
end