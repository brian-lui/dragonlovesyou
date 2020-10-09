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
local consts = require "/helpers/consts"


--[==================[
QUEUE COMPONENT
--]==================]

local Queue = {}

function Queue:init()
end

function Queue:add(frames, func, ...)
	assert(frames % 1 == 0 and frames >= 0, "non-integer or negative queue received")
	assert(type(func) == "function", "non-function of type " .. type(func) .. " received")
	local a = consts.frame + frames
	self[a] = self[a] or {}
	table.insert(self[a], {func, {...}})
end

function Queue:update()
	local doToday = self[consts.frame]

	if doToday then
		for i = 1, #doToday do
			local func, args = doToday[i][1], doToday[i][2]
			func(table.unpack(args))
		end
		self[consts.frame] = nil
	end
end

Queue = common.class("Queue", Queue)

--[==================[
END QUEUE COMPONENT
--]==================]

local Game = {}

function Game:init()
	self.camera = common.instance(require "/libraries/camera")
	self.settings = require "/helpers/settings"
	self.rng = love.math.newRandomGenerator()
	self.sound = common.instance(require "sound")
	self.stage = require("stage")
	self.background = common.instance(require "background")
	self.particles = common.instance(require "particles")
	self.queue = common.instance(Queue)
	self.statemanager = common.instance(require "/libraries/statemanager", self)

	self.controls = {clicked = false, pressedDown = 0}
	self:switchState("gs_title")
	self:reset()

	-- can add more
end

function Game:reset()
	self.rng:setSeed(os.time())
	consts:reset()
	self.sound:reset()
	self.particles:reset()

	-- can add more
end

-- takes a string
function Game:switchState(gamestate)
	self.currentGamestate = require(gamestate)
	self.statemanager:switch(self.currentGamestate)
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
		if consts.timeBucket >= consts.timeStep then
			func(...)
			consts.frame = consts.frame + 1
			consts.timeBucket = consts.timeBucket - consts.timeStep
		end
	end
end

function Game:update(dt)
	consts.timeBucket = consts.timeBucket + dt

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
	mandatory parameters: name, image, imagePushed, endX, endY, action
	optional parameters: duration, startTransparency, endTransparency,
		startX, startY, easing, exit, pushed, pushedSFX, released, startScaling,
		endScaling, releasedSFX, forceMaxAlpha, imageIndex, category
--]]
function Game:_createButton(gamestate, params)
	params = params or {}
	if params.name == nil then print("No object name received!") end
	if params.imagePushed == nil then
		print("Caution: no push image received for " .. params.name .. "!")
	end

	local button = Pic:create{
		name = params.name,
		x = params.startX or params.endX,
		y = params.startY or params.endY,
		transparency = params.startTransparency or 1,
		scaling = params.startScaling or 1,
		image = params.image,
		imageIndex = params.imageIndex,
		container = params.container or gamestate.ui.clickable,
		forceMaxAlpha = params.forceMaxAlpha,
		sound = self.sound,
		category = params.category,
		clickable = true,
	}

	button:change{
		duration = params.duration,
		x = params.endX,
		y = params.endY,
		transparency = params.endTransparency or 1,
		scaling = params.endScaling or 1,
		easing = params.easing or "linear",
		exitFunc = params.exitFunc,
	}
	button.pushed = params.pushed or function(_self)
		_self.sound:newSFX(params.pushedSFX or "button")
		_self:newImage(params.imagePushed)
	end
	button.released = params.released or function(_self)
		if params.releasedSFX then
			_self.sound:newSFX(params.releasedSFX)
		end
		_self:newImage(params.image)
	end

	button.action = params.action -- when clicked/pressed
	button.gamestate = gamestate -- for action context

	return button
end

-------------------------------------------------------------------------------
--[[ creates an object that can be dragged and longpressed
	mandatory parameters: name, image, imagePressed, endX, endY
	optional parameters: duration, startTransparency, endTransparency,
		startX, startY, easing, exit, pushed, pushedSFX, startScaling, endScaling,
		releasedSFX, forceMaxAlpha, imageIndex, longpressed, category
--]]
function Game:_createDraggable(gamestate, params)
	params = params or {}
	if params.name == nil then print("No object name received!") end
	if params.imagePressed == nil then
		print("Caution: no push image received for " .. params.name .. "!")
	end

	local draggable = Pic:create{
		name = params.name,
		x = params.startX or params.endX,
		y = params.startY or params.endY,
		transparency = params.startTransparency or 1,
		scaling = params.startScaling or 1,
		image = params.image,
		imageIndex = params.imageIndex,
		container = params.container or gamestate.ui.draggable,
		forceMaxAlpha = params.forceMaxAlpha,
		sound = self.sound,
		category = params.category,
	}

	draggable:change{
		duration = params.duration,
		x = params.endX,
		y = params.endY,
		transparency = params.endTransparency or 1,
		scaling = params.endScaling or 1,
		easing = params.easing or "linear",
		exitFunc = params.exitFunc,
	}
	draggable.longpressed = params.longpressed or function(_self)
		_self:newImage(params.imagePressed)
	end

	draggable.released = params.released or function(_self)
		_self:newImage(params.image)
	end

	return draggable
