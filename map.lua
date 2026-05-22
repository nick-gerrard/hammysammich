local C = require("config")
local Map = {}

function Map.generateSolids(level)
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
	local obstacles = Map.generateObstacles(C.OBSTACLE_SIZE, level)
	for i, obs in ipairs(obstacles) do
		table.insert(solids, obs)
	end
	return solids
end

function Map.generateObstacles(size, level)
	local obstacles = {}
	local x_values = {}
	for i = C.PLAY_MIN_X + size, C.PLAY_MAX_X - size * 2, size do
		table.insert(x_values, i)
	end
	local y_values = {}
	for i = C.PLAY_MIN_Y + size, C.PLAY_MAX_Y - size * 2, size do
		table.insert(y_values, i)
	end
	for i = 1, level do
		if #x_values == 0 or #y_values == 0 then
			break
		end
		local x_index = math.random(#x_values)
		local y_index = math.random(#y_values)
		local obstacle = {
			x = x_values[x_index],
			y = y_values[y_index],
			width = size,
			height = size,
			tag = C.OBJECT_TAGS.OBSTACLE,
		}

		table.insert(obstacles, obstacle)
		table.remove(x_values, x_index)
		table.remove(y_values, y_index)
	end
	return obstacles
end

function Map.draw(solids)
	for i, solid in ipairs(solids) do
		if solid.tag == C.OBJECT_TAGS.WALL then
			love.graphics.rectangle("line", solid.x, solid.y, solid.width, solid.height)
		else
			love.graphics.rectangle("fill", solid.x, solid.y, solid.width, solid.height)
		end
	end
end

return Map
