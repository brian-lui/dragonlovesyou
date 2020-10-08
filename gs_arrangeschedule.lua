--[[
	This is the gamestate module for the arranging the dragon's schedule for
	the week (?)
--]]

local common = require "class.commons"
local images = require "images"
local stage = require "stage"
local spairs = require "/helpers/utilities".spairs

local ArrangeSchedule = {name = "ArrangeSchedule"}

-- refer to game.lua for instructions for createButton and createImage
function ArrangeSchedule:createButton(params)
	return self:_createButton(ArrangeSchedule, params)
end

function ArrangeSchedule:createImage(params)
	return self:_createImage(ArrangeSchedule, params)
end

function ArrangeSchedule:createText(params)
	return self:_createText(ArrangeSchedule, params)
end

local imageData = {
	{
		name = "screendark",
		image = images.gui_screendark,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		endTransparency = 0,
		imageIndex = 0,
	},
	{
		name = "activitiesframe",
		image = images.gui_activitiesframe,
		endX = stage.width * 0.15,
		endY = stage.height * 0.29,
		imageIndex = -3,
	},
	{
		name = "activitiestxt",
		image = images.gui_activitiestxt,
		endX = stage.width * 0.15,
		endY = stage.height * 0.05,
		imageIndex = -2,
	},
	{
		name = "actionbox",
		image = images.gui_actionbox,
		endX = stage.width * 0.15,
		endY = stage.height * 0.12,
		imageIndex = -1,
	},
	{
		name = "scheduleframe",
		image = images.gui_scheduleframe,
		endX = stage.width * 0.87,
		endY = stage.height * 0.45,
		imageIndex = -3,
	},
	{
		name = "scheduletxt",
		image = images.gui_scheduletxt,
		endX = stage.width * 0.87,
		endY = stage.height * 0.15,
		imageIndex = -2,
	},
	{
		name = "coparent",
		image = images.gui_coparent,
		endX = stage.width * 0.68,
		endY = stage.height * 0.05,
		imageIndex = -1,
	},
	{
		name = "finalize",
		image = images.gui_finalizetxt,
		endX = stage.width * 0.88,
		endY = stage.height * 0.05,
		imageIndex = -1,
	},
	{
		name = "moneyplusblock",
		image = images.gui_stats_moneyplusblock,
		endX = stage.width * 0.07,
		endY = stage.height * 0.74,
		imageIndex = -2,
	},
	{
		name = "actionplusblock",
		image = images.gui_stats_actionplusblock,
		endX = stage.width * 0.07,
		endY = stage.height * 0.79,
		imageIndex = -2,
	},
	{
		name = "energyback",
		image = images.gui_stats_energyback,
		endX = stage.width * 0.08,
		endY = stage.height * 0.915,
		imageIndex = -2,
	},
	{
		name = "energyicon",
		image = images.gui_stats_energyicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.87,
		imageIndex = -1,
	},
	{
		name = "happyicon",
		image = images.gui_stats_happyicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.92,
		imageIndex = -1,
	},
	{
		name = "loveicon",
		image = images.gui_stats_loveicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.97,
		imageIndex = -1,
	},
	{
		name = "energyblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.87,
		imageIndex = -2,
	},
	{
		name = "happyblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.92,
		imageIndex = -2,
	},
	{
		name = "loveblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.97,
		imageIndex = -2,
	},
	{
		name = "dragonmoonicon",
		image = images.gui_dragonmoonicon,
		endX = stage.width * 0.89,
		endY = stage.height * 0.93,
		imageIndex = -1,
	},
	{
		name = "questionicon",
		image = images.gui_questionicon,
		endX = stage.width * 0.96,
		endY = stage.height * 0.89,
		imageIndex = -1,
	},
	{
		name = "settingsicon",
		image = images.gui_settingsicon,
		endX = stage.width * 0.96,
		endY = stage.height * 0.96,
		imageIndex = -1,
	},

	{
		name = "pb_bar_attack",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 0),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_defense",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 1),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_flight",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 2),
		imageIndex = 1,
		category = "progressbook",
	},

	{
		name = "pb_bar_fire",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 0),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_water",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 1),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_earth",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 2),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_ice",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 3),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_light",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 4),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_dark",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 5),
		imageIndex = 1,
		category = "progressbook",
	},

	{
		name = "pb_bar_world",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 0),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_science",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 1),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_math",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 2),
		imageIndex = 1,
		category = "progressbook",
	},
}

