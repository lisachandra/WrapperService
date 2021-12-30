--#selene: allow(undefined_variable)
return function()
    local Packages = script.Parent.Parent:WaitForChild("Packages")
    local WrapperService = require(Packages:WaitForChild("WrapperService"))

    beforeAll(function(context)
        context.wrappedInstances = {}
        context.revertableChanges = {}

        context.addWrappedInstance = function(wrappedInstance)
            context.wrappedInstances[#context.wrappedInstances + 1] = wrappedInstance
        end

        context.addRevertableChanges = function(propertyName, revertableChanges)
            context.revertableChanges[propertyName] = revertableChanges 
        end
    end)

    afterAll(function(context)
        for propertyName, propertyContents in pairs(context.revertableChanges) do
            propertyContents.instance[propertyName] = propertyContents.previousValue
        end

        for _, wrappedInstance in ipairs(context.wrappedInstances) do
            if WrapperService.isWrapped(wrappedInstance) then
                wrappedInstance:Cleanup()
            end
        end
    end)
end