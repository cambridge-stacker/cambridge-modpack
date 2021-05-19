local SurvivalAXHGame = require 'tetris.modes.survival_axh'

local SurvivalAXH2Game = SurvivalAXHGame:extend()

SurvivalAXH2Game.name = "Survival AXH2"
SurvivalAXH2Game.hash = "SurvivalAXH2"
SurvivalAXH2Game.tagline = "Hellish speeds, fading blocks!"

function SurvivalAXH2Game:getSkin()
    return "bone"
end

function SurvivalAXH2Game:getFadeoutTime()
        if self.lines >= 190 then return 60
    elseif self.lines >= 150 then return 120
    elseif self.lines >= 50  then return 150
    end
end

local function rollOpacityFunction(game, block, x, y, age)
    local opacity
    if age < game:getFadeoutTime() then opacity = 1
    elseif age >= game:getFadeoutTime() + 60 then opacity = 0
    else opacity = 1 - (age - game:getFadeoutTime()) / 60 end
    return 0.5, 0.5, 0.5, opacity, 0
end

function SurvivalAXH2Game:drawGrid()
    if self:getFadeoutTime() then
        self.grid:drawCustom(rollOpacityFunction, self)
    else
        self.grid:draw()
    end
end

return SurvivalAXH2Game