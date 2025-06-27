require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'

local History6RollsRandomizer = require 'tetris.randomizers.history_6rolls_35bag'

local CreditsA3Game = GameMode:extend()

CreditsA3Game.name = "Credits A3"
CreditsA3Game.hash = "CreditsA3"
CreditsA3Game.description = "How consistently can you clear the Ti M-roll?"
CreditsA3Game.tags = {"20G Start", "Invisible Stack", "Trainer"}

function CreditsA3Game:new()
	CreditsA3Game.super:new()
	self.section_time_limit = 3238
	self.norm = 0
	self.section = 0
	self.roll_frames = 0

	self.lock_drop = true
	self.lock_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 3
	self.randomizer = History6RollsRandomizer()
end

function CreditsA3Game:getARE()
	return 6
end

function CreditsA3Game:getLineARE()
	return 6
end

function CreditsA3Game:getDasLimit()
	return 7
end

function CreditsA3Game:getLineClearDelay()
	return 4
end

function CreditsA3Game:getLockDelay()
	return 15
end

function CreditsA3Game:getGravity()
	return 20
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
			self.clear = false
			self.grid:clear()
			switchBGM("credit_roll", "gm3")
			self:initializeOrHold(inputs, ruleset)
		else
			return false
		end
	elseif self.ready_frames == 0 then
		self.frames = self.frames + 1
		if self.frames >= self.section_time_limit then
			self.norm = self.norm + 16
			self.piece = nil
			if self.norm >= 60 then
				self.section = self.section + 1
				self.roll_frames = 150
				self.clear = true
			else
				self.game_over = true
				switchBGM(nil)
			end
		end
	end
	return true
end

function CreditsA3Game:onLineClear(cleared_row_count)
	if not self.clear then
		self.norm = self.norm + cleared_row_count + (cleared_row_count >= 4 and 6 or 0)
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
	love.graphics.printf("ROLLS COMPLETED", 240, 170, 120, "left")
	love.graphics.printf("TIME LEFT", 240, 250, 80, "left")
	love.graphics.printf("NORM", 240, 320, 40, "left")

	love.graphics.setFont(font_3x5_3)

	love.graphics.printf(self.section, 240, 190, 160, "left")

	-- draw time left, flash red if necessary
	local time_left = self.section_time_limit - self.frames

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
	return self.section % 20
end

return CreditsA3Game