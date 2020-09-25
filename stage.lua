--[[
This module mainly defines the locations of the objects that will be shown
on-screen in the main gamestate.
--]]

local inits = require "/helpers/inits"

local stage = {}

stage.width = inits.drawspace.width
stage.height = inits.drawspace.height

return stage
