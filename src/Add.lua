local WrapperService = require(script.Parent)
local switch = require(script.Parent:WaitForChild("switch"))
local t = require(script.Parent:WaitForChild("t"))

local addCheck = t.tuple(
	WrapperService.isWrapped,
	t.map(t.string, function(propertyContentsToCheck)
		local key
		for valueType in pairs(propertyContentsToCheck) do
			key = valueType
			break
		end

		return switch(key, {
			["Property"] = function()
				return t.strictInterface({
					[key] = t.any,
				})(propertyContentsToCheck)
			end,

			["Method"] = function()
				return t.strictInterface({
					[key] = t.callback,
				})(propertyContentsToCheck)
			end,

			["Event"] = function()
				return t.strictInterface({
					[key] = t.callback,
				})(propertyContentsToCheck)
			end,

			["default"] = function()
				return false, "Bad argument #1 while calling function Add (key Event | Method | Property expected, got " .. tostring(key) .. ")"
			end,
		})
	end)
)

---@type SignalService
local SignalService = require(script.Parent:WaitForChild("SignalService"))

local function Add(self, properties)
	assert(addCheck(self, properties))

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
								warn("Expected `:` not `.` while calling function " .. name)
							else
								return value(...)
							end
						end
					end,
				})
			)
		end
	end
end

return Add
