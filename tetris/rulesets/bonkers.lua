local Ruleset = require "tetris.rulesets.ruleset"

local BONKERS = Ruleset:extend()

BONKERS.name = "B.O.N.K.E.R.S."
BONKERS.hash = "Bonkers"
BONKERS.world = true

BONKERS.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

BONKERS.colourscheme = {
	I = "G",
	J = "G",
	L = "G",
	O = "G",
	S = "G",
	T = "G",
	Z = "G",
}

BONKERS.softdrop_lock = false
BONKERS.harddrop_lock = true

BONKERS.block_offsets = {
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

-- Component functions.

function BONKERS:attemptRotate(new_inputs, piece, grid, initial)
	local rot_dir = 0
	
	if (new_inputs["rotate_left"] or new_inputs["rotate_left2"]) then
		rot_dir = 3
	elseif (new_inputs["rotate_right"] or new_inputs["rotate_right2"]) then
		rot_dir = 1
	elseif (new_inputs["rotate_180"]) then
		rot_dir = self:get180RotationValue()
	end

	if rot_dir == 0 then return end
    if config.gamesettings.world_reverse == 3 or (self.world and config.gamesettings.world_reverse == 2) then
        rot_dir = 4 - rot_dir
    end

	local new_piece = piece:withRelativeRotation(rot_dir)

	if (grid:canPlacePiece(new_piece)) then
		if piece:isDropBlocked(grid) then
			self:attemptWallkicks(piece, new_piece, rot_dir, grid)
		else
			piece:setRelativeRotation(rot_dir)
			self:onPieceRotate(piece, grid)
		end
	else
		if not(initial and self.enable_IRS_wallkicks == false) then
			self:attemptWallkicks(piece, new_piece, rot_dir, grid)
		end
	end
end

function BONKERS:attemptWallkicks(piece, new_piece, rot_dir, grid)

	if piece.shape == "I" then
		horizontal_kicks = {0, 1, -1, 2, -2}
	else
		horizontal_kicks = {0, 1, -1}
	end

	for y_offset = 24, -24, -1 do
		for idx, x_offset in pairs(horizontal_kicks) do
			local offset = {x=x_offset, y=y_offset}
			kicked_piece = new_piece:withOffset(offset)
			if grid:canPlacePiece(kicked_piece) then
				piece:setRelativeRotation(rot_dir)
				piece:setOffset(offset)
				piece.lock_delay = 0 -- rotate reset
				return
			end
		end
	end

end

function BONKERS:onPieceDrop(piece, grid)
	piece.lock_delay = 0 -- step reset
end

function BONKERS:onPieceMove(piece, grid)
	piece.lock_delay = 0 -- move reset
end

function BONKERS:onPieceRotate(piece, grid)
	piece.lock_delay = 0 -- rotate reset
end

return BONKERS
