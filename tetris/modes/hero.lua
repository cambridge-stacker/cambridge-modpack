local GameMode = require 'tetris.modes.gamemode'

local HistoryRandomizer = require 'tetris.randomizers.history_6rolls_35bag'

local TheTrueHero = GameMode:extend()

bgm.undyne = love.audio.newSource("res/bgm/mus_x_undyne.mp3", "stream")

sounds.undyne = {
    ding = love.audio.newSource("res/se/000029aa.wav", "static"),
    pike = love.audio.newSource("res/se/0000299c.wav", "static"),
    damage = love.audio.newSource("res/se/000029c3.wav", "static")
}

TheTrueHero.name = "The True Hero"
TheTrueHero.hash = "TheTrueHero"
TheTrueHero.tagline = "A tribute to the Puzzle Maker."

function TheTrueHero:new()
    self.super:new()

    self.randomizer = HistoryRandomizer()

    self.attacks = {
        "PIECE GOAL",
        "LINE GOAL",
        "GARBAGE",
        "HIDDEN PREVIEWS",
        "TO THE BEAT",
        "INVISIBLE"
    }

    self.attack_number = 0
    self.current_attack = 0
    self.var = 0
    
    self.section_frames = 0
    self.section_times = {
        385,
        385,
        385,
        386,
        386,
        385,
        381,
        384,
        384,
        384,
        384,
        385,
        385,
        384,
        384,
        288,
        288,
        288,
        288,
        288,
        288,
        288,
        288,
        288,
        288,
        288,
        290,
    }

    self.queue_age = 0
    self.grounded_time = 0

    self.lock_drop = true
    self.lock_hard_drop = true
    self.enable_hold = true
    self.next_queue_length = 5

    self.irs = false
    self.ihs = false
end

function TheTrueHero:getDropSpeed()
	return 20
end

function TheTrueHero:getARR()
	return config.arr
end

function TheTrueHero:getARE()
	return 0
end

function TheTrueHero:getLineARE()
	return 0
end

function TheTrueHero:getDasLimit()
	return config.das
end

function TheTrueHero:getLineClearDelay()
	return 0
end

function TheTrueHero:getLockDelay()
    return 30
end

function TheTrueHero:getGravity()
    return self.current_attack == 5 and 20 or 1.1 ^ (self.attack_number - 1)
end

function TheTrueHero:getDasCutDelay()
    return config.dcd
end

