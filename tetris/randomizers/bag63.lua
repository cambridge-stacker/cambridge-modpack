local Randomizer = require 'tetris.randomizers.randomizer'

local Bag63Randomiser = Randomizer:extend()

function Bag63Randomiser:initialize()
    self.bag = {}
end

function Bag63Randomiser:generatePiece()
    if next(self.bag) == nil then
        self.bag = {
            "I", "I", "I", "I", "I", "I", "I", "I", "I",
            "T", "T", "T", "T", "T", "T", "T", "T", "T", 
            "L", "L", "L", "L", "L", "L", "L", "L", "L",
            "J", "J", "J", "J", "J", "J", "J", "J", "J",
            "S", "S", "S", "S", "S", "S", "S", "S", "S",
            "Z", "Z", "Z", "Z", "Z", "Z", "Z", "Z", "Z",
            "O", "O", "O", "O", "O", "O", "O", "O", "O",
        }
    end
    return table.remove(self.bag, love.math.random(#self.bag))
end

return Bag63Randomiser