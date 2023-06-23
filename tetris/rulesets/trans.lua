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

    if initial then
	    if (grid:canPlacePiece(new_piece)) then
		    self:onPieceRotate(piece, grid)
            piece:setRelativeRotation(rot_dir)
        end
	else
		self:attemptWallkicks(piece, new_piece, rot_dir, grid)
	end
end

function Trans:attemptWallkicks(piece, new_piece, rot_dir, grid)
    local pieces = {"I", "J", "L", "O", "S", "T", "Z"}
    repeat
        new_piece.shape = pieces[love.math.random(7)]
    until piece.shape ~= new_piece.shape

    local offsets = {{x=0, y=0}, {x=1, y=0}, {x=-1, y=0}}
    for _, o in pairs(offsets) do
        local kicked_piece = new_piece:withOffset(o)
        if (grid:canPlacePiece(kicked_piece)) then
            self:onPieceRotate(piece, grid)
            piece:setRelativeRotation(rot_dir)
            piece:setOffset(o)
            piece.shape = new_piece.shape
            return
        end
    end
end

return Trans