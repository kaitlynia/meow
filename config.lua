json = require "json"

function loadClientConfig(location)
	local config_file = io.open(location)
	local config_str = config_file:read("*a")
	config_file:close()
	return json.decode(config_str)
end