end


--[[ creates an object that can be tweened but not clicked
	mandatory parameters: name, image, endX, endY
	optional parameters: duration, startTransparency, endTransparency,
		startX, startY, easing, remove, exitFunc, forceMaxAlpha,
		startScaling, endScaling, container, flipH, imageIndex,
		category
--]]
function Game:_createImage(gamestate, params)
	params = params or {}
	if params.name == nil then print("No object name received!") end

	local button = Pic:create{
		name = params.name,
		x = params.startX or params.endX,
		y = params.startY or params.endY,
		transparency = params.startTransparency or 1,
		scaling = params.startScaling or 1,
		image = params.image,
		imageIndex = params.imageIndex,
		container = params.container or gamestate.ui.static,
		forceMaxAlpha = params.forceMaxAlpha,
		flipH = params.flipH,
		category = params.category,
	}

	button:change{
		duration = params.duration,
		x = params.endX,
		y = params.endY,
		transparency = params.endTransparency or 1,
		scaling = params.endScaling or 1,
		easing = params.easing,
		remove = params.remove,
		exitFunc = params.exitFunc,
	}
	return button
end

--[[ creates an object that displays text
	mandatory parameters: name, font, text, x, y
	optional parameters: RGBColor, imageIndex, transparency, category
--]]
function Game:_createText(gamestate, params)
	params = params or {}
	assert(params.name, "No object name received!")
	assert(consts.FONT[params.font], "No font received or invalid font name!")
	assert(params.text, "No text received!")
	assert(params.x and params.y, "No x-value or y-value received!")

	local text = {
		container = gamestate.ui.text,
		name = params.name,
		font = consts.FONT[params.font],
		text = params.text,
		x = params.x,
		y = params.y,
		color = params.RGBColor or {0, 0, 0},
		imageIndex = params.imageIndex or 0,
		transparency = params.transparency or 1,
		category = params.category,
	}

	text.draw = function(_self)
		if _self.transparency == 0 then return end

		local RGBT = {
			_self.color[1],
			_self.color[2],
			_self.color[3],
			_self.transparency,
		}

		love.graphics.push("all")
			love.graphics.setFont(_self.font)
			love.graphics.setColor(RGBT)
			love.graphics.printf(_self.text, _self.x, _self.y, math.huge, "left")
			-- love.graphics.printf( text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky )
		love.graphics.pop()
	end

	text.update = function(_self) end

	text.remove = function(_self)
		_self.container[_self.name] = nil
	end

	gamestate.ui.text[text.name] = text

	return text
end



local pointIsInRect = require "/helpers/utilities".pointIsInRect

--default controllerPressed function if not specified by a sub-state
function Game:_controllerPressed(x, y, gamestate)
	if self.controls.pressedDown == 0 then
		for _, button in pairs(gamestate.ui.clickable) do
			if pointIsInRect(x, y, button:getRect()) and button.clickable then
				self.controls.clicked = button
				button:pushed()
			end
		end
	end

	self.controls.pressedDown = self.controls.pressedDown + 1
end

-- default controllerReleased function if not specified by a sub-state
function Game:_controllerReleased(x, y, gamestate)
	if self.controls.clicked then
		for _, button in pairs(gamestate.ui.clickable) do
			if self.controls.clicked == button then button:released() end

			if pointIsInRect(x, y, button:getRect())
			and self.controls.clicked == button then
				button.action(button.gamestate, self)
				break
			end
		end

		self.controls.clicked = false
	end

	self.controls.pressedDown = self.controls.pressedDown - 1
end

-- default controllerMoved function if not specified by a sub-state
function Game:_controllerMoved(x, y, gamestate)
	if self.controls.clicked then
		if not pointIsInRect(x, y, self.controls.clicked:getRect()) then
			self.controls.clicked:released()
			self.controls.clicked = false
		end
	end
end


-- get current controller position
function Game:_getControllerPosition()
	local drawspace = consts.drawspace
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
