local SRS = require 'tetris.rulesets.arika_srs'

local Cultris = SRS:extend()

Cultris.name = "Cultris II"
Cultris.hash = "Cultris"

Cultris.colourscheme = {
	I = "G",
	L = "M",
	J = "B",
	S = "C",
	Z = "F",
	O = "Y",
	T = "R",
}

Cultris.wallkicks = {
	{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}, {x=-2, y=0}, {x=2, y=0}
}

function Cultris:attemptWallkicks(piece, new_piece, rot_dir, grid)
	local kicks = Cultris.wallkicks

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

function Cultris:onPieceMove() end
function Cultris:onPieceRotate() end
function Cultris:get180RotationValue() return 2 end

return Cultris
