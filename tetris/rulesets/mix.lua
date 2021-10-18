local Ruleset = require 'tetris.rulesets.ruleset'

local MixRS = Ruleset:extend()

MixRS.name = "MixRS"
MixRS.hash = "MixRS"

MixRS.colourscheme = {
    [1] = "R",
	[2] = "O",
	[3] = "B",
	[4] = "M",
	[5] = "G",
	[6] = "Y",
	[7] = "C",
    [8] = "C",
	[9] = "O",
	[10] = "B",
	[11] = "G",
	[12] = "R",
	[13] = "Y",
	[14] = "M",
}

MixRS.spawn_positions = {
	[1] = { x=5, y=4 },
	[2] = { x=4, y=5 },
    [3] = { x=4, y=5 },
	[4] = { x=4, y=5 },
    [5] = { x=4, y=5 },
    [6] = { x=5, y=5 },
	[7] = { x=4, y=5 },
    [8] = { x=5, y=4 },
	[9] = { x=4, y=5 },
    [10] = { x=4, y=5 },
    [11] = { x=4, y=5 },
    [12] = { x=4, y=5 },
	[13] = { x=5, y=5 },
	[14] = { x=4, y=5 },
}

MixRS.big_spawn_positions = {
	[1] = { x=3, y=2 },
    [2] = { x=2, y=3 },
	[3] = { x=2, y=3 },
	[4] = { x=2, y=3 },
    [5] = { x=2, y=3 },
    [6] = { x=3, y=3 },
	[7] = { x=2, y=3 },
    [8] = { x=3, y=2 },
    [9] = { x=2, y=3 },
	[10] = { x=2, y=3 },
    [11] = { x=2, y=3 },
    [12] = { x=2, y=3 },
	[13] = { x=3, y=3 },
	[14] = { x=2, y=3 },
}

MixRS.next_sounds = {
    [1] = "I",
    [2] = "L",
    [3] = "J",
    [4] = "S",
    [5] = "Z",
    [6] = "O",
    [7] = "T",
    [8] = "I",
    [9] = "L",
    [10] = "J",
    [11] = "S",
    [12] = "Z",
    [13] = "O",
    [14] = "T"
}

MixRS.block_offsets = {
	[1]={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
	},
	[2]={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=1, y=-1} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-2}, {x=0, y=-2}, {x=0, y=0} },
	},
    [3]={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=-1} },
		{ {x=0, y=-1}, {x=1, y=-2}, {x=0, y=-2}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=-1, y=0} },
	},
	[4]={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=-1, y=-2}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=-1, y=-2}, {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0} },
	},
    [5]={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
	},
    [6]={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
	},
	[7]={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=-1, y=-1}, {x=0, y=-2} },
	},
	[8]={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=0, y=2} },
		{ {x=0, y=1}, {x=-1, y=1}, {x=-2, y=1}, {x=1, y=1} },
		{ {x=-1, y=0}, {x=-1, y=-1}, {x=-1, y=1}, {x=-1, y=2} },
	},
	[9]={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=1, y=-1} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=1, y=1} },
		{ {x=0, y=0}, {x=1, y=0}, {x=-1, y=0}, {x=-1, y=1} },
		{ {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=-1, y=-1} },
	},
    [10]={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=-1, y=-1} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1} , {x=1, y=-1} },
		{ {x=0, y=0}, {x=1, y=0}, {x=-1, y=0}, {x=1, y=1} },
		{ {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=-1, y=1} },
	},
	[11]={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=1, y=1}, {x=1, y=0}, {x=0, y=0}, {x=0, y=-1} },
		{ {x=-1, y=1}, {x=0, y=1}, {x=0, y=0}, {x=1, y=0} },
		{ {x=-1, y=-1}, {x=-1, y=0}, {x=0, y=0}, {x=0, y=1} },
	},
    [12]={
		{ {x=-1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=1, y=0} },
		{ {x=1, y=-1}, {x=1, y=0}, {x=0, y=0}, {x=0, y=1} },
		{ {x=1, y=1}, {x=0, y=1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=-1, y=1}, {x=-1, y=0}, {x=0, y=0}, {x=0, y=-1} },
	},
    [13]={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
	},
	[14]={
		{ {x=0, y=0}, {x=-1, y=0}, {x=1, y=0}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=0, y=-1}, {x=0, y=1}, {x=1, y=0} },
		{ {x=0, y=0}, {x=1, y=0}, {x=-1, y=0}, {x=0, y=1} },
		{ {x=0, y=0}, {x=0, y=1}, {x=0, y=-1}, {x=-1, y=0} },
	}
}

