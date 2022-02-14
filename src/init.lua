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

function WrapperService.new<I>(Instance: I): WrappedInstance<I>
    assert(Checks.new(Instance))

    local self = {}
    
    self.Instance = Instance :: Instance
    self.Index = (#WrapperService.Instances + 1) :: number

	setmetatable(self, WrappedInstance)
    table.insert(WrapperService.Instances, self)

    return self :: any
end

function WrapperService.Is(self: any): (boolean, string?)
    assert(Checks.Is(self))

    return (
        type(self) == "table"
        and getmetatable(self) == WrappedInstance
    ) or false, ("expected WrappedInstance got %s"):format(typeof(self))
end

function WrapperService.GetByIndex(Index: number): WrappedInstance<Instance>?
    assert(Checks.GetByIndex(Index))

    return WrapperService.Instances[Index] :: any
end

function WrapperService.GetByInstance<I>(Instance: I): WrappedInstance<I>?
    assert(Checks.GetByInstance(Instance))

    for _index, WrappedInstance in ipairs(WrapperService.Instances) do
        if WrappedInstance.Instance == Instance then
            return WrappedInstance :: any
        end
    end
end

return WrapperService
