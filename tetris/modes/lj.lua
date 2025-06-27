local GameMode = require 'tetris.modes.gamemode'
local Bag7Randomizer = require 'tetris.randomizers.bag7'

local MarathonWLJGame = GameMode:extend()

MarathonWLJGame.name = "Marathon WLJ"
MarathonWLJGame.hash = "MarathonWLJ"
MarathonWLJGame.description = "A simple marathon mode, originating from Lockjaw."
MarathonWLJGame.tags = {"Marathon", "Web"}

function MarathonWLJGame:new()
    GameMode:new()
    
    self.lock_drop = true
	self.lock_hard_drop = true
	self.instant_hard_drop = true
	self.instant_soft_drop = false
	self.enable_hold = true
    self.next_queue_length = 6
    self.randomizer = Bag7Randomizer()
    
    self.pieces = 0
    self.b2b = false
    self.immobile_spin_bonus = true

    self.message = ""
    self.message_timer = 0
end

function MarathonWLJGame:getARE() return 6 end
function MarathonWLJGame:getLineARE() return 6 end
function MarathonWLJGame:getLineClearDelay() return 24 end
function MarathonWLJGame:getDasLimit() return config.das end
function MarathonWLJGame:getARR() return config.arr end
function MarathonWLJGame:getDasCutDelay() return config.dcd end

function MarathonWLJGame:getGravity()
    if self.pieces < 609 then
        return (1/60) * (259/256) ^ self.pieces
    else
        return 20
    end
end

function MarathonWLJGame:getLockDelay()
    if self.pieces >= 609 then
        return math.ceil(40 / (1 + (3/256) * (self.pieces - 609)))
    else
        return 40
    end
end

function MarathonWLJGame:onSoftDrop(dropped_row_count)
    self.score = self.score + dropped_row_count
end

function MarathonWLJGame:onHardDrop(dropped_row_count)
    self.score = self.score + 2 * dropped_row_count
end

function MarathonWLJGame:onPieceLock(piece, cleared_row_count)
    playSE("lock")
    self.pieces = self.pieces + 1
    self.lines = self.lines + cleared_row_count
    if piece.spin then
        self.score = self.score + (
            500 * cleared_row_count +
            (self.b2b and cleared_row_count > 0 and 200 or 0)
        )
        self.message = (
            ((self.b2b and cleared_row_count > 0) and "B2B " or "") ..
            (type(piece.shape) == "string" and piece.shape .. "-" or "") ..
            "SPIN " .. cleared_row_count .. "!"
        )
        if cleared_row_count > 0 then self.b2b = true end
    elseif cleared_row_count > 0 then
        local score_table = {100, 400, 700, 1200}
        self.score = self.score + (
            score_table[math.min(cleared_row_count, 4)] +
            (self.b2b and cleared_row_count >= 4 and 200 or 0)
        )
        self.message = cleared_row_count >= 4 and (
            (self.b2b and "B2B " or "") ..
            string.upper(string.sub(
                number_names[cleared_row_count * 3 + 3], 1, -7
            )) .. "A!"
        ) or ""
        self.b2b = cleared_row_count >= 4
    else
        self.message = ""
    end
    self.message_timer = 60
end

function MarathonWLJGame:advanceOneFrame()
    if self.ready_frames == 0 then
        self.frames = self.frames + 1
    end
    return true
end

function MarathonWLJGame:drawGrid()
    self.grid:draw()
    self:drawGhostPiece()
end

function MarathonWLJGame:getHighscoreData()
	return {
		score = self.score,
		pieces = self.pieces,
		frames = self.frames,
	}
end

function MarathonWLJGame:getSectionEndLevel()
	return math.floor(self.pieces / 30 + 1) * 30
end

function MarathonWLJGame:getBackground()
	return math.floor(self.pieces / 30) % 20
end

function MarathonWLJGame:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
    love.graphics.printf("LINES", 240, 120, 40, "left")
	love.graphics.printf("SCORE", 240, 200, 40, "left")
	love.graphics.printf("LEVEL", 240, 320, 40, "left")

    if self.message_timer > 0 then
        love.graphics.printf(self.message, 64, 400, 160, "center")
        self.message_timer = self.message_timer - 1
    end

	love.graphics.setFont(font_3x5_3)
    love.graphics.printf(self.lines, 240, 140, 90, "left")
	love.graphics.printf(self.score, 240, 220, 90, "left")
	love.graphics.printf(self.pieces, 240, 340, 50, "right")
	love.graphics.printf(self:getSectionEndLevel(), 240, 370, 50, "right")

	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

return MarathonWLJGame