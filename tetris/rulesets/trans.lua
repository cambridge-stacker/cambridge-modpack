local ARS = require 'tetris.rulesets.arika'
local Trans = ARS:extend()

Trans.name = "TransRS"
Trans.hash = "TransRS"

function Trans:attemptRotate(new_inputs, piece, grid, initial)
	local rot_dir = 0
	
	if (new_inputs["rotate_left"] or new_inputs["rotate_left2"]) then
		rot_dir = 3
	elseif (new_inputs["rotate_right"] or new_inputs["rotate_right2"]) then
		rot_dir = 1
	elseif (new_inputs["rotate_180"]) then
		rot_dir = 2
	end

	if rot_dir == 0 then return end
    if config.gamesettings.world_reverse == 3 or (self.world and config.gamesettings.world_reverse == 2) then
        rot_dir = 4 - rot_dir
    end

    local new_piece = piece:withRelativeRotation(rot_dir)
    local pieces = {"I", "J", "L", "O", "S", "T", "Z"}
    repeat
        new_piece.shape = pieces[math.random(7)]
    until piece.shape ~= new_piece.shape

	if (grid:canPlacePiece(new_piece)) then
		self:onPieceRotate(piece, grid)
        piece:setRelativeRotation(rot_dir)
        piece.shape = new_piece.shape
	else
		if not(initial and self.enable_IRS_wallkicks == false) then
			if (grid:canPlacePiece(new_piece:withOffset({x=1, y=0}))) then
                self:onPieceRotate(piece, grid)
                piece:setRelativeRotation(rot_dir):setOffset({x=1, y=0})
                piece.shape = new_piece.shape
            elseif (grid:canPlacePiece(new_piece:withOffset({x=-1, y=0}))) then
                self:onPieceRotate(piece, grid)
                piece:setRelativeRotation(rot_dir):setOffset({x=-1, y=0})
                piece.shape = new_piece.shape
            end
		end
	end
end

return Trans