require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'
local Grid = require 'tetris.components.strategygrid'

local MasterOfBags = require 'tetris.randomizers.masterofbags'

local StrategyPFGame = GameMode:extend()

bgm.strategy_pf=
	{
		love.audio.newSource("res/bgm/data_jack_2nd_version.s3m", "stream"),
		love.audio.newSource("res/bgm/omniphil.s3m", "stream"),
		love.audio.newSource("res/bgm/icefront.s3m", "stream"),
	}
	

StrategyPFGame.name = "Strategy PF"
StrategyPFGame.hash = "StrategyPF"
StrategyPFGame.tagline = "Work with a limited number of pieces to reach the end!"



function StrategyPFGame:new()
	StrategyPFGame.super:new()
	self.grid=Grid(10,24)
	
	self.roll_frames = 0
	self.remaining = 50
	self.used = 0
	self.bravos = 0
	self.roll_lines = 0

	self.Gnames = {
		"", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX",
		"X", "XI", "XII", "XIII", "XIV",
		"M", "M-I", "M-II", "M-III", "M-IV", "M-V", "M-VI", "M-VII", "M-VIII", "M-IX",
		"GM"
	}
	
	self.randomizer = MasterOfBags()

	self.instant_hard_drop = true
	self.instant_soft_drop = false
	self.enable_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 2
	self.torikan_check = {}
	self.torikan_penalty = 0

	self.bgmcheck=0
end

function StrategyPFGame:getRank()
	local level=self.level
	local names=self.Gnames
	return names[math.floor(level/100) + 1 + math.floor(math.min(30, self.roll_lines)/3) - self.torikan_penalty]
end

function StrategyPFGame:getGravity()
	return 0
end

function StrategyPFGame:advanceOneFrame()
	if self.ready_frames == 0 then
		self.frames = self.frames + 1
	end
	if self.bgmcheck==0 then
		switchBGM("strategy_pf", 1)
		self.bgmcheck=1
	elseif self.bgmcheck==1 then
		if self.level>980 then
			fadeoutBGM(180)
			self.bgmcheck=-1
		end
	elseif self.bgmcheck==-1 then
		if self.level>999 then
			switchBGM("strategy_pf", 2)
			self.bgmcheck=2
		end
	elseif self.bgmcheck==2 then
		if self.level>1480 then
			fadeoutBGM(180)
			self.bgmcheck=-2
		end
	elseif self.bgmcheck==-2 then
		if self.level>1499 then
			switchBGM("strategy_pf", 3)
			self.bgmcheck=3
		end
	end
	processBGMFadeout(1)
	return true
end

function StrategyPFGame:onPieceEnter()
	if (self.level % 100 ~= 99) and not self.clear and self.frames ~= 0 then
		self.level = self.level + 1
	end
	self.remaining = self.remaining - 1
end

function StrategyPFGame:onPieceLock(piece, cleared_row_count)
	playSE("lock")
	if self.remaining==0 and (self.clear or cleared_row_count==0) then
		self.completed=true
	end
	if self.level<1500 then
		self.used = self.used + 1
	end
	self.grid:placement()
end

function StrategyPFGame:onLineClear(cleared_row_count)
	if not self.clear then
		if self.level<1500 then self.remaining = self.remaining + math.ceil(({2, 6, 8, 20})[math.min(4,cleared_row_count)] * (1 - math.min(1000, self.level)/2000)) end
		local new_level = math.min(self.level + cleared_row_count + math.max(0, (self.remaining - self:getPieceLimit())), 1500)
		if new_level == 1500 then
			self.remaining = 100
			self.clear = true
		end
		self.level = new_level
		if self.level < 1500 then
			self.remaining = math.min(self.remaining, self:getPieceLimit())
		end
		for x=1,6 do
			if self.level > (899 + x * 100) and not self.torikan_check[x] then
				if self.used > 70 * math.floor(self.level/100) - 100 then
					self.level = 900 + 100 * x
					self.completed = true
					self.torikan_penalty = 1
					return
				end
				self.torikan_check[x]=true
			end
		end
	else
		self.roll_lines = self.roll_lines + cleared_row_count
		if self.roll_lines > 29 then
			self.completed = true
		end
	end
end

function StrategyPFGame:getPieceLimit()
	return 100 - math.floor(math.min(1000 , self.level)/20)
end

StrategyPFGame.rollOpacityFunction = {}
	
for x=1, 26 do
	StrategyPFGame.rollOpacityFunction[x] = function(age, placements)
		if placements < 27-x or age < 4 then return 1
		else return 0 end
	end
end
	
	

function StrategyPFGame:drawGrid()
	if self.level>999 and not (self.completed or self.game_over) then
		self.grid:drawInvisible(self.rollOpacityFunction[math.floor(self.level/20)-49], nil, true)
	else
		self.grid:draw()
	end
end

function StrategyPFGame:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)

	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("GRADE", 240, 120, 40, "left")
	love.graphics.printf("REMAINING PIECES", 240, 200, 150, "left")
	love.graphics.printf("LEVEL", 240, 320, 40, "left")
	love.graphics.printf("PIECES USED", 64, 420, 160, "left")

	if self.bravos > 0 then love.graphics.printf("BRAVO", 300, 120, 40, "left") end

	love.graphics.setFont(font_3x5_3)
	love.graphics.printf(self:getRank(), 240, 140, 120, "left")
	if self.level<1500 then
		if self.remaining<=25 then
			love.graphics.setColor(1, 1, 0, 1)
			if self.remaining<=10 then
				love.graphics.setColor(1, 0, 0, 1)
			end
		end
		love.graphics.printf(self.remaining.."/"..self:getPieceLimit(), 240, 220, 80, "left")
		love.graphics.setColor(1, 1, 1, 1)
	else
		love.graphics.printf(self.remaining, 240, 220, 80, "left")
	end
	
	love.graphics.printf(self.level, 240, 340, 50, "right")
	love.graphics.printf(self:getSectionEndLevel(), 240, 370, 50, "right")
	if self.bravos > 0 then love.graphics.printf(self.bravos, 300, 140, 40, "left") end
	
	love.graphics.setFont(font_8x11)
	love.graphics.printf(self.used, 64, 420, 160, "right")
end

function StrategyPFGame:getSectionEndLevel()
	return math.min(1500, math.floor(self.level / 100 + 1) * 100)
end

function StrategyPFGame:getBackground()
	return math.floor(self.level / 100)
end

function StrategyPFGame:getHighscoreData()
	return {
		level = self.level,
		roll_lines = self.roll_lines
	}
end

return StrategyPFGame
