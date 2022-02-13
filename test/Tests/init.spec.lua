return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local WrapperService

    local isAuto: boolean, Packages: any = pcall(function()
        return ReplicatedStorage:FindFirstChild("Packages")
    end)

    if isAuto then 
        WrapperService = require(Packages.WrapperService)
    else
        WrapperService = require(ReplicatedStorage:FindFirstChild("WrapperService"))
    end

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
            if WrapperService.Is(wrappedInstance) then
                wrappedInstance:Clean()
            end
        end
    end)
end