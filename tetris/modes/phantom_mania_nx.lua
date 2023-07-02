local GameMode = require 'tetris.modes.gamemode'

local PhantomManiaNXGame = GameMode:extend()

local History6RollsRandomizer = require 'tetris.randomizers.history_6rolls_35bag'

PhantomManiaNXGame.name = "Phantom Mania NX"
PhantomManiaNXGame.hash = "PhantomManiaNX"
PhantomManiaNXGame.tagline = "The ultimate invisible challenge! Can you survive the brutal gimmicks?"

function PhantomManiaNXGame:new()
	PhantomManiaNXGame.super:new()

	self.grade = 0
	self.garbage = 0
	self.roll_frames = 0
    self.roll_points = 0
	self.combo = 1
    self.cools = 0
    self.last_section_cool = false
    self.tetrises = 0
    self.section_tetris = {}
	self.randomizer = History6RollsRandomizer()
	
	self.SGnames = {
		"S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9",
		"M1", "M2", "M3", "M4", "M5", "M6", "M7", "M8", "M9",
		"GM"
	}
	
	self.lock_drop = true
	self.lock_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 3

	self.coolregret_message = "COOL!!"
	self.coolregret_timer = 0
	self.section_cools = { [0] = 0 }
	self.section_regrets = { [0] = 0 }
end

function PhantomManiaNXGame:getARE()
		if self.level < 300 then return 12
	else return 6 end
end

function PhantomManiaNXGame:getLineARE()
		if self.level < 100 then return 8
	elseif self.level < 200 then return 7
	elseif self.level < 500 then return 6
	elseif self.level < 1300 then return 5
	else return 6 end
end

function PhantomManiaNXGame:getDasLimit()
		if self.level < 100 then return 9
	elseif self.level < 500 then return 7
	else return 5 end
end

function PhantomManiaNXGame:getLineClearDelay()
	if self.level < 1300 then return self:getLineARE() - 2
	else return 6 end
end

function PhantomManiaNXGame:getLockDelay()
        if self.level < 200 then return 18
	elseif self.level < 300 then return 17
	elseif self.level < 500 then return 15
	elseif self.level < 600 then return 13
	elseif self.level < 1100 then return 12
	elseif self.level < 1200 then return 10
	elseif self.level < 1300 then return 8
	else return 15 end
end

function PhantomManiaNXGame:getGravity()
	return 20
end

function PhantomManiaNXGame:getGarbageLimit()
        if self.level < 600 then return 20
	elseif self.level < 700 then return 18
	elseif self.level < 800 then return 10
	elseif self.level < 900 then return 9
	else return 8 end
end

function PhantomManiaNXGame:getSkin()
	return self.level >= 1000 and "bone" or "2tie"
end

function PhantomManiaNXGame:hitTorikan(old_level, new_level)
	if old_level < 300 and new_level >= 300 and self.frames > frameTime(1,30) then
		self.level = 300
		return true
	end
    if old_level < 500 and new_level >= 500 and self.frames > frameTime(2,28) then
		self.level = 500
		return true
	end
    if old_level < 800 and new_level >= 800 and self.frames > frameTime(3,38) then
		self.level = 800
		return true
	end
	if old_level < 1000 and new_level >= 1000 and self.frames > frameTime(4,56) then
		self.level = 1000
		return true
	end
	return false
end

function PhantomManiaNXGame:advanceOneFrame()
	if self.clear then
		self.roll_frames = self.roll_frames + 1
		if self.roll_frames < 0 then
			if self.roll_frames + 1 == 0 then
				switchBGM("credit_roll", "gm3")
				return true
			end
			return false
		elseif self.roll_frames > 3238 then
			if self:qualifiesForGMRoll() then
				self.roll_points = self.roll_points + 160
			else
				self.roll_points = self.roll_points + 50
			end
			switchBGM(nil)
			self.completed = true
		end
	elseif self.ready_frames == 0 then
		self.frames = self.frames + 1
	end
	return true
end

function PhantomManiaNXGame:onPieceEnter()
	if (self.level % 100 ~= 99) and not self.clear and self.frames ~= 0 then
		self:updateSectionTimes(self.level, self.level + 1)
        self.level = self.level + 1
	end
