local GameMode = require 'tetris.modes.gamemode'
local SurvivalA3Game = require 'tetris.modes.survival_a3'

local A3Minus = SurvivalA3Game:extend()

A3Minus.name = "Survival A3-"
A3Minus.hash = "A3Minus"
A3Minus.tagline = "A training version of Survival A3."

function A3Minus:initialize(ruleset)
    self.torikan_time = math.huge
    GameMode.initialize(self, ruleset)
end

return A3Minus