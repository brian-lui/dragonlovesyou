--[[
This module contains all the pre-defined animated objects for non-character
images. Particles are objects that are displayed on-screen but do not affect
the gamestate.

There should never be gamestate code that depends on particles, except for
code that uses particle duration to calculate delay times.

Draw order is as follows, from drawn first to drawn last:
	-4 (at bottom of screen)
	-3
	-2
	-1
	0
	1
	2
	3
	4
	5 (at top of screen)
--]]

local common = require "class.commons"
local Pic = require "pic"

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
		Example1 = {},
		Example2 = {},
	}
end

-------------------------------------------------------------------------------
-- When a gem is placed in basin, make the gem effects for tweening offscreen.
local Example1 = {}
function Example1:init(manager, gem)
	Pic.init(self, manager.game, {x = gem.x, y = gem.y, image = gem.image})
	local counter = self.game.inits.ID.particle
	manager.allParticles.Example1[counter] = self
	self.gem = gem
	self.manager = manager
end

function Example1:remove()
	self.manager.allParticles.Example1[self.ID] = nil
end

function Example1.generate(game, gem)
	local p = common.instance(Example1, game.particles, gem)
	p:change{
		duration = 60,
		y = p.y - game.stage.height,
		easing = "inQuad",
		remove = true,
	}
end

-- draw anything that's contained by the gem, too
function Example1:draw()
	Pic.draw(self)
	-- etc.
end

Example1 = common.class("Example1", Example1, Pic)

-------------------------------------------------------------------------------
-- When a gem is placed in basin, this is the lighter gem in the holding area
-- to show where you placed it.
local Example2 = {}
function Example2:init(manager, gem, y, row, place_type)
	Pic.init(
		self,
		manager.game,
		{x = gem.x, y = y, image = gem.image, transparency = 0.75}
	)
	local counter = self.game.inits.ID.particle
	manager.allParticles.Example2[counter] = self
	self.manager = manager
	self.player_num = gem.player_num
	self.gem = gem
	self.row = row
	self.place_type = place_type
	self.tweened_down = false
	self.tweened_down_permanently = false
end

function Example2:remove()
	self.manager.allParticles.Example2[self.ID] = nil
end

function Example2.generate(game, gem)
	-- We calculate the placedgem location based on the gem row
	local row, y, place_type
	if gem.row == 1 or gem.row == 2 then
	-- doublecast gem, goes in rows 7-8
		row = gem.row + 6
		place_type = "doublecast"
	elseif gem.row == 3 or gem.row == 4 then
	-- rush gem, goes in rows 9-10
		row = gem.row + 6
		place_type = "rush"
	elseif gem.row == 5 or gem.row == 6 then
	-- normal gem, goes in rows 7-8 (gets pushed to 11-12)
		row = gem.row + 2
		place_type = "normal"
	else
		print("Error, placedgem received a gem without a row")
	end
	y = game.grid.y[row]
	common.instance(Example2, game.particles, gem, y, row, place_type)
end

Example2 = common.class("Example2", Example2, Pic)

-------------------------------------------------------------------------------

Particles.example1 = Example1
Particles.example2 = Example2

return common.class("Particles", Particles)
