local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ruleset'

local MTET = Ruleset:extend()

MTET.name = "MTET"
MTET.hash = "MTET"
MTET.description = "A semi-permissive, arcade-inspired ruleset made for MTET."

MTET.softdrop_lock = false
MTET.harddrop_lock = true
MTET.spawn_above_field = true

MTET.colourscheme = {
	I = "R",
	J = "G",
	L = "M",
	O = "C",
	S = "B",
	T = "O",
	Z = "Y",
}

MTET.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

MTET.big_spawn_positions = {
	I = { x=3, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=3, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

MTET.block_offsets = {
	I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=0, y=1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=-2}, {x=-1, y=0}, {x=-1, y=1} },
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
		{ {x=1, y=0}, {x=1, y=-1}, {x=0, y=-1}, {x=0, y=-2} },
		{ {x=-1, y=0}, {x=0, y=0}, {x=0, y=-1}, {x=1, y=-1} },
		{ {x=-1, y=-2}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
	},
	T={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=-1, y=-1}, {x=0, y=-2} },
	},
	Z={
		{ {x=1, y=0}, {x=0, y=0}, {x=0, y=-1}, {x=-1, y=-1} },
		{ {x=1, y=-2}, {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
		{ {x=1, y=0}, {x=0, y=0}, {x=0, y=-1}, {x=-1, y=-1} },
		{ {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=-2} },
	}
}

--[[
{xFactor, 0},
{xFactor, 1},
{0, 1},
{-xFactor, 0},
{0, -1},
{xFactor, -1},
{-xFactor, -1}
]]
MTET.wallkicks_cw  = {{x=1, y=0},  {x=1, y=1},  {x=0, y=1}, {x=-1, y=0}, {x=0, y=-1}, {x=1, y=-1},  {x=-1, y=-1}}
MTET.wallkicks_ccw = {{x=-1, y=0}, {x=-1, y=1}, {x=0, y=1}, {x=1, y=0},  {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}}

function MTET:attemptWallkicks(piece, new_piece, rot_dir, grid)
	local kicks
    if piece.shape == "O" then
		return
	elseif rot_dir == 1 or rot_dir == 2 then
		kicks = MTET.wallkicks_cw
	else 
		kicks = MTET.wallkicks_ccw
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

function MTET:checkNewLow(piece)
	for _, block in pairs(piece:getBlockOffsets()) do
		local y = piece.position.y + block.y
		if y > piece.lowest_y then
			piece.allowed_manipulations = 15
			piece.lock_delay = 0
			piece.lowest_y = y
		end
	end
end

function MTET:onPieceCreate(piece, grid)
	piece.allowed_manipulations = 15
	piece.lowest_y = -math.huge
end

function MTET:onPieceDrop(piece, grid)
	self:checkNewLow(piece)
end

function MTET:onPieceMove(piece, grid)
	if piece:isDropBlocked(grid) and piece.allowed_manipulations > 0 then
		piece.lock_delay = self.game:getLockDelay() * (1 - piece.allowed_manipulations/15)
		piece.allowed_manipulations = piece.allowed_manipulations - 1
	end
end

function MTET:onPieceRotate(piece, grid)
	self:checkNewLow(piece)
	if piece:isDropBlocked(grid) and piece.allowed_manipulations > 0 then
		piece.lock_delay = self.game:getLockDelay() * (1 - piece.allowed_manipulations/15)
		piece.allowed_manipulations = piece.allowed_manipulations - 1
	end
end

function MTET:getDefaultOrientation() return 1 end

return MTET
