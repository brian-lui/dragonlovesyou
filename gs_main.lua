--[[
	This is the gamestate module for the main screen.
--]]

local common = require "class.commons"
local images = require "images"
local stage = require "stage"

local MainScreen = {name = "MainScreen"}

-- refer to game.lua for instructions for createButton and createImage
function MainScreen:createButton(params)
	return self:_createButton(MainScreen, params)
end

function MainScreen:createImage(params)
	return self:_createImage(MainScreen, params)
end

-- After the initial tween, we keep the icons here if returning to MainScreen screen
-- So we put it in init(), not enter() like in the other states
function MainScreen:init()
	MainScreen.ui = {
		clickable = {},
		static = {},
	}

	MainScreen.createImage(self, {
		name = "logo",
		image = images.main_mainlogo,
		duration = 30,
		endX = stage.width * 0.5,
		startY = 0,
		endY = stage.height * 0.25,
		startTransparency = 0,
		easing = "linear",
	})

	MainScreen.currentBackground = common.instance(self.background.plain, self)
end

function MainScreen:enter()
	MainScreen.clicked = nil
	if self.sound:getCurrentBGM() ~= "mainBGM" then
		self.sound:stopBGM()
		self.queue:add(45, self.sound.newBGM, self.sound, "mainBGM", true)
	end

end

function MainScreen:update(dt)
	MainScreen.currentBackground:update(dt)
	for _, tbl in pairs(MainScreen.ui) do
		for _, v in pairs(tbl) do v:update(dt) end
	end
end

function MainScreen:draw()
	MainScreen.currentBackground:draw()
	for _, v in pairs(MainScreen.ui.static) do v:draw() end
	for _, v in pairs(MainScreen.ui.clickable) do v:draw() end
end

function MainScreen:mousepressed(x, y)
	self:_mousepressed(x, y, MainScreen)
end

function MainScreen:mousereleased(x, y)
	self:_mousereleased(x, y, MainScreen)
end

function MainScreen:mousemoved(x, y)
	self:_mousemoved(x, y, MainScreen)
end

return MainScreen