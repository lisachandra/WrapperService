local _WaitForGame = game:IsLoaded() or game.Loaded:Wait()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packages = ReplicatedStorage:WaitForChild("Packages")

local WrapperService = require(Packages:WaitForChild("WrapperService"))

WrapperService:new(workspace)
local workspace = WrapperService:GetWrappedInstance(workspace)
local id = workspace.__id

local thingy = workspace:WaitForChild("Baseplate")
local texture = thingy:WaitForChild("Texture")
texture.Name = "Modified"

workspace:Add({
	NewProperty = {
		Property = "This is a new property!",
	},
})

local event
event = workspace:GetPropertyChangedSignal("Gravity"):Connect(function()
	print(workspace.Gravity)
	event:Disconnect()
end)

task.delay(2, function()
	workspace.Gravity = 89
end)

print(workspace.NewProperty)

workspace = workspace:Cleanup()
print(WrapperService.isWrapped(workspace))
print(WrapperService.__wrappedInstances[id])
print(workspace.Baseplate.Name)
