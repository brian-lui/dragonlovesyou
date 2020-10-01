--[[
This module mainly defines the locations of the objects that will be shown
on-screen in the main gamestate.
--]]

local consts = require "/helpers/consts"

local stage = {}

stage.width = consts.drawspace.width
stage.height = consts.drawspace.height

return stage
