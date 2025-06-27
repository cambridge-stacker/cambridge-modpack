local SurvivalAXGame = require 'tetris.modes.survival_ax'

local SurvivalAXHGame = SurvivalAXGame:extend()

SurvivalAXHGame.name = "Survival AXH"
SurvivalAXHGame.hash = "SurvivalAXH"
SurvivalAXHGame.description = "An old Heboris mode! The field slowly hides itself!"
SurvivalAXGame.tags = {"Survival", "Web", "Gimmick"}

function SurvivalAXHGame:new()
    SurvivalAXGame:new()
    self.hidden_timer = 0
    self.hidden_rows = 0
end

function SurvivalAXHGame:getARE() return 3 end
function SurvivalAXHGame:getLineARE() return 3 end
function SurvivalAXHGame:getLineClearDelay() return 3 end
function SurvivalAXHGame:getLockDelay() return 11 end
function SurvivalAXHGame:getDasLimit() return 7 end

function SurvivalAXHGame:getSkin()
    return self.lines >= 150 and "bone" or "2tie"
end

function SurvivalAXHGame:getHiddenDelay()
    if (self.lines >= 50 and self.lines < 70) then
        return 30 * self.hidden_rows + 45
    elseif (self.lines >= 70 and self.lines < 150) then
        return 10 * self.hidden_rows + 30
    end
end

function SurvivalAXHGame:getSectionTimeLimit()
    return ({
        [0] = 1800, 1800, 1800, 1800, 1800, 1500, 1500, 1500, 1500, 1500,
		1200, 1200, 1200, 1020, 900, 1200, 1020, 900, 840, 840, 840
    })[math.floor(self.lines / 10)]
end

function SurvivalAXHGame:advanceOneFrame()
	if self.ready_frames == 0 then
		if not self.section_clear then
			self.frames = self.frames + 1
            if self:getHiddenDelay() then
                self.hidden_timer = self.hidden_timer + 1
                if self.hidden_timer >= self:getHiddenDelay() then
                    self.hidden_timer = 0
                    self.hidden_rows = math.min(self.hidden_rows + 1, 19)
                end
            end
		end
		if self:getSectionTime() >= self:getSectionTimeLimit() then
			self.game_over = true
		end
	end
	return true
end

function SurvivalAXHGame:onLineClear(cleared_row_count)
	if not self.clear then
        local new_lines = self.lines + cleared_row_count
		self:updateSectionTimes(self.lines, new_lines)
		self.lines = math.min(new_lines, 200)
        self.hidden_rows = math.max(0, self.hidden_rows - cleared_row_count)
		if self.lines == 200 then
			self.grid:clear()
			self.clear = true
			self.completed = true
		end
	end
end

function SurvivalAXHGame:drawGrid()
    self.grid:drawOutline()
    if self:getHiddenDelay() then
        for i = 1, self.hidden_rows do
            for j = 1, 10 do
                love.graphics.draw(blocks["2tie"]["W"], 48+j*16, (24-i+1)*16)
            end
        end
    end
end

function SurvivalAXHGame:drawScoringInfo()
	SurvivalAXGame.super.drawScoringInfo(self)

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

	local current_section = math.floor(self.lines / 10) + 1
	self:drawSectionTimesWithSplits(current_section)

	love.graphics.setFont(font_3x5_3)
	love.graphics.printf(self.lines, 240, 340, 40, "right")
	love.graphics.printf(self.clear and self.lines or self:getSectionEndLines(), 240, 370, 40, "right")

	-- draw time left, flash red if necessary
	local time_left = self:getSectionTimeLimit() - math.max(self:getSectionTime(), 0)
	if not self.game_over and not self.clear and time_left < frameTime(0,10) and time_left % 4 < 2 then
		love.graphics.setColor(1, 0.3, 0.3, 1)
	end
	if self.lines < 200 then love.graphics.printf(formatTime(time_left), 240, 270, 160, "left") end
	love.graphics.setColor(1, 1, 1, 1)
end

function SurvivalAXHGame:getBackground()
    return math.min(math.floor(self.lines / 10), 19)
end

return SurvivalAXHGame