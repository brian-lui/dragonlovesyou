--[[
This is the base class for almost all game images. Images are represented as
instances of the Pic class, and can use the methods associated with it.

The most useful methods are Pic:create(), Pic:newImage(), Pic:newImageFadeIn(),
Pic:change(), and Pic:wait().
--]]

local love = _G.love
local common = require "class.commons"
local tween = require "/libraries/tween"
local consts = require "/helpers/consts"

local Pic = {}

-- required: x, y, image
-- container to specify different container
-- doesn't assign the created instance to any container by default
function Pic:init(tbl)
	self.queuedMoves = {}
	self.rotation = 0
	self.scaling = 1
	self.transparency = 1
	self.imageIndex = 0

	for k, v in pairs(tbl) do
		self[k] = v
	end
	if tbl.x == nil then print("No x-value received!") end
	if tbl.y == nil then print("No y-value received!") end
	if tbl.image == nil then print("No image received!") end
	if tbl.container then
		assert(tbl.name, "Container specified without name!")
		self.ID = tbl.name
		self.container[tbl.name] = self
	else
		consts.particleCount = consts.particleCount + 1
		self.ID = consts.particleCount
	end

	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
	self.quad = love.graphics.newQuad(
		0,
		0,
		self.width,
		self.height,
		self.width,
		self.height
	)
	self.quadData = {}
end

function Pic:create(params)
	assert(params.x, "x-value not received!")
	assert(params.y, "y-value not received!")
	assert(params.image, "Image not received!")
	if params.container then
		assert(params.name, "Container specified without name!")
	end

	return common.instance(self, params)
end

--[[ Takes the following optional table arguments:
	flipH: whether to draw the image flipped around the horizontal axis
	flipV: whether to draw the image flipped around the vertical axis
	x, y: x or y position to draw the image at
	rotation: rotation number to draw
	scale: scaling to draw
	RGBTable: colors to draw, given as {red, green, blue, alpha}
	transparency: transparency to draw
	image: image to draw
	darkened: draw darker (when pop-up menu is active).
		Overridden by forceMaxAlpha boolean
--]]
function Pic:draw(params)
	if self.transparency == 0 then return end

	params = params or {}
	love.graphics.push("all")
		local scaleX = params.scale or self.scalingX or self.scaling
		local scaleY = params.scale or self.scalingY or self.scaling
		local rgbt = self.RGB or {1, 1, 1}
		rgbt[4] = params.transparency or self.transparency or 1

		if params.darkened and not self.forceMaxAlpha then
			love.graphics.setColor(
				params.darkened,
				params.darkened,
				params.darkened
			)
		elseif params.RGBTable then
			love.graphics.setColor(params.RGBTable)
		elseif self.transparency then
			love.graphics.setColor(rgbt)
		end
		if (self.flipH or params.flipH) then scaleX = scaleX * -1 end
		if (self.flipV or params.flipV) then scaleY = scaleY * -1 end

		love.graphics.draw(
			params.image or self.image,
			self.quad,
			(params.x or self.x) + (self.quadData.offsetX or 0),
			(params.y or self.y) + (self.quadData.offsetY or 0),
			params.rotation or self.rotation,
			scaleX or 1,
			scaleY or 1,
			self.width / 2, -- origin x
			self.height / 2 -- origin y
		)

		if self.newImageData then
			local r, g, b
			if params.RGBTable then
				r, g, b = params.RGBTable[1], params.RGBTable[2], params.RGBTable[3]
			else
				r, g, b = rgbt[1], rgbt[2], rgbt[3]
			end
			love.graphics.setColor(r, g, b, self.newImageData.transparency)
			love.graphics.draw(
			self.newImageData.image,
			self.quad,
			(params.x or self.x) + (self.quadData.offsetX or 0),
			(params.y or self.y) + (self.quadData.offsetY or 0),
			params.rotation or self.rotation,
			scaleX or 1,
			scaleY or 1,
			self.width / 2, -- origin x
			self.height / 2 -- origin y
		)
		end
	love.graphics.pop()
