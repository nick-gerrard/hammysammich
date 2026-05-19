local GameState = {}

local state = "menu"

function GameState.get()
	return state
end

function GameState.set(newState)
	state = newState
end

function GameState.isPlaying()
	return state == "playing"
end

function GameState.draw(playerScore)
	if state == "win" then
		love.graphics.setColor(0, 0, 0, 0.6)
		love.graphics.rectangle("fill", 0, 0, 800, 600)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("HAMMY IS FED AND HAPPY!", 280, 270)
		love.graphics.print("Score: " .. playerScore .. " sandwiches eaten.", 310, 300)
		love.graphics.print("Press R to play again", 340, 330)
	elseif state == "lose" then
		love.graphics.setColor(0, 0, 0, 0.6)
		love.graphics.rectangle("fill", 0, 0, 800, 600)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("HAMMY HAS BEEN VACUUMED :(", 280, 270)
		love.graphics.print("Score: " .. playerScore .. " sandwiches eaten.", 310, 300)
		love.graphics.print("Press R to play again", 340, 330)
	elseif state == "menu" then
		love.graphics.setColor(0, 0, 0, 0.85)
		love.graphics.rectangle("fill", 0, 0, 800, 600)
		love.graphics.setColor(1, 0.8, 0.2)
		love.graphics.print("HAMILTON'S HOUSE", 280, 220)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("Help Hammy eat all the sandwiches!", 250, 265)
		love.graphics.print("Avoid the vacuum at all costs.", 265, 290)
		love.graphics.setColor(0.7, 0.7, 0.7)
		love.graphics.print("WASD to move", 335, 340)
		love.graphics.print("F for fullscreen", 330, 360)
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("Press ENTER to start", 315, 420)
	end
end

return GameState
