require "constants"
require "client.input"
require "client.camera"
require "object.Tile"
require "object.Player"
require "world.World"
require "client.renderer"
socket = require "socket"
json = require "json"

local config_file = io.open("config.json")
local config_str = config_file:read("*a")
config_file:close()
local config = json.decode(config_str)

local ip = config.server
local udp = socket.udp()
udp:settimeout(0)
udp:setpeername(ip, 5678)
udp:send(json.encode({
	type = "player_auth",
	name = config.name
}))

player = nil
world = nil

PhysicalWorld = love.physics.newWorld(0, 9.81 * 32, true)

--examplep = Panel(-32, -100, 64, 64, 3)

other_players = {}

player = Player(world, PhysicalWorld, config.name)
--heavy = Tile(PhysicalWorld, 0, 0, 25)
bouncy = Tile(PhysicalWorld, 64, -64, 26)

function love.load()
	--Physics
	love.physics.setMeter(29)

	setupRendering()
	--addToRenderer(examplep)
	for i = -12, 12 do
		addToRenderer(Tile(PhysicalWorld, i * 16, 64, 24))
	end
	--addToRenderer(heavy)
	addToRenderer(bouncy)
	addToRenderer(player)
end

local client_events = {
	sync_playerlist = function(event)
		print(string.format("[%s]: Syncing player list...", os.date("%X")))
		for _, v in pairs(other_players) do
			removeFromRenderer(v)
		end

		other_players = {}
		for _, v in pairs(event.players) do
			if v.name ~= config.name then
				table.insert(other_players, Player(world, PhysicalWorld, v.name, v.x, v.y))
			end
		end

		for _, v in pairs(other_players) do
			addToRenderer(v)
		end

	end,
	player_patch = function(event)
		player.patch(event.data)
	end
}

local t = 0
function love.update(dt)

	if Intent then
		udp:send(json.encode({
			type = "intent",
			data = Input
		}))
		print(string.format("[%s]: Sending intent to %s", os.date("%X"), ip .. ":5678"))
		Intent = false
	end

	local received, msg = udp:receive()
	if received then
		local json_data = json.decode(received)
		local event_handler = client_events[json_data.type]
		if event_handler then
			event_handler(json_data)
		end
	elseif msg ~= "timeout" then
		error("Network error: " .. tostring(msg))
	end

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
		--y = -1
	elseif Input["down"] then
		--y = 1
	end
	if Input["inventory"] then
		s = s * 0.99
	elseif Input["drop"] then
		s = s * 1.01
	end

	player.physics.body:applyForce(50 * x, 200 * y)
	x = x * 0.25
	y = y * 0.25
	--player:move(x, y)
	camera:setPos(player:getX() + 8, player:getY() + 8)
	--camera:move(x, y)
	camera:setZoom(s)

	t = t + dt
	ShaderRainbow:send("time", t)
end

function love.quit()
	udp:send(json.encode({
		type = "player_disconnect",
		name = config.name
	}))
	udp:close()
	--server:disconnect()
	--host:flush()
end