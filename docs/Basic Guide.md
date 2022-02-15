# Basic Guide

Lets say you wanna add a custom property, method and event to the workspace.
First we need to wrap the workspace.
```lua
local WrapperService = require(path.to.WrapperService)

local Workspace = WrapperService:Create(workspace)
```
Now we have created a wrapped version of the workspace,
we can add properties to them!
```lua
Workspace:Add({
    -- property keys don't need to be strings, but it is recommended to use strings
    NewString = {
        Property = "This is a new property!"
    },

    GetNewString = {
        -- self is the wrapped instance itself
        Method = function(self)
            self.GetNewStringCalled:Fire(self.NewString)
            return self.NewString
        end
    },

    GetNewStringCalled = {
        --[[ 
            We make an empty function here because
            this doesn't handle firing the signal,
            the method itself does.
        ]]
        Event = function(signal) end
    }
})
```
Now we can use them as normal properties!
```lua
print(Workspace.NewString) -- "This is a new property!"

local Connection
Connection = Workspace.GetNewStringCalled:Connect(function(value)
    print("GetNewString was called:", value)
    Connection:Disconnect()
end)

Workspace:GetNewString() -- The callback above will run when calling this
```
There is still more to explore, go to the API Docs for more information!
