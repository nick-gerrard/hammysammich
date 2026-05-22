local C = require("config")
local Utils = require("utils")
local Audio = require("audio")
local Enemy = {}

local vacuum = {
	x = 700,
	y = 500,
	vx = 1,
	vy = 0.5,
	width = C.VACUUM_WIDTH,
	height = C.VACUUM_HEIGHT,
	speed = C.VACUUM_SPEED_SWEEP,
	chaseSpeed = C.VACUUM_SPEED_CHASE,
	sweepSpeed = C.VACUUM_SPEED_SWEEP,
	detectionRadius = C.VACUUM_DETECTION_RADIUS,
	distance = 800,
	state = C.VACUUM_STATE.SWEEPING,
	timer = 0,
	angle = 0,
	active = false,
	spawnTimer = 0,
	spawnX = 0,
	spawnY = 0,
}

function Enemy.isActive()
	return vacuum.active
end

function Enemy.load()
	vacuum.image = love.graphics.newImage("assets/vacuum.png")
	vacuum.sx = vacuum.width / vacuum.image:getWidth() * C.VACUUM_DISPLAY_SCALE
	vacuum.sy = vacuum.height / vacuum.image:getHeight() * C.VACUUM_DISPLAY_SCALE
	Enemy.reset()
end

function Enemy.draw()
	if not vacuum.active then
		return
	end
	local centerX = vacuum.x + vacuum.width / 2
	local centerY = vacuum.y + vacuum.height / 2
	local ox = vacuum.image:getWidth() / 2
	local oy = vacuum.image:getHeight() / 2
	love.graphics.draw(vacuum.image, centerX, centerY, vacuum.angle or 0, vacuum.sx, vacuum.sy, ox, oy)
end

function Enemy.getRect()
	return vacuum
end

function Enemy.checkDistance(player)
	vacuum.distance = math.sqrt((player.x - vacuum.x) ^ 2 + (player.y - vacuum.y) ^ 2)
end

function Enemy.swapState()
	if vacuum.distance < vacuum.detectionRadius then
		vacuum.state = C.VACUUM_STATE.CHASING
		vacuum.speed = vacuum.chaseSpeed
		Audio.startVac()
	else
		vacuum.state = C.VACUUM_STATE.SWEEPING
		vacuum.speed = vacuum.sweepSpeed
		Audio.stopVac()
	end
end

function Enemy.spawnDelayed(x, y, delay)
	vacuum.active = false
	vacuum.spawnTimer = delay
	vacuum.spawnX = x
	vacuum.spawnY = y
	vacuum.detectionRadius = vacuum.detectionRadius + 25
	vacuum.sweepSpeed = vacuum.sweepSpeed + 10
end

function Enemy.update(dt, playerRect, solids)
	if not vacuum.active then
		vacuum.spawnTimer = vacuum.spawnTimer - dt
		if vacuum.spawnTimer <= 0 then
			vacuum.x = vacuum.spawnX
			vacuum.y = vacuum.spawnY
			vacuum.active = true
		end
		return
	end
	Enemy.checkDistance(playerRect)

	Enemy.swapState()
	vacuum.timer = vacuum.timer + dt

	if vacuum.state == C.VACUUM_STATE.CHASING then
		local dx = playerRect.x - vacuum.x
		local dy = playerRect.y - vacuum.y
		local len = math.sqrt(dx * dx + dy * dy)
		vacuum.vx = dx / len
		vacuum.vy = dy / len
	end

	if vacuum.state == C.VACUUM_STATE.SWEEPING then
		if vacuum.timer >= 1 then
			vacuum.vx = -vacuum.vx
			vacuum.x = vacuum.x + vacuum.vx * vacuum.speed * dt
			vacuum.timer = 0
		end
	end
	vacuum.x = vacuum.x + vacuum.vx * vacuum.speed * dt
	for i, solid in ipairs(solids) do
		if Utils.checkCollision(vacuum, solid) then
			vacuum.vx = -vacuum.vx
			vacuum.x = vacuum.x + vacuum.vx * vacuum.speed * dt
			break
		end
	end

	vacuum.y = vacuum.y + vacuum.vy * vacuum.speed * dt
	for i, solid in ipairs(solids) do
		if Utils.checkCollision(vacuum, solid) then
			vacuum.vy = -vacuum.vy
			vacuum.y = vacuum.y + vacuum.vy * vacuum.speed * dt
			break
		end
	end

	vacuum.angle = math.atan2(vacuum.vy, vacuum.vx)
end

function Enemy.reset()
	vacuum.vx = 1
	vacuum.vy = 0.5
	vacuum.timer = 0
	vacuum.state = C.VACUUM_STATE.SWEEPING
	vacuum.distance = 800
	vacuum.chaseSpeed = C.VACUUM_SPEED_CHASE
	vacuum.sweepSpeed = C.VACUUM_SPEED_SWEEP
	vacuum.detectionRadius = C.VACUUM_DETECTION_RADIUS
	local edges = {
		{ x = math.random(C.PLAY_MIN_X, C.PLAY_MAX_X - C.VACUUM_WIDTH), y = C.PLAY_MIN_Y },
		{ x = math.random(C.PLAY_MIN_X, C.PLAY_MAX_X - C.VACUUM_WIDTH), y = C.PLAY_MAX_Y - C.VACUUM_HEIGHT },
		{ x = C.PLAY_MIN_X, y = math.random(C.PLAY_MIN_Y, C.PLAY_MAX_Y - C.VACUUM_HEIGHT) },
		{ x = C.PLAY_MAX_X - C.VACUUM_WIDTH, y = math.random(C.PLAY_MIN_Y, C.PLAY_MAX_Y - C.VACUUM_HEIGHT) },
	}
	local pos = edges[math.random(4)]
	vacuum.spawnX = pos.x
	vacuum.spawnY = pos.y
	vacuum.spawnTimer = 1.0
	vacuum.active = false
end

return Enemy
