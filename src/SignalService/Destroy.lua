local SignalService = require(script.Parent)

local function ClearTableDescendants(tableToClear)
	for index, value in pairs(tableToClear) do
		if typeof(value) == "table" then
			table.clear(tableToClear[index])
			setmetatable(tableToClear[index], nil)
			ClearTableDescendants(tableToClear[index])
		end
	end
end

local function Destroy(self)
	if not SignalService.isSignal(self) then
		local message = "Expected `:` not `.` while calling function Fire"

		error(message, 2)
	end

	self:DisconnectAll()
	ClearTableDescendants(self)

	table.clear(self)
	setmetatable(self, nil)
end

return Destroy
