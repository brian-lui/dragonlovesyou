--[[
This module provides the backgrounds and associated animations for all
gamestates.

Every background should have:
IDNumber - used for the ordering of the backgrounds
init()
update(dt)
draw()
--]]

local love = _G.love
local common = require "class.commons"
local Pic = require "pic"
local consts = require "/helpers/consts"
local stage = require "stage"

-------------------------------------------------------------------------------
local Plain = {IDNumber = 1}
function Plain:init()
	Pic:create{
		x = stage.width * 0.5,
		y = stage.height * 0.5,
		image = love.graphics.newImage('images/backgrounds/plainbackground.png'),
		container = self,
		name = "background",
	}

	consts.backgroundParticleCount = 0
end

function Plain:update(dt)
	local w, h = love.window.getMode()
	local widthRatio = w / self.background.width
	local heightRatio = h / self.background.height

	local biggestRatio = math.max(widthRatio, heightRatio)
	self.background.scaling = biggestRatio
	self.background.x = w * 0.5
	self.background.y = h * 0.5
end

function Plain:draw(params)
	self.background:draw(params)
end

Plain = common.class("Plain", Plain)

-------------------------------------------------------------------------------
local Library = {IDNumber = 2}
function Library:init()
	Pic:create{
		x = stage.width * 0.5,
		y = stage.height * 0.5,
		image = love.graphics.newImage('images/backgrounds/library.png'),
		container = self,
		name = "background",
	}

	consts.backgroundParticleCount = 0
end

function Library:update(dt)
	local w, h = love.window.getMode()
	local widthRatio = w / self.background.width
	local heightRatio = h / self.background.height

	local biggestRatio = math.max(widthRatio, heightRatio)
	self.background.scaling = biggestRatio
	self.background.x = w * 0.5
	self.background.y = h * 0.5
end

function Library:draw(params)
	self.background:draw(params)
end

Library = common.class("Library", Library)


-------------------------------------------------------------------------------
local background = {}
background.plain = Plain
background.library = Library


-------------------------------------------------------------------------------
local bkList, total = {}, 0
for k in pairs(background) do
	bkList[#bkList+1] = k
	total = total + 1
end
background.total = total

function background:idxToStr(idx)
	for _, v in pairs(bkList) do
		if self[v].IDNumber == idx then return v end
	end
	return "no background"
end

return common.class("background", background)
