local SRS = require 'tetris.rulesets.standard'

local Shirase = SRS:extend()

Shirase.name = "Shirase RS"
Shirase.hash = "Shirase"
Shirase.description = "help what happened to my pieces"
Shirase.world = false

Shirase.colourscheme = {
    I = "R",
    J = "R",
    L = "R",
    O = "R",
    S = "R",
    T = "R",
    Z = "R"
}

Shirase.block_offsets = {
    I={
        { {x=-2, y=0}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
        { {x=1, y=-2}, {x=1, y=-1}, {x=1, y=0}, {x=1, y=1} },
        { {x=0, y=1}, {x=1, y=1}, {x=2, y=1}, {x=3, y=1} },
        { {x=0, y=0}, {x=0, y=1}, {x=0, y=2}, {x=0, y=3} },
    },
    J={
        { {x=-1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
        { {x=1, y=-2}, {x=2, y=-2}, {x=1, y=-1}, {x=1, y=0} },
        { {x=1, y=0}, {x=2, y=0}, {x=3, y=0}, {x=3, y=1} },
        { {x=1, y=0}, {x=1, y=1}, {x=0, y=2}, {x=1, y=2} },
    },
    L={
        { {x=1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
        { {x=1, y=-2}, {x=1, y=-1}, {x=1, y=0}, {x=2, y=0} },
        { {x=1, y=0}, {x=2, y=0}, {x=3, y=0}, {x=1, y=1} },
        { {x=0, y=0}, {x=1, y=0}, {x=1, y=1}, {x=1, y=2} },
    },
    O={
        { {x=-1, y=-1}, {x=0, y=-1}, {x=-1, y=0}, {x=0, y=0} },
        { {x=0, y=-2}, {x=1, y=-2}, {x=0, y=-1}, {x=1, y=-1} },
        { {x=1, y=-1}, {x=2, y=-1}, {x=1, y=0}, {x=2, y=0} },
        { {x=0, y=0}, {x=1, y=0}, {x=0, y=1}, {x=1, y=1} },
    },
    S={
        { {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=0}, {x=0, y=0} },
        { {x=1, y=-2}, {x=1, y=-1}, {x=2, y=-1}, {x=2, y=0} },
        { {x=2, y=0}, {x=3, y=0}, {x=1, y=1}, {x=2, y=1} },
        { {x=0, y=0}, {x=0, y=1}, {x=1, y=1}, {x=1, y=2} },
    },
    T={
        { {x=0, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
        { {x=1, y=-2}, {x=1, y=-1}, {x=2, y=-1}, {x=1, y=0} },
        { {x=1, y=0}, {x=2, y=0}, {x=3, y=0}, {x=2, y=1} },
        { {x=1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=1, y=2} },
    },
    Z={
        { {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=1, y=0} },
        { {x=2, y=-2}, {x=1, y=-1}, {x=2, y=-1}, {x=1, y=0} },
        { {x=1, y=0}, {x=2, y=0}, {x=2, y=1}, {x=3, y=1} },
        { {x=1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=0, y=2} },
    }
}

function Shirase:attemptWallkicks(piece, new_piece, rot_dir, grid)

	local kicks
	if piece.shape == "I" then
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

function Shirase:onPieceDrop(piece) piece.lock_delay = 0 end
function Shirase:onPieceMove(piece) piece.lock_delay = 0 end
function Shirase:onPieceRotate(piece) piece.lock_delay = 0 end

function Shirase:getDefaultOrientation()
    return love.math.random(4)
end

return Shirase