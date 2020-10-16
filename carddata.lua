local images = require "images"

local cards = {
	meditate = {
		name = "meditate",
		cardImage = images.cardart_idea,
		titlebackImage = images.cardui_title,
		cardbackImage = images.cardui_beige,
		titleText = "Meditate",
		descriptionText = "Ability\n+Attack   +Defense\n-Happy   -Energy",
	}
}



local cardData = {}

function cardData.getCard(cardname)
	assert(cards[cardname], "No such requested card " .. cardname .. "!")

	return cards[cardname]
end

return cardData
