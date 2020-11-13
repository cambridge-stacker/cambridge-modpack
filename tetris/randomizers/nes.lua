local Randomizer = require 'tetris.randomizers.randomizer'

local NES = Randomizer:extend()

function NES:initialize()
	self.history = 0
	self.shapes = {"I", "J", "L", "O", "S", "T", "Z"}
end

function NES:generatePiece()
	local x = math.random(8)
	if x == 8 or x == self.history then
		x = math.random(7)
	end
	self.history = x
	return self.shapes[x]
end

return NES