end

local cleared_row_levels = {1, 2, 4, 6}
local roll_points = {4, 8, 12, 26}
local mroll_points = {10, 20, 30, 100}

function PhantomManiaNXGame:qualifiesForGMRoll()
    for i = 0, 12 do
        if not self.section_tetris[i] then
            return false
        end
    end
    return self.cools >= 13 and self.tetrises >= 40
end

function PhantomManiaNXGame:onLineClear(cleared_row_count)
	if not self.clear then
		if cleared_row_count >= 4 then
            self.tetrises = self.tetrises + 1
            self.section_tetris[math.floor(self.level / 100)] = true
        end
        local new_level = self.level + cleared_row_levels[cleared_row_count]
		self:updateSectionTimes(self.level, new_level)
		if new_level >= 1300 or self:hitTorikan(self.level, new_level) then
			self.clear = true
			if new_level >= 1300 then
				self.level = 1300
				self.grid:clear()
				self.roll_frames = -150
			else
				self.game_over = true
			end
		else
			self.level = math.min(new_level, 1300)
		end
		self:advanceBottomRow(-cleared_row_count)
    else
        if self:qualifiesForGMRoll() then
            self.roll_points = self.roll_points + mroll_points[cleared_row_count]
        else
            self.roll_points = self.roll_points + roll_points[cleared_row_count]
        end
	end
end

function PhantomManiaNXGame:onPieceLock(piece, cleared_row_count)
	playSE("lock")
	if cleared_row_count == 0 then self:advanceBottomRow(1) end
end

function PhantomManiaNXGame:updateScore(level, drop_bonus, cleared_lines)
	if not self.clear then
		if cleared_lines > 0 then
			self.combo = self.combo + (cleared_lines - 1) * 2
			self.score = self.score + (
				(math.ceil((level + cleared_lines) / 4) + drop_bonus) *
				cleared_lines * self.combo
			)
		else
			self.combo = 1
		end
		self.drop_bonus = 0
	end
end

local cool_cutoffs = {
    [0] = frameTime(0,32), frameTime(0,32), frameTime(0,29), frameTime(0,25), frameTime(0,25),
          frameTime(0,22), frameTime(0,22), frameTime(0,18), frameTime(0,18), frameTime(0,16),
          frameTime(0,16), frameTime(0,14), frameTime(0,14)
}

function PhantomManiaNXGame:updateSectionTimes(old_level, new_level)
    local section_time = self.frames - self.section_start_time
    if math.floor(old_level / 100) < math.floor(new_level / 100) then
		table.insert(self.section_times, section_time)
		self.section_start_time = self.frames
        if section_time >= frameTime(1,00) then
            --self.last_section_cool = false
            self.coolregret_message = "REGRET!!"
			self.coolregret_timer = 300
            self.grade = self.grade - 1
			table.insert(self.section_regrets, 1)
        else
			table.insert(self.section_regrets, 0)
		end
		if self.last_section_cool then
			self.cools = self.cools + 1
        end
        self.grade = self.grade + 1
	elseif old_level % 100 < 70 and new_level % 100 >= 70 then
        local old_section = math.floor(old_level / 100)
        table.insert(self.secondary_section_times, section_time)
        if  section_time <= cool_cutoffs[old_section] and (
            section_time < (self.secondary_section_times[old_section] + 120) or
			old_section == 0 )
        then
			self.last_section_cool = true
            self.coolregret_message = "COOL!!"
			self.coolregret_timer = 300
			table.insert(self.section_cools, 1)
		else
			self.last_section_cool = false
			table.insert(self.section_cools, 0)
		end
    end
end

function PhantomManiaNXGame:advanceBottomRow(dx)
	if self.level >= 500 and self.level < 1000 then
		self.garbage = math.max(self.garbage + dx, 0)
		if self.garbage >= self:getGarbageLimit() then
			self.grid:copyBottomRow()
			self.garbage = 0
		end
	end
end

function PhantomManiaNXGame:canDrawLCA()
    return (
        self.level < 1000 or (
            self.level >= 1300 and
            not self:qualifiesForGMRoll()
        )
    ) and self.lcd > 0
