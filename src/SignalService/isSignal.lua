local function isSignal(signalObject)
	local Type = tostring(signalObject)
	if Type == "Signal" and typeof(signalObject) == "table" or Type == "Connection" and typeof(signalObject) == "table" then
		return true
	else
		return false, "Signal/Connection expected, got " .. typeof(signalObject)
	end
end

return isSignal
