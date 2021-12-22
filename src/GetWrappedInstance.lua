local messages = require(script.Parent:WaitForChild("messages"))

local function GetWrappedInstance(self, instanceToGet)
	assert(typeof(instanceToGet) == "Instance", messages.BAD_ARGUMENT:format(1, "function", "GetWrappedInstance", "Instance", typeof(instanceToGet)))

	for _, WrappedInstance in pairs(self.__wrappedInstances) do
		if WrappedInstance.Instance == instanceToGet then
			return WrappedInstance
		end
	end

	return nil
end

return GetWrappedInstance
