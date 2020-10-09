--[[
	This is the gamestate module for the arranging the dragon's schedule for
	the week (?)
--]]

local common = require "class.commons"
local spairs = require "/helpers/utilities".spairs
local assetData = require "assetdata"

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
			if t.category == subscreenName then t.clickable = true end
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
			if t.category == subscreenName then t.clickable = false end
		end
	end
end


function ArrangeSchedule:showDragonGoal()
	self:_showSubscreen("dragongoal")
end

function ArrangeSchedule:hideDragonGoal()
	self:_hideSubscreen("dragongoal")
end

function ArrangeSchedule:showDragonDream()
	self:_showSubscreen("dragondream")
	print(self.ui.clickable.dragondream)
end

function ArrangeSchedule:hideDragonDream()
	self:_hideSubscreen("dragondream")
end

function ArrangeSchedule:showProgressBook()
	self:_showSubscreen("progress")
end

function ArrangeSchedule:hideProgressBook()
	self:_hideSubscreen("progress")
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
