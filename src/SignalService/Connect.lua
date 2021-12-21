local strict = require(script.Parent.strict)

--[[

]]
---@param self Signal
---@param callbackFunction fun()
---@return Connection
local function Connect(self, callbackFunction)
	local id = tostring(Random.new():NextInteger(1, math.huge))
	self.__callbacks[id] = callbackFunction

	--[[
        
    ]]
	---@class Connection
	local Connection = {
		__signal = self,
		__id = id,

		Connected = true,

		Disconnect = require(script.Parent:WaitForChild("Disconnect")),
	}

	Connection = strict(Connection, "Connection")
	self.__connections[id] = Connection
	return Connection
end

return Connect
