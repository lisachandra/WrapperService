return function()
    local Packages = script.Parent.Parent:WaitForChild("Packages")
    local WrapperService = require(Packages:WaitForChild("WrapperService"))

    describe("isWrapped", function()
        it("should return true", function()
            local boolean = WrapperService.isWrapped(setmetatable({}, {
                __tostring = function()
                    return "WrappedInstance"
                end
            }))

            expect(boolean).to.be.equal(true)
        end)

        it("should return false", function()
            local boolean = WrapperService.isWrapped("WrappedInstance")
            expect(boolean).to.be.equal(false)
        end)
    end)

    describe("cleanup", function()
        it("should destroy the WrappedInstance", function()
            local workspace = WrapperService:new(workspace)
            local id = workspace.__id
            workspace = workspace:Cleanup()
            expect(workspace.Name).to.be.equal("Workspace")
            expect(WrapperService.isWrapped(workspace)).to.be.equal(false)
            expect(WrapperService.__wrappedInstances[id]).to.be.equal(nil)
        end)
    end)
    
    describe("new", function()
        it("should create a WrappedInstance", function(context)
            local workspace = WrapperService:new(workspace)
            context.addWrappedInstance(workspace)
            expect(WrapperService.isWrapped(workspace)).to.be.equal(true)
        end)

        it("should connect to an event", function(context)
            local workspace = WrapperService:new(workspace)
            context.addWrappedInstance(workspace)

            local event
            event = workspace.Changed:Connect(function()
                event:Disconnect()
            end)

            expect(typeof(event)).to.be.equal("RBXScriptConnection")
        end)

        it("should return the name as Workspace", function(context)
            local workspace = WrapperService:new(workspace)
            context.addWrappedInstance(workspace)
            expect(workspace.Name).to.be.equal("Workspace")
        end)

        it("should modify the gravity to 1", function(context)
            local workspace = WrapperService:new(workspace)
            context.addWrappedInstance(workspace)
            context.addRevertableChanges("Gravity", {
                instance = workspace.Instance,
                previousValue = workspace.Gravity
            })

            workspace.Gravity = 1
            expect(workspace.Gravity).to.be.equal(1)
        end)

        it("should find the baseplate and modify its children", function(context)
            local workspace = WrapperService:new(workspace)
            context.addWrappedInstance(workspace)
            local baseplate = workspace:FindFirstChild("Baseplate")
            
            expect(typeof(baseplate)).to.be.equal("Instance")

            for _, child in ipairs(baseplate:GetChildren()) do
                context.addRevertableChanges("Name", {
                    instance = child,
                    previousValue = child.Name
                })

                child.Name = "Modified"
                expect(child.Name).to.be.equal("Modified")
            end
        end)
    end)

    describe("getWrappedInstance", function()
        it("should return a WrappedInstance", function(context)
            WrapperService:new(workspace)
            local workspace = WrapperService:GetWrappedInstance(workspace)
            context.addWrappedInstance(workspace)
            expect(WrapperService.isWrapped(workspace)).to.be.equal(true)
        end)
    end)

    describe("add", function()
        it("should make a new property and a method", function(context)
            local workspace = WrapperService:new(workspace)
            context.addWrappedInstance(workspace)

            workspace:Add({
                NewProperty = {
                    Property = "This is a new property!"
                },

                GetInteger = {
                    Method = function()
                        return 1
                    end
                }
            })

            expect(workspace.NewProperty).to.be.equal("This is a new property!")
            expect(workspace:GetInteger()).to.be.a("number")
        end)

        it("should make a new event and fire with the correct arguments", function(context)
            local workspace = WrapperService:new(workspace)
            context.addWrappedInstance(workspace)

            workspace:Add({
                AutomaticEvent = {
                    Event = function(signal)
                        wait(1)
                        signal:Fire("fired!")
                    end
                }
            })

            workspace.AutomaticEvent:Connect(function(stringArgument)
                expect(stringArgument).to.be.equal("fired!")
            end)
        end)
    end)

    describe("waitForProperty", function()
        it("should wait for a property", function(context)
            local workspace = WrapperService:new(workspace)
            context.addWrappedInstance(workspace)

            workspace:Add({
                GetNewProperty = {
                    Method = function(self)
                        return self:WaitForProperty("NewProperty")
                    end
                }
            })

            coroutine.wrap(function()
                wait(0.25)
                workspace:Add({
                    NewProperty = {
                        Property = "This is a new property!"
                    },
                })
            end)()

            expect(workspace:GetNewProperty()).to.be.equal("This is a new property!")
        end)

        it("should timeout while waiting for a property", function(context)
            local workspace = WrapperService:new(workspace)
            context.addWrappedInstance(workspace)

            workspace:Add({
                NewProperty = {
                    Property = "This is a new property!"
                },

                GetNewProperty = {
                    Method = function(self)
                        return self:WaitForProperty("InvalidNewProperty", 2)
                    end
                }
            })

            expect(workspace.NewProperty).to.be.equal("This is a new property!")
            expect(workspace:GetNewProperty()).to.be.equal(nil)
        end)
    end)
end