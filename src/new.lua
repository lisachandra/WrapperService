local t = require(script.Parent.Parent:WaitForChild("t"))

local newCheck = t.tuple(function(selfToCheck)
	if tostring(selfToCheck) == "WrapperService" and typeof(selfToCheck) == "table" then
		return true
	else
		return false, "expected WrapperService, got " .. typeof(selfToCheck)
	end
end, t.Instance)

local function createId(self)
	math.randomseed(#self.__wrappedInstances)

    return math.random(math.huge, 1)
end

local function new(self, instanceToWrap)
	assert(newCheck(self, instanceToWrap))
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
			if instanceToWrap[key] == nil then
				local message = ("%q (%s) is not a valid member of %s"):format(tostring(key), typeof(key), instanceToWrap.Name)
				error(message, 2)
			end

			if typeof(instanceToWrap[key]) == "function" then
				return function(_, ...)
					return instanceToWrap[key](instanceToWrap, ...)
				end
			else
				return instanceToWrap[key]
			end
		end,

		__newindex = function(_self, key, value)
			if instanceToWrap[key] == nil then
				local message = ("%q (%s) is not a valid member of %s"):format(tostring(key), typeof(key), instanceToWrap.Name)
				error(message, 2)
			end

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