local buttonData = {
	{
		name = "dragongoal",
		image = images.dreams_card2,
		imagePushed = images.dreams_card2,
		endX = stage.width * 0.38,
		endY = stage.height * 0.07,
		endScaling = 0.2,
		imageIndex = -1,
		action = function()
			print("test")
		end,
	},
	{
		name = "dragondream",
		image = images.dreams_card1,
		imagePushed = images.dreams_card1,
		endX = stage.width * 0.5,
		endY = stage.height * 0.07,
		endScaling = 0.2,
		imageIndex = -1,
		action = function()
			print("test")
		end,
	},
	{
		name = "progressbookicon",
		image = images.gui_progressbookicon,
		imagePushed = images.gui_progressbookicon,
		endX = stage.width * 0.8,
		endY = stage.height * 0.93,
		imageIndex = -1,
		action = function()
			if not ArrangeSchedule.shownProgressBook then
				ArrangeSchedule:_showProgressBook()
			end
		end,
	},
	{
		name = "pb_infoscreen",
		image = images.gui_progressbook_infoscreen,
		imagePushed = images.gui_progressbook_infoscreen,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		imageIndex = 1,
		action = function()
			if ArrangeSchedule.shownProgressBook then
				ArrangeSchedule:_hideProgressBook()
			end
		end,
		category = "progressbook",
	},
}

local textData = {
	{
		name = "pb_dragonability",
		font = "BIG",
		text = "DRAGON ABILITY",
		x = stage.width * 0.05,
		y = stage.height * 0.18,
		imageIndex = 2,
		category = "progressbook",
	},
	{
		name = "pb_magic",
		font = "BIG",
		text = "MAGIC",
		x = stage.width * 0.05,
		y = stage.height * 0.45,
		imageIndex = 2,
		category = "progressbook",
	},
	{
		name = "pb_knowledge",
		font = "BIG",
		text = "KNOWLEDGE",
		x = stage.width * 0.4,
		y = stage.height * 0.18,
		imageIndex = 2,
		category = "progressbook",
	},

	{
		name = "pb_dragonability_substats",
		font = "MEDIUM",
		text = "ATTACK\nDEFENSE\nFLIGHT",
		x = stage.width * 0.05,
		y = stage.height * 0.25,
		imageIndex = 2,
		category = "progressbook",
	},
	{
		name = "pb_magic_substats",
		font = "MEDIUM",
		text = "FIRE\nWATER\nEARTH\nICE\nLIGHT\nDARK",
		x = stage.width * 0.05,
		y = stage.height * 0.52,
		imageIndex = 2,
		category = "progressbook",
	},
	{
		name = "pb_knowledge_substats",
		font = "MEDIUM",
		text = "WORLD\nSCIENCE\nMATH",
		x = stage.width * 0.4,
		y = stage.height * 0.25,
		imageIndex = 2,
		category = "progressbook",
	},
}


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

	self.shownProgressBook = false

	for _, tbl in pairs(ArrangeSchedule.ui) do
		for _, t in pairs(tbl) do
			if t.category == "progressbook" then t.transparency = 0 end
		end
	end
end

function ArrangeSchedule:_showProgressBook()
	self.shownProgressBook = true

	self.ui.static.screendark.transparency = 1

	for _, tbl in pairs(self.ui) do
		for _, t in pairs(tbl) do
			if t.category == "progressbook" then t.transparency = 1 end
		end
	end
end

function ArrangeSchedule:_hideProgressBook()
	self.shownProgressBook = false

	self.ui.static.screendark.transparency = 0

	for _, tbl in pairs(self.ui) do
		for _, t in pairs(tbl) do
			if t.category == "progressbook" then t.transparency = 0 end
		end
	end
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
