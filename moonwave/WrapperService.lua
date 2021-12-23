--#selene: allow(unused_variable)

-- WrapperService type

--[=[
    @class WrapperService
]=]
local WrapperService = {}

--[=[
    Creates a wrapped instance.
    ```lua
    ---@type WrappedInstance | Workspace -- This is for IntelliSense
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

    ---@type WrappedInstance | Workspace -- This is for IntelliSense
    local workspace = WrapperService:GetWrappedInstance(workspace)
    ```

    @param instanceToGet Instance
    @return WrappedInstance
]=]
function WrapperService:GetWrappedInstance(instanceToGet) end

--[=[
    Returns true if the passed instance is wrapped, false if it's not.  
    ```lua  
    local boolean = WrapperService.isWrapped(WrapperService:new(workspace)) -- True
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
    Destroys/Cleans the wrapped instance for GC  
    Returns the unwrapped version of the wrapped instance  
    ```lua
    ---@type WrappedInstance | Workspace
    local workspace = WrapperService:new(workspace)

    local normalWorkspace: Workspace = workspace:Cleanup()
    ```

    @return Instance
]=]
function WrappedInstance:Cleanup() end

--[=[
    Adds properties to the instance (Event/Method/Property)  
    ```lua
    <WrappedInstance>:Add({
        NewProperty = {
            Property = "This is a new property!"
        },

        NewMethod = {
            Method = function()
                return <WrappedInstance>:WaitForProperty("NewProperty")
            end
        }

        NewEvent = {
            ---@param signal Signal -- This is for IntelliSense
            Event = function(signal)
                while true do
                    task.wait(5)
                    signal:Fire(Random.new():NextInteger(1, math.huge))
                end
            end
        },
    })

    local NewProperty = <WrappedInstance>.NewProperty
    NewProperty = <WrappedInstance>:NewMethod()

    local NewConnection = <WrappedInstance>.NewEvent:Connect(function(randomInteger)
        print(tostring(randomInteger))
    end)
    ``` 

    @param properties table<string, table<string, any>>
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
