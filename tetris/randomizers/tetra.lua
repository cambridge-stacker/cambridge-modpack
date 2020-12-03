-- A randomizer based on Tetra Legends' "Tetra-X" game mode
-- There are two main rules:
-- * if piece hasn't been generated for 13+ pieces, force it
-- * if piece has been generated in the last two pieces, don't give it out
--
-- The official implementation also has self-balancing functionality (bias
-- towards pieces that have appeared less often).

local Randomizer = require 'tetris.randomizers.randomizer'

local TetraXRandomizer = Randomizer:extend()

function TetraXRandomizer:initialize()
    local pieces = {"I", "J", "L", "O", "S", "T", "Z"}

    self.count = {}
    self.lastseen = {}
    self.totalcount = 0
    self.pieceselection = pieces

    for _, piece in ipairs(pieces) do
        self.count[piece] = 0
        self.lastseen[piece] = -1  -- use -1 as magic value for "not seen"
    end

end

function TetraXRandomizer:generatePiece()
    local generated = nil
    while true do
        generated = self.pieceselection[math.random(#self.pieceselection)]
        if not (self.lastseen[generated] == 0 or self.lastseen[generated] == 1) then
            break
        end
    end

    -- piece has not been generated in the last 13+
    for piece, val in pairs(self.lastseen) do
        if val >= 13 then
            generated = piece
            break
        end
    end

    for piece, val in pairs(self.lastseen) do
        if piece == generated then
            self.lastseen[piece] = 0
        else
            if val ~= -1 then
                self.lastseen[piece] = val + 1
            end
        end
    end

    self.count[generated] = self.count[generated] + 1
    self.totalcount = self.totalcount + 1

    -- shuffle the piece selection for the next time
    self.pieceselection = {}
    for piece, count in pairs(self.count) do
        local probability = (self.totalcount - count) / (self.totalcount * 6)
        local chances = math.floor(probability * 1000 + 0.5) -- simulated "round"
        for _ = 1, chances do
            table.insert(self.pieceselection, piece)
        end
    end

    return generated
end

return TetraXRandomizer
