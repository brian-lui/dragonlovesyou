--[[
This is the module for loading all the game images that aren't character
specific. It uses a multithreaded image loader to improve performance.
--]]

local love = _G.love
local lily = require "/libraries/lily"

local achievement = {
	"1p", "1ptag", "2p", "2ptag", "3p", "3ptag", "4p", "4ptag", "back", "book",
	"doodle", "endings", "highestscore", "next", "pic", "press",
}

local actionart = {
	"tv", "nap", "camping", "ant", "globe", "healspell", "fly", "fire",
}

local actionselect = {
	"actionpopup", "battleground", "battlegroundtag", "card", "center",
	"centerbare", "home", "hometag", "shop", "shoptag", "library",
	"librarytag", "outing", "outingtag", "separationcenter",
}
local cardart = {
	"idea", "magic", "sleepydragon",
	"comfy", "hype", "shopper", "family", "empathy", "excitement", "relax",
}

local cardui = {
	"back", "title",
}

local coparent = {
	"2p", "3p", "4p", "nametag", "p1", "p2", "p3", "p4", "playerschedule",
	"quickdown",
}

local dreamart = {
	"pyro", "binge", "heal", "study",
}

local dreamui = {
	"dream", "goal", "personal",
}

local finalizescreen = {
	"back", "screendark", "skip",
}

local gui = {
	"actionbox", "activitiesbutton", "activitiesframe", "activitysubmenuframe",
	"activitiestxt", "canceltxt", "coparent", "dragonmoonicon", "finalizetxt",
	"progressbookicon", "questionicon", "scheduleframe", "scheduletxt",
	"screendark", "screentransparent", "settingsicon",

	"cardcloseup_box",

	"progress_bar", "progress_infoscreen", "progress_tag",

	"stats_actionicon", "stats_actionplusblock", "stats_blockback",
	"stats_blockframe", "stats_blue", "stats_energyback", "stats_energyicon",
	"stats_happyicon", "stats_loveicon", "stats_moneyplusblock",
	"stats_pink", "stats_yellow",
}

local items = {
	"logiccube",
}
local particles = {
	"pow",
}

local personality = {
	"cloud", "hate", "love", "middle",
}

local shop = {
	"banner", "buy", "cardback", "cost", "gem", "itemback", "shopback", "view",
}

local story = {
	"money", "start1", "start2", "storyback", "storyframe",
}
local title = {
	"achievements", "achievementspressed", "extras", "extraspressed",
	"newgame", "newgamepressed", "ongoingback", "ongoinggameback", "ongoingtitle",
	"quit", "quitpressed", "settings", "settingspressed",
}




-- categories to create, in the form [key] = {category}
-- assumes that key is the same as pathname
-- e.g. buttons = buttons will create
-- imageNames["buttons_" .. item] = "images/buttons/" .. item .. ".png"
local categories = {
	achievement = achievement,
	actionart = actionart,
	actionselect = actionselect,
	cardart = cardart,
	cardui = cardui,
	coparent = coparent,
	dreamart = dreamart,
	dreamui = dreamui,
	finalizescreen = finalizescreen,
	gui = gui,
	items = items,
	particles = particles,
	personality = personality,
	shop = shop,
	story = story,
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
