local Randomizer = require 'tetris.randomizers.randomizer'

local SplitHistoryRandomizer = Randomizer:extend()

function SplitHistoryRandomizer:initialize()
    self.history = {"Z", "Z", "Z", "Z", "Z", "Z", "Z", "Z"}
    self.piece_count = 0
end

function SplitHistoryRandomizer:generatePiece()
	if self.piece_count < 2 then
		self.piece_count = self.piece_count + 1
		return self:updateHistory(({"L", "J", "I", "T"})[math.random(4)])
	else
		local shapes = {"I", "J", "L", "O", "S", "T", "Z"}
		for i = 1, 4 do
			local x = math.random(7)
			if not inHistory(shapes[x], self.history) or i == 4 then
				return self:updateHistory(shapes[x])
			end
		end
	end
end

function SplitHistoryRandomizer:updateHistory(shape)
	table.remove(self.history, 1)
	table.insert(self.history, shape)
	return shape
end

function inHistory(piece, history)
	for i = 1, 7, 2 do
        if history[i] == piece then
            return true
        end
    end
	return false
end

return SplitHistoryRandomizer
