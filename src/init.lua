local Signal = require(script.Signal)
local GetChecks = require(script.GetChecks)
local WrappedInstance = require(script.WrappedInstance)

export type Signal = WrappedInstance.Signal
export type WrappedInstance<I> = WrappedInstance.WrappedInstance<I>

--[=[
    @class WrapperService

    A service that allows you to create custom properties for roblox instances  
    Github: [https://github.com/zxibs/WrapperService](https://github.com/zxibs/WrapperService)
]=]
local WrapperService = {}

--[=[
    @prop Instances { WrappedInstance<Instance> }
    @within WrapperService

    A table containing all of the wrapped instances that have been created and not cleaned.
]=]
WrapperService.Instances = {} :: { WrappedInstance<Instance> }

local Checks = GetChecks(WrapperService, true)

--[=[
    @since v1.0.0
    @param Instance I
    @return WrappedInstance<I>

    Creates and returns a new WrappedInstance from the Instance
]=]
function WrapperService:Create<I>(Instance: I): WrappedInstance<I>
    assert(Checks.Create(self, Instance))

    local Wrapped = {}
    
    Wrapped.Instance = Instance :: Instance
    Wrapped.Index = (#self.Instances + 1) :: number
    Wrapped.Cleaning = Signal.new() :: Signal
    
    Wrapped.Cleaning:Connect(function(Index: number)
        for InstanceIndex = (Index + 1), #self.Instances do
            self.Instances[InstanceIndex].Index -= 1
        end

        table.remove(self.Instances, Index)
    end)

	setmetatable(Wrapped, WrappedInstance)
    table.insert(self.Instances, Wrapped)

    return Wrapped :: any
end

--[=[
    @since v1.0.0
    @param object any
    @return ( boolean, string? )

    A method for checking if an object is a WrappedInstance,
    if it is not it will return false and an error message
]=]
function WrapperService:Is(object: any): (boolean, string?)
    assert(Checks.Is(self, object))

    return (
        type(object) == "table"
        and getmetatable(object) == WrappedInstance
    ) or false, ("expected WrappedInstance got %s"):format(typeof(object))
end

--[=[
    @since v1.0.0
    @param Index number
    @return WrappedInstance<Instance>

    Gets a wrapped instance in ```WrapperService.Instances``` from an index
]=]
function WrapperService:GetByIndex(Index: number): WrappedInstance<Instance>?
    assert(Checks.GetByIndex(self, Index))

    return self.Instances[Index] :: any
end

--[=[
    @since v1.0.0
    @param Instance I
    @return WrappedInstance<I>

    Gets a wrapped instance in ```WrapperService.Instances``` from an instance
]=]
function WrapperService:GetByInstance<I>(Instance: I): WrappedInstance<I>?
    assert(Checks.GetByInstance(self, Instance))

    for _index, wrappedInstance in ipairs(self.Instances) do
        if wrappedInstance.Instance == Instance then
            return wrappedInstance :: any
        end
    end
end

return WrapperService
