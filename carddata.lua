local images = require "images"

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

return cardData
