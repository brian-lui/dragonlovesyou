--[[
This is the entry module for LOVE2D.
The main stuff is actually in game.lua.
--]]

-- For compatibility; Lua 5.3 moved unpack to table.unpack
_G.table.unpack = _G.table.unpack or _G.unpack

local love = _G.love
require "/libraries/classcommons"
local common = require "class.commons"
local consts = require "/helpers/consts"

function love.load()
	print("Debug folder is at: " .. love.filesystem.getSaveDirectory())
	love.window.setTitle("Dragon loves you")
	game = common.instance(require "game")

	-- set resolution depending on OS
	local osString = love.system.getOS()
	if osString == "Windows" or osString == "OS X" or osString == "Linux" then
		local windowWidth, windowHeight = love.window.getDesktopDimensions()
		love.window.setMode(windowWidth / 2, windowHeight / 2, {resizable=true})
	elseif osString == "Android" or osString == "iOS" then
		local windowWidth, windowHeight = love.graphics.getDimensions()
		love.window.setMode(windowWidth, windowHeight, {
			fullscreen = true,
			usedpiscale = false,
		})
	end

	-- TODO: set icon
	--local icon = love.image.newImageData("/images/unclickables/windowicon.png")
	--love.window.setIcon(icon)
end


function love.quit()
	local lily = require "/libraries/lily"
	lily.quit()
end

local backgroundRGB = {0, 0, 0, 0.4}
function love.draw()
	game:drawBackground()

	local drawspace = consts.drawspace
	drawspace.tlfres.beginRendering(drawspace.width, drawspace.height)
		game:draw()
	drawspace.tlfres.endRendering(backgroundRGB)
end

function love.update(dt)
	game.update(game, dt)
end

function love.keypressed(key)
	game.keypressed(game, key)
end

function love.mousepressed(x, y, button, istouch)
	if button == 1 then
		local drawspace = consts.drawspace
		x, y = drawspace.tlfres.getMousePosition(drawspace.width, drawspace.height)
		game.mousepressed(game, x, y, button, istouch)
	end
end

function love.mousereleased(x, y, button, istouch)
	if button == 1 then
		local drawspace = consts.drawspace
		x, y = drawspace.tlfres.getMousePosition(drawspace.width, drawspace.height)
		game.mousereleased(game, x, y, button, istouch)
	end
end

function love.mousemoved(x, y, dx, dy)
	if game.mousemoved then
		local drawspace = consts.drawspace
		x, y = drawspace.tlfres.getMousePosition(drawspace.width, drawspace.height)
		local scale = drawspace.tlfres.getScale(drawspace.width, drawspace.height)
		dx, dy = dx / scale, dy / scale
		game:mousemoved(x, y, dx, dy)
	end
end
