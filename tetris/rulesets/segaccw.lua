local ARS = require 'tetris.rulesets.arika'

local Sega = ARS:extend()

Sega.name = "Sega CCW"
Sega.hash = "SegaCCW"
Sega.description = "You can only rotate counterclockwise in this variant of the Sega ruleset."

function Sega:attemptRotate(new_inputs, piece, grid)
	local rot_dir = 0

    if new_inputs["rotate_left"] or new_inputs["rotate_left2"] or
       new_inputs["rotate_right"] or new_inputs["rotate_right2"] or
       new_inputs["rotate_180"] then rot_dir = 3 end

	local new_piece = piece:withRelativeRotation(rot_dir)

	if (grid:canPlacePiece(new_piece)) then
		self:onPieceRotate(piece, grid)
		piece:setRelativeRotation(rot_dir)
    end
end

return Sega
