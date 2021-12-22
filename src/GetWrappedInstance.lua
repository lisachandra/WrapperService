local t = require(script.Parent:WaitForChild("t"))

local getWrappedInstanceCheck = t.tuple(function(selfToCheck)
	if tostring(selfToCheck) == "WrapperService" and typeof(selfToCheck) == "table" then
		return true
	else
		return false, "expected WrapperService, got " .. typeof(selfToCheck)
	end
end, t.Instance)

local function GetWrappedInstance(self, instanceToGet)
	assert(getWrappedInstanceCheck(self, instanceToGet))

	for _, WrappedInstance in pairs(self.__wrappedInstances) do
		if WrappedInstance.Instance == instanceToGet then
			return WrappedInstance
		end
	end

	return nil
end

return GetWrappedInstance
