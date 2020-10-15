local data = {
	stats = {
		dragonability = {
			attack = 30,
			defense = 40,
			flight = 50,
		},
		magic = {
			fire = 60,
			water = 70,
			earth = 10,
			ice = 20,
			light = 80,
			dark = 90,
		},
		knowledge = {
			world = 50,
			science = 100,
			math = 60,
		},
	},
}

local stateInfo = {}

--[[
args are category, subcategory, sub-subcategory, etc.
returns item = {
	{item1 = value or {table}},
	{item2 = value or table}},
	...
}
--]]
function stateInfo.get(...)
	local ret = data

	for _, category in ipairs{...} do
		ret = ret[category]
		assert(ret, "stateInfo category " .. category .. " not found!")
	end

	return ret
end

function stateInfo.set(value, ...)
	local s = data

	for i = 1, #arg - 1 do
		s = s[ arg[i] ]
		assert(s, "stateInfo category" .. arg[i] .. " not found!")
	end

	s[ arg[#arg] ] = value
end
return stateInfo
