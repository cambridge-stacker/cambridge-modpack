require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Bag7Randomizer = require 'tetris.randomizers.bag7'

local MarathonGFGame = GameMode:extend()

MarathonGFGame.name = "Marathon GF"
MarathonGFGame.hash = "MarathonGF"
MarathonGFGame.tagline = "The old puzzle mode from Tetris Friends!"

function MarathonGFGame:new()
    self.super:new()

    self.back_to_back = false
    self.roll_limit = 10
    self.roll_frames = 0
    self.message = ""
    self.message_timer = 0
    self.randomizer = Bag7Randomizer()
    self.combo = 0

    self.lock_drop = true
	self.lock_hard_drop = true
	self.instant_hard_drop = true
	self.instant_soft_drop = false
	self.enable_hold = true
    self.next_queue_length = 6
end

function MarathonGFGame:getARE() return 6 end
function MarathonGFGame:getLineARE() return 6 end
function MarathonGFGame:getLineClearDelay() return 24 end
function MarathonGFGame:getDasLimit() return config.das end
function MarathonGFGame:getARR() return config.arr end

function MarathonGFGame:getGravity()
    if self.lines < 180 then
        return (0.8 - (math.floor(self.lines / 10) * 0.007)) ^ -math.floor(self.lines / 10) / 60
    elseif self.lines < 200 then return 20
    else return 1/4 end
end

function MarathonGFGame:getDropSpeed()
    return self:getGravity() * 20
end

function MarathonGFGame:advanceOneFrame()
	if self.clear then
		self.roll_frames = self.roll_frames + 1
        if self.roll_frames < 0 then return false
        else self.frames = self.frames + 1 end
        if self.roll_frames >= self.roll_limit + 10 then
            self.roll_frames = 0
            self.roll_limit = self.roll_limit + 5
        end
	elseif self.ready_frames == 0 then
        self.frames = self.frames + 1
    end
    if self.drop_bonus > 0 then
        self.score = self.score + self.drop_bonus
        self.drop_bonus = 0
    end
	return true
end

function MarathonGFGame:onLineClear(cleared_row_count)
	if not self.clear then
		local new_lines = self.lines + cleared_row_count
		self:updateSectionTimes(self.lines, new_lines)
		self.lines = math.min(new_lines, 200)
		if self.lines == 200 then
			self.clear = true
			self.roll_frames = -150
		end
	end
end

function MarathonGFGame:getSectionTime()
	return self.frames - self.section_start_time
end

function MarathonGFGame:updateSectionTimes(old_lines, new_lines)
	if math.floor(old_lines / 10) < math.floor(new_lines / 10) then
		-- record new section
		table.insert(self.section_times, self:getSectionTime())
		self.section_start_time = self.frames
	end
end

function MarathonGFGame:updateScore(level, drop_bonus, cleared_lines)
    local normal_table = {[0] = 0, 1, 3, 5, 8}
    local spin_score = 4 * (cleared_lines + 1)
    local all_clear_table = {[0] = 0, 8, 12, 18, 20}

    if self.grid:checkForBravo(cleared_lines) then
        self.score = self.score + (
            ((self.back_to_back and cleared_lines == 4)
            and 32 or all_clear_table[cleared_lines]) *
            100 * (math.floor(self.lines / 10) + 1)
        )
    end

    if cleared_lines > 0 then
        self.score = self.score + (
            self.combo * 50 * (math.floor(self.lines / 10) + 1)
        )
    end

    if self.piece.spin then
        self.score = self.score + (
            spin_score * 100 *
            (math.floor(self.lines / 10) + 1) *
            ((self.back_to_back and cleared_lines ~= 0) and 1.5 or 1)
        )
        if cleared_lines ~= 0 then
            self.back_to_back = true
            self.combo = self.combo + 1
        else self.combo = 0 end
    elseif cleared_lines > 0 then
        self.score = self.score + (
            normal_table[cleared_lines] * 100 *
            (math.floor(self.lines / 10) + 1) *
            ((self.back_to_back and cleared_lines == 4) and 1.5 or 1)
        )
        if cleared_lines == 4 then self.back_to_back = true
        else self.back_to_back = false end
        self.combo = self.combo + 1
    else self.combo = 0 end
