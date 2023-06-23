local Randomizer = require 'tetris.randomizers.randomizer'

local MasterOfBags = Randomizer:extend()

function MasterOfBags:initialize()
	self.history = {"S", "Z", "S", "Z"}
	self.first = true
	self.bag={}
	for x=1,28 do
		self.bag[x]=({"I", "J", "L", "O", "S", "T", "Z"})[(x-1)%7+1]
	end
end

function MasterOfBags:generatePiece()
	local piece=love.math.random(({[true]=#self.bag,[false]=#self.bag+1})[#self.bag>14])
	if piece>#self.bag then
		self.bag={}
		for x=1,28 do
			self.bag[x]=({"I", "J", "L", "O", "S", "T", "Z"})[(x-1)%7+1]
		end
		piece=love.math.random(#self.bag)
	end
	for i = 1, 6 do
		if not inHistory(self.bag[piece], self.history) then
			break
		end
		piece=love.math.random(#self.bag)
	end
	self:updateHistory(self.bag[piece])

	return table.remove(self.bag, piece)
end

function MasterOfBags:updateHistory(shape)
	table.remove(self.history, 1)
	table.insert(self.history, shape)
end

function inHistory(piece, history)
	for idx, entry in pairs(history) do
		if entry == piece then
			return true
		end
	end
	return false
end

return MasterOfBags
