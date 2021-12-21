task.wait() -- this is for avoiding recursion

local messages = require(script.Parent:WaitForChild("messages"))

--[[
	```lua
	WrapperService:GetWrappedInstance(instanceToGet: Instance)
	```
]]
---@param instanceToGet Instance
---@param self WrapperService
---@return WrappedInstance?
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