end

function MarathonGFGame:onAttemptPieceMove(piece)
    if self.piece ~= nil then
        if not piece:isMoveBlocked(self.grid, { x=-1, y=0 }) and
           not piece:isMoveBlocked(self.grid, { x=1, y=0 }) then
            piece.spin = false
        end
    end
end

function MarathonGFGame:onAttemptPieceRotate(piece)
    if self.piece ~= nil then
       if piece:isDropBlocked(self.grid) and
       piece:isMoveBlocked(self.grid, { x=-1, y=0 }) and 
       piece:isMoveBlocked(self.grid, { x=1, y=0 }) and
       piece:isMoveBlocked(self.grid, { x=0, y=-1 }) then
        piece.spin = true
       else
        piece.spin = false
       end
    end
end

function MarathonGFGame:onPieceLock(piece, cleared_row_count)
    self.super:onPieceLock()
    if self.grid:checkForBravo(cleared_row_count) then
        self.message = "ALL CLEAR!"
    elseif piece.spin then
        self.message = (self.back_to_back and cleared_row_count ~= 0 and "B2B " or "") ..
                       piece.shape .. "-SPIN " ..
                       cleared_row_count .. "!"
    elseif cleared_row_count == 4 then
        self.message = (self.back_to_back and "B2B " or "") ..
                       "QUADRA!"
    elseif cleared_row_count ~= 0 and self.combo > 0 then
        self.message = "COMBO " .. self.combo .. "!"
    else
        self.message = ""
    end
    self.message_timer = 60
end

MarathonGFGame.rollOpacityFunction = function(age)
    return 0.5
end

MarathonGFGame.mRollOpacityFunction = function(age)
    return 0
end

function MarathonGFGame:drawGrid(ruleset)
    if not self.game_over then
        if self.lines >= 200 and self.roll_frames >= self.roll_limit then
            self.grid:drawInvisible(self.rollOpacityFunction)
        elseif self.lines >= 200 then
            self.grid:drawInvisible(self.mRollOpacityFunction)
        else self.grid:draw() end
    else self.grid:draw() end
    self:drawGhostPiece(ruleset)
end

function MarathonGFGame:getHighscoreData()
    return {
        score = self.score,
        frames = self.frames,
    }
end

function MarathonGFGame:getBackground()
    return math.min(19, math.floor(self.lines / 10))
end

function MarathonGFGame:drawScoringInfo()
    love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
    love.graphics.printf("NEXT", 64, 40, 40, "left")
    love.graphics.printf("SCORE", 240, 180, 80, "left")
	love.graphics.printf("LEVEL", 240, 250, 80, "left")
	love.graphics.printf("LINES", 240, 320, 40, "left")

	local current_section = math.floor(self.lines / 10) + 1
    self:drawSectionTimesWithSplits(current_section)
    
    if self.message_timer > 0 then
        love.graphics.printf(self.message, 64, 400, 160, "center")
        self.message_timer = self.message_timer - 1
    end

    love.graphics.setFont(font_3x5_3)
    love.graphics.printf(self.score, 240, 200, 120, "left")
	love.graphics.printf(self.lines, 240, 340, 40, "right")
	love.graphics.printf(self.clear and self.lines or self:getSectionEndLines(), 240, 370, 40, "right")

	if not self.game_over and self.clear and self.roll_frames % 4 < 2 then
		love.graphics.setColor(1, 1, 0.3, 1)
	end
    love.graphics.printf(math.floor(self.lines / 10) + 1, 240, 270, 160, "left")
    love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function MarathonGFGame:getSectionEndLines()
	return math.floor(self.lines / 10 + 1) * 10
end

return MarathonGFGame