local GameMode = require 'tetris.modes.gamemode'
local Grid = require 'tetris.components.grid'
local SegaRandomizer = require 'tetris.randomizers.sega'
local PowerOnSequence = require 'tetris.randomizers.poweron'

local MarathonC99Game = GameMode:extend()

MarathonC99Game.name = "Marathon C99"
MarathonC99Game.hash = "MarathonC99"
MarathonC99Game.tagline = "A recreation of Sega ***ris Naomi / Dreamcast!"

local lines_to_next_level = {
    [0] = 6, 6, 7, 9, 6, 9,
    9, 9, 10, 10, 20, 16, 16,
    16, 16, 0, 1, math.huge
}

local score_table = {
    [0] = 0, 50, 200, 450, 1000, 2000, 3000, 4000
}

local slots_table = {
    50, 10000, 50000, 100000
}

function MarathonC99Game:new()
    self.super:new()
    self.grid = Grid(10, 22)

    self.roll_frames = -57
    self.lines_to_next_level = lines_to_next_level[self.level]
    self.slots = {}
    self.tetris_slots = 0
    self.ccw_bonus = 10 ^ 7

    self.irs = false
    self.enable_hard_drop = false
    self.lock_drop = false
    self.next_queue_length = 1
end

function MarathonC99Game:getARE()
        if self.level == 0 then return 31
    elseif self.level == 1 then return 28
    elseif self.level <= 3 then return 26
    elseif self.level == 4 then return 28
    elseif self.level <= 15 then return 26
    elseif self.level == 16 then return 31
    else return 17 end
end

function MarathonC99Game:getLineARE()
    return self:getARE()
end

function MarathonC99Game:getLineClearDelay()
    return 57
end

function MarathonC99Game:getDasLimit()
    return 15
end

function MarathonC99Game:getGravity()
        if self.level == 0 then return 1/24
    elseif self.level == 1 then return 1/15
    elseif self.level == 2 then return 1/10
    elseif self.level == 3 then return 1/3
    elseif self.level == 4 then return 1/20
    elseif self.level == 5 then return 1/3
    elseif self.level <= 9 then return 1/2
    elseif self.level <= 15 then return 1
    elseif self.level == 16 then return 1/24
    else return 1 end
end

function MarathonC99Game:getLockDelay()
        if self.level == 0 then return 44
    elseif self.level == 1 then return 39
    elseif self.level == 2 then return 34
    elseif self.level == 3 then return 30
    elseif self.level == 4 then return 39
    elseif self.level <= 7 then return 29
    elseif self.level <= 9 then return 28
    elseif self.level <= 12 then return 24
    elseif self.level <= 14 then return 20
    elseif self.level == 15 then return 19
    elseif self.level == 16 then return 44
    else return 18 end
end

function MarathonC99Game:getSlotMultiplier()
        if self.level == 17 then return 10
    elseif self.level >= 15 then return 5
    else return math.ceil((self.level + 1) / 5) end
end

function MarathonC99Game:getScoreMultiplier()
    if self.level == 17 then return 20
    else return self.level + 1 end
end

function MarathonC99Game:startRightDAS()
	self.move = "right"
	self.das.direction = "right"
	if self:getDasLimit() == 0 then
		self:continueDAS()
	end
end

function MarathonC99Game:startLeftDAS()
	self.move = "left"
	self.das.direction = "left"
	if self:getDasLimit() == 0 then
		self:continueDAS()
	end
end

function MarathonC99Game:onSoftDrop(dropped_row_count)
    self.score = self.score + dropped_row_count
end

function MarathonC99Game:advanceOneFrame(inputs, ruleset)
    if self.clear then
        if self.level == 17 then
            self.roll_frames = self.roll_frames + 1
            if self.roll_frames >= frameTime(3,19) then
                self.score = self.score + self.ccw_bonus
                self.completed = true
            end
        end
        if inputs.rotate_right or inputs.rotate_right2 or
        (inputs.rotate_180 and ruleset:get180RotationValue() ~= 3)
        and self.piece ~= nil then
            self.ccw_bonus = 0
        end
    elseif self.ready_frames == 0 then
        self.frames = self.frames + 1
        if inputs.rotate_right or inputs.rotate_right2 or
        (inputs.rotate_180 and ruleset:get180RotationValue() ~= 3)
        and self.piece ~= nil then
            self.ccw_bonus = 0
        end
    end
end

