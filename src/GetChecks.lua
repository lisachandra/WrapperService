local t = require(script.Parent.Utilities.t)

local EXPECTED = "%s expected, got %s"

local function IsClassOrService(ClassOrService, Name)
	return function(OtherClassOrService)
		local isTable, errorMsg = t.table(OtherClassOrService)

		if isTable then
			if OtherClassOrService == ClassOrService then
				return true
			else
				return false, EXPECTED:format(Name, typeof(OtherClassOrService))
			end
		else
			return false, errorMsg
		end
	end
end

local function IsObjectOfServiceOrClass(ClassOrService, Name)
	return function(Object)
		return (type(Object) == "table" and getmetatable(Object) == ClassOrService) or false,
			EXPECTED:format(Name, typeof(Object))
	end
end

local function GetChecks(ClassOrService, IsService)
	if IsService then
		local IsWrapperService = IsClassOrService(ClassOrService, "WrapperService")

		local Checks = {
			GetByInstance = t.tuple(IsWrapperService, t.Instance),
			GetByIndex = t.tuple(IsWrapperService, t.integer),
			Create = t.tuple(IsWrapperService, t.Instance),
			Is = t.tuple(IsWrapperService, t.any),
		}

		return Checks
	else
		local IsWrappedInstance = IsObjectOfServiceOrClass(ClassOrService, "WrappedInstance")

		local Checks = {
			Clean = t.tuple(IsWrappedInstance),
			Add = t.tuple(
				IsWrappedInstance,
				t.map(
					t.any,
					t.union(
						t.strictInterface({
							Property = t.any,
						}),
						t.strictInterface({
							Method = t.callback,
						}),
						t.strictInterface({
							Event = t.callback,
						})
					)
				)
			),
		}

		return Checks
	end
end

return GetChecks
