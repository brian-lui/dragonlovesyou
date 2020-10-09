local images = require "images"
local stage = require "stage"

-------------------------------------------------------------------------------
------------------------------------ TITLE ------------------------------------
-------------------------------------------------------------------------------

local titleImages = {
	{
		name = "wallpaper",
		image = images.title_wallpaper,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		imageIndex = -2,
	},
	{
		name = "splash",
		image = images.title_splash,
		duration = 15,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		startTransparency = 0,
		easing = "linear",
		imageIndex = -1,
	},
	{
		name = "logo",
		image = images.title_logo,
		duration = 30,
		endX = stage.width * 0.25,
		endY = stage.height * 0.75,
		startTransparency = 0,
		easing = "linear",
	},
}

local titleButtons = {
	{
		name = "start",
		image = images.title_start,
		imagePushed = images.title_start,
		duration = 60,
		startX = stage.width * -0.2,
		endX = stage.width * 0.75,
		endY = stage.height * 0.55,
		easing = "inQuart",
		action = function(_, game)
			game:switchState("gs_arrangeschedule")
		end,
	},
	{
		name = "achievements",
		image = images.title_achievements,
		imagePushed = images.title_achievements,
		duration = 60,
		startX = stage.width * -0.2,
		endX = stage.width * 0.75,
		endY = stage.height * 0.65,
		easing = "inQuart",
		action = function()
		end,
	},
	{
		name = "options",
		image = images.title_options,
		imagePushed = images.title_options,
		duration = 60,
		startX = stage.width * -0.2,
		endX = stage.width * 0.75,
		endY = stage.height * 0.75,
		easing = "inQuart",
		action = function()
		end,
	},
	{
		name = "quit",
		image = images.title_quit,
		imagePushed = images.title_quit,
		duration = 60,
		startX = stage.width * -0.2,
		endX = stage.width * 0.75,
		endY = stage.height * 0.85,
		easing = "inQuart",
		action = function()
		end,
	},
}

local titleDraggables = {
}

local titleText = {
}


-------------------------------------------------------------------------------
------------------------------- ARRANGESCHEDULE -------------------------------
-------------------------------------------------------------------------------

