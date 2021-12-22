local function DisconnectAll(self)
	for _, connection in pairs(self.__connections) do
		connection:Disconnect()
	end
end

return DisconnectAll
