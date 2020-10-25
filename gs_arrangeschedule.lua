--[[
	This is the gamestate module for the arranging the dragon's schedule for
	the week (?)
--]]

local common = require "class.commons"
local spairs = require "/helpers/utilities".spairs
local assetData = require "assetdata"
local cardData = require "carddata"
local stateInfo = require "stateinfo"
local stage = require "stage"
local Pic = require 'pic'
local images = require "images"

local ArrangeSchedule = {name = "ArrangeSchedule"}

-- refer to game.lua for instructions for createButton and createImage
function ArrangeSchedule:createButton(params)
	return game:_createButton(ArrangeSchedule, params)
end

function ArrangeSchedule:createDraggable(params)
	return game:_createDraggable(ArrangeSchedule, params)
end

function ArrangeSchedule:createImage(params)
	return game:_createImage(ArrangeSchedule, params)
end

function ArrangeSchedule:createText(params)
	return game:_createText(ArrangeSchedule, params)
end

local imageData = assetData.getImages("ArrangeSchedule")
local buttonData = assetData.getButtons("ArrangeSchedule")
local draggableData = assetData.getDraggables("ArrangeSchedule")
local textData = assetData.getText("ArrangeSchedule")

function ArrangeSchedule:init()
	ArrangeSchedule.ui = {
		clickable = {},
		draggable = {},
		static = {},
		text = {},
	}

	for _, data in pairs(imageData) do
		ArrangeSchedule.createImage(self, data)
	end

	for _, data in pairs(buttonData) do
		ArrangeSchedule.createButton(self, data)
	end

	for _, data in pairs(draggableData) do
		ArrangeSchedule.createDraggables(self, data)
	end

	for _, data in pairs(textData) do
		ArrangeSchedule.createText(self, data)
	end

	ArrangeSchedule.currentBackground = common.instance(self.background.library, self)
end

function ArrangeSchedule:enter()
	self.controls.clicked = nil
	if self.sound:getCurrentBGM() ~= "mainBGM" then
		self.sound:stopBGM()
		self.queue:add(45, self.sound.newBGM, self.sound, "mainBGM", true)
	end

	self.shownSubscreen = false

	local categories = {
		progress = true,
		dragongoal = true,
		dragondream = true,
		cardcloseup = true,
	}

	for _, tbl in pairs(ArrangeSchedule.ui) do
		for _, t in pairs(tbl) do
			if categories[t.category] then t.transparency = 0 end
		end
	end

	for _, t in pairs(ArrangeSchedule.ui.clickable) do
		if categories[t.category] then t.clickable = false end
	end

	ArrangeSchedule:createHand(3)
end

function ArrangeSchedule:_showSubscreen(subscreenName)
	if not self.shownSubscreen then
		self.shownSubscreen = subscreenName

		for _, tbl in pairs(self.ui) do
			for _, t in pairs(tbl) do
				if t.category == subscreenName then t.transparency = 1 end
			end
		end

		for _, t in pairs(self.ui.clickable) do
			t.clickable = (t.category == subscreenName)
		end

	end
end

function ArrangeSchedule:_hideSubscreen(subscreenName)
	if self.shownSubscreen == subscreenName then
		self.shownSubscreen = false

		for _, tbl in pairs(self.ui) do
			for _, t in pairs(tbl) do
				if t.category == subscreenName then t.transparency = 0 end
			end
		end

		for _, t in pairs(self.ui.clickable) do
			if t.category == subscreenName then
				t.clickable = false
			elseif not t.category then
				t.clickable = true
			end
		end
	end
end

function ArrangeSchedule:showDragonGoal()
	self:_showSubscreen("dragongoal")

	self.ui.clickable.dragongoal.imageIndex = 2
	self.ui.clickable.dragongoal.clickable = false

	self.ui.clickable.dragongoal:change{
		duration = 15,
		scaling = 1,
		x = stage.width * 0.3,
		y = stage.height * 0.5,
	}
end

