require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'

local Bag7NoSZOStartRandomizer = require 'tetris.randomizers.bag7noSZOstart'

local HighStackerGame = GameMode:extend()

HighStackerGame.name = "High Stacker"
HighStackerGame.hash = "HighStacker"
HighStackerGame.tagline = "Play risky on the higher fields and don't be a chicken!"



function HighStackerGame:new()
	HighStackerGame.super:new()

	self.roll_frames = 0
	self.combo = 0
	self.randomizer = Bag7NoSZOStartRandomizer()
	self.grade = 0
	self.grade_points = 0
	self.grade_point_decay_counter = 0
	self.section_start_score = 0
	self.section_scores = { [0] = 0 }
	self.loop = 0 --0 == loop 1 / 1 == omote / 2 == ura
	self.total_lines = 0
	self.section_cools = 0
	self.cool_timer = 0
	self.ground_touched = false
	self.total_delay = 300
	self.show_loop = false
	self.actually_cue_the_rolls = false
	self.ren_on = false

	self.line_details = { }
	self.line_details_second = { }
	self.detail_timer = 0
	self.ending = 0
	self.clear_bonus_given = false

	--debug
	--[[
	self.level = 499
	self.section_cools = 4
	self.score = 50000000
	self.section_scores = {
		[0] = 10000000,
		[1] = 10000000,
		[2] = 10000000,
		[3] = 10000000
	}
	]]
	
	self.additive_gravity = false
	self.lock_drop = false
	self.lock_hard_drop = false
	self.enable_hold = true
	self.next_queue_length = 3
end

function HighStackerGame:getARE()
		if self.level < 700 then return 27
	elseif self.level < 800 then return 18
	else return 14 end
end

function HighStackerGame:getLineARE()
		if self.level < 600 then return 27
	elseif self.level < 700 then return 18
	elseif self.level < 800 then return 14
	else return 8 end
end

function HighStackerGame:getDasLimit()
		if self.level < 500 then return 15
	elseif self.level < 900 then return 9
	else return 7 end
end

function HighStackerGame:getLineClearDelay()
		if self.level < 500 then return 40
	elseif self.level < 600 then return 25
	elseif self.level < 700 then return 16
	elseif self.level < 800 then return 12
	else return 6 end
end

function HighStackerGame:getLockDelay()
		if self.level < 900 then return 30
	else return 17 end
end

function HighStackerGame:getGravity()
		if (self.level < 30)  then return 4/256
	elseif (self.level < 35)  then return 6/256
	elseif (self.level < 40)  then return 8/256
	elseif (self.level < 50)  then return 10/256
	elseif (self.level < 60)  then return 12/256
	elseif (self.level < 70)  then return 16/256
	elseif (self.level < 80)  then return 32/256
	elseif (self.level < 90)  then return 48/256
	elseif (self.level < 100) then return 64/256
	elseif (self.level < 120) then return 80/256
	elseif (self.level < 140) then return 96/256
	elseif (self.level < 160) then return 112/256
	elseif (self.level < 170) then return 128/256
	elseif (self.level < 200) then return 144/256
	elseif (self.level < 220) then return 4/256
	elseif (self.level < 230) then return 32/256
	elseif (self.level < 233) then return 64/256
	elseif (self.level < 236) then return 96/256
	elseif (self.level < 239) then return 128/256
	elseif (self.level < 243) then return 160/256
	elseif (self.level < 247) then return 192/256
	elseif (self.level < 251) then return 224/256
	elseif (self.level < 300) then return 1
	elseif (self.level < 330) then return 2
	elseif (self.level < 360) then return 3
	elseif (self.level < 400) then return 4
	elseif (self.level < 420) then return 5
	elseif (self.level < 450) then return 4
	elseif (self.level < 500) then return 3
	else return 20
	end
end

function HighStackerGame:getTotalDelay()
		if self.loop ~= 2 then return 300
	elseif self.level < 530 then return 270
	elseif self.level < 600 then return 240
	elseif self.level < 700 then return 210
	elseif self.level < 800 then return 180
	elseif self.level < 900 then return 150
	else return 120 end
end

