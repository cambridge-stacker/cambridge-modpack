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

function SRS:onPieceMove(piece, grid)
	piece.lock_delay = 0 -- move reset
	if piece:isDropBlocked(grid) then
		piece.manipulations = piece.manipulations + 1
		if piece.manipulations >= 24 then
			piece:dropToBottom(grid)
			piece.locked = true
		end
	end
end

function SRS:onPieceRotate(piece, grid)
	piece.lock_delay = 0 -- rotate reset
	if piece:isDropBlocked(grid) then
		piece.rotations = piece.rotations + 1
		if piece.rotations >= 12 then
			piece:dropToBottom(grid)
			piece.locked = true
		end
	end
end

function SRS:get180RotationValue() return 2 end

return SRS
