local Map = {}

local walls = {
	{ x = 0, y = 0, width = 800, height = 16 },
	{ x = 0, y = 584, width = 800, height = 16 },
	{ x = 0, y = 0, width = 16, height = 600 },
	{ x = 780, y = 0, width = 16, height = 600 },
}

function Map.getWalls()
	return walls
end

function Map.draw()
	for i, wall in ipairs(walls) do
		love.graphics.rectangle("fill", wall.x, wall.y, wall.width, wall.height)
	end
end

return Map
