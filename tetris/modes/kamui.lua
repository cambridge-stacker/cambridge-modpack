require 'funcs'

local GameMode = require 'tetris.modes.gamemode'

local Randomizer = require 'tetris.randomizers.kamui_sequence'

local KamuiGame = GameMode:extend()

KamuiGame.name = "Race A3"
KamuiGame.hash = "RaceA3"
KamuiGame.tagline = "How fast can you reach level 500?"
KamuiGame.tags = {"Race", "Arika", "20G Start"}

function KamuiGame:new()
    self.super:new()

    self.randomizer = Randomizer()
    self.time_limit = 18000

    self.section_start_time = 0
    self.section_times = { [0] = 0 }
    
    self.lock_drop = true
    self.lock_hard_drop = true
    self.enable_hold = true
    self.next_queue_length = 3
end

function KamuiGame:getARE()
        if self.level < 100 then return 16
    elseif self.level < 300 then return 12
    elseif self.level < 400 then return 6
    else return 5 end
end

function KamuiGame:getLineARE()
        if self.level < 100 then return 12
    elseif self.level < 400 then return 6
    else return 5 end
end

function KamuiGame:getLineClearDelay() return self:getLineARE() end

function KamuiGame:getDasLimit()
        if self.level < 200 then return 10
    elseif self.level < 300 then return 9
    elseif self.level < 400 then return 8
    else return 6 end
end

function KamuiGame:getLockDelay()
        if self.level < 100 then return 30
    elseif self.level < 200 then return 26
    elseif self.level < 300 then return 22
    elseif self.level < 400 then return 18
    else return 15 end
end

function KamuiGame:getGravity() return 20 end

function KamuiGame:onPieceEnter()
    if self.level % 100 ~= 99 and self.frames ~= 0 then
        self.level = self.level + 1
    end
end

function KamuiGame:onLineClear(cleared_row_count)
    local cleared_row_levels = {1, 2, 4, 6}
    local new_level = self.level + cleared_row_levels[cleared_row_count]
    self:updateSectionTimes(self.level, new_level)
    self.level = math.min(500, new_level)
    self.game_over = self.level == 500
end

function KamuiGame:updateSectionTimes(old_level, new_level)
	if math.floor(old_level / 100) < math.floor(new_level / 100) then
		-- record new section
		table.insert(self.section_times, self.frames - self.section_start_time)
		self.section_start_time = self.frames
	end
end

function KamuiGame:advanceOneFrame()
    if self.ready_frames == 0 then
        self.frames = self.frames + 1
        self.time_limit = self.time_limit - 1
    end
    return true
end

function KamuiGame:drawGrid() self.grid:draw() end

function KamuiGame:drawScoringInfo()
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
	love.graphics.printf(self.level, 240, 340, 40, "right")
	love.graphics.printf(self.level == 500 and self.level or (math.floor(self.level / 100) + 1) * 100, 240, 370, 40, "right")

	-- draw time left, flash red if necessary
	if not self.game_over and self.time_limit < frameTime(0,10) and time_left % 4 < 2 then
		love.graphics.setColor(1, 0.3, 0.3, 1)
	end
	love.graphics.printf(formatTime(self.time_limit), 240, 270, 160, "left")
	love.graphics.setColor(1, 1, 1, 1)
end

function KamuiGame:getBackground()
    return math.floor(self.level / 100)
end

function KamuiGame:getHighscoreData()
    return {
        level = self.level,
        frames = self.frames,
    }
end

return KamuiGame