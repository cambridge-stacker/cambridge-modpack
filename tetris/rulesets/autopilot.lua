local ARS = require 'tetris.rulesets.arika'

local Autopilot = ARS:extend()

Autopilot.name = "Autopilot-I"
Autopilot.hash = "Autopilot"

function Autopilot:attemptRotate(new_inputs, piece, grid, initial)
	local rot_dir = 0
	
	if (new_inputs["rotate_left"] or new_inputs["rotate_left2"]) then
		rot_dir = 3
	elseif (new_inputs["rotate_right"] or new_inputs["rotate_right2"]) then
		rot_dir = 1
	elseif (new_inputs["rotate_180"]) then
		rot_dir = self:get180RotationValue()
	end

	if rot_dir == 0 then return end
    if config.gamesettings.world_reverse == 3 or (self.world and config.gamesettings.world_reverse == 2) then
        rot_dir = 4 - rot_dir
    end

	local new_piece = piece:withRelativeRotation(rot_dir)

	if self:attemptWallkicks(piece, new_piece, rot_dir, grid) then
        return
    elseif grid:canPlacePiece(new_piece) then
        piece:setRelativeRotation(rot_dir)
		self:onPieceRotate(piece, grid)
    end
end

function Autopilot:attemptWallkicks(piece, new_piece, rot_dir, grid)
    for y = grid.height, -grid.height, -1 do
        for x = -grid.width, grid.width do
            kicked_piece = piece:withOffset({x=x, y=y})
            kicked_piece.shape = "I"
            kicked_piece.rotation = 1
            if grid:canPlacePiece(kicked_piece) then
                piece:setOffset({x=x, y=y})
                piece.shape = "I"
                piece.rotation = 1
                return true
            end
        end
    end
end

return Autopilot