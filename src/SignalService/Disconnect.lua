local SignalService = require(script.Parent)

local function Disconnect(self)
	if not SignalService.isSignal(self) then
		local message = "Expected `:` not `.` while calling function Fire"

		error(message, 2)
	end

	self.__signal.__connections[self.__id] = nil
	self.__signal.__callbacks[self.__id] = nil
	self.Connected = false
end

return Disconnect
