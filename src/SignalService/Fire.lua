local function Fire(self, ...)
	for _, callback in pairs(self.__callbacks) do
		coroutine.wrap(callback)(...)
	end

	for index, waiterThread in pairs(self.__waiters) do
		self.__waiters[index] = nil
		coroutine.resume(waiterThread, ...)
	end
end

return Fire
