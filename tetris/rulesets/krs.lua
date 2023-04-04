local SRS = require 'tetris.rulesets.standard_ti'

local KRS = SRS:extend()

KRS.name = "K.R.S."
KRS.hash = "KRS"
KRS.colourscheme = {
	I = "M",
	L = "R",
	J = "C",
	S = "O",
	Z = "B",
	O = "Y",
	T = "G",
}

KRS.wallkicks_3x3 = {
    [0]={
        [1]={{-1,0},{-1,-1}},
        [2]={{0,-1},{0,-2}},
        [3]={{1,0},{1,-1}},
    },
    [1]={
        [0]={{1,0},{1,1}},
        [2]={{1,0},{1,-1}},
        [3]={{1,0},{2,0}},
    },
    [2]={
        [0]={{0,1},{0,2}},
        [1]={{-1,0},{-1,1}},
        [3]={{1,0},{1,1}},
    },
    [3]={
        [0]={{-1,0},{-1,1}},
        [1]={{-1,0},{-2,0}},
        [2]={{-1,0},{-1,-1}},
    },
}

KRS.wallkicks_line = {
    [0]={
        [1]={{-1,0},{-1,-1},{1,0},{1,1}},
        [2]={{0,-1},{0,-2}},
        [3]={{1,0},{1,-1},{-1,0},{-1,1}},
    },
    [1]={
        [0]={{1,0},{1,1},{-1,0},{-1,-1}},
        [2]={{1,0},{1,-1},{-1,0},{-1,1}},
        [3]={{2,0}},
    },
    [2]={
        [0]={{0,1},{0,2}},
        [1]={{-1,0},{-1,1},{1,0},{1,-1}},
        [3]={{1,0},{1,1},{-1,0},{-1,-1}},
    },
    [3]={
        [0]={{-1,0},{-1,1},{1,0},{1,-1}},
        [1]={{-2,0}},
        [2]={{-1,0},{-1,-1},{1,0},{1,1}},
    },
}

function KRS:onPieceCreate(piece)
    piece.das_kicked = false
    piece.recovery_frames = self.game:getLockDelay() * 15
end

function KRS:onPieceDrop() end

function KRS:onPieceMove(piece)
    while piece.lock_delay > 0 and piece.recovery_frames > 0 do
        piece.recovery_frames = piece.recovery_frames - 1
        piece.lock_delay = piece.lock_delay - 1
    end
end

function KRS:onPieceRotate(piece)
    while piece.lock_delay > 0 and piece.recovery_frames > 0 do
        piece.recovery_frames = piece.recovery_frames - 1
        piece.lock_delay = piece.lock_delay - 1
    end
end

function KRS:canPieceMove(piece) return not piece.das_kicked end
function KRS:canPieceRotate(piece) return true end

function KRS:attemptRotate(new_inputs, piece, grid, initial)
	piece.das_kicked = false
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

    if initial then
        if grid:canPlacePiece(new_piece) then
            piece:setRelativeRotation(rot_dir)
            self:onPieceRotate(piece)
        end
    else
	    self:attemptWallkicks(piece, new_piece, rot_dir, grid, new_inputs)
    end
end

function KRS:attemptWallkicks(piece, new_piece, rot_dir, grid, new_inputs)
    local kicks = (
        piece.shape == "I" and
        KRS.wallkicks_line[piece.rotation][new_piece.rotation] or
        KRS.wallkicks_3x3[piece.rotation][new_piece.rotation]
    )
    local priority = 0
    local das_charged = (
        self.game.das.frames >= self.game:getDasLimit() - self.game:getARR()
    )
    if (
        new_inputs.left or
        (self.game.das.direction == "left" and
        (das_charged or piece:isMoveBlocked(grid, {x=-1, y=0})))
    ) then
        priority = -1
    elseif (
        new_inputs.right or
        (self.game.das.direction == "right" and
        (das_charged or piece:isMoveBlocked(grid, {x=1, y=0})))
    ) then
        priority = 1
    end

    -- base rotation with offset
    if grid:canPlacePiece(new_piece:withOffset({x=priority, y=0})) then
        piece:setRelativeRotation(rot_dir)
        piece:setOffset({x=priority, y=0})
        self:onPieceRotate(piece)
        piece.das_kicked = priority ~= 0
        return
    end

    -- das kicks
    for idx, offset in pairs(kicks) do
        kicked_piece = new_piece:withOffset({x=offset[1]+priority, y=offset[2]})
        if grid:canPlacePiece(kicked_piece) then
			piece:setRelativeRotation(rot_dir)
			piece:setOffset({x=offset[1]+priority, y=offset[2]})
			self:onPieceRotate(piece)
            piece.das_kicked = priority ~= 0
			return
		end
    end

    -- base rotation
    if grid:canPlacePiece(new_piece) then
        piece:setRelativeRotation(rot_dir)
        self:onPieceRotate(piece)
        return
    end

    -- regular kicks
    for idx, offset in pairs(kicks) do
        kicked_piece = new_piece:withOffset({x=offset[1], y=offset[2]})
        if grid:canPlacePiece(kicked_piece) then
			piece:setRelativeRotation(rot_dir)
			piece:setOffset({x=offset[1], y=offset[2]})
			self:onPieceRotate(piece)
			return
		end
    end
end

function KRS:get180RotationValue() return 2 end

return KRS