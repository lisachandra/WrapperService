local t = require(script.Parent.t)

local EXPECTED = "%s expected, got %s"

local function IsObjectOfClass(Class, ObjectName)
    return function(Object)
        return (
            type(Object) == "table"
            and getmetatable(Object) == Class
        ) or false, EXPECTED:format(ObjectName, typeof(Object))
    end
end

local function GetChecks(ClassOrService, IsService)
    if IsService then
        local Checks = {
            new = t.tuple(t.Instance),
            Is = t.tuple(t.any),
            GetByIndex = t.tuple(t.integer),
            GetByInstance = t.tuple(t.Instance),
        }

        return Checks
    end

    local IsWrappedInstance = IsObjectOfClass(ClassOrService, "WrappedInstance")

    local Checks = {
        Clean = t.tuple(IsWrappedInstance),
        WaitForProperty = t.tuple(IsWrappedInstance, t.any, t.optional(t.number)),
        Add = t.tuple(IsWrappedInstance, t.map(t.any, t.union(t.strictInterface({
            Property = t.any,
        }), t.strictInterface({
            Method = t.callback,
        }), t.strictInterface({
            Event = t.callback,
        })))),
    }

    return Checks
end

return GetChecks