local arrangeScheduleImages = {
	{
		name = "screendark",
		image = images.gui_screendark,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		endTransparency = 0,
		imageIndex = 0,
	},
	{
		name = "activitiesframe",
		image = images.gui_activitiesframe,
		endX = stage.width * 0.15,
		endY = stage.height * 0.29,
		imageIndex = -3,
	},
	{
		name = "activitiestxt",
		image = images.gui_activitiestxt,
		endX = stage.width * 0.15,
		endY = stage.height * 0.05,
		imageIndex = -2,
	},
	{
		name = "actionbox",
		image = images.gui_actionbox,
		endX = stage.width * 0.15,
		endY = stage.height * 0.12,
		imageIndex = -1,
	},
	{
		name = "scheduleframe",
		image = images.gui_scheduleframe,
		endX = stage.width * 0.87,
		endY = stage.height * 0.45,
		imageIndex = -3,
	},
	{
		name = "scheduletxt",
		image = images.gui_scheduletxt,
		endX = stage.width * 0.87,
		endY = stage.height * 0.15,
		imageIndex = -2,
	},
	{
		name = "coparent",
		image = images.gui_coparent,
		endX = stage.width * 0.68,
		endY = stage.height * 0.05,
		imageIndex = -1,
	},
	{
		name = "finalize",
		image = images.gui_finalizetxt,
		endX = stage.width * 0.88,
		endY = stage.height * 0.05,
		imageIndex = -1,
	},
	{
		name = "moneyplusblock",
		image = images.gui_stats_moneyplusblock,
		endX = stage.width * 0.07,
		endY = stage.height * 0.74,
		imageIndex = -2,
	},
	{
		name = "actionplusblock",
		image = images.gui_stats_actionplusblock,
		endX = stage.width * 0.07,
		endY = stage.height * 0.79,
		imageIndex = -2,
	},
	{
		name = "energyback",
		image = images.gui_stats_energyback,
		endX = stage.width * 0.08,
		endY = stage.height * 0.915,
		imageIndex = -2,
	},
	{
		name = "energyicon",
		image = images.gui_stats_energyicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.87,
		imageIndex = -1,
	},
	{
		name = "happyicon",
		image = images.gui_stats_happyicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.92,
		imageIndex = -1,
	},
	{
		name = "loveicon",
		image = images.gui_stats_loveicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.97,
		imageIndex = -1,
	},
	{
		name = "energyblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.87,
		imageIndex = -2,
	},
	{
		name = "happyblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.92,
		imageIndex = -2,
	},
	{
		name = "loveblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.97,
		imageIndex = -2,
	},
	{
		name = "dragonmoonicon",
		image = images.gui_dragonmoonicon,
		endX = stage.width * 0.89,
		endY = stage.height * 0.93,
		imageIndex = -1,
	},
	{
		name = "questionicon",
		image = images.gui_questionicon,
		endX = stage.width * 0.96,
		endY = stage.height * 0.89,
		imageIndex = -1,
	},
	{
		name = "settingsicon",
		image = images.gui_settingsicon,
		endX = stage.width * 0.96,
		endY = stage.height * 0.96,
		imageIndex = -1,
	},

	{
		name = "pb_tag",
		image = images.gui_progress_tag,
		endX = stage.width * 0.2,
		endY = stage.height * 0.12,
		imageIndex = 1,
		category = "progress",
	},
	{
		name = "pb_bar_attack",
		image = images.gui_progress_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 0),
		imageIndex = 1,
		category = "progress",
	},
	{
		name = "pb_bar_defense",
		image = images.gui_progress_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 1),
		imageIndex = 1,
		category = "progress",
	},
	{
		name = "pb_bar_flight",
		image = images.gui_progress_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 2),
		imageIndex = 1,
		category = "progress",
	},

	{
		name = "pb_bar_fire",
		image = images.gui_progress_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 0),
		imageIndex = 1,
		category = "progress",
	},
	{
		name = "pb_bar_water",
		image = images.gui_progress_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 1),
		imageIndex = 1,
		category = "progress",
	},
	{
		name = "pb_bar_earth",
		image = images.gui_progress_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 2),
		imageIndex = 1,
		category = "progress",
	},
	{
		name = "pb_bar_ice",
		image = images.gui_progress_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 3),
		imageIndex = 1,
		category = "progress",
	},
	{
		name = "pb_bar_light",
		image = images.gui_progress_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 4),
		imageIndex = 1,
		category = "progress",
	},
	{
		name = "pb_bar_dark",
		image = images.gui_progress_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 5),
		imageIndex = 1,
		category = "progress",
	},

	{
		name = "pb_bar_world",
		image = images.gui_progress_bar,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 0),
		imageIndex = 1,
		category = "progress",
	},
	{
		name = "pb_bar_science",
		image = images.gui_progress_bar,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 1),
		imageIndex = 1,
		category = "progress",
	},
	{
		name = "pb_bar_math",
		image = images.gui_progress_bar,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 2),
		imageIndex = 1,
		category = "progress",
	},
}

