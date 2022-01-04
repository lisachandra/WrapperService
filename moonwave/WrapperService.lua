--#selene: allow(unused_variable)

-- WrapperService type

--[=[
    @class WrapperService
]=]
local WrapperService = {}

--[=[
    
]=]

--[=[
    Creates a wrapped instance.
    ```lua
    local workspace = WrapperService:new(workspace)
    ```

    @param instanceToWrap Instance
    @return WrappedInstance
]=]
function WrapperService:new(instanceToWrap) end

--[=[
    Gets a wrapped version of the instance, returns nil if it doesn't exist.  
    ```lua
    WrapperService:new(workspace)

    local workspace = WrapperService:GetWrappedInstance(workspace)
    ```

    @param instanceToGet Instance
    @return WrappedInstance
]=]
function WrapperService:GetWrappedInstance(instanceToGet) end

--[=[
    Returns true if the passed instance is wrapped, false if it's not.  
    ```lua  
    local boolean = WrapperService.isWrapped(WrapperService:new(workspace)) -- true
    ```

    @param instanceToCheck Instance | WrappedInstance
    @return boolean
]=]
function WrapperService.isWrapped(instanceToCheck) end

-- WrappedInstance type

--[=[
    @class WrappedInstance
]=]
local WrappedInstance = {}

--[=[
    Valid value types that are for adding properties using the Add function
    @type ValueType "Property" | "Method" | "Event"
    @within WrappedInstance
]=]

--[=[
    Destroys/Cleans the wrapped instance for GC  
    Returns the unwrapped version of the wrapped instance  
    ```lua  
    local workspace = WrapperService:new(workspace)

    local normalWorkspace: Workspace = workspace:Cleanup()
    ```

    @return Instance
]=]
function WrappedInstance:Cleanup() end

--[=[
    Adds properties to the instance (Event/Method/Property)  
    ```lua
    local workspace = WrapperService:new(workspace)

    workspace:Add({
        NewProperty = {
            Property = "This is a new property!"
        },

        NewMethod = {
            Method = function(self)
                return self.NewProperty
            end
        }

        NewEvent = {
            Event = function(signal) -- This function will be the signal's fire handler.
                while true do
                    task.wait(5)
                    signal:Fire(Random.new():NextInteger(1, math.huge))
                end
            end
        },
    })

    local NewProperty = workspace.NewProperty
    NewProperty = workspace:NewMethod()

    local NewConnection = workspace.NewEvent:Connect(function(randomInteger)
        print(tostring(randomInteger))
    end)
    ``` 

    @param properties table<string, table<ValueType, any>>
]=]
function WrappedInstance:Add(properties) end

--[=[
    Basically like `<Instance>:WaitForChild()` but for properties  

    This is useful when you want to add a method that
    returns a property but the property isn't there yet
    
    You can see this function being used in the Add function example above.

    @param propertyName string
    @param timeOut? number
    @return any
    @yields
]=]
function WrappedInstance:WaitForProperty(propertyName, timeOut) end
