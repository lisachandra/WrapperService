local messages = require(script.Parent:WaitForChild("messages"))
local switch = require(script.Parent:WaitForChild("switch"))

---@type SignalService
local SignalService = require(script.Parent:WaitForChild("SignalService"))

--[[
    ValueTypes:  
    Event  
    Method  
    Property  

    ```lua
    <WrappedInstance>:Add(properties: {[string]: {[ValueType]: any}})
    ```
]]
---@param properties table
---@param self WrappedInstance
local function Add(self, properties)
	assert(typeof(properties) == "table", messages.BAD_ARGUMENT:format(1, "function", "Add", "table", typeof(properties)))

	for name, propertyContents in pairs(properties) do
		for valueType, value in pairs(propertyContents) do
			rawset(
				self,
				tostring(name),
				switch(valueType, {
					["Property"] = function()
						return value
					end,

					["Event"] = function()
						local Signal = SignalService.new()
						coroutine.wrap(value)(Signal)

						return Signal
					end,

					["Method"] = function()
						return function(__self, ...)
							if __self ~= self then
								warn(messages.SELF_EXPECTED:format(name))
							else
								return value(...)
							end
						end
					end,

					["default"] = function()
						warn(messages.BAD_VALUE_TYPE:format("properties", "Valid value type (Property | Event | Method)", valueType))
						return nil
					end,
				})
			)
		end
	end
end

return Add
