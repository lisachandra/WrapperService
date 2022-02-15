local RunService = game:GetService("RunService")

local Signal = require(script.Parent.Signal)
local GetChecks = require(script.Parent.GetChecks)

type Properties<I> = {
    [any]: {
        Property: any
    } | {
        Method: (self: WrappedInstance<I>, ...any?) -> ...any?
    } | {
        Event: (Signal: Signal) -> ()
    }
}

--TODO: Add T... generics when parse_error problem is fixed
export type Signal = Signal.Signal

export type WrappedInstance<I> = {
    Cleaning: Signal,
    Instance: I,
    Index: number,

    Add: (self: WrappedInstance<I>, properties: Properties<I>) -> (),
    Clean: (self: WrappedInstance<I>) -> I,
    WaitForProperty: (self: WrappedInstance<I>, propertyKey: any, timeOut: number?) -> any?
} & I

--[=[
    @class WrappedInstance
]=]
local WrappedInstance = {}
local Checks = GetChecks(WrappedInstance)

--[=[
    @type Properties<I> { [any]: {Property: any } | { Method: (self: WrappedInstance<I>, ...any?) -> ...any? } | { Event: (Signal: Signal) -> () } }
    @within WrappedInstance

    Properties type for ```WrappedInstance:Add``` method
]=]

--[=[
    @prop Cleaning Signal<number>
    @within WrappedInstance

    A signal that will get fired while cleaning
]=]

--[=[
    @prop Index number
    @within WrappedInstance

    The index of where the wrapped instance is stored in ```WrapperService.Instances```
]=]

--[=[
    @prop Instance I
    @within WrappedInstance

    The instance that was passed in ```WrapperService:Create```
]=]

--[=[
    @since v1.0.0
    @param Properties Properties<I>
    
    Adds new properties.
]=]
function WrappedInstance:Add(properties: Properties<Instance>): ()
    assert(Checks.Add(self, properties))

    for name, propertyContents in pairs(properties) do
		for valueType, value in pairs(propertyContents) do
			local GetValues = {
				Property = function()
					return value
				end,

				Event = function()
                    local newSignal: Signal = Signal.new() :: any
					task.spawn(value, newSignal)

					return newSignal
				end,

				Method = function()
					return function(otherSelf, ...)
						if otherSelf ~= self then
							warn(("Expected `:` not `.` while calling member function %s"):format(tostring(name)))
						else
							return value(otherSelf, ...)
						end
					end
				end,
			}

			local GetValue = GetValues[valueType]
            local Value = GetValue()

			rawset(self, tostring(name), Value)
		end
	end
end

--[=[
    @since v1.0.0
    @param propertyKey any
    @param timeOut number?
    @return any
    @yields
    
    Similar to ```Instance:WaitForChild``` but for properties.
]=]
function WrappedInstance:WaitForProperty(propertyKey: any, timeOut: number?): any?
    assert(Checks.WaitForProperty(self, propertyKey, timeOut))

	local timer = os.clock()
    local waitMethod = if RunService:IsClient() then "RenderStepped" else "Heartbeat"

	while true do
		if timeOut and (os.clock() - timer) >= timeOut or self[propertyKey] then
			if timeOut and (os.clock() - timer) >= timeOut then
				warn(("Timeout reached while calling function WaitForProperty(%s, %s)"):format(
                    tostring(propertyKey), 
                    tostring(timeOut)
                ))
			end

			return self[propertyKey]
		end

        RunService[waitMethod]:Wait()
	end
end

--[=[
    @since v1.0.0
    @return I
    
    Makes the wrapped instance unuseable.
]=]
function WrappedInstance:Clean(): Instance
    assert(Checks.Clean(self))

    local Instance = self.Instance
    
    self.Cleaning:Fire(self.Index)
    
    table.clear(self)
    setmetatable(self, nil)

    return Instance
end

function WrappedInstance:__index(key: any): any?
    if type(WrappedInstance[key]) == "function" then
        return function(otherSelf, ...)
            return WrappedInstance[key](otherSelf, ...)
        end
    elseif WrappedInstance[key] then
        return WrappedInstance[key]
    end

    local exists: boolean, property: any = pcall(function()
        return self.Instance[key]
    end)

    if exists then
        if type(property) == "function" then
            return function(_, ...)
                return property(self.Instance, ...)
            end
        else
            return property
        end
    end

    return
end

function WrappedInstance:__newindex(key: any, value: any): ()
    local exists: boolean = pcall(function()
        local _test = self.Instance[key]
    end)

    if exists then 
        self.Instance[key] = value
    end
end

function WrappedInstance:__tostring(): string
    return ("WrappedInstance (%s)"):format(self.Instance.Name)
end

return WrappedInstance
