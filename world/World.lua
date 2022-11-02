-- TODO: make this stub more meaningful

World = class(
		function(self, data)
			self.data = data or {}
		end
)

function World.net_str(self)
	-- TODO: impl real data for World entities
	return tostring(self.data)
end

function World:random()
end

function World:from_config(path)
end