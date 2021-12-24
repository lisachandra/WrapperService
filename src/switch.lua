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
local function switch(variable, conditions)
	local values = conditions[variable] and table.pack(conditions[variable]()) or conditions["default"] and table.pack(conditions["default"]()) or { nil }

	return table.unpack(values)
end

return switch
