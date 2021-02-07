local GameMode = require 'tetris.modes.gamemode'
local Grid = require 'tetris.components.grid'

local Snake = GameMode:extend()

Snake.name = "Snake"
Snake.hash = "Snake"
Snake.tagline = "...It's literally just snake."

local moves = {
    ["right"] = {x=1, y=0},
    ["left"] = {x=-1, y=0},
    ["up"] = {x=0, y=-1},
    ["down"] = {x=0, y=1},
}

function Snake:new()
    self.super:new()
    self.grid = Grid(25, 24)
    self.next_queue_length = 0
    self.ready_frames = 1
    self.ticks = 60
    self.direction = "right"
    self.last_move = "right"
    self.snake = {
        {x=11, y=15},
        {x=12, y=15},
        {x=13, y=15},
        {x=14, y=15},
    }
    self.gem = {x=1, y=5}
    self:generateGem()
    self:updateGrid()
end

function Snake:isInSnake(p)
    for _, point in pairs(self.snake) do
        if point.x == p.x and point.y == p.y then
            return true
        end
    end
    return false
end

function Snake:updateGrid()
    local snake = { skin = "2tie", colour = "G" }
    local gem = { skin = "gem", colour = "R" }
    self.grid:clear()
    self.grid.grid[self.gem.y][self.gem.x] = gem
    for y = 5, 24 do
        for x = 1, 25 do
            if self:isInSnake({x=x, y=y}) then
                self.grid.grid[y][x] = snake
            end
            self.grid.grid_age[y][x] = 3
        end
    end
end

function Snake:generateGem()
    repeat
        self.gem.x = math.random(1, 25)
        self.gem.y = math.random(5, 24)
    until not self:isInSnake({x=self.gem.x, y=self.gem.y})
end

function Snake:advanceOneFrame(inputs, ruleset)
    if self.game_over or self.completed then return true end
    if self.last_move ~= "left" and not self.prev_inputs.right and inputs.right then
        self.direction = "right"
    elseif self.last_move ~= "right" and not self.prev_inputs.left and inputs.left then
        self.direction = "left"
    elseif self.last_move ~= "down" and not self.prev_inputs.up and inputs.up then
        self.direction = "up"
    elseif self.last_move ~= "up" and not self.prev_inputs.down and inputs.down then
        self.direction = "down"
    end
    self.ticks = self.ticks - 1
    if self.ticks <= 0 then
        local move = moves[self.direction]
        local new_x = self.snake[#self.snake].x + move.x
        local new_y = self.snake[#self.snake].y + move.y
        if (
            new_x < 1 or new_x > 25 or new_y < 5 or new_y > 24 or
            self:isInSnake({x=new_x, y=new_y})
        ) then
            self.game_over = true
        else
            table.insert(self.snake, {
                x = new_x,
                y = new_y,
            })
            if new_x == self.gem.x and new_y == self.gem.y then
                if #self.snake >= 500 then
                    self.completed = true
                    self:updateGrid()
                    return false
                else
                    self:generateGem()
                end
            else
                table.remove(self.snake, 1)
            end
            self:updateGrid()
            self.last_move = self.direction
            self.ticks = 10
        end
    end
    self.prev_inputs = inputs
    return false
end

local function noOutline(game, block, x, y, age)
    local x = 0.75
    return x, x, x, 1, 0
end

function Snake:drawGrid()
    self.grid:drawCustom(noOutline, self)
end

function Snake:drawScoringInfo()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(font_3x5_2)
    love.graphics.print("SNAKE LENGTH", 480, 130)
    love.graphics.print("GEM LOCATION", 480, 210)
    love.graphics.setFont(font_3x5_3)
    love.graphics.print(#self.snake, 480, 150)
    love.graphics.print(self.gem.x .. ", " .. self.gem.y - 4, 480, 230)
end

function Snake:getHighscoreData()
    return {
        snake_length = #self.snake,
    }
end

return Snake