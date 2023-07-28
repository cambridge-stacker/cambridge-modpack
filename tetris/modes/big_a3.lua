require 'funcs'

local MarathonA3Game = require 'tetris.modes.marathon_a3'

local BigA3Game = MarathonA3Game:extend()

BigA3Game.name = "Big A3"
BigA3Game.hash = "BigA3-2"
BigA3Game.tagline = "placeholder text"

function BigA3Game:new()
	BigA3Game.super:new()
	self.big_mode = true
	local getClearedRowCount = self.grid.getClearedRowCount
	self.grid.getClearedRowCount = function(self)
		return getClearedRowCount(self) / 2
	end
end

return BigA3Game