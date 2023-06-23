local Randomizer = require 'tetris.randomizers.randomizer'

local HistoryRandomizer = Randomizer:extend()

function HistoryRandomizer:new(history_length, rolls, allowed_pieces)
	self.super:new()
	self.history = {}
    for i = 1, history_length do
        table.insert(self.history, '')
    end
    self.rolls = rolls
    self.allowed_pieces = allowed_pieces
end

function HistoryRandomizer:generatePiece()
	for i = 1, self.rolls do
		local x = love.math.random(table.getn(self.allowed_pieces))
		if not inHistory(self.allowed_pieces[x], self.history) or i == self.rolls then
			return self:updateHistory(self.allowed_pieces[x])
		end
	end
end

function HistoryRandomizer:updateHistory(shape)
	table.remove(self.history, 1)
	table.insert(self.history, shape)
	return shape
end

function inHistory(piece, history)
	for idx, entry in pairs(history) do
		if entry == piece then
			return true
		end
	end
	return false
end

return HistoryRandomizer