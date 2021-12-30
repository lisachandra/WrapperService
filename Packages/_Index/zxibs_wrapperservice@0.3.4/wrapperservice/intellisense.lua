--#selene: allow(unused_variable)
--[[
    --NOTE: YOU DO NOT NEED TO REQUIRE THIS.

    Uses EmmyLua annotations to provide some intellisense
    https://emmylua.github.io/

    How to use: ```lua
    -- Do @type [type] on top of a variable like this:

    ---@type WrapperService
    local WrapperService = require("WrapperService")

    -- For Wrapped Instances

    ---@type WrappedInstance | Workspace @ Put your instance to wrap here
    local workspace = WrapperService:new(workspace)
    ```
]]

-- WrapperService type

--- A service that allows you to create custom properties for roblox instances.
--- Github: [https://github.com/zxibs/WrapperService](https://github.com/zxibs/WrapperService)
---@class WrapperService
---@field __wrappedInstances table<string, WrappedInstance>
local WrapperService = {}

--- Creates a wrapped instance
---@param instanceToWrap Instance
---@return WrappedInstance
function WrapperService:new(instanceToWrap) end

--- Gets a wrapped version of the instance, returns nil if it doesn't exist.
---@param instanceToGet Instance
---@return WrappedInstance
function WrapperService:GetWrappedInstance(instanceToGet) end

--- Returns true if the passed instance is wrapped, false if it's not.
---@param instanceToCheck Instance|WrappedInstance
---@return boolean
function WrapperService.isWrapped(instanceToCheck) end

-- WrappedInstance type

---@class WrappedInstance
---@field Instance Instance
---@field __id string
local WrappedInstance = {}

--- Adds properties to the instance (Event/Method/Property)
---@param properties table<string, table<string, any>>
function WrappedInstance:Add(properties) end

--- Destroys/Cleans the wrapped instance for GC
--- Returns the unwrapped version of the wrapped instance
---@return Instance
function WrappedInstance:Cleanup() end

--- Basically like `<Instance>:WaitForChild()` but for properties
---
--- This is useful when you want to add a method that
--- returns a property but the property isn't there yet
---@param propertyName string
---@param timeOut? number
---@return any
function WrappedInstance:WaitForProperty(propertyName, timeOut) end
