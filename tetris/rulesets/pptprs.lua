local Piece = require 'tetris.components.piece'
local SRS = require 'tetris.rulesets.standard'

local PPTPRS = SRS:extend()

PPTPRS.name = "PPTPRS"
PPTPRS.hash = "Puyo Tetris Pentos"

PPTPRS.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=5, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

PPTPRS.block_offsets = {
	I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0}, {x=-3, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2}, {x=0, y=-2} },
		{ {x=0, y=1}, {x=-1, y=1}, {x=-2, y=1}, {x=1, y=1}, {x=2, y=1} },
		{ {x=-1, y=0}, {x=-1, y=-1}, {x=-1, y=1}, {x=-1, y=2}, {x=-1, y=3} },
	},
	J={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=-2}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0} , {x=1, y=-2}, {x=-1, y=-1} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=0, y=-2}, {x=-1, y=0}, {x=1, y=-1} },
	},
	L={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=-2}, {x=-1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=1, y=0}, {x=-1, y=-2} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=-2}, {x=-1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=1, y=0}, {x=-1, y=-2} },
	},
	O={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=-1, y=-2}, {x=0, y=-2}, {x=-1, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=-1, y=-2}, {x=0, y=-2}, {x=-2, y=-2} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=-1, y=-2}, {x=0, y=-2}, {x=0, y=-3} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=-1, y=-2}, {x=0, y=-2}, {x=1, y=-1} },
	},
	S={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0} },
		{ {x=1, y=1}, {x=1, y=0}, {x=0, y=0}, {x=0, y=-1}, {x=0, y=-2} },
		{ {x=-1, y=1}, {x=0, y=1}, {x=0, y=0}, {x=1, y=0}, {x=2, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=0, y=1}, {x=0, y=2} },
	},
	T={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1}, {x=0, y=-2} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=1, y=0}, {x=2, y=0} },
		{ {x=0, y=0}, {x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=0, y=2} },
		{ {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=-1, y=0}, {x=-2, y=0} },
	},
	Z={
		{ {x=-1, y=-2}, {x=0, y=-2}, {x=0, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=1, y=-2}, {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=1, y=0}, {x=0, y=0}, {x=0, y=-1}, {x=-1, y=-1}, {x=-1, y=-2} },
		{ {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=-2}, {x=1, y=-2} },
	}
}

PPTPRS.wallkicks_O = {
	[0]={
		[1]={{x=0, y=1}},
		[2]={{x=0, y=1}},
		[3]={{x=-1, y=0}},
	},
	[1]={
				[0]={{x=0, y=-1}},
				[2]={{x=-1, y=0}},
				[3]={{x=-1, y=0}},
		},
	[2]={
				[0]={{x=0, y=-1}},
				[1]={{x=1, y=0}},
				[3]={{x=0, y=-1}},
		},
	[3]={
				[0]={{x=1, y=0}},
				[1]={{x=1, y=0}},
				[2]={{x=0, y=1}},
		},
}

function PPTPRS:attemptWallkicks(piece, new_piece, rot_dir, grid)

	local kicks
	if piece.shape == "O" then
		kicks = PPTPRS.wallkicks_O[piece.rotation][new_piece.rotation]
	elseif piece.shape == "I" then
		kicks = SRS.wallkicks_line[piece.rotation][new_piece.rotation]
	else
		kicks = SRS.wallkicks_3x3[piece.rotation][new_piece.rotation]
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

return PPTPRS
