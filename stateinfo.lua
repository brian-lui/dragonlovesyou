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
	deck = {
		"meditate",
		"meditate",
		"meditate",
		"sleep",
		"fireball",
	}
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
	local args = {...}
	local ret = data

	for _, category in ipairs(args) do
		ret = ret[category]
		assert(ret, "stateInfo category " .. category .. " not found!")
	end

	return ret
end

function stateInfo.set(value, ...)
	local args = {...}
	local set = data

	for i = 1, #args - 1 do
		set = set[ args[i] ]
		assert(set, "stateInfo category" .. args[i] .. " not found!")
	end

	if type(set[ args[#args] ]) == "table" then
		assert(type(value) == "table", "tried to write non-table to table!")
	end

	set[ args[#args] ] = value
end
return stateInfo
