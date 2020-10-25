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
	end
end

return debugKeys
