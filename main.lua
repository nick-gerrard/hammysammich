local Player = require("player")
local Enemy = require("enemy")
local Snacks = require("snacks")
local GameState = require("gamestate")
local Utils = require("utils")
local Map = require("map")
local Menu = require("menu")

local VIRTUAL_W = 800
local VIRTUAL_H = 600
local canvas

function love.load()
	love.window.setTitle("Hammy's House")
	love.window.setMode(VIRTUAL_W, VIRTUAL_H, { resizable = true })
	love.graphics.setDefaultFilter("nearest", "nearest")
	canvas = love.graphics.newCanvas(VIRTUAL_W, VIRTUAL_H)
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
		GameState.set("lose")
		Player.reset()
	end

	if Snacks.allEaten() then
		GameState.set("win")
	end
end

function love.draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear(0.1, 0.1, 0.15)
	if GameState.get() == "menu" then
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
	local scale = math.min(winW / VIRTUAL_W, winH / VIRTUAL_H)
	local offsetX = math.floor((winW - VIRTUAL_W * scale) / 2)
	local offsetY = math.floor((winH - VIRTUAL_H * scale) / 2)
	love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)
end

function love.keypressed(key)
	if key == "return" and GameState.get() == "menu" then
		GameState.set("playing")
	end
	if key == "r" and not GameState.isPlaying() then
		Player.reset()
		Enemy.reset()
		Snacks.reset()
		GameState.set("playing")
	end
	if key == "f" then
		love.window.setFullscreen(not love.window.getFullscreen())
	end
	if key == "p" then
		if not GameState.isPlaying() then
			GameState.set("playing")
		else
			GameState.set("paused")
		end
	end
end
