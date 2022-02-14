return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local WrapperService
    local Signal
    
    local _success, Packages: any = pcall(function()
        return ReplicatedStorage:FindFirstChild("Packages")
    end)

    if Packages then
        Signal = require(Packages._Index["zxibs_wrapperservice"]["wrapperservice"]:FindFirstChild("Signal"))
        WrapperService = require(Packages.WrapperService)
    else   
        Signal = require(ReplicatedStorage:FindFirstChild("WrapperService"):FindFirstChild("Signal"))
        WrapperService = require(ReplicatedStorage:FindFirstChild("WrapperService"))
    end

    describe("Is", function()
        it("should return true", function()
            local boolean = WrapperService:Is(setmetatable({}, WrapperService))

            expect(boolean).to.be.equal(true)
        end)

        it("should return false and an error message", function()
            local boolean, message = WrapperService:Is({})

            expect(boolean).to.be.equal(false)
            expect(type(message)).to.be.equal("string")
        end)
    end)

    describe("Clean", function()
        it("should destroy the WrappedInstance and return the instance that was passed in .new", function()
            local Workspace = WrapperService.new(workspace)
            local Index = Workspace.Index

            Workspace = Workspace:Clean()

            expect(Workspace.Name).to.be.equal("Workspace")
            expect(WrapperService:Is(Workspace)).to.be.equal(false)
            expect(WrapperService.Instances[Index]).to.be.equal(nil)
        end)

        it("should destroy the WrappedInstance and shift index", function()
            local Workspace = WrapperService.new(workspace)
            local otherWorkspace = WrapperService.new(workspace)

            local lastIndex = otherWorkspace.Index

            Workspace = Workspace:Clean()
            
            expect(type(table.find(WrapperService.Instances, otherWorkspace))).to.be.equal("number")
            expect(otherWorkspace.Index == lastIndex - 1).to.be.equal(true)
        end)
    end)
    
    describe("new", function()
        it("should create a WrappedInstance", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(workspace)

            expect(WrapperService:Is(Workspace)).to.be.equal(true)
        end)

        it("should connect to an event", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(Workspace)

            local event
            event = Workspace.Changed:Connect(function()
                event:Disconnect()
            end)

            expect(typeof(event)).to.be.equal("RBXScriptConnection")
        end)

        it("should return the name as Workspace", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(Workspace)

            expect(Workspace.Name).to.be.equal("Workspace")
        end)

        it("should modify the gravity to 1", function(context)
            local Workspace = WrapperService.new(workspace)

            context.addWrappedInstance(Workspace)
            context.addRevertableChanges("Gravity", {
                instance = Workspace.Instance,
                previousValue = Workspace.Gravity
            })

            Workspace.Gravity = 1
            expect(Workspace.Gravity).to.be.equal(1)
        end)

        it("should correctly call a method", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(Workspace)

            local children = Workspace:GetChildren()
            
            expect(type(children)).to.be.equal("table")
        end)
    end)

    describe("GetByIndex", function()
        it("should return a WrappedInstance", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(Workspace)

            Workspace = WrapperService:GetByIndex(Workspace.Index)

            expect(WrapperService:Is(Workspace)).to.be.equal(true)
        end)
    end)

    describe("GetByInstance", function()
        it("should return a WrappedInstance", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(Workspace)

            Workspace = WrapperService:GetByInstance(workspace)

            expect(WrapperService:Is(Workspace)).to.be.equal(true)
        end)
    end)

    describe("Add", function()
        it("should make a new property and a method", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(Workspace)

            Workspace:Add({
                NewProperty = {
                    Property = "This is a new property!"
                },

                GetInteger = {
                    Method = function()
                        return 1
                    end
                }
            })

            expect(Workspace.NewProperty).to.be.equal("This is a new property!")
            expect(Workspace:GetInteger()).to.be.a("number")
        end)

        it("should make a new signal", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(Workspace)

            Workspace:Add({
                AutomaticEvent = {
                    Event = function() end
                }
            })

            expect(Signal.Is(Workspace.AutomaticEvent)).to.be.equal(true)
        end)
    end)

    describe("WaitForProperty", function()
        it("should wait for a property", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(Workspace)

            Workspace:Add({
                GetNewProperty = {
                    Method = function(self)
                        return self:WaitForProperty("NewProperty")
                    end
                }
            })

            task.delay(0.2, Workspace.Add, Workspace, {
                NewProperty = {
                    Property = "This is a new property!"
                },
            })

            expect(type(Workspace:GetNewProperty())).to.be.equal("string")
        end)

        it("should timeout while waiting for a property", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(Workspace)

            Workspace:Add({
                NewProperty = {
                    Property = "This is a new property!"
                },

                GetNewProperty = {
                    Method = function(self)
                        return self:WaitForProperty("InvalidNewProperty", 2)
                    end
                }
            })

            expect(type(Workspace.NewProperty)).to.be.equal("string")
            expect(Workspace:GetNewProperty()).to.be.equal(nil)
        end)

        it("should wait for a property with a timeout", function(context)
            local Workspace = WrapperService.new(workspace)
            context.addWrappedInstance(Workspace)

            Workspace:Add({
                GetNewProperty = {
                    Method = function(self)
                        return self:WaitForProperty("NewProperty", 1)
                    end
                }
            })

            task.delay(0.5, Workspace.Add, Workspace, {
                NewProperty = {
                    Property = "This is a new property!"
                },
            })

            expect(type(Workspace:GetNewProperty())).to.be.equal("string")
        end)
    end)
end