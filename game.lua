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

	self.controls = {
		clicked = false,
		lastClickedFrame = false,
		lastClickedX = false,
		lastClickedY = false,
		pressedDown = 0,
	}

	self:switchState("gs_title")
	self:reset()
end

function Game:reset()
	self.rng:setSeed(os.time())
	consts:reset()
	self.sound:reset()
	self.particles:reset()
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

		local obj = self.controls.clicked
		if self.lastClickedFrame
		and (consts.frame - self.lastClickedFrame > consts.LONGPRESS_FRAMES)
		and obj
		and obj.longpressable then
			obj:longpressFunc()
			obj.longpressed = true
			obj.longpressable = false
			obj.draggable = false
			obj.dragged = false
		end
		-- other logic stuff
	end)

	self.sound:update()
	self.particles:update(dt)
	-- other non-logic update stuff
end

function Game:drawBackground()
	self.currentGamestate.currentBackground:draw()
end

-------------------------------------------------------------------------------
--[[ create a clickable object
	mandatory parameters: name, image, imagePushed, endX, endY, action
	optional parameters: duration, startTransparency, endTransparency,
		startX, startY, easing, exit, pushedFunc, pushedSFX, releasedFunc, startScaling,
		endScaling, releasedSFX, forceMaxAlpha, imageLayer, category, extraInfo
--]]
function Game:_createButton(gamestate, params)
	params = params or {}
	assert(params.name, "No object name received!")
	assert(params.imagePushed, "No imagePushed received!")

	local button = Pic:create{
		name = params.name,
		x = params.startX or params.endX,
		y = params.startY or params.endY,
		transparency = params.startTransparency or 1,
		scaling = params.startScaling or 1,
		image = params.image,
		imageLayer = params.imageLayer,
		container = params.container or gamestate.ui.clickable,
		forceMaxAlpha = params.forceMaxAlpha,
		sound = self.sound,
		category = params.category,
		extraInfo = params.extraInfo,
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
	button.pushedFunc = params.pushedFunc or function(_self)
		_self.sound:newSFX(params.pushedSFX or "button")
		_self:newImage(params.imagePushed)
	end
	button.releasedFunc = params.releasedFunc or function(_self)
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
	mandatory parameters: name, image, endX, endY
	optional parameters: duration, startTransparency, endTransparency,
		startX, startY, easing, exit, pushedSFX, startScaling, endScaling,
		releasedSFX, forceMaxAlpha, imageLayer, longpressFunc, category, imagePressed
		releasedFunc, extraInfo
--]]
function Game:_createDraggable(gamestate, params)
	params = params or {}
	assert(params.name, "No object name received!")

	local draggable = Pic:create{
		name = params.name,
		x = params.startX or params.endX,
		y = params.startY or params.endY,
		transparency = params.startTransparency or 1,
		scaling = params.startScaling or 1,
		image = params.image,
		imageLayer = params.imageLayer,
		container = params.container or gamestate.ui.draggable,
		forceMaxAlpha = params.forceMaxAlpha,
		sound = self.sound,
		category = params.category,
		extraInfo = params.extraInfo,
		longpressable = true,
		longpressed = false,
		draggable = true,
		dragged = false,
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

	draggable.pushedFunc = params.pushedFunc or function(_self)
		_self.sound:newSFX(params.pushedSFX or "button")
	end

	draggable.longpressFunc = params.longpressFunc or function(_self)
		_self:newImage(params.imagePressed)
	end

	draggable.releasedFunc = params.releasedFunc or function(_self)
		_self:newImage(params.image)
	end

	return draggable
end


--[[ creates an object that can be tweened but not clicked
	mandatory parameters: name, image, endX, endY
	optional parameters: duration, startTransparency, endTransparency,
		startX, startY, easing, remove, exitFunc, forceMaxAlpha,
		startScaling, endScaling, container, flipH, imageLayer,
		category, extraInfo
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
		imageLayer = params.imageLayer,
		container = params.container or gamestate.ui.static,
		forceMaxAlpha = params.forceMaxAlpha,
		flipH = params.flipH,
		category = params.category,
		extraInfo = params.extraInfo,
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
	optional parameters: RGBColor, imageLayer, transparency, category,
	extraInfo, align, attachedObject, attachedObjectXOffset, attachedObjectYOffset
--]]
function Game:_createText(gamestate, params)
	params = params or {}
	assert(params.name, "No object name received!")
	assert(consts.FONT[params.font], "No font received or invalid font name!")
	assert(params.text, "No text received!")
	assert(params.x and params.y, "No x-value or y-value received!")
	if params.align then
		assert(
			params.align == "left" or
			params.align == "center" or
			params.align == "right",
			"Incorrect alignment specified!"
		)
	end

	local text = {
		container = gamestate.ui.text,
		name = params.name,
		font = consts.FONT[params.font],
		text = params.text,
		align = params.align or "left",
		x = params.x,
		y = params.y,
		color = params.RGBColor or {0, 0, 0},
		imageLayer = params.imageLayer or 0,
		transparency = params.transparency or 1,
		attachedObject = params.attachedObject,
		attachedObjectXOffset = params.attachedObjectXOffset,
		attachedObjectYOffset = params.attachedObjectYOffset,
		category = params.category,
		extraInfo = params.extraInfo,
	}
	text.width = text.font:getWidth(text.text)

	text.draw = function(_self)
		if _self.transparency == 0 then return end

		local RGBT = {
			_self.color[1],
			_self.color[2],
			_self.color[3],
			_self.transparency,
		}

		love.graphics.push("all")
			love.graphics.setColor(RGBT)
			local x
			if _self.align == "left" then
				x = _self.x
			elseif _self.align == "center" then
				x = _self.x - _self.width * 0.5
			elseif _self.align == "right" then
				x = _self.x - _self.width
			end

			love.graphics.printf(_self.text, _self.font, x, _self.y, _self.width)
		love.graphics.pop()
	end

	text.update = function(_self)
		if _self.attachedObject then
			_self.x = _self.attachedObject.x + _self.attachedObjectXOffset
			_self.y = _self.attachedObject.y + _self.attachedObjectYOffset
		end
	end

	text.remove = function(_self)
		_self.container[_self.name] = nil
	end

	text.changeText = function(_self, newText)
		_self.text = newText
		_self.width = _self.font:getWidth(_self.text)
	end

	gamestate.ui.text[text.name] = text

	return text
end



local pointIsInRect = require "/helpers/utilities".pointIsInRect

--default controllerPressed function if not specified by a sub-state
function Game:_controllerPressed(x, y, gamestate)
	if self.controls.pressedDown == 0 then
		local clickedItems = {}

		for _, button in pairs(gamestate.ui.clickable) do
			if pointIsInRect(x, y, button:getRect()) and button.clickable then
				clickedItems[#clickedItems + 1] = button
			end
		end

		for _, obj in pairs(gamestate.ui.draggable) do
			if pointIsInRect(x, y, obj:getRect()) and
			(obj.draggable or obj.longpressable) then
				clickedItems[#clickedItems + 1] = obj
			end
		end

		if #clickedItems > 0 then
			local function sortFunc(a, b)
				return a.imageLayer > b.imageLayer
			end

			table.sort(clickedItems, sortFunc)

			self.controls.clicked = clickedItems[1]
			clickedItems[1]:pushedFunc()
			self.lastClickedFrame = consts.frame
			self.lastClickedX = x
			self.lastClickedY = y
		end
	end

	self.controls.pressedDown = self.controls.pressedDown + 1
end

-- default controllerReleased function if not specified by a sub-state
function Game:_controllerReleased(x, y, gamestate)
	if self.controls.clicked then
		for _, button in pairs(gamestate.ui.clickable) do
			if self.controls.clicked == button then
				button:releasedFunc()

				if pointIsInRect(x, y, button:getRect()) then
					button.action(button.gamestate)
				end
			end
		end

		for _, obj in pairs(gamestate.ui.draggable) do
			if self.controls.clicked == obj then
				obj:releasedFunc()
				obj.dragged = false
				obj.draggable = true
				obj.longpressed = false
				obj.longpressable = true

				if not obj.skipSnapback then
					obj:change{	duration = 5, x = obj.originalX, y = obj.originalY}
					obj.originalX = nil
					obj.originalY = nil
				end
			end
		end

		self.controls.clicked = false
		self.lastClickedFrame = false
		self.lastClickedX = false
		self.lastClickedY = false
	end

	self.controls.pressedDown = self.controls.pressedDown - 1
end

-- default controllerMoved function if not specified by a sub-state
function Game:_controllerMoved(x, y, gamestate)
	local obj = self.controls.clicked
	if obj then
		if obj.draggable then
			if not obj.originalX then obj.originalX = obj.x end
			if not obj.originalY then obj.originalY = obj.y end

			obj.x = x
			obj.y = y
			obj.dragged = true
			obj.longpressable = false
			obj.longpressed = false
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
	local debugKeys = require "/helpers/debugkeys"
	debugKeys.keypressed(key)
end

return common.class("Game", Game)
