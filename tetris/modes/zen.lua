require 'funcs'

local Race40Game = require 'tetris.modes.race_40'

local ZenMode = Race40Game:extend()

ZenMode.name = "Marathon WZ"
ZenMode.hash = "Zen"
ZenMode.description = "Attempt to score as many points as you can!"
ZenMode.tags = {"Marathon", "Score Attack", "Web", "Beginner Friendly"}

function ZenMode:new()
    self.super:new()

    self.score = bigint.new(0)
    self.line_goal = 200
    self.pieces = 0
    self.bravos = 0
    self.combo = 0
    self.b2b = 0
    self.message_timer = 0
    self.immobile_spin_bonus = true
end

function ZenMode:initialize(ruleset)
    self.super.initialize(self, ruleset)
    ruleset.onPieceDrop = function(self, piece) piece.lock_delay = 0 end
    ruleset.onPieceMove = function(self, piece) piece.lock_delay = 0 end
    ruleset.onPieceRotate = function(self, piece) piece.lock_delay = 0 end
end

function ZenMode:onHardDrop(dropped_row_count)
    if dropped_row_count > 0 then
        self.score = self.score + bigint.new(dropped_row_count)
    end
end

function ZenMode:getColor(i)
    local color_table = {
        {255/255, 128/255, 128/255, 1},
        {255/255, 191/255, 128/255, 1},
        {255/255, 255/255, 128/255, 1},
        {128/255, 255/255, 191/255, 1},
        {128/255, 255/255, 255/255, 1},
        {128/255, 128/255, 191/255, 1},
        {191/255, 128/255, 255/255, 1},
    }
    if i == 0 then
        return {1, 1, 1, 1}
    else
        return color_table[Mod1(i, #color_table)]
    end
end

function ZenMode:updateScore(level, drop_bonus, cleared_row_count)
    local score_to_add = bigint.new(1)
    if cleared_row_count ~= 0 then
        if self.piece.spin then
            score_to_add = score_to_add * (
                bigint.new(400 + 400 * cleared_row_count) *
                (bigint.new(2) ^ bigint.new(self.b2b + self.combo))
            )
            self.b2b = self.b2b + 1
        elseif cleared_row_count >= 4 then
            score_to_add = score_to_add * (
                bigint.new(100 * (cleared_row_count * cleared_row_count / 4 + cleared_row_count) - 25 * (cleared_row_count % 2)) * 
                (bigint.new(2) ^ bigint.new(self.b2b + self.combo))
            )
            self.b2b = self.b2b + 1
        else
            score_to_add = score_to_add * (
                bigint.new(({100, 300, 500})[cleared_row_count]) *
                (bigint.new(2) ^ bigint.new(self.combo))
            )
            self.b2b = 0
        end
        self.combo = self.combo + 1
    else
        if self.piece.spin then 
            score_to_add = score_to_add * (
                bigint.new(2) ^ (bigint.new(self.b2b)) * (bigint.new(400))
            )
        else
            score_to_add = bigint.new(0)
        end
        self.combo = 0
    end
    self.score = self.score + score_to_add * bigint.new(16) ^ bigint.new(self.bravos)
    if self.grid:checkForBravo(cleared_row_count) then
        self.score = self.score + bigint.new(10 ^ 6) * bigint.new(16) ^ bigint.new(self.bravos)
        self.bravos = self.bravos + 1
    end
end

function ZenMode:onPieceLock(piece, cleared_row_count)
    self.super:onPieceLock()
    self.pieces = self.pieces + 1
    self.score = self.score + bigint.new(math.max(0, self:getLockDelay() - piece.lock_delay))
    if self.grid:checkForBravo(cleared_row_count) then
        self.message = "ALL CLEAR!"
    elseif piece.spin then
        self.message = (self.b2b > 0 and cleared_row_count ~= 0 and "B2B " or "") ..
            (type(piece.shape) == "string" and piece.shape .. "-" or "") ..
            "SPIN " .. cleared_row_count .. "!"
    elseif cleared_row_count >= 4 then
        self.message = (self.b2b > 0 and "B2B " or "") ..
            string.upper(string.sub(number_names[cleared_row_count * 3 + 3], 1, -7)) .. "A!"
    else
        self.message = ""
    end
    self.message_timer = 60
end

function ZenMode:drawScoringInfo()
    local text_x = config["side_next"] and 320 or 240
    
    love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(font_3x5_2)

	if config["side_next"] then
		love.graphics.printf("NEXT", 240, 72, 40, "left")
	else
		love.graphics.printf("NEXT", 64, 40, 40, "left")
	end

	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
    )
    
    love.graphics.printf("SCORE", text_x, 100, 40, "left")
    love.graphics.printf("PIECES", text_x, 280, 80, "left")
    love.graphics.printf("LINES", text_x, 340, 40, "left")
	love.graphics.printf("B2B / COMBO", text_x, 160, 160, "left")
    love.graphics.printf("PERFECT CLEARS", text_x, 220, 160, "left")
    if self.message_timer > 0 then
        love.graphics.printf(self.message, 64, 400, 160, "center")
        self.message_timer = self.message_timer - 1
    end
	local sg = self.grid:checkSecretGrade()
	if sg >= 7 or self.upstacked then 
		love.graphics.printf("SECRET GRADE", 240, 430, 180, "left")
	end

    love.graphics.setFont(font_3x5_3)
    love.graphics.printf(
        {self:getColor(self.b2b), formatBigNum(tostring(self.score))},
        text_x, 120, 400, "left"
    )
    love.graphics.printf(self.pieces, text_x, 300, 80, "left")
	love.graphics.printf(self.b2b .. " / " .. self.combo, text_x, 180, 80, "left")
	love.graphics.printf(self.bravos, text_x, 240, 80, "left")
	if sg >= 7 or self.upstacked then
		love.graphics.printf(self:getSecretGrade(sg), 240, 450, 180, "left")
	end

	love.graphics.setFont(font_3x5_4)
	love.graphics.printf(math.max(0, self.line_goal - self.lines), text_x, 360, 80, "left")

	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function ZenMode:getBackground()
    return math.floor(self.lines / 10) % 20
end

function ZenMode:getHighscoreData()
    return {
        score = self.score,
        lines = self.lines,
        frames = self.frames,
    }
end

return ZenMode