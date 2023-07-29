require 'funcs'

local GameMode = require 'tetris.modes.gamemode'

local Bag7Randomizer = require 'tetris.randomizers.bag7'

local LudicrousSpeed = GameMode:extend()

LudicrousSpeed.name = "Ludicrous Speed"
LudicrousSpeed.hash = "LSpeed"
LudicrousSpeed.tagline = "Don't make Keanu sad. Always stay above the speed limit."

function LudicrousSpeed:new()
    self.super:new()

    self.time_limit = 300
    self.delays = {}
    self.last_piece = 0
    self.pps_limit = 1

    self.randomizer = Bag7Randomizer()

    self.lock_drop = true
    self.lock_hard_drop = true
    self.instant_soft_drop = false
    self.instant_hard_drop = true
    self.enable_hold = true
    self.next_queue_length = 6
end

local function mean(t)
    local sum = 0
    
    for _, v in pairs(t) do
        sum = sum + v
    end

    return sum / #t
end

function LudicrousSpeed:getGravity()
    if self.lines < 180 then
        return (0.8 - (math.floor(self.lines / 10) * 0.007)) ^ -math.floor(self.lines / 10) / 60
    else return 20 end
end

function LudicrousSpeed:getARE() return 0 end
function LudicrousSpeed:getLineARE() return 0 end
function LudicrousSpeed:getLineClearDelay() return 0 end
function LudicrousSpeed:getDasLimit() return config.das end
function LudicrousSpeed:getARR() return config.arr end
function LudicrousSpeed:getDasCutDelay() return config.dcd end
function LudicrousSpeed:getDropSpeed() return 20 end

function LudicrousSpeed:getPPS()
    if #self.delays == 0 then return 0 end
    local delays = copy(self.delays)
    delays[0] = self.frames - self.last_piece
    return 60 / mean(delays)
end

function LudicrousSpeed:advanceOneFrame()
    if self.ready_frames == 0 then
        self.frames = self.frames + 1
        if self.frames > 60 and self:getPPS() < self.pps_limit then
            self.time_limit = self.time_limit - 1
            self.game_over = self.time_limit <= 0
        else self.time_limit = 300 end
    end
    return true
end

function LudicrousSpeed:onPieceLock(...)
    self.super:onPieceLock(...)
    self.delays[#self.delays + 1] = self.frames - self.last_piece
    if #self.delays >= 25 then
        table.remove(self.delays, 1)
    end
    self.last_piece = self.frames
end

function LudicrousSpeed:onLineClear(cleared_row_count)
    self.lines = self.lines + cleared_row_count
    self.pps_limit = 1 + math.floor(self.lines / 10) / 10
end

function LudicrousSpeed:drawGrid()
    self.grid:draw()
    self:drawGhostPiece()
end

function LudicrousSpeed:drawScoringInfo()
    love.graphics.setColor(1, 1, 1, 1)

    local text_x = config["side_next"] and 320 or 240
	
	love.graphics.setFont(font_3x5_2)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("LINES", text_x, 120, 80, "left")
    love.graphics.printf("piece/sec", text_x, 180, 80, "left")
    love.graphics.printf("REQUIRED PPS", text_x, 240, 120, "left")
    if self.time_limit < 300 then
        if self.time_limit % 4 < 2 and self.time_limit ~= 0 then
            love.graphics.setColor(1, 0.3, 0.3, 1)
        end
        love.graphics.printf("SPEED UP!", text_x, 300, 120, "left")
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs) ..
		self.drop_bonus
	)
    
    love.graphics.setFont(font_3x5_4)
    if self.time_limit < 300 then
        love.graphics.printf(formatTime(self.time_limit):sub(-4, -1), text_x, 320, 160, "left")
    end
    
    love.graphics.setFont(font_3x5_3)
	love.graphics.printf(self.lines, text_x, 140, 80, "left")
    love.graphics.printf(("%.02f"):format(self:getPPS()), text_x, 200, 80, "left")
    love.graphics.printf(("%.02f"):format(self.pps_limit), text_x, 260, 80, "left")

    love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function LudicrousSpeed:getBackground()
    return math.floor(self.lines / 10)
end

function LudicrousSpeed:getHighscoreData()
    return {
        lines = self.lines,
        frames = self.frames,
    }
end

return LudicrousSpeed
