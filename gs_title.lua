--[[
	This is the gamestate module for the Title screen.

	Note to coders and code readers!
	You can't call Title.createButton by doing Title:createButton(...)
	That will call it by passing in an instance of Title, which doesn't work
	You have to call it with Title.createButton(self, ...)
	That passes in an instance of self, which works (???)
	Look I didn't code this I just know how to use it, ok
--]]

local common = require "class.commons"
local assetData = require "assetdata"
local spairs = require "/helpers/utilities".spairs

local Title = {name = "Title"}

-- refer to game.lua for instructions for createButton and createImage
function Title:createButton(params)
	return self:_createButton(Title, params)
end

function Title:createImage(params)
	return self:_createImage(Title, params)
end

function Title:createText(params)
	return self:_createText(Title, params)
end

local imageData = assetData.getImages("Title")
local buttonData = assetData.getButtons("Title")
local draggableData = assetData.getDraggables("Title")
local textData = assetData.getText("Title")

-- After the initial tween, we keep the icons here if returning to Title screen
-- So we put it in init(), not enter() like in the other states
function Title:init()
	Title.ui = {
		clickable = {},
		draggable = {},
		static = {},
		text = {},
	}

	for _, data in pairs(imageData) do
		Title.createImage(self, data)
	end

	for _, data in pairs(buttonData) do
		Title.createButton(self, data)
	end

	for _, data in pairs(draggableData) do
		Title.createDraggables(self, data)
	end

	for _, data in pairs(textData) do
		Title.createText(self, data)
	end

	Title.currentBackground = common.instance(self.background.plain, self)
end

function Title:enter()
	self.controls.clicked = nil
	if self.sound:getCurrentBGM() ~= "titleBGM" then
		self.sound:stopBGM()
		self.queue:add(45, self.sound.newBGM, self.sound, "titleBGM", true)
	end

end

function Title:update(dt)
	Title.currentBackground:update(dt)
	for _, tbl in pairs(Title.ui) do
		for _, v in pairs(tbl) do v:update(dt) end
	end
end

function Title:draw()
	local indexes = {-2, -1, 0, 1}

	for _, i in ipairs(indexes) do

		for _, v in spairs(Title.ui.static) do
			if v.imageIndex == i then
				v:draw()
			end
		end

		for _, v in spairs(Title.ui.clickable) do
			if v.imageIndex == i then
				v:draw()
			end
		end

		for _, v in spairs(Title.ui.draggable) do
			if v.imageIndex == i then
				v:draw()
			end
		end
	end
end

-- add custom things to these three functions
function Title:_pressed(x, y)
	self:_controllerPressed(x, y, Title)
end

function Title:_released(x, y)
	self:_controllerReleased(x, y, Title)
end

function Title:_moved(x, y)
	self:_controllerMoved(x, y, Title)
end

function Title:mousepressed(x, y) Title._pressed(self, x, y) end
function Title:touchpressed(_, x, y) Title._pressed(self, x, y) end

function Title:mousereleased(x, y) Title._released(self, x, y) end
function Title:touchreleased(_, x, y) Title._released(self, x, y) end

function Title:mousemoved(x, y) Title._moved(self, x, y) end
function Title:touchmoved(_, x, y) Title._moved(self, x, y) end

return Title