end

function Pic:isStationary()
	return self.moveFunc == nil
end

function Pic:remove()
	if self.container then
		self.container[self.ID] = nil
	end
end

function Pic:getRect()
	local scalingX = self.scalingX or self.scaling
	local scalingY = self.scalingY or self.scaling

	return
		self.x - (self.width / 2) * scalingX,
		self.y - (self.height / 2) * scalingY,
		self.width * scalingX,
		self.height * scalingY
end

-- Instantly swaps current image
function Pic:newImage(image)
	self.image = image
	self.width = image:getWidth()
	self.height = image:getHeight()
	self.quad = love.graphics.newQuad(
		0,
		0,
		self.width,
		self.height,
		self.width,
		self.height
	)
end

-- fades in a new image over the previous one, with optional delay time.
-- will queue a fade with queue_wait_time if something is already fading in.
function Pic:newImageFadeIn(image, frames, delay)
	if self.newImageData then
		self.newImageQueue = self.newImageQueue or {}
		self.newImageQueue[#self.newImageQueue+1] = {
			image = image,
			frames = frames,
			delay = delay or 0,
		}
	else
		self.newImageData = {
			image = image,
			transparency = 0,
			opaque_speed = 1 / frames,
			delay = delay or 0,
		}
	end
end

-- clear the junk from all the tweens and stuff. runs exit function too.
local function clearMove(self)
	if self.exitFunc then
		if type(self.exitFunc) == "function" then -- single func, no args
			self.exitFunc()
		elseif type(self.exitFunc) == "table" then
			if type(self.exitFunc[1]) == "function" then -- single func, args
				self.exitFunc[1](unpack(self.exitFunc, 2))
			elseif type(self.exitFunc[1]) == "table" then -- multiple funcs
				for i = 1, #self.exitFunc do
					self.exitFunc[i][1](unpack(self.exitFunc[i], 2))
				end
			else -- wot
				print("passed in something wrong for exitFunc table")
			end
		else -- wot
			print("maybe passed in something wrong for the exitFunc property")
		end
	end
	if self.removeOnExit then self:remove() end
	self.t, self.tweening, self.curve, self.moveFunc = nil, nil, nil, nil
	self.during, self.duringFrame = nil, nil
	self.exit, self.exitFunc = nil, nil
end

-- this is called from createMoveFunc and from some UI functions
function Pic:setQuad(x, y, w, h)
	self.quad = love.graphics.newQuad(x, y, w, h, self.width, self.height)
	self.quadData = {
		offsetX = x or 0,
		offsetY = y or 0,
		x = self.x + (x or 0),
		y = self.y + (y or 0),
		pctX = w / self.width,
		pctY = h / self.height,
	}
end

