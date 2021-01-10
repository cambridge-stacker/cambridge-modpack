local SRS = require 'tetris.rulesets.standard_exp'

local Shirase = SRS:extend()

Shirase.name = "Shirase RS"
Shirase.hash = "Shirase"
Shirase.world = false

Shirase.colourscheme = {
    I = "R",
    J = "R",
    L = "R",
    O = "R",
    S = "R",
    T = "R",
    Z = "R"
}

Shirase.block_offsets = {
    I={
        { {x=-2, y=0}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
        { {x=1, y=-2}, {x=1, y=-1}, {x=1, y=0}, {x=1, y=1} },
        { {x=0, y=1}, {x=1, y=1}, {x=2, y=1}, {x=3, y=1} },
        { {x=0, y=0}, {x=0, y=1}, {x=0, y=2}, {x=0, y=3} },
    },
    J={
        { {x=-1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
        { {x=1, y=-2}, {x=2, y=-2}, {x=1, y=-1}, {x=1, y=0} },
        { {x=1, y=0}, {x=2, y=0}, {x=3, y=0}, {x=3, y=1} },
        { {x=1, y=0}, {x=1, y=1}, {x=0, y=2}, {x=1, y=2} },
    },
    L={
        { {x=1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
        { {x=1, y=-2}, {x=1, y=-1}, {x=1, y=0}, {x=2, y=0} },
        { {x=1, y=0}, {x=2, y=0}, {x=3, y=0}, {x=1, y=1} },
        { {x=0, y=0}, {x=1, y=0}, {x=1, y=1}, {x=1, y=2} },
    },
    O={
        { {x=-1, y=-1}, {x=0, y=-1}, {x=-1, y=0}, {x=0, y=0} },
        { {x=0, y=-2}, {x=1, y=-2}, {x=0, y=-1}, {x=1, y=-1} },
        { {x=1, y=-1}, {x=2, y=-1}, {x=1, y=0}, {x=2, y=0} },
        { {x=0, y=0}, {x=1, y=0}, {x=0, y=1}, {x=1, y=1} },
    },
    S={
        { {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=0}, {x=0, y=0} },
        { {x=1, y=-2}, {x=1, y=-1}, {x=2, y=-1}, {x=2, y=0} },
        { {x=2, y=0}, {x=3, y=0}, {x=1, y=1}, {x=2, y=1} },
        { {x=0, y=0}, {x=0, y=1}, {x=1, y=1}, {x=1, y=2} },
    },
    T={
        { {x=0, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=1, y=0} },
        { {x=1, y=-2}, {x=1, y=-1}, {x=2, y=-1}, {x=1, y=0} },
        { {x=1, y=0}, {x=2, y=0}, {x=3, y=0}, {x=2, y=1} },
        { {x=1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=1, y=2} },
    },
    Z={
        { {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=1, y=0} },
        { {x=2, y=-2}, {x=1, y=-1}, {x=2, y=-1}, {x=1, y=0} },
        { {x=1, y=0}, {x=2, y=0}, {x=2, y=1}, {x=3, y=1} },
        { {x=1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=0, y=2} },
    }
}

function Shirase:onPieceDrop(piece) piece.lock_delay = 0 end
function Shirase:onPieceMove(piece) piece.lock_delay = 0 end
function Shirase:onPieceRotate(piece) piece.lock_delay = 0 end

function Shirase:getDefaultOrientation()
    return math.random(4)
end

return Shirase