--[[
This module handles music and sound effects. The most commonly called modules
should be Sound:newBGM() and Sound:newSFX().
--]]

local love = _G.love
local common = require "class.commons"
local stringEndsWith = require "/helpers/utilities".stringEndsWith
local consts = require "/helpers/consts"

local soundfiles = {
	titleBGM = {
		filename = "music/wolfgang.ogg",
		loopFrom = 132.727,
		loopTo = 20.909,
	},
	mainBGM = {
		filename = "music/wolfgang.ogg",
		loopFrom = 132.727,
		loopTo = 20.909,
	},
}

local SFXFiles = {
	"dummy", "button",
}

for _, v in pairs(SFXFiles) do
	soundfiles[v] = {filename = "sound/" .. v .. ".ogg"}
end

-------------------------------------------------------------------------------
local SoundObject = {}
function SoundObject:init(manager, params)
	manager.activeSounds[params.soundName][params.startFrame] = self
	self.manager = manager

	-- defaults
	self.volume = 1
	self.shouldFadeIn = false
	self.shouldFadeOut = false

	for k, v in pairs(params) do self[k] = v end -- optional arguments

	self.source:play()
end

function SoundObject:remove()
	self.manager.activeSounds[self.soundName][self.startFrame] = nil
end

-- noRepeats is optional. If true, then it won't replay it 2 frames later,
-- instead it will just not create any sound effect
function SoundObject.generate(sound, soundName, isBGM, noRepeats)
	local s = soundfiles[soundName]

	if stringEndsWith(soundName, ".ogg") then
		s = {filename = soundName}
		-- register it too
		sound.activeSounds[soundName] = sound.activeSounds[soundName] or {}
		sound.lastPlayedFrame[soundName] = sound.lastPlayedFrame[soundName] or -1
	end

	if s then
		local startFrame = consts.frame
		local previousPlay = sound.lastPlayedFrame[soundName]
		if startFrame <= (previousPlay + 1) then -- delay by 2 frames
			if noRepeats then return end
			startFrame = previousPlay + 2
		end

		local sourceType = isBGM and "stream" or "static"
		local params = {
			source = love.audio.newSource(s.filename, sourceType),
			soundName = soundName,
			startFrame = startFrame,
			isBGM = isBGM,
			looping = isBGM,
			loopFrom = s.loopFrom or -1,
			loopTo = s.loopTo or -1,
		}

		local object = common.instance(SoundObject, sound, params)
		sound.lastPlayedFrame[soundName] = startFrame
		return object
	else
		print("invalid sound requested ", soundName)
	end
end

function SoundObject:play()
	self.source:play()
end

function SoundObject:pause()
	self.source:pause()
end

function SoundObject:stop()
	self.source:stop()
end

function SoundObject:isStopped()
	return not self.source:isPlaying()
end

function SoundObject:getVolume()
	return self.source:getVolume()
end

function SoundObject:setVolume(vol)
	self.source:setVolume(vol)
end

function SoundObject:getTime()
	return self.source:tell()
end

function SoundObject:setTime(time)
	self.source:seek(time)
end

function SoundObject:setPosition(x, y, z)
	self.source:setPosition(x, y, z)
end

-- sets volume to fade in from 0
-- frames is optional, defaults to 30
-- volumeMult is optional, stated as a multiple of the default volume
function SoundObject:fadeIn(framesTaken, volumeMult)
	framesTaken = framesTaken or 30
	volumeMult = volumeMult or 1
	local targetVolume = self.isBGM and self.manager.BGMVolume or self.manager.SFXVolume
	self.volume = targetVolume * volumeMult

	local volumePerFrame = targetVolume / framesTaken
	self:setVolume(0)
	self.shouldFadeIn = true
	self.fadeInSpeed = volumePerFrame
end

-- sets volume to fade out from current volume to 0
-- frames is optional
-- Not implemented yet
function SoundObject:fadeOut(frames)
end

-- will loop if set to true.
-- optional for time to loop from, and time to loop to
function SoundObject:setLooping(isLooping, loopFrom, loopTo)
	self.loopFrom = loopFrom or self.loopFrom
	self.loopTo = loopTo or self.loopTo
	self.looping = isLooping
end

function SoundObject:isPlaying()
	return self.source:isPlaying()
end
SoundObject = common.class("SoundObject", SoundObject)

-------------------------------------------------------------------------------
local Sound = {}
function Sound:init()
	self.currentBGM = nil
	self:reset()
end

function Sound:update()
	local frame = consts.frame
	for _, soundName in pairs(self.activeSounds) do
		for startFrame, instance in pairs(soundName) do
			if instance:isStopped() and frame > startFrame then
				instance:remove()
			end

			if instance.shouldFadeIn then
				local curVolume = instance:getVolume()
				if instance.volume > curVolume then
					instance:setVolume(math.min(curVolume + instance.fadeInSpeed, instance.volume))
				else
					instance.shouldFadeIn = false
					instance.fadeInSpeed = 0
				end
			elseif instance.shouldFadeOut then
				local curVolume = instance:getVolume()
				if curVolume > 0 then
					instance:setVolume(math.max(curVolume + instance.fadeOutSpeed, 0))
				else
					instance.shouldFadeOut = false
					instance.fadeOutSpeed = 0
				end
			end

			if instance.looping then
				if instance:getTime() >= instance.loopFrom then
					instance:setTime(instance.loopTo)
				end
			end
		end
	end
end

function Sound:newBGM(soundName, isLooping)
	self.currentBGM = self.object.generate(self, soundName, true)
	if isLooping then self.currentBGM:setLooping(true) end
	self.currentBGM:setVolume(0.4) -- placeholder
	return self.currentBGM
end

function Sound:stopBGM()
	if self.currentBGM then
		self.currentBGM:stop()
		self.currentBGM = nil
	end
end

function Sound:pauseBGM()
	self.currentBGM:pause()
end

function Sound:getCurrentBGM()
	if self.currentBGM then return self.currentBGM.soundName end
end

-- can also accept a link to full location of sound file
function Sound:newSFX(soundName, noRepeats)
	return self.object.generate(self, soundName, false, noRepeats)
end

function Sound:reset()
	if self.activeSounds then
		for _, soundName in pairs(self.activeSounds) do
			for _, instance in pairs(soundName) do
				instance:stop()
			end
		end
	end
	self.lastPlayedFrame = {}
	self.activeSounds = {}

	for name, _ in pairs(soundfiles) do
		self.activeSounds[name] = {}
		self.lastPlayedFrame[name] = -1
	end
	self.SFXVolume = 1 -- later we can point to user settings for these
	self.BGMVolume = 1 -- later we can point to user settings for these
end

Sound.object = SoundObject
return common.class("Sound", Sound)
