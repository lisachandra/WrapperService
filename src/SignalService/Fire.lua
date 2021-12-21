--[[

]]
---@param self Signal
local function Fire(self, ...)
	for _, callback in ipairs(self.__callbacks) do
		coroutine.wrap(callback)(...)
	end

	for index, waiterThread in ipairs(self.__waiters) do
		self.__waiters[index] = nil
		coroutine.resume(waiterThread, ...)
	end
end

return Fire
