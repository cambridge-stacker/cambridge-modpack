local GameMode = require 'tetris.modes.gamemode'
local Bag63Randomiser = require 'tetris.randomizers.bag63'

local SquareMode = GameMode:extend()

SquareMode.name = "Square"
SquareMode.hash = "Square"
SquareMode.tagline = "Make squares to get more lines!"
SquareMode.tags = {"Marathon", "Classic", "Score Attack"}

function SquareMode:new()
    self.super:new()

    self.randomizer = Bag63Randomiser()

    self.square_mode = true
    self.enable_hard_drop = true
    self.enable_hold = true
    self.next_queue_length = 3

    self.irs = false
    self.ihs = false
end

function SquareMode:initialize(ruleset)
    self.super.initialize(self, ruleset)
    self.hold_queue = table.remove(self.next_queue, 1)
	table.insert(self.next_queue, self:getNextPiece(ruleset))
end

function SquareMode:getARE() return 30 end
function SquareMode:getLineARE() return self:getARE() end
function SquareMode:getDasLimit() return 10 end
function SquareMode:getLineClearDelay() return self:getARE() end
function SquareMode:getARR() return 5 end

function SquareMode:getGravity()
    return 1/30 * 1.005 ^ self.lines
end

function SquareMode:getLockDelay()
    return math.ceil(30 * 0.9998 ^ self.lines)
end

function SquareMode:advanceOneFrame()
    if self.ready_frames == 0 then
        self.frames = self.frames + 1
    end
    return true
end

function SquareMode:onPieceLock(piece, cleared_row_count)
    self.super:onPieceLock()
    for _, offset in pairs(piece:getBlockOffsets()) do
        local y = piece.position.y + offset.y
        if y <= 3 then
            self.game_over = true
            return
        end
    end
    self.lines = self.lines + cleared_row_count + (cleared_row_count >= 4 and 1 or 0)
    self.square_table = self.grid:scanForSquares()
    local _, rows_cleared = self.grid:getClearedRowCount()
    for _, row in pairs(rows_cleared) do
        self.lines = self.lines + self.square_table[row]
    end
end

function SquareMode:drawScoringInfo()
    SquareMode.super.drawScoringInfo(self)

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(font_3x5_4)
    love.graphics.printf(self.lines, 240, 160, 150, "left")
    love.graphics.printf(self.squares, 240, 230, 150, "left")

    love.graphics.setFont(font_3x5_2)
    love.graphics.printf("LINES", 240, 200, 150, "left")
    love.graphics.printf("SQUARES", 240, 270, 150, "left")
end

function SquareMode:drawGrid()
    self.grid:draw()
    self:drawGhostPiece()
end

function SquareMode:getHighscoreData()
    return {
        lines = self.lines,
        squares = self.squares,
        frames = self.frames,
    }
end

function SquareMode:getBackground()
    return math.floor(self.lines / 100) % 20
end

return SquareMode
