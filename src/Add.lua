local WrapperService = require(script.Parent)
local switch = require(script.Parent:WaitForChild("switch"))
local t = require(script.Parent:WaitForChild("t"))

local addCheck = t.tuple(WrapperService.isWrapped, function(propertiesToCheck)
	if not t.table(propertiesToCheck) then
		return t.table(propertiesToCheck)
	end

	for _, propertyContents in pairs(propertiesToCheck) do
		if not t.table(propertyContents) then
			return t.table(propertyContents)
		end

		for valueType, value in pairs(propertyContents) do
			local success, errorMsg = switch(valueType, {
				["Event"] = function()
					if not t.callback(value) then
						return t.callback(value)
					end

					return true
				end,

				["Method"] = function()
					if not t.callback(value) then
						return t.callback(value)
					end

					return true
				end,

				["Property"] = function()
					return true
				end,

				["default"] = function()
					return false, "Bad argument #1 while calling function Add (key Event | Method | Property expected, got " .. tostring(valueType) .. ")"
				end,
			})

			if not success and errorMsg then
				return false, errorMsg
			end
		end
	end

	return true
end)

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