local arrangeScheduleButtons = {
	{
		name = "dragongoal",
		image = images.dreams_card2,
		imagePushed = images.dreams_card2,
		endX = stage.width * 0.38,
		endY = stage.height * 0.07,
		endScaling = 0.2,
		imageIndex = -1,
		action = function(ArrangeSchedule)
			ArrangeSchedule:showDragonGoal()
		end,
	},
	{
		name = "dragondream",
		image = images.dreams_card1,
		imagePushed = images.dreams_card1,
		endX = stage.width * 0.5,
		endY = stage.height * 0.07,
		endScaling = 0.2,
		imageIndex = -1,
		action = function(ArrangeSchedule)
			ArrangeSchedule:showDragonDream()
		end,
	},
	{
		name = "progressbookicon",
		image = images.gui_progressbookicon,
		imagePushed = images.gui_progressbookicon,
		endX = stage.width * 0.8,
		endY = stage.height * 0.93,
		imageIndex = -1,
		action = function(ArrangeSchedule)
			ArrangeSchedule:showProgressBook()
		end,
	},

	{
		name = "pb_infoscreen",
		image = images.gui_progress_infoscreen,
		imagePushed = images.gui_progress_infoscreen,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		imageIndex = 1,
		action = function(ArrangeSchedule)
			ArrangeSchedule:hideProgressBook()
		end,
		category = "progress",
	},

	{
		name = "dream_screendark",
		image = images.gui_screendark,
		imagePushed = images.gui_screendark,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		imageIndex = 0,
		action = function(ArrangeSchedule)
			ArrangeSchedule:hideDragonDream()
		end,
		category = "dragondream",
	},

	{
		name = "goal_screendark",
		image = images.gui_screendark,
		imagePushed = images.gui_screendark,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		imageIndex = 0,
		action = function(ArrangeSchedule)
			ArrangeSchedule:hideDragonGoal()
		end,
		category = "dragongoal",
	},

}

local arrangeScheduleDraggables = {
}

local arrangeScheduleText = {
	{
		name = "pb_dragonability",
		font = "BIG",
		text = "DRAGON ABILITY",
		x = stage.width * 0.05,
		y = stage.height * 0.18,
		imageIndex = 2,
		category = "progress",
	},
	{
		name = "pb_magic",
		font = "BIG",
		text = "MAGIC",
		x = stage.width * 0.05,
		y = stage.height * 0.45,
		imageIndex = 2,
		category = "progress",
	},
	{
		name = "pb_knowledge",
		font = "BIG",
		text = "KNOWLEDGE",
		x = stage.width * 0.4,
		y = stage.height * 0.18,
		imageIndex = 2,
		category = "progress",
	},

	{
		name = "pb_dragonability_substats",
		font = "MEDIUM",
		text = "ATTACK\nDEFENSE\nFLIGHT",
		x = stage.width * 0.05,
		y = stage.height * 0.25,
		imageIndex = 2,
		category = "progress",
	},
	{
		name = "pb_magic_substats",
		font = "MEDIUM",
		text = "FIRE\nWATER\nEARTH\nICE\nLIGHT\nDARK",
		x = stage.width * 0.05,
		y = stage.height * 0.52,
		imageIndex = 2,
		category = "progress",
	},
	{
		name = "pb_knowledge_substats",
		font = "MEDIUM",
		text = "WORLD\nSCIENCE\nMATH",
		x = stage.width * 0.4,
		y = stage.height * 0.25,
		imageIndex = 2,
		category = "progress",
	},
}


local lookup = {
	ArrangeSchedule = {
		images = arrangeScheduleImages,
		buttons = arrangeScheduleButtons,
		draggables = arrangeScheduleDraggables,
		text = arrangeScheduleText,
	},
	Title = {
		images = titleImages,
		buttons = titleButtons,
		draggables = arrangeScheduleDraggables,
		text = titleText,
	},
}

local assetData = {}
function assetData.getImages(gamestateName, aspectRatioOrWhatever)
	assert(lookup[gamestateName].images, "No images for gamestate " .. gamestateName)
	return lookup[gamestateName].images
end

function assetData.getButtons(gamestateName, aspectRatioOrWhatever)
	assert(lookup[gamestateName].buttons, "No buttons for gamestate " .. gamestateName)
	return lookup[gamestateName].buttons
end

function assetData.getDraggables(gamestateName, aspectRatioOrWhatever)
	assert(lookup[gamestateName].draggables, "No draggables for gamestate " .. gamestateName)
	return lookup[gamestateName].draggables
end

function assetData.getText(gamestateName, aspectRatioOrWhatever)
	assert(lookup[gamestateName].text, "No text for gamestate " .. gamestateName)
	return lookup[gamestateName].text
end

return assetData
