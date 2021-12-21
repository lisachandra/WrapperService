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

]]
---@param self Signal
local function Destroy(self)
	self:DisconnectAll()
	ClearTableDescendants(self)

	table.clear(self)
	setmetatable(self, nil)
end

return Destroy
