local GameMode = require 'tetris.modes.gamemode'
local Bag7Randomizer = require 'tetris.randomizers.bag7'

local SurvivalGTEGame = GameMode:extend()

SurvivalGTEGame.name = "Survival GTE"
SurvivalGTEGame.hash = "SurvivalGTE"
SurvivalGTEGame.tagline = "A well-known Master mode that ramps up in difficulty quickly!"

function SurvivalGTEGame:new()
    SurvivalGTEGame.super:new()

    self.lock_drop = true
	self.lock_hard_drop = true
	self.instant_hard_drop = true
	self.instant_soft_drop = false
	self.enable_hold = true
    self.next_queue_length = 4
end

function SurvivalGTEGame:getARE() return 6 end
function SurvivalGTEGame:getLineARE() return 6 end
function SurvivalGTEGame:getGravity() return 20 end
function SurvivalGTEGame:getARR() return 2 end

function SurvivalGTEGame:getDasLimit()
    return math.min(self:getLockDelay() - 2, 10)
end

function SurvivalGTEGame:getLockDelay()
        if self.lines < 100 then return 29
    elseif self.lines < 110 then return 27
    elseif self.lines < 120 then return 25
    elseif self.lines < 130 then return 22
    elseif self.lines < 140 then return 20
    elseif self.lines < 150 then return 17
    elseif self.lines < 160 then return 16
    elseif self.lines < 180 then return 15
    elseif self.lines < 190 then return 13
    elseif self.lines < 210 then return 11
    elseif self.lines < 230 then return 10
    elseif self.lines < 240 then return 9
    elseif self.lines < 260 then return 8
    elseif self.lines < 280 then return 7
    elseif self.lines < 290 then return 6
    else return 5 end
end

function SurvivalGTEGame:getLineClearDelay()
    return math.max(30 - math.floor(self.lines / 10) * 3, 1)
end

function SurvivalGTEGame:onLineClear(cleared_row_count)
    self.lines = math.min(self.lines + cleared_row_count, 300)
    self.completed = self.lines == 300
end

function SurvivalGTEGame:advanceOneFrame()
    if self.ready_frames == 0 then
        self.frames = self.frames + 1
    end
end

function SurvivalGTEGame:getBackground()
    return math.floor(self.lines / 10) % 20
end

function SurvivalGTEGame:getHighscoreData()
    return {
        lines = self.lines,
        frames = self.frames
    }
end

function SurvivalGTEGame:drawScoringInfo()
    love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
    love.graphics.printf("NEXT", 64, 40, 40, "left")
    love.graphics.printf("SPEED LEVEL", 240, 280, 160, "left")
    love.graphics.printf("LINES", 240, 350, 160, "left")

    love.graphics.setFont(font_3x5_3)
    love.graphics.printf(
        "M" .. math.min(30, math.floor(self.lines / 10) + 1),
        240, 300, 160, "left"
    )
    love.graphics.printf(self.lines, 240, 370, 160, "left")

    love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

return SurvivalGTEGame