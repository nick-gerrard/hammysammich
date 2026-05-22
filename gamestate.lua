local C = require("config")
local GameState = {}

local state = C.STATE.MENU
local playerScore, vacScore = 0, 0
local hudFont, scoreFont, titleFont, defaultFont

function GameState.load()
	hudFont = love.graphics.newFont(13)
	scoreFont = love.graphics.newFont(20)
	titleFont = love.graphics.newFont(36)
	defaultFont = love.graphics.newFont(12)
end

function GameState.get()
	return state
end

function GameState.set(newState)
	state = newState
end

function GameState.isPlaying()
	return state == C.STATE.PLAYING
end

function GameState.addScore(p, v)
	playerScore = playerScore + p
	vacScore = vacScore + v
end

function GameState.addVacScore()
	vacScore = vacScore + 1
end

function GameState.addPlayerScore()
	playerScore = playerScore + 1
end

function GameState.reset()
	state = C.STATE.PLAYING
	playerScore = 0
	vacScore = 0
end

local function centered(font, text, y)
	love.graphics.setFont(font)
	love.graphics.print(text, C.VIRTUAL_W / 2 - font:getWidth(text) / 2, y)
end

function GameState.draw()
	local score = playerScore - vacScore

	if state ~= C.STATE.MENU then
		love.graphics.setColor(0.12, 0.12, 0.18)
		love.graphics.rectangle("fill", 0, 0, C.WALL_THICKNESS * 4, C.WALL_THICKNESS)
		love.graphics.setFont(hudFont)
		love.graphics.setColor(1, 0.85, 0.2)
		love.graphics.print("SCORE " .. score, 3, 1)
	end

	if state == C.STATE.PAUSED then
		love.graphics.setColor(0, 0, 0, 0.6)
		love.graphics.rectangle("fill", 0, 0, C.VIRTUAL_W, C.VIRTUAL_H)
		local pw, ph = 300, 140
		local px, py = C.VIRTUAL_W / 2 - pw / 2, C.VIRTUAL_H / 2 - ph / 2
		love.graphics.setColor(0.12, 0.12, 0.22)
		love.graphics.rectangle("fill", px, py, pw, ph)
		love.graphics.setColor(0.3, 0.3, 0.55)
		love.graphics.rectangle("line", px, py, pw, ph)
		love.graphics.setColor(1, 1, 1)
		centered(titleFont, "PAUSED", py + 18)
		love.graphics.setColor(0.75, 0.75, 0.75)
		centered(defaultFont, "P  —  Resume", py + 88)
		centered(defaultFont, "R  —  Restart", py + 108)
	end

	if state == C.STATE.LOSE then
		love.graphics.setColor(0, 0, 0, 0.75)
		love.graphics.rectangle("fill", 0, 0, C.VIRTUAL_W, C.VIRTUAL_H)
		local pw, ph = 500, 180
		local px, py = C.VIRTUAL_W / 2 - pw / 2, C.VIRTUAL_H / 2 - ph / 2
		love.graphics.setColor(0.15, 0.08, 0.08)
		love.graphics.rectangle("fill", px, py, pw, ph)
		love.graphics.setColor(0.5, 0.15, 0.15)
		love.graphics.rectangle("line", px, py, pw, ph)
		love.graphics.setColor(1, 0.35, 0.35)
		centered(titleFont, "HAMMY GOT VACUUMED!", py + 18)
		love.graphics.setColor(1, 0.85, 0.2)
		centered(scoreFont, "Score: " .. score .. " sandwiches", py + 82)
		love.graphics.setColor(0.75, 0.75, 0.75)
		centered(defaultFont, "R  —  Play Again", py + 145)
	end

	love.graphics.setFont(defaultFont)
	love.graphics.setColor(1, 1, 1)
end

return GameState