MixRS.wallkicks_cw = {{x=1, y=0}, {x=-1, y=0}, {x=0, y=1}, {x=1, y=1}, {x=-1, y=1}}
MixRS.wallkicks_ccw = {{x=-1, y=0}, {x=1, y=0}, {x=0, y=1}, {x=-1, y=1}, {x=1, y=1}}

function MixRS:ARS(piece, new_piece, rot_dir, grid)
	
	local kicks
	if piece.shape == 6 then
		return
	elseif rot_dir == 1 then
		kicks = MixRS.wallkicks_cw
	else
		kicks = MixRS.wallkicks_ccw
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

    if (
        piece.shape == 1 and
        piece:isDropBlocked(grid) and
        new_piece.rotation % 2 == 1 and
        not piece.floorkicked
    ) then
		if grid:canPlacePiece(new_piece:withOffset({x=0, y=-1})) then
			piece:setRelativeRotation(rot_dir):setOffset({x=0, y=-1})
			piece.floorkicked = true
			self:onPieceRotate(piece, grid)
		elseif grid:canPlacePiece(new_piece:withOffset({x=0, y=-2})) then
			piece:setRelativeRotation(rot_dir):setOffset({x=0, y=-2})
			piece.floorkicked = true
			self:onPieceRotate(piece, grid)
		end
    elseif (
        piece.shape == 7
		and new_piece.rotation == 0
	    and not piece.floorkicked
		and piece:isDropBlocked(grid)
		and grid:canPlacePiece(new_piece:withOffset({x=0, y=-1}))
    ) then
		piece.floorkicked = true
		piece:setRelativeRotation(rot_dir):setOffset({x=0, y=-1})
		self:onPieceRotate(piece, grid)
	end

end

MixRS.wallkicks_3x3 = {
	[0]={
		[1]={{x=-1, y=0}, {x=-1, y=-1}, {x=0, y=2}, {x=-1, y=2}},
		[2]={{x=1,y=0},{x=2,y=0},{x=1,y=1},{x=2,y=1},{x=-1,y=0},{x=-2,y=0},{x=-1,y=1},{x=-2,y=1},{x=0,y=-1},{x=3,y=0},{x=-3,y=0}},
		[3]={{x=1, y=0}, {x=1, y=-1}, {x=0, y=2}, {x=1, y=2}},
	},
	[1]={
		[0]={{x=1, y=0}, {x=1, y=1}, {x=0, y=-2}, {x=1, y=-2}},
		[2]={{x=1, y=0}, {x=1, y=1}, {x=0, y=-2}, {x=1, y=-2}},
		[3]={{x=0,y=1},{x=0,y=2},{x=-1,y=1},{x=-1,y=2},{x=0,y=-1},{x=0,y=-2},{x=-1,y=-1},{x=-1,y=-2},{x=1,y=0},{x=0,y=3},{x=0,y=-3}},
	},
	[2]={
		[0]={{x=-1,y=0},{x=-2,y=0},{x=-1,y=-1},{x=-2,y=-1},{x=1,y=0},{x=2,y=0},{x=1,y=-1},{x=2,y=-1},{x=0,y=1},{x=-3,y=0},{x=3,y=0}},
		[1]={{x=-1, y=0}, {x=-1, y=-1}, {x=0, y=2}, {x=-1, y=2}},
		[3]={{x=1, y=0}, {x=1, y=-1}, {x=0, y=2}, {x=1, y=2}},
	},
	[3]={
		[0]={{x=-1, y=0}, {x=-1, y=1}, {x=0, y=-2}, {x=-1, y=-2}},
		[1]={{x=0,y=1},{x=0,y=2},{x=1,y=1},{x=1,y=2},{x=0,y=-1},{x=0,y=-2},{x=1,y=-1},{x=1,y=-2},{x=-1,y=0},{x=0,y=3},{x=0,y=-3}},
		[2]={{x=-1, y=0}, {x=-1, y=1}, {x=0, y=-2}, {x=-1, y=-2}},
	},
}

