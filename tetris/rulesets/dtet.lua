local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ruleset'

local DTET = Ruleset:extend()

DTET.name = "D.R.S."
DTET.hash = "DTET"

DTET.softdrop_lock = false
DTET.harddrop_lock = true
DTET.are_cancel = true

DTET.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

DTET.big_spawn_positions = {
	I = { x=3, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=3, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

DTET.block_offsets = {
	I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=-2}, {x=-1, y=0}, {x=-1, y=1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=0, y=1} },
	},
	J={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=-1} },
		{ {x=0, y=-1}, {x=1, y=-2}, {x=0, y=-2}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=-1, y=0} },
	},
	L={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=1, y=-1} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-2}, {x=0, y=-2}, {x=0, y=0} },
	},
	O={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
	},
	S={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=-1, y=-2}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
		{ {x=-1, y=0}, {x=0, y=0}, {x=0, y=-1}, {x=1, y=-1} },
		{ {x=1, y=0}, {x=1, y=-1}, {x=0, y=-1}, {x=0, y=-2} },
	},
	T={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=-1, y=-1}, {x=0, y=-2} },
	},
	Z={
		{ {x=1, y=0}, {x=0, y=0}, {x=0, y=-1}, {x=-1, y=-1} },
		{ {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=-2} },
		{ {x=1, y=0}, {x=0, y=0}, {x=0, y=-1}, {x=-1, y=-1} },
		{ {x=1, y=-2}, {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
	}
}

DTET.wallkicks_cw = {{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}}
DTET.wallkicks_ccw = {{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}}

function DTET:attemptWallkicks(piece, new_piece, rot_dir, grid)
	
	local kicks
    if piece.shape == "O" then
		return
	elseif rot_dir == 1 then
		kicks = DTET.wallkicks_cw
	else
		kicks = DTET.wallkicks_ccw
	end

	assert(piece.rotation ~= new_piece.rotation)

	for idx, offset in pairs(kicks) do
		kicked_piece = new_piece:withOffset(offset)
		if grid:canPlacePiece(kicked_piece) then
			self:onPieceRotate(piece, grid)
			piece:setRelativeRotation(rot_dir)
			piece:setOffset(offset)
			return
		end
	end

end

function DTET:onPieceDrop(piece, grid)
	piece.lock_delay = 0 -- step reset
end

function DTET:getDefaultOrientation() return 3 end

return DTET