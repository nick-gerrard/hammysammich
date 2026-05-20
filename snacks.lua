local C = require("config")
local Utils = require("utils")
local Snacks = {}

local snackImage = nil
local playerScore = 0
local vacScore = 0
local snacks = {}

function Snacks.generate(total)
	local x_values = {}
	for i = C.PLAY_MIN_X, C.PLAY_MAX_X - C.SNACK_SIZE, C.SNACK_SIZE do
		table.insert(x_values, i)
	end
	local y_values = {}
	for i = C.PLAY_MIN_Y, C.PLAY_MAX_Y - C.SNACK_SIZE, C.SNACK_SIZE do
		table.insert(y_values, i)
	end
	for i = 1, total do
		if #x_values == 0 or #y_values == 0 then
			break
		end
		local x_index = math.random(#x_values)
		local y_index = math.random(#y_values)
		table.insert(snacks, {
			x = x_values[x_index],
			y = y_values[y_index],
			width = C.SNACK_SIZE,
			height = C.SNACK_SIZE,
			eaten = false,
		})
		table.remove(x_values, x_index)
		table.remove(y_values, y_index)
	end
end

function Snacks.load()
	Snacks.generate(math.random(C.SNACK_MIN, C.SNACK_MAX))
	snackImage = love.graphics.newImage("assets/sammy.png")
end

function Snacks.update(playerRect, enemyRect)
	if #snacks <= playerScore + vacScore then
		Snacks.generate(math.random(C.SNACK_MIN, C.SNACK_MAX))
	end
	for i, snack in ipairs(snacks) do
		if not snack.eaten then
			if Utils.checkCollision(playerRect, snack) then
				snack.eaten = true
				playerScore = playerScore + 1
			elseif Utils.checkCollision(enemyRect, snack) then
				snack.eaten = true
				vacScore = vacScore + 1
			end
		end
	end
end

function Snacks.draw()
	for i, snack in ipairs(snacks) do
		if not snack.eaten then
			love.graphics.draw(snackImage, snack.x, snack.y)
		end
	end
end

function Snacks.getPlayerScore()
	return playerScore
end

function Snacks.getVacScore()
	return vacScore
end

function Snacks.reset()
	snacks = {}
	Snacks.generate(math.random(C.SNACK_MIN, C.SNACK_MAX))
	playerScore = 0
	vacScore = 0
end

return Snacks
