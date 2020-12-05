require 'funcs'

local IntervalTrainingMode = require 'tetris.modes.interval_training'
local Piece = require 'tetris.components.piece'

local History6RollsRandomizer = require 'tetris.randomizers.history_6rolls'

local CreditsA3Game = IntervalTrainingMode:extend()

CreditsA3Game.name = "Credits A3"
CreditsA3Game.hash = "CreditsA3"
CreditsA3Game.tagline = "How consistently can you clear the Ti M-roll?"

function CreditsA3Game:new()
	CreditsA3Game.super:new()
	self.section_time_limit = 3238
	self.norm = 0
	self.section = 0
end

function CreditsA3Game:advanceOneFrame(inputs, ruleset)
	if self.frames == 0 then
		switchBGM("credit_roll", "gm3")
	end
	if self.roll_frames > 0 then
		self.roll_frames = self.roll_frames - 1
		if self.roll_frames == 0 then
			-- reset
			self.norm = 0
			self.frames = 0
			self.grid:clear()
			switchBGM("credit_roll", "gm3")
			self:initializeOrHold(inputs, ruleset)
		else
			return false
		end
	elseif self.ready_frames == 0 then
		self.frames = self.frames + 1
		if self:getSectionTime() >= self.section_time_limit then
			self.norm = self.norm + 16
			self.piece = nil
			if self.norm >= 60 then
				self.section = self.section + 1
				self.roll_frames = 150
			else
				self.game_over = true
				switchBGM(nil)
			end
		end
	end
	return true
end

function CreditsA3Game:onPieceEnter()
	-- do nothing
end

function CreditsA3Game:onLineClear(cleared_row_count)
	if not self.clear then
		self.norm = self.norm + (cleared_row_count == 4 and 10 or cleared_row_count)
	end
end

CreditsA3Game.rollOpacityFunction = function(age)
	if age > 4 then return 0
	else return 1 - age / 4 end
end

function CreditsA3Game:drawGrid(ruleset)
	if not self.game_over and self.roll_frames < 30 then
		self.grid:drawInvisible(self.rollOpacityFunction)
	else
		self.grid:draw()
	end
end

function CreditsA3Game:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("TIME LEFT", 240, 250, 80, "left")
	love.graphics.printf("NORM", 240, 320, 40, "left")

	self:drawSectionTimesWithSplits(self.section)

	love.graphics.setFont(font_3x5_3)
	-- draw time left, flash red if necessary
	local time_left = self.section_time_limit - math.max(self:getSectionTime(), 0)

	if not self.game_over and not self.clear and time_left < frameTime(0,10) and time_left % 4 < 2 then
		if self.norm >= 44 then
			love.graphics.setColor(0.3, 1, 0.3, 1) -- flash green if goal has been cleared
		else
			love.graphics.setColor(1, 0.3, 0.3, 1) -- otherwise flash red
		end
	end

	love.graphics.printf(formatTime(time_left), 240, 270, 160, "left")

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(self.norm, 240, 340, 40, "right")
	if self.game_over or self.roll_frames > 0 then
		love.graphics.printf("60", 240, 370, 40, "right")
	else
		love.graphics.printf("44", 240, 370, 40, "right")
	end
end

function CreditsA3Game:getBackground()
	return self.section
end

return CreditsA3Game