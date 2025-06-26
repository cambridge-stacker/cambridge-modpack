require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'

local History6RollsRandomizer = require 'tetris.randomizers.history_6rolls'

local MarathonWCBGame = GameMode:extend()

MarathonWCBGame.name = "Marathon WCB"
MarathonWCBGame.hash = "MarathonWCB"
MarathonWCBGame.tagline = "When all the pieces slip right to their destinations... can you keep up?"
MarathonWCBGame.tags = {"Marathon", "Web", "20G Start"}

function MarathonWCBGame:new()
	MarathonWCBGame.super:new()

	self.pieces = 0
	self.randomizer = History6RollsRandomizer()

	self.lock_drop = true
	self.lock_hard_drop = true
	self.instant_hard_drop = true
	self.instant_soft_drop = true
	self.enable_hold = false
	self.next_queue_length = 6

    self.piece_is_active = false
end

function MarathonWCBGame:initialize(ruleset)
	self.super.initialize(self, ruleset)
	self.colourscheme = copy(ruleset.colourscheme)
	ruleset.onPieceDrop = function() end
	ruleset.onPieceMove = function() end
	ruleset.onPieceRotate = function() end
end

function MarathonWCBGame:getDropSpeed()
	return 20
end

function MarathonWCBGame:getARR()
	return 0
end

function MarathonWCBGame:getARE()
	return 0
end

function MarathonWCBGame:getLineARE()
	return 0
end

function MarathonWCBGame:getDasLimit()
	return 0
end

function MarathonWCBGame:getLineClearDelay()
	return 0
end

function MarathonWCBGame:getLockDelay()
	return math.huge
end

function MarathonWCBGame:getGravity()
	return self.piece_is_active and 20 or 0
end

function MarathonWCBGame:advanceOneFrame()
	if self.ready_frames == 0 then
		self.frames = self.frames + 1
	end
	return true
end

function MarathonWCBGame:onAttemptPieceMove()
    if self.piece ~= nil then
        -- don't let the piece move before it's finished dropping
        self.piece:dropToBottom(self.grid)
    end
    self.piece_is_active = true
end

function MarathonWCBGame:onAttemptPieceRotate()
    self.piece_is_active = true
end

function MarathonWCBGame:shuffleColours()
	local temp_colours = {}
	for _, colour in pairs(self.colourscheme) do
		table.insert(temp_colours, colour)
	end
	for piece in pairs(self.ruleset.colourscheme) do
		self.ruleset.colourscheme[piece] = table.remove(temp_colours, love.math.random(#temp_colours))
	end
end

function MarathonWCBGame:resetColours()
	for piece in pairs(self.colourscheme) do
		self.ruleset.colourscheme[piece] = self.colourscheme[piece]
	end
end

function MarathonWCBGame:onPieceLock()	
	self.super:onPieceLock()
	self.piece_is_active = false
	self.pieces = self.pieces + 1
	if self.pieces % 50 == 0 then
		self:shuffleColours()
	end
end

function MarathonWCBGame:onLineClear(cleared_row_count)
	self.lines = self.lines + cleared_row_count
end

function MarathonWCBGame:onExit()
	self:resetColours()
end

function MarathonWCBGame:drawGrid(ruleset)
	self.grid:draw()
	if self.piece ~= nil then
		self:drawGhostPiece(ruleset)
	end
end

function MarathonWCBGame:getHighscoreData()
	return {
		pieces = self.pieces,
		lines = self.lines,
		frames = self.frames,
	}
end

function MarathonWCBGame:drawScoringInfo()
	MarathonWCBGame.super.drawScoringInfo(self)
	love.graphics.setColor(1, 1, 1, 1)

	local text_x = config["side_next"] and 320 or 240

	love.graphics.setFont(font_3x5_2)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("lines", text_x, 160, 80, "left")
	love.graphics.printf("pieces", text_x, 220, 80, "left")
	love.graphics.printf("piece/sec", text_x, 280, 80, "left")
	local sg = self.grid:checkSecretGrade()
	if sg >= 5 then
		love.graphics.printf("SECRET GRADE", 240, 430, 180, "left")
	end

	love.graphics.setFont(font_3x5_3)
	love.graphics.printf(self.lines, text_x, 180, 80, "left")
	love.graphics.printf(self.pieces, text_x, 240, 80, "left")
	love.graphics.printf(string.format("%.04f", self.pieces / math.max(1, self.frames) * 60), text_x, 300, 80, "left")
	if sg >= 5 then
		love.graphics.printf(self.SGnames[sg], 240, 450, 180, "left")
	end
end

function MarathonWCBGame:getBackground()
	return (math.floor(self.pieces / 50) % 20)
end

return MarathonWCBGame