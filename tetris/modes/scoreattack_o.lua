require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'

local History4RollsRandomizer = require 'tetris.randomizers.bag7noSZOstart'

local ArcadeScoreAttack = GameMode:extend()

ArcadeScoreAttack.name = "Arcade Score Attack"
ArcadeScoreAttack.hash = "Oshisaure-ArcadeScoreAttack"
ArcadeScoreAttack.tagline = "Huge scores! How big can you make yours?"



function ArcadeScoreAttack:new()
	ArcadeScoreAttack.super:new()
	
	self.timeleft = 9000
	self.chain = 0
	self.quads = 0
    self.level = 1
    self.multiplier = 1
    self.b2b = false
    
	self.randomizer = History4RollsRandomizer()
    
    self.lock_drop = true
    self.lock_hard_drop = true
	self.enable_hard_drop = true
	self.enable_hold = true
	self.next_queue_length = 5
end

function ArcadeScoreAttack:updateMultiplier()
end

function ArcadeScoreAttack:getARE()
	return 24
end

function ArcadeScoreAttack:getLineARE()
	return 8
end

function ArcadeScoreAttack:getLineClearDelay()
	return 16
end

function ArcadeScoreAttack:getLockDelay()
	return 30
end

function ArcadeScoreAttack:getDasLimit()
	return 12
end

function ArcadeScoreAttack:getARR()
	return 1
end

local levelchanges = { 
    5,   --lv 1: 5 lines
    10,
    15,
    20,
    25,  
    35,  --lv 6: 10 lines
    45,
    55,
    65, 
    75,  
    90,  --lv11: 15 lines
    115, 
    130,
    145, 
    160, --lv15: 20 lines 
    180, 
    200, 
    220, 
    250, 
    math.huge --lv20: infinite
}

local gravitycurve = {
     1/60, --lv1
     1/30,
     1/20,
     1/15,
     1/12, --lv5
     1/10,
     1/ 6,
     1/ 4,
     1/ 3,
     1/ 2, --lv10
     2/ 2,
     3/ 2,
     4/ 2,
     5/ 2,
     3/ 1, --lv15
     4/ 1,
     5/ 1,
     7/ 1,
    10/ 1,
    20/ 1, --lv20
}
function ArcadeScoreAttack:getGravity()
	return gravitycurve[self.level]
end

function ArcadeScoreAttack:advanceOneFrame()
    if self.ready_frames == 0 then
        self.score = self.score + self.multiplier
        self.timeleft = self.timeleft-1
        if self.timeleft <= 0 then
            self.game_over = true
        end
		self.frames = self.frames + 1
	end
end

function ArcadeScoreAttack:onPieceEnter()
end

function ArcadeScoreAttack:updateScore(level, drop_bonus, cleared_lines)
    self.lines = self.lines + cleared_lines
    if self.lines >= levelchanges[self.level] then
        self.level = self.level + 1
        self.timeleft = self.timeleft + 1800
    end
    local pts = 0
    if cleared_lines == 0 then
        if not self.b2b then self.chain = 0 end
    else
        self.chain = self.chain + 1
        self.b2b = false
        if cleared_lines >= 4 then
            self.b2b = true
            self.quads = self.quads + 1
        end
        pts = 1000
        for i = 2, cleared_lines do pts = pts * i end
    end
    self.multiplier = self.level * (self.chain+1) * (self.quads+1)
    if pts > 0 then
        self.score = self.score + pts * self.multiplier
    end
end

function ArcadeScoreAttack:drawGrid()
	self.grid:draw()
	self:drawGhostPiece(ruleset)
end

local function comma(score)
    if score == 0 then return "0" end
    local scorestr = ""
    local p = 1
    for d = 0, math.log10(score) do
        if d % 3 == 0 and d ~= 0 then scorestr = ","..scorestr end
        local digit = math.floor(score/p)%10
        scorestr = digit..scorestr
        p = p*10
    end
    return scorestr
end

function ArcadeScoreAttack:drawScoringInfo()
	ArcadeScoreAttack.super.drawScoringInfo(self)
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("SCORE", 240, 100, 40, "left")
	love.graphics.printf("LINES", 240, 165, 40, "left")
	love.graphics.printf("MULTIPLIER"     , 240, 220, 153, "right")
	love.graphics.printf("LEVEL"          , 240, 240, 153, "left")
	love.graphics.printf("QUADS   x (1 + ", 240, 260, 160, "left")
	love.graphics.printf("CHAIN   x (1 + ", 240, 280, 160, "left")
	love.graphics.printf("TOTAL   ="      , 240, 310, 153, "left")
	love.graphics.printf("TIME REMAINING", 240, 350, 120, "left")
    
	love.graphics.printf(self.level     .." ", 240, 240, 153, "right")
	love.graphics.printf(self.quads     ..")", 240, 260, 160, "right")
	love.graphics.printf(self.chain     ..")", 240, 280, 160, "right")
	love.graphics.printf(self.multiplier.." ", 240, 310, 153, "right")
    
	love.graphics.setFont(font_3x5_3)
    local li = levelchanges[self.level]
    if li == math.huge then
        love.graphics.printf(self.lines, 240, 190, 40, "left")
    else
        love.graphics.printf(self.lines.."/"..li, 240, 185, 100, "left")
    end
	love.graphics.printf(formatTime(self.timeleft), 240, 370, 150, "left")
    
	love.graphics.setFont(font_3x5_4)
	love.graphics.printf(comma(self.score), 240, 120, 300, "left")
	
	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function ArcadeScoreAttack:getBackground()
	return self.level - 1
end

function ArcadeScoreAttack:getHighscoreData()
	return {
		score = self.score,
		level = self.level,
		frames = self.frames,
	}
end

return ArcadeScoreAttack
