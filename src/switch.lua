--[[
    ```lua
    local case = 1
    local month = switch(case, {
        ["1"] = function()
            return "January"
        end,

        ["default"] = function()
            return "This will return if the case doesn't match any of the keys in this table"
        end
    })

    print(month) -- January
    ```
]]
---@param variable string | number
---@param conditions table
---@return any
local function switch(variable, conditions)
	local trace = debug.traceback(coroutine.running(), "", 1)
	local values = conditions[tostring(variable)] and table.pack(conditions[tostring(variable)]()) or conditions["default"] and table.pack(conditions["default"]()) or nil

	if not values then
		local message = string.format("Values are nil or false, variable might be invalid \nTraceback: " .. trace .. "\nCase: " .. tostring(variable), "%q")

		warn(message)
	end

	return table.unpack(values)
end

return switch
