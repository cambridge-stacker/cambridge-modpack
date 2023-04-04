local SRS = require 'tetris.rulesets.standard_ace'

local EARS = SRS:extend()

EARS.name = "E.A.R.S."
EARS.hash = "EARS"

EARS.colourscheme = {
    I = "W",
    J = "G",
    L = "R",
    O = "C",
    S = "B",
    T = "Y",
    Z = "O",
}

function EARS:attemptWallkicks(piece, new_piece, rot_dir, grid)
    for kd = 1, grid.height do
        for x = -kd, kd do
            tx = rot_dir == 3 and -x or x
            for y = kd, -kd, -1 do
                if math.abs(tx) + math.abs(y) == kd then
                    offset = {x=tx, y=y}
                    kicked_piece = new_piece:withOffset(offset)
		            if grid:canPlacePiece(kicked_piece) then
			            piece:setRelativeRotation(rot_dir)
			            piece:setOffset(offset)
                        self:onPieceRotate(piece, grid, offset.y < 0)
			            return
                    end
                end
            end
        end
    end
end

function EARS:get180RotationValue()
    return 2
end

return EARS