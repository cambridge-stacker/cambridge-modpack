local SRS = require 'tetris.rulesets.standard'

local Infinity = SRS:extend()

Infinity.name = "Infinity-SRS"
Infinity.hash = "Infinity-SRS"

function Infinity:onPieceDrop(piece) piece.lock_delay = 0 end
function Infinity:onPieceMove(piece) piece.lock_delay = 0 end
function Infinity:onPieceRotate(piece) piece.lock_delay = 0 end

return Infinity