function HighStackerGame:advanceOneFrame()
	if self.clear then
		self.roll_frames = self.roll_frames + 1
		if not self.actually_cue_the_rolls then
			if self.roll_frames < -120 then
				return false
			elseif self.roll_frames >= 0 then
				if self.loop ~= 0 then
					self.clear = false
					self.ready_frames = 100
					self.show_loop = true
				end
				return true
			end
			return false
		elseif self.roll_frames < 0 then
			if self.roll_frames + 1 == 0 then
				switchBGM("credit_roll", "gm3")
			end
			return false
		elseif self.roll_frames > 3701 then
			self.completed = true
			switchBGM(nil)
		end
	elseif self.ready_frames == 0 then
		self.frames = self.frames + 1
		if self.piece ~= nil then
			if self.ground_touched and self.loop == 2 then
				self.total_delay = self.total_delay + 1
				if self.total_delay >= self:getTotalDelay() and self.piece:isDropBlocked(self.grid) then
					self.piece.locked = true
				end
			elseif self.piece:isDropBlocked(self.grid) then self.ground_touched = true end
		end
	end
	if self.detail_timer > 0 then
		self.detail_timer = self.detail_timer - 1
	end
	return true
end

function HighStackerGame:onPieceEnter()
	self.total_delay = 0
	self.ground_touched = false
	if (self.level % 100 ~= 99) and not self.clear and self.frames ~= 0 and not self.ren_on then
		self.level = self.level + 1
	end
end

local line_count_multiplier = {1, 2, 4, 6}
local line_position_score = {
	15000,
	15000,
	15000,
	15000, --lowest off-field row
	15000,
	10000,
	9000,
	8000,
	7000,
	6000,
	5000,
	4000,
	3000,
	2000,
	1000,
	900,
	800,
	700,
	600,
	500,
	40,
	30,
	20,
	10
}

function HighStackerGame:updateScore(level, drop_bonus, cleared_lines)
	local ae, cleared_lines_table = self.grid:getClearedRowCount()
	self.total_lines = self.total_lines + cleared_lines
	if cleared_lines > 0 then
		self.detail_timer = 120
		self.line_details = { }
		self.line_details_second = { }
		local basescore = self.combo
		local levelscore = self.level * 10
		table.insert(self.line_details_second, levelscore)
		if basescore > 0 then 
			table.insert(self.line_details_second, basescore)
			self.ren_on = true
		end
		if self.loop == 1 then levelscore = levelscore - 5000 end
		basescore = basescore + levelscore
		for key, pos in ipairs(cleared_lines_table) do
			basescore = basescore + line_position_score[pos]
			table.insert(self.line_details, line_position_score[pos])
		end
		self.score = self.score + basescore * line_count_multiplier[cleared_lines]
		self.combo = basescore
		
	else
		self.combo = 0
		self.ren_on = false
	end
	self.drop_bonus = 0
	if self.clear then self.lines = self.lines + cleared_lines end --reminder that this is for roll lines
end

function HighStackerGame:onLineClear(cleared_row_count)
	if self.ren_on == false then
		self:updateSectionScores(self.level, self.level + cleared_row_count)
		self.level = math.min(self.level + cleared_row_count, 1000)
	end
	if self.level >= 500 and not self.clear and self.loop == 0 then
		self.level = 500
		self.clear = true
		self.grid:clear()
		self.roll_frames = -150
		if self:nextloopcheck() then
			self.roll_frames = self.roll_frames - 120
			self.lcd = 0
			self.are = 0
		else
			self.actually_cue_the_rolls = true
		end
	elseif self.level == 1000 and not self.clear then
		self.clear = true
		self.grid:clear()
		self.actually_cue_the_rolls = true
		self.roll_frames = -150
	end
	self.lock_drop = self.level >= 900
	self.lock_hard_drop = self.level >= 900
end

local lowest_section_cool_cutoff = 800000

function HighStackerGame:updateSectionScores(old_level, new_level)
	if self.clear or self.loop ~= 0 then return end
	if math.floor(old_level / 100) < math.floor(new_level / 100) or
	new_level >= 500 then
		-- record new section
		section_score = self.score - self.section_start_score
		self.section_scores[math.floor(old_level / 100)] = section_score
		self.section_start_score = self.score
		if self.loop == 0 then
			if section_score >= lowest_section_cool_cutoff + 50000 * (math.floor(old_level / 100) + self.section_cools) then
				self.section_cools = self.section_cools + 1
				self.cool_timer = 300
			end
		end
	end
end

