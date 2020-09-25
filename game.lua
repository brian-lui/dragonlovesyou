--[[
This is the main game module.
It contains several major components:
Queue - this is the component that allows convenient callbacks, for situations
where there isn't a better way to callback
Serialization - this module has a section for serializing the gamestate and
delta
Menu - this has the menu prototype, e.g. the settings menu and actions
Global default callbacks - this has global default functions for things like
keypress, mouse actions
Global default functions - this has global functions that apply to multiple
states, such as darkening and brightening screen
--]]

local love = _G.love
local Pic = require "pic"
local common = require "/libraries/classcommons"


--[==================[
QUEUE COMPONENT
--]==================]

local Queue = {}

function Queue:init(game)
	self.game = game
end

function Queue:add(frames, func, ...)
	assert(frames % 1 == 0 and frames >= 0, "non-integer or negative queue received")
	assert(type(func) == "function", "non-function of type " .. type(func) .. " received")
	local a = self.game.frame + frames
	self[a] = self[a] or {}
	table.insert(self[a], {func, {...}})
end

function Queue:update()
	local do_today = self[self.game.frame]

	if do_today then
		for i = 1, #do_today do
			local func, args = do_today[i][1], do_today[i][2]
			func(table.unpack(args))
		end
		self[self.game.frame] = nil
	end
end

Queue = common.class("Queue", Queue)

--[==================[
END QUEUE COMPONENT
--]==================]

local Game = {}

function Game:init()
	self.frame, self.time_step, self.timeBucket = 0, 1/60, 0
	self.camera = common.instance(require "/libraries/camera")
	self.inits = require "/helpers/inits"
	self.settings = require "/helpers/settings"
	self.rng = love.math.newRandomGenerator()
	self.sound = common.instance(require "sound", self)
	self.background = common.instance(require "background", self)
	self.particles = common.instance(require "particles", self)
	self.queue = common.instance(Queue, self)
	self.statemanager = common.instance(require "/libraries/statemanager", self)

	self:switchState("gs_title")
	self:reset()

	-- can add more
end

function Game:reset()
	self.rng:setSeed(os.time())
	self.frame = 0
	self.inits.ID:reset()
	self.sound:reset()
	self.particles:reset()

	-- can add more
end

-- takes a string
function Game:switchState(gamestate)
	self.current_gamestate = require(gamestate)
	self.statemanager:switch(self.current_gamestate)
end

--[[
This is a wrapper to do stuff at 60hz. We want the logic stuff to be at
60hz, but the drawing can be at whatever! So each love.update runs at
unbounded speed, and then adds dt to bucket. When bucket is larger
than 1/60, it runs the logic functions until bucket is less than 1/60,
or we reached the maximum number of times to run the logic this cycle.
--]]
function Game:timeDip(func, ...)
	for _ = 1, 4 do -- run a maximum of 4 logic cycles per love.update cycle
		if self.timeBucket >= self.time_step then
			func(...)
			self.frame = self.frame + 1
			self.timeBucket = self.timeBucket - self.time_step
		end
	end
end

function Game:update(dt)
	self.timeBucket = self.timeBucket + dt

	self:timeDip(function()
		self.queue:update()
		-- other logic stuff
	end)

	self.sound:update()
	self.particles:update(dt)
	-- other non-logic update stuff
end

-------------------------------------------------------------------------------
--[[ create a clickable object
	mandatory parameters: name, image, image_pushed, end_x, end_y, action
	optional parameters: duration, start_transparency, end_transparency,
		start_x, start_y, easing, exit, pushed, pushed_sfx, released,
		released_sfx, force_max_alpha
--]]
function Game:_createButton(gamestate, params)
	params = params or {}
	if params.name == nil then print("No object name received!") end
	if params.image_pushed == nil then
		print("Caution: no push image received for " .. params.name .. "!")
	end

	local button = Pic:create{
		game = self,
		name = params.name,
		x = params.start_x or params.end_x,
		y = params.start_y or params.end_y,
		transparency = params.start_transparency or 1,
		image = params.image,
		container = params.container or gamestate.ui.clickable,
		force_max_alpha = params.force_max_alpha,
	}

	button:change{
		duration = params.duration,
		x = params.end_x,
		y = params.end_y,
		transparency = params.end_transparency or 1,
		easing = params.easing or "linear",
		exit_func = params.exit_func,
	}
	button.pushed = params.pushed or function(_self)
		_self.game.sound:newSFX(params.pushed_sfx or "button")
		_self:newImage(params.image_pushed)
	end
	button.released = params.released or function(_self)
		if params.released_sfx then
			_self.game.sound:newSFX(params.released_sfx)
		end
		_self:newImage(params.image)
	end
	button.action = params.action
	return button
end

--[[ creates an object that can be tweened but not clicked
	mandatory parameters: name, image, end_x, end_y
	optional parameters: duration, start_transparency, end_transparency,
		start_x, start_y, easing, remove, exit_func, force_max_alpha,
		start_scaling, end_scaling, container, counter, h_flip
--]]
function Game:_createImage(gamestate, params)
	params = params or {}
	if params.name == nil then print("No object name received!") end

	local button = Pic:create{
		game = self,
		name = params.name,
		x = params.start_x or params.end_x,
		y = params.start_y or params.end_y,
		transparency = params.start_transparency or 1,
		scaling = params.start_scaling or 1,
		image = params.image,
		counter = params.counter,
		container = params.container or gamestate.ui.static,
		force_max_alpha = params.force_max_alpha,
		h_flip = params.h_flip,
	}

	button:change{
		duration = params.duration,
		x = params.end_x,
		y = params.end_y,
		transparency = params.end_transparency or 1,
		scaling = params.end_scaling or 1,
		easing = params.easing,
		remove = params.remove,
		exit_func = params.exit_func,
	}
	return button
end

local pointIsInRect = require "/helpers/utilities".pointIsInRect

--default mousepressed function if not specified by a sub-state
function Game:_mousepressed(x, y, gamestate)
	for _, button in pairs(gamestate.ui.clickable) do
		if pointIsInRect(x, y, button:getRect()) then
			gamestate.clicked = button
			button:pushed()
			return
		end
	end
	gamestate.clicked = false
end

-- default mousereleased function if not specified by a sub-state
function Game:_mousereleased(x, y, gamestate)
	for _, button in pairs(gamestate.ui.clickable) do
		if gamestate.clicked == button then button:released() end
		if pointIsInRect(x, y, button:getRect())
		and gamestate.clicked == button then
			button.action()
			break
		end
	end
	gamestate.clicked = false
end

-- default mousemoved function if not specified by a sub-state
function Game:_mousemoved(x, y, gamestate)
	if gamestate.clicked then
		if not pointIsInRect(x, y, gamestate.clicked:getRect()) then
			gamestate.clicked:released()
			gamestate.clicked = false
		end
	end
end

-- checks if mouse is down (for ui). Can use different function for touchscreen
function Game:_ismousedown()
	return love.mouse.isDown(1)
end

-- get current mouse position
function Game:_getmouseposition()
	local drawspace = self.inits.drawspace
	local x, y = drawspace.tlfres.getMousePosition(drawspace.width, drawspace.height)
	return x, y
end

function Game:keypressed(key)
	if key == "escape" then
		love.event.quit()

	-- elseif, or whatever

	end
end

return common.class("Game", Game)
