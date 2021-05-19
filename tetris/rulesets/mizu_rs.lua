local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ruleset'

local MizuRS = Ruleset:extend()

MizuRS.name = "Mizu Rotation"
MizuRS.hash = "MizuRS"

MizuRS.softdrop_lock = false
MizuRS.harddrop_lock = true
MizuRS.spawn_above_field = true

MizuRS.colourscheme = {
	I = "R",
	L = "O",
	J = "C",
	S = "G",
	Z = "M",
	O = "Y",
	T = "B",
}

MizuRS.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

MizuRS.big_spawn_positions = {
	I = { x=3, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=3, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

MizuRS.block_offsets = {
	I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
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

MizuRS.wallkicks_cw  = {{x=0, y=1}, {x=0, y=2}, {x=1, y=0}, {x=2, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=1}, {x=2, y=2}, {x=-1, y=1}, {x=-2, y=2}, {x=0, y=-1}, {x=0, y=-2}, {x=1, y=-1}, {x=2, y=-2}, {x=-1, y=-1}, {x=-2, y=-2}}
MizuRS.wallkicks_ccw = {{x=0, y=1}, {x=0, y=2}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0}, {x=2, y=0}, {x=-1, y=1}, {x=-2, y=2}, {x=1, y=1}, {x=2, y=2}, {x=0, y=-1}, {x=0, y=-2}, {x=-1, y=-1}, {x=-2, y=-2}, {x=1, y=-1}, {x=2, y=-2}}

function MizuRS:attemptWallkicks(piece, new_piece, rot_dir, grid)
	local kicks
    if piece.shape == "O" then
		return
	elseif rot_dir == 1 then
		kicks = MizuRS.wallkicks_cw
	else 
		kicks = MizuRS.wallkicks_ccw
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

function MizuRS:checkNewLow(piece)
	for _, block in pairs(piece:getBlockOffsets()) do
		local y = piece.position.y + block.y
		if y > piece.lowest_y then
			piece.ldincrease = 20
			piece.lock_delay = 0
			piece.lowest_y = y
		end
	end
end

function MizuRS:onPieceCreate(piece, grid)
	piece.ldincrease = 20
	piece.lowest_y = -math.huge
end

function MizuRS:onPieceDrop(piece, grid)
	self:checkNewLow(piece)
end

function MizuRS:onPieceMove(piece, grid)
	if piece:isDropBlocked(grid) then
		piece.lock_delay = math.max((piece.lock_delay - piece.ldincrease), 0)
		piece.ldincrease = piece.ldincrease - 1
	end
end

function MizuRS:onPieceRotate(piece, grid)
	if piece:isDropBlocked(grid) then
		piece.lock_delay = math.max((piece.lock_delay - piece.ldincrease), 0)
		piece.ldincrease = piece.ldincrease - 1
	end
end

function MizuRS:getDefaultOrientation() return 3 end

return MizuRS
