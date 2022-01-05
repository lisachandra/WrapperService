local strict = require(script.Parent:WaitForChild("strict"))
local t = require(script.Parent.Parent:WaitForChild("t"))
local SignalService = require(script.Parent)

local connectCheck = t.tuple(SignalService.isSignal, t.callback)

local function createId(self)
	local id = tostring(Random.new():NextInteger(0, math.huge))

	if self.__callbacks[id] then
		return createId()
	else
		return id
	end
end

local function Connect(self, callbackFunction)
	assert(connectCheck(self, callbackFunction))

	local id = createId(self)
	self.__callbacks[id] = callbackFunction

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
