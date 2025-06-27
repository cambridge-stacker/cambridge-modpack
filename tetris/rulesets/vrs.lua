local Ruleset = require "tetris.rulesets.ruleset"

local VRS = Ruleset:extend()

VRS.name = "V.R.S."
VRS.hash = "VRS"
VRS.description = "A fairly balanced rotation system by Oshisaure."

VRS.world = true
VRS.colourscheme = {
	I = "M",
	L = "R",
	J = "C",
	S = "Y",
	Z = "B",
	O = "O",
	T = "G",
}

VRS.enable_IRS_wallkicks = true
VRS.spawn_above_field = true

VRS.spawn_positions = {
	I = { x=4, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=4, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

VRS.big_spawn_positions = {
	I = { x=2, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=2, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

VRS.block_offsets = {
	I = {
		{{x=1, y=0}, {x=0, y=0}, {x=-1, y=0}, {x=2, y=0}},
		{{x=1, y=-2}, {x=1, y=-1}, {x=1, y=0}, {x=1, y=1}},
		{{x=1, y=0}, {x=0, y=0}, {x=-1, y=0}, {x=2, y=0}},
		{{x=1, y=-2}, {x=1, y=-1}, {x=1, y=0}, {x=1, y=1}}
	},
	S = {
		{{x=-1, y=0}, {x=0, y=0}, {x=0, y=-1}, {x=1, y=-1}},
		{{x=0, y=-1}, {x=0, y=0}, {x=1, y=0}, {x=1, y=1}},
		{{x=-1, y=0}, {x=0, y=0}, {x=0, y=-1}, {x=1, y=-1}},
		{{x=0, y=-1}, {x=0, y=0}, {x=1, y=0}, {x=1, y=1}}
	},
	Z = {
		{{x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=1, y=0}},
		{{x=1, y=-1}, {x=1, y=0}, {x=0, y=0}, {x=0, y=1}},
		{{x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=1, y=0}},
		{{x=1, y=-1}, {x=1, y=0}, {x=0, y=0}, {x=0, y=1}}
	},
	T = {
		{{x=1, y=0}, {x=0, y=0}, {x=-1, y=0}, {x=0, y=-1}},
		{{x=0, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=1, y=0}},
		{{x=1, y=0}, {x=0, y=0}, {x=-1, y=0}, {x=0, y=1}},
		{{x=0, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=-1, y=0}}
	},
	J = {
		{{x=1, y=0}, {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}},
		{{x=0, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=1, y=-1}},
		{{x=1, y=0}, {x=0, y=0}, {x=-1, y=0}, {x=1, y=1}},
		{{x=0, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=-1, y=1}}
	},
	L = {
		{{x=1, y=0}, {x=0, y=0}, {x=-1, y=0}, {x=1, y=-1}},
		{{x=0, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=1, y=1}},
		{{x=1, y=0}, {x=0, y=0}, {x=-1, y=0}, {x=-1, y=1}},
		{{x=0, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=-1, y=-1}}
	},
	O = {
		{{x=0, y=0}, {x=1, y=0}, {x=1, y=-1}, {x=0, y=-1}},
		{{x=0, y=0}, {x=1, y=0}, {x=1, y=-1}, {x=0, y=-1}},
		{{x=0, y=0}, {x=1, y=0}, {x=1, y=-1}, {x=0, y=-1}},
		{{x=0, y=0}, {x=1, y=0}, {x=1, y=-1}, {x=0, y=-1}}
	},
}

VRS.kicks_ccw = {
	I = {
		[0] = {{x=-1, y=0}, {x=-1, y=1}, {x=-2, y=0}, {x=-2, y=1}, {x=-1, y=-1}, {x=-2, y=-1}, {x=-1, y=2}, {x=-2, y=2}, {x=0, y=0}, {x=0, y=1}, {x=1, y=0}, {x=1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=0, y=2}, {x=1, y=2}},
		{{x=0, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=0, y=-2}, {x=-1, y=-2}, {x=1, y=0}, {x=1, y=1}, {x=2, y=0}, {x=2, y=1}, {x=1, y=-1}, {x=2, y=-1}, {x=1, y=-2}, {x=2, y=-2}},
		{{x=-1, y=0}, {x=-1, y=1}, {x=-2, y=0}, {x=-2, y=1}, {x=-1, y=-1}, {x=-2, y=-1}, {x=-1, y=2}, {x=-2, y=2}, {x=0, y=0}, {x=0, y=1}, {x=1, y=0}, {x=1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=0, y=2}, {x=1, y=2}},
		{{x=0, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=0, y=-2}, {x=-1, y=-2}, {x=1, y=0}, {x=1, y=1}, {x=2, y=0}, {x=2, y=1}, {x=1, y=-1}, {x=2, y=-1}, {x=1, y=-2}, {x=2, y=-2}},
	},
	
	TLJ = {
		[0] = {{x=0, y=0}, {x=0, y=1}, {x=1, y=0}, {x=1, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
		{{x=0, y=0}, {x=0, y=1}, {x=1, y=0}, {x=1, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
		{{x=0, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=1, y=0}, {x=1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
		{{x=0, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=1, y=0}, {x=1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
	},
	
	SZ = {
		[0] = {{x=-1, y=0}, {x=-1, y=1}, {x=-2, y=0}, {x=-2, y=1}, {x=-1, y=-1}, {x=-2, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=-1, y=2}, {x=-1, y=-2}},
		{{x=0, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=1, y=1}, {x=1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
		{{x=-1, y=0}, {x=-1, y=1}, {x=-2, y=0}, {x=-2, y=1}, {x=-1, y=-1}, {x=-2, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=-1, y=2}, {x=-1, y=-2}},
		{{x=0, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=1, y=1}, {x=1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
	},
	
	O = {
		-- lol
		[0] = {{x=0, y=0}},
		{{x=0, y=0}},
		{{x=0, y=0}},
		{{x=0, y=0}},
	},
}

VRS.kicks_cw = {
	I = {
		[0] = {{x=0, y=0}, {x=0, y=1}, {x=1, y=0}, {x=1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=0, y=2}, {x=1, y=2}, {x=-1, y=0}, {x=-1, y=1}, {x=-2, y=0}, {x=-2, y=1}, {x=-1, y=-1}, {x=-2, y=-1}, {x=-1, y=2}, {x=-2, y=2}},
		{{x=1, y=0}, {x=1, y=1}, {x=2, y=0}, {x=2, y=1}, {x=1, y=-1}, {x=2, y=-1}, {x=1, y=-2}, {x=2, y=-2}, {x=0, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=0, y=-2}, {x=-1, y=-2}},
		{{x=0, y=0}, {x=0, y=1}, {x=1, y=0}, {x=1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=0, y=2}, {x=1, y=2}, {x=-1, y=0}, {x=-1, y=1}, {x=-2, y=0}, {x=-2, y=1}, {x=-1, y=-1}, {x=-2, y=-1}, {x=-1, y=2}, {x=-2, y=2}},
		{{x=1, y=0}, {x=1, y=1}, {x=2, y=0}, {x=2, y=1}, {x=1, y=-1}, {x=2, y=-1}, {x=1, y=-2}, {x=2, y=-2}, {x=0, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=0, y=-2}, {x=-1, y=-2}},
	},
	
	TLJ = {
		[0] = {{x=0, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=1, y=0}, {x=1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
		{{x=0, y=0}, {x=0, y=1}, {x=1, y=0}, {x=1, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
		{{x=0, y=0}, {x=0, y=1}, {x=1, y=0}, {x=1, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
		{{x=0, y=0}, {x=0, y=1}, {x=-1, y=0}, {x=-1, y=1}, {x=1, y=0}, {x=1, y=1}, {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
	},
	
	SZ = {
		[0] = {{x=0, y=0}, {x=0, y=1}, {x=1, y=0}, {x=1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=0}, {x=-1, y=1}, {x=-1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
		{{x=1, y=0}, {x=1, y=1}, {x=2, y=0}, {x=2, y=1}, {x=1, y=-1}, {x=2, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=1, y=2}, {x=1, y=-2}},
		{{x=0, y=0}, {x=0, y=1}, {x=1, y=0}, {x=1, y=1}, {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=0}, {x=-1, y=1}, {x=-1, y=-1}, {x=0, y=2}, {x=0, y=-2}},
		{{x=1, y=0}, {x=1, y=1}, {x=2, y=0}, {x=2, y=1}, {x=1, y=-1}, {x=2, y=-1}, {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=1, y=2}, {x=1, y=-2}},
	},
	
	O = {
		-- lol
		[0] = {{x=0, y=0}},
		{{x=0, y=0}},
		{{x=0, y=0}},
		{{x=0, y=0}},
	},
}

function VRS:attemptRotate(new_inputs, piece, grid, initial)
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
	self:attemptWallkicks(piece, new_piece, rot_dir, grid)
end

function VRS:attemptWallkicks(piece, new_piece, rot_dir, grid)
    local kicks
    if rot_dir == 1 then
        if piece.shape == "I" then
            kicks = VRS.kicks_cw.I[piece.rotation]
        elseif (
            piece.shape == "T" or
            piece.shape == "L" or
            piece.shape == "J"
        ) then
            kicks = VRS.kicks_cw.TLJ[piece.rotation]
        elseif (
            piece.shape == "S" or
            piece.shape == "Z"
        ) then
            kicks = VRS.kicks_cw.SZ[piece.rotation]
        else
            kicks = VRS.kicks_cw.O[piece.rotation]
        end
    else
        if piece.shape == "I" then
            kicks = VRS.kicks_ccw.I[piece.rotation]
        elseif (
            piece.shape == "T" or
            piece.shape == "L" or
            piece.shape == "J"
        ) then
            kicks = VRS.kicks_ccw.TLJ[piece.rotation]
        elseif (
            piece.shape == "S" or
            piece.shape == "Z"
        ) then
            kicks = VRS.kicks_ccw.SZ[piece.rotation]
        else
            kicks = VRS.kicks_ccw.O[piece.rotation]
        end
    end

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

function VRS:onPieceCreate(piece)
    piece.rotate_counter = 0
end

function VRS:onPieceDrop(piece)
	piece.lock_delay = 0 -- step reset
end

function VRS:onPieceRotate(piece)
    piece.rotate_counter = piece.rotate_counter + 1
    piece.lock_delay = 0
end

function VRS:canPieceRotate(piece)
    return piece.rotate_counter < 15
end

function VRS:get180RotationValue() return 3 end

return VRS