local C = require("config")
local GameState = {}

local state = C.STATE.MENU

function GameState.get()
	return state
end

function GameState.set(newState)
	state = newState
end

function GameState.isPlaying()
	return state == C.STATE.PLAYING
end

function GameState.draw(playerScore)
	if state == C.STATE.WIN then
		love.graphics.setColor(0, 0, 0, 0.6)
		love.graphics.rectangle("fill", 0, 0, C.VIRTUAL_W, C.VIRTUAL_H)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("HAMMY IS FED AND HAPPY!", 280, 270)
		love.graphics.print("Score: " .. playerScore .. " sandwiches eaten.", 310, 300)
		love.graphics.print("Press R to play again", 340, 330)
	elseif state == C.STATE.LOSE then
		love.graphics.setColor(0, 0, 0, 0.6)
		love.graphics.rectangle("fill", 0, 0, C.VIRTUAL_W, C.VIRTUAL_H)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("HAMMY HAS BEEN VACUUMED :(", 280, 270)
		love.graphics.print("Score: " .. playerScore .. " sandwiches eaten.", 310, 300)
		love.graphics.print("Press R to play again", 340, 330)
	end
end

return GameState
