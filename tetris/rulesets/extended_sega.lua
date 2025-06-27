local Sega = require 'tetris.rulesets.sega'

local ExtendedSega = Sega:extend()

ExtendedSega.name = "Extended Sega"
ExtendedSega.hash = "ExtendedSega"
ExtendedSega.description = "The Sega ruleset with one-cell lateral kicks."

function ExtendedSega:attemptWallkicks(piece, new_piece, rot_dir, grid)
    if piece.shape == "I" or piece.shape == "O" then return end

    local kick_dir = "none"

    for _, offset in pairs(new_piece:getBlockOffsets()) do
        if piece.position.x + offset.x < 0 then
            kick_dir = "right"
            break
        elseif piece.position.x + offset.x >= grid.width then
            kick_dir = "left"
            break
        end
    end

    if kick_dir == "none" then
        return
    elseif kick_dir == "right" and (grid:canPlacePiece(new_piece:withOffset({x=1, y=0}))) then
		piece:setRelativeRotation(rot_dir):setOffset({x=1, y=0})
	elseif kick_dir == "left" and (grid:canPlacePiece(new_piece:withOffset({x=-1, y=0}))) then
		piece:setRelativeRotation(rot_dir):setOffset({x=-1, y=0})
	end
end

return ExtendedSega