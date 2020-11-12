local ARS = require 'tetris.rulesets.arika'

local Sega = ARS:extend()

Sega.name = "Sega Rotation"
Sega.hash = "Sega"

function Sega:attemptWallkicks() end

return Sega
