--[[
	This is the gamestate module for the arranging the dragon's schedule for
	the week (?)
--]]

local common = require "class.commons"
local spairs = require "/helpers/utilities".spairs
local assetData = require "assetdata"
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

	local categories = {progress = true, dragongoal = true, dragondream = true}

	for _, tbl in pairs(ArrangeSchedule.ui) do
		for _, t in pairs(tbl) do
			if categories[t.category] then t.transparency = 0 end
		end
	end

	for _, t in pairs(ArrangeSchedule.ui.clickable) do
		if categories[t.category] then t.clickable = false end
	end

	local images = require "images"
	local test = ArrangeSchedule.createCard(self, {
		name = "testcard",
		cardBack = images.cardui_beige,
		cardTitle = images.cardui_title,
		x = stage.width * 0.5,
		y = stage.height * 0.8,
		scaling = 0.2,
		longpressFunc = function(card)
			card:change{duration = 30, scaling = 1}
		end,
		releasedFunc = function(card)
			card:change{duration = 30, scaling = 0.2}
		end,
	})
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
		x = stage.width * 0.4,
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
		x = stage.width * 0.4,
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
		local x = self.ui.static["pb_bar_" .. stat[2]].x
		local y = self.ui.static["pb_bar_" .. stat[2]].y
		local image = images.gui_stats_blue

		ArrangeSchedule.createImage(self, {
			name = "pb_statbar_" .. stat[2],
			image = image,
			duration = 20,
			endX = x,
			endY = y,
			easing = "linear",
			imageIndex = 1,
			category = "progress",
		})
	end
end

function ArrangeSchedule:hideProgressBook()
	self:_hideSubscreen("progress")

	for _, stat in ipairs(pbstats) do
		self.ui.static["pb_statbar_" .. stat[2] ] = nil
	end
end

-- mandatory: name, cardBack, cardTitle, x, y
-- optional: scaling, longpressFunc, releasedFunc
function ArrangeSchedule:createCard(params)
	assert(params.name, "No card name given!")
	assert(params.cardBack, "No cardback image given!")
	assert(params.cardTitle, "No card title image given!")
	assert(params.x and params.y, "No card x or y given!")

	local card = ArrangeSchedule.createDraggable(self, {
		name = params.name,
		image = params.cardBack,
		endX = params.x,
		endY = params.y,
		endScaling = params.scaling,
	})

	card.imageTitle = params.cardTitle
	card.longpressFunc = params.longpressFunc or function(clickedObject) end
	card.releasedFunc = params.releasedFunc or function(clickedObject) end

	card.draw = function(_self)
		Pic.draw(_self)
		Pic.draw(_self, {image = _self.imageTitle})
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
	ArrangeSchedule.currentBackground:draw()

	local indexes = {-3, -2, -1, 0, 1, 2}

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
