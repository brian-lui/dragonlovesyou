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
}



local cardData = {}

function cardData.getCard(cardname)
	assert(cards[cardname], "No such requested card " .. cardname .. "!")

	return cards[cardname]
end

function cardData.getCardPosition(pos, totalCards)
	local mid = (totalCards + 1) * 0.5
	local spacingX = {0, 0.15, 0.1, 0.08, 0.07}
	local spacingY = {0, 0.05, 0.05, 0.05, 0.05}
	local spacingRotation = {0, 0.1, 0.08, 0.06, 0.05, 0.04}

	local x = stage.width * (0.5 + (pos - mid) * spacingX[totalCards])
	local y = stage.height * (0.75 + math.abs(pos - mid) * spacingY[totalCards])
	local rotation = (pos - mid) * math.pi * spacingRotation[totalCards]

	return {x = x, y = y, rotation = rotation}
end

return cardData