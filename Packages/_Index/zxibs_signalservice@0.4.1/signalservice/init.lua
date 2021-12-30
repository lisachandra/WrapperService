local strict = require(script:WaitForChild("strict"))
local SignalService = strict({
	new = require(script:WaitForChild("new")),
	isSignal = require(script:WaitForChild("isSignal")),
}, "SignalService")

return SignalService
