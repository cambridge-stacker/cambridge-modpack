local Randomizer = require 'tetris.randomizers.randomizer'

local DTETRandomizer = Randomizer:extend()

function DTETRandomizer:initialize()
    -- keep a tally of how long each piece has been droughted
    self.droughts = {
        ["I"] = 0,
        ["J"] = 0,
        ["L"] = 0,
        ["O"] = 0,
        ["S"] = 0,
        ["T"] = 0,
        ["Z"] = 0
    }
    self.piece_index = {
        "I",
        "J",
        "L",
        "O",
        "S",
        "T",
        "Z",
    }
end

function DTETRandomizer:updateDroughts(piece)
    -- update drought counters
    for k, v in pairs(self.droughts) do
        if k == piece then
            self.droughts[k] = 0
        else
            self.droughts[k] = v + 1
        end
    end
end

function DTETRandomizer:generatePiece()
    local droughts = {}
    local weights = {}
    local bag = {}
    
    -- copy drought table
    for k, v in pairs(self.droughts) do
        droughts[k] = v
    end

    -- assign weights to each piece
    for i = 1, 7 do
        local lowest_drought = math.huge
        local lowest_drought_piece = ""
        for k, v in ipairs(self.piece_index) do
            if droughts[v] ~= nil and droughts[v] < lowest_drought then
                lowest_drought = droughts[v]
                lowest_drought_piece = v
            end
        end
        droughts[lowest_drought_piece] = nil
        weights[lowest_drought_piece] = i - 1
    end

    -- insert pieces into 21-bag
    for k, v in ipairs(self.piece_index) do
        if weights[v] then
            for i = 1, weights[v] do
                table.insert(bag, v)
            end
        end
    end

    -- pull piece from 21-bag and update drought counters
    local generated = bag[love.math.random(#bag)]
    self:updateDroughts(generated)
    return generated
end

return DTETRandomizer