local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ruleset'

local TheNext = Ruleset:extend()

TheNext.name = "The Next Tetris"
TheNext.hash = "TheNext"

TheNext.softdrop_lock = false
TheNext.harddrop_lock = false

TheNext.colourscheme = {
    I = "C",
    J = "B",
    L = "M",
    O = "A",
    S = "G",
    Z = "R",
    T = "Y"
}

TheNext.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

TheNext.big_spawn_positions = {
	I = { x=3, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=3, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

TheNext.block_offsets = {
    T={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=1, y=-1} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=0, y=-2}, {x=-1, y=-1} },
    },
    I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=-2}, {x=-1, y=0}, {x=-1, y=1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=-2}, {x=-1, y=0}, {x=-1, y=1} },
    },
    O={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
    },
    S={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=0}, {x=1, y=1} },
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=0}, {x=1, y=1} },
    },
    Z={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=-1, y=1}, {x=-1, y=0}, {x=0, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=-1, y=1}, {x=-1, y=0}, {x=0, y=-1}, {x=0, y=0} },
    },
    J={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=-1} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=1, y=-1}, {x=0, y=1} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=1, y=0}, {x=1, y=-1}, {x=1, y=1}, {x=0, y=1} },
	},
	L={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=1, y=-1} },
		{ {x=-1, y=-1}, {x=-1, y=0}, {x=0, y=1}, {x=-1, y=1} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=0} },
		{ {x=0, y=0}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=1} },
	},
}

TheNext.wallkicks_ccw = {{x=-1, y=0}, {x=0, y=1}, {x=1, y=0}, {x=0, y=-1}}
TheNext.wallkicks_cw = {{x=1, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=0, y=-1}}

function TheNext:attemptWallkicks(piece, new_piece, rot_dir, grid)

	local kicks
    if piece.shape == "O" then
		return
	elseif new_piece.rotation == piece.rotation + 1 or
    (piece.rotation == 3 and new_piece.rotation == 0) then
		kicks = TheNext.wallkicks_cw
	else
		kicks = TheNext.wallkicks_ccw
	end

	assert(piece.rotation ~= new_piece.rotation)

	for idx, offset in pairs(kicks) do
		kicked_piece = new_piece:withOffset(offset)
		if grid:canPlacePiece(kicked_piece) then
			piece:setRelativeRotation(rot_dir)
			piece:setOffset(offset)
			self:onPieceRotate(piece, grid)
			return
		end
	end

end

function TheNext:onPieceDrop(piece, grid)
	piece.lock_delay = 0 -- step reset
end

function TheNext:get180RotationValue() 
	if config.gamesettings.world_reverse == 1 then
		return 1
	else
		return 3
	end
end

function TheNext:getDefaultOrientation() return 3 end

return TheNext