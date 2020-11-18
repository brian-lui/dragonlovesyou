local data = {
	energy = 30,
	happy = 10,
	love = 60,
	money = 3,
	action = 5,

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
	},

	hand = {
	},

	actions = {
		home = {
			[1] = {
				buttonText = "Watch TV",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Watch TV",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
			[2] = {
				buttonText = "Poop",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Poop",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
			[3] = {
				buttonText = "Play Videogames",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Play Videogames",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
			[4] = {
				buttonText = "Meditate",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Meditate",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
		},
		outing = {
			[1] = {
				buttonText = "Picnic",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Picnic",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
			[2] = {
				buttonText = "Sonic Boom",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Sonic Boom",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
		},
		library = {
			[1] = {
				buttonText = "Nerd Stuff",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Nerd Stuff",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
			[2] = {
				buttonText = "Learn MMA",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Learn MMA",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
		},
		battleground = {
			[1] = {
				buttonText = "Fight kobold",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Fight kobold",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
		},
		shop = {
			[1] = {
				buttonText = "Buy buy buy",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Buy buy buy",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
			[2] = {
				buttonText = "Sell sell sell",
				cardImageName = "cardart_idea",
				titlebackImageName = "cardui_title",
				cardbackImageName = "cardui_beige",
				titleText = "Sell sell sell",
				descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
			},
		},
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

-- general set for if there's no specific thingy
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

function stateInfo.addHandCard(cardName)
	data.hand[#data.hand + 1] = cardName
end

function stateInfo.popHandCard(gameRng)
	local rand = gameRng:random(#data.hand)
	local card = table.remove(data.hand, rand)
	return card
end

function stateInfo.addDeckCard(cardName)
	data.deck[#data.deck + 1] = cardName
end

function stateInfo.popDeckCard(gameRng)
	local rand = gameRng:random(#data.deck)
	local card = table.remove(data.deck, rand)
	return card
end

return stateInfo
