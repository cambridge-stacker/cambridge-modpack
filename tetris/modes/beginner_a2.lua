require 'funcs'

local GameMode = require 'tetris.modes.gamemode'

local History6RollsRandomizer = require 'tetris.randomizers.history_6rolls'

local BeginnerA2Game = GameMode:extend()

BeginnerA2Game.name = "Beginner A2"
BeginnerA2Game.hash = "BeginnerA2"
BeginnerA2Game.tagline = "How many points can you score in 300 levels?"
BeginnerA2Game.tags = {"Marathon", "Arika", "Beginner Friendly"}

function BeginnerA2Game:new()
    self.super:new()

    self.roll_frames = 0
	self.combo = 1
    self.randomizer = History6RollsRandomizer()
    self.piece_time = 0
    
    self.SGnames = {
		"9", "8", "7", "6", "5", "4", "3", "2", "1",
		"S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9",
		"GM"
    }
    
	self.additive_gravity = false
    self.lock_drop = false
	self.lock_hard_drop = false
	self.enable_hold = false
    self.next_queue_length = 1
end

function BeginnerA2Game:getARE() return 25 end
function BeginnerA2Game:getLineARE() return self:getARE() end
function BeginnerA2Game:getLineClearDelay() return 40 end
function BeginnerA2Game:getDasLimit() return 14 end
function BeginnerA2Game:getLockDelay() return 30 end

function BeginnerA2Game:getGravity()
        if self.level < 8   then return 4/256
    elseif self.level < 19  then return 5/256
    elseif self.level < 35  then return 6/256
    elseif self.level < 40  then return 8/256
    elseif self.level < 50  then return 10/256
    elseif self.level < 60  then return 12/256
    elseif self.level < 70  then return 16/256
    elseif self.level < 80  then return 32/256
    elseif self.level < 90  then return 48/256
    elseif self.level < 100 then return 64/256
    elseif self.level < 108 then return 4/256
    elseif self.level < 119 then return 5/256
    elseif self.level < 125 then return 6/256
    elseif self.level < 131 then return 8/256
    elseif self.level < 139 then return 12/256
    elseif self.level < 149 then return 32/256
    elseif self.level < 156 then return 48/256
    elseif self.level < 164 then return 80/256
    elseif self.level < 174 then return 112/256
    elseif self.level < 180 then return 128/256
    elseif self.level < 200 then return 144/256
    elseif self.level < 212 then return 16/256
    elseif self.level < 221 then return 48/256
    elseif self.level < 232 then return 80/256
    elseif self.level < 244 then return 112/256
    elseif self.level < 256 then return 144/256
    elseif self.level < 267 then return 176/256
    elseif self.level < 277 then return 192/256
    elseif self.level < 287 then return 208/256
    elseif self.level < 295 then return 224/256
    elseif self.level < 300 then return 240/256
    else return 20 end
end

function BeginnerA2Game:advanceOneFrame()
	if self.clear then
		self.roll_frames = self.roll_frames + 1
		if self.roll_frames > 1800 then
			self.completed = true
		end
	elseif self.ready_frames == 0 then
		self.frames = self.frames + 1
	end
	return true
end

function BeginnerA2Game:onPieceEnter()
	if self.level ~= 299 and not self.clear and self.frames ~= 0 then
		self.level = self.level + 1
	end
end

function BeginnerA2Game:updateScore(level, drop_bonus, cleared_lines)
	if not self.clear then
		if self.grid:checkForBravo(cleared_lines) then self.bravo = 4 else self.bravo = 1 end
		if cleared_lines > 0 then
			self.combo = self.combo + (cleared_lines - 1) * 2
			self.score = self.score + (
				((math.ceil((level + cleared_lines) / 4) + drop_bonus) *
                cleared_lines * self.combo * self.bravo +
                math.ceil(math.min(300, level + cleared_lines) / 2) +
                math.max(self:getLockDelay() - self.piece_time, 0) * 7)
                * 6
			)
		else
			self.combo = 1
		end
        self.drop_bonus = 0
        self.piece_time = 0
    end
end

function BeginnerA2Game:whilePieceActive()
    self.piece_time = self.piece_time + 1
end

function BeginnerA2Game:onLineClear(cleared_row_count)
	self.level = math.min(self.level + cleared_row_count, 300)
	if self.level == 300 and not self.clear then
        self.clear = true
        self.score = self.score + (
            1253 * math.ceil(math.max(0, 18000 - self.frames) / 60)
        )
	end
end

function BeginnerA2Game:drawGrid()
	self.grid:draw()
	if self.piece ~= nil and self.level < 100 then
		self:drawGhostPiece(ruleset)
	end
end

function BeginnerA2Game:getHighscoreData()
	return {
		score = self.score,
		level = self.level,
		frames = self.frames,
	}
end

function BeginnerA2Game:getBackground()
	return math.floor(self.level / 100)
end

function BeginnerA2Game:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		self.piece_time .. " " ..
        strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("SCORE", 240, 200, 40, "left")
	love.graphics.printf("LEVEL", 240, 320, 40, "left")
	local sg = self.grid:checkSecretGrade()
	if sg >= 5 then 
		love.graphics.printf("SECRET GRADE", 240, 430, 180, "left")
	end

	love.graphics.setFont(font_3x5_3)
	love.graphics.printf(self.score, 240, 220, 90, "left")
	love.graphics.printf(self.level, 240, 340, 40, "right")
	love.graphics.printf(300, 240, 370, 40, "right")
	if sg >= 5 then
		love.graphics.printf(self.SGnames[sg], 240, 450, 180, "left")
	end

	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

return BeginnerA2Game