require 'funcs'

local SurvivalA3Game = require 'tetris.modes.survival_a3'

local BigMemeGame = SurvivalA3Game:extend()

BigMemeGame.name = "Big Survival A3"
BigMemeGame.hash = "BigA3"
BigMemeGame.tagline = "The blocks are bigger and the speeds are faster!"

function BigMemeGame:initialize(ruleset)
    self.super:initialize(ruleset)
    self.big_mode = true
end

local cleared_row_levels = {1, 2, 4, 6}

function BigMemeGame:onLineClear(cleared_row_count)
    cleared_row_count = cleared_row_count / 2
    if not self.clear then
		local new_level = self.level + cleared_row_levels[cleared_row_count]
		self:updateSectionTimes(self.level, new_level)
		if new_level >= 1300 or self:hitTorikan(self.level, new_level) then
			self.clear = true
			if new_level >= 1300 then
				self.level = 1300
				self.grid:clear()
				self.big_mode = true
				self.roll_frames = -150
			else
				self.game_over = true
			end
		else
			self.level = math.min(new_level, 1300)
		end
		self:advanceBottomRow(-cleared_row_count)
	end
end

function BigMemeGame:advanceBottomRow(dx)
	if self.level >= 500 and self.level < 1000 then
		self.garbage = math.max(self.garbage + dx, 0)
		if self.garbage >= self:getGarbageLimit() then
			self.grid:copyBottomRow()
			self.grid:copyBottomRow()
			self.garbage = 0
		end
	end
end

return BigMemeGame