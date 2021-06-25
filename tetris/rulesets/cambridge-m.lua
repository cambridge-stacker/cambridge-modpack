local CRS = require 'tetris.rulesets.cambridge'

local CRS_M = CRS:extend()

CRS_M.name = "Cambridge-M"
CRS_M.hash = "Cambridge-M"

function CRS_M:onPieceMove(piece, grid)
    CRS.onPieceMove(CRS, piece, grid)
    piece.lock_delay = 0
end

function CRS_M:onPieceRotate(piece, grid)
    CRS.onPieceRotate(CRS, piece, grid)
    piece.lock_delay = 0
end

return CRS_M