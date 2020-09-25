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
local stage = require "stage"
local Pic = require "pic"
local spairs = require "/helpers/utilities".spairs

-------------------------------------------------------------------------------
---------------------------------- STARFALL -----------------------------------
-------------------------------------------------------------------------------
local Starfall = {ID_number = 1}
function Starfall:init(game)
	self.game = game
	Pic:create{
		game = game,
		x = stage.width * 0.5,
		y = stage.height * 0.5,
		image = love.graphics.newImage('images/backgrounds/starfall/starfall.png'),
		container = self,
		name = "background",
	}
	self.star_timer_func = function() return math.random(70, 100) end
	self.star_timer = self.star_timer_func()
	self.stars = {} -- container for stars
	game.inits.ID.background_particle = 0
end

function Starfall:_generateStar()

	local image_table = {
		love.graphics.newImage('images/backgrounds/starfall/star1.png'),
		love.graphics.newImage('images/backgrounds/starfall/star2.png'),
		love.graphics.newImage('images/backgrounds/starfall/star3.png'),
		love.graphics.newImage('images/backgrounds/starfall/star4.png'),
	}
	local image_index = math.random(1, #image_table)
	local image = image_table[image_index]
	local height = image:getHeight()

	local duration = (stage.height / height) * 30
	local rotation = (stage.height / height)
	local start_x = math.random(0.1 * stage.width, 0.8 * stage.width)
	local start_y = -height
	local end_x = start_x + stage.width * math.random(0.15, 0.15)
	local end_y = stage.height + height

	local star = Pic:create{
		game = self.game,
		x = start_x,
		y = start_y,
		image = image,
		container = self.stars,
		counter = "background_particle",
	}
	star:change{
		duration = duration,
		x = end_x,
		y = end_y,
		rotation = rotation,
		remove = true,
	}
end

function Starfall:update(dt)
	for _, v in pairs(self.stars) do v:update(dt) end
	if self.star_timer <= 0 then
		self:_generateStar()
		self.star_timer = self.star_timer_func()
	else
		self.star_timer = self.star_timer - 1
	end
end

function Starfall:draw(params)
	self.background:draw(params)
	for _, v in spairs(self.stars) do v:draw(params) end
end
Starfall = common.class("Starfall", Starfall)


-------------------------------------------------------------------------------
----------------------------------- COLORS -----------------------------------
-------------------------------------------------------------------------------
local Colors = {ID_number = 2}
function Colors:init(game)
	self.game = game
	self.t = 0
	Pic:create{
		game = self.game,
		x = stage.width * 0.5,
		y = stage.height * 0.5,
		image = love.graphics.newImage('images/backgrounds/colors/white.png'),
		container = self,
		name = "current_color",
	}
	self.previous_color = nil
	self.timing_full_cycle = 1800
	self.timings = {
		[0] = love.graphics.newImage('images/backgrounds/colors/white.png'),
		[360] = love.graphics.newImage('images/backgrounds/colors/blue.png'),
		[720] = love.graphics.newImage('images/backgrounds/colors/red.png'),
		[1080] = love.graphics.newImage('images/backgrounds/colors/green.png'),
		[1440] =  love.graphics.newImage('images/backgrounds/colors/yellow.png'),
	}
	game.inits.ID.background_particle = 0
end

function Colors:_newColor(image)
	self.previous_color = self.current_color
	self.previous_color:change{duration = 180, transparency = 0,
		exit_func = function() self.previous_color = nil end}
	Pic:create{
		game = self.game,
		x = stage.width * 0.5,
		y = stage.height * 0.5,
		image = image,
		transparency = 0,
		container = self,
		name = "current_color",
	}
	self.current_color:change{duration = 90, transparency = 1}
end

function Colors:update(dt)
	self.t = (self.t + 1) % self.timing_full_cycle
	self.current_color:update(dt)
	if self.previous_color then self.previous_color:update(dt) end
	local new = self.timings[self.t]
	if new then self:_newColor(new) end
end

function Colors:draw(params)
	if self.previous_color then self.previous_color:draw(params) end
	self.current_color:draw(params)
end
Colors = common.class("Colors", Colors)


-------------------------------------------------------------------------------
local background = {}
background.starfall = Starfall
background.colors = Colors

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
