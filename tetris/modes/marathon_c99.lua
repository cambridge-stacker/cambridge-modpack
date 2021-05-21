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

local level_names = {
	[0]="LITTLE ISLE",
	"GRAND CANYON",
	"SHIBUYA",
	"SOUTH POLE",
	"ATLANTIS",
	"Is. GALAPAGOS",
	"EGYPT",
	"NETHERLANDS",
	"PARIS",
	"ASAKUSA",
	"VENICE",
	"NIAGARA FALLS",
	"Mt. RUSHMORE",
	"BEI-JING",
	"EASTER ISLAND",
	"TRIP",
	"THE MOON",
	"[time]"
}

local score_table = {
    [0] = 0, 50, 200, 450, 1000, 2000, 3000, 4000
}

local slots_table = {
    50, 10000, 50000, 100000
}

local slot_popup = {["text"]="",["time"]=0,["slotnum"]=0}
local line_popup = {["y"]=0,["score"]=0,["lines"]=0}

function MarathonC99Game:new()
    self.super:new()
    self.grid = Grid(10, 22)

    self.additive_gravity = false
    self.roll_frames = 0
    self.lines_to_next_level = lines_to_next_level[self.level]
    self.slots = {}
    self.tetris_slots = 0
    self.ccw_bonus = 10 ^ 7
	slot_popup = {["text"]="",["time"]=0}
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

function MarathonC99Game:onPieceEnter()
    self.piece.last_orientation = self.piece.rotation
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
    elseif self.ready_frames == 0 then
        self.frames = self.frames + 1
    end
    if self.piece ~= nil then
        if not (
            self.piece.rotation - self.piece.last_orientation == -1 or -- 3 >> 2, 2 >> 1, 1 >> 0
            self.piece.rotation - self.piece.last_orientation == 3 or -- 0 >> 3
            self.piece.rotation - self.piece.last_orientation == 0 -- not rotated
        ) then
            self.ccw_bonus = 0
        end
        if inputs.down and not self.piece:isDropBlocked(self.grid) then
            self.score = self.score + 1
        end
        self.piece.last_orientation = self.piece.rotation
    end
end

function MarathonC99Game:onLineClear(cleared_row_count)
    self.lines = self.lines + cleared_row_count
	line_popup.lines = cleared_row_count
    local score_to_add = score_table[cleared_row_count]

    local highest_row_cleared
    for i = 1, 22 do
        if self.grid:isRowFull(i) then
            highest_row_cleared = i
            break
        end
    end
	if(cleared_row_count > 0) then
		line_popup.y = (highest_row_cleared)*16
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
            if cleared_row_count == 4 and (self.tetris_slots == 0 or self.level == 17) then
                self.score = self.score + 999999
				slot_popup.text = "3xTETRIS\n+999999"
				slot_popup.time = 150
				slot_popup.slotnum = 4
            else
				clear_names = {"SINGLE","DOUBLE","TRIPLE","***RIS"}
				local score_text = tostring(math.min(999999, slots_table[cleared_row_count] * self:getSlotMultiplier()))
				while #score_text < 6 do score_text = "0"..score_text end
                self.score = self.score + math.min(999999, slots_table[cleared_row_count] * self:getSlotMultiplier())
				slot_popup.text = "3x"..clear_names[cleared_row_count].."\n+"..score_text
				slot_popup.time = 150
				slot_popup.slotnum = cleared_row_count
            end
        end
        self.slots = {}
    else
        table.insert(self.slots, cleared_row_count)
    end

    if self.grid:checkForBravo(cleared_row_count) then
        self.score = self.score + 200000 * self:getSlotMultiplier()
		line_popup.score = 200000 * self:getSlotMultiplier()
    else
        self.score = self.score + score_to_add * self:getScoreMultiplier()
		line_popup.score = score_to_add * self:getScoreMultiplier()
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
	if(self.lcd > 0) then
		love.graphics.setColor(1,1,1,1)
		love.graphics.setFont(font_3x5_2)
		--if(line_popup.lines > 1) then love.graphics.setFont(font_3x5_3) end
		love.graphics.printf(line_popup.score,40,line_popup.y-1,200,"center")
	end
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
    love.graphics.printf("LEVEL "..self.level, 240, 120, 80, "left")
    love.graphics.printf("LINES", 240, 190, 200, "left")
	love.graphics.printf(self.lines.."/300", 240, 210, 200, "left")
	
	if(self.level ~= 15 and self.level ~= 17) then
		xp = -0.5
		love.graphics.setColor(0,1,0,1)
		for i=1,lines_to_next_level[self.level]-self.lines_to_next_level do
			love.graphics.printf("|", 240+xp*5, 165, 30, "left")
			xp = xp+1
		end
		love.graphics.setColor(0,0.5,0,1)
		for i=1,self.lines_to_next_level do
			love.graphics.printf("|", 240+xp*5, 165, 30, "left")
			xp = xp+1
		end
	end
	love.graphics.setColor(1,1,1,1)

    love.graphics.setFont(font_3x5_4)

    love.graphics.printf(formatBigNum(self.score), 64, 400, 160, "center")
    if self.ready_frames == 0 then
		love.graphics.setColor(
			((self.frames + self.roll_frames) % 4 < 2) and
			{0.3, 1, 0.3, 1} or
			{1, 1, 1, 1}
		)
		if(slot_popup.time > 0) then
			love.graphics.setFont(font_3x5_2)
			love.graphics.printf(slot_popup.text, 310, 80, 200, "left")
			slot_popup.time = slot_popup.time - 1
			love.graphics.setFont(font_3x5_3)
			love.graphics.printf(
			slot_popup.slotnum .. " " ..
			slot_popup.slotnum .. " " ..
			slot_popup.slotnum,
			240, 80, 100, "left")
			love.graphics.setColor(1,1,1,1)
			
		else
			love.graphics.setFont(font_3x5_3)
			love.graphics.setColor(
				(self.slots[1] and self.slots[2] and
				self.slots[1] == self.slots[2] and
				(self.frames + self.roll_frames) % 4 < 2) and
				{0.3, 1, 0.3, 1} or
				{1, 1, 1, 1}
			)
			love.graphics.printf(
			(self.slots[1] and self.slots[1] or math.random(4)) .. " " ..
			(self.slots[2] and self.slots[2] or math.random(4)) .. " " ..
			math.random(4),
			240, 80, 100, "left")
			love.graphics.setColor(1,1,1,1)
		end
    end
	love.graphics.setFont(font_3x5_3)
    love.graphics.setColor(1, 1, 1, 1)
	level_names[17] = self.roll_frames == frameTime(3,19) and "THE EDGE OF THE WORLD" or formatTime(frameTime(3,19) - self.roll_frames)
	love.graphics.printf(level_names[self.level], 240, 137, 200, "left")
	love.graphics.setFont(font_3x5_2)
	love.graphics.setFont(font_8x11)
    love.graphics.printf(formatTime(self.frames), 240, 300, 160, "left")
	
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