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

-- After the initial tween, we keep the icons here if returning to ArrangeSchedule screen
-- So we put it in init(), not enter() like in the other states
function ArrangeSchedule:init()
	ArrangeSchedule.ui = {
		clickable = {},
		draggable = {},
		static = {},
	}

	ArrangeSchedule.createImage(self, {
		name = "activitiesframe",
		image = images.gui_activitiesframe,
		endX = stage.width * 0.15,
		endY = stage.height * 0.5,
		imageIndex = -2,
	})

	ArrangeSchedule.createImage(self, {
		name = "activitiestxt",
		image = images.gui_activitiestxt,
		endX = stage.width * 0.15,
		endY = stage.height * 0.26,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "actionbox",
		image = images.gui_actionbox,
		endX = stage.width * 0.15,
		endY = stage.height * 0.33,
		imageIndex = 0,
	})

	ArrangeSchedule.createImage(self, {
		name = "scheduleframe",
		image = images.gui_scheduleframe,
		endX = stage.width * 0.88,
		endY = stage.height * 0.45,
		imageIndex = -2,
	})

	ArrangeSchedule.createImage(self, {
		name = "scheduletxt",
		image = images.gui_scheduletxt,
		endX = stage.width * 0.88,
		endY = stage.height * 0.15,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "statbar",
		image = images.gui_statbar,
		endX = stage.width * 0.4,
		endY = stage.height * 0.15,
		imageIndex = -3,
	})

	ArrangeSchedule.createImage(self, {
		name = "cloud",
		image = images.gui_cloud,
		endX = stage.width * 0.1,
		endY = stage.height * 0.15,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "energyicon",
		image = images.gui_energyicon,
		endX = stage.width * 0.2,
		endY = stage.height * 0.15,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "energyblockback",
		image = images.gui_blockback,
		endX = stage.width * 0.28,
		endY = stage.height * 0.15,
		imageIndex = -2,
	})

	ArrangeSchedule.createImage(self, {
		name = "happyicon",
		image = images.gui_happyicon,
		endX = stage.width * 0.37,
		endY = stage.height * 0.15,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "happyblockback",
		image = images.gui_blockback,
		endX = stage.width * 0.45,
		endY = stage.height * 0.15,
		imageIndex = -2,
	})

	ArrangeSchedule.createImage(self, {
		name = "loveicon",
		image = images.gui_loveicon,
		endX = stage.width * 0.54,
		endY = stage.height * 0.15,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "loveblockback",
		image = images.gui_blockback,
		endX = stage.width * 0.62,
		endY = stage.height * 0.15,
		imageIndex = -2,
	})

	ArrangeSchedule.createImage(self, {
		name = "actionicon",
		image = images.gui_actionicon,
		endX = stage.width * 0.71,
		endY = stage.height * 0.15,
		imageIndex = -1,
	})

	ArrangeSchedule.createImage(self, {
		name = "coparent",
		image = images.gui_coparent,
		endX = stage.width * 0.15,
		endY = stage.height * 0.9,
		imageIndex = 0,
	})

	ArrangeSchedule.createImage(self, {
		name = "finalize",
		image = images.gui_finalize,
		endX = stage.width * 0.85,
		endY = stage.height * 0.9,
		imageIndex = 0,
	})

	ArrangeSchedule.currentBackground = common.instance(self.background.library, self)
end

function ArrangeSchedule:enter()
	self.controls.clicked = nil
	if self.sound:getCurrentBGM() ~= "mainBGM" then
		self.sound:stopBGM()
		self.queue:add(45, self.sound.newBGM, self.sound, "mainBGM", true)
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
