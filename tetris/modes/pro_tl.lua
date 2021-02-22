require 'funcs'

local MarathonAX4Game = require 'tetris.modes.survival_ax'
local TetraRandomizer = require 'tetris.randomizers.tetra'

local ProGame = MarathonAX4Game:extend()

ProGame.name = "Final TL"
ProGame.hash = "ProTL"
ProGame.tagline = "Your next pieces start disappearing! What lies past Mach 9?"

function ProGame:new()
    self.super:new()
    self.next_queue_length = 6
	self.randomizer = TetraRandomizer()
end

function ProGame:initialize(ruleset)
	self.super.initialize(self, ruleset)
	ruleset.onPieceDrop = function() end
	ruleset.onPieceMove = function() end
	ruleset.onPieceRotate = function() end
end

function ProGame:getARE() return 6 end
function ProGame:getLineARE() return 12 end
function ProGame:getLineClearDelay() return 6 end
function ProGame:getDasLimit() return config.das end
function ProGame:getARR() return config.arr end
function ProGame:getDasCutDelay() return config.dcd end
function ProGame:getDropSpeed() return 20 end

function ProGame:getGravity()
    if self.lines < 20 then return 1
    elseif self.lines < 40 then return 2
    elseif self.lines < 60 then return 5
    else return 20 end
end

function ProGame:getLockDelay()
    if self.lines < 20 then return 30
    elseif self.lines < 40 then return 29
    elseif self.lines < 60 then return 27
    elseif self.lines < 80 then return 23
    elseif self.lines < 100 then return 21
    elseif self.lines < 120 then return 20
    elseif self.lines < 140 then return 18
    elseif self.lines < 160 then return 17
    elseif self.lines < 180 then return 15
    else return 14 end
end

function ProGame:advanceOneFrame(inputs, ruleset)
	if self.ready_frames == 0 then
		if not self.section_clear then
			self.frames = self.frames + 1
		end
		if self:getSectionTime() >= self.section_time_limit then
			self.game_over = true
		end
    end

	return true
end

function ProGame:onPieceEnter()
	self.section_clear = false
	self.piece.lowest_y = -math.huge
end

function ProGame:onHold()
	self.piece.lowest_y = -math.huge
end

function ProGame:whilePieceActive()
	for _, block in pairs(self.piece:getBlockOffsets()) do
		local y = self.piece.position.y + block.y
		if y > self.piece.lowest_y then
			self.piece.lock_delay = 0
			self.piece.lowest_y = y
		end
	end
end

function ProGame:onLineClear(cleared_row_count)
	if not self.clear then
		local new_lines = self.lines + cleared_row_count
		self:updateSectionTimes(self.lines, new_lines)
		self.lines = math.min(new_lines, 200)
		if self.lines == 200 then
			self.clear = true
			self.completed = true
        else
            self.enable_hold = self.lines < 160
            self.next_queue_length = math.max(1, 6 - math.floor(self.lines / 20))
		end
	end
end

function ProGame:updateSectionTimes(old_lines, new_lines)
	if math.floor(old_lines / 20) < math.floor(new_lines / 20) then
		-- record new section
		table.insert(self.section_times, self:getSectionTime())
		self.section_start_time = self.frames
		self.section_clear = true
	end
end

function ProGame:drawGrid()
	self.grid:draw()
	self:drawGhostPiece()
end

function ProGame:drawScoringInfo()
	MarathonAX4Game.super.drawScoringInfo(self)

	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	if self.lines < 200 then love.graphics.printf("TIME LEFT", 240, 250, 80, "left") end
	love.graphics.printf("LINES", 240, 320, 40, "left")

	local current_section = math.floor(self.lines / 20) + 1
	self:drawSectionTimesWithSplits(current_section)

	love.graphics.setFont(font_3x5_3)
	love.graphics.printf(self.lines, 240, 340, 40, "right")
	love.graphics.printf(self.clear and self.lines or self:getSectionEndLines(), 240, 370, 40, "right")

	-- draw time left, flash red if necessary
	local time_left = self.section_time_limit - math.max(self:getSectionTime(), 0)
	if not self.game_over and not self.clear and time_left < frameTime(0,10) and time_left % 4 < 2 then
		love.graphics.setColor(1, 0.3, 0.3, 1)
	end
	if self.lines < 200 then love.graphics.printf(formatTime(time_left), 240, 270, 160, "left") end
	love.graphics.setColor(1, 1, 1, 1)
end

function ProGame:getSectionEndLines()
	return math.floor(self.lines / 20 + 1) * 20
end

function ProGame:getBackground()
	return math.floor(self.lines / 20)
end

return ProGame