function HighStackerGame:nextloopcheck()
	if not self.clear then return false end
	if self.section_cools >= 5 and self.score >= 6000000 then
		self.loop = 2
		return true
	elseif self.section_cools >= 3 and self.score >= 4000000 then
		self.loop = 1
		return true
	end
	return false
end

function HighStackerGame:getSkin()
	return (self.level >= 701 and self.loop == 2) and "bone" or "2tie"
end

function HighStackerGame:onGameComplete()
	if not self.clear_bonus_given then
		self.clear_bonus_given = true
		if self.loop == 2 then
			self.score = self.score + self.total_lines * 100 + self.lines * 1000
		elseif self.loop == 1 then
			self.score = self.score + self.total_lines * 100 + self.lines * 500
		else
			self.score = self.score + self.total_lines * 10 + self.lines * 100
		end
	end
	self:onGameOver()
end

function HighStackerGame:onGameOver()
	switchBGM(nil)
	if not self.clear_bonus_given then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(font_3x5_3)
		love.graphics.printf("GAME\nOVER", 64, 200, 160, "center")
	else
		if self.game_over_frames >= 300 then
			local alpha = 0
			local animation_length = 120
			if self.game_over_frames - 300 < animation_length then
				-- Show field for a bit, then fade out.
				alpha = math.pow(2048, (self.game_over_frames - 300)/animation_length - 1)
			else
				alpha = 1
			end
			love.graphics.setColor(0, 0, 0, alpha)
			love.graphics.rectangle(
				"fill", 64, 80,
				16 * self.grid.width, 16 * (self.grid.height - 4)
			)
		end
		if self.game_over_frames >= 420 and loop == 2 then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.setFont(font_3x5_2)
			love.graphics.printf(
				[[And so, the journey
for the true end of
this absurd scoring
mode is over...

From now on,
aim for an even
	  higher score.

May fortune
	   be with you.

	   -Xx_Henry_xX]], 67, math.max(125, 1000 - self.game_over_frames), 160, "left")
		end
	end
end

HighStackerGame.rollOpacityFunction = function(age)
	if age < 240 then return 1
	elseif age > 300 then return 0
	else return 1 - (age - 240) / 60 end
end

HighStackerGame.mRollOpacityFunction = function(age)
	if age > 4 then return 0
	else return 1 - age / 4 end
end

function HighStackerGame:drawGrid()
	if self.clear and not (self.completed or self.game_over) then
		if self.loop == 2 then
			self.grid:drawInvisible(self.mRollOpacityFunction, nil, false)
		elseif self.loop == 1 then
			self.grid:drawInvisible(self.rollOpacityFunction, nil, false)
		else
			self.grid:draw()
		end
	else
		self.grid:draw()
		if self.piece ~= nil then
			self:drawGhostPiece(ruleset)
		end
	end
end

