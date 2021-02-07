local GameMode = require 'tetris.modes.gamemode'
local Grid = require 'tetris.components.grid'

local StackerGame = GameMode:extend()

StackerGame.name = "Stacker"
StackerGame.hash = "Stacker"
StackerGame.tagline = "Hey, wait, I didn't mean this kind of block stacking!"

local block = { skin = "2tie", colour = "C" }

function StackerGame:new()
    self.super:new()
    self.grid = Grid(7, 19)
    self.next_queue_length = 0
    self.ready_frames = 1
    self.row = 19
    self.block_width = 3
    self.position = 0
    self.direction = 1
    self.ticks = 0
    self.are = 30
    self.map = {}
    block.colour = "C"
    self:updateGrid()
end

function StackerGame:getSpeed()
    return 20 ^ ((self.row - 4) / 15)
end

function StackerGame:getMaxBlockWidth()
        if self.row >= 17 then return 3
    elseif self.row >= 11 then return 2
    else return 1 end
end

function StackerGame:updateGrid()
    local width = math.min(self:getMaxBlockWidth(), self.block_width)
    self.grid:clear()
    self.grid:applyMap(self.map)
    for w = 0, width - 1 do
        self.grid.grid[self.row][self.position - w] = block
    end
    for y = 5, 19 do
        for x = 1, 7 do
            self.grid.grid_age[y][x] = 3
        end
    end
end

function StackerGame:advanceOneFrame(inputs, ruleset)
    if self.game_over or self.completed then return true end
    if self.are > 0 then
        self.are = self.are - 1
        return false
    end
    if not self.prev_inputs.up and inputs.up then
        self.prev_inputs = inputs
        local width = math.min(self:getMaxBlockWidth(), self.block_width)
        local new_width = 0
        local row = {}
        for w = 0, width - 1 do
            if self.grid:isOccupied(self.position - w - 1, self.row) and
            self.position - w >= 1 and self.position - w <= 7 then
                new_width = new_width + 1
                row[self.position - w] = block
            end
        end
        if new_width == 0 then
            self.game_over = true
        else
            playSE("lock")
            self.map[self.row] = row
            self.row = self.row - 1
            if self.row <= 8 and self.row >= 5 then
                block.colour = "R"
            elseif self.row <= 4 then
                block.colour = "G"
                self.completed = true
                self:updateGrid()
                return false
            end
            self.ticks = 0
            self.block_width = new_width
            self.position = 0
            self.are = 30
            self:updateGrid()
        end
        return false
    end
    self.ticks = self.ticks + 1
    if self.ticks >= self:getSpeed() then
        self.ticks = self.ticks - self:getSpeed()
        if self.position >= 7 + math.min(self:getMaxBlockWidth(), self.block_width) - 1 then
            self.direction = -1
        elseif self.position <= 1 then
            self.direction = 1
        end
        self.position = self.position + self.direction
        self:updateGrid()
    end
    self.prev_inputs = inputs
    return false
end

local function noOutline(game, block, x, y, age)
    local x = 0.75
    return x, x, x, 1, 0
end

function StackerGame:onGameComplete() end

function StackerGame:drawGrid()
    self.grid:drawCustom(noOutline, self)
end

function StackerGame:drawScoringInfo()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(font_3x5_2)
    love.graphics.print("<-- MAJOR PRIZE", 190, 80)
    love.graphics.print("<-- MINOR PRIZE", 190, 144)
    love.graphics.print("ROWS STACKED", 64, 340)
    love.graphics.print("FRAMES PER MOVE", 64, 400)
    love.graphics.setFont(font_3x5_3)
    love.graphics.print(19 - self.row .. (self.row <= 4 and " - COMPLETE!" or ""), 64, 360)
    love.graphics.print(
        (
            self.row > 4 and
            string.format("%.02f", self:getSpeed()) or
            "N/A"
        ),
        64, 420
    )
end

function StackerGame:getHighscoreData()
    return {
        rows = 19 - self.row,
    }
end

return StackerGame