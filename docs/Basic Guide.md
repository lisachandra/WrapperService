# Basic Guide

Lets say you wanna add a custom property, method and event to the workspace.
First we need to wrap the workspace.
```lua
--[[
    we can add IntelliSense by adding a @type comment on top of the variable 
    (For people that use EmmyLua, Roblox LSP, sumneko's lua language server, etc.)
]]

---@type WrappedInstance | Workspace
local workspace = WrapperService:new(workspace)
```
Now we have created a wrapped version of the workspace,
we can add properties to them!
```lua
workspace:Add({
    NewString = {
        Property = "This is a new property!"
    },

    GetNewString = {
        Method = function(self)
            return self.NewString
        end
    },

    onNewStringChanged = {
        ---@param signal Signal -- This is for IntelliSense
        Event = function(signal) -- This function will be the signal's fire handler.
            repeat
            task.wait()
            until signal.__callbacks[1] -- Waits until a callback is connected

            --[[
                We have to use :WaitForProperty because 
                this function may get called first before NewString is added
            ]]

            local currentValue = workspace:WaitForProperty("NewString")

            while true do
                task.wait()

                if WrapperService.isWrapped(workspace) and workspace:WaitForProperty("NewString") ~= currentValue then
                    signal:Fire(workspace:WaitForProperty("NewString"), currentValue)
                    currentValue = workspace:WaitForProperty("NewString")
                elseif not WrapperService.isWrapped(workspace) then
                    --[[
                        will break the loop when the 
                        wrapped version of workspace is destroyed/cleaned
                    ]]

                    break 
                end
            end
        end
    },
})
```
Now we can use them as normal properties!
```lua
local Connection = workspace.onNewStringChanged:Connect(function(newValue, lastValue)
    print(newValue, lastValue) -- Changed This is a new property!
end)

task.wait(1)

workspace.NewString = "Changed"

local newString = workspace:GetNewString()
print(newString) -- Changed
```
There is still more to explore, go to the API Docs for more information!