function HighStackerGame:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(font_3x5_2)

	--y is dis debug text everywhere
	--[[
	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
	]]

	love.graphics.printf("NEXT", 126, 6, 40, "left")
	love.graphics.printf("HOLD", 46, 6, 40, "left")
	--love.graphics.printf("SCORE", 240, 200, 40, "left")
	local vertpos = 320
	if self.show_loop then vertpos = 290 end
	love.graphics.printf("LEVEL", 240, vertpos, 40, "left")

	love.graphics.setFont(font_3x5_3)
	if self.clear and not self.actually_cue_the_rolls and self.roll_frames >= -120 then
		if self.loop == 2 then
			love.graphics.printf("WELCOME TO THE SPECIAL ROUND", 64, 200, 160, "center")
		else
			love.graphics.printf("Let's try everything again", 64, 200, 160, "center")
		end
	end	

	if self.clear_bonus_given then
		if self.loop == 0 then
			love.graphics.setFont(font_3x5_3)
			love.graphics.printf("ALL CLEAR!", 44, 100, 200, "center")
			love.graphics.setFont(font_3x5)
			love.graphics.printf("(probably)", 44, 125, 200, "center")

			love.graphics.setFont(font_3x5_2)
			love.graphics.printf("TOTAL LINES", 80, 240, 120, "left")
			love.graphics.printf(self.total_lines .. " x 10\n" .. (self.total_lines * 10), 80, 260, 120, "right")
			love.graphics.printf("ROLL LINES", 80, 320, 120, "left")
			love.graphics.printf(self.lines .. " x 100\n" .. (self.lines * 100), 80, 340, 120, "right")
		elseif self.loop == 1 then
			love.graphics.setFont(font_3x5_3)
			love.graphics.printf("2-ALL CLEAR!", 44, 100, 200, "center")
			love.graphics.setFont(font_3x5)
			love.graphics.printf("(still not enough)", 44, 125, 200, "center")

			love.graphics.setFont(font_3x5_2)
			love.graphics.printf("TOTAL LINES", 80, 240, 120, "left")
			love.graphics.printf(self.total_lines .. " x 100\n" .. (self.total_lines * 100), 80, 260, 120, "right")
			love.graphics.printf("ROLL LINES", 80, 320, 120, "left")
			love.graphics.printf(self.lines .. " x 500\n" .. (self.lines * 500), 80, 340, 120, "right")
		elseif self.game_over_frames < 300 then
			love.graphics.printf("CONGRATULATIONS!\nTRUE 2-ALL\nCLEAR!!!", 44, 100, 200, "center")

			love.graphics.setFont(font_3x5_2)
			love.graphics.printf("TOTAL LINES", 80, 240, 120, "left")
			love.graphics.printf(self.total_lines .. " x 100\n" .. (self.total_lines * 100), 80, 260, 120, "right")
			love.graphics.printf("ROLL LINES", 80, 320, 120, "left")
			love.graphics.printf(self.lines .. " x 1000\n" .. (self.lines * 1000), 80, 340, 120, "right")
		end
	end

	if(self.cool_timer > 0) then
		love.graphics.printf("COOL!!", 64, 400, 160, "center")
		self.cool_timer = self.cool_timer - 1
	end

	love.graphics.setFont(font_8x11)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(self.score, 48, 420, 180, "right")
	love.graphics.setFont(font_3x5_3)
	if self.show_loop then
		if self.loop == 2 then
			love.graphics.printf("2'-", 240, 310, 40, "right")
		elseif self.loop == 1 then
			love.graphics.printf("2-", 240, 310, 40, "left")
		end
	end
	love.graphics.printf(self:getLevel(), 240, 340, 40, "right")
	love.graphics.printf(self:getSectionEndLevel(), 240, 370, 40, "right")
	love.graphics.setFont(font_3x5_2)
	love.graphics.printf(formatTime(self.frames), 500, 420, 180, "left")

	love.graphics.setColor(1, 1, 1, 1)
	if self.loop == 0 then
		local prevSectionTotal = 0
		for i = 0, #self.section_scores do
			prevSectionTotal = prevSectionTotal + self.section_scores[i]
		end
		love.graphics.printf(self.score - prevSectionTotal, 240, 420, 70, "right")
		love.graphics.printf("/" .. lowest_section_cool_cutoff + 50000 * (math.floor(self.level / 100) + self.section_cools), 240, 436, 70, "right")
	end

    cool_counter = 0
	for i = 0, #self.section_scores do
		love.graphics.setColor(1, 1, 1, 1)
		if self.section_scores[i] > lowest_section_cool_cutoff + 50000 * (i + cool_counter) then
			love.graphics.setColor(0, 1, 0, 1)
			cool_counter = cool_counter + 1
		end
		love.graphics.printf(self.section_scores[i], 400, 80 + 16 * i, 180, "right")
	end

	love.graphics.setColor(1, 1, 1, 1)
	if self.detail_timer > 0 then
		for i = 1, #self.line_details do
			love.graphics.printf(self.line_details[i] .. "x" .. line_count_multiplier[#self.line_details], 240, 134 + 16 * i, 60, "right")
		end
		for i = 1, #self.line_details_second do
			love.graphics.printf(self.line_details_second[i] .. "x" .. line_count_multiplier[#self.line_details], 240, 196 + 16 * i, 60, "right")
		end
	end
end

function HighStackerGame:getHighscoreData()
	return {
		score = self.score,
		level = self.level,
		frames = self.frames,
	}
end

function HighStackerGame:getLevel()
	if self.loop ~=0 then return self.level - 500 end
	return self.level
end

function HighStackerGame:getSectionEndLevel()
	if self.loop ~=0 then return math.min(math.floor((self.level - 500) / 100 + 1) * 100, 500) end
	return math.min(math.floor(self.level / 100 + 1) * 100, 500)
end

function HighStackerGame:getBackground()
	return math.floor(self.level / 100)
end

return HighStackerGame