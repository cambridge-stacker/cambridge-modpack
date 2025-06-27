require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'

local Randomizer = require 'tetris.randomizers.nes'

local MarathonC89Game = GameMode:extend()

MarathonC89Game.name = "Marathon C89"
MarathonC89Game.hash = "MarathonC89"
MarathonC89Game.description = "Can you play fast enough to reach the killscreen?"
MarathonC89Game.tags = {"Marathon", "Classic"}


function MarathonC89Game:new()
	MarathonC89Game.super:new()
	
	self.randomizer = Randomizer()

	self.ready_frames = 1
	self.waiting_frames = 96
	self.in_menu = true

	self.start_level = 18
	self.level = self.start_level

	self.last_row = 1
	
	self.tetrises = 0
	self.line_clears = 0

	self.lock_drop = true
	self.enable_hard_drop = false
	self.enable_hold = false
	self.next_queue_length = 1
	self.additive_gravity = false
	self.classic_lock = true
	
	self.irs = false
end

function MarathonC89Game:getDropSpeed() return 1/2 end
function MarathonC89Game:getDasLimit() return 16 end
function MarathonC89Game:getARR() return 6 end

function MarathonC89Game:getARE()
		if self.last_row > 22 then return 10
	elseif self.last_row > 18 then return 12
	elseif self.last_row > 14 then return 14
	elseif self.last_row > 10 then return 16
	else return 18 end
end

function MarathonC89Game:getLineARE() return self:getARE() end

function MarathonC89Game:getLineClearDelay()
	for i = 17, 20 do
		if (self.frames + i) % 4 == 0 then return i end
	end
end

function MarathonC89Game:getLockDelay() return 0 end

function MarathonC89Game:chargeDAS(inputs)
	if inputs[self.das.direction] == true and
		self.prev_inputs[self.das.direction] == true and
		not inputs["down"] and
		self.piece ~= nil
	then
		local das_frames = self.das.frames + 1
		if das_frames >= self:getDasLimit() then
			if self.das.direction == "left" then
				self.move = (self:getARR() == 0 and "speed" or "") .. "left"
				self.das.frames = self:getDasLimit() - self:getARR()
			elseif self.das.direction == "right" then
				self.move = (self:getARR() == 0 and "speed" or "") .. "right"
				self.das.frames = self:getDasLimit() - self:getARR()
			end
		else
			self.move = "none"
			self.das.frames = das_frames
		end
	elseif inputs["right"] == true then
		self.das.direction = "right"
		if not inputs["down"] and self.piece ~= nil then
			self.move = "right"
			self.das.frames = 0
		else 
			self.move = "none"
		end
	elseif inputs["left"] == true then
		self.das.direction = "left"
		if not inputs["down"] and self.piece ~= nil then
			self.move = "left"
			self.das.frames = 0
		else 
			self.move = "none"
		end
	else
		self.move = "none"
	end

	if self.das.direction == "left" and self.piece ~= nil and self.piece:isMoveBlocked(self.grid, {x=-1, y=0}) or
		self.das.direction == "right" and self.piece ~= nil and self.piece:isMoveBlocked(self.grid, {x=1, y=0})
	then
		self.das.frames = self:getDasLimit()
	end

	if inputs["down"] == false and self.prev_inputs["down"] == true then
		self.drop_bonus = 0
	end
	
	if inputs["down"] then self.waiting_frames = 0 end
end

local gravity_table = {
	[0] =
	1366/65536,  1525/65536,  1725/65536,  1986/65536,  2341/65536,
	2850/65536,  3641/65536,  5042/65536,  8192/65536,  10923/65536,
	13108/65536, 13108/65536, 13108/65536, 16384/65536, 16384/65536,
	16384/65536, 21846/65536, 21846/65536, 21846/65536
}

function MarathonC89Game:getGravity()
	if self.waiting_frames > 0 then return 0 end
		if self.level >= 29 then return 1
	elseif self.level >= 19 then return 1/2
	else return gravity_table[self.level] end
end

function MarathonC89Game:advanceOneFrame(inputs, ruleset)
	if self.in_menu then
		if not self.prev_inputs["right"] and inputs["right"] then
			self.start_level = math.min(29, self.start_level + 1)
		elseif not self.prev_inputs["left"] and inputs["left"] then
			self.start_level = math.max(0, self.start_level - 1)
		elseif inputs["hold"] then
			self.in_menu = false
		end
		self.level = self.start_level
		self.prev_inputs = copy(inputs)
		return false
	elseif self.waiting_frames > 0 then
		self.waiting_frames = self.waiting_frames - 1
	else
		self.frames = self.frames + 1
	end
	return true
end

function MarathonC89Game:onPieceLock()
	self.super:onPieceLock()
	self.score = self.score + self.drop_bonus
	self.drop_bonus = 0
	self.last_row = self.piece.position.y
end

local cleared_line_scores = { 40, 100, 300, 1200 }

function MarathonC89Game:getTransitionLines()
	return math.min(self.start_level * 10 + 10, math.max(100, self.start_level * 10 - 50))
end

function MarathonC89Game:getLevelForLines()
	return self.start_level + math.max(0, math.floor((self.lines - self:getTransitionLines()) / 10) + 1)
end

function MarathonC89Game:updateScore(level, drop_bonus, cleared_lines)
	if cleared_lines > 0 then
		self.lines = self.lines + cleared_lines
		self.level = self:getLevelForLines()
		self.score = self.score + cleared_line_scores[cleared_lines] * (self.level + 1)
		self.line_clears = self.line_clears + 1
		if cleared_lines == 4 then self.tetrises = self.tetrises + 1 end
		for i = 1, 4 do
			self.grid:clearSpecificRow(i)
		end
	else
		self.drop_bonus = 0
		self.combo = 1
	end
end

function MarathonC89Game:drawGrid()
	self.grid:draw()
end

function MarathonC89Game:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		(self.line_clears ~= 0 and math.floor(self.tetrises * 100 / self.line_clears) or 0) .. "% " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("LINES", 240, 120, 40, "left")
	love.graphics.printf("SCORE", 240, 200, 40, "left")
	love.graphics.printf("LEVEL", 240, 280, 40, "left")

	love.graphics.setFont(font_3x5_3)
	love.graphics.printf(self.lines, 240, 140, 90, "left")
	if self.score >= 999999 then love.graphics.setColor(1, 1, 0, 1) end
	love.graphics.printf(self.score, 240, 220, 90, "left")
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(self.level, 240, 300, 90, "left")

	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function MarathonC89Game:drawCustom()
	love.graphics.setColor(1, 1, 1, 1)
	
	if self.in_menu then
		love.graphics.setFont(font_3x5_3)
		love.graphics.printf("CHOOSE A LEVEL", 64, 120, 160, "center")

		love.graphics.setFont(font_3x5_4)
		love.graphics.printf(
			(self.start_level == 0 and "-- " or "<- ") ..
			(self.start_level <= 9 and 0 .. self.start_level or self.start_level) ..
			(self.start_level == 29 and " --" or " ->"),
			64, 200, 160, "center"
		)

		love.graphics.setFont(font_3x5_2)
		love.graphics.printf("Press hold to start", 64, 260, 160, "center")
	end
end

function MarathonC89Game:getBackground()
	return self.level % 20
end

function MarathonC89Game:getHighscoreData()
	return {
		score = self.score,
		level = self.level,
	}
end

return MarathonC89Game
