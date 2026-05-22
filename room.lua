local C = require("config")
local Map = require("map")
local Snacks = require("snacks")

local Room = {}

local positions = {
	top = {
		x = C.VIRTUAL_W / 2 - C.DOOR_SIZE / 2,
		y = 1,
		width = C.DOOR_SIZE,
		height = C.WALL_THICKNESS,
		wall = C.DOOR_POSITION.TOP,
		tag = C.OBJECT_TAGS.DOOR,
	},
	bottom = {
		x = C.VIRTUAL_W / 2 - C.DOOR_SIZE / 2,
		y = C.VIRTUAL_H - C.WALL_THICKNESS - 1,
		width = C.DOOR_SIZE,
		height = C.WALL_THICKNESS,
		wall = C.DOOR_POSITION.BOTTOM,
		tag = C.OBJECT_TAGS.DOOR,
	},
	left = {
		x = 1,
		y = C.VIRTUAL_H / 2 - C.DOOR_SIZE / 2,
		width = C.WALL_THICKNESS,
		height = C.DOOR_SIZE,
		wall = C.DOOR_POSITION.LEFT,
		tag = C.OBJECT_TAGS.DOOR,
	},
	right = {
		x = C.VIRTUAL_W - C.WALL_THICKNESS - 1,
		y = C.VIRTUAL_H / 2 - C.DOOR_SIZE / 2,
		width = C.WALL_THICKNESS,
		height = C.DOOR_SIZE,
		wall = C.DOOR_POSITION.RIGHT,
		tag = C.OBJECT_TAGS.DOOR,
	},
}
function Room.generateDoor(wall)
	return positions[wall]
end
function Room.generate(level)
	local solids = Map.generateSolids(level)
	local snacks = Snacks.generate(level, solids)
	local room = {
		level = level,
		solids = solids,
		snacks = snacks,
		doors = {},
	}
	return room
end

return Room
