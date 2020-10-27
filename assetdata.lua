local images = require "images"
local stage = require "stage"

-------------------------------------------------------------------------------
------------------------------------ TITLE ------------------------------------
-------------------------------------------------------------------------------

local titleImages = {
	ongoingtitle = {
		name = "ongoingtitle",
		image = images.title_ongoingtitle,
		duration = 30,
		startX = stage.width * -0.4,
		endX = stage.width * 0.16,
		endY = stage.height * 0.2,
		easing = "inCubic",
		imageIndex = 0,
	},
	ongoingback = {
		name = "ongoingback",
		image = images.title_ongoingback,
		duration = 30,
		endX = stage.width * 0.134,
		endY = stage.height * 0.45,
		startTransparency = 0,
		imageIndex = -1,
	},

	-- TEMP: this should be generated based on # games
	ongoinggameback = {
		name = "ongoinggameback",
		image = images.title_ongoinggameback,
		duration = 30,
		endX = stage.width * 0.134,
		endY = stage.height * 0.3,
		startTransparency = 0,
		imageIndex = 0,
		easing = "inCubic",
	},
}

local titleButtons = {
	newgame = {
		name = "newgame",
		image = images.title_newgame,
		imagePushed = images.title_newgamepressed,
		duration = 45,
		startX = stage.width * -0.2,
		endX = stage.width * 0.86,
		endY = stage.height * 0.45,
		easing = "inQuart",
		action = function()
			game:switchState("gs_arrangeschedule")
		end,
	},
	achievements = {
		name = "achievements",
		image = images.title_achievements,
		imagePushed = images.title_achievementspressed,
		duration = 45,
		startX = stage.width * -0.2,
		endX = stage.width * 0.86,
		endY = stage.height * 0.55,
		easing = "inQuart",
		action = function()
		end,
	},
	extras = {
		name = "extras",
		image = images.title_extras,
		imagePushed = images.title_extraspressed,
		duration = 45,
		startX = stage.width * -0.2,
		endX = stage.width * 0.86,
		endY = stage.height * 0.65,
		easing = "inQuart",
		action = function()
		end,
	},
	settings = {
		name = "settings",
		image = images.title_settings,
		imagePushed = images.title_settingspressed,
		duration = 45,
		startX = stage.width * -0.2,
		endX = stage.width * 0.86,
		endY = stage.height * 0.75,
		easing = "inQuart",
		action = function()
		end,
	},
	quit = {
		name = "quit",
		image = images.title_quit,
		imagePushed = images.title_quitpressed,
		duration = 45,
		startX = stage.width * -0.2,
		endX = stage.width * 0.86,
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
	activitiesframe ={
		name = "activitiesframe",
		image = images.gui_activitiesframe,
		endX = stage.width * 0.15,
		endY = stage.height * 0.29,
		imageIndex = -4,
	},
	activitiestxt = {
		name = "activitiestxt",
		image = images.gui_activitiestxt,
		endX = stage.width * 0.15,
		endY = stage.height * 0.05,
		imageIndex = -2,
	},
	actionbox = {
		name = "actionbox",
		image = images.gui_actionbox,
		endX = stage.width * 0.15,
		endY = stage.height * 0.12,
		imageIndex = -1,
	},
	scheduleframe = {
		name = "scheduleframe",
		image = images.gui_scheduleframe,
		endX = stage.width * 0.87,
		endY = stage.height * 0.45,
		imageIndex = -4,
	},
	scheduletxt = {
		name = "scheduletxt",
		image = images.gui_scheduletxt,
		endX = stage.width * 0.87,
		endY = stage.height * 0.15,
		imageIndex = -2,
	},
	coparent = {
		name = "coparent",
		image = images.gui_coparent,
		endX = stage.width * 0.68,
		endY = stage.height * 0.05,
		imageIndex = -1,
	},
	finalize = {
		name = "finalize",
		image = images.gui_finalizetxt,
		endX = stage.width * 0.88,
		endY = stage.height * 0.05,
		imageIndex = -1,
	},
	moneyplusblock = {
		name = "moneyplusblock",
		image = images.gui_stats_moneyplusblock,
		endX = stage.width * 0.07,
		endY = stage.height * 0.74,
		imageIndex = -3,
	},
	actionplusblock = {
		name = "actionplusblock",
		image = images.gui_stats_actionplusblock,
		endX = stage.width * 0.07,
		endY = stage.height * 0.79,
		imageIndex = -3,
	},
	energyback = {
		name = "energyback",
		image = images.gui_stats_energyback,
		endX = stage.width * 0.08,
		endY = stage.height * 0.915,
		imageIndex = -4,
	},
	energyicon = {
		name = "energyicon",
		image = images.gui_stats_energyicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.87,
		imageIndex = -1,
	},
	happyicon = {
		name = "happyicon",
		image = images.gui_stats_happyicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.92,
		imageIndex = -1,
	},
	loveicon = {
		name = "loveicon",
		image = images.gui_stats_loveicon,
		endX = stage.width * 0.03,
		endY = stage.height * 0.97,
		imageIndex = -1,
	},
	energyblockback = {
		name = "energyblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.87,
		imageIndex = -3,
	},
	energyblockbar = {
		name = "energyblockbar",
		image = images.gui_stats_blue,
		endX = stage.width * 0.086,
		endY = stage.height * 0.87,
		imageIndex = -2,
	},
	energyblockframe = {
		name = "energyblockframe",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.11,
		endY = stage.height * 0.87,
		imageIndex = -1,
	},
	happyblockback = {
		name = "happyblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.92,
		imageIndex = -3,
	},
	happyblockbar = {
		name = "happyblockbar",
		image = images.gui_stats_yellow,
		endX = stage.width * 0.086,
		endY = stage.height * 0.92,
		imageIndex = -2,
	},
	happyblockframe = {
		name = "happyblockframe",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.11,
		endY = stage.height * 0.92,
		imageIndex = -1,
	},
	loveblockback = {
		name = "loveblockback",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.11,
		endY = stage.height * 0.97,
		imageIndex = -3,
	},
	loveblockbar = {
		name = "loveblockbar",
		image = images.gui_stats_pink,
		endX = stage.width * 0.086,
		endY = stage.height * 0.97,
		imageIndex = -2,
	},
	loveblockframe = {
		name = "loveblockframe",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.11,
		endY = stage.height * 0.97,
		imageIndex = -1,
	},
	dragonmoonicon = {
		name = "dragonmoonicon",
		image = images.gui_dragonmoonicon,
		endX = stage.width * 0.89,
		endY = stage.height * 0.93,
		imageIndex = -1,
	},
	questionicon = {
		name = "questionicon",
		image = images.gui_questionicon,
		endX = stage.width * 0.96,
		endY = stage.height * 0.89,
		imageIndex = -1,
	},
	settingsicon = {
		name = "settingsicon",
		image = images.gui_settingsicon,
		endX = stage.width * 0.96,
		endY = stage.height * 0.96,
		imageIndex = -1,
	},

	pb_tag = {
		name = "pb_tag",
		image = images.gui_progress_tag,
		endX = stage.width * 0.2,
		endY = stage.height * 0.12,
		imageIndex = 1,
		category = "progress",
	},
	pb_blockback_attack = {
		name = "pb_blockback_attack",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 0),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_blue},
	},
	pb_blockframe_attack = {
		name = "pb_blockframe_attack",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 0),
		imageIndex = 3,
		category = "progress",
	},
	pb_blockback_defense = {
		name = "pb_blockback_defense",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 1),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_blue},
	},
	pb_blockframe_defense = {
		name = "pb_blockframe_defense",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 1),
		imageIndex = 3,
		category = "progress",
	},
	pb_blockback_flight = {
		name = "pb_blockback_flight",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 2),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_blue},
	},
	pb_blockframe_flight = {
		name = "pb_blockframe_flight",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 2),
		imageIndex = 3,
		category = "progress",
	},
	pb_blockback_fire = {
		name = "pb_blockback_fire",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 0),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_pink},
	},
	pb_blockframe_fire = {
		name = "pb_blockframe_fire",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 0),
		imageIndex = 3,
		category = "progress",
	},
	pb_blockback_water = {
		name = "pb_blockback_water",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 1),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_pink},
	},
	pb_blockframe_water = {
		name = "pb_blockframe_water",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 1),
		imageIndex = 3,
		category = "progress",
	},
	pb_blockback_earth = {
		name = "pb_blockback_earth",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 2),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_pink},
	},
	pb_blockframe_earth = {
		name = "pb_blockframe_earth",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 2),
		imageIndex = 3,
		category = "progress",
	},
	pb_blockback_ice = {
		name = "pb_blockback_ice",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 3),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_pink},
	},
	pb_blockframe_ice = {
		name = "pb_blockframe_ice",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 3),
		imageIndex = 3,
		category = "progress",
	},
	pb_blockback_light = {
		name = "pb_blockback_light",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 4),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_pink},
	},
	pb_blockframe_light = {
		name = "pb_blockframe_light",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 4),
		imageIndex = 3,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_pink},
	},
	pb_blockback_dark = {
		name = "pb_blockback_dark",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 5),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_pink},
	},
	pb_blockframe_dark = {
		name = "pb_blockframe_dark",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 5),
		imageIndex = 3,
		category = "progress",
	},
	pb_blockback_world = {
		name = "pb_blockback_world",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 0),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_yellow},
	},
	pb_blockframe_world = {
		name = "pb_blockframe_world",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 0),
		imageIndex = 3,
		category = "progress",
	},
	pb_blockback_science = {
		name = "pb_blockback_science",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 1),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_yellow},
	},
	pb_blockframe_science = {
		name = "pb_blockframe_science",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 1),
		imageIndex = 3,
		category = "progress",
	},
	pb_blockback_math = {
		name = "pb_blockback_math",
		image = images.gui_stats_blockback,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 2),
		imageIndex = 1,
		category = "progress",
		extraInfo = {meterImage = images.gui_stats_yellow},
	},
	pb_blockframe_math = {
		name = "pb_blockframe_math",
		image = images.gui_stats_blockframe,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 2),
		imageIndex = 3,
		category = "progress",
	},

	card_screendark = {
		name = "card_screendark",
		image = images.gui_screendark,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		imageIndex = 0,
		category = "cardcloseup",
	},
	card_description_background = {
		name = "card_description_background",
		image = images.gui_cardcloseup_box,
		endX = stage.width * 0.7,
		endY = stage.height * 0.7,
		imageIndex = 1,
		category = "cardcloseup",
	},


	goal_closeupbox = {
		name = "goal_closeupbox",
		image = images.gui_cardcloseup_box,
		endX = stage.width * 0.7,
		endY = stage.height * 0.7,
		imageIndex = 1,
		category = "dragongoal",
	},

	dream_closeupbox = {
		name = "dream_closeupbox",
		image = images.gui_cardcloseup_box,
		endX = stage.width * 0.7,
		endY = stage.height * 0.7,
		imageIndex = 1,
		category = "dragondream",
	},
}

