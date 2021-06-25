local SurvivalA3Game = require 'tetris.modes.survival_a3'

local A3Plus = SurvivalA3Game:extend()

A3Plus.name = "Survival A3+"
A3Plus.hash = "A3Plus"
A3Plus.tagline = "A hardcore version of Survival A3."

function A3Plus:new()
    A3Plus.super:new()
    self.next_queue_length = 1
    self.enable_hold = false
end

return A3Plus