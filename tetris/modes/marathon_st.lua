local GameMode = require 'tetris.modes.gamemode'
local History6RollsRandomizer = require 'tetris.randomizers.history_6rolls'

local MarathonSTGame = GameMode:extend()

MarathonSTGame.name = "Marathon ST"
MarathonSTGame.hash = "MarathonST"
MarathonSTGame.tagline = "Grade points are heavily boosted! Can you make it to the end?"

function MarathonSTGame:new()
    self.super:new()
    
    self.roll_frames = 0
	self.combo = 1
	self.randomizer = History6RollsRandomizer()
	self.grade = 0
	self.grade_points = 0
    self.grade_point_decay_counter = 0
    self.grade_point_multiplier = 100
    self.section_start_time = 0
    self.section_boosts = 0
    self.section_boost_status = { [0] = false }
    self.boost_message_time = 0
    
    self.lock_drop = true
    self.lock_hard_drop = true
    self.enable_hard_drop = true
    self.enable_hold = true
    self.next_queue_length = 3
end

function MarathonSTGame:getSpeedLevel()
    return self.level + self.section_boosts * 100
end

function MarathonSTGame:getARE()
    local speed_level = self:getSpeedLevel()
    if speed_level < 800 then return 27
    elseif speed_level < 1000 then return 18
    elseif speed_level < 1800 then return 14
    elseif speed_level < 2000 then return 8
    elseif speed_level < 2200 then return 7
    else return 6 end
end

function MarathonSTGame:getLineARE()
    local speed_level = self:getSpeedLevel()
    if speed_level < 600 then return 27
    elseif speed_level < 800 then return 18
    elseif speed_level < 1000 then return 14
    elseif speed_level < 2000 then return 8
    elseif speed_level < 2200 then return 7
    else return 6 end
end

function MarathonSTGame:getDasLimit()
    local speed_level = self:getSpeedLevel()
    if speed_level < 500 then return 14
    elseif speed_level < 2000 then return 9
    else return 7 end
end

function MarathonSTGame:getLockDelay()
    local speed_level = self:getSpeedLevel()
    if speed_level < 1200 then return 30
    elseif speed_level < 1400 then return 26
    elseif speed_level < 1600 then return 22
    elseif speed_level < 1800 then return 18
    elseif speed_level < 2000 then return 17
    else return 15 end
end

function MarathonSTGame:getLineClearDelay()
    local speed_level = self:getSpeedLevel()
    if speed_level < 500 then return 40
    elseif speed_level < 600 then return 25
    elseif speed_level < 800 then return 16
    elseif speed_level < 1000 then return 12
    elseif speed_level < 2000 then return 6
    elseif speed_level < 2200 then return 5
    else return 4 end
end

function MarathonSTGame:getGravity()
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
else return 20 end
end

function MarathonSTGame:advanceOneFrame()
	if self.clear then
		self.roll_frames = self.roll_frames + 1
		if self.roll_frames < 0 then return false end
		if self.roll_frames > 3694 then
			self.completed = true
		end
	elseif self.ready_frames == 0 then
		self.frames = self.frames + 1
	end
	return true
end

function MarathonSTGame:onPieceEnter()
	if self.level % 100 ~= 99 and not self.clear and self.frames ~= 0 then
		self.level = self.level + 1
	end
end

function MarathonSTGame:onPieceLock(piece, cleared_row_count)
    MarathonSTGame.super:onPieceLock(piece, cleared_row_count)
    self:updateGrade(cleared_row_count)
    self:updateSectionTimes(self.level, self.level + cleared_row_count)
	self.level = math.min(self.level + cleared_row_count, 1500)
	if self.level == 1500 and not self.clear then
		self.clear = true
		self.grid:clear()
		self.roll_frames = -150
    end
end

local section_boost_requirements = {
    [0] = frameTime(0,60), frameTime(0,57), frameTime(0,54), frameTime(0,51), frameTime(0,48),
    frameTime(0,45), frameTime(0,42), frameTime(0,39), frameTime(0,36)
}

function MarathonSTGame:updateSectionTimes(old_level, new_level)
	if self.clear then return end
	if math.floor(old_level / 100) < math.floor(new_level / 100) then
		-- record new section
        local section_time = self.frames - self.section_start_time
        table.insert(self.section_times, section_time)
        self.section_start_time = self.frames
        if (
            old_level >= 600 and
            math.floor(self:getSpeedLevel() / 100) % 2 == 0 and
            section_time <= section_boost_requirements[self.section_boosts]
        ) then
            self.section_boosts = self.section_boosts + 1
            table.insert(self.section_boost_status, true)
            self.grade_point_multiplier = self.grade_point_multiplier + 15
            self.boost_message_time = 180
        else
            table.insert(self.section_boost_status, false)
        end
	end
end

local grade_point_bonuses = {
	{10, 20, 40, 50},
	{10, 20, 30, 40},
	{10, 20, 30, 40},
	{10, 15, 30, 40},
	{10, 15, 20, 40},
	{5, 15, 20, 30},
	{5, 10, 20, 30},
	{5, 10, 15, 30},
	{5, 10, 15, 30},
	{5, 10, 15, 30},
	{2, 12, 13, 30},
}

local grade_point_decays = {
	125, 80, 80, 50, 45, 45, 45,
	40, 40, 40, 40, 40, 30, 30, 30,
	20, 20, 20, 20, 20,
	15, 15, 15, 15, 15, 15, 15, 15, 15, 15,
	10, 10
}

