local Ruleset = require 'tetris.rulesets.ruleset'

local Nintendo = Ruleset:extend()

Nintendo.name = "Nintendo-R"
Nintendo.hash = "NintendoR"

Nintendo.spawn_positions = {
	I = { x=5, y=4 },
	J = { x=4, y=5 },
	L = { x=4, y=5 },
	O = { x=5, y=5 },
	S = { x=4, y=5 },
	T = { x=4, y=5 },
	Z = { x=4, y=5 },
}

Nintendo.block_offsets = {
	I={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=0, y=1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-2, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=0, y=1} },
	},
	J={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=-1, y=-2} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0} , {x=1, y=-2} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=0, y=-2}, {x=-1, y=0} },
	},
	L={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=1, y=-2} },
		{ {x=0, y=-1}, {x=0, y=-2}, {x=0, y=0}, {x=1, y=0} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=-1, y=0} },
		{ {x=0, y=0}, {x=-1, y=-2}, {x=0, y=-2}, {x=0, y=-1} },
	},
	O={
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
		{ {x=0, y=0}, {x=-1, y=0}, {x=-1, y=-1}, {x=0, y=-1} },
	},
	S={
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=-1}, {x=1, y=0} },
		{ {x=1, y=-1}, {x=0, y=-1}, {x=0, y=0}, {x=-1, y=0} },
		{ {x=0, y=-2}, {x=0, y=-1}, {x=1, y=-1}, {x=1, y=0} },
	},
	T={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=-1}, {x=0, y=-2} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=0, y=-2}, {x=1, y=-1} },
		{ {x=0, y=-1}, {x=1, y=-1}, {x=-1, y=-1}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=0, y=-2}, {x=-1, y=-1} },
	},
	Z={
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
		{ {x=0, y=-1}, {x=-1, y=-1}, {x=1, y=0}, {x=0, y=0} },
		{ {x=0, y=-1}, {x=0, y=0}, {x=1, y=-2}, {x=1, y=-1} },
	}
}

function Nintendo:onPieceDrop(piece)
	piece.lock_delay = 0
end

function Nintendo:get180RotationValue() 
	if config.gamesettings.world_reverse == 3 then
		return 1
	else
		return 3
	end
end

function Nintendo:getDefaultOrientation() return 3 end  -- downward facing pieces by default

return Nintendo
