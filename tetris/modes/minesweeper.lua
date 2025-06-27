local GameMode = require 'tetris.modes.gamemode'
local Grid = require 'tetris.components.grid'

local Minesweeper = GameMode:extend()

Minesweeper.name = "Minesweeper"
Minesweeper.hash = "Minesweeper"
Minesweeper.description = "Avoid the exploding mines!"

local width = 15
local height = 15

function Minesweeper:new()
    self.super:new()
    self:initializeGrid()
    self.menu_state = 1
    self.mines = {}
    self.cursor = {x=1, y=1}
    self.first_move = true
    self.ready_frames = 1
    self.next_queue_length = 0
end

function Minesweeper:isMine(x, y)
    for _, mine in pairs(self.mines) do
        if mine.x == x and mine.y == y then
            return true
        end
    end
    return false
end

function Minesweeper:initializeGrid()
    self.grid = Grid(width, height + 4)
    self.flags = math.floor(0.15 * width * height)
    self.chosen_colour = ({ "R", "O", "Y", "G", "C", "B", "M" })[love.math.random(7)]
    for y = 1, height do
        for x = 1, width do
            self.grid.grid[y+4][x] = { skin = "2tie", colour = self.chosen_colour }
        end
    end
end

function Minesweeper:initializeMines(sel_x, sel_y)
    for i = 1, self.flags do
        local x, y
        repeat
            x = love.math.random(1, width)
            y = love.math.random(1, height)
        until not (self:isMine(x, y) or (sel_x == x and sel_y == y))
        table.insert(self.mines, {x=x, y=y})
    end
end

function Minesweeper:advanceOneFrame(inputs, ruleset)
    if self.menu_state ~= 0 then
        self:menuLoop(inputs)
        return false
    elseif self.game_over or self.completed or self.ready_frames > 1 then
        return true
    else
        self:mainGameLoop(inputs)
        return false
    end
end

function Minesweeper:menuLoop(inputs)
    if not self.prev_inputs.right and inputs.right then
        if self.menu_state == 1 then
            width = math.min(width + 1, 28)
        else
            height = math.min(height + 1, 22)
        end
        self:initializeGrid()
    elseif not self.prev_inputs.left and inputs.left then
        if self.menu_state == 1 then
            width = math.max(width - 1, 8)
        else
            height = math.max(height - 1, 8)
        end
        self:initializeGrid()
    elseif (not self.prev_inputs.down and inputs.down) or
    (not self.prev_inputs.up and inputs.up) then
        self.menu_state = -self.menu_state
    end
    if not self.prev_inputs.rotate_left and inputs.rotate_left then
        self.ready_frames = 100
        self.menu_state = 0
    end
    self.prev_inputs = inputs
end

function Minesweeper:mainGameLoop(inputs)
    self:moveCursor(inputs)
    if not self.prev_inputs.rotate_left and inputs.rotate_left and
    self.grid.grid[self.cursor.y+4][self.cursor.x].colour ~= "W" and
    self.grid.grid[self.cursor.y+4][self.cursor.x].colour ~= "D" then
        playSE("lock")
        if not self:isMine(self.cursor.x, self.cursor.y) then
            self:uncoverCell(self.cursor.x, self.cursor.y)
        else
            self.game_over = true
        end
    end
    if not self.prev_inputs.rotate_right and inputs.rotate_right then
        self:flagCell(self.cursor.x, self.cursor.y)
    end
    self:updateFlagCount()
    self.frames = self.frames + 1
    self.prev_inputs = inputs
end

function Minesweeper:updateFlagCount()
    local flags = math.floor(0.15 * width * height)
    for y = 5, height + 4 do
        for x = 1, width do
            if self.grid.grid[y][x].colour == "D" then
                flags = flags - 1
            end
        end
    end
    self.flags = flags
end

function Minesweeper:moveCursor(inputs)
    if not self.prev_inputs.right and inputs.right then
        self.cursor.x = math.min(self.cursor.x + 1, width)
    elseif not self.prev_inputs.left and inputs.left then
        self.cursor.x = math.max(self.cursor.x - 1, 1)
    elseif not self.prev_inputs.down and inputs.down then
        self.cursor.y = math.min(self.cursor.y + 1, height)
    elseif not self.prev_inputs.up and inputs.up then
        self.cursor.y = math.max(self.cursor.y - 1, 1)
    end
end

