--[[

]]
---@param self Signal
local function Wait(self)
	table.insert(self.__waiters, coroutine.running())
	return coroutine.yield()
end

return Wait
