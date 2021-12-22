local WrapperService = {
	__wrappedInstances = {},

	new = require(script:WaitForChild("new")),
	isWrapped = require(script:WaitForChild("isWrapped")),
	GetWrappedInstance = require(script:WaitForChild("GetWrappedInstance")),
}

return WrapperService