function Minesweeper:flagCell(x, y)
    if self.flags > 0 and self.grid.grid[y+4][x].skin == "2tie" and
    self.grid.grid[y+4][x].colour ~= "W" then
        self.grid.grid[y+4][x] = {
            skin = "gem", colour = "D"
        }
    elseif self.grid.grid[y+4][x].skin == "gem" then
        self.grid.grid[y+4][x] = {
            skin = "2tie", colour = self.chosen_colour
        }
    end
end

function Minesweeper:uncoverCell(x, y)
    if self.first_move then
        self:initializeMines(x, y)
        self.first_move = false
    end
    
    local stack = {
        {
            x = x,
            y = y,
        }
    }

    while #stack > 0 do
        local current = table.remove(stack)
        local x = current.x
        local y = current.y

        self.grid.grid[y+4][x] = { skin = "2tie", colour = "W" }

        if self:getSurroundingMineCount(x, y) == 0 then
            for dy = -1, 1 do
                for dx = -1, 1 do
                    if not (dx == 0 and dy == 0) and
                    x+dx >= 1 and x+dx <= width and
                    y+dy >= 1 and y+dy <= height and
                    self.grid.grid[y+4+dy][x+dx].colour ~= "W"
                    then
                        table.insert(stack, {
                            x = x + dx,
                            y = y + dy,
                        })
                    end
                end
            end
        end
    end

    for y = 5, height + 4 do
        for x = 1, width do
            if self.grid.grid[y][x].colour ~= "W" and
            not self:isMine(x, y-4) then
                return
            end
        end
    end

    self.completed = true
end

function Minesweeper:getSurroundingMineCount(x, y)
    local mines = 0
    for dy = -1, 1 do
        for dx = -1, 1 do
            if not (dx == 0 and dy == 0) and self:isMine(x+dx, y+dy) then
                mines = mines + 1
            end
        end
    end
    return mines
end

function Minesweeper:onGameOver()
    for y = 5, height + 4 do
        for x = 1, width do
            if self:isMine(x, y-4) then
                self.grid.grid[y][x] = { skin = "gem", colour = "R" }
            else
                self.grid.grid[y][x] = { skin = "2tie", colour = "W" }
            end
        end
    end
end

function Minesweeper:onGameComplete()
    self:onGameOver()
    love.graphics.setColor(
        self.game_over_frames % 4 < 2 and
        {0.3, 1, 0.3, 1} or
        {1, 1, 1, 1}
    )
    love.graphics.setFont(font_3x5_3)
    love.graphics.print("GOOD JOB!", 80 + 16 * width, 280)
end

local function opacityFunction(game, block, x, y, age)
    if block.colour == "W" then
        return 0.5, 0.5, 0.5, 1, 1
    else
        return 1, 1, 1, 1, 1
    end
end

function Minesweeper:drawGrid()
    self.grid:drawCustom(opacityFunction, self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(font_3x5_2)
    love.graphics.setLineWidth(2)
    for y = 5, height + 4 do
        for x = 1, width do
            if self.cursor.x == x and self.cursor.y + 4 == y then
                love.graphics.rectangle("line", 48+x*16, y*16, 16, 16)
            end
            if self:getSurroundingMineCount(x, y-4) ~= 0 and
            self.grid.grid[y][x].colour == "W" then
                love.graphics.print(self:getSurroundingMineCount(x, y-4), 50+x*16, -2+y*16)
            end
        end
    end    
end

function Minesweeper:drawScoringInfo()
    love.graphics.setColor(1, 1, 1, 1)
    
    local x = 80 + 16 * width
    love.graphics.setFont(font_3x5_2)
    love.graphics.print("DIMENSIONS", x, 100)
    love.graphics.print("FLAGS", x, 160)
    love.graphics.print("TIME ELAPSED", x, 220)
    love.graphics.setFont(font_3x5_3)
    love.graphics.print(width .. " x " .. height, x, 120)
    love.graphics.print(self.flags, x, 180)
    love.graphics.print(formatTime(self.frames), x, 240)
end

function Minesweeper:drawCustom()
    if self.menu_state ~= 0 then
        love.graphics.setFont(font_3x5_3)
        love.graphics.setColor(
            self.menu_state == 1 and
            {1, 1, 0.3, 1} or
            {1, 1, 1, 1}
        )
        love.graphics.print("WIDTH: " .. width, 67, 100)
        love.graphics.setColor(
            self.menu_state == -1 and
            {1, 1, 0.3, 1} or
            {1, 1, 1, 1}
        )
        love.graphics.print("HEIGHT: " .. height, 67, 140)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return Minesweeper