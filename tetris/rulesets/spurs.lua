local SRS = require 'tetris.rulesets.arika_srs'

local SPURS = SRS:extend()

SPURS.name = "SPURS"
SPURS.hash = "SPURS"

SPURS.softdrop_lock = true
SPURS.harddrop_lock = false

SPURS.MANIPULATIONS_MAX = 30
SPURS.ROTATIONS_MAX = 18

SPURS.wallkicks_3x3_neutral = {
	[0] = {
		[1] = {
			{x= 0, y= 1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x= 0, y=-1},
			{x= 1, y=-1},
			{x=-1, y=-1}
		},
		[2] = {
			{x=-1, y= 0},
			{x= 1, y= 0},
			{x=-1, y=-1},
			{x= 1, y=-1},
			{x= 0, y=-1}
		},
		[3] = {
			{x= 0, y= 1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 0, y=-1},
			{x=-1, y=-1},
			{x= 1, y=-1}
		},
	},
	[1] = {
		[0] = {
			{x= 0, y= 1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 0, y=-1},
			{x=-1, y=-1},
			{x= 1, y=-1}
		},
		[2] = {
			{x= 0, y= 1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x= 0, y=-1},
			{x= 1, y=-1},
			{x=-1, y=-1}
		},
		[3] = {
			{x= 0, y= 1},
			{x= 1, y= 0},
			{x= 0, y=-1},
			{x= 1, y=-1}
		},
	},
	[2] = {
		[0] = {
			{x= 1, y= 0},
			{x=-1, y= 0},
			{x= 1, y= 1},
			{x=-1, y= 1},
			{x= 0, y= 1}
		},
		[1] = {
			{x= 0, y= 1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 0, y=-1},
			{x=-1, y=-1},
			{x= 1, y=-1}
		},
		[3] = {
			{x= 0, y= 1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x= 0, y=-1},
			{x= 1, y=-1},
			{x=-1, y=-1}
		},
	},
	[3] = {
		[0] = {
			{x= 0, y= 1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x= 0, y=-1},
			{x= 1, y=-1},
			{x=-1, y=-1}
		},
		[1] = {
			{x= 0, y= 1},
			{x=-1, y= 0},
			{x= 0, y=-1},
			{x=-1, y=-1}
		},
		[2] = {
			{x= 0, y= 1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 0, y=-1},
			{x=-1, y=-1},
			{x= 1, y=-1}
		},
	},
};

SPURS.wallkicks_3x3_right = {
	[0] = {
		[1] = {
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1}
		},
		[2] = {
			{x= 1, y= 0},
			{x= 1, y=-1},
			{x= 0, y=-1},
			{x=-1, y= 0},
			{x=-1, y=-1}
		},
		[3] = {
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1}
		},
	},
	[1] = {
		[0] = {
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1}
		},
		[2] = {
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1}
		},
		[3] = {
			{x= 1, y= 0},
			{x= 1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1}
		},
	},
	[2] = {
		[0] = {
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 0, y= 1},
			{x=-1, y= 0},
			{x=-1, y= 1}
		},
		[1] = {
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1}
		},
		[3] = {
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1}
		},
	},
	[3] = {
		[0] = {
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1}
		},
		[1] = {
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x=-1, y= 0},
			{x=-1, y=-1}
		},
		[2] = {
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1}
		},
	},
};

SPURS.wallkicks_3x3_left = {
	[0] = {
		[1] = {
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1}
		},
		[2] = {
			{x=-1, y= 0},
			{x=-1, y=-1},
			{x= 0, y=-1},
			{x= 1, y= 0},
			{x= 1, y=-1}
		},
		[3] = {
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1}
		},
	},
	[1] = {
		[0] = {
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1}
		},
		[2] = {
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1}
		},
		[3] = {
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 1, y= 0},
			{x= 1, y=-1}
		},
	},
	[2] = {
		[0] = {
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x= 0, y= 1},
			{x= 1, y= 0},
			{x= 1, y= 1}
		},
		[1] = {
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1}
		},
		[3] = {
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1}
		},
	},
	[3] = {
		[0] = {
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1}
		},
		[1] = {
			{x=-1, y= 0},
			{x=-1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1}
		},
		[2] = {
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1},
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1}
		},
	},
};

