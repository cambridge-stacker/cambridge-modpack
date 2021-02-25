local Ruleset = require 'tetris.rulesets.ruleset'
local Piece = require 'tetris.components.piece'

local RandomPieces = Ruleset:extend()

RandomPieces.name = "Random Pieces"
RandomPieces.hash = "RandomPieces"

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
                x = math.random(-1, 1),
                y = math.random(-2, 0)
            }
        until not containsPoint(offsets, generated_offset)
        offsets[i] = generated_offset
    end

    return offsets
end

RandomPieces.pieces = 1

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
    "F"
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
    local offsets = self:generateBlockOffsets()
    piece.getBlockOffsets = function()
        return offsets
    end
    piece.withOffset = function(self, offset)
        local piece = Piece(
            self.shape, self.rotation,
            {x = self.position.x + offset.x, y = self.position.y + offset.y},
            self.block_offsets, self.gravity, self.lock_delay, self.skin, self.colour, self.big
        )
        local offsets = self:getBlockOffsets()
        piece.getBlockOffsets = function()
            return offsets
        end
        piece.draw = function(self, opacity, brightness, grid, partial_das)
            if self.ghost then return false end
            if opacity == nil then opacity = 1 end
            if brightness == nil then brightness = 1 end
            love.graphics.setColor(brightness, brightness, brightness, opacity)
            local offsets = self:getBlockOffsets()
            local gravity_offset = 0
            if config.gamesettings.smooth_movement == 1 and 
               grid ~= nil and not self:isDropBlocked(grid) then
                gravity_offset = self.gravity * 16
            end
            if partial_das == nil then partial_das = 0 end
            for index, offset in pairs(offsets) do
                local x = self.position.x + offset.x
                local y = self.position.y + offset.y
                if self.big then
                    love.graphics.draw(
                        blocks[self.skin][self.colour],
                        64+x*32+partial_das*2, 16+y*32+gravity_offset*2,
                        0, 2, 2
                    )
                else
                    love.graphics.draw(
                        blocks[self.skin][self.colour],
                        64+x*16+partial_das, 16+y*16+gravity_offset
                    )
                end
            end
            return false
        end
        return piece
    end
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
    local offsets = self:generateBlockOffsets()
    new_piece.getBlockOffsets = function()
        return offsets
    end
    
    if (grid:canPlacePiece(new_piece)) then
        piece.getBlockOffsets = function()
            return offsets
        end
		self:onPieceRotate(piece, grid)
	else
		if not(initial and self.enable_IRS_wallkicks == false) then
			self:attemptWallkicks(piece, new_piece, offsets, grid)
		end
    end
end

function RandomPieces:onPieceDrop(piece) piece.lock_delay = 0 end
function RandomPieces:onPieceMove(piece) piece.lock_delay = 0 end
function RandomPieces:onPieceRotate(piece) piece.lock_delay = 0 end

return RandomPieces