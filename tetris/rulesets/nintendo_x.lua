local NRS_R = require 'tetris.rulesets.nintendo_r'
local NRS_X = NRS_R:extend()

NRS_X.name = "Nintendo-X"
NRS_X.hash = "NintendoX"

NRS_X.wallkicks_line_cw = {{x=1, y=0}, {x=2, y=0}, {x=-1, y=0}, {x=0, y=-1}}
NRS_X.wallkicks_line_ccw = {{x=-1, y=0}, {x=1, y=0}, {x=2, y=0}, {x=0, y=-1}}
NRS_X.wallkicks_other_cw = {{x=1, y=0}, {x=-1, y=0}, {x=0, y=-1}}
NRS_X.wallkicks_other_ccw = {{x=-1, y=0}, {x=1, y=0}, {x=0, y=-1}}

function NRS_X:checkNewLow(piece)
    for _, block in pairs(piece:getBlockOffsets()) do
        local y = piece.position.y + block.y
        if y > piece.lowest_y then
            piece.lock_delay = 0
            piece.lowest_y = y
        end
    end
end

function NRS_X:onPieceCreate(piece, grid)
    piece.lowest_y = -math.huge
end

function NRS_X:onPieceDrop(piece)
	self:checkNewLow(piece)
end

function NRS_X:onPieceRotate(piece)
    self:checkNewLow(piece)
end

function NRS_X:attemptWallkicks(piece, new_piece, rot_dir, grid)
	local kicks
	if piece.shape == "O" then
		return
	elseif piece.shape == "I" then
		kicks = (
			rot_dir == 3 and
			NRS_X.wallkicks_line_ccw or
			NRS_X.wallkicks_line_cw
		)
	else
		kicks = (
			rot_dir == 3 and
			NRS_X.wallkicks_other_ccw or
			NRS_X.wallkicks_other_cw
		)
	end

	assert(piece.rotation ~= new_piece.rotation)

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

return NRS_X