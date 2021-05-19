local SRS = require 'tetris.rulesets.standard'

local kon = SRS:extend()

kon.name = "kon"
kon.hash = "kon"

kon.colourscheme = {
	I = "M",
	L = "R",
	J = "C",
	S = "Y",
	Z = "B",
	O = "O",
	T = "G",
}

kon.kicks_cw = { -- also 180
    {x=0, y=0}, {x=1, y=0}, {x=-1, y=0},
    {x=0, y=1}, {x=1, y=1}, {x=-1, y=1},
    {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1},
    {x=0, y=2}, {x=0, y=-2},
}

kon.kicks_ccw = {
    {x=0, y=0}, {x=-1, y=0}, {x=1, y=0},
    {x=0, y=1}, {x=-1, y=1}, {x=1, y=1},
    {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1},
    {x=0, y=2}, {x=0, y=-2},
}

kon.kicks_I_cw = {}
kon.kicks_I_ccw = {}

for _, y in pairs({0, 2, 1, -1, -2}) do
    for _, x in pairs({0, 1, -1, 2, -2}) do
        table.insert(kon.kicks_I_cw, {x=x, y=y})
        table.insert(kon.kicks_I_ccw, {x=-x, y=y})
    end
end

kon.corners_I = {
    [0] = {
        {x=0, y=-1}, {x=-1, y=-1}, {x=-2, y=-1}, {x=1, y=-1}, {x=2, y=0},
        {x=0, y=1}, {x=-1, y=1}, {x=-2, y=1}, {x=1, y=1}, {x=-3, y=0},
    },
    [1] = {
        {x=1, y=0}, {x=1, y=-1}, {x=1, y=1}, {x=1, y=2}, {x=0, y=-2},
        {x=-1, y=0}, {x=-1, y=-1}, {x=-1, y=1}, {x=-1, y=2}, {x=0, y=3},
    },
    [2] = {
        {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0}, {x=2, y=1},
        {x=0, y=2}, {x=-1, y=2}, {x=-2, y=2}, {x=1, y=2}, {x=-3, y=1},
    },
    [3] = {
        {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2}, {x=-1, y=-2},
        {x=-2, y=0}, {x=-2, y=-1}, {x=-2, y=1}, {x=-2, y=2}, {x=-1, y=3},
    }
}

kon.corners_O = {
    {x=0, y=1}, {x=-1, y=1},
    {x=-2, y=0}, {x=-2, y=-1},
    {x=-1, y=-2}, {x=0, y=-2},
    {x=1, y=-1}, {x=1, y=0},
}

kon.corners_3x3 = {
    L = {
        [0] = {
            {x=-2, y=0}, {x=-1, y=1}, {x=-1, y=-1}, {x=0, y=1}, {x=0, y=-1},
            {x=1, y=1}, {x=1, y=-2}, {x=2, y=0}, {x=2, y=-1},
        }
    },
    Z = {
        [0] = {
            {x=-2, y=-1}, {x=-1, y=-2}, {x=-1, y=0}, {x=0, y=-2},
            {x=0, y=1}, {x=1, y=-1}, {x=1, y=1}, {x=2, y=0},
        }
    },
    T = {
        [0] = {
            {x=-2, y=0}, {x=-1, y=-1}, {x=-1, y=1}, {x=0, y=-2},
            {x=0, y=1}, {x=1, y=-1}, {x=1, y=1}, {x=2, y=0},
        }
    },
    S = {
        [0] = {
            {x=-2, y=0}, {x=-1, y=-1}, {x=-1, y=1}, {x=0, y=-2},
            {x=0, y=1}, {x=1, y=-2}, {x=1, y=0}, {x=2, y=-1},
        }
    },
    J = {
        [0] = {
            {x=-2, y=-1}, {x=-2, y=0}, {x=-1, y=-2}, {x=-1, y=1}, {x=0, y=-1},
            {x=0, y=1}, {x=1, y=-1}, {x=1, y=1}, {x=2, y=0},
        }
    }
}

for piece, _ in pairs(kon.corners_3x3) do
    for i = 1, 3 do
        kon.corners_3x3[piece][i] = {}
        for _, corner in pairs(kon.corners_3x3[piece][i - 1]) do
            table.insert(
                kon.corners_3x3[piece][i],
                {x=-corner.y, y=corner.x}
            )
        end
    end
end

function kon:attemptRotate(new_inputs, piece, grid, initial)
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

	if (grid:canPlacePiece(new_piece)) then
		if piece:isDropBlocked(grid) then
			self:attemptWallkicks(piece, new_piece, rot_dir, grid)
		else
			piece:setRelativeRotation(rot_dir)
			self:onPieceRotate(piece, grid)
		end
	else
		if not(initial and self.enable_IRS_wallkicks == false) then
			self:attemptWallkicks(piece, new_piece, rot_dir, grid)
		end
	end
end

function kon:attemptWallkicks(piece, new_piece, rot_dir, grid)
    local kicks
    if rot_dir == 3 then
        kicks = piece.shape == "I" and kon.kicks_I_ccw or kon.kicks_ccw
    else
        kicks = piece.shape == "I" and kon.kicks_I_cw or kon.kicks_cw
    end

    local corners
    if piece.shape == "I" then
        corners = kon.corners_I[new_piece.rotation]
    elseif piece.shape == "O" then
        corners = kon.corners_O
    else
        corners = kon.corners_3x3[piece.shape][new_piece.rotation]
    end

    local chosen_kick
    local greatest_corners = -1
    for _, offset in pairs(kicks) do
        kicked_piece = new_piece:withOffset(offset)
        if grid:canPlacePiece(kicked_piece) then
            local occupied_corners = 0
            for _, corner in pairs(corners) do
                if grid:isOccupied(
                    kicked_piece.position.x + corner.x,
                    kicked_piece.position.y + corner.y
                ) then
                    occupied_corners = occupied_corners + 1
                end
            end
            if occupied_corners > greatest_corners then
                greatest_corners = occupied_corners
                chosen_kick = offset
            end
        end
    end

    if chosen_kick then
        piece:setRelativeRotation(rot_dir)
        piece:setOffset(chosen_kick)
        self:onPieceRotate(piece, grid)
    end
end

return kon