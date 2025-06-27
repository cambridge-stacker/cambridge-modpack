local ARS = require 'tetris.rulesets.arika'

local Sega = ARS:extend()

Sega.name = "Sega Rotation"
Sega.hash = "Sega"
Sega.description = "What many regard as the Japanese standard for block-stacking games."

function Sega:attemptWallkicks() end

return Sega
