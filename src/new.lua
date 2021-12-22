local messages = require(script.Parent:WaitForChild("messages"))

local function createId(self)
	local id = tostring(Random.new():NextInteger(0, math.huge))

	if self.__wrappedInstances[id] then
		return createId()
	else
		return id
	end
end

local function new(self, instanceToWrap)
	assert(typeof(instanceToWrap) == "Instance", messages.BAD_ARGUMENT:format(1, "function", "new", "Instance", typeof(instanceToWrap)))
	local id = createId(self)

	local WrappedInstance = {
		__id = id,

		Instance = instanceToWrap,

		Add = require(script.Parent:WaitForChild("Add")),
		Cleanup = require(script.Parent:WaitForChild("Cleanup")),
		WaitForProperty = require(script.Parent:WaitForChild("WaitForProperty")),
	}

	setmetatable(WrappedInstance, {
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
			if self.isWrapped(value) then
				if value.__id == WrappedInstance.__id then
					return true
				else
					return false
				end
			else
				return value == instanceToWrap
			end
		end,
	})

	self.__wrappedInstances[id] = WrappedInstance
	return WrappedInstance
end

return new
