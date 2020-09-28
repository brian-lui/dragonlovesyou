--[[
This is the module for loading all the game images that aren't character
specific. It uses a multithreaded image loader to improve performance.
--]]

local love = _G.love
local lily = require "/libraries/lily"

local main = {
	"mainlogo",
}

local title = {
	"wallpaper", "logo", "start", "achievements", "options", "quit",
}

-- categories to create, in the form [key] = {category}
-- assumes that key is the same as pathname
-- e.g. buttons = buttons will create
-- imageNames["buttons_" .. item] = "images/buttons/" .. item .. ".png"
local categories = {
	main = main,
	title = title,
}

local images = {
	lookup = {},
	dummy = love.graphics.newImage('images/dummy.png'),
}

local imageNames = {}
local lilyTable = {}
local lilyCount = 1
for str, tbl in pairs(categories) do
	for _, item in pairs(tbl) do
		local handle = str .. "_" .. item
		local filepath = "images/" .. str .. "/" .. item .. ".png"
		imageNames[handle] = filepath

		lilyTable[lilyCount] = {handle = handle, filepath = filepath}
		lilyCount = lilyCount + 1
	end
end

-- Create the lily data table
local to_load = {}
for i, tbl in ipairs(lilyTable) do
	to_load[i] = {"newImage", tbl.filepath}
end

local function processImage(i, imagedata)
	local handle = lilyTable[i].handle
	images[handle] = imagedata
end

local multilily = lily.loadMulti(to_load)
multilily:onLoaded(function(_, i, imagedata) processImage(i, imagedata) end)

-- If an image isn't loaded yet but is called, immediately load it
local fallback = {
	__index = function(t, k)
		--print("loading image as fallback " .. k)
		local image
		local success = pcall(
			function() image = love.graphics.newImage(imageNames[k]) end
		)
		assert(success, "Failed to load " .. k)
		t[k] = image
		return image
	end
}
setmetatable(images, fallback)

return images