function ArrangeSchedule:hideDragonGoal()
	self:_hideSubscreen("dragongoal")

	local original = assetData.getItem("ArrangeSchedule", "buttons", "dragongoal")

	self.ui.clickable.dragongoal:change{
		duration = 15,
		scaling = 0.2,
		x = original.endX,
		y = original.endY,
		exitFunc = function()
			self.ui.clickable.dragongoal.imageIndex = original.imageIndex
			self.ui.clickable.dragongoal.clickable = true
		end,
	}
end

function ArrangeSchedule:showDragonDream()
	self:_showSubscreen("dragondream")

	self.ui.clickable.dragondream.imageIndex = 2
	self.ui.clickable.dragondream.clickable = false

	self.ui.clickable.dragondream:change{
		duration = 15,
		scaling = 1,
		x = stage.width * 0.3,
		y = stage.height * 0.5,
	}
end

function ArrangeSchedule:hideDragonDream()
	self:_hideSubscreen("dragondream")

	local original = assetData.getItem("ArrangeSchedule", "buttons", "dragondream")

	self.ui.clickable.dragondream:change{
		duration = 15,
		scaling = 0.2,
		x = original.endX,
		y = original.endY,
		exitFunc = function()
			self.ui.clickable.dragondream.imageIndex = original.imageIndex
			self.ui.clickable.dragondream.clickable = true
		end,
	}
end

local pbstats = {
	{"dragonability", "attack"},
	{"dragonability", "defense"},
	{"dragonability", "flight"},
	{"magic", "fire"},
	{"magic", "water"},
	{"magic", "earth"},
	{"magic", "ice"},
	{"magic", "light"},
	{"magic", "dark"},
	{"knowledge", "world"},
	{"knowledge", "science"},
	{"knowledge", "math"},
}

function ArrangeSchedule:showProgressBook()
	self:_showSubscreen("progress")

	for _, stat in ipairs(pbstats) do
		local value = stateInfo.get("stats", stat[1], stat[2])
		local blockback = self.ui.static[ "pb_blockback_" .. stat[2] ]

		local p = ArrangeSchedule.createImage(self, {
			name = "pb_statbar_" .. stat[2],
			image = blockback.extraInfo.meterImage,
			endX = blockback.x - stage.width * 0.025,
			endY = blockback.y,
			imageIndex = 2,
			category = "progress",
		})

		p:change{
			duration = value * 0.5,
			easing = "outCubic",
			quad = {
				x = true,
				percentageX = value * 0.01,
				anchorX = "left",
				cropFromX = "right",
			},
		}
	end
end

function ArrangeSchedule:hideProgressBook()
	self:_hideSubscreen("progress")

	for _, stat in ipairs(pbstats) do
		self.ui.static["pb_statbar_" .. stat[2] ] = nil
	end
end

function ArrangeSchedule:showCard(card)
	self:_showSubscreen("cardcloseup")

	card.originalX = card.x
	card.originalY = card.y
	card.originalScaling = card.scaling
	card.originalRotation = card.rotation

	card.imageIndex = 2
	card:change{duration = 10,
		rotation = 0,
		scaling = 1,
		x = stage.width * 0.35,
		y = stage.height * 0.5,
	}

	ArrangeSchedule.createText(self, {
		name = "titleText",
		font = "BIG",
		text = card.titleText,
		x = stage.width * 0.3,
		y = stage.height * 0.1,
		imageIndex = 2,
	})

	ArrangeSchedule.createText(self, {
		name = "descriptionText",
		font = "MEDIUM",
		text = card.descriptionText,
		x = stage.width * 0.6,
		y = stage.height * 0.6,
		imageIndex = 2,
	})
end

function ArrangeSchedule:hideCard(card)
	self:_hideSubscreen("cardcloseup")
	card:change{
		duration = 10,
		rotation = card.originalRotation,
		scaling = card.originalScaling,
		x = card.originalX,
		y = card.originalY,
	}

	card.originalX = nil
	card.originalY = nil
	card.originalScaling = nil
	card.originalRotation = nil

	card.imageIndex = -1

	self.ui.text.titleText = nil
	self.ui.text.descriptionText = nil
end