end

PhantomManiaNXGame.rollOpacityFunction = function(age)
	if age > 4 then return 0
	else return 1 - age / 4 end
end

PhantomManiaNXGame.garbageOpacityFunction = function(age)
	return age > 4 and 0 or 1
end

function PhantomManiaNXGame:drawGrid()
    if not (
        self.game_over or self.completed or
        (self.level >= 1300 and not self:qualifiesForGMRoll())
    ) then
        self.grid:drawInvisible(
            self.rollOpacityFunction,
            self.garbageOpacityFunction,
            self.level < 1000
        )
    else
        self.grid:draw()
    end
end

function PhantomManiaNXGame:getBackground()
	return math.floor(self.level / 100)
end

function PhantomManiaNXGame:getHighscoreData()
	return {
		grade = self:getAggregateGrade(),
        level = self.level,
		frames = self.frames,
	}
end

function PhantomManiaNXGame:getAggregateGrade()
    local grade_cap
    if self:qualifiesForGMRoll() then
        if self.roll_frames > 3238 then
            grade_cap = 42
        else
            grade_cap = 41
        end
    else
        grade_cap = 26
    end
    return math.min(
        self.grade + self.cools + math.floor(self.roll_points / 100) + (
            self:qualifiesForGMRoll() and 1 or 0
        ), grade_cap
    )
end

local master_grades = {"M", "MK", "MV", "MO"}

local function getLetterGrade(grade)
    if grade == 0 then
        return "1"
    elseif grade <= 13 then
        return "S" .. tostring(grade)
    elseif grade <= 26 then
        return "M" .. tostring(grade - 13)
    elseif grade <= 30 then
        return master_grades[grade - 26]
    elseif grade <= 41 then
        return "MM-" .. tostring(grade - 30)
    else
        return "GM"
    end
end

function PhantomManiaNXGame:sectionColourFunction(section)
	if self.section_cools[section] == 1 and self.section_regrets[section] == 1 then
		return { 1, 1, 0, 1 }
	elseif self.section_cools[section] == 1 then
		return { 0, 1, 0, 1 }
	elseif self.section_regrets[section] == 1 then
		return { 1, 0, 0, 1 }
	else
		return { 1, 1, 1, 1 }
	end
end

function PhantomManiaNXGame:drawScoringInfo()
	PhantomManiaNXGame.super.drawScoringInfo(self)

	love.graphics.setColor(1, 1, 1, 1)

	local text_x = config["side_next"] and 320 or 240

	love.graphics.setFont(font_3x5_2)
	love.graphics.printf("GRADE", text_x, 120, 40, "left")
	love.graphics.printf("SCORE", text_x, 200, 40, "left")
	love.graphics.printf("LEVEL", text_x, 320, 40, "left")
	local sg = self.grid:checkSecretGrade()
	if sg >= 5 then 
		love.graphics.printf("SECRET GRADE", 240, 430, 180, "left")
	end
	
	if(self.coolregret_timer > 0) then
		love.graphics.printf(self.coolregret_message, 64, 400, 160, "center")
		self.coolregret_timer = self.coolregret_timer - 1
	end

	local current_section = math.floor(self.level / 100) + 1
	self:drawSectionTimesWithSecondary(current_section)

	love.graphics.setFont(font_3x5_3)
	if self.roll_frames > 3238 then love.graphics.setColor(1, 0.5, 0, 1)
	elseif self.level >= 1300 then love.graphics.setColor(0, 1, 0, 1) end
	love.graphics.printf(getLetterGrade(self:getAggregateGrade()), text_x, 140, 90, "left")
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(self.score, text_x, 220, 90, "left")
	love.graphics.printf(self.level, text_x, 340, 50, "right")
	if self.clear then
		love.graphics.printf(self.level, text_x, 370, 50, "right")
	else
		love.graphics.printf(math.floor(self.level / 100 + 1) * 100, text_x, 370, 50, "right")
	end
	if sg >= 5 then
		love.graphics.printf(self.SGnames[sg], 240, 450, 180, "left")
	end
end

return PhantomManiaNXGame
