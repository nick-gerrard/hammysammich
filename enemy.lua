local C = require("config")
local Enemy = {}

local vacuum = {
	x = 400,
	y = 300,
	vx = 1,
	vy = 0.5,
	width = C.VACUUM_WIDTH,
	height = C.VACUUM_HEIGHT,
	speed = C.VACUUM_SPEED_SWEEP,
	distance = 800,
	state = C.VACUUM_STATE.SWEEPING,
	timer = 0,
	angle = 0,
}

function Enemy.load()
	vacuum.image = love.graphics.newImage("assets/vacuum.png")
	vacuum.sx = vacuum.width / vacuum.image:getWidth()
	vacuum.sy = vacuum.height / vacuum.image:getHeight()
end

function Enemy.draw()
	local ox = vacuum.image:getWidth() / 2
	local oy = vacuum.image:getHeight() / 2
	love.graphics.draw(
		vacuum.image,
		vacuum.x + vacuum.width / 2,
		vacuum.y + vacuum.height / 2,
		vacuum.angle or 0,
		vacuum.sx,
		vacuum.sy,
		ox,
		oy
	)
end

function Enemy.getRect()
	return vacuum
end

function Enemy.checkDistance(player)
	vacuum.distance = math.sqrt((player.x - vacuum.x) ^ 2 + (player.y - vacuum.y) ^ 2)
end

function Enemy.swapState()
	if vacuum.distance < C.VACUUM_DETECTION_RADIUS then
		vacuum.state = C.VACUUM_STATE.CHASING
		vacuum.speed = C.VACUUM_SPEED_CHASE
	else
		vacuum.state = C.VACUUM_STATE.SWEEPING
		vacuum.speed = C.VACUUM_SPEED_SWEEP
	end
end

function Enemy.update(dt, playerRect)
	Enemy.checkDistance(playerRect)
	Enemy.swapState()
	vacuum.timer = vacuum.timer + dt
	if vacuum.state == C.VACUUM_STATE.CHASING then
		local dx = playerRect.x - vacuum.x
		local dy = playerRect.y - vacuum.y
		local len = math.sqrt(dx * dx + dy * dy)
		vacuum.vx = dx / len
		vacuum.vy = dy / len
		vacuum.x = vacuum.x + vacuum.vx * vacuum.speed * dt
		vacuum.y = vacuum.y + vacuum.vy * vacuum.speed * dt
	else
		vacuum.x = vacuum.x + vacuum.vx * vacuum.speed * dt
		vacuum.y = vacuum.y + vacuum.vy * vacuum.speed * dt
		if vacuum.x < C.PLAY_MIN_X or vacuum.x + vacuum.width > C.PLAY_MAX_X then
			vacuum.vx = -vacuum.vx
		end
		if vacuum.y < C.PLAY_MIN_Y or vacuum.y + vacuum.height > C.PLAY_MAX_Y then
			vacuum.vy = -vacuum.vy
		end
		if vacuum.timer >= 1.0 then
			vacuum.vx = -vacuum.vx
			vacuum.timer = 0
		end
	end
	vacuum.angle = math.atan2(vacuum.vy, vacuum.vx)
end

function Enemy.reset()
	vacuum.x = 400
	vacuum.y = 300
	vacuum.vx = 1
	vacuum.vy = 0.5
	vacuum.timer = 0
	vacuum.state = C.VACUUM_STATE.SWEEPING
	vacuum.distance = 800
end

return Enemy
