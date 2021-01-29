local SRS = require 'tetris.rulesets.standard'

local H = SRS:extend()

H.name = "h"
H.hash = "h"
H.world = false

function H:attemptRotate(new_inputs, piece, grid, initial)
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

	if not(initial and self.enable_IRS_wallkicks == false) then
		piece:setRelativeRotation(rot_dir)
		self:onPieceRotate(piece, grid)
	end
end

function H:getDefaultOrientation()
    return math.random(4)
end

return H