-- create the moveFunc that's updated each pic:update()
local function createMoveFunc(self, target)
	-- convert numbers into function equivalents
	local functionize = {
		"x",
		"y",
		"rotation",
		"transparency",
		"scaling",
		"scalingX",
		"scalingY",
	}
	for i = 1, #functionize do
		local item = functionize[i]
		if target[item] then
			if type(target[item]) == "number" then
				local original = self[item] or 1
				local diff = target[item] - original
				target[item] = function() return original + diff * self.t end
				if target.debug then
					print("converting number into function for " .. item)
				end
			else
				if target.debug then
					print("using provided function for " .. item)
				end
			end
		else
			target[item] = function() return self[item] end
		end
	end

	-- create some yummy state
	self.during, self.duringFrame = target.during, 0
	self.removeOnExit = target.remove
	self.exitFunc = target.exitFunc
	self.t = 0
	self.tweening = tween.new(
		target.duration,
		self,
		target.tweenTarget,
		target.easing
	)
	if target.debug then print("duration:", target.duration) end

	-- set the x/y function depending on if it's a bezier or not
	local xyFunc = function() return target.x(), target.y() end
	if target.curve then
		if target.debug then print("creating bezier curve move func") end
		xyFunc = function(_self) return _self.curve:evaluate(_self.t) end
		self.curve = target.curve
	end

	-- set the quad change function if provided
	local quadFunc = nil
	if target.quad then
		local startX_pct = self.quadData.pctX or (target.quad.x and 0 or 1)
		local endX_pct = target.quad.percentageX or 1
		local startY_pct = self.quadData.pctY or (target.quad.y and 0 or 1)
		local endY_pct = target.quad.percentageY or 1

		quadFunc = function(_self)
			local cur_pctX = (endX_pct - startX_pct) * _self.t + startX_pct
			local curWidth = cur_pctX * _self.width
			local curX = target.quad.x and target.quad.anchorX * (1-_self.t) * _self.width * endX_pct or 0
			local cur_pctY = (endY_pct - startY_pct) * _self.t + startY_pct
			local curHeight = cur_pctY * _self.height
			local curY = target.quad.y and target.quad.anchorY * (1-_self.t) * _self.height * endY_pct or 0
			_self:setQuad(curX, curY, curWidth, curHeight)
		end
	end

	-- create the moveFunc
	local moveFunc = function(_self, dt)
		_self.t = _self.t + dt / target.duration
		local complete = _self.tweening:update(dt)
		_self.x, _self.y = xyFunc(_self)
		_self.rotation = target.rotation()
		_self.transparency = target.transparency()
		_self.scaling = target.scaling()
		_self.scalingX = target.scalingX()
		_self.scalingY = target.scalingY()
		if quadFunc then quadFunc(_self, dt) end
		if target.debug then
			target.debugCounter = ((target.debugCounter or 0) + 1) % 10
			if target.debugCounter == 0 then
				print("current x, current y:", _self.x, _self.y)
			end
		end
		if complete then
			if target.debug then print("Tween ended") end
			return true
		end
	end

	return moveFunc
end

--[[ Tell the pic how to move.
	Takes the following table parameters:
		duration: amount of time for movement, in frames
			If not provided, instantly moves there
		x: target x location, or function
			e.g. x = function() return self.y^2 end
		y: target y location, or function
		rotation: target rotation, or function
		scaling: target scaling, or function
		scalingX, scalingY: target scaling in one axis
			takes precedence over "scaling" parameter
		transparency: target transparency, or function
		easing: easing, default is "linear"
		tweenTarget: variables to tween, default is {t = 1}
		curve: bezier curve, provided as a love.math.newBezierCurve() object
		queue: queue this move after the previous one is finished. default true
		here: if true, will instantly move from current position
			false to move from end of previous position
			only used if queue is false
		during: optionally provided as {frameStep, frame_start, func, args}
			or {{fs1, fs1, f1, a1}, {fs2, fs2, f2, a2}, ...}
			executes this every dt_step while tweening
		remove: set to true to delete when the move finishes
		exitFunc: execute when the move finishes.
			Can be 1) func, 2) {func, args}, 3) {{f1, a1}, {f2, a2}, ...}
		quad: Tween a quad, with parameters of {
			x = bool,
			y = bool,
			percentageX = 0-1,
			percentageY = 0-1,
			anchorX = 0-1,
			anchorY = 0-1
		}
		debug: print some unhelpful debug info
	Junk created: self.t, moveFunc, tweening, curve, exit, during. duringFrame
	Cleans up after itself when movement or tweening finished during Pic:update()
