local images = require "images"
local stage = require "stage"

local imageData = {
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
		name = "pb_bar_attack",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 0),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_defense",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 1),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_flight",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.27 + 0.056 * 2),
		imageIndex = 1,
		category = "progressbook",
	},

	{
		name = "pb_bar_fire",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 0),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_water",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 1),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_earth",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 2),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_ice",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 3),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_light",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 4),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_dark",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.25,
		endY = stage.height * (0.54 + 0.056 * 5),
		imageIndex = 1,
		category = "progressbook",
	},

	{
		name = "pb_bar_world",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 0),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_science",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 1),
		imageIndex = 1,
		category = "progressbook",
	},
	{
		name = "pb_bar_math",
		image = images.gui_progressbook_bar,
		endX = stage.width * 0.6,
		endY = stage.height * (0.27 + 0.056 * 2),
		imageIndex = 1,
		category = "progressbook",
	},
}

local buttonData = {
	{
		name = "dragongoal",
		image = images.dreams_card2,
		imagePushed = images.dreams_card2,
		endX = stage.width * 0.38,
		endY = stage.height * 0.07,
		endScaling = 0.2,
		imageIndex = -1,
		action = function()
			print("test")
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
		action = function()
			print("test")
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
			if not ArrangeSchedule.shownProgressBook then
				ArrangeSchedule:_showProgressBook()
			end
		end,
	},
	{
		name = "pb_infoscreen",
		image = images.gui_progressbook_infoscreen,
		imagePushed = images.gui_progressbook_infoscreen,
		endX = stage.width * 0.5,
		endY = stage.height * 0.5,
		imageIndex = 1,
		action = function(ArrangeSchedule)
			if ArrangeSchedule.shownProgressBook then
				ArrangeSchedule:_hideProgressBook()
			end
		end,
		category = "progressbook",
	},
}

local textData = {
	{
		name = "pb_dragonability",
		font = "BIG",
		text = "DRAGON ABILITY",
		x = stage.width * 0.05,
		y = stage.height * 0.18,
		imageIndex = 2,
		category = "progressbook",
	},
	{
		name = "pb_magic",
		font = "BIG",
		text = "MAGIC",
		x = stage.width * 0.05,
		y = stage.height * 0.45,
		imageIndex = 2,
		category = "progressbook",
	},
	{
		name = "pb_knowledge",
		font = "BIG",
		text = "KNOWLEDGE",
		x = stage.width * 0.4,
		y = stage.height * 0.18,
		imageIndex = 2,
		category = "progressbook",
	},

	{
		name = "pb_dragonability_substats",
		font = "MEDIUM",
		text = "ATTACK\nDEFENSE\nFLIGHT",
		x = stage.width * 0.05,
		y = stage.height * 0.25,
		imageIndex = 2,
		category = "progressbook",
	},
	{
		name = "pb_magic_substats",
		font = "MEDIUM",
		text = "FIRE\nWATER\nEARTH\nICE\nLIGHT\nDARK",
		x = stage.width * 0.05,
		y = stage.height * 0.52,
		imageIndex = 2,
		category = "progressbook",
	},
	{
		name = "pb_knowledge_substats",
		font = "MEDIUM",
		text = "WORLD\nSCIENCE\nMATH",
		x = stage.width * 0.4,
		y = stage.height * 0.25,
		imageIndex = 2,
		category = "progressbook",
	},
}

local assetData_arrangeschedule = {}

function assetData_arrangeschedule.getImageData(aspectRatioOrWhatever)
	return imageData
end

function assetData_arrangeschedule.getButtonData(aspectRatioOrWhatever)
	return buttonData
end

function assetData_arrangeschedule.getTextData(aspectRatioOrWhatever)
	return textData
end

return assetData_arrangeschedule
