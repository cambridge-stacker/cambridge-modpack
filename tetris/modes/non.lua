require 'funcs'

bgm.non = {
    start = love.audio.newSource("res/bgm/non-start.ogg", "stream"),
    loop = love.audio.newSource("res/bgm/non-loop.ogg", "stream"),
}

local GameMode = require 'tetris.modes.gamemode'

local Bag7NoSZOStartRandomizer = require 'tetris.randomizers.bag7noSZOstart'

local NightOfNights = GameMode:extend()

NightOfNights.name = "Night of Nights"
NightOfNights.hash = "NightOfNights"
NightOfNights.tagline = "The pieces lock down super fast! How long can you survive?"

function NightOfNights:new()
    self.super:new()

    self.active_time = 0
    self.pieces = 0

    self.randomizer = Bag7NoSZOStartRandomizer()

    self.lock_drop = true
    self.lock_hard_drop = true
    self.lock_on_soft_drop = false
    self.lock_on_hard_drop = false
    self.enable_hold = true
    self.next_queue_length = 6
end

function NightOfNights:getARE() return 0 end
function NightOfNights:getLineARE() return 0 end
function NightOfNights:getLineClearDelay() return 0 end
function NightOfNights:getDasLimit() return config.das end
function NightOfNights:getARR() return config.arr end
function NightOfNights:getGravity() return 20 end

function NightOfNights:advanceOneFrame()
    if self.ready_frames == 0 then
        if self.frames == 0 then
            switchBGM("non", "start")
        elseif self.frames == 1280 then
            switchBGMLoop("non", "loop")
        end
        self.frames = self.frames + 1
    else
        self.lock_on_soft_drop = false
        self.lock_on_hard_drop = false
        switchBGM(nil)
    end
end

function NightOfNights:whilePieceActive()
    self.active_time = self.active_time + 1
    if self.active_time >= 20 then self.piece.locked = true end
end

function NightOfNights:onPieceLock(piece, cleared_row_count)
    self.super:onPieceLock()
    self.active_time = 0
    self.pieces = self.pieces + 1
    self.lines = self.lines + cleared_row_count
end

function NightOfNights:drawGrid()
    self.grid:draw()
end

function NightOfNights:drawScoringInfo()
    love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
        strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
    love.graphics.printf("LINES", 240, 160, 80, "left")
    love.graphics.printf("PIECES", 240, 240, 80, "left")

	love.graphics.setFont(font_3x5_4)
    love.graphics.printf(self.lines, 240, 180, 90, "left")
    love.graphics.printf(self.pieces, 240, 260, 90, "left")

	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function NightOfNights:getBackground()
    return 19
end

function NightOfNights:getHighscoreData()
    return {
        lines = self.lines,
        pieces = self.pieces,
        frames = self.frames,
    }
end

return NightOfNights