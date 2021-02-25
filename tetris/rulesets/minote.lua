local Ruleset = require 'tetris.rulesets.ruleset'

local Minote = Ruleset:extend()

Minote.name = "Minote"
Minote.hash = "Minote"

Minote.block_offsets = {
    J={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=-2} },
		{ {x=0, y=-1}, {x=1, y=-2}, {x=0, y=-2}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=-1, y=0} },
	},
	L={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=-2} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-2}, {x=0, y=-2}, {x=0, y=0} },
	},
	O={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
	},
    T={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=-1, y=-1}, {x=0, y=-2} },
	},
    I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
	},
    S={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=-1}, {x=1, y=0} },
	},
    Z={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
	}
}

Minote.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

Minote.big_spawn_positions = {
	I = { x=3, y=2 },
	J = { x=2, y=3 },
	L = { x=2, y=3 },
	O = { x=3, y=3 },
	S = { x=2, y=3 },
	T = { x=2, y=3 },
	Z = { x=2, y=3 },
}

function Minote:new()
    Ruleset:new()
    self.last_direction = 1 -- 1 is right, -1 is left
end

Minote.kicks = {{0,1},{1,0},{-1,0},{1,1},{-1,1}}

function Minote:attemptRotate(new_inputs, piece, grid, initial)
	-- last direction check
    if new_inputs["right"] then
        self.last_direction = 1
    elseif new_inputs["left"] then
        self.last_direction = -1
    end

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

	self:attemptWallkicks(piece, new_piece, rot_dir, grid, initial)
end

function Minote:attemptWallkicks(piece, new_piece, rot_dir, grid, initial)
    -- piece drift calculation
    local drift
    if (piece.shape == "S" or piece.shape == "Z" or piece.shape == "I") then
        if (new_piece.rotation % 2 == 0 and rot_dir == 1) then
            drift = 1
        elseif (new_piece.rotation % 2 == 1 and rot_dir == 3) then
            drift = -1
        else
            drift = 0
        end
    else
        drift = 0
    end

    -- base rotation + drift
    if grid:canPlacePiece(new_piece:withOffset({x=drift, y=0})) then
        piece:setRelativeRotation(rot_dir)
        piece:setOffset({x=drift, y=0})
        self:onPieceRotate(piece)
        return
    end
    
    -- I, IRS don't kick
    if (piece.shape == "I") or initial then return end

    -- J, L, T floorkick
    if (
        (piece.shape == "J" or piece.shape == "L" or piece.shape == "T") and
        piece.rotation == 0 and
        grid:canPlacePiece(new_piece:withOffset({x=0, y=-1}))
    ) then
        piece:setRelativeRotation(rot_dir)
        piece:setOffset({x=0, y=-1})
        self:onPieceRotate(piece)
        return
    end

    for idx, kick in pairs(Minote.kicks) do
        -- kick calculation
        offset = {
            x = kick[1] * self.last_direction + drift,
            y = kick[2]
        }

		kicked_piece = new_piece:withOffset(offset)
		if grid:canPlacePiece(kicked_piece) then
			piece:setRelativeRotation(rot_dir)
			piece:setOffset(offset)
            self:onPieceRotate(piece)
			return
		end
	end
end

function Minote:checkNewLow(piece)
    for _, block in pairs(piece:getBlockOffsets()) do
        local y = piece.position.y + block.y
        if y > piece.lowest_y then
            piece.lock_delay = 0
            piece.lowest_y = y
        end
    end
end

function Minote:onPieceCreate(piece)
    piece.lowest_y = -math.huge
end

function Minote:onPieceDrop(piece)
    self:checkNewLow(piece)
end

function Minote:onPieceRotate(piece)
    self:checkNewLow(piece)
end

function Minote:get180RotationValue() return 3 end

function Minote:getDefaultOrientation() return 3 end  -- downward facing pieces by default

return Minote