function MarathonC99Game:onLineClear(cleared_row_count)
    self.lines = self.lines + cleared_row_count

    local score_to_add = score_table[cleared_row_count]

    local highest_row_cleared
    for i = 1, 22 do
        if self.grid:isRowFull(i) then
            highest_row_cleared = i
            break
        end
    end

    if highest_row_cleared + 1 <= 22 and self.grid:isRowFull(highest_row_cleared + 1) and
       highest_row_cleared + 2 <= 22 and not self.grid:isRowFull(highest_row_cleared + 2) and
       highest_row_cleared + 3 <= 22 and self.grid:isRowFull(highest_row_cleared + 3) then
        score_to_add = 1
    elseif (cleared_row_count == 2 or cleared_row_count == 3) and
        highest_row_cleared + 1 <= 22 and not self.grid:isRowFull(highest_row_cleared + 1) then
        score_to_add = score_to_add + 100
    end
    
    if (#self.slots == 2) then
        if (self.slots[1] == self.slots[2] and self.slots[1] == cleared_row_count) then
            if cleared_row_count == 4 then
                self.tetris_slots = (self.tetris_slots + 1) % 10
            end
            if cleared_row_count == 4 and self.tetris_slots == 0 then
                self.score = self.score + 999999
            else
                self.score = self.score + slots_table[cleared_row_count] * self:getSlotMultiplier()
            end
        end
        self.slots = {}
    else
        table.insert(self.slots, cleared_row_count)
    end

    if self.grid:checkForBravo(cleared_row_count) then
        self.score = self.score + 200000 * self:getSlotMultiplier()
    else
        self.score = self.score + score_to_add * self:getScoreMultiplier()
    end

    if cleared_row_count >= self.lines_to_next_level then
        self.level = self.level + 1
        if self.level == 15 then
            self.lines_to_next_level = 300 - self.lines
        else
            self.lines_to_next_level = lines_to_next_level[self.level]
        end

        if self.level == 16 then
            self.clear = true
            self.grid:clear()
            if self.used_randomizer.possible_pieces == 7 then
                self.used_randomizer = PowerOnSequence()
                self.next_queue[1].shape = self.used_randomizer:nextPiece()
            end
        end
    else
        self.lines_to_next_level = self.lines_to_next_level - cleared_row_count
    end
    
    for i = 1, 4 do
        self.grid:clearSpecificRow(i)
    end
end

function MarathonC99Game:drawGrid()
    self.grid:draw()
end

function MarathonC99Game:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.setFont(font_3x5_2)

    love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs) ..
		self.drop_bonus
    )
    
    love.graphics.printf("NEXT", 64, 40, 40, "left")
    love.graphics.printf("LEVEL", 240, 120, 80, "left")
    love.graphics.printf("LINES: " .. self.lines .. "/300", 240, 180, 200, "left")
    if self.level <= 15 then
        love.graphics.printf("LINES TO NEXT LEVEL", 240, 220, 200, "left")
    elseif self.level == 17 then
        love.graphics.printf("TIME REMAINING", 240, 220, 200, "left")
    end

    love.graphics.setFont(font_3x5_4)

    love.graphics.printf(formatBigNum(self.score), 64, 400, 160, "center")
    
    love.graphics.setFont(font_3x5_3)

    love.graphics.setColor(
        (self.slots[1] and self.slots[2] and
        self.slots[1] == self.slots[2] and
        (self.frames + self.roll_frames) % 4 < 2) and
        {0.3, 1, 0.3, 1} or
        {1, 1, 1, 1}
    )
    if self.ready_frames == 0 then
        love.graphics.printf(
            (self.slots[1] and self.slots[1] or math.random(4)) .. " " ..
            (self.slots[2] and self.slots[2] or math.random(4)) .. " " ..
            math.random(4),
            240, 80, 100, "left"
        )
    end
    love.graphics.setColor(1, 1, 1, 1)

    if self.level <= 15 then
        love.graphics.printf(self.lines_to_next_level, 240, 240, 200, "left")
    elseif self.level == 17 then
        love.graphics.printf(formatTime(frameTime(3,19) - self.roll_frames), 240, 240, 200, "left")
    end

	love.graphics.setFont(font_8x11)
    love.graphics.printf(formatTime(self.frames), 240, 300, 160, "left")
    love.graphics.printf(self.level, 290, 120, 80, "left")
end

function MarathonC99Game:getBackground()
    if self.level == 17 then
        return math.floor(math.min(math.max(0, self.roll_frames * 20 / frameTime(3,19)), 19))
    end
    return self.level
end

function MarathonC99Game:getHighscoreData()
    return {
        score = self.score,
        lines = self.lines,
        level = self.level,
        frames = self.frames,
    }
end

return MarathonC99Game