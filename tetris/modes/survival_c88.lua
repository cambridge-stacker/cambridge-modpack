require 'funcs'

local MarathonC88Game = require 'tetris.modes.marathon_c88'

local SurvivalC88Game = MarathonC88Game:extend()

SurvivalC88Game.name = "Survival C88"
SurvivalC88Game.hash = "Shimizu"
SurvivalC88Game.description = "You can't rotate the pieces initially! What will you do?"
SurvivalC88Game.tags = {"Survival", "Classic", "Web", "20G Start"}

function SurvivalC88Game:new(secret_inputs)
    self.super:new(secret_inputs)
end

function SurvivalC88Game:getGravity()
    return 20
end

return SurvivalC88Game