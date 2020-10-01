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
------------------------------------ PLAIN ------------------------------------
-------------------------------------------------------------------------------
local Plain = {IDNumber = 1}
function Plain:init()
	Pic:create{
		x = stage.width * 0.5,
		y = stage.height * 0.5,
		image = love.graphics.newImage('images/backgrounds/plain/plainbackground.png'),
		container = self,
		name = "background",
	}

	consts.ID.backgroundParticle = 0
end

function Plain:update(dt)
end

function Plain:draw(params)
	self.background:draw(params)
end

Plain = common.class("Plain", Plain)



-------------------------------------------------------------------------------
local background = {}
background.plain = Plain

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
