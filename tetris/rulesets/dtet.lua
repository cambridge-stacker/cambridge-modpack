local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ruleset'

local DTET = Ruleset:extend()

DTET.name = "D.R.S."
DTET.hash = "DTET"

DTET.softdrop_lock = false
DTET.harddrop_lock = true
DTET.are_cancel = true
DTET.enable_IRS_wallkicks = true

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

function DTET:attemptRotate(new_inputs, piece, grid, initial)
	local rot_dir = 0
	
	if (new_inputs["rotate_180"]) or
	(new_inputs["rotate_left"] and new_inputs["rotate_right"]) or
	(new_inputs["rotate_left2"] and new_inputs["rotate_right2"]) then
		rot_dir = self:get180RotationValue()
	elseif (new_inputs["rotate_left"] or new_inputs["rotate_left2"]) then
		rot_dir = 3
	elseif (new_inputs["rotate_right"] or new_inputs["rotate_right2"]) then
		rot_dir = 1
	end

	if rot_dir == 0 then return end
    if config.gamesettings.world_reverse == 3 or (self.world and config.gamesettings.world_reverse == 2) then
        rot_dir = 4 - rot_dir
    end

	local new_piece = piece:withRelativeRotation(rot_dir)

	if (grid:canPlacePiece(new_piece)) then
		piece:setRelativeRotation(rot_dir)
		self:onPieceRotate(piece, grid)
	else
		if not(initial and self.enable_IRS_wallkicks == false) then
			self:attemptWallkicks(piece, new_piece, rot_dir, grid)
		end
	end
end

function DTET:attemptWallkicks(piece, new_piece, rot_dir, grid)
	
	local kicks
	if piece.shape == "O" or (
		(piece.shape == "S" or piece.shape == "Z" or piece.shape == "I")
		and rot_dir == 2
	) then
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