local ARS = require 'tetris.rulesets.arika'

local BONKERS = ARS:extend()

BONKERS.name = "SUPER302"
BONKERS.hash = "Super302"

BONKERS.colourscheme = {
	I = "C",
	J = "G",
	L = "G",
	O = "B",
	S = "C",
	T = "G",
	Z = "C"
}

function BONKERS:attemptWallkicks(piece, new_piece, rot_dir, grid)
	if piece.big then return end
	unfilled_block_offsets = {}
	for y = 4, grid.height - 1 do
		for x = 0, 9 do
			if not grid:isOccupied(x, y) then
				table.insert(unfilled_block_offsets, {x=x-100, y=y-100})
			end
		end
	end
	-- don't ask
	piece.position = {x=100, y=100}
	piece.getBlockOffsets = function(piece)
		return unfilled_block_offsets
	end
end

return BONKERS