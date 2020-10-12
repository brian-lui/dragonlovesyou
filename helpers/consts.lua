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
consts.particleCount = 0
consts.backgroundParticleCount = 0

consts.LONGPRESS_FRAMES = 30

consts.drawspace = {
	width = DRAWSPACE_WIDTH,
	height = DRAWSPACE_HEIGHT,
	scale = TLfres.getScale(DRAWSPACE_WIDTH, DRAWSPACE_HEIGHT),
	tlfres = TLfres,
}

function consts.reset(self)
	self.timeStep = 1/60
	self.timeBucket = 0
	self.frame = 0
	self.particleCount = 0
	self.backgroundParticleCount = 0
end
consts:reset()


consts.FONT = {
	SMALL = love.graphics.newFont('/fonts/regular.ttf', 30),
	MEDIUM = love.graphics.newFont('/fonts/regular.ttf', 60),
	BIG = love.graphics.newFont('/fonts/regular.ttf', 80),
}

consts.FONT.SMALL_ROWADJUST = -math.ceil(consts.FONT.SMALL:getHeight() * 0.5)
consts.FONT.MEDIUM_ROWADJUST = -math.ceil(consts.FONT.MEDIUM:getHeight() * 0.5)
consts.FONT.BIG_ROWADJUST = -math.ceil(consts.FONT.BIG:getHeight() * 0.5)

return consts