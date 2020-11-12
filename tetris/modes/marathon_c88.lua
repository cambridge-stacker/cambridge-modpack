require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'

local SegaRandomizer = require 'tetris.randomizers.sega'

local MarathonC88Game = GameMode:extend()

MarathonC88Game.name = "Marathon C88"
MarathonC88Game.hash = "MarathonC88"
MarathonC88Game.tagline = "An old Japanese game! Can you hit the max score?"

function MarathonC88Game:new()
	self.super:new()

	self.level_timer = 0
	self.level_lines = 0
	self.last_cleared = 0
	self.tetrises = 0
	self.line_clears = 0
	
	self.randomizer = SegaRandomizer()

	self.lock_drop = false
	self.enable_hard_drop = false
	self.enable_hold = false
	self.next_queue_length = 1

	self.grid:applyCeiling(4)
end

function MarathonC88Game:getARE() return 30 end
function MarathonC88Game:getLineARE() return 30 end
function MarathonC88Game:getDasLimit() return 20 end
function MarathonC88Game:getLineClearDelay() return 42 end
function MarathonC88Game:getLockDelay() return 30 end

function MarathonC88Game:getGravity()
	    if self.level == 0  then return 1/30
	elseif self.level == 1  then return 1/15
	elseif self.level == 2  then return 1/12
	elseif self.level == 3  then return 1/10
	elseif self.level == 4  then return 1/8
	elseif self.level == 5  then return 1/6
	elseif self.level == 6  then return 1/4
	elseif self.level == 7  then return 1/2
	elseif self.level <= 9  then return 1
	elseif self.level == 10 then return 1/8
	elseif self.level == 11 then return 1/6
	elseif self.level == 12 then return 1/4
	elseif self.level == 13 then return 1/2
	else return 1 end
end

function MarathonC88Game:getLevelTimerLimit()
	    if self.level == 0  then return 3480
	elseif self.level <= 8  then return 2320
	elseif self.level <= 10 then return 3480
	elseif self.level <= 14 then return 1740
	else return 3480 end
end

function MarathonC88Game:getScoreMultiplier()
	    if self.level <= 1 then return 1
	elseif self.level <= 3 then return 2
	elseif self.level <= 5 then return 3
	elseif self.level <= 7 then return 4
	else return 5 end
end

function MarathonC88Game:advanceOneFrame()
	if not (self.piece == nil and self.level_timer == 0) and self.ready_frames == 0 then
		self.level_timer = self.level_timer + 1
	end
	if self.ready_frames == 0 then self.frames = self.frames + 1 end
	if self.drop_bonus > 0 then
		self.score = self.score + self.drop_bonus * self:getScoreMultiplier()
		self.drop_bonus = 0
	end
end

function MarathonC88Game:onPieceEnter()
	for row = 5, 4 + self.last_cleared do self.grid:clearSpecificRow(row) end
	self.grid:applyCeiling(4)
end

local score_table = {[0] = 0, 1, 4, 9, 20}

function MarathonC88Game:updateScore(level, drop_bonus, cleared_lines)
	local bravo = self.grid:checkForBravo(cleared_lines) and 10 or 1
	self.score = self.score + score_table[cleared_lines] * 100 * self:getScoreMultiplier() * bravo
	self.level_lines = self.level_lines + cleared_lines
	self.lines = self.lines + cleared_lines
	self.line_clears = self.line_clears + 1
	if (cleared_lines == 4) then self.tetrises = self.tetrises + 1 end
	if (cleared_lines == 0 and self.level_timer >= self:getLevelTimerLimit()) or (self.level_lines >= 4) then
		self.level = self.level + 1
		self.level_lines = 0
		self.level_timer = 0
	end
	self.last_cleared = cleared_lines
end

MarathonC88Game.opacityFunction = function(age)
	return 1
end

MarathonC88Game.ceilingOpacityFunction = function(age)
    return 0
end

function MarathonC88Game:drawGrid()
	self.grid:drawInvisible(self.opacityFunction, self.ceilingOpacityFunction)
end

function MarathonC88Game:drawScoringInfo()
	MarathonC88Game.super.drawScoringInfo(self)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		math.floor(self.tetrises / self.line_clears) .. "% " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("SCORE", 240, 120, 40, "left")
	love.graphics.printf("LINES", 240, 200, 40, "left")
	love.graphics.printf("LEVEL", 240, 280, 40, "left")

	love.graphics.setFont(font_3x5_3)
	if self.score >= 999999 then love.graphics.setColor(1, 1, 0, 1) end
	love.graphics.printf(self.score, 240, 140, 90, "left")
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(self.lines, 240, 220, 90, "left")
	love.graphics.printf(self.level, 240, 300, 90, "left")

	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function MarathonC88Game:getBackground()
	return math.min(math.floor(self.level / 2), 19)
end

function MarathonC88Game:getHighscoreData()
	return {
		score = self.score,
		level = self.level,
		lines = self.lines,
		frames = self.frames,
	}
end

return MarathonC88Game
