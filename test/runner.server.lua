local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DevPackages = ReplicatedStorage:WaitForChild("DevPackages")

local TestEZ = require(DevPackages:WaitForChild("TestEZ"))

TestEZ.TestBootstrap:run({
    ReplicatedStorage.Tests,
})
