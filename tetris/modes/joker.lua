require 'funcs'

local GameMode = require 'tetris.modes.gamemode'
local Piece = require 'tetris.components.piece'

local DTETRandomizer = require 'tetris.randomizers.dtet'

local JokerGame = GameMode:extend()

local rush = false

JokerGame.name = "Final J"
JokerGame.hash = "Joker"
JokerGame.tagline = "One of the hardest modes! Can you retain your stock to level 300?"

function JokerGame:new()
	self.super:new()

	self.randomizer = DTETRandomizer()
	
	self.level = 50
	self.stock = 0
	self.time_limit = 7200

	self.lock_drop = true
	self.lock_hard_drop = true
	self.enable_hold = false
	self.next_queue_length = 6
end

function JokerGame:getARE()
	if self.level < 200 then return math.ceil(20 - (self.level - 50) / 10)
	else return math.max(math.ceil(20 - (self.level - 200) / 7), 5) end
end

function JokerGame:getLineARE()
	return self:getARE()
end

function JokerGame:getDasLimit()
	return 6
end

function JokerGame:getARR()
	return rush and 0 or 1
end

function JokerGame:getLineClearDelay()
	if self.level < 200 then return math.ceil(6 - (self.level - 50) / 50)
	else return math.max(math.ceil(6 - (self.level - 200) / 33), 3) end
end

function JokerGame:getLockDelay()
	if self.level < 200 then return math.ceil(30 - (self.level - 50) / 10)
	else return math.max(math.ceil(30 - (self.level - 200) / 7), 15) end
end

function JokerGame:getGravity() return 20 end

function JokerGame:advanceOneFrame(inputs, ruleset)
	if self.ready_frames == 0 then
		self.frames = self.frames + 1
		self.time_limit = self.time_limit - 1
	else
		if not self.prev_inputs.hold and inputs.hold then
			rush = not rush
		end
	end
	if self.time_limit <= 0 then self.game_over = true end
	return true
end

function JokerGame:onPieceEnter()
	-- The Initial Movement System, pioneered by DTET
	if self.grid:canPlacePiece(self.piece) then
		if self.das.direction == "left" then
			for i = 1, 10 do
				local new_piece = self.piece:withOffset({x=-i, y=0})
				if self.grid:canPlacePiece(new_piece) then
					self.piece = new_piece
					break
				end
				if not rush then break end
			end
		elseif self.das.direction == "right" then
			for i = 1, 10 do
				local new_piece = self.piece:withOffset({x=i, y=0})
				if self.grid:canPlacePiece(new_piece) then
					self.piece = new_piece
					break
				end
				if not rush then break end
			end
		end
	end
end

function JokerGame:onLineClear(cleared_row_count)
	if cleared_row_count >= 4 and self.level < 200 then self.stock = self.stock + 1
	elseif cleared_row_count < 4 and self.level >= 200 then self.stock = self.stock - 1 end

	if self.level >= 200 then
		if self.stock > 0 or (cleared_row_count >= 4 and self.stock <= 0) then
			self.level = self.level + 1
			self.time_limit = math.min(self.time_limit + frameTime(0,15), frameTime(5,00))
		elseif self.stock == 0 then
			self.level = self.level + 1
                        self.time_limit = math.min(self.time_limit + frameTime(0,15), frameTime(5,00))
		end
	else
		self.level = self.level + 1
		self.time_limit = math.min(self.time_limit + frameTime(0,15), frameTime(5,00))
	end

	if self.stock <= 0 and (self.level == 200 or self.level >= 300) then self.game_over = true end
end

function JokerGame:drawGrid() self.grid:drawOutline() end

function JokerGame:drawScoringInfo()
	local colour = (
		(
			rush and
			(self.frames % 4 < 2 and self.frames ~= 0)
		) and {1, 1, 0.3, 1}
		or {1, 1, 1, 1}
	)
	love.graphics.setColor(colour)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("TIME LIMIT", 240, 120, 80, "left")
	love.graphics.printf("LEVEL", 240, 200, 40, "left")
	love.graphics.printf("STOCK", 240, 280, 40, "left")

	love.graphics.setFont(font_3x5_3)
	if not self.game_over and self.time_limit < frameTime(0,10) and self.time_limit % 4 < 2 then
		love.graphics.setColor(1, 0.3, 0.3, 1)
	end
	love.graphics.printf(formatTime(self.time_limit), 240, 140, 120, "left")
	love.graphics.setColor(colour)
	love.graphics.printf(self.level, 240, 220, 90, "left")
	love.graphics.printf(math.max(self.stock, 0), 240, 300, 90, "left")
	if (self.ready_frames ~= 0) then
		love.graphics.printf(
			"RUSH: " .. (rush and "ON" or "OFF"),
			64, 100, 160, "center"
		)
	end

	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function JokerGame:getBackground()
	if self.level < 200 then return 0
	elseif self.level < 300 then return 4
	else return 19 end
end

function JokerGame:getHighscoreData()
	return {
		level = self.level,
	}
end

return JokerGame
