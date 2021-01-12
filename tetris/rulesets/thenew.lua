local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ruleset'

local TheNew = Ruleset:extend()

TheNew.name = "The Newtris"
TheNew.hash = "TheNew"

TheNew.softdrop_lock = false
TheNew.harddrop_lock = false

TheNew.colourscheme = {
    I = "C",
    J = "B",
    L = "M",
    O = "F",
    S = "G",
    Z = "R",
    T = "Y"
}

TheNew.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

TheNew.big_spawn_positions = {
	I = { x=3, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=3, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

TheNew.block_offsets = {
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

TheNew.wallkicks_ccw = {{x=0, y=1}, {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1}}
TheNew.wallkicks_cw = {{x=0, y=1}, {x=1, y=0}, {x=-1, y=0}, {x=0, y=-1}}

function TheNew:attemptWallkicks(piece, new_piece, rot_dir, grid)
	
	local kicks
    if piece.shape == "O" then
		return
	elseif rot_dir == 1 then
		kicks = TheNew.wallkicks_cw
	else
		kicks = TheNew.wallkicks_ccw
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

function TheNew:onPieceDrop(piece, grid)
	piece.lock_delay = 0 -- step reset
end

function TheNew:get180RotationValue() 
	if config.gamesettings.world_reverse == 1 then
		return 1
	else
		return 3
	end
end

function TheNew:getDefaultOrientation() return 3 end

return TheNew