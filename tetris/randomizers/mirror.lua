local Randomizer = require 'tetris.randomizers.randomizer'

local MirrorRandomizer = Randomizer:extend()

function MirrorRandomizer:initialize()
    self.mirror_state = false
    self.total_pieces = 0
    self.piece_stack = {}
    self.history = {"S", "Z"}
    self.shapes = {"I", "J", "L", "O", "S", "T", "Z"}
    self.mirrors = {
        ["I"] = "O",
        ["J"] = "L",
        ["L"] = "J",
        ["O"] = "I",
        ["S"] = "Z",
        ["T"] = "T",
        ["Z"] = "S"
    }
end

function inHistory(piece, history)
	for idx, entry in pairs(history) do
		if entry == piece then
			return true
		end
	end
	return false
end

function MirrorRandomizer:generatePiece()
    local generated    

    if self.mirror_state then
        generated = table.remove(self.piece_stack)
    else
        repeat
            generated = self.shapes[math.random(7)]
        until not inHistory(generated, self.history)
        table.remove(self.history, 1)
        table.insert(self.history, generated)
        table.insert(self.piece_stack, self.mirrors[generated])
    end
    
    self.total_pieces = self.total_pieces + 1

    if self.total_pieces % 14 == 0 then
        self.mirror_state = false
    elseif self.total_pieces % 14 == 7 then
        self.mirror_state = true
    end

    return generated
end

return MirrorRandomizer