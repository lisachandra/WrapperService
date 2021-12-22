local function Disconnect(self)
	self.__signal.__connections[self.__id] = nil
	self.__signal.__callbacks[self.__id] = nil
	self.Connected = false
end

return Disconnect