local combo_multipliers = {
	{1.0, 1.0, 1.0, 1.0},
	{1.0, 1.2, 1.4, 1.5},
	{1.0, 1.2, 1.5, 1.8},
	{1.0, 1.4, 1.6, 2.0},
	{1.0, 1.4, 1.7, 2.2},
	{1.0, 1.4, 1.8, 2.3},
	{1.0, 1.4, 1.9, 2.4},
	{1.0, 1.5, 2.0, 2.5},
	{1.0, 1.5, 2.1, 2.6},
	{1.0, 2.0, 2.5, 3.0},
}

function MarathonSTGame:whilePieceActive()
    if self.clear then return end
    if self.combo <= 1 then
        self.grade_point_decay_counter = self.grade_point_decay_counter + 1
    end
	if self.grade_point_decay_counter >= grade_point_decays[self.grade + 1] then
		self.grade_point_decay_counter = 0
		self.grade_points = math.max(0, self.grade_points - 1)
	end
end

function MarathonSTGame:updateGrade(cleared_lines)
    if cleared_lines == 0 then
        self.combo = 1
	else
        self.grade_points = self.grade_points + (
			math.ceil(
				grade_point_bonuses[math.min(self.grade + 1, 11)][math.min(cleared_lines, 4)] *
                combo_multipliers[math.min(self.combo, 10)][math.min(cleared_lines, 4)] *
                (self.grade_point_multiplier / 100) ^ (self.section_boosts == 9 and 2 or 1) *
                (self.clear and 2 or 1)
			)
		)
		if self.grade_points >= 100 and self.grade < 33 then
			self.grade_points = 0
			self.grade = self.grade + 1
        end
        if cleared_lines > 1 then
            self.combo = self.combo + 1
        end
	end
end

local master_grades = { "M", "MK", "MJ", "MV", "MO", "MM" }

function MarathonSTGame:getLetterGrade()
	if self.grade < 9 then
		return tostring(9 - self.grade)
	elseif self.grade < 18 then
		return "S" .. tostring(self.grade - 8)
	elseif self.grade < 27 then
		return "M" .. tostring(self.grade - 17)
	elseif self.grade < 33 then
		return master_grades[self.grade - 26]
	elseif self.grade >= 33 and (not self.completed or self.section_boosts < 9) then
		return "MM+"
	else
		return "GM"
	end
end

local function rollOpacityFunction(game, block, x, y, age)
    if game.section_boosts == 9 then
        return 0.5, 0.5, 0.5, 1 - age / 4, age >= 4 and 0 or 0.64
    else
        local fade_out_frames = 300 - game.section_boosts * 30
        if age < fade_out_frames then
            return 0.5, 0.5, 0.5, 1, 0.64
        elseif age >= fade_out_frames + 60 then
            return 0.5, 0.5, 0.5, 0, 0
        else
            return 0.5, 0.5, 0.5, 1 - (age - fade_out_frames) / 60, 0.64
        end
    end
end


function MarathonSTGame:drawGrid()
    if self.clear and not (self.game_over or self.completed) then
        self.grid:drawCustom(rollOpacityFunction, self)
    else
        self.grid:draw()
    end
    if self.level < 100 then
        self:drawGhostPiece()
    end
end

function MarathonSTGame:sectionColourFunction(section)
    if self.section_boost_status[section] then
        return {0, 1, 0, 1}
    else
        return {1, 1, 1, 1}
    end
end

function MarathonSTGame:drawScoringInfo()
    love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("GRADE", 240, 120, 40, "left")
    love.graphics.printf("GRADE POINTS", 240, 180, 120, "left")
    if self.level >= 600 then
        love.graphics.printf("MULTIPLIER", 240, 240, 80, "left")
    end
    if self.boost_message_time > 0 then
        love.graphics.setColor(
            self.boost_message_time % 4 < 2 and
            {0.3, 1, 0.3, 1} or
            {1, 1, 1, 1}
        )
        love.graphics.printf("BOOSTED!!", 310, 263, 120, "left")
        love.graphics.setColor(1, 1, 1, 1)
        self.boost_message_time = self.boost_message_time - 1
    end
    love.graphics.printf("LEVEL", 240, 320, 40, "left")

    local current_section = math.floor(self.level / 100) + 1
    self:drawSectionTimesWithSplits(current_section, 15)
    
    love.graphics.setFont(font_3x5_3)
    love.graphics.printf(self:getLetterGrade(), 240, 140, 90, "left")
    love.graphics.printf(self.grade_points, 240, 200, 90, "left")
    if self.level >= 600 then
        love.graphics.printf(string.format("%.02f", self.grade_point_multiplier / 100) .. "x", 240, 260, 90, "left")
    end
    love.graphics.printf(self.level, 240, 340, 50, "right")
	love.graphics.printf(self.clear and self.level or self:getSectionEndLevel(), 240, 370, 50, "right")

    love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function MarathonSTGame:getHighscoreData()
	return {
		grade = self.grade,
		level = self.level,
		frames = self.frames,
	}
end

function MarathonSTGame:getSectionEndLevel()
	return math.floor(self.level / 100 + 1) * 100
end

function MarathonSTGame:getBackground()
	return math.floor(self.level / 100)
end

return MarathonSTGame