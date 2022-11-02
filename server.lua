require "object.Player"
json = require "json"
socket = require "socket"

local udp = socket.udp()
udp:settimeout(0)
udp:setsockname("192.168.0.32", 5678)

local running = true

players = {}
clients = {}

function log(text)
	print(string.format("[%s]: " .. text, os.date("%X")))
end

function showPlayers()
	log("Players: {")
	for k, v in pairs(players) do
		log(string.format("   %s: %s", k, v.name))
	end
	log("}")
end

function sendPlayerPos()

end

local server_events = {
	player_auth = function(event, client_ip, client_port)
		--udp:sendto("yes", client_ip, client_port)
		local has_player = false
		for k, v in pairs(players) do
			if v == event.name then
				has_player = true
			end
		end
		if not has_player then
			table.insert(players, {
				name = event.name,
				x = 0,
				y = 0,
			})
			table.insert(clients, {
				name = event.name,
				ip = client_ip,
				port = client_port
			})
		end
		showPlayers()
		for k, v in pairs(clients) do
			udp:sendto(json.encode({
				type = "sync_playerlist",
				players = players
			}), v.client_ip, v.client_port)
		end
	end,
	player_disconnect = function(event, client_ip, client_port)
		for k, v in pairs(players) do
			if v.name == event.name then
				table.remove(players, k)
				break
			end
		end
		showPlayers()
	end
}

log("Starting Server...")
while running do
	local data, client_ip, client_port = udp:receivefrom()
	if data then
		local json_data = json.decode(data)
		local event_handler = server_events[json_data.type]
		if event_handler then
			log(string.format("Received %s from %s", json_data.type, client_ip .. ":" .. client_port))
			event_handler(json_data, client_ip, client_port)
		end
	elseif client_ip ~= 'timeout' then
		error("Unknown network error: " .. tostring(msg))
	end

	socket.sleep(0.01)
end
print("Server Stopped.")
