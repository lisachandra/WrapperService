local SignalService = require(script.Parent.Parent:WaitForChild("SignalService"))
local WrapperService = require(script.Parent)

local t = require(script.Parent.Parent:WaitForChild("t"))

local VALUE_TYPES = {
	Property = "any",
	Method = "callback",
	Event = "callback"
}

local addCheck = t.tuple(
	WrapperService.isWrapped,
	t.map(t.string, function(propertyContentsToCheck)
		for valueType: string in pairs(propertyContentsToCheck) do
			if VALUE_TYPES[valueType] then			
				return t.interface({
					[valueType] = t[VALUE_TYPES[valueType]]
				})(propertyContentsToCheck)
			else			
				return false, string.format("(field ValueType expected, got %s) \nValid ValueTypes: Property, Method and Event", valueType)
			end
		end 
	end)
)

local function Add(self, properties)
	assert(addCheck(self, properties))

	for name, propertyContents in pairs(properties) do
		for valueType, value in pairs(propertyContents) do
			local values = {
				Property = function()
					return value
				end,
		
				Event = function()
					local Signal = SignalService.new()
					coroutine.wrap(value)(Signal)
		
					return Signal
				end,
		
				Method = function()
					return function(_self, ...)
						if _self ~= self then
							warn("Expected `:` not `.` while calling function " .. name)
						else
							return value(_self, ...)
						end
					end
				end
			}

			local propertyValue = values[valueType]
			rawset(self, tostring(name), propertyValue())
		end
	end
end

return Add
