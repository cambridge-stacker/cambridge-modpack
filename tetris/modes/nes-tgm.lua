local GameMode = require 'tetris.modes.gamemode'
local NESRandomizer = require 'tetris.randomizers.nes'

local NESTGMMode = GameMode:extend()

NESTGMMode.name = "NES-TGM"
NESTGMMode.hash = "NESTGM"
NESTGMMode.tagline = "An arcade-styled mode with roots in retro!"

function NESTGMMode:new()
    GameMode:new()
    self.quad_clears = {[0] = 0, 0}
    self.roll_frames = 0

    self.randomizer = NESRandomizer()

	self.ready_frames = 1
	self.waiting_frames = 96

	self.last_row = 1

	self.lock_drop = true
	self.enable_hard_drop = false
	self.enable_hold = false
	self.next_queue_length = 1
	self.additive_gravity = false
	self.classic_lock = true
	
	self.irs = false
end

function NESTGMMode:getDropSpeed() return 1/2 end
function NESTGMMode:getDasLimit() return 16 end
function NESTGMMode:getARR() return 6 end

function NESTGMMode:getARE()
		if self.last_row > 22 then return 10
	elseif self.last_row > 18 then return 12
	elseif self.last_row > 14 then return 14
	elseif self.last_row > 10 then return 16
	else return 18 end
end

function NESTGMMode:getLineARE() return self:getARE() end

function NESTGMMode:getLineClearDelay()
	for i = 17, 20 do
		if (self.frames + i) % 4 == 0 then return i end
	end
end

function NESTGMMode:getLockDelay() return 0 end

function NESTGMMode:chargeDAS(inputs)
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

function NESTGMMode:getLevelForLines()
        if self.lines <  10 then return math.floor(self.lines / 5)
    elseif self.lines < 150 then return math.floor(self.lines / 10) + 1
    elseif self.lines < 300 then return math.floor(self.lines / 50) + 13
    else return 19 end
end

local gravity_table = {
    [0] = 1/48, 1/43, 1/38, 1/33, 1/28,
    1/23, 1/48, 1/28, 1/13, 1/8, 1/6,
    1/5, 1/4, 1/4, 1/5, 1/5, 1/3, 1/3,
    1/3, 1/2
}

function NESTGMMode:getGravity()
    if self.waiting_frames > 0 then return 0 end
    return gravity_table[self:getLevelForLines()]
end

function NESTGMMode:advanceOneFrame()
	if self.waiting_frames > 0 then
		self.waiting_frames = self.waiting_frames - 1
    elseif self:getLevelForLines() >= 19 then
        self.roll_frames = self.roll_frames + 1
        if self.roll_frames >= 3600 then
            self.completed = true
        end
    else
		self.frames = self.frames + 1
	end
	return true
end

function NESTGMMode:onPieceLock()
	self.super:onPieceLock()
	self.score = self.score + self.drop_bonus
	self.drop_bonus = 0
	self.last_row = self.piece.position.y
end

function NESTGMMode:getGrade()
    if (
        self.lines >= 300 and
        self.score >= 600000 and
        self.quad_clears[0] >= 25 and
        self.quad_clears[1] >= 15
    ) then
        if self.roll_frames >= 3600 then return {19, "???"}
        else return {18, "???"} end
    else
            if self.score < 002000 then return {0, 2000}
        elseif self.score < 005300 then return {1, 5300}
        elseif self.score < 011000 then return {2, 11000}
        elseif self.score < 018000 then return {3, 18000}
        elseif self.score < 027000 then return {4, 27000}
        elseif self.score < 038000 then return {5, 38000}
        elseif self.score < 050000 then return {6, 50000}
        elseif self.score < 065000 then return {7, 65000}
        elseif self.score < 083000 then return {8, 83000}
        elseif self.score < 110000 then return {9, 110000}
        elseif self.score < 150000 then return {10, 150000}
        elseif self.score < 200000 then return {11, 200000}
        elseif self.score < 260000 then return {12, 260000}
        elseif self.score < 330000 then return {13, 330000}
        elseif self.score < 410000 then return {14, 410000}
        elseif self.score < 500000 then return {15, 500000}
        elseif self.score < 600000 then return {16, 600000}
        else return {17, "???"} end
    end
end

function NESTGMMode:updateScore(level, drop_bonus, cleared_lines)
	if cleared_lines > 0 then
		if cleared_lines >= 4 and self.lines < 300 then
            self.quad_clears[math.floor(self.lines / 150)] = (
                self.quad_clears[math.floor(self.lines / 150)] + 1
            )
        end
        self.lines = self.lines + cleared_lines
        local score_to_add = 40
        if cleared_lines > 1 then
            score_to_add = 100
            for i = 3, cleared_lines do
                score_to_add = score_to_add * i
            end
        end
        self.score = self.score + score_to_add * (self:getLevelForLines() + 1)
		for i = 1, 4 do
			self.grid:clearSpecificRow(i)
		end
	end
end

function NESTGMMode:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("GRADE", 240, 120, 40, "left")
	love.graphics.printf("SCORE", 240, 200, 40, "left")
	love.graphics.printf("NEXT RANK", 240, 260, 90, "left")
	love.graphics.printf("LINES", 240, 320, 40, "left")
	local sg = self.grid:checkSecretGrade()
	if sg >= 5 then 
		love.graphics.printf("SECRET GRADE", 240, 430, 180, "left")
	end

	love.graphics.setFont(font_3x5_3)
	love.graphics.printf(self.score, 240, 220, 90, "left")
	if self:getGrade()[1] == 19 then
        love.graphics.printf("GM", 240, 140, 90, "left")
    elseif self:getGrade()[1] == 18 then
        love.graphics.printf("M", 240, 140, 90, "left")
    else
        love.graphics.printf(
            self.SGnames[self:getGrade()[1] + 1], 240, 140, 90, "left"
        )
    end
	love.graphics.printf(self:getGrade()[2], 240, 280, 90, "left")
	love.graphics.printf(math.min(300, self.lines), 240, 340, 40, "right")
	love.graphics.printf(self:getSectionEndLines(), 240, 370, 40, "right")
	if sg >= 5 then
		love.graphics.printf(self.SGnames[sg], 240, 450, 180, "left")
	end
	
	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function NESTGMMode:getSectionEndLines()
        if self.lines <  10 then return (1 + math.floor(self.lines / 5)) * 5
    elseif self.lines < 150 then return (1 + math.floor(self.lines / 10)) * 10
    elseif self.lines < 300 then return (1 + math.floor(self.lines / 50)) * 50
    else return 300 end
end

function NESTGMMode:drawGrid()
	self.grid:draw()
end

function NESTGMMode:getBackground()
	return self:getLevelForLines()
end

function NESTGMMode:getHighscoreData()
	return {
        grade = self:getGrade()[1],
		score = self.score,
		level = self:getLevelForLines(),
        lines = self.lines,
	}
end

return NESTGMMode
