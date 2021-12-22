local messages = require(script.Parent:WaitForChild("messages"))

local function WaitForProperty(self, propertyName, timeOut)
	if rawget(self, propertyName) ~= nil then
		return rawget(self, propertyName)
	end

	local timer = os.time()

	while true do
		task.wait()
		if timeOut and (os.time() - timer) >= math.floor(timeOut) or rawget(self, propertyName) ~= nil then
			if timeOut then
				warn(messages.TIMEOUT_REACHED:format("WaitForProperty"))
			end

			return rawget(self, propertyName)
		end
	end
end

return WaitForProperty
