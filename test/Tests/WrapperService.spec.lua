return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local WrapperService
    local Signal
    
    local _success, Packages: any = pcall(function()
        return ReplicatedStorage:FindFirstChild("Packages")
    end)

    if Packages then
        Signal = require(Packages._Index["zxibs_wrapperservice"]["wrapperservice"]:FindFirstChild("Utilities"):FindFirstChild("Signal"))
        WrapperService = require(Packages.WrapperService)
    else   
        Signal = require(ReplicatedStorage:FindFirstChild("WrapperService"):FindFirstChild("Utilities"):FindFirstChild("Signal"))
        WrapperService = require(ReplicatedStorage:FindFirstChild("WrapperService"))
    end

    describe("Is", function()
        it("should return true", function()
            local boolean = WrapperService:Is(WrapperService:Create(workspace))

            expect(boolean).to.be.equal(true)
        end)

        it("should return false and an error message", function()
            local boolean, message = WrapperService:Is({})

            expect(boolean).to.be.equal(false)
            expect(type(message)).to.be.equal("string")
        end)
    end)

    describe("Clean", function()
        it("should destroy the WrappedInstance and return the instance that was passed in :Create", function()
            local Workspace = WrapperService:Create(workspace)
            local Index = Workspace._Index

            Workspace = Workspace:Clean()

            expect(Workspace).to.be.equal(workspace)
            expect(WrapperService:Is(Workspace)).to.be.equal(false)
            expect(WrapperService.Instances[Index]).to.be.equal(nil)
        end)

        it("should destroy the WrappedInstance and shift index", function()
            local Workspace = WrapperService:Create(workspace)
            local otherWorkspace = WrapperService:Create(workspace)

            local lastIndex = otherWorkspace._Index

            Workspace = Workspace:Clean()
            
            expect(type(table.find(WrapperService.Instances, otherWorkspace))).to.be.equal("number")
            expect(otherWorkspace._Index == (lastIndex - 1)).to.be.equal(true)
        end)

        it("should destroy the WrappedInstance and disconnect all signals", function()
            local Workspace = WrapperService:Create(workspace)

            local Connection = Workspace.Called:Connect(function() end)
            local Connection1 = Workspace.Changed:Connect(function() end)

            Workspace:Clean()

            expect(Connection.Connected).to.be.equal(false)
            expect(Connection1.Connected).to.be.equal(false)
        end)
    end)
    
    describe("Create", function()
        it("should create a WrappedInstance", function(context)
            local Workspace = WrapperService:Create(workspace)
            context.addWrappedInstance(workspace)

            expect(WrapperService:Is(Workspace)).to.be.equal(true)
        end)

        it("should connect to an event", function(context)
            local Workspace = WrapperService:Create(workspace)
            context.addWrappedInstance(Workspace)

            local event
            event = Workspace.ChildAdded:Connect(function() end)
            
            event:Disconnect()

            expect(typeof(event)).to.be.equal("RBXScriptConnection")
        end)

        it("should return the name as Workspace", function(context)
            local Workspace = WrapperService:Create(workspace)
            context.addWrappedInstance(Workspace)

            expect(Workspace.Name).to.be.equal("Workspace")
        end)

        it("should modify the gravity to 1", function(context)
            local Workspace = WrapperService:Create(workspace)

            context.addWrappedInstance(Workspace)
            context.addRevertableChanges("Gravity", {
                instance = Workspace._Instance,
                previousValue = Workspace.Gravity
            })

            Workspace.Gravity = 1
            expect(Workspace.Gravity).to.be.equal(1)
        end)

        it("should correctly call a method", function(context)
            local Workspace = WrapperService:Create(workspace)
            context.addWrappedInstance(Workspace)

            local children = Workspace:GetChildren()
            
            expect(type(children)).to.be.equal("table")
        end)
    end)

    describe("GetByIndex", function()
        it("should return a WrappedInstance", function(context)
            local Workspace = WrapperService:Create(workspace)
            context.addWrappedInstance(Workspace)

            Workspace = WrapperService:GetByIndex(Workspace._Index)

            expect(WrapperService:Is(Workspace)).to.be.equal(true)
        end)
    end)

    describe("GetByInstance", function()
        it("should return a WrappedInstance", function(context)
            local Workspace = WrapperService:Create(workspace)
            context.addWrappedInstance(Workspace)

            Workspace = WrapperService:GetByInstance(workspace)

            expect(WrapperService:Is(Workspace)).to.be.equal(true)
        end)
    end)

    describe("Add", function()
        it("should make a new property and a method", function(context)
            local Workspace = WrapperService:Create(workspace)
            context.addWrappedInstance(Workspace)

            Workspace:Add({
                NewProperty = {
                    Property = "This is a new property!"
                },

                GetInteger = {
                    Method = function(self)
                        return self._Index
                    end
                }
            })

            expect(Workspace.NewProperty).to.be.equal("This is a new property!")
            expect(type(Workspace:GetInteger())).to.be.equal("number")
        end)

        it("should make a new signal", function(context)
            local Workspace = WrapperService:Create(workspace)
            context.addWrappedInstance(Workspace)

            Workspace:Add({
                AutomaticEvent = {
                    Event = function() end
                }
            })

            expect(Signal.Is(Workspace.AutomaticEvent)).to.be.equal(true)
        end)
    end)

    describe("Called", function()
        it("should fire with arguments when calling a prototype method", function()
            local Workspace = WrapperService:Create(workspace)
            local methodString

            Workspace.Called:Connect(function(methodKey, self)
                methodString = tostring(methodKey)
                Workspace = self
            end)

            Workspace:Clean()

            expect(methodString).to.be.equal("Clean")
            expect(WrapperService:Is(Workspace)).to.be.equal(false)
        end)

        it("should fire with arguments when calling an instance method", function(context)
            local Workspace = WrapperService:Create(workspace)
            local methodString
            context.addWrappedInstance(Workspace)

            Workspace.Called:Connect(function(methodKey, self)
                methodString = tostring(methodKey)
                Workspace = self
            end)

            Workspace:GetChildren()

            expect(methodString).to.be.equal("GetChildren")
            expect(Workspace).to.be.equal(workspace)
        end)

        it("should fire with arguments when calling a custom method", function(context)
            local Workspace = WrapperService:Create(workspace)
            local methodString
            context.addWrappedInstance(Workspace)

            Workspace:Add({
                GetInteger = {
                    Method = function(self)
                        return self._Index
                    end
                }
            })

            Workspace.Called:Connect(function(methodKey, self)
                methodString = tostring(methodKey)
                Workspace = self
            end)

            Workspace:GetInteger()

            expect(methodString).to.be.equal("GetInteger")
            expect(WrapperService:Is(Workspace)).to.be.equal(true)
        end)
    end)

    describe("Changed", function()
        it("should fire with arguments when a public property has changed", function(context)
            local Workspace = WrapperService:Create(workspace)
            local propertyName, lastValue, newValue
            context.addWrappedInstance(Workspace)

            Workspace.Changed:Connect(function(propertyKey, last, new)
                propertyName = tostring(propertyKey)
                lastValue = last
                newValue = new
            end)

            Workspace:Add({
                NewProperty = {
                    Property = "This is a new property!"
                },
            })

            Workspace.NewProperty = "This property was changed!"

            expect(lastValue).to.be.equal("This is a new property!")
            expect(newValue).to.be.equal("This property was changed!")
            expect(propertyName).to.be.equal("NewProperty")
        end)

        it("should fire with arguments when a instance property has changed", function(context)
            local Workspace = WrapperService:Create(workspace)
            local propertyName, lastValue, newValue
            local previousValue
            context.addWrappedInstance(Workspace)

            previousValue = Workspace.FallenPartsDestroyHeight

            context.addRevertableChanges({
                Instance = Workspace._Instance,
                previousValue = previousValue
            })

            Workspace.Changed:Connect(function(propertyKey, last, new)
                propertyName = tostring(propertyKey)
                lastValue = last
                newValue = new
            end)

            Workspace.FallenPartsDestroyHeight = -50

            expect(lastValue).to.be.equal(previousValue)
            expect(newValue).to.be.equal(-50)
            expect(propertyName).to.be.equal("FallenPartsDestroyHeight")
        end)
    end)
end