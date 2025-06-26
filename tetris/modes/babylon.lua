local MarathonGFGame = require 'tetris.modes.marathon_gf'

local BabylonMarathonGame = MarathonGFGame:extend()

BabylonMarathonGame.name = "Babylon Marathon"
BabylonMarathonGame.hash = "BabylonMarathon"
BabylonMarathonGame.tagline = "Help my blocks are ascending what do I do"
BabylonMarathonGame.tags = {"Marathon", "Web", "Gimmick"}

function BabylonMarathonGame:afterLineClear(cleared_row_count)
    for i = 1, cleared_row_count do
        self.grid:garbageRise({
            "e", "e", "e", "e", "e", "e", "e", "e", "e", "e"
        })
    end
end

return BabylonMarathonGame