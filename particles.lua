--[[
This module contains all the pre-defined animated objects for non-character
images. Particles are objects that are displayed on-screen but do not affect
the gamestate.

There should never be gamestate code that depends on particles, except for
code that uses particle duration to calculate delay times.
--]]

local common = require "class.commons"
local Pic = require "pic"
local images = require "images"
local inits = require "/helpers/inits"

local Particles = {}

function Particles:init(game)
	self.game = game
	self:reset()
end

function Particles:update(dt)
	for _, particleTbl in pairs(self.allParticles) do
		for _, particle in pairs(particleTbl) do particle:update(dt) end
	end
end

function Particles:reset()
	self.allParticles = {
		Example = {},
	}
end

-- if layer is provided, only draws particles on that layer. Otherwise draws
-- all particles
function Particles:draw(layer)
	if layer then
		for _, particleTbl in pairs(self.allParticles) do
			for _, particle in pairs(particleTbl) do
				if particle.imageIndex == layer then
					particle:draw()
				end
			end
		end
	else
		for _, particleTbl in pairs(self.allParticles) do
			for _, particle in pairs(particleTbl) do particle:draw() end
		end
	end
end

-------------------------------------------------------------------------------
local Example = {}
function Example:init(manager, x, y)
	Pic.init(self, manager.game, {
		x = x,
		y = y,
		image = images.particles_pow,
	})
	local counter = inits.ID.particle
	manager.allParticles.Example[counter] = self
	self.manager = manager
end

function Example:remove()
	self.manager.allParticles.Example[self.ID] = nil
end

function Example.generate(game, x, y)
	local p = common.instance(Example, game.particles, x, y)
	p:change{
		duration = 30,
		transparency = 0,
		easing = "linear",
		remove = true,
	}
end

-- draw additional stuff optionally
function Example:draw()
	Pic.draw(self)
	-- etc.
end

Example = common.class("Example", Example, Pic)

-------------------------------------------------------------------------------

Particles.example = Example

return common.class("Particles", Particles)
