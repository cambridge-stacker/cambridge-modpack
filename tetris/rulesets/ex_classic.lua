local Ruleset = require 'tetris.rulesets.ruleset'

local EXClassic = Ruleset:extend()

EXClassic.name = "T-EX-Classic"
EXClassic.hash = "EXClassic"

EXClassic.softdrop_lock = false
EXClassic.harddrop_lock = true

EXClassic.MANIPULATIONS_MAX = 10
EXClassic.ROTATIONS_MAX = 8

EXClassic.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

EXClassic.big_spawn_positions = {
	I = { x=3, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=3, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

EXClassic.block_offsets = {
	I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=0, y=1} },
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
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=-1, y=-2}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
	},
	T={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=-1, y=-1}, {x=0, y=-2} },
	},
	Z={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
	}
}

EXClassic.normal_ccw = {
    {x=0, y=0}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=1},
    {x=1, y=1}, {x=1, y=0}, {x=0, y=-1}
}
EXClassic.normal_cw = {
    {x=0, y=0}, {x=1, y=0}, {x=1, y=1}, {x=0, y=1},
    {x=-1, y=1}, {x=-1, y=0}, {x=0, y=-1}
}
EXClassic.left_ccw = {
    {x=-1, y=0}, {x=-1, y=1}, {x=-2, y=0}, {x=0, y=0},
    {x=0, y=1}, {x=0, y=-1}, {x=1, y=1}, {x=1, y=0}
}
EXClassic.left_cw = {
    {x=-1, y=0}, {x=-1, y=1}, {x=0, y=1}, {x=-1, y=2},
    {x=0, y=0}, {x=0, y=-1}, {x=1, y=0}, {x=1, y=1}
}
EXClassic.right_ccw = {
    {x=1, y=0}, {x=1, y=1}, {x=0, y=1}, {x=1, y=2},
    {x=0, y=0}, {x=0, y=-1}, {x=-1, y=0}, {x=-1, y=1}
}
EXClassic.right_cw = {
    {x=1, y=0}, {x=1, y=1}, {x=2, y=0}, {x=0, y=0},
    {x=0, y=1}, {x=0, y=-1}, {x=-1, y=1}, {x=-1, y=0}
}

function EXClassic:attemptRotate(new_inputs, piece, grid, initial)
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
	self:attemptWallkicks(piece, new_piece, rot_dir, grid)
end

function EXClassic:attemptWallkicks(piece, new_piece, rot_dir, grid)
    local kicks
    if self.game.das.direction == "left" and (
        self.game.das.frames >= self.game:getDasLimit() - self.game:getARR() or
        piece:isMoveBlocked(grid, {x=-1, y=0})
    ) then
        kicks = rot_dir == 1 and EXClassic.left_cw or EXClassic.left_ccw
    elseif self.game.das.direction == "right" and (
        self.game.das.frames >= self.game:getDasLimit() - self.game:getARR() or
        piece:isMoveBlocked(grid, {x=1, y=0})
    ) then
        kicks = rot_dir == 1 and EXClassic.right_cw or EXClassic.right_ccw
    else
        kicks = rot_dir == 1 and EXClassic.normal_cw or EXClassic.normal_ccw
    end

    for idx, offset in pairs(kicks) do
		kicked_piece = new_piece:withOffset(offset)
		if grid:canPlacePiece(kicked_piece) then
			piece:setRelativeRotation(rot_dir)
			piece:setOffset(offset)
			self:onPieceRotate(piece, grid, offset.y < 0)
			return
		end
	end
end

function EXClassic:onPieceCreate(piece, grid)
	piece.manipulations = 0
	piece.rotations = 0
end

function EXClassic:onPieceMove(piece, grid)
	if piece.manipulations < self.MANIPULATIONS_MAX then
        piece.lock_delay = 0 -- move reset
	    if piece:isDropBlocked(grid) then
		    piece.manipulations = piece.manipulations + 1
	    end
    end
end

function EXClassic:onPieceRotate(piece, grid, upward)
	if piece.rotations < self.ROTATIONS_MAX then
        piece.lock_delay = 0 -- rotate reset
	    if upward or piece:isDropBlocked(grid) then
            piece.rotations = piece.rotations + 1
	    end
    end
end

function EXClassic:get180RotationValue()
    return 3
end

function EXClassic:getDefaultOrientation()
    return 3
end

return EXClassic