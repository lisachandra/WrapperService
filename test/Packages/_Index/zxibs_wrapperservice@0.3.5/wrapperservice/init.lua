local SignalService = require(script.Parent:WaitForChild("SignalService"))

type Dictionary<T> = {[string]: T}
type Array<T> = {[number]: T}

type Signal = SignalService.Signal

type ValueTypes = {
     Property: any
} | {
     Method: (self: WrappedInstance, ...any) -> ...any,
} | {
     Event: (signal: Signal) -> ()
}

export type WrappedInstance = {
     __id: string,

     Instance: Instance,

     Add: (self: WrappedInstance, propertiesToAdd: Dictionary<ValueTypes>) -> (),
     Cleanup: (self: WrappedInstance) -> Instance,
     WaitForProperty: (self: WrappedInstance, propertyName: string, timeOut: number?) -> any
}

export type WrapperService = {
     __wrappedInstance: Dictionary<WrappedInstance>,

     new: (self: WrapperService, instanceToWrap: Instance) -> WrappedInstance,
     isWrapped: (wrappedInstance: WrappedInstance?) -> (boolean, string?),
     GetWrappedInstance: (self: WrapperService, instanceToGet: Instance) -> WrappedInstance? 
}

local strict = require(script:WaitForChild("strict"))

--[[
     A service that allows you to create custom properties for roblox instances  
     Github: [https://github.com/zxibs/WrapperService](https://github.com/zxibs/WrapperService)
]]
local WrapperService: WrapperService = strict({
	__wrappedInstances = {},

	new = require(script:WaitForChild("new")),
	isWrapped = require(script:WaitForChild("isWrapped")),
	GetWrappedInstance = require(script:WaitForChild("GetWrappedInstance")),
}, "WrapperService")

return WrapperService
