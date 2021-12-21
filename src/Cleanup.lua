---@type WrapperService
local WrapperService = require(script.Parent)

local function ClearTableDescendants(tableToClear)
	for index, value in pairs(tableToClear) do
		if typeof(value) == "table" then
			table.clear(tableToClear[index])
			setmetatable(tableToClear[index], nil)
			ClearTableDescendants(tableToClear[index])
		end
	end
end

--[[
    ```lua
    <WrappedInstance>:Cleanup()
    ```
]]
---@param self WrappedInstance
---@return Instance
local function Cleanup(self)
	local instance = self.Instance
	WrapperService.__wrappedInstances[self.__id] = nil
	ClearTableDescendants(self)
	setmetatable(self, nil)
	table.clear(self)

	return instance
end

return Cleanup
