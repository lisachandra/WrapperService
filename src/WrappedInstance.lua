local Signal = require(script.Parent.Utilities.Signal)
local GetChecks = require(script.Parent.GetChecks)

type Properties<I> = {
	[any]: {
		Property: any,
	} | {
		Method: (self: WrappedInstance<I>, ...any?) -> ...any?,
	} | {
		Event: (Signal: Signal) -> (),
	},
}

--TODO: Add T... generics when parse_error problem is fixed
export type Signal = Signal.Signal

export type WrappedInstance<I> = {
    Changed: Signal,
    Called: Signal,

	Add: (self: WrappedInstance<I>, properties: Properties<I>) -> (),
	Clean: (self: WrappedInstance<I>) -> I
} & { [any]: any } & I

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
					local newSignal: Signal = self._Janitor:Add(Signal.new(), "DisconnectAll")
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
    @return I
    
    Makes the wrapped instance unuseable.
]=]
function WrappedInstance:Clean(): Instance
	assert(Checks.Clean(self))

	local Instance = self._Instance

	self._Janitor:Destroy()

	table.clear(self)
	setmetatable(self, nil)

	return Instance
end

function WrappedInstance:__index(key: any): any?
    local Called = self._Public.Called
    local property = self._Public[key]

    if type(property) == "function" then
        return function(otherSelf, ...)
            Called:Fire(key, otherSelf, ...)
			return property(otherSelf, ...)
		end
    elseif property then
        return property
    end

    property = WrappedInstance[key]

	if type(property) == "function" then
		return function(otherSelf, ...)
            Called:Fire(key, otherSelf, ...)
			return property(otherSelf, ...)
		end
	elseif property then
		return property
	end

	local exists: boolean, instanceProperty: any = pcall(function()
		return self._Instance[key]
	end)

	if exists then
		if type(instanceProperty) == "function" then
			return function(_, ...)
                Called:Fire(key, self._Instance, ...)
				return instanceProperty(self._Instance, ...)
			end
		else
			return instanceProperty
		end
	end

	return
end

function WrappedInstance:__newindex(key: any, value: any): ()
    local Changed = self._Public.Changed
    local property = self._Public[key]

    if property then
        self._Public[key] = value
        Changed:Fire(property, value)
    end

	local exists: boolean, instanceProperty: string | any = pcall(function()
		return self._Instance[key]
	end)

	if exists then
		self._Instance[key] = value
        Changed:Fire(instanceProperty, value)
	end
end

function WrappedInstance:__tostring(): string
	return ("WrappedInstance (%s)"):format(self._Instance.Name)
end

return WrappedInstance
