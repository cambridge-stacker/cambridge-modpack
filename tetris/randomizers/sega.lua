local Randomizer = require 'tetris.randomizers.randomizer'

local SegaRandomizer = Randomizer:extend()
local seed=711800410 -- all sega starts with this seed. preserved here for future modification
local dummy=0
function SegaRandomizer:initialize()
        seed=love.math.random(0,268435455)*16+10  -- pick a valid Sega seed, using love.math.random so it will work in replays. 
	                                          -- When starting with seed 711800410, the period is maximum length, so we can randomly select the bits that change.
        self.bag = {"I", "Z", "S", "O", "T", "L", "J"}
        self.sequence = {}
                for i = 1, 1000 do
                self.sequence[i] = self.bag[self:SegaRandom()+1]
        end
        self.counter = 0
end

function SegaRandomizer:generatePiece()
        self.counter = self.counter + 1
        return self.sequence[(self.counter-1) % 1000 + 1]
end
function SegaRandomizer:SegaRandom()
        local temp=seed
        local d0
        seed=seed * 41
        seed=seed % 4294967296
	        seed=seed % 4294967296
        temp=seed % 65536 + math.floor(seed / 65536)
        temp=temp % 65536
        seed=temp * 65536 + seed % 65536
        d0=temp % 64
        return (d0 % 7)
end
