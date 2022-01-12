local strict = require(script:WaitForChild("strict"))

--[[
     A service that allows you to create custom properties for roblox instances  
     Github: [https://github.com/zxibs/WrapperService](https://github.com/zxibs/WrapperService)
]]
local WrapperService = strict({
	__wrappedInstances = {},

	new = require(script:WaitForChild("new")),
	isWrapped = require(script:WaitForChild("isWrapped")),
	GetWrappedInstance = require(script:WaitForChild("GetWrappedInstance")),
}, "WrapperService")

return WrapperService