MixRS.wallkicks_line = {
	[0]={
		[1]={{x=-2, y= 0}, {x= 1, y= 0}, {x= 1, y=-2}, {x=-2, y= 1}},
		[2]={{x=-1,y=0},{x=-2,y=0},{x=1,y=0},{x=2,y=0},{x=0,y=1}},
		[3]={{x= 2, y= 0}, {x=-1, y= 0}, {x=-1, y=-2}, {x= 2, y= 1}},
	},
	[1]={
		[0]={{x= 2, y= 0}, {x=-1, y= 0}, {x= 2, y=-1}, {x=-1, y= 2}},
		[2]={{x=-1, y= 0}, {x= 2, y= 0}, {x=-1, y=-2}, {x= 2, y= 1}},
		[3]={{x=0,y=1},{x=0,y=2},{x=0,y=-1},{x=0,y=-2},{x=-1,y=0}},
	},
	[2]={
		[0]={{x=1,y=0},{x=2,y=0},{x=-1,y=0},{x=-2,y=0},{x=0,y=-1}},
		[1]={{x=-2, y= 0}, {x= 1, y= 0}, {x=-2, y=-1}, {x= 1, y= 1}},
		[3]={{x= 2, y= 0}, {x=-1, y= 0}, {x= 2, y=-1}, {x=-1, y= 1}},
	},
	[3]={
		[0]={{x=-2, y= 0}, {x= 1, y= 0}, {x=-2, y=-1}, {x= 1, y= 2}},
		[1]={{x=0,y=1},{x=0,y=2},{x=0,y=-1},{x=0,y=-2},{x=1,y=0}},
		[2]={{x= 1, y= 0}, {x=-2, y= 0}, {x= 1, y=-2}, {x=-2, y= 1}},
	},
}

function MixRS:SRS(piece, new_piece, rot_dir, grid)

	local kicks
	if piece.shape == 13 then
		return
	elseif piece.shape == 8 then
		kicks = MixRS.wallkicks_line[piece.rotation][new_piece.rotation]
	else
		kicks = MixRS.wallkicks_3x3[piece.rotation][new_piece.rotation]
	end

	for idx, offset in pairs(kicks) do
		kicked_piece = new_piece:withOffset(offset)
		if grid:canPlacePiece(kicked_piece) then
			piece:setRelativeRotation(rot_dir)
			piece:setOffset(offset)
			self:onPieceRotate(piece, grid, offset.y < 0)
			return
		end
	end

end

function MixRS:attemptWallkicks(piece, new_piece, rot_dir, grid)
    if piece.shape >= 8 then
        self:SRS(piece, new_piece, rot_dir, grid)
    else
        self:ARS(piece, new_piece, rot_dir, grid)
    end
end

function MixRS:onPieceDrop(piece) piece.lock_delay = 0 end
function MixRS:onPieceMove(piece)
    if piece.shape >= 8 then
        piece.lock_delay = 0
    end
end
function MixRS:onPieceRotate(piece)
    if piece.shape >= 8 then
        piece.lock_delay = 0
    end
end

function MixRS:getDefaultOrientation(shape)
    if shape >= 8 then
        return 1
    else
        return 3
    end
end

return MixRS