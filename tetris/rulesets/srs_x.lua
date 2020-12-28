local Piece = require 'tetris.components.piece'
local Ruleset = require 'tetris.rulesets.ti_srs'

local SRS = Ruleset:extend()

SRS.name = "SRS-X"
SRS.hash = "Reversed SRS drop functions"
SRS.softdrop_lock = true
SRS.harddrop_lock = false

SRS.colourscheme = {
	I = "R",
	L = "O",
	J = "B",
	S = "M",
	Z = "G",
	O = "Y",
	T = "C",
}

SRS.MANIPULATIONS_MAX = 24
SRS.ROTATIONS_MAX = 12

function SRS:onPieceDrop(piece, grid)
    if (piece.manipulations >= self.MANIPULATIONS_MAX or piece.rotations >= self.ROTATIONS_MAX) and piece:isDropBlocked(grid) then
        piece.locked = true
    else
        piece.lock_delay = 0 -- step reset
    end
end

function SRS:onPieceMove(piece, grid)
	piece.lock_delay = 0 -- move reset
	if piece:isDropBlocked(grid) then
		piece.manipulations = piece.manipulations + 1
		if piece.manipulations >= self.MANIPULATIONS_MAX then
			piece.locked = true
		end
	end
end

function SRS:onPieceRotate(piece, grid)
	piece.lock_delay = 0 -- rotate reset
	if piece:isDropBlocked(grid) then
        piece.rotations = piece.rotations + 1
		if piece.rotations >= self.ROTATIONS_MAX then
			piece.locked = true
		end
	end
end

function SRS:get180RotationValue() return 2 end

return SRS
