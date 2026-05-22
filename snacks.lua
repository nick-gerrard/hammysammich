local C = require("config")
local Utils = require("utils")
local GameState = require("gamestate")
local Audio = require("audio")
local Snacks = {}
local snackImage = nil

function Snacks.generate(level, solids)
	local snacks = {}
	local x_values = {}
	for i = C.PLAY_MIN_X, C.PLAY_MAX_X - C.SNACK_SIZE, C.SNACK_SIZE do
		table.insert(x_values, i)
	end
	local y_values = {}
	for i = C.PLAY_MIN_Y, C.PLAY_MAX_Y - C.SNACK_SIZE, C.SNACK_SIZE do
		table.insert(y_values, i)
	end
	for i = 1, level do
		if #x_values == 0 or #y_values == 0 then
			break
		end
		local x_index = math.random(#x_values)
		local y_index = math.random(#y_values)
		local snack = {
			x = x_values[x_index],
			y = y_values[y_index],
			width = C.SNACK_SIZE,
			height = C.SNACK_SIZE,
			eaten = false,
		}
		for i, obj in ipairs(solids) do
			if obj.tag == C.OBJECT_TAGS.OBSTACLE and Utils.checkCollision(snack, obj) then
				snack.eaten = true
				break
			end
		end

		table.insert(snacks, snack)
		table.remove(x_values, x_index)
		table.remove(y_values, y_index)
	end
	return snacks
end

function Snacks.allEaten(snacks)
	for i, snack in ipairs(snacks) do
		if snack.eaten == false then
			return false
		end
	end
	return true
end
function Snacks.load()
	snackImage = love.graphics.newImage("assets/sammy.png")
end

function Snacks.update(snacks, playerRect, enemyRect)
	for i, snack in ipairs(snacks) do
		if not snack.eaten then
			if Utils.checkCollision(playerRect, snack) then
				snack.eaten = true
				GameState.addPlayerScore()
				Audio.playMunch()
			elseif Utils.checkCollision(enemyRect, snack) then
				snack.eaten = true
				GameState.addVacScore()
			end
		end
	end
end

function Snacks.draw(snacks)
	for i, snack in ipairs(snacks) do
		if not snack.eaten then
			love.graphics.draw(snackImage, snack.x, snack.y)
		end
	end
end

return Snacks
