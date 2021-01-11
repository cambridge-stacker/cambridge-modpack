require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local SurvivalA3Game = require 'tetris.modes.survival_a3'
local Grid = require 'tetris.components.grid'

local FourWideGame = SurvivalA3Game:extend()

FourWideGame.name = "4-wide Simulator"
FourWideGame.hash = "4wide"
FourWideGame.tagline = "The board has gotten narrower! Can you survive the increasing speeds?"

function FourWideGame:initialize(ruleset)
	self.super:initialize(ruleset)
	self.grid = Grid(4)
end

local function getLetterGrade(grade)
	if grade == 0 then
		return "1"
	else
		return "S" .. tostring(grade)
	end
end

function FourWideGame:drawScoringInfo()
	GameMode:drawScoringInfo()

	love.graphics.setColor(1, 1, 1, 1)

	local text_x = 160

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
	self:drawSectionTimesWithSplits(current_section)

	love.graphics.setFont(font_3x5_3)
	if self.roll_frames > 3238 then love.graphics.setColor(1, 0.5, 0, 1)
		elseif self.level >= 1300 and self.clear then love.graphics.setColor(0, 1, 0, 1) end
	love.graphics.printf(getLetterGrade(math.floor(self.grade)), text_x, 140, 90, "left")
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

return FourWideGame
