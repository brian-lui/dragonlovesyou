--[[
This module provides the backgrounds and associated animations for all
gamestates.

Every background should have:
ID_number - used for the ordering of the backgrounds
init(game)
update(dt)
draw()
--]]

local love = _G.love
local common = require "class.commons"
local Pic = require "pic"

-------------------------------------------------------------------------------
---------------------------- RABBIT IN A SNOWSTORM ----------------------------
-------------------------------------------------------------------------------
local Plain = {ID_number = 1}
function Plain:init(game)
	self.game = game
	Pic:create{
		game = game,
		x = game.stage.width * 0.5,
		y = game.stage.height * 0.5,
		image = love.graphics.newImage('images/backgrounds/plain/plainbackground.png'),
		container = self,
		name = "background",
	}

	game.inits.ID.background_particle = 0
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

local bk_list, total = {}, 0
for k in pairs(background) do
	bk_list[#bk_list+1] = k
	total = total + 1
end
background.total = total

function background:idx_to_str(idx)
	for _, v in pairs(bk_list) do
		if self[v].ID_number == idx then return v end
	end
	return "no background"
end

return common.class("background", background)
