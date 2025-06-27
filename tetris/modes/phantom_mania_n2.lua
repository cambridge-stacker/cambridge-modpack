local SurvivalA3Game = require 'tetris.modes.survival_a3'

local PhantomManiaN2Game = SurvivalA3Game:extend()

PhantomManiaN2Game.name = "Phantom Mania N2"
PhantomManiaN2Game.hash = "PhantomManiaN2"
PhantomManiaN2Game.description = "As PM1 is to Death, PM2 is to Shirase."
PhantomManiaN2Game.tags = {"Invisible Stack", "Survival", "Gimmick", "Cambridge"}

PhantomManiaN2Game.rollOpacityFunction = function(age)
	if age > 4 then return 0
	else return 1 - age / 4 end
end

PhantomManiaN2Game.garbageOpacityFunction = function(age)
	return age > 4 and 0 or 1
end

function PhantomManiaN2Game:canDrawLCA()
    return self.level < 1000 and self.lcd > 0
end

function PhantomManiaN2Game:drawGrid()
    if not (self.game_over or self.completed) then
        self.grid:drawInvisible(
            self.rollOpacityFunction,
            self.garbageOpacityFunction,
            self.level < 1000
        )
    elseif self.game_over or self.completed then
        self.grid:draw()
    end
end

return PhantomManiaN2Game