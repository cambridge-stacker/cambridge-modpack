local SurvivalA3Game = require 'tetris.modes.survival_a3'

local A3Minus = SurvivalA3Game:extend()

A3Minus.name = "Survival A3-"
A3Minus.hash = "A3Minus"
A3Minus.description = "A training version of Survival A3."

function A3Minus:hitTorikan()
    return false
end

return A3Minus