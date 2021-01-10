local SRS = require 'tetris.rulesets.standard_exp'

local DS = SRS:extend()

DS.name = "DS-World"
DS.hash = "DS-World"

DS.are = false

function DS:onPieceDrop(piece) piece.lock_delay = 0 end
function DS:onPieceMove(piece) piece.lock_delay = 0 end
function DS:onPieceRotate(piece) piece.lock_delay = 0 end

function DS:get180RotationValue() 
	if config.gamesettings.world_reverse == 1 then
		return 1
	else
		return 3
	end
end

return DS