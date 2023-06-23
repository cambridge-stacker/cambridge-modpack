local SRS = require 'tetris.rulesets.standard_ti'

local TexyWorld = SRS:extend()

TexyWorld.name = "Texy-World"
TexyWorld.hash = "TexyWorld"

function TexyWorld:attemptWallkicks(piece, new_piece, rot_dir, grid)

	local kicks
	if piece.shape == "O" then
		return
	elseif piece.shape == "I" then
		kicks = SRS.wallkicks_line[piece.rotation][new_piece.rotation]
	else
		kicks = SRS.wallkicks_3x3[piece.rotation][new_piece.rotation]
	end

	assert(piece.rotation ~= new_piece.rotation)

	for idx, temp_offset in pairs(kicks) do
        offset = {
            x=temp_offset.x*(rot_dir==3 and -1 or 1),
            y=temp_offset.y
        }
		kicked_piece = new_piece:withOffset(offset)
		if grid:canPlacePiece(kicked_piece) then
			piece:setRelativeRotation(rot_dir)
			piece:setOffset(offset)
			self:onPieceRotate(piece, grid, offset.y < 0)
			return
		end
	end

end

return TexyWorld