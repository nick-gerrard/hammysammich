local C = require("config")
local Player = require("player")
local Enemy = require("enemy")
local Snacks = require("snacks")
local GameState = require("gamestate")
local Utils = require("utils")
local Room = require("room")
local Map = require("map")
local Menu = require("menu")
local Audio = require("audio")

local canvas
local currentRoom
local currentLevel = 1
local walls = { C.DOOR_POSITION.TOP, C.DOOR_POSITION.BOTTOM, C.DOOR_POSITION.LEFT, C.DOOR_POSITION.RIGHT }

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
	GameState.load()
	Map.load()
	Audio.load()
	Audio.startMusic()
	currentRoom = Room.generate(currentLevel)
end

function love.update(dt)
	if not GameState.isPlaying() then
		return
	end

	Player.update(dt, currentRoom.solids)
	Enemy.update(dt, Player.getRect(), currentRoom.solids)
	Snacks.update(currentRoom.snacks, Player.getRect(), Enemy.getRect())

	if Utils.checkCollision(Player.getRect(), Enemy.getRect()) then
		if Enemy.isActive() then
			GameState.set(C.STATE.LOSE)
			Audio.stopVac()
		end
	end

	if Snacks.allEaten(currentRoom.snacks) and #currentRoom.doors == 0 then
		table.insert(currentRoom.doors, Room.generateDoor(walls[math.random(#walls)]))
	end

	for i, door in ipairs(currentRoom.doors) do
		if Utils.checkCollision(Player.getRect(), door) then
			currentLevel = currentLevel + 1
			currentRoom = Room.generate(currentLevel)
			local spawnX, spawnY = Player.reset(door.wall)
			Enemy.spawnDelayed(spawnX, spawnY, 1.0)
		end
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
		Snacks.draw(currentRoom.snacks)
		Map.draw(currentRoom.solids)
		Map.draw(currentRoom.doors)
		love.graphics.setColor(1, 1, 1)
		GameState.draw()
	end
	if C.DEBUG then
		love.graphics.setColor(1, 0, 0, 0.5)
		local p = Player.getRect()
		love.graphics.rectangle("line", p.x, p.y, p.width, p.height)

		local e = Enemy.getRect()
		love.graphics.rectangle("line", e.x, e.y, e.width, e.height)

		for i, snack in ipairs(currentRoom.snacks) do
			love.graphics.rectangle("line", snack.x, snack.y, snack.width, snack.height)
		end

		love.graphics.setColor(1, 1, 1)
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
		Player.reset(C.DOOR_POSITION.BOTTOM)
		Enemy.reset()
		currentRoom = Room.generate(1)
		currentLevel = 1
		GameState.reset()
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
