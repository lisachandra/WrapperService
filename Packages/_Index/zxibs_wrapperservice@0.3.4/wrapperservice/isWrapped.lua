local function isWrapped(wrappedInstanceObject)
	if tostring(wrappedInstanceObject) == "WrappedInstance" and typeof(wrappedInstanceObject) == "table" then
		return true
	else
		return false, "expected WrappedInstance, got " .. typeof(wrappedInstanceObject)
	end
end

return isWrapped
