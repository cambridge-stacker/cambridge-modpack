local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ruleset'

local SRS = Ruleset:extend()

SRS.name = "MoB-Deluxe"
SRS.hash = "Spiderman losing his grip"
SRS.description = "Spiderman losing his grip"

SRS.world = true
SRS.colourscheme = {
	I = "C",
	L = "O",
	J = "B",
	S = "G",
	Z = "R",
	O = "Y",
	T = "M",
}
SRS.softdrop_lock = false
SRS.harddrop_lock = true

SRS.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

SRS.big_spawn_positions = {
	I = { x=3, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=3, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

SRS.block_offsets = {
	I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
		{ {x=0, y=1}, {x=-1, y=1}, {x=-2, y=1}, {x=1, y=1} },
		{ {x=-1, y=0}, {x=-1, y=-1}, {x=-1, y=1}, {x=-1, y=2} },
	},
	J={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=-1} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1} , {x=1, y=-1} },
		{ {x=0, y=0}, {x=1, y=0}, {x=-1, y=0}, {x=1, y=1} },
		{ {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=-1, y=1} },
	},
	L={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=1, y=-1} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=1, y=1} },
		{ {x=0, y=0}, {x=1, y=0}, {x=-1, y=0}, {x=-1, y=1} },
		{ {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=-1, y=-1} },
	},
	O={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
	},
	S={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=1, y=1}, {x=1, y=0}, {x=0, y=0}, {x=0, y=-1} },
		{ {x=-1, y=1}, {x=0, y=1}, {x=0, y=0}, {x=1, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=0, y=1} },
	},
	T={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=1, y=0} },
		{ {x=0, y=0}, {x=1, y=0}, {x=-1, y=0}, {x=0, y=1} },
		{ {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=-1, y=0} },
	},
	Z={
		{ {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=1, y=0} },
		{ {x=1, y=-1}, {x=1, y=0}, {x=0, y=0}, {x=0, y=1} },
		{ {x=1, y=1}, {x=0, y=1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=-1, y=1}, {x=-1, y=0}, {x=0, y=0}, {x=0, y=-1} },
	}
}

SRS.wallkicks_3x3 = {
	[0]={
		[1]={{x=-1, y=0}, {x=-1, y=-1}},
		[2]={},
		[3]={{x=1, y=0}, {x=1, y=-1}},
	},
	[1]={
		[0]={{x=1, y=0}, {x=1, y=1}},
		[2]={{x=1, y=0}, {x=1, y=-1}},
		[3]={},
	},
	[2]={
		[0]={},
		[1]={{x=-1, y=0}, {x=-1, y=1}},
		[3]={{x=1, y=0}, {x=1, y=1}},
	},
	[3]={
		[0]={{x=-1, y=0}, {x=-1, y=1}},
		[1]={},
		[2]={{x=-1, y=0}, {x=-1, y=-1}},
	},
};

SRS.wallkicks_line = {
	[0]={
		[1]={{x=-1, y=0}, {x=-1, y=-1}, {x=1, y=0}, {x=1, y=1}},
		[2]={},
		[3]={{x=1, y=0}, {x=1, y=-1}, {x=-1, y=0}, {x=-1, y=-1}},
	},
	[1]={
		[0]={{x=1, y=0}, {x=1, y=1}, {x=-1, y=0}, {x=-1, y=-1}},
		[2]={{x=1, y=0}, {x=1, y=-1}, {x=-1, y=0}, {x=-1, y=1}},
		[3]={},
	},
	[2]={
		[0]={},
		[1]={{x=-1, y=0}, {x=-1, y=1}, {x=1, y=0}, {x=1, y=-1}},
		[3]={{x=1, y=0}, {x=1, y=1}, {x=-1, y=0}, {x=-1, y=-1}},
	},
	[3]={
		[0]={{x=-1, y=0}, {x=-1, y=1}, {x=1, y=0}, {x=1, y=-1}},
		[1]={},
		[2]={{x=-1, y=0}, {x=-1, y=-1}, {x=1, y=0}, {x=1, y=1}},
	},
};

-- Component functions.

function SRS:attemptWallkicks(piece, new_piece, rot_dir, grid)

	local kicks
	if piece.shape == "O" then
		return
	elseif piece.shape == "I" then
		kicks = SRS.wallkicks_line[piece.rotation][new_piece.rotation]
	else
		kicks = SRS.wallkicks_3x3[piece.rotation][new_piece.rotation]
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

function SRS:onPieceCreate(piece, grid)
	piece.manipulations = 0
	piece.rotations = 0
end

function SRS:onPieceDrop(piece, grid)
	piece.lock_delay = 0 -- step reset
end

function SRS:onPieceMove(piece, grid)
	piece.lock_delay = 0 -- move reset
	if piece:isDropBlocked(grid) then
		piece.manipulations = piece.manipulations + 1
		if piece.manipulations >= 10 then
			piece:dropToBottom(grid)
			piece.locked = true
		end
	end
end

function SRS:onPieceRotate(piece, grid)
	piece.lock_delay = 0 -- rotate reset
	if piece:isDropBlocked(grid) then
		piece.rotations = piece.rotations + 1
		if piece.rotations >= 8 then
			piece:dropToBottom(grid)
			piece.locked = true
		end
	end
end

function SRS:get180RotationValue() 
	return 3
end

return SRS
