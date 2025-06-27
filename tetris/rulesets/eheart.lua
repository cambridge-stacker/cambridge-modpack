local Piece = require 'tetris.components.piece'
local ARS = require 'tetris.rulesets.arika'

local EHeart = ARS:extend()

EHeart.name = "E-Heart ARS"
EHeart.hash = "EHeartARS"
EHeart.description = "A modified version of ARS for ***ris With Card Captor Sakura Eternal Heart. Pairs well with Sakura A3."

function EHeart:attemptWallkicks(piece, new_piece, rot_dir, grid)

	-- I and O don't kick
	if (piece.shape == "I" or piece.shape == "O") then return end

	-- center column rule (kicks)
	local offsets = new_piece:getBlockOffsets()
	table.sort(offsets, function(A, B) return A.y < B.y or A.y == B.y and A.x < B.y end)
	for index, offset in pairs(offsets) do
		if grid:isOccupied(piece.position.x + offset.x, piece.position.y + offset.y) then
			if offset.x < 0 then
				self:lateralKick(1, piece, new_piece, rot_dir, grid)
				break
			elseif offset.x == 0 then
				return
			elseif offset.x > 0 then
				self:lateralKick(-1, piece, new_piece, rot_dir, grid)
				break
			end
		end
	end
end

function EHeart:lateralKick(dx, piece, new_piece, rot_dir, grid)
	if (grid:canPlacePiece(new_piece:withOffset({x=dx, y=0}))) then
		self:onPieceRotate(piece, grid)
		piece:setRelativeRotation(rot_dir):setOffset({x=dx, y=0})
	end
end

return EHeart
