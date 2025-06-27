local GameMode = require 'tetris.modes.gamemode'
local Grid = require 'tetris.components.grid'
local BagRandomizer = require 'tetris.randomizers.bag7'

local ComboChallenge = GameMode:extend()

ComboChallenge.name = "Combo Challenge"
ComboChallenge.hash = "ComboChallenge"
ComboChallenge.description = "Make the highest combo you can in 30 seconds!"
ComboChallenge.tags = {"Trainer"}

local blk = { skin = "2tie", colour = "A" }

local maps = {
    [1] = {
        [23] = {blk, blk, nil, nil},
        [24] = {blk, nil, nil, nil},
    },
    [2] = {
        [23] = {blk, nil, nil, nil},
        [24] = {blk, blk, nil, nil},
    },
    [3] = {
        [23] = {nil, nil, blk, blk},
        [24] = {nil, nil, nil, blk},
    },
    [4] = {
        [23] = {nil, nil, nil, blk},
        [24] = {nil, nil, blk, blk},
    },
    [5] = {
        [24] = {blk, blk, blk, nil},
    },
    [6] = {
        [24] = {nil, blk, blk, blk},
    },
    [7] = {
        [24] = {blk, blk, nil, blk},
    },
    [8] = {
        [24] = {blk, nil, blk, blk},
    }
}

function ComboChallenge:new()
    GameMode:new()
    self.grid = Grid(4, 24)
    self.grid:applyMap(maps[love.math.random(#maps)])
    self.randomizer = BagRandomizer()
    self.lock_drop = false
    self.lock_hard_drop = false
    self.enable_hold = true
    self.next_queue_length = 6
    self.rta = 0
    self.combo = 0
    self.max_combo = 0
    self.skips = 2
end

function ComboChallenge:getARR() return config.arr end
function ComboChallenge:getARE() return 6 end
function ComboChallenge:getLineARE() return 6 end
function ComboChallenge:getLineClearDelay() return 12 end
function ComboChallenge:getDasLimit() return config.das end
function ComboChallenge:getDasCutDelay() return config.dcd end

-- skip instead of hold
function ComboChallenge:hold(inputs, ruleset, ihs)
	if self.skips <= 0 then return end
    
    -- special ihs case
    if ihs then
        table.remove(self.next_queue, 1)
        table.insert(self.next_queue, self:getNextPiece(ruleset))
    end

    -- skip
	self:initializeNextPiece(inputs, ruleset, table.remove(self.next_queue, 1), false)
    table.insert(self.next_queue, self:getNextPiece(ruleset))
    self.skips = self.skips - 1

	self:onHold()
	if ihs then
		playSE("ihs")
	else
		playSE("hold")
		self:onEnterOrHold(inputs, ruleset)
	end
end

function ComboChallenge:advanceOneFrame()
    if self.ready_frames == 0 then
        self.rta = self.rta + 1
        if self.are == 0 then
            self.frames = self.frames + 1
            if self.frames >= frameTime(0,30) then
                self.game_over = true
            end
        end
    end
end

function ComboChallenge:onPieceLock(piece, cleared_row_count)
    playSE("lock")
    self.skips = math.min(self.skips + 1, 2)
    if cleared_row_count > 0 then
        self.combo = self.combo + 1
        self.max_combo = math.max(self.combo, self.max_combo)
    else
        self.combo = 0
    end
end

function ComboChallenge:drawGrid()
    self.grid:draw()
    self:drawGhostPiece()
end

function ComboChallenge:getHighscoreData()
    return {
        combo = self.max_combo
    }
end

function ComboChallenge:drawScoringInfo()
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
		strTrueValues(self.prev_inputs) ..
		self.drop_bonus
	)

    love.graphics.print("SKIPS", 200, 120)
    love.graphics.print("MAX COMBO", 200, 200)
    love.graphics.print("COMBO", 200, 280)
    
    love.graphics.setFont(font_3x5_4)
    love.graphics.print(self.skips, 200, 140)
    love.graphics.print(self.max_combo, 200, 220)
    love.graphics.print(self.combo, 200, 300)

    love.graphics.setFont(font_8x11)
    love.graphics.setColor(
        (
            self.frames >= frameTime(0,20) and self.rta % 4 < 2 and not self.game_over
        ) and {1, 0.3, 0.3, 1} or {1, 1, 1, 1}
    )
    love.graphics.printf(formatTime(frameTime(0,30) - self.frames), 64, 420, 160, "center")
    love.graphics.setColor(1, 1, 1, 1)
end

return ComboChallenge