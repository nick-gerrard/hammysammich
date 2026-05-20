local C = require("config")
local Map = {}

local walls = {
	{ x = 0, y = 0, width = C.VIRTUAL_W, height = C.WALL_THICKNESS },
	{ x = 0, y = 584, width = C.VIRTUAL_W, height = C.WALL_THICKNESS },
	{ x = 0, y = 0, width = C.WALL_THICKNESS, height = C.VIRTUAL_H },
	{ x = 780, y = 0, width = C.WALL_THICKNESS, height = C.VIRTUAL_H },
}

function Map.getWalls()
	return walls
end

function Map.draw()
	for i, wall in ipairs(walls) do
		love.graphics.rectangle("line", wall.x, wall.y, wall.width, wall.height)
	end
end

return Map
