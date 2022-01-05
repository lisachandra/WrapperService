local SignalService = require(script.Parent)

local function DisconnectAll(self)
	if not SignalService.isSignal(self) then
		local message = "Expected `:` not `.` while calling function Fire"

		error(message, 2)
	end

	for _, connection in pairs(self.__connections) do
		connection:Disconnect()
	end
end

return DisconnectAll
