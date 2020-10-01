--[[
This file describes some "global" defaults.
--]]

local love = _G.love
local TLfres = require "/libraries/tlfres"

local consts = {}

local DRAWSPACE_WIDTH = 2732
local DRAWSPACE_HEIGHT = 2048

consts.timeStep = 1/60
consts.timeBucket = 0
consts.frame = 0
consts.particle = 0
consts.backgroundParticle = 0

consts.drawspace = {
	width = DRAWSPACE_WIDTH,
	height = DRAWSPACE_HEIGHT,
	scale = TLfres.getScale(DRAWSPACE_WIDTH, DRAWSPACE_HEIGHT),
	tlfres = TLfres,
}

consts.ID = {
	reset = function(self)
		self.timeStep = 1/60
		self.timeBucket = 0
		self.frame = 0
		self.particle = 0
		self.backgroundParticle = 0
	end
}
consts.ID:reset()

consts.FONT = {
	STANDARD_REGULAR = love.graphics.newFont('/fonts/anonymous.ttf', 20),
	STANDARD_MEDIUM = love.graphics.newFont('/fonts/anonymous.ttf', 30),
	STANDARD_BIGGER = love.graphics.newFont('/fonts/anonymous.ttf', 40),
	CARTOON_SMALL = love.graphics.newFont('/fonts/BD_Cartoon_Shout.ttf', 30),
	CARTOON_MEDIUM = love.graphics.newFont('/fonts/BD_Cartoon_Shout.ttf', 60),
	CARTOON_BIG = love.graphics.newFont('/fonts/BD_Cartoon_Shout.ttf', 90),
}
consts.FONT.CARTOON_SMALL_ROWADJUST = -math.ceil(consts.FONT.CARTOON_SMALL:getHeight() * 0.5)
consts.FONT.CARTOON_MEDIUM_ROWADJUST = -math.ceil(consts.FONT.CARTOON_MEDIUM:getHeight() * 0.5)
consts.FONT.CARTOON_BIG_ROWADJUST = -math.ceil(consts.FONT.CARTOON_BIG:getHeight() * 0.5)

return consts