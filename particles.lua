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
local consts = require "/helpers/consts"

local Particles = {}

function Particles:init()
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

--[[
	if layer is provided, only draws particles on that layer. Otherwise draws
	all particles
--]]
function Particles:draw(layer)
	if layer then
		for _, particleTbl in pairs(self.allParticles) do
			for _, particle in pairs(particleTbl) do
				if particle.imageLayer == layer then
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

-- Here follow the particles
-------------------------------------------------------------------------------
local Example = {}
function Example:init(particles_instance, x, y)
	Pic.init(self, {
		x = x,
		y = y,
		image = images.particles_pow,
	})
	local counter = consts.particleCount
	particles_instance.allParticles.Example[counter] = self
	self.particles_instance = particles_instance
end

function Example:remove()
	self.particles_instance.allParticles.Example[self.ID] = nil
end

function Example.generate(particles_instance, x, y)
	local p = common.instance(Example, particles_instance, x, y)

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

local particle_names = {
	Example = Example,
}

function Particles:create(particle_name, ...)
	assert(particle_names[particle_name], "No particle: " .. particle_name)
	particle_names[particle_name].generate(self, ...)
end

return common.class("Particles", Particles)
