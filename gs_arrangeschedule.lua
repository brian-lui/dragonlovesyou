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


-- After the initial tween, we keep the icons here if returning to ArrangeSchedule screen
-- So we put it in init(), not enter() like in the other states
function ArrangeSchedule:init()
	ArrangeSchedule.ui = {
		clickable = {},
		draggable = {},
		static = {},
		text = {},
	}

	ArrangeSchedule.createImage(self, {
		name = "screendark",
		image = images.gui_screendark,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		endTransparency = 0,
		imageIndex = 0,
	})

	ArrangeSchedule.createImage(self, {
		name = "activitiesframe",
		image = images.gui_activitiesframe,
		endX = stage.width * 0.15,
		endY = stage.height * 0.29,
		imageIndex = -3,
	})

	ArrangeSchedule.createImage(self, {
		name = "activitiestxt",
		image = images.gui_activitiestxt,
		endX = stage.width * 0.15,
		endY = stage.height * 0.05,
		imageIndex = -2,
	})

	ArrangeSchedule.createImage(self, {
		name = "actionbox",
		image = images.gui_actionbox,
		endX = stage.width * 0.15,
		endY = stage.height * 0.12,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "scheduleframe",
		image = images.gui_scheduleframe,
		endX = stage.width * 0.87,
		endY = stage.height * 0.45,
		imageIndex = -3,
	})

	ArrangeSchedule.createImage(self, {
		name = "scheduletxt",
		image = images.gui_scheduletxt,
		endX = stage.width * 0.87,
		endY = stage.height * 0.15,
		imageIndex = -2,
	})

	ArrangeSchedule.createImage(self, {
		name = "coparent",
		image = images.gui_coparent,
		endX = stage.width * 0.68,
		endY = stage.height * 0.05,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "finalize",
		image = images.gui_finalizetxt,
		endX = stage.width * 0.88,
		endY = stage.height * 0.05,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "moneyplusblock",
		image = images.gui_stats_moneyplusblock,
		endX = stage.width * 0.07,
		endY = stage.height * 0.74,
		imageIndex = -2,
	})

	ArrangeSchedule.createImage(self, {
		name = "actionplusblock",
		image = images.gui_stats_actionplusblock,
		endX = stage.width * 0.07,
		endY = stage.height * 0.79,
		imageIndex = -2,
	})

	ArrangeSchedule.createImage(self, {
		name = "energyback",
		image = images.gui_stats_energyback,
		endX = stage.width * 0.08,
		endY = stage.height * 0.915,
		imageIndex = -2,
	})

	ArrangeSchedule.createImage(self, {
		name = "energyicon",
		image = images.gui_stats_energyicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.87,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "happyicon",
		image = images.gui_stats_happyicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.92,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "loveicon",
		image = images.gui_stats_loveicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.97,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "energyblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.87,
		imageIndex = -2,
	})


	ArrangeSchedule.createImage(self, {
		name = "happyblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.92,
		imageIndex = -2,
	})


	ArrangeSchedule.createImage(self, {
		name = "loveblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.97,
		imageIndex = -2,
	})

	ArrangeSchedule.createButton(self, {
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
	})

	ArrangeSchedule.createImage(self, {
		name = "dragonmoonicon",
		image = images.gui_dragonmoonicon,
		endX = stage.width * 0.89,
		endY = stage.height * 0.93,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "questionicon",
		image = images.gui_questionicon,
		endX = stage.width * 0.96,
		endY = stage.height * 0.89,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "settingsicon",
		image = images.gui_settingsicon,
		endX = stage.width * 0.96,
		endY = stage.height * 0.96,
		imageIndex = -1,
	})


	ArrangeSchedule.createButton(self, {
		name = "progressbook_infoscreen",
		image = images.gui_progressbook_infoscreen,
		imagePushed = images.gui_progressbook_infoscreen,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		endTransparency = 0,
		imageIndex = 1,
		action = function()
			if ArrangeSchedule.shownProgressBook then
				ArrangeSchedule:_hideProgressBook()
			end
		end,
	})

	ArrangeSchedule.createText(self, {
		name = "progressbook_dragonability",
		font = "MEDIUM",
		text = "DRAGON ABILITY",
		x = stage.width * 0.2,
		y = stage.width * 0.2,
		imageIndex = 2,
		transparency = 0,
	})

	ArrangeSchedule.currentBackground = common.instance(self.background.library, self)
end

function ArrangeSchedule:enter()
	self.controls.clicked = nil
	if self.sound:getCurrentBGM() ~= "mainBGM" then
		self.sound:stopBGM()
		self.queue:add(45, self.sound.newBGM, self.sound, "mainBGM", true)
	end

	self.shownProgressBook = false
end

function ArrangeSchedule:_showProgressBook()
	self.shownProgressBook = true

	self.ui.static.screendark.transparency = 1
	self.ui.clickable.progressbook_infoscreen.transparency = 1
	for k, v in pairs(self.ui.text) do print(k, v) end
	self.ui.text.progressbook_dragonability.transparency = 1
end

function ArrangeSchedule:_hideProgressBook()
	self.shownProgressBook = false

	self.ui.static.screendark.transparency = 0
	self.ui.clickable.progressbook_infoscreen.transparency = 0
	self.ui.text.progressbook_dragonability.transparency = 0
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
		for _, v in spairs(ArrangeSchedule.ui.static) do
			if v.imageIndex == i then
				v:draw()
			end
		end

		for _, v in spairs(ArrangeSchedule.ui.clickable) do
			if v.imageIndex == i then
				v:draw()
			end
		end

		for _, v in spairs(ArrangeSchedule.ui.draggable) do
			if v.imageIndex == i then
				v:draw()
			end
		end

		for _, v in pairs(ArrangeSchedule.ui.text) do
			if v.imageIndex == i then
				v:draw()
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
