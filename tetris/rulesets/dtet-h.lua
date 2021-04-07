local DTET = require 'tetris.rulesets.dtet'

local DTETH = DTET:extend()

DTETH.name = "D.R.S.-H"
DTETH.hash = "D.R.S.-H"

DTETH.are_cancel = false

function DTETH:attemptWallkicks(piece, new_piece, rot_dir, grid)
	
	local kicks
	if piece.shape == "O" then
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

return DTETH