local C = require("config")
local Map = {}

local solids = {
	{ x = 0, y = 0, width = C.VIRTUAL_W, height = C.WALL_THICKNESS, tag = C.OBJECT_TAGS.WALL },
	{
		x = 0,
		y = C.VIRTUAL_H - C.WALL_THICKNESS,
		width = C.VIRTUAL_W,
		height = C.WALL_THICKNESS,
		tag = C.OBJECT_TAGS.WALL,
	},
	{ x = 0, y = 0, width = C.WALL_THICKNESS, height = C.VIRTUAL_H, tag = C.OBJECT_TAGS.WALL },
	{
		x = C.VIRTUAL_W - C.WALL_THICKNESS,
		y = 0,
		width = C.WALL_THICKNESS,
		height = C.VIRTUAL_H,
		tag = C.OBJECT_TAGS.WALL,
	},
}

local obstacleTimer = 0

function Map.getSolids()
	return solids
end

function Map.generateObstacle(w, h)
	local x = math.random(C.PLAY_MIN_X + w, C.PLAY_MAX_X - w)
	local y = math.random(C.PLAY_MIN_Y + h, C.PLAY_MAX_Y - h)
	table.insert(solids, { x = x, y = y, width = w, height = h, tag = C.OBJECT_TAGS.OBSTACLE })
end

function Map.update(dt)
	obstacleTimer = obstacleTimer + dt
	if obstacleTimer >= 15 then
		Map.generateObstacle(40, 40)
		obstacleTimer = 0
	end
end

function Map.reset()
	for i, solid in ipairs(solids) do
		if solid.tag == C.OBJECT_TAGS.OBSTACLE then
			table.remove(solids, i)
		end
	end
	obstacleTimer = 0
end

function Map.draw()
	for i, solid in ipairs(solids) do
		if solid.tag == C.OBJECT_TAGS.WALL then
			love.graphics.rectangle("line", solid.x, solid.y, solid.width, solid.height)
		else
			love.graphics.rectangle("fill", solid.x, solid.y, solid.width, solid.height)
		end
	end
end

return Map
