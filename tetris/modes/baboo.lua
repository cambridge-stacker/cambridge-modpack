local GameMode = require 'tetris.modes.gamemode'
local Bag7Randomizer = require 'tetris.randomizers.bag7'

local MarathonWBGame = GameMode:extend()

MarathonWBGame.name = "Marathon WB"
MarathonWBGame.hash = "MarathonWB"
MarathonWBGame.tagline = "What can you do with 300 keystrokes?"
MarathonWBGame.tags = {"Marathon", "Web", "Gimmick"}

function MarathonWBGame:new()
    GameMode:new()
    
    self.lock_drop = true
	self.lock_hard_drop = true
	self.instant_hard_drop = true
	self.instant_soft_drop = false
	self.enable_hold = true
    self.next_queue_length = 6
    self.randomizer = Bag7Randomizer()
    
    self.keystrokes = 0
    self.pieces = 0
    self.b2b = false
    self.immobile_spin_bonus = true

    self.message = ""
    self.message_timer = 0
end

function MarathonWBGame:getARE() return 0 end
function MarathonWBGame:getLineARE() return 0 end
function MarathonWBGame:getLineClearDelay() return 0 end
function MarathonWBGame:getDasLimit() return config.das end
function MarathonWBGame:getARR() return config.arr end
function MarathonWBGame:getDasCutDelay() return config.dcd end
function MarathonWBGame:getGravity() return 0 end

function MarathonWBGame:onSoftDrop(dropped_row_count)
    self.score = self.score + dropped_row_count
end

function MarathonWBGame:onHardDrop(dropped_row_count)
    self.score = self.score + 2 * dropped_row_count
end

function MarathonWBGame:onPieceLock(piece, cleared_row_count)
    playSE("lock")
    self.pieces = self.pieces + 1
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

function MarathonWBGame:advanceOneFrame(inputs, ruleset)
    if self.ready_frames == 0 then
        self.frames = self.frames + 1
        for input, value in pairs(inputs) do
            if value and not self.prev_inputs[input] then
                self.keystrokes = self.keystrokes + 1
                self.game_over = self.keystrokes >= 300
            end
        end
    end
    return true
end

function MarathonWBGame:drawGrid()
    self.grid:draw()
    self:drawGhostPiece()
end

function MarathonWBGame:drawScoringInfo()
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

    love.graphics.print("SCORE", 240, 140)
    love.graphics.print("KEYSTROKES", 240, 200)
    love.graphics.print("keys/piece", 240, 270)

    if self.message_timer > 0 then
        love.graphics.printf(self.message, 64, 400, 160, "center")
        self.message_timer = self.message_timer - 1
    end

    love.graphics.setFont(font_3x5_3)
    love.graphics.print(self.score, 240, 160)
    love.graphics.print(
        string.format("%.04f", self.keystrokes / math.max(self.pieces, 1)),
        240, 290
    )
    love.graphics.print("B2B " .. tostring(self.b2b), 240, 330)

	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")

    love.graphics.setFont(font_3x5_4)
    love.graphics.print(math.max(300 - self.keystrokes, 0), 240, 220)
    
end

function MarathonWBGame:getHighscoreData()
    return {
        score = self.score
    }
end

return MarathonWBGame