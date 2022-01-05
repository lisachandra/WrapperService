type Dictionary<T> = {[string]: T}
type Array<T> = {[number]: T}

export type Connection = {
     __signal: Signal,
     __id: string,

     Connected: boolean,

     Disconnect: (self: Connection) -> ()
}

export type Signal = {
     __connections: Dictionary<Connection>,
     __callbacks: Dictionary<(...any) -> ()>,
     __waiters: Array<thread>,

     Fire: (self: Signal, ...any) -> (),
     Wait: (self: Signal) -> ...any,
     Connect: (self: Signal, callbackFn: (...any) -> ()) -> Connection,
     Destroy: (self: Signal) -> (),
     Dispatch: (self: Signal, action: {type: string}) -> (),
     onDispatch: (self: Signal, dispatchHandlers: Dictionary<(action: {type: string}) -> ()>) -> (),
     DisconnectAll: (self: Signal) -> ()
}

export type SignalService = {
     new: () -> Signal,
     isSignal: (signalObject: Signal?) -> (boolean, string?)
}

local strict = require(script:WaitForChild("strict"))

--[[
     A service that allows you to create custom events  
     Github: [https://github.com/zxibs/SignalService](https://github.com/zxibs/SignalService)
]]
local SignalService: SignalService = strict({
	new = require(script:WaitForChild("new")),
	isSignal = require(script:WaitForChild("isSignal")),
}, "SignalService")

return SignalService