function ArrangeSchedule:createHand(totalCards)
	for i = 1, totalCards do
		local cardName = stateInfo.popDeckCard(game.rng)
		local data = cardData.getCardInfo(cardName)
		local loc = cardData.getCardPosition(i, totalCards)

		data.x = loc.x
		data.y = loc.y
		data.rotation = loc.rotation
		data.scaling = 0.2

		ArrangeSchedule.createCard(self, data)
	end
end

function ArrangeSchedule:discardHand()
	local toDelete = {}
	for _, item in pairs(self.ui.draggable) do
		if item.category == "card" then
			stateInfo.addDeckCard(item.stateDataName)
			toDelete[#toDelete + 1] = item
		end
	end

	for _, item in pairs(toDelete) do item:remove() end
end

-- mandatory: name, cardImage, cardbackImage, titlebackImage, titleText, descriptionText, x, y
-- optional: scaling, longpressFunc, releasedFunc
function ArrangeSchedule:createCard(params)
	assert(params.name, "No card name given!")
	assert(params.cardImage, "No card image given!")
	assert(params.cardbackImage, "No cardback image given!")
	assert(params.titlebackImage, "No titleback image given!")
	assert(params.descriptionText, "No description text given!")
	assert(params.titleText, "No title text given!")
	assert(params.x and params.y, "No card x or y given!")

	stateInfo.addHandCard(params.name)

	local cardHandle = params.name
	while ArrangeSchedule.ui.draggable[cardHandle] do
		cardHandle = cardHandle .. "_"
	end

	local card = ArrangeSchedule.createDraggable(self, {
		name = cardHandle,
		image = params.cardbackImage,
		endX = params.x,
		endY = params.y,
		endScaling = params.scaling,
		imageIndex = -1,
		category = "card",
	})

	card.rotation = params.rotation
	card.titlebackImage = params.titlebackImage
	card.cardImage = params.cardImage
	card.titleText = params.titleText
	card.descriptionText = params.descriptionText
	card.stateDataName = params.name

	card.longpressFunc = function(_card) ArrangeSchedule:showCard(_card) end

	card.releasedFunc = function(_card)
		if _card.longpressed then
			ArrangeSchedule:hideCard(_card)
		elseif _card.dragged then
			-- if released over the schedule area then
			-- else snap back
		end
	end

	card.draw = function(_self)
		Pic.draw(_self)
		Pic.draw(_self, {image = _self.cardImage})
		Pic.draw(_self, {image = _self.titlebackImage})
		-- if longpressed then
			-- draw descriptionBackground, draw titleTextObject,  draw descriptionTextObject
		-- end
	end

	return card
end


function ArrangeSchedule:update(dt)
	ArrangeSchedule.currentBackground:update(dt)
	for _, tbl in pairs(ArrangeSchedule.ui) do
		for _, v in pairs(tbl) do v:update(dt) end
	end
end

function ArrangeSchedule:draw()
	local indexes = {-3, -2, -1, 0, 1, 2, 3}

	for _, i in ipairs(indexes) do
		for _, tbl in spairs(ArrangeSchedule.ui) do
			for _, v in spairs(tbl) do
				if v.imageIndex == i then
					v:draw()
				end
			end
		end
	end

	self.particles:draw()
end

-- add custom things to these three functions
function ArrangeSchedule:_pressed(x, y)
	self.particles:create("Example", x, y)

	self:_controllerPressed(x, y, ArrangeSchedule)
end

function ArrangeSchedule:_released(x, y)
	self:_controllerReleased(x, y, ArrangeSchedule)
end

function ArrangeSchedule:_moved(x, y)
	self:_controllerMoved(x, y, ArrangeSchedule)
end

function ArrangeSchedule:mousepressed(x, y) ArrangeSchedule._pressed(self, x, y) end
function ArrangeSchedule:touchpressed(_, x, y) ArrangeSchedule._pressed(self, x, y) end

function ArrangeSchedule:mousereleased(x, y) ArrangeSchedule._released(self, x, y) end
function ArrangeSchedule:touchreleased(_, x, y) ArrangeSchedule._released(self, x, y) end

function ArrangeSchedule:mousemoved(x, y) ArrangeSchedule._moved(self, x, y) end
function ArrangeSchedule:touchmoved(_, x, y) ArrangeSchedule._moved(self, x, y) end

return ArrangeSchedule
