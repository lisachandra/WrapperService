local function isSignal(signalObject)
	if tostring(signalObject) == "Signal" or tostring(signalObject) == "Connection" and typeof(signalObject) == "table" then
		return true
	else
		return false
	end
end

return isSignal
