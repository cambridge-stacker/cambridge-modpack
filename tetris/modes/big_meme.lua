require 'funcs'

local SurvivalA3Game = require 'tetris.modes.survival_a3'

local BigMemeGame = SurvivalA3Game:extend()

BigMemeGame.name = "Big Survival A3"
BigMemeGame.hash = "BigA3"
BigMemeGame.description = "The blocks are bigger and the speeds are faster!"

function BigMemeGame:new()
	BigMemeGame.super:new()
	self.big_mode = true
	local getClearedRowCount = self.grid.getClearedRowCount
	self.grid.getClearedRowCount = function(self)
		return getClearedRowCount(self) / 2
	end
end

return BigMemeGame