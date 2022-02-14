local Signal = require(script.Signal)

type Properties<I, T...> = {
    [any]: {
        Property: any
    } | {
        Method: (self: WrappedInstance<I>, ...any?) -> ...any?
    } | {
        Event: (Signal: Signal<T...>) -> ()
    }
}

export type Signal<T...> = Signal.Signal<T...>

export type WrappedInstance<I> = {
    Instance: I,
    Index: number,

    Add: (self: WrappedInstance<I>, properties: Properties<any>) -> (),
    Clean: (self: WrappedInstance<I>) -> I,
    WaitForProperty: (self: WrappedInstance<I>, propertyKey: any, timeOut: number) -> any
} & I

--[[
     A service that allows you to create custom properties for roblox instances  
     Github: [https://github.com/zxibs/WrapperService](https://github.com/zxibs/WrapperService)
]]
local WrapperService = {}
WrapperService.Instances = {} :: { WrappedInstance<Instance> }

function WrapperService.new<I>(Instance: I): WrappedInstance<I>
    local self = {}
    table.insert(WrapperService.Instances, self)

    self.Instance = Instance :: Instance
    self.Index = table.find(WrapperService.Instances, self) :: number

	setmetatable(self, WrapperService)

    return self :: any
end

function WrapperService:Is(object: any): (boolean, string?)
    return (
        type(object) == "table"
        and getmetatable(object) == self
    ) or false, ("expected WrappedInstance got %s"):format(typeof(object))
end

function WrapperService:GetByIndex(Index: number): WrappedInstance<Instance>?
    return self.Instances[Index] :: any
end

function WrapperService:GetByInstance<I>(Instance: I): WrappedInstance<I>?
    for _index, WrappedInstance in ipairs(self.Instances) do
        if WrappedInstance.Instance == Instance then
            return WrappedInstance :: any
        end
    end
end

function WrapperService:Add(properties: Properties<Instance, any>): ()
    for name, propertyContents in pairs(properties) do
		for valueType, value in pairs(propertyContents) do
			local GetValues = {
				Property = function()
					return value
				end,

				Event = function()
                    local newSignal = Signal.new()
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

function WrapperService:WaitForProperty(propertyKey: any, timeOut: number): any?
	local timer = os.time()

	while true do
		task.wait()
        
		if timeOut and (os.time() - timer) >= math.round(timeOut) or self[propertyKey] then
			if timeOut and (os.time() - timer) >= math.round(timeOut) then
				warn(("Timeout reached while calling function WaitForProperty(%s, %s)"):format(
                    tostring(propertyKey), 
                    tostring(timeOut)
                ))
			end

			return self[propertyKey]
		end
	end
end

function WrapperService:Clean(): Instance
    local Instance = self.Instance
    
    for Index = (self.Index :: number + 1), #WrapperService.Instances do
        local WrappedInstance = WrapperService.Instances[Index]

        WrappedInstance.Index -= 1
    end

    table.remove(WrapperService.Instances, self.Index :: number)
    table.clear(self)

    setmetatable(self, nil)

    return Instance
end

function WrapperService:__index(key: any): any?
    if type(WrapperService[key]) == "function" then
        return function(otherSelf, ...)
            return WrapperService[key](otherSelf, ...)
        end
    elseif WrapperService[key] then
        return WrapperService[key]
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

function WrapperService:__newindex(key: any, value: any): ()
    local exists: boolean = pcall(function()
        local test = self.Instance[key]
    end)

    if exists then 
        self.Instance[key] = value
    end
end

function WrapperService:__tostring(): string
    return ("WrappedInstance (%s)"):format(self.Instance.Name)
end

return WrapperService