local arrangeScheduleButtons = {
	dragongoal = {
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
	dragondream = {
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
	progressbookicon = {
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

	pb_infoscreen = {
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

	dream_screendark = {
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

	goal_screendark = {
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

	pb_screendark = {
		name = "pb_screendark",
		image = images.gui_screendark,
		imagePushed = images.gui_screendark,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		imageIndex = 0,
		action = function(ArrangeSchedule)
			ArrangeSchedule:hideProgressBook()
		end,
		category = "progress",
	},
}

local arrangeScheduleDraggables = {
}

local arrangeScheduleText = {
	pb_dragonability = {
		name = "pb_dragonability",
		font = "BIG",
		text = "DRAGON ABILITY",
		x = stage.width * 0.05,
		y = stage.height * 0.18,
		imageIndex = 2,
		category = "progress",
	},
	pb_magic = {
		name = "pb_magic",
		font = "BIG",
		text = "MAGIC",
		x = stage.width * 0.05,
		y = stage.height * 0.45,
		imageIndex = 2,
		category = "progress",
	},
	pb_knowledge = {
		name = "pb_knowledge",
		font = "BIG",
		text = "KNOWLEDGE",
		x = stage.width * 0.4,
		y = stage.height * 0.18,
		imageIndex = 2,
		category = "progress",
	},

	pb_dragonability_substats = {
		name = "pb_dragonability_substats",
		font = "MEDIUM",
		text = "ATTACK\nDEFENSE\nFLIGHT",
		x = stage.width * 0.05,
		y = stage.height * 0.25,
		imageIndex = 2,
		category = "progress",
	},
	pb_magic_substats = {
		name = "pb_magic_substats",
		font = "MEDIUM",
		text = "FIRE\nWATER\nEARTH\nICE\nLIGHT\nDARK",
		x = stage.width * 0.05,
		y = stage.height * 0.52,
		imageIndex = 2,
		category = "progress",
	},
	pb_knowledge_substats = {
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

function assetData.getItem(gamestateName, category, itemName, aspectRatioOrWhatever)
	assert(lookup[gamestateName], "No gamestate named " .. gamestateName)
	assert(lookup[gamestateName][category], "No category named " .. category)
	assert(lookup[gamestateName][category][itemName], "No item named " .. itemName)
	return lookup[gamestateName][category][itemName]
end

return assetData
