local SRS = require 'tetris.rulesets.arika_srs'

local Tetra = SRS:extend()

Tetra.name = "Tetra-X"
Tetra.hash = "TetraX"

Tetra.colourscheme = {
	I = "O",
	L = "Y",
	J = "B",
	S = "C",
	Z = "R",
	O = "G",
	T = "M",
}

Tetra.wallkicks_3x3 = {
	[0]={
		[1]={{x=0, y=1}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=1}, {x=1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}},
		[2]={{x=0, y=1}, {x=0, y=-1}, {x=-1, y=0}, {x=1, y=0}},
		[3]={{x=0, y=1}, {x=1, y=0}, {x=-1, y=0}, {x=1, y=1}, {x=-1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}},
	},
	[1]={
		[0]={{x=0, y=1}, {x=1, y=0}, {x=-1, y=0}, {x=1, y=1}, {x=-1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}},
		[2]={{x=0, y=1}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=1}, {x=1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}},
		[3]={{x=0, y=1}, {x=0, y=-1}, {x=-1, y=0}, {x=1, y=0}},
	},
	[2]={
		[0]={{x=0, y=1}, {x=0, y=-1}, {x=-1, y=0}, {x=1, y=0}},
		[1]={{x=0, y=1}, {x=1, y=0}, {x=-1, y=0}, {x=1, y=1}, {x=-1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}},
		[3]={{x=0, y=1}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=1}, {x=1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}},
	},
	[3]={
		[0]={{x=0, y=1}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=1}, {x=1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}},
		[1]={{x=0, y=1}, {x=0, y=-1}, {x=-1, y=0}, {x=1, y=0}},
		[2]={{x=0, y=1}, {x=1, y=0}, {x=-1, y=0}, {x=1, y=1}, {x=-1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}},
	},
}

Tetra.wallkicks_line = {
	[0]={
		[1]={{x=0, y=-1}, {x=0, y=-2}, {x=0, y=1}, {x=1, y=-1}, {x=-1, y=-1}, {x=1, y=-2}, {x=-1, y=-2}},
		[2]={{x=0, y=-1}, {x=0, y=1}},
		[3]={{x=0, y=-1}, {x=0, y=-2}, {x=0, y=1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=-2}, {x=1, y=-2}},
	},
	[1]={
		[0]={{x=0, y=-1}, {x=0, y=-2}, {x=0, y=1}, {x=-1, y=0}, {x=1, y=0}, {x=2, y=0}},
		[2]={{x=0, y=-1}, {x=0, y=-2}, {x=0, y=1}, {x=-1, y=0}, {x=1, y=0}, {x=2, y=0}},
		[3]={{x=0, y=-1}, {x=0, y=1}},
	},
	[2]={
		[0]={{x=0, y=-1}, {x=0, y=1}},
		[1]={{x=0, y=1}, {x=0, y=2}, {x=0, y=-1}, {x=-1, y=1}, {x=1, y=1}, {x=-1, y=2}, {x=1, y=2}},
		[3]={{x=0, y=1}, {x=0, y=2}, {x=0, y=-1}, {x=1, y=1}, {x=-1, y=1}, {x=1, y=2}, {x=-1, y=2}},
	},
	[3]={
		[0]={{x=0, y=-1}, {x=0, y=-2}, {x=0, y=1}, {x=1, y=0}, {x=-1, y=0}, {x=-2, y=0}},
		[1]={{x=0, y=-1}, {x=0, y=1}},
		[2]={{x=0, y=-1}, {x=0, y=-2}, {x=0, y=1}, {x=1, y=0}, {x=-1, y=0}, {x=-2, y=0}},
	},
}

function Tetra:attemptWallkicks(piece, new_piece, rot_dir, grid)

	local kicks
	if piece.shape == "O" then
		return
	elseif piece.shape == "I" then
		kicks = Tetra.wallkicks_line[piece.rotation][new_piece.rotation]
	else
		kicks = Tetra.wallkicks_3x3[piece.rotation][new_piece.rotation]
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

function Tetra:checkNewLow(piece)
        for _, block in pairs(piece:getBlockOffsets()) do
                local y = piece.position.y + block.y
                if y > piece.lowest_y then
			piece.lock_delay = 0
			piece.lowest_y = y
                end
        end
end

function Tetra:onPieceCreate(piece) piece.lowest_y = -math.huge end
function Tetra:onPieceDrop(piece) self:checkNewLow(piece) end
function Tetra:onPieceMove() end
function Tetra:onPieceRotate() end
function Tetra:get180RotationValue() return 2 end

return Tetra

