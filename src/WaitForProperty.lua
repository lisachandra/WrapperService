local WrapperService = require(script.Parent)
local t = require(script.Parent.Parent:WaitForChild("t"))

local waitForPropertyCheck = t.tuple(WrapperService.isWrapped, t.string, t.optional(t.number))

local function WaitForProperty(self, propertyName, timeOut)
	assert(waitForPropertyCheck(self, propertyName, timeOut))

	if rawget(self, propertyName) ~= nil then
		return rawget(self, propertyName)
	end

	local timer = os.time()

	while true do
		task.wait()
		if timeOut and (os.time() - timer) >= math.floor(timeOut) or rawget(self, propertyName) ~= nil then
			if timeOut then
				warn(
					"Timeout reached while calling function WaitForProperty(" .. propertyName .. ", " .. timeOut .. ")"
				)
			end

			return rawget(self, propertyName)
		end
	end
end

return WaitForProperty
