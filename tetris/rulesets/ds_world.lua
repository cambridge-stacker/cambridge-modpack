local SRS = require 'tetris.rulesets.standard'

local DS = SRS:extend()

DS.name = "DS-World"
DS.hash = "DS-World"

DS.are = false

function DS:onPieceDrop(piece) piece.lock_delay = 0 end
function DS:onPieceMove(piece) piece.lock_delay = 0 end
function DS:onPieceRotate(piece) piece.lock_delay = 0 end

function DS:get180RotationValue() 
	return 3
end

return DS