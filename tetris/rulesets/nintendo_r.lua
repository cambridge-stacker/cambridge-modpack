local Ruleset = require 'tetris.rulesets.ruleset'

local Nintendo = Ruleset:extend()

Nintendo.name = "Nintendo-R"
Nintendo.hash = "NintendoR"
Nintendo.description = "Straight from the NES."

Nintendo.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=5, y=5 },
	L = { x=5, y=5 },
	O = { x=5, y=5 },
	S = { x=5, y=5 },
	T = { x=5, y=5 },
	Z = { x=5, y=5 },
}

Nintendo.big_spawn_positions = {
	I = { x=3, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=3, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

Nintendo.block_offsets = {
	I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=0, y=1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=0, y=1} },
	},
	J={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=-2} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0} , {x=1, y=-2} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=0, y=-2}, {x=-1, y=0} },
	},
	L={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=-2} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=-1, y=0} },
		{ {x=0, y=0}, {x=-1, y=-2}, {x=0, y=-2}, {x=0, y=-1} },
	},
	O={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
	},
	S={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=-1}, {x=1, y=0} },
	},
	T={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=0, y=-2}, {x=1, y=-1} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=0, y=-2}, {x=-1, y=-1} },
	},
	Z={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
	}
}

function Nintendo:onPieceDrop(piece)
	piece.lock_delay = 0
end

function Nintendo:get180RotationValue() 
	return 3
end

function Nintendo:getDefaultOrientation() return 3 end  -- downward facing pieces by default

return Nintendo
