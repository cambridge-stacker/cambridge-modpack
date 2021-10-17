local MarathonA1Game = require 'tetris.modes.marathon_a1'
local Grid = require 'tetris.components.grid'
local SplitHistoryRandomizer = require 'tetris.randomizers.split_history'

local DualityA1Game = MarathonA1Game:extend()

DualityA1Game.name = "Duality A1"
DualityA1Game.hash = "DualityA1"
DualityA1Game.tagline = "Control two boards at once!"

function DualityA1Game:new()
    DualityA1Game.super:new()
    self.randomizer = SplitHistoryRandomizer()
    self.other_grid = Grid(10, 24)
    self.next_queue_length = 2
end

function DualityA1Game:updateScore(level, drop_bonus, cleared_lines)
    if not self.clear then
		if self.grid:checkForBravo(cleared_lines) then
			self.bravo = 4
			self.bravos = self.bravos + 1
		else self.bravo = 1 end
		if cleared_lines > 0 then
			self.combo = self.combo + (cleared_lines - 1) * 2
			self.score = self.score + (
				(math.ceil((level + cleared_lines) / 4) + drop_bonus) *
				cleared_lines * self.combo * self.bravo
			)
		else
			self.combo = 1
		end
		self.drop_bonus = 0
	end
    if cleared_lines ~= 0 then return end
    self.grid, self.other_grid = self.other_grid, self.grid
end

function DualityA1Game:afterLineClear(cleared_row_count)
    self.grid, self.other_grid = self.other_grid, self.grid
end

local function fadeOut(game, block, x, y, age)
    local opacity = game.are / (game:getARE() / 2) - 1
    return 0.5, 0.5, 0.5, opacity, opacity
end

local function fadeIn(game, block, x, y, age)
    local opacity = game.are / (game:getARE() / 2) - 1
    return 0.5, 0.5, 0.5, 1 - opacity, 1 - opacity
end

function DualityA1Game:drawGrid()
    if self.lcd == 0 and self.are > 0 then
        self.grid:drawCustom(fadeIn, self)
        self.other_grid:drawCustom(fadeOut, self)
    else
        self.grid:draw()
    end
    if self.piece ~= nil and self.level < 100 then
        self:drawGhostPiece()
    end
end

return DualityA1Game