function TheTrueHero:advanceOneFrame(inputs, ruleset)
    if self.ready_frames == 0 then
        if self.frames == 0 then
            switchBGMLoop("undyne")
        end
        if self.section_frames >= self.section_times[Mod1(self.attack_number, #self.section_times)] or self.frames == 0 then
            if (self.current_attack == 1 or self.current_attack == 2) and self.var > 0 then
                playSE("undyne", "damage")
                self.game_over = true
                return false
            end
            self.section_frames = 0
            self.attack_number = self.attack_number + 1
            local prev_attack = self.current_attack
            self.current_attack = -1
            local attack_rolls = 0
            while ((
                prev_attack == self.current_attack or
                self.current_attack == 5
            ) and (attack_rolls < 2)) or attack_rolls == 0 do
                attack_rolls = attack_rolls + 1
                if self.attack_number > 20 then
                    self.current_attack = math.random(#self.attacks)
                else
                    self.current_attack = math.random(4)
                end
            end
            if self.current_attack == 1 then
                self.var = math.floor(3 + math.random(
                    math.floor(self.attack_number / 4),
                    math.floor(self.attack_number / 3)
                ) *
                self.section_times[Mod1(self.attack_number, #self.section_times)] / 342)
            elseif self.current_attack == 2 then
                self.var = math.floor(1 + math.random(
                    math.floor(self.attack_number / 6),
                    math.floor(self.attack_number / 4)
                ) *
                self.section_times[Mod1(self.attack_number, #self.section_times)] / 342)
            elseif self.current_attack == 3 then
                self.var = math.max(10 - math.random(
                    math.floor(self.attack_number / 8),
                    math.floor(self.attack_number / 4)
                ), 3)
            end
        end
        self.frames = self.frames + 1
        self.section_frames = self.section_frames + 1
        if self.current_attack == 5 then
            self.lock_on_soft_drop = false
            self.lock_on_hard_drop = false
            if self.section_frames % 24 == 0 and self.section_frames >= 25 then
                self.piece.locked = true
                playSE("undyne", "pike")
            end
        else
            self.lock_on_soft_drop = ({ruleset.softdrop_lock, self.instant_soft_drop, false, true })[config.gamesettings.manlock]
            self.lock_on_hard_drop = ({ruleset.harddrop_lock, self.instant_hard_drop, true,  false})[config.gamesettings.manlock]
        end
    end
    return true
end

function TheTrueHero:onPieceEnter()
    self.queue_age = 0
    self.grounded_time = 0
end

function TheTrueHero:onHold()
    self.grounded_time = 0
end

function TheTrueHero:whilePieceActive()
    if self.piece:isDropBlocked(self.grid) then
        self.grounded_time = self.grounded_time + 1
        if self.grounded_time >= 120 then
            self.piece.locked = true
        end
    end
    self.queue_age = self.queue_age + 1
end

function TheTrueHero:onPieceLock(piece, cleared_row_count)
    self.super:onPieceLock()
    if self.current_attack == 1 or self.current_attack == 3 then
        self.var = math.max(self.var - 1, 0)
        self:advanceBottomRow(1)
        playSE("undyne", "ding")
    elseif self.current_attack == 2 then
        self.var = math.max(self.var - cleared_row_count, 0)
        if cleared_row_count ~= 0 then
            playSE("undyne", "ding")
        end
    end
end

function TheTrueHero:advanceBottomRow(dx)
	if self.var <= 0 and self.current_attack == 3 then
        self.grid:copyBottomRow()
        self.var = math.max(10 - math.random(
            math.floor(self.attack_number / 8),
            math.floor(self.attack_number / 4)
        ), 3)
        playSE("undyne", "pike")
	end
end

function TheTrueHero:setNextOpacity(i)
	if self.current_attack == 4 then
		local hidden_next_pieces = math.ceil(self.attack_number / 15)
		if i < hidden_next_pieces then
			love.graphics.setColor(1, 1, 1, 0)
		elseif i == hidden_next_pieces then
			love.graphics.setColor(1, 1, 1, 1 - math.min(1, self.queue_age / 15))
		else
			love.graphics.setColor(1, 1, 1, 1)
		end
	else
		love.graphics.setColor(1, 1, 1, 1)
	end
end

local function invisible(game, block, x, y, age)
    return 0.5, 0.5, 0.5, 1 - age / (300 - game.attack_number * 5.5), 0
end

function TheTrueHero:drawGrid()
    if self.current_attack == 6 then
        self.grid:drawCustom(invisible, self)
    else
        self.grid:draw()
    end
    self:drawGhostPiece()
end

function TheTrueHero:drawScoringInfo()
    self.super.drawScoringInfo(self)

    love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.setFont(font_3x5_2)
    love.graphics.printf("ATTACK NUMBER", 240, 150, 200, "left")
    love.graphics.printf("ATTACK", 240, 230, 200, "left")

    love.graphics.setFont(font_3x5_3)
    if self.attack_number > 0 then
        love.graphics.printf(self.attack_number .. " - " .. (
            string.sub(formatTime(
                self.section_times[Mod1(self.attack_number, #self.section_times)] - self.section_frames
            ), -4, -1)
        ), 240, 170, 200, "left")
    end
    love.graphics.printf(
        self.attacks[self.current_attack] or "",
        240, 250, 200, "left"
    )

    love.graphics.setFont(font_3x5_4)
    if self.current_attack >= 1 and self.current_attack <= 3 then
        love.graphics.setColor(
            (not self.game_over and self.frames % 4 < 2) and
            (
                self.var == 0 and {0.3, 1, 0.3, 1} or {1, 0.3, 0.3, 1}
            ) or {1, 1, 1, 1}
        )
        love.graphics.printf(self.var, 240, 280, 200, "left")
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function TheTrueHero:getHighscoreData()
    return {
        frames = self.frames,
    }
end

function TheTrueHero:getBackground()
    return math.max(0, self.attack_number - 1) % 20
end

return TheTrueHero