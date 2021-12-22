--#selene: allow(unused_variable)
--[[
    --NOTE: YOU DO NOT NEED TO REQUIRE THIS.

    Uses EmmyLua annotations to provide some intellisense
    https://emmylua.github.io/

    How to use: ```lua
    -- Do @type [type] on top of a variable like this:

    ---@type SignalService
    local SignalService = require("SignalService")

    ---@type Signal
    local Signal = SignalService.new()

    ---@type Connection
    local Connection = Signal:Connect(function() end)
    ```
]]

-- SignalService type

--- A service that allows you to create custom events
--- Github: [https://github.com/zxibs/SignalService](https://github.com/zxibs/SignalService)
---@class SignalService
local SignalService = {}

--- Creates a new signal
---@return Signal
function SignalService.new() end

--- Returns true if the passed in signal is a signal, returns false if it's not
---@param signalToCheck Signal
---@return boolean
function SignalService.isWrapped(signalToCheck) end

-- Signal type

---@class Signal
---@field __connections table<string, Connection>
---@field __callbacks table<string, fun()>
---@field __waiters table<number, thread>
local Signal = {}

--- Fires the signal causing connected callbacks to fire
function Signal:Fire(...) end

--- Yields the thread and resumes with it's arguments when the signal is fired
---@return any
function Signal:Wait() end

--- Connects a callback to the signal that will be fired when
--- `<Signal>:Fire()` is called
---
--- **And**
---
--- Returns a connection that can be disconnected by calling
--- `<Connection>:Disconnect()`
---@param callbackFunction fun()
---@return Connection
function Signal:Connect(callbackFunction) end

--- Runs `<Signal>:DisconnectAll()` then destroys/cleans the signal for GC
function Signal:Destroy() end

--- Runs `<Connection>:Disconnect()` on every connection that is in the signal
function Signal:DisconnectAll() end

-- Connection type

---@class Connection
---@field __signal Signal
---@field __id string
---@field Connected boolean
local Connection = {}

--- Disconnects/Destroys the connection for GC
--- and sets the `Connection.Connected` property to false
function Connection:Disconnect() end
