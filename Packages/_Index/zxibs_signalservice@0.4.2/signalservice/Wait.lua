local SignalService = require(script.Parent)

local function Wait(self)
	if not SignalService.isSignal(self) then
		local message = "Expected `:` not `.` while calling function Fire"

		error(message, 2)
	end

	table.insert(self.__waiters, coroutine.running())
	return coroutine.yield()
end

return Wait
