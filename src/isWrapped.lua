--[[
    ```lua
	WrapperService.isWrapped(wrappedInstanceObject: WrappedInstance)
	```
]]
---@param wrappedInstanceObject WrappedInstance
---@return boolean
local function isWrapped(wrappedInstanceObject)
	if tostring(wrappedInstanceObject) == "WrappedInstance" and typeof(wrappedInstanceObject) == "table" then
		return true
	else
		return false
	end
end

return isWrapped