--]]
function Pic:change(target)
	target.easing = target.easing or "linear"
	target.tweenTarget = target.tweenTarget or {t = 1}
	if target.queue ~= false then target.queue = true end
	if target.debug then print("New move instruction received")	end
	if target.duration == 0 then target.duration = 0.0078125 end

	if not target.duration then -- apply instantly, interrupting all moves
		clearMove(self)
		self.queuedMoves = {}
		self.x = target.x or self.x
		self.y = target.y or self.y
		self.rotation = target.rotation or self.rotation
		self.scaling = target.scaling or self.scaling
		self.scalingX = target.scalingX or self.scalingX
		self.scalingY = target.scalingY or self.scalingY
		self.transparency = target.transparency or self.transparency
		if target.debug then print("Instantly moving image") end
	elseif not self.moveFunc then -- no active tween, apply this immediately
		self.moveFunc = createMoveFunc(self, target)
		if target.debug then
			print("No active tween, applying immediately")
			print("self.moveFunc is now ", self.moveFunc)
		end
	elseif target.queue then -- append to end of self.queuedMoves
		self.queuedMoves[#self.queuedMoves+1] = target
		if target.debug then
			print("Queueing this tween")
		end
	elseif target.here then -- clear queue, tween from current position
		clearMove(self)
		self.queuedMoves = {}
		self.moveFunc = createMoveFunc(self, target)
		if target.debug then
			print("Tweening from current position")
			print("self.moveFunc is now ", self.moveFunc)
		end
	else -- clear queue, tween from end position
		self:moveFunc(math.huge)
		clearMove(self)
		self.queuedMoves = {}
		self.moveFunc = createMoveFunc(self, target)
		if target.debug then
			print("Queueing from end position")
			print("self.moveFunc is now ", self.moveFunc)
		end
	end
end

-- queues a wait during the move animation, in frames. 0 duration is ok I guess
function Pic:wait(frames)
	self:change{duration = frames}
end

function Pic:resolve()
	while self.moveFunc do
		self:moveFunc(math.huge)
		clearMove(self)
		if #self.queuedMoves > 0 then
			local newTarget = table.remove(self.queuedMoves, 1)
			self.moveFunc = createMoveFunc(self, newTarget)
		end
	end
end
-- clears all moves
function Pic:clear()
	self.t, self.tweening, self.curve, self.moveFunc = nil, nil, nil, nil
	self.during, self.duringFrame = nil, nil
	self.exit = nil
	self.exitFunc = nil
	self.queuedMoves = {}
end

function Pic:update(dt)
	dt = dt / consts.timeStep  -- convert dt to frames
	if self.moveFunc then
		if self.during then -- takes {frameStep, frame_start, func, args}
			self.duringFrame = self.duringFrame + 1
			if type(self.during[1]) == "table" then -- multiple funcs
				for i = 1, #self.during do
					local step, start = self.during[i][1], self.during[i][2]
					if (self.duringFrame + start) % step == 0 then
						self.during[i][3](table.unpack(self.during[i], 4))
					end
				end
			else -- single func
				local step, start = self.during[1], self.during[2]
				if (self.duringFrame + start) % step == 0 then
					self.during[3](table.unpack(self.during, 4))
				end
			end
		end

		local finished = self:moveFunc(dt)
		if finished then
			clearMove(self)
			if #self.queuedMoves > 0 then
				local newTarget = table.remove(self.queuedMoves, 1)
				if newTarget.image_swap then
					self.image = newTarget.image
					self.width = newTarget.width
					self.height = newTarget.height
					self.quad = newTarget.quad
					self.moveFunc = function() return true end
				else
					self.moveFunc = createMoveFunc(self, newTarget)
				end
			end
		end
	end
	if self.newImageData then
		if self.newImageData.delay > 0 then
			self.newImageData.delay = math.max(self.newImageData.delay - 1, 0)
		else
			self.newImageData.transparency = self.newImageData.transparency + self.newImageData.opaque_speed
			if self.newImageData.transparency >= 1 then
				self.image = self.newImageData.image
				self.newImageData = nil
				if self.newImageQueue then
					if self.newImageQueue[1] then
						local newImageData = table.remove(self.newImageQueue, 1)
						self.newImageData = {
							image = newImageData.image,
							transparency = 0,
							opaque_speed = 1 / newImageData.frames,
							delay = newImageData.delay,
						}
					else
						self.newImageQueue = nil
					end
				end
			end
		end
	end
end

return common.class("Pic", Pic)
