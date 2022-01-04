local SignalService = require(script.Parent)
local t = require(script.Parent.Parent:WaitForChild("t"))

local onDispatchCheck = t.tuple(SignalService.isSignal, t.intersection(t.table, t.map(t.string, t.callback)))

local function onDispatch(self, dispatchHandlers)
	assert(onDispatchCheck(self, dispatchHandlers))

	rawset(
		self,
		"__dispatchHandler",
		setmetatable(dispatchHandlers, {
			__call = function(_self, action)
				local actionType = action.type
				action.type = nil

				return self.__dispatchHandler[actionType](action)
			end,
		})
	)
end

return onDispatch
