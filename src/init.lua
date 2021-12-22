local strict = require(script:WaitForChild("strict"))
local WrapperService = strict({
	__wrappedInstances = {},

	new = require(script:WaitForChild("new")),
	isWrapped = require(script:WaitForChild("isWrapped")),
	GetWrappedInstance = require(script:WaitForChild("GetWrappedInstance")),
}, "WrapperService")

return WrapperService