SPURS.wallkicks_line = {
	[0] = {
		[1] = {
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 0, y= 2},
			{x= 0, y=-2},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 1, y= 2},
			{x= 1, y=-2}
},
		[2] = {
			{x=-1, y= 0},
			{x= 1, y= 0},
			{x=-2, y= 0},
			{x= 2, y= 0},
			{x= 0, y=-1},
			{x=-1, y=-1},
			{x= 1, y=-1},
			{x=-2, y=-1},
			{x= 2, y=-1}
		},
		[3] = {
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 0, y= 2},
			{x= 0, y=-2},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1},
			{x=-1, y= 2},
			{x=-1, y=-2}
},
	},
	[1] = {
		[0] = {
			{x=-1, y= 0},
			{x= 1, y= 0},
			{x=-2, y= 0},
			{x= 2, y= 0},
			{x= 0, y=-1},
			{x=-1, y=-1},
			{x= 1, y=-1},
			{x=-2, y=-1},
			{x= 2, y=-1}
		},
		[2] = {
			{x= 1, y= 0},
			{x=-1, y= 0},
			{x= 2, y= 0},
			{x=-2, y= 0},
			{x= 0, y= 1},
			{x= 1, y= 1},
			{x=-1, y= 1},
			{x= 2, y= 1},
			{x=-2, y= 1}
		},
		[3] = {
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 0, y= 2},
			{x= 0, y=-2},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 1, y= 2},
			{x= 1, y=-2}
},
		
	},
	[2] = {
		[0] = {
			{x= 1, y= 0},
			{x=-1, y= 0},
			{x= 2, y= 0},
			{x=-2, y= 0},
			{x= 0, y= 1},
			{x= 1, y= 1},
			{x=-1, y= 1},
			{x= 2, y= 1},
			{x=-2, y= 1}
		},
		[1] = {
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 0, y= 2},
			{x= 0, y=-2},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 1, y= 2},
			{x= 1, y=-2}
},
		[3] = {
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 0, y= 2},
			{x= 0, y=-2},
			{x=-1, y= 0},
			{x=-1, y= 1},
			{x=-1, y=-1},
			{x=-1, y= 2},
			{x=-1, y=-2}
},
	},
	[3] = {
		[0] = {
			{x=-1, y= 0},
			{x= 1, y= 0},
			{x=-2, y= 0},
			{x= 2, y= 0},
			{x= 0, y=-1},
			{x=-1, y=-1},
			{x= 1, y=-1},
			{x=-2, y=-1},
			{x= 2, y=-1}
		},
		[1] = {
			{x= 0, y= 1},
			{x= 0, y=-1},
			{x= 0, y= 2},
			{x= 0, y=-2},
			{x= 1, y= 0},
			{x= 1, y= 1},
			{x= 1, y=-1},
			{x= 1, y= 2},
			{x= 1, y=-2}
},
		[2] = {
			{x= 1, y= 0},
			{x=-1, y= 0},
			{x= 2, y= 0},
			{x=-2, y= 0},
			{x= 0, y= 1},
			{x= 1, y= 1},
			{x=-1, y= 1},
			{x= 2, y= 1},
			{x=-2, y= 1}
		},
	},
};

function SPURS:attemptWallkicks(piece, new_piece, rot_dir, grid)
	local kicks
	local tableflipper
	if piece.shape == "O" then
		return
	elseif piece.shape == "I" then
		kicks = SPURS.wallkicks_line[piece.rotation][new_piece.rotation]
	else
		if self.game.das.direction == "left" and (
			self.game.das.frames >= self.game:getDasLimit() - self.game:getARR() or
			piece:isMoveBlocked(grid, {x=-1, y=0})
		) then
			kicks = SPURS.wallkicks_3x3_left[piece.rotation][new_piece.rotation]
		elseif self.game.das.direction == "right" and (
			self.game.das.frames >= self.game:getDasLimit() - self.game:getARR() or
			piece:isMoveBlocked(grid, {x=1, y=0})
		) then
			kicks = SPURS.wallkicks_3x3_right[piece.rotation][new_piece.rotation]
		else
			kicks = SPURS.wallkicks_3x3_neutral[piece.rotation][new_piece.rotation]
		end
	end


	assert(piece.rotation ~= new_piece.rotation)
	
	for idx, offset in pairs(kicks) do
	
	
		kicked_piece = new_piece:withOffset(offset)
		if grid:canPlacePiece(kicked_piece) then
			self:onPieceRotate(piece, grid)
			piece:setRelativeRotation(rot_dir)
			piece:setOffset(offset)
			return
		end
	end
end

function SPURS:onPieceMove(piece, grid)
	if piece.manipulations < self.MANIPULATIONS_MAX then
		piece.lock_delay = 0 -- move reset
		if piece:isDropBlocked(grid) then
			piece.manipulations = piece.manipulations + 1
		end
	end
end

function SPURS:onPieceRotate(piece, grid, upward)
	if piece.rotations < self.ROTATIONS_MAX then
		piece.lock_delay = 0 -- rotate reset
		if upward or piece:isDropBlocked(grid) then
			piece.rotations = piece.rotations + 1
			if upward then
				piece.rotations = piece.rotations + 1
				piece.manipulations = piece.manipulations + 1
			end
		end
	end
end

function SPURS:get180RotationValue() return 2 end

return SPURS