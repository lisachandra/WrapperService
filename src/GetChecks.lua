local t = require(script.Parent.t)

local VALUE_TYPES = {
	Property = "any",
	Method = "callback",
	Event = "callback",
}

local function GetKeysFromTable(table)
    local keys: string = ""

    for key, _value in pairs(table) do
        keys = keys .. tostring(key) .. ", "
    end

    return keys:sub(1, #keys - 2)
end

local function IsClass(Class, FunctionName)
    return function(self)
        local isTable, message = t.table(self)

        if not isTable then
            return false, message
        end

        if self ~= Class then
            return false, ("Expected ':' not '.' while calling member function %s"):format(FunctionName)
        end

        return true
    end
end

local function IsObjectOfClass(Class, ObjectName)
    return function(Object)
        return (
            type(Object) == "table"
            and getmetatable(Object) == Class
        ) or false, ("Expected %s got %s"):format(ObjectName, typeof(Object))
    end
end

local function GetChecks(WrapperService)
    local IsWrappedInstance = IsObjectOfClass(WrapperService, "WrappedInstance")
    local IsWrapperService = IsClass(WrapperService, "Is")

    local Checks = {
        new = t.tuple(t.Instance),

        Is = t.tuple(IsWrapperService, t.any),
        GetByIndex = t.tuple(IsWrapperService, t.integer),
        GetByInstance = t.tuple(IsWrapperService, t.Instance),

        Clean = t.tuple(IsWrappedInstance),
        WaitForProperty = t.tuple(IsWrappedInstance, t.any, t.optional(t.number)),
        Add = t.tuple(IsWrappedInstance, t.map(t.any, function(properties)
            for valueType: string in pairs(properties) do
                if VALUE_TYPES[valueType] then
                    return t.interface({
                        [valueType] = t[VALUE_TYPES[valueType]],
                    })(properties)
                else
                    return false, ("field ValueType expected, got %s \nValid ValueTypes: %s"):format(
                        tostring(valueType),
                        GetKeysFromTable(VALUE_TYPES)
                    )
                end
            end
        end)),
    }

    return Checks
end

return GetChecks
