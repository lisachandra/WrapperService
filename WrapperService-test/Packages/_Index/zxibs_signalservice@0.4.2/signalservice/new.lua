local strict = require(script.Parent:WaitForChild("strict"))

local function new()
	local Signal = {
		__connections = {},
		__callbacks = {},
		__waiters = {},

		Fire = require(script.Parent:WaitForChild("Fire")),
		Wait = require(script.Parent:WaitForChild("Wait")),
		Connect = require(script.Parent:WaitForChild("Connect")),
		Destroy = require(script.Parent:WaitForChild("Destroy")),
		Dispatch = require(script.Parent:WaitForChild("Dispatch")),
		onDispatch = require(script.Parent:WaitForChild("onDispatch")),
		DisconnectAll = require(script.Parent:WaitForChild("DisconnectAll")),
	}

	return strict(Signal, "Signal")
end

return new
