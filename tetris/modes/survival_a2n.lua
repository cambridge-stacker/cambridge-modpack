local SurvivalA2Game = require 'tetris.modes.survival_a2'

local SurvivalA2NGame = SurvivalA2Game:extend()

SurvivalA2NGame.name = "Survival A2N"
SurvivalA2NGame.hash = "SurvivalA2N"
SurvivalA2NGame.tagline = "A variation of Survival A2 for Carnival of Derp."

function SurvivalA2NGame:new()
    self.super:new()
    self.next_queue_length = 3
    self.enable_hold = true
end

return SurvivalA2NGame