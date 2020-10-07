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
	SMALL = love.graphics.newFont('/fonts/regular.ttf', 15),
	MEDIUM = love.graphics.newFont('/fonts/regular.ttf', 30),
	BIG = love.graphics.newFont('/fonts/regular.ttf', 40),
}

consts.FONT.SMALL_ROWADJUST = -math.ceil(consts.FONT.SMALL:getHeight() * 0.5)
consts.FONT.MEDIUM_ROWADJUST = -math.ceil(consts.FONT.MEDIUM:getHeight() * 0.5)
consts.FONT.BIG_ROWADJUST = -math.ceil(consts.FONT.BIG:getHeight() * 0.5)

return consts