local function isWrapped(wrappedInstanceObject)
	if tostring(wrappedInstanceObject) == "WrappedInstance" and typeof(wrappedInstanceObject) == "table" then
		return true
	else
		return false
	end
end

return isWrapped
