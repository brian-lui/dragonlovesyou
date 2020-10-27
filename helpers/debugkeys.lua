local stateInfo = require "stateinfo"

local debugKeys = {}

function debugKeys.keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == "1" then
		local aspectRatio = 1920/1080 -- desktop
		local width = love.window.getMode()
		local newheight = width / aspectRatio
		love.window.setMode (width, newheight, {resizable = true})
	elseif key == "2" then
		local aspectRatio = 2732/2048 -- iPad
		local width = love.window.getMode()
		local newheight = width / aspectRatio
		love.window.setMode (width, newheight, {resizable = true})
	elseif key == "3" then
		local aspectRatio = 2436/1125 -- mobile
		local width = love.window.getMode()
		local newheight = width / aspectRatio
		love.window.setMode (width, newheight, {resizable = true})
	elseif key == "4" then
		if game.currentGamestate.name == "ArrangeSchedule" then
			game.currentGamestate:discardHand()
			game.currentGamestate:createHand(1)
		end
	elseif key == "5" then
		if game.currentGamestate.name == "ArrangeSchedule" then
			game.currentGamestate:discardHand()
			game.currentGamestate:createHand(2)
		end
	elseif key == "6" then
		if game.currentGamestate.name == "ArrangeSchedule" then
			game.currentGamestate:discardHand()
			game.currentGamestate:createHand(3)
		end
	elseif key == "7" then
		if game.currentGamestate.name == "ArrangeSchedule" then
			game.currentGamestate:discardHand()
			game.currentGamestate:createHand(4)
		end
	elseif key == "8" then
		if game.currentGamestate.name == "ArrangeSchedule" then
			game.currentGamestate:discardHand()
			game.currentGamestate:createHand(5)
		end
	elseif key == "a" then
		if game.currentGamestate.name == "ArrangeSchedule" then
			stateInfo.set(math.random(100), "energy")
			stateInfo.set(math.random(100), "happy")
			stateInfo.set(math.random(100), "love")
			stateInfo.set(math.random(50), "money")
			stateInfo.set(math.random(10), "action")
			print("energy, happy, love now", stateInfo.get("energy"), stateInfo.get("happy"), stateInfo.get("love"))
			game.currentGamestate:updateStats()
		end
	end
end

return debugKeys
