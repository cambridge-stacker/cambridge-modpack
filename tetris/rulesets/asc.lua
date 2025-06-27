local Ruleset = require 'tetris.rulesets.ruleset'

local Ascension = Ruleset:extend()

Ascension.name = "Ascension"
Ascension.hash = "Ascension"
Ascension.description = "A ruleset made for Ascension by winternebs."
Ascension.world = true
Ascension.colourscheme = {
	I = "C",
	L = "O",
	J = "B",
	S = "G",
	Z = "R",
	O = "Y",
	T = "M",
}
Ascension.softdrop_lock = false
Ascension.harddrop_lock = true
Ascension.spawn_above_field = true

Ascension.spawn_positions = {
	I = { x=4, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=4, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

Ascension.big_spawn_positions = {
	I = { x=2, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=2, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

Ascension.block_offsets = {
	I={
        { {x=-1, y=0}, {x=0, y=0}, {x=1, y=0}, {x=2, y=0} },
        { {x=0, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=0, y=2} },
        { {x=-2, y=0}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
        { {x=0, y=-2}, {x=0, y=-1}, {x=0, y=0}, {x=0, y=1} },
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
        { {x=0, y=-1}, {x=1, y=-1}, {x=0, y=0}, {x=1, y=0} },
        { {x=0, y=0}, {x=1, y=0}, {x=0, y=1}, {x=1, y=1} },
        { {x=-1, y=0}, {x=0, y=0}, {x=-1, y=1}, {x=0, y=1} },
        { {x=-1, y=-1}, {x=0, y=-1}, {x=-1, y=0}, {x=0, y=0} },
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

-- CCW kicks, negative X for CW
Ascension.kicks = {
    {x=1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=0, y=2}, {x=1, y=2}, {x=2, y=0}, {x=2, y=1},
    {x=2, y=2}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=2, y=-1}, {x=-1, y=2},
    {x=-2, y=0}, {x=0, y=-2}, {x=1, y=-2}, {x=2, y=-2}, {x=-2, y=1}, {x=-2, y=2}, {x=-1, y=-1},
}

function Ascension:attemptWallkicks(piece, new_piece, rot_dir, grid)
    
    if rot_dir == 2 then return end

    local kicks = Ascension.kicks

    assert(piece.rotation ~= new_piece.rotation)

	for idx, o in pairs(kicks) do
        offset = {
            x = o.x * (rot_dir == 1 and -1 or 1),
            y = o.y
        }
        kicked_piece = new_piece:withOffset(offset)
		if grid:canPlacePiece(kicked_piece) then
            self:onPieceRotate(piece, grid)
			piece:setRelativeRotation(rot_dir)
			piece:setOffset(offset)
			return
		end
    end
    
end

function Ascension:onPieceDrop(piece) piece.lock_delay = 0 end
function Ascension:onPieceMove(piece) piece.lock_delay = 0 end
function Ascension:onPieceRotate(piece) piece.lock_delay = 0 end

return Ascension