local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ruleset'

local Tengen = Ruleset:extend()

Tengen.name = "Tengen"
Tengen.hash = "Tengen"
Tengen.colourscheme = {
	I = "R",
	J = "O",
	L = "M",
	O = "B",
	S = "G",
	T = "Y",
	Z = "C"
}
Tengen.spawn_above_field = true

Tengen.spawn_positions = {
	I = { x=3, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=4, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

Tengen.big_spawn_positions = {
	I = { x=1, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=2, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

Tengen.block_offsets = {
	I={
		{ {x=0, y=0}, {x=1, y=0}, {x=2, y=0}, {x=3, y=0} },
		{ {x=1, y=0}, {x=1, y=1}, {x=1, y=2}, {x=1, y=3} },
		{ {x=0, y=0}, {x=1, y=0}, {x=2, y=0}, {x=3, y=0} },
		{ {x=1, y=0}, {x=1, y=1}, {x=1, y=2}, {x=1, y=3} },
	},
	J={
		{ {x=-1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
		{ {x=-1, y=-1}, {x=0, y=-1}, {x=-1, y=0}, {x=-1, y=1} },
		{ {x=-1, y=-1}, {x=0, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=-1, y=1}, {x=0, y=1} },
	},
	L={
		{ {x=1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=1} },
		{ {x=-1, y=-1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=0} },
		{ {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=0, y=1} },
	},
	O={
		{ {x=0, y=-1}, {x=1, y=-1}, {x=0, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=0, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=0, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=0, y=0}, {x=1, y=0} },
	},
	S={
		{ {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=0}, {x=0, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=0, y=1} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=0}, {x=0, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=0, y=1} },
	},
	T={
		{ {x=0, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=-1, y=1} },
		{ {x=-1, y=-1}, {x=0, y=-1}, {x=1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=0, y=1} },
	},
	Z={
		{ {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=-1, y=1} },
		{ {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=-1, y=1} },
	}
}


-- Component functions.

function Tengen:attemptWallkicks(piece, new_piece, rot_dir, grid)

	-- O doesn't kick
	if (piece.shape == "O") then return end

	if (grid:canPlacePiece(new_piece:withOffset({x=-1, y=0}))) then
		piece:setRelativeRotation(rot_dir):setOffset({x=-1, y=0})
	end

end

function Tengen:onPieceDrop(piece, grid)
	piece.lock_delay = 0 -- step reset
end

function Tengen:get180RotationValue() 
	return 3
end

function Tengen:getDefaultOrientation() return 3 end  -- downward facing pieces by default

return Tengen
