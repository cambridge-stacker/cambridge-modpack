-- thanks Adventium_ for heavily un-spaghetti-ing this code

local Ruleset = require 'tetris.rulesets.ruleset'
local Piece = require 'tetris.components.piece'

local RandomPieces = Ruleset:extend()

RandomPieces.name = "Random Pieces"
RandomPieces.hash = "RandomPieces"
RandomPieces.description = "because predictability is lame"

function RandomPieces:generateBlockOffsets()
    function containsPoint(points, p)
        for _, point in pairs(points) do
            if point.x == p.x and point.y == p.y then
                return true
            end
        end
        return false
    end
    
    local offsets = {}
    for i = 1, 4 do
        local generated_offset = {}
        repeat
            generated_offset = {
                x = love.math.random(-1, 1),
                y = love.math.random(-2, 0)
            }
        until not containsPoint(offsets, generated_offset)
        offsets[i] = generated_offset
    end

    return { { offsets, offsets, offsets, offsets } }
end

RandomPieces.spawn_positions = {
    { x=4, y=5 }
}

RandomPieces.big_spawn_positions = {
    { x=2, y=3 }
}

RandomPieces.next_sounds = {
    "O"
}

RandomPieces.colourscheme = {
    "W"
}

RandomPieces.block_offsets = {
    {
		{ {x=0, y=0} },
		{ {x=0, y=0} },
		{ {x=0, y=0} },
		{ {x=0, y=0} },
    }
}

function RandomPieces:onPieceCreate(piece)
	piece.block_offsets = RandomPieces.generateBlockOffsets()
end

function RandomPieces:attemptRotate(new_inputs, piece, grid, initial)
    if not (
        new_inputs.rotate_left or new_inputs.rotate_left2 or
        new_inputs.rotate_right or new_inputs.rotate_right2 or
        new_inputs.rotate_180
    ) then
        return
    end
	
    local new_piece = piece:withOffset({x=0, y=0})
	new_piece.block_offsets = RandomPieces.generateBlockOffsets()
	
	if (grid:canPlacePiece(new_piece)) then
		piece.block_offsets = new_piece.block_offsets
		self:onPieceRotate(piece, grid)
	end
end

function RandomPieces:onPieceDrop(piece) piece.lock_delay = 0 end
function RandomPieces:onPieceMove(piece) piece.lock_delay = 0 end
function RandomPieces:onPieceRotate(piece) piece.lock_delay = 0 end

return RandomPieces