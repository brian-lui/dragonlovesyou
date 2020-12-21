local images = require "images"
local stage = require "stage"

-- the rect where action cards can be played to
-- rect between x1 x2 and y1 y2
local actionRect = {
	x1 = stage.width * 0.75,
	y1 = stage.height * 0.1,
	x2 = stage.width * 0.95,
	y2 = stage.height * 0.75,
}

-- the rect where hand cards can be played to
local handRect = {
	x1 = 0,
	y1 = 0,
	x2 = stage.width,
	y2 = stage.height * 0.6,
}

local cards = {
	comfy = {
		name = "comfy",
		cardImage = images.cardart_comfy,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Super Comfy",
		descriptionText = "Double the next action's relaxation gained",
		actionCost = 1,
		buyCost = 10,
		cardType = "hand",
		releasedRect = handRect,
	},
	hype = {
		name = "hype",
		cardImage = images.cardart_hype,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Hype Up",
		descriptionText = "Gain 2 energy next round",
		actionCost = 1,
		buyCost = 10,
		cardType = "hand",
		releasedRect = handRect,
	},
	shopper = {
		name = "shopper",
		cardImage = images.cardart_shopper,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Avid Shopper",
		descriptionText = "Reset Shop now",
		actionCost = 1,
		buyCost = 10,
		cardType = "hand",
		releasedRect = handRect,
	},
	family = {
		name = "family",
		cardImage = images.cardart_family,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Family Memories",
		descriptionText = "Gain 1 max trust",
		actionCost = 2,
		buyCost = 10,
		cardType = "hand",
		releasedRect = handRect,
	},
	empathy = {
		name = "empathy",
		cardImage = images.cardart_empathy,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Empathy",
		descriptionText = "All empathy doubles next action",
		actionCost = 1,
		buyCost = 10,
		cardType = "hand",
		releasedRect = handRect,
	},
	excitement = {
		name = "excitement",
		cardImage = images.cardart_excitement,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Excitement",
		descriptionText = "Next action will be done with double the energy",
		actionCost = 1,
		buyCost = 10,
		cardType = "hand",
		releasedRect = handRect,
	},
	relax = {
		name = "relax",
		cardImage = images.cardart_relax,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Relaxation",
		descriptionText = "Energy loss halved whole round",
		actionCost = 1,
		buyCost = 10,
		cardType = "hand",
		releasedRect = handRect,
	},

	pyro = {
		name = "pyro",
		cardImage = images.dreamart_pyro,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Pyromancer",
		descriptionText = "Increase fire magic 3 different ways",
		cardType = "dream",
	},
	binge = {
		name = "binge",
		cardImage = images.dreamart_binge,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Binge Watch",
		descriptionText = "Watch TV 4 times",
		cardType = "dream",
	},

	heal = {
		name = "heal",
		cardImage = images.dreamart_heal,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Healing Spell",
		descriptionText = "Practice Healing 2 times",
		cardType = "goal",
	},
	study = {
		name = "study",
		cardImage = images.dreamart_pyro,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_back,
		titleText = "Studious Dragon",
		descriptionText = "Dragon studies while energetic",
		cardType = "goal",
	},

	home_tv = {
		name = "home_tv",
		cardImage = images.actionart_tv,
		titlebackImage = images.actionui_home,
		cardbackImage = images.actionui_back,
		titleText = "Watch TV",
		descriptionText = "Ability\n++Happy   +Trust\n++Empathy",
		buttonText = "Watch TV",
		buttonFont = "MEDIUM",
		actionCost = 2,
		changeHappy = 2,
		changeTrust = 1,
		changeEmpathy = 2,
		submenu = "home",
		cardType = "action",
		releasedRect = actionRect,
	},
	home_nap = {
		name = "home_nap",
		cardImage = images.actionart_nap,
		titlebackImage = images.actionui_home,
		cardbackImage = images.actionui_back,
		titleText = "Nap",
		descriptionText = "Ability\n+Happy   ++Energy\n+Trust",
		buttonText = "Nap",
		buttonFont = "MEDIUM",
		actionCost = 2,
		changeHappy = 1,
		changeEnergy = 2,
		changeTrust = 1,
		submenu = "home",
		cardType = "action",
		releasedRect = actionRect,
	},

	outing_camping = {
		name = "outing_camping",
		cardImage = images.actionart_camping,
		titlebackImage = images.actionui_outing,
		cardbackImage = images.actionui_back,
		titleText = "Camping",
		descriptionText = "Ability\n++Happy   -Energy\n++Trust   ++Fire Magic\n++Empathy",
		buttonText = "Camping",
		buttonFont = "MEDIUM",
		actionCost = 2,
		changeHappy = 2,
		changeEnergy = -1,
		changeTrust = 2,
		changeFireMagic = 2,
		changeEmpathy = 2,
		submenu = "outing",
		cardType = "action",
		releasedRect = actionRect,
	},
	outing_ant = {
		name = "outing_ant",
		cardImage = images.actionart_ant,
		titlebackImage = images.actionui_outing,
		cardbackImage = images.actionui_back,
		titleText = "Magnify Ants",
		descriptionText = "Ability\n++Happy   +++Fire Magic\n-Environment",
		buttonText = "Magnify Ants",
		buttonFont = "MEDIUM",
		actionCost = 2,
		changeHappy = 2,
		changeFireMagic = 2,
		changeEnvironment = -1,
		submenu = "outing",
		cardType = "action",
		releasedRect = actionRect,
	},

	library_globe = {
		name = "library_globe",
		cardImage = images.actionart_globe,
		titlebackImage = images.actionui_library,
		cardbackImage = images.actionui_back,
		titleText = "World History",
		descriptionText = "Ability\n--Energy   -Trust",
		buttonText = "World History",
		buttonFont = "MEDIUM",
		actionCost = 2,
		changeEnergy = -2,
		changeTrust = -1,
		submenu = "library",
		cardType = "action",
		releasedRect = actionRect,
	},
	library_healspell = {
		name = "library_healspell",
		cardImage = images.actionart_healspell,
		titlebackImage = images.actionui_library,
		cardbackImage = images.actionui_back,
		titleText = "Healing Spells",
		descriptionText = "Ability\n--Energy   -Trust\n++++++Healing Magic",
		buttonText = "Healing Spells",
		buttonFont = "MEDIUM",
		actionCost = 2,
		changeEnergy = -2,
		changeTrust = -1,
		changeHealingMagic = 6,
		submenu = "library",
		cardType = "action",
		releasedRect = actionRect,
	},

	battleground_fly = {
		name = "battleground_fly",
		cardImage = images.actionart_fly,
		titlebackImage = images.actionui_battleground,
		cardbackImage = images.actionui_back,
		titleText = "Practice Flying",
		descriptionText = "Ability\n--Energy   ++++++Flight",
		buttonText = "Practice Flying",
		buttonFont = "MEDIUM",
		actionCost = 2,
		changeEnergy = -2,
		changeFlying = 6,
		submenu = "battleground",
		cardType = "action",
		releasedRect = actionRect,
	},
	battleground_fire = {
		name = "battleground_fire",
		cardImage = images.actionart_fire,
		titlebackImage = images.actionui_battleground,
		cardbackImage = images.actionui_back,
		titleText = "Fire Breathing",
		descriptionText = "Ability\n----Energy   -Trust\n++++++Fire Magic",
		buttonText = "Fire Breathing",
		buttonFont = "MEDIUM",
		actionCost = 2,
		changeEnergy = -2,
		changeTrust = -1,
		changeFireMagic = 6,
		submenu = "battleground",
		cardType = "action",
		releasedRect = actionRect,
	},

	shop_buybuybuy = {
		name = "buybuybuy",
		cardImage = images.cardart_idea,
		titlebackImage = images.actionui_shop,
		cardbackImage = images.actionui_back,
		titleText = "Buy Buy Buy",
		descriptionText = "Ability\n+++Fire",
		buttonText = "Buy Buy Buy",
		buttonFont = "MEDIUM",
		submenu = "shop",
		releasedRect = actionRect,
	},
	shop_sellsellsell = {
		name = "sellsellsell",
		cardImage = images.cardart_idea,
		titlebackImage = images.actionui_shop,
		cardbackImage = images.actionui_back,
		titleText = "Sell Sell Sell",
		descriptionText = "Ability\n+++Fire",
		buttonText = "Sell Sell Sell",
		buttonFont = "MEDIUM",
		submenu = "shop",
		releasedRect = actionRect,
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