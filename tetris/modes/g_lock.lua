require 'funcs'

local GameMode = require 'tetris.modes.gamemode'

local History4RollsRandomizer = require 'tetris.randomizers.history_4rolls'

local GLock = GameMode:extend()

GLock.name = "G-Lock"
GLock.hash = "GLock"
GLock.description = "The speeds fluctuate rapidly! Can you withstand the pressure?"
-- TODO: tag

function GLock:new()
	self.super:new()

	self.pieces = 0
	self.time_active = 0
	
	self.randomizer = History4RollsRandomizer()
	self.lock_drop = true
	self.lock_hard_drop = true
	self.enable_hold = false
	self.next_queue_length = 4
end

function GLock:getARE()
    	if (self.pieces < 250) then return 23
	elseif (self.pieces < 275) then return 20
    	elseif (self.pieces < 285) then return 23
    	elseif (self.pieces < 305) then return 14
	elseif (self.pieces < 315) then return 20
	elseif (self.pieces < 340) then return 14
	elseif (self.pieces < 350) then return 20
	elseif (self.pieces < 380) then return 12
	elseif (self.pieces < 395) then return 18
	elseif (self.pieces < 430) then return 12
	elseif (self.pieces < 445) then return 16
	elseif (self.pieces < 475) then return 10
    	else return 8
	end
end

function GLock:getLineARE()
	if (self.pieces < 250) then return 20
    elseif (self.pieces < 275) then return 18
    elseif (self.pieces < 285) then return 18
    elseif (self.pieces < 305) then return 14
    elseif (self.pieces < 315) then return 16
    elseif (self.pieces < 340) then return 12
    elseif (self.pieces < 350) then return 14
    elseif (self.pieces < 380) then return 12
    elseif (self.pieces < 395) then return 12
    elseif (self.pieces < 430) then return 10
    elseif (self.pieces < 445) then return 10
    else return 8
	end
end

function GLock:getDasLimit()
	if (self.pieces < 195) then return 16
    elseif (self.pieces < 235) then return 14
    elseif (self.pieces < 250) then return 16
    elseif (self.pieces < 275) then return 14
    elseif (self.pieces < 285) then return 14
    elseif (self.pieces < 305) then return 14
    elseif (self.pieces < 315) then return 14
    elseif (self.pieces < 340) then return 12
    elseif (self.pieces < 350) then return 12
    elseif (self.pieces < 380) then return 12
    elseif (self.pieces < 395) then return 12
    else return 10
	end
end

function GLock:getLineClearDelay()
	if (self.pieces < 275) then return 25
    elseif (self.pieces < 285) then return 18
    elseif (self.pieces < 305) then return 20
    elseif (self.pieces < 315) then return 18
    elseif (self.pieces < 340) then return 18
    elseif (self.pieces < 350) then return 16
    elseif (self.pieces < 380) then return 16
    elseif (self.pieces < 395) then return 16
    elseif (self.pieces < 430) then return 12
    elseif (self.pieces < 445) then return 14
    elseif (self.pieces < 475) then return 10
    else return 8
	end
end

function GLock:getLockDelay()
        if (self.pieces < 285) then return 30
    elseif (self.pieces < 305) then return 25
    elseif (self.pieces < 315) then return 30
    elseif (self.pieces < 340) then return 25
    elseif (self.pieces < 350) then return 30
    elseif (self.pieces < 380) then return 22
    elseif (self.pieces < 395) then return 30
    elseif (self.pieces < 430) then return 22
    elseif (self.pieces < 445) then return 30
    elseif (self.pieces < 475) then return 17
    else return 15
        end
end

function GLock:getGravity()
        if (self.pieces < 20)  then return 64/256
    elseif (self.pieces < 50)  then return 2
    elseif (self.pieces < 65)  then return 64/256
    elseif (self.pieces < 115) then return 4
    elseif (self.pieces < 130) then return 128/256
    elseif (self.pieces < 180) then return 5
    elseif (self.pieces < 195) then return 1
    elseif (self.pieces < 235) then return 10
    elseif (self.pieces < 250) then return 2
    elseif (self.pieces < 275) then return 20
    elseif (self.pieces < 285) then return 2
    elseif (self.pieces < 305) then return 20
    elseif (self.pieces < 315) then return 3
    elseif (self.pieces < 340) then return 20
    elseif (self.pieces < 350) then return 3
    elseif (self.pieces < 380) then return 20
    elseif (self.pieces < 395) then return 4
    elseif (self.pieces < 430) then return 20
    elseif (self.pieces < 445) then return 5
    else return 20
    end
end

function GLock:advanceOneFrame()
	if self.ready_frames == 0 then
		self.frames = self.frames + 1
	end
	return true
end

function GLock:onPieceLock()
	self.super:onPieceLock()
	self.pieces = self.pieces + 1
	self.time_active = 0
	if self.pieces == 500 then
		self.completed = true
		local emptyGarbage = {"e", "e", "e", "e", "e", "e", "e", "e", "e", "e"}
		local letterGTopBottom = {"e", "e", "e", "", "", "", "", "e", "e", "e"}
		local letterG145 = {"e", "e", "", "e", "e", "e", "e", "", "e", "e"}
		local letterG2 = {"e", "e", "", "e", "e", "e", "e", "e", "e", "e"}
		local letterG3 = {"e", "e", "", "e", "e", "", "", "e", "e", "e"}
		self.grid:clear()
		self.grid:garbageRise(letterGTopBottom)
		self.grid:garbageRise(letterG145)
		self.grid:garbageRise(letterG2)
		self.grid:garbageRise(letterG3)
		self.grid:garbageRise(letterG145)
		self.grid:garbageRise(letterG145)
		self.grid:garbageRise(letterGTopBottom)
		self.grid:garbageRise(emptyGarbage)
		self.grid:garbageRise(emptyGarbage)
		self.grid:garbageRise(letterGTopBottom)
		self.grid:garbageRise(letterG145)
		self.grid:garbageRise(letterG2)
		self.grid:garbageRise(letterG3)
		self.grid:garbageRise(letterG145)
		self.grid:garbageRise(letterG145)
		self.grid:garbageRise(letterGTopBottom)
		self.grid:garbageRise(emptyGarbage)
		self.grid:garbageRise(emptyGarbage)
	end
end

function GLock:onGameComplete() end

function GLock:onPieceMove(piece)
	piece.lock_delay = 0
end

function GLock:onPieceRotate(piece)
	piece.lock_delay = 0
end

function GLock:onPieceDrop(piece)
	piece.lock_delay = 0
end

function GLock:whilePieceActive()
	if self.piece:isDropBlocked(self.grid) then
		self.time_active = self.time_active + 1
		if self.time_active >= 240 then self.piece.locked = true end
	end
end

function GLock:drawGrid()
	self.grid:draw()
	self:drawGhostPiece()
end

function GLock:drawScoringInfo()
	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.setFont(font_3x5_2)
	love.graphics.print(
		self.das.direction .. " " ..
		self.das.frames .. " " ..
		strTrueValues(self.prev_inputs)
	)
	love.graphics.printf("NEXT", 64, 40, 40, "left")
	love.graphics.printf("GRADE", 240, 120, 40, "left")
	love.graphics.printf("SECTION", 240, 200, 60, "left")
	love.graphics.printf("PIECES", 240, 320, 60, "left")
	
	if self:getGSectionState() then
		love.graphics.printf("G-SECTION", 240, 220, 90, "left")
	else
		love.graphics.printf("N-SECTION", 240, 220, 90, "left")
	end

	love.graphics.setFont(font_3x5_3)

	if self:getGSection() == 11 then
		-- blame gizmo4487 for this time
		-- he's a legend
		if self.frames <= frameTime(5,19) then love.graphics.printf("GM", 240, 140, 90, "left")
		else love.graphics.printf("M", 240, 140, 90, "left") end
	else
		love.graphics.printf("G"..1+self:getGSection(), 240, 140, 90, "left")
	end

	love.graphics.printf(self.pieces, 240, 340, 40, "right")
	love.graphics.printf(self:getSectionEndLevel(), 240, 370, 40, "right")
    
	love.graphics.setFont(font_8x11)
	love.graphics.printf(formatTime(self.frames), 64, 420, 160, "center")
end

function GLock:getSectionEndLevel()
	    if self.pieces < 20 then return 20
	elseif self.pieces < 50 then return 50
    	elseif self.pieces < 65 then return 65
	elseif self.pieces < 115 then return 115
    	elseif self.pieces < 130 then return 130
	elseif self.pieces < 180 then return 180
    	elseif self.pieces < 195 then return 195
	elseif self.pieces < 235 then return 235
    	elseif self.pieces < 250 then return 250
	elseif self.pieces < 275 then return 275
    	elseif self.pieces < 285 then return 285
	elseif self.pieces < 305 then return 305
    	elseif self.pieces < 315 then return 315
	elseif self.pieces < 340 then return 340
	elseif self.pieces < 350 then return 350
	elseif self.pieces < 380 then return 380
    	elseif self.pieces < 395 then return 395
	elseif self.pieces < 430 then return 430
    	elseif self.pieces < 445 then return 445
	elseif self.pieces < 475 then return 475
	else return 500 end
end

function GLock:getGSectionState()
	if self.pieces < 20 then return false
    elseif self.pieces < 50 then return true
    elseif self.pieces < 65 then return false
    elseif self.pieces < 115 then return true
    elseif self.pieces < 130 then return false
    elseif self.pieces < 180 then return true
    elseif self.pieces < 195 then return false
    elseif self.pieces < 235 then return true
    elseif self.pieces < 250 then return false
    elseif self.pieces < 275 then return true
    elseif self.pieces < 285 then return false
    elseif self.pieces < 305 then return true
    elseif self.pieces < 315 then return false
    elseif self.pieces < 340 then return true
    elseif self.pieces < 350 then return false
    elseif self.pieces < 380 then return true
    elseif self.pieces < 395 then return false
    elseif self.pieces < 430 then return true
    elseif self.pieces < 445 then return false
    else return true
    end
end

function GLock:getGSection()
        if (self.pieces < 50)  then return 0
    elseif (self.pieces < 115) then return 1
    elseif (self.pieces < 180) then return 2
    elseif (self.pieces < 235) then return 3
    elseif (self.pieces < 275) then return 4
    elseif (self.pieces < 305) then return 5
    elseif (self.pieces < 340) then return 6
    elseif (self.pieces < 380) then return 7
    elseif (self.pieces < 430) then return 8
    elseif (self.pieces < 475) then return 9
    elseif (self.pieces < 500) then return 10
    else return 11 end
end

function GLock:getBackground()
	if self:getGSectionState() then return 4
	else return 7 end
end

function GLock:getHighscoreData()
	return {
		gsection = self:getGSection(),
		pieces = self.pieces,
		frames = self.frames,
	}
end

return GLock

