local GetChecks = require(script.GetChecks)
local WrappedInstance = require(script.WrappedInstance)

export type Signal<T...> = WrappedInstance.Signal<T...>
export type WrappedInstance<I> = WrappedInstance.WrappedInstance<I>

--[[
     A service that allows you to create custom properties for roblox instances  
     Github: [https://github.com/zxibs/WrapperService](https://github.com/zxibs/WrapperService)
]]
local WrapperService = {}
WrapperService.Instances = {} :: { WrappedInstance<Instance> }

local Checks = GetChecks(WrapperService, true)

function WrapperService:Create<I>(Instance: I): WrappedInstance<I>
    assert(Checks.new(self, Instance))

    local Wrapped = {}
    
    Wrapped.Instance = Instance :: Instance
    Wrapped.Index = (#self.Instances + 1) :: number

	setmetatable(Wrapped, WrappedInstance)
    table.insert(self.Instances, Wrapped)

    return Wrapped :: any
end

function WrapperService:Is(object: any): (boolean, string?)
    assert(Checks.Is(self, object))

    return (
        type(object) == "table"
        and getmetatable(object) == WrappedInstance
    ) or false, ("expected WrappedInstance got %s"):format(typeof(object))
end

function WrapperService:GetByIndex(Index: number): WrappedInstance<Instance>?
    assert(Checks.GetByIndex(self, Index))

    return self.Instances[Index] :: any
end

function WrapperService:GetByInstance<I>(Instance: I): WrappedInstance<I>?
    assert(Checks.GetByInstance(self, Instance))

    for _index, WrappedInstance in ipairs(self.Instances) do
        if WrappedInstance.Instance == Instance then
            return WrappedInstance :: any
        end
    end
end

return WrapperService
