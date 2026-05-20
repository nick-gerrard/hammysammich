local Utils = require("utils")
local C = require("config")
local Player = {}

local hammy = {
	x = 100,
	y = 100,
	width = C.HAMMY_WIDTH,
	height = C.HAMMY_HEIGHT,
	speed = C.HAMMY_SPEED,
}

function Player.load()
	hammy.image = love.graphics.newImage("assets/hammy.png")
	hammy.sx = hammy.width / hammy.image:getWidth()
	hammy.sy = hammy.height / hammy.image:getHeight()
end

function Player.update(dt, walls)
	local dx = 0
	local dy = 0

	if love.keyboard.isDown("d") then
		dx = hammy.speed * dt
	end
	if love.keyboard.isDown("a") then
		dx = -hammy.speed * dt
	end
	if love.keyboard.isDown("w") then
		dy = -hammy.speed * dt
	end
	if love.keyboard.isDown("s") then
		dy = hammy.speed * dt
	end

	hammy.x = hammy.x + dx
	for i, wall in ipairs(walls) do
		if Utils.checkCollision(hammy, wall) then
			if dx > 0 then
				hammy.x = wall.x - hammy.width
			end
			if dx < 0 then
				hammy.x = wall.x + wall.width
			end
		end
	end
	hammy.y = hammy.y + dy

	for i, wall in ipairs(walls) do
		if Utils.checkCollision(hammy, wall) then
			if dy > 0 then
				hammy.y = wall.y - hammy.height
			end
			if dy < 0 then
				hammy.y = wall.y + wall.height
			end
		end
	end
end

function Player.getRect()
	return hammy
end

function Player.draw()
	love.graphics.draw(hammy.image, hammy.x, hammy.y, 0, hammy.sx, hammy.sy)
end

function Player.reset()
	hammy.x = 100
	hammy.y = 100
end

return Player
