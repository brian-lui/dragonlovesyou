local images = require "images"
local stage = require "stage"

local cards = {
	meditate = {
		name = "meditate",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Meditate",
		descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
	},
	sleep = {
		name = "sleep",
		cardImage = images.cardart_sleepydragon,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Sleep",
		descriptionText = "Ability\n+Energy   +Happy\n-Light   -Fire",
	},
	fireball = {
		name = "fireball",
		cardImage = images.cardart_magic,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Fireball!",
		descriptionText = "Ability\n+++Fire",
	},

	home_watchTV = {
		name = "watchtv",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Watch TV",
		descriptionText = "Ability\n+++Fire",
		submenu = "home",
	},
	home_poop = {
		name = "poop",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Poop",
		descriptionText = "Ability\n+++Fire",
		submenu = "home",
	},
	home_videogames = {
		name = "videogames",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Play Videogames",
		descriptionText = "Ability\n+++Fire",
		submenu = "home",
	},
	home_meditate = {
		name = "meditate",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Watch TV",
		descriptionText = "Ability\n+++Fire",
		submenu = "home",
	},

	outing_picnic = {
		name = "picnic",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Picnic",
		descriptionText = "Ability\n+++Fire",
		submenu = "outing",
	},
	outing_sonicboom = {
		name = "sonicboom",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Sonic Boom!",
		descriptionText = "Ability\n+++Fire",
		submenu = "outing",
	},

	library_nerdstuff = {
		name = "nerdstuff",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Nerd Stuff",
		descriptionText = "Ability\n+++Fire",
		submenu = "library",
	},
	library_learnMMA = {
		name = "learnMMA",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Learn MMA",
		descriptionText = "Ability\n+++Fire",
		submenu = "library",
	},

	battleground_fightkobold = {
		name = "fightkobold",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Fight Kobold",
		descriptionText = "Ability\n+++Fire",
		submenu = "battleground",
	},

	shop_buybuybuy = {
		name = "buybuybuy",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Buy Buy Buy",
		descriptionText = "Ability\n+++Fire",
		submenu = "shop",
	},
	shop_sellsellsell = {
		name = "sellsellsell",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Sell Sell Sell",
		descriptionText = "Ability\n+++Fire",
		submenu = "shop",
	},
}



local cardData = {}

function cardData.getCardInfo(cardname)
	assert(cards[cardname], "No such requested card " .. cardname .. "!")

	return cards[cardname]
end

function cardData.getCardPosition(pos, totalCards)
	local mid = (totalCards + 1) * 0.5
	local spacingX = {0.1, 0.1, 0.1, 0.1, 0.09}
	local spacingY = {0.7, 0.06, 0.05, 0.04, 0.02}
	local spacingRotation = {0.12, 0.1, 0.08, 0.06, 0.05, 0.04}

	local x = stage.width * (0.5 + (pos - mid) * spacingX[totalCards])
	local y = stage.height * (0.85 + math.abs(pos - mid) * spacingY[totalCards])
	local rotation = (pos - mid) * math.pi * spacingRotation[totalCards]

	return {x = x, y = y, rotation = rotation}
end

return cardData