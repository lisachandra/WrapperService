local messages = require(script.Parent:WaitForChild("messages"))

local function createId(self)
	local id = tostring(Random.new():NextInteger(0, math.huge))

	if self.__wrappedInstances[id] then
		return createId()
	else
		return id
	end
end

--[[
	```lua
	WrapperService:new(instanceToWrap: Instance)
	```
]]
---@param WrapperService WrapperService
---@param instanceToWrap Instance
---@return WrappedInstance
local function new(WrapperService, instanceToWrap)
	assert(typeof(instanceToWrap) == "Instance", messages.BAD_ARGUMENT:format(1, "function", "new", "Instance", typeof(instanceToWrap)))
	local id = createId(WrapperService)

	---@class WrappedInstance
	local self = {
		__id = id,

		Instance = instanceToWrap,

		Add = require(script.Parent:WaitForChild("Add")),
		Cleanup = require(script.Parent:WaitForChild("Cleanup")),
		WaitForProperty = require(script.Parent:WaitForChild("WaitForProperty")),
	}

	setmetatable(self, {
		__index = function(_self, key)
			if typeof(instanceToWrap[key]) == "function" then
				return function(_, ...)
					return instanceToWrap[key](instanceToWrap, ...)
				end
			else
				return instanceToWrap[key]
			end
		end,

		__newindex = function(_self, key, value)
			instanceToWrap[key] = value
		end,

		__tostring = function()
			return "WrappedInstance"
		end,

		__eq = function(_self, value)
			if WrapperService.isWrapped(value) then
				if value.__id == self.__id then
					return true
				else
					return false
				end
			else
				return value == instanceToWrap
			end
		end,
	})

	WrapperService.__wrappedInstances[id] = self
	return self
end

return new
