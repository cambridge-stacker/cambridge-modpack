require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'

local History6RollsRandomizer = require 'tetris.randomizers.history_6rolls_35bag'

local IntervalTrainingGame = GameMode:extend()

IntervalTrainingGame.name = "Interval Training"
IntervalTrainingGame.hash = "IntervalTraining"
IntervalTrainingGame.tagline = "Can you clear the time hurdles when the game goes this fast?"
IntervalTrainingGame.tags = {"Trainer", "20G Start"}



function IntervalTrainingGame:new()
	IntervalTrainingGame.super:new()

	self.roll_frames = 0
	self.combo = 1
	self.randomizer = History6RollsRandomizer()
	
	self.section_time_limit = 0
	self.section_start_time = 0
	self.section_times = { [0] = 0 }
	self.lock_drop = true
	self.lock_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 3
end

function IntervalTrainingGame:getARE()
	return 6
end

function IntervalTrainingGame:getLineARE()
	return 6
end

function IntervalTrainingGame:getDasLimit()
	return 7
end

function IntervalTrainingGame:getLineClearDelay()
	return 4
end

function IntervalTrainingGame:getLockDelay()
	return 15
end

function IntervalTrainingGame:getGravity()
	return 20
end

function IntervalTrainingGame:getSection()
	return math.floor(level / 100) + 1
end

function IntervalTrainingGame:advanceOneFrame(inputs, ruleset)
	if self.ready_frames == 0 then
		self.frames = self.frames + 1
		if self:getSectionTime() >= self.section_time_limit then
			self.game_over = true
		end
	else
		self.section_time_limit = ruleset.world and 37 * 60 or 1800
	end
	return true
end

function IntervalTrainingGame:onPieceEnter()
	if (self.level % 100 ~= 99) and self.frames ~= 0 then
		self.level = self.level + 1
	end
end

function IntervalTrainingGame:onLineClear(cleared_row_count)
	local cleared_level_bonus = {1, 2, 4, 6}
	local new_level = self.level + cleared_level_bonus[cleared_row_count]
	self:updateSectionTimes(self.level, new_level)
	self.level = new_level
end

function IntervalTrainingGame:getSectionTime()
	return self.frames - self.section_start_time
end

function IntervalTrainingGame:updateSectionTimes(old_level, new_level)
	if math.floor(old_level / 100) < math.floor(new_level / 100) then
		-- record new section
		table.insert(self.section_times, self:getSectionTime())
		self.section_start_time = self.frames
	end
end

function IntervalTrainingGame:drawGrid()
	self.grid:draw()
end

function IntervalTrainingGame:getHighscoreData()
	return {
		level = self.level,
		frames = self.frames,
	}
end

function IntervalTrainingGame:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("TIME LEFT", 240, 250, 80, "left")
	love.graphics.printf("LEVEL", 240, 320, 40, "left")

	local current_section = math.floor(self.level / 100) + 1
	self:drawSectionTimesWithSplits(current_section)

	love.graphics.setFont(font_3x5_3)
	love.graphics.printf(self.level, 240, 340, 50, "right")

	-- draw time left, flash red if necessary
	local time_left = self.section_time_limit - math.max(self:getSectionTime(), 0)
	if not self.game_over and time_left < frameTime(0,10) and time_left % 4 < 2 then
		love.graphics.setColor(1, 0.3, 0.3, 1)
	end
	love.graphics.printf(formatTime(time_left), 240, 270, 160, "left")

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(self:getSectionEndLevel(), 240, 370, 50, "right")
end

function IntervalTrainingGame:getSectionEndLevel()
	return math.floor(self.level / 100 + 1) * 100
end

function IntervalTrainingGame:getBackground()
	return math.floor(self.level / 100) % 20
end

return IntervalTrainingGame
