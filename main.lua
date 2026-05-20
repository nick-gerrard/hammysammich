local C = require("config")
local Player = require("player")
local Enemy = require("enemy")
local Snacks = require("snacks")
local GameState = require("gamestate")
local Utils = require("utils")
local Map = require("map")
local Menu = require("menu")

local canvas

function love.load()
	math.randomseed(os.time())
	love.window.setTitle("Hammy's House")
	love.window.setMode(C.VIRTUAL_W, C.VIRTUAL_H, { resizable = true })
	love.graphics.setDefaultFilter("nearest", "nearest")
	canvas = love.graphics.newCanvas(C.VIRTUAL_W, C.VIRTUAL_H)
	canvas:setFilter("nearest", "nearest")
	Player.load()
	Enemy.load()
	Snacks.load()
	Menu.load()
end

function love.update(dt)
	if not GameState.isPlaying() then
		return
	end

	Player.update(dt, Map.getWalls())
	Enemy.update(dt, Player.getRect())
	Snacks.update(Player.getRect(), Enemy.getRect())

	if Utils.checkCollision(Player.getRect(), Enemy.getRect()) then
		GameState.set(C.STATE.LOSE)
		Player.reset()
	end

	if Snacks.getPlayerScore() - Snacks.getVacScore() > 30 then
		GameState.set(C.STATE.WIN)
	end
end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear(0.1, 0.1, 0.15)
	if GameState.get() == C.STATE.MENU then
		Menu.draw()
	else
		Player.draw()
		Enemy.draw()
		Snacks.draw()
		Map.draw()
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("Score: " .. Snacks.getPlayerScore(), 10, 10)
		GameState.draw(Snacks.getPlayerScore())
	end
	love.graphics.setCanvas()
	love.graphics.setColor(1, 1, 1)
	local winW, winH = love.graphics.getDimensions()
	local scale = math.min(winW / C.VIRTUAL_W, winH / C.VIRTUAL_H)
	local offsetX = math.floor((winW - C.VIRTUAL_W * scale) / 2)
	local offsetY = math.floor((winH - C.VIRTUAL_H * scale) / 2)
	love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)
end

function love.keypressed(key)
	if key == "return" and GameState.get() == C.STATE.MENU then
		GameState.set(C.STATE.PLAYING)
	end
	if key == "r" and not GameState.isPlaying() then
		Player.reset()
		Enemy.reset()
		Snacks.reset()
		GameState.set(C.STATE.PLAYING)
	end
	if key == "f" then
		love.window.setFullscreen(not love.window.getFullscreen())
	end
	if key == "p" then
		if not GameState.isPlaying() then
			GameState.set(C.STATE.PLAYING)
		else
			GameState.set(C.STATE.PAUSED)
		end
	end
end
