require 'funcs'

local MarathonC88Game = require 'tetris.modes.marathon_c88'

local SurvivalC88Game = MarathonC88Game:extend()

SurvivalC88Game.name = "Survival C88"
SurvivalC88Game.hash = "Shimizu"
SurvivalC88Game.tagline = "You can't rotate the pieces initially! What will you do?"

function SurvivalC88Game:getGravity()
    return 20
end

return SurvivalC88Game