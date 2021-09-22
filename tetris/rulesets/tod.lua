local SRS = require 'tetris.rulesets.arika_srs'

local TOD = SRS:extend()

TOD.name = "TOD M4"
TOD.hash = "TOD"

TOD.colourscheme = {
    I = "C",
    J = "B",
    L = "M",
    O = "W",
    S = "G",
    Z = "R",
    T = "Y"
}
TOD.harddrop_lock = false

function TOD:attemptWallkicks(piece, new_piece, rot_dir, grid)
    local kicks = {{x=1, y=0}, {x=-1, y=0}, {x=0, y=-1}}

    for idx, offset in pairs(kicks) do
        kicked_piece = new_piece:withOffset(offset)
        if grid:canPlacePiece(kicked_piece) then
            piece:setRelativeRotation(rot_dir)
            piece:setOffset(offset)
            self:onPieceRotate(piece, grid)
            return
        end
    end
end

function TOD:onPieceDrop(piece)
    piece.lock_delay = math.max(
        0, piece.lock_delay - math.ceil(1 / self.game:getGravity())
    )
end

function TOD:onPieceMove() end
function TOD:onPieceRotate() end
function TOD:canPieceRotate() return true end

return TOD