local strict = require(script.Parent.strict)

local function new()
	local Signal = {
		__connections = {},
		__callbacks = {},
		__waiters = {},

		Fire = require(script.Parent:WaitForChild("Fire")),
		Wait = require(script.Parent:WaitForChild("Wait")),
		Connect = require(script.Parent:WaitForChild("Connect")),
		Destroy = require(script.Parent:WaitForChild("Destroy")),
		DisconnectAll = require(script.Parent:WaitForChild("DisconnectAll")),
	}

	return strict(Signal, "Signal")
end

return new
