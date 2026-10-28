--!strict
-- Uma corrida no cliente: junta corredor, pista, colisão, coleta, efeitos, câmera e HUD
-- (e o vilão perseguidor, quando GameConfig.Chaser.Enabled).
-- O cliente simula para responder na hora; o resultado vai para o servidor validar.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Abilities = require(Shared.Config.Abilities)
local Chapters = require(Shared.Config.Chapters)
local Heroes = require(Shared.Config.Heroes)
local Strings = require(Shared.Config.Strings)
local TrackGenerator = require(Shared.TrackGenerator)
local Types = require(Shared.Types)

local AmbientFx = require(script.Parent.AmbientFx)
local CameraRig = require(script.Parent.CameraRig)
local ChapterAmbience = require(script.Parent.ChapterAmbience)
local ChaserView = require(script.Parent.ChaserView)
local GhostManager = require(script.Parent.GhostManager)
local Hud = require(script.Parent.Hud)
local Input = require(script.Parent.Input)
local Juice = require(script.Parent.Juice)
local Music = require(script.Parent.Music)
local Runner = require(script.Parent.Runner)
local RunnerView = require(script.Parent.RunnerView)
local Track = require(script.Parent.Track)
local TrackSpace = require(script.Parent.TrackSpace)

local TrackConfig = GameConfig.Track
local Obstacles = GameConfig.Obstacles
local RunnerSize = GameConfig.Runner
local Coins = GameConfig.Coins

export type EndReason = "Crash" | "Caught" | "Fall"

type ActiveEffect = { id: string, remaining: number, effect: Types.Effect }

export type Options = {
	countIn: number, -- segundos de contagem antes da largada
	rivals: { Types.Rival }?, -- corrida multiplayer
}

type SessionData = {
	loadout: Types.RunLoadout,
	hero: Heroes.HeroDef,
	hud: Hud.Hud,
	onEnded: (Types.RunReport, EndReason) -> (),
	folder: Folder,
	generator: TrackGenerator.TrackGenerator,
	track: Track.Track,
	runner: Runner.Runner,
	runnerView: RunnerView.RunnerView,
	chaser: ChaserView.ChaserView?, -- nil = perseguidor desligado
	camera: CameraRig.CameraRig,
	juice: Juice.Juice,
	ambient: AmbientFx.AmbientFx,
	ghosts: GhostManager.GhostManager?,
	countIn: number,
	spectating: boolean,
	groundAt: (number) -> number?,
	time: number,
	coins: number, -- fracionário por causa dos multiplicadores
	shield: boolean,
	revivesLeft: number,
	lastStumbleAt: number,
	graceUntil: number,
	chaserGap: number,
	currentChunk: number,
	effects: { ActiveEffect },
	abilityCooldown: number,
	ended: boolean,
}

local RunSession = {}
RunSession.__index = RunSession

export type RunSession = typeof(setmetatable({} :: SessionData, RunSession))

local function overlaps(a0: number, a1: number, b0: number, b1: number): boolean
	return a0 < b1 and b0 < a1
end

function RunSession.new(
	loadout: Types.RunLoadout,
	hud: Hud.Hud,
	onEnded: (Types.RunReport, EndReason) -> (),
	options: Options
): RunSession
	local hero = Heroes.ById[loadout.heroId] or Heroes.ById[Heroes.Order[1]]
	local passive = hero.passive

	local folder = Instance.new("Folder")
	folder.Name = "LocalRun"
	folder.Parent = Workspace

	local generator = TrackGenerator.new(loadout.seed, loadout.chapterId)
	local track = Track.new(generator, folder)

	local self = {} :: SessionData
	self.loadout = loadout
	self.hero = hero
	self.hud = hud
	self.onEnded = onEnded
	self.folder = folder
	self.generator = generator
	self.track = track
	self.runnerView = RunnerView.new(folder, hero.id)
	self.chaser = if GameConfig.Chaser.Enabled then ChaserView.new(folder) else nil
	self.camera = CameraRig.new()
	self.juice = Juice.new(folder)
	self.ambient = AmbientFx.new(folder)
	self.ghosts = if options.rivals and #options.rivals > 0 then GhostManager.new(folder, options.rivals) else nil
	self.countIn = options.countIn
	self.spectating = false
	self.groundAt = function(distance: number): number?
		return track:groundAt(distance)
	end
	self.time = 0
	self.coins = 0
	self.shield = passive.startShield == true
	self.revivesLeft = loadout.upgrades.extraLives
	self.lastStumbleAt = -math.huge
	self.graceUntil = 0
	self.chaserGap = GameConfig.Chaser.NearGap -- começa colado e fica para trás
	self.currentChunk = -1
	self.effects = {}
	self.abilityCooldown = 0
	self.ended = false

	local session = setmetatable(self, RunSession)

	self.runner = Runner.new({
		laneSwitchTime = GameConfig.Lanes.SwitchTime * (passive.laneSwitchTimeMultiplier or 1),
		slideDuration = GameConfig.Slide.Duration * (passive.slideDurationMultiplier or 1),
		glideDuration = GameConfig.Jump.GlideDuration * (passive.glideDurationMultiplier or 1),
		doubleJump = loadout.upgrades.doubleJump,
	}, function(event, value)
		session:_onRunnerEvent(event, value)
	end)

	track:update(0)
	ChapterAmbience.apply(loadout.chapterId, true)
	self.ambient:setChapter(loadout.chapterId)
	Music.play(loadout.chapterId)
	session:_setChaser(loadout.chapterId)
	hud:setCoins(0)
	hud:setDistance(0)
	hud:setEffects("")
	hud:setAbility(if hero.activeId then 0 else -1)
	return session
end

-- Comandos -------------------------------------------------------------------

function RunSession.press(self: RunSession, action: Input.Action)
	if self.ended or self.countIn > 0 then
		return
	end
	if action == "Ability" then
		self:_useAbility()
	else
		self.runner:press(action :: Runner.MoveAction)
	end
end

function RunSession.releaseJump(self: RunSession)
	if not self.ended and self.countIn <= 0 then
		self.runner:releaseJump()
	end
end

function RunSession._useAbility(self: RunSession)
	local activeId = self.hero.activeId
	if not activeId or self.abilityCooldown > 0 then
		return
	end
	local def = Abilities.HeroActives[activeId]
	if not def then
		return
	end
	self:_addEffect(activeId, def.effect, 0)
	self.abilityCooldown = def.cooldown
	self.juice:play("PowerUp")
	self.camera:shake(0.3)
end

-- Efeitos --------------------------------------------------------------------

function RunSession._addEffect(self: RunSession, id: string, effect: Types.Effect, bonusDuration: number)
	local duration = effect.duration + bonusDuration
	for _, active in self.effects do
		if active.id == id then
			active.remaining = duration -- pegar de novo renova
			return
		end
	end
	table.insert(self.effects, { id = id, remaining = duration, effect = effect })
end

function RunSession._tickEffects(self: RunSession, dt: number)
	for i = #self.effects, 1, -1 do
		local active = self.effects[i]
		active.remaining -= dt
		if active.remaining <= 0 then
			table.remove(self.effects, i)
		end
	end
	self.abilityCooldown = math.max(0, self.abilityCooldown - dt)
end

function RunSession._product(self: RunSession, field: "speedMultiplier" | "coinMultiplier"): number
	local value = 1
	for _, active in self.effects do
		value *= (active.effect :: any)[field] or 1
	end
	return value
end

function RunSession._timeScale(self: RunSession): number
	local scale = 1
	for _, active in self.effects do
		scale = math.min(scale, active.effect.timeScale or 1)
	end
	return scale
end

function RunSession._has(self: RunSession, predicate: (Types.Effect) -> boolean): boolean
	for _, active in self.effects do
		if predicate(active.effect) then
			return true
		end
	end
	return false
end

function RunSession._invulnerable(self: RunSession): boolean
	return self.time < self.graceUntil or self:_has(function(effect)
		return effect.invulnerable == true
	end)
end

function RunSession._crushes(self: RunSession, kind: string): boolean
	return self:_has(function(effect)
		return effect.crushKinds ~= nil and effect.crushKinds[kind] == true
	end)
end

function RunSession._magnetRadius(self: RunSession): number
	local active = self:_has(function(effect)
		return effect.magnet == true
	end)
	if not active then
		return 0
	end
	return Coins.MagnetRadius + self.loadout.upgrades.magnetLevel * Abilities.MagnetPerLevel.radius
end

function RunSession._activatePowerUp(self: RunSession, id: string)
	local def = Abilities.PowerUps[id]
	if not def then
		return
	end
	if def.shield then
		self.shield = true
	end
	if def.effect then
		local bonus = if def.effect.magnet
			then self.loadout.upgrades.magnetLevel * Abilities.MagnetPerLevel.duration
			else 0
		self:_addEffect(id, def.effect, bonus)
	end
	self.juice:play("PowerUp")
	self.hud:flash(Strings.PowerUps[id] or id)
end

-- Eventos do corredor (juice) ---------------------------------------------------

function RunSession._onRunnerEvent(self: RunSession, event: Runner.RunnerEvent, value: number)
	if event == "Land" then
		self.juice:play("Land")
		if value >= GameConfig.Visuals.LandParticlesMinImpact then
			self.runnerView:landDust()
			self.camera:shake(GameConfig.Camera.LandShake)
		end
	elseif event == "Jump" or event == "DoubleJump" then
		self.juice:play("Jump", if event == "DoubleJump" then 1.2 else 1)
	elseif event == "Launch" then
		self.juice:play("Trampoline")
		self.camera:shake(0.3)
	elseif event == "Slide" then
		self.juice:play("Slide")
	elseif event == "LaneChange" then
		self.juice:play("LaneChange")
	elseif event == "LaneBlocked" then
		self.camera:shake(0.15)
	end
end

-- Regras de colisão --------------------------------------------------------------

function RunSession._fail(self: RunSession, reason: EndReason)
	if self.revivesLeft > 0 then
		-- Vida extra: volta no começo do próximo chunk, cuja entrada é sempre livre
		self.revivesLeft -= 1
		local nextChunk = math.floor(self.runner.distance / TrackConfig.ChunkLength) + 1
		self.runner:placeAt(nextChunk * TrackConfig.ChunkLength + 1)
		self.graceUntil = self.time + GameConfig.Revive.GraceSeconds
		self.lastStumbleAt = -math.huge
		self.hud:flash(Strings.Revived)
		self.camera:shake(GameConfig.Camera.HitShake)
		return
	end

	self.ended = true
	self.juice:play("Crash")
	self.camera:shake(GameConfig.Camera.HitShake)
	self.hud:flash(Strings.EndReasons[reason] or "")
	self.onEnded({ distance = self.runner.distance, coins = math.floor(self.coins) }, reason)
end

function RunSession._hit(self: RunSession, obstacle: Track.Obstacle)
	local runner = self.runner
	if self:_invulnerable() or self:_crushes(obstacle.kind) then
		return
	end

	local outcome: "Stumble" | "Crash" = "Stumble"
	if obstacle.kind == "Block" then
		local sideScrape = runner:isSwitching() and obstacle.lane == runner.lane and runner.laneFrom ~= obstacle.lane
		if sideScrape then
			runner:cancelLaneChange()
		else
			outcome = GameConfig.Collision.BlockHeadOn
		end
	end

	if self.shield then
		self.shield = false
		self.graceUntil = self.time + GameConfig.Collision.GraceSeconds
		self.juice:play("ShieldBreak")
		self.camera:shake(GameConfig.Camera.HitShake * 0.5)
		self.hud:flash(Strings.ShieldBroke)
		return
	end

	if outcome == "Crash" then
		self:_fail("Crash")
		return
	end

	-- Tropeço: o segundo dentro da janela encerra
	if self.time - self.lastStumbleAt <= GameConfig.Stumble.ComboWindow then
		self:_fail("Caught")
		return
	end
	self.lastStumbleAt = self.time
	self.graceUntil = self.time + GameConfig.Collision.GraceSeconds
	self.juice:play("Stumble")
	self.camera:shake(GameConfig.Camera.HitShake * 0.6)
	self.hud:flash(Strings.Stumble)
end

function RunSession._collect(self: RunSession, coin: Track.Coin)
	coin.collected = true
	self.track:hide(coin.part)
	local multiplier = (self.hero.passive.coinMultiplier or 1) * self:_product("coinMultiplier")
	self.coins += Coins.Value * multiplier
	self.juice:coin(self.time)
	self.hud:setCoins(math.floor(self.coins))
end

function RunSession._collide(self: RunSession, dt: number)
	local runner = self.runner
	local height = runner:height()
	local halfWidth = RunnerSize.Width / 2
	local halfDepth = RunnerSize.Depth / 2
	local x, y, d = runner.x, runner.y, runner.distance
	local center = Vector3.new(x, y + height / 2, d)
	local magnetRadius = self:_magnetRadius()

	for _, chunk in self.track:chunksAround(d) do
		for _, obstacle in chunk.obstacles do
			if
				not obstacle.disabled
				and overlaps(d - halfDepth, d + halfDepth, obstacle.z0, obstacle.z1)
				and overlaps(x - halfWidth, x + halfWidth, obstacle.x - Obstacles.HalfWidth, obstacle.x + Obstacles.HalfWidth)
				and overlaps(y, y + height, obstacle.bottom, obstacle.top)
			then
				obstacle.disabled = true -- cada obstáculo acerta no máximo uma vez
				self:_hit(obstacle)
				if self.ended then
					return
				end
			end
		end

		for _, pickup in chunk.pickups do
			if
				not pickup.used
				and overlaps(d - halfDepth, d + halfDepth, pickup.z0, pickup.z1)
				and math.abs(x - pickup.x) < TrackConfig.LaneWidth / 2
			then
				if pickup.kind == "Trampoline" then
					if y <= Obstacles.Trampoline.top + GameConfig.Jump.LandSnap and runner.vy <= 0 then
						pickup.used = true
						runner:launch(GameConfig.Jump.TrampolineVelocity)
					end
				else
					local half = Obstacles.PowerUp.size / 2
					local h = Obstacles.PowerUp.height
					if overlaps(y, y + height, h - half, h + half) then
						pickup.used = true
						self.track:hide(pickup.part)
						self:_activatePowerUp(pickup.powerUpId :: string)
					end
				end
			end
		end

		for _, coin in chunk.coins do
			if not coin.collected then
				local offset = coin.position - center
				if magnetRadius > 0 and offset.Magnitude <= magnetRadius then
					coin.attracted = true
				end
				if coin.attracted then
					coin.position = coin.position:Lerp(center, math.min(1, dt * Coins.MagnetPull))
					offset = coin.position - center
				end
				if offset.Magnitude <= Coins.PickupRadius then
					self:_collect(coin)
				end
			end
		end
	end
end

-- Laço ---------------------------------------------------------------------------

function RunSession._checkChapter(self: RunSession)
	local index = math.floor(self.runner.distance / TrackConfig.ChunkLength)
	if index == self.currentChunk then
		return
	end
	self.currentChunk = index
	local slot = self.generator:getSlot(index)
	if slot.chunk.special == "PageTurn" then
		local page = math.floor(index * TrackConfig.ChunkLength * TrackConfig.MetersPerStud / TrackConfig.ChapterLengthMeters)
		local name = Strings.Chapters[slot.chapterId] or slot.chapterId
		self.hud:pageTurn(string.format(Strings.ChapterBanner, page + 1, name))
		self.juice:play("PageTurn")
		ChapterAmbience.apply(slot.chapterId)
		self.ambient:setChapter(slot.chapterId)
		Music.play(slot.chapterId)
		self:_setChaser(slot.chapterId)
	end
end

function RunSession._setChaser(self: RunSession, chapterId: string)
	local chaserId = Chapters.ById[chapterId].chaserId
	if self.chaser and chaserId then
		self.chaser:setVillain(chaserId)
	end
end

function RunSession._simulate(self: RunSession, dt: number)
	self.time += dt
	self:_tickEffects(dt)

	-- Tropeço tira velocidade, que volta aos poucos
	local stumble = GameConfig.Stumble
	local recover = math.clamp((self.time - self.lastStumbleAt) / stumble.RecoverSeconds, 0, 1)
	local penalty = stumble.SpeedPenalty + (1 - stumble.SpeedPenalty) * recover
	self.runner.speedScale = penalty * self:_product("speedMultiplier")

	self.runner:step(dt, self.groundAt)
	self:_checkChapter()
	self:_collide(dt)
	if self.ended then
		return
	end

	if self.runner.y < TrackConfig.KillHeight then
		self:_fail("Fall")
		return
	end

	-- Vilão chega perto depois de um tropeço e volta a ficar para trás com corrida limpa
	local chaserConfig = GameConfig.Chaser
	local recentStumble = self.time - self.lastStumbleAt <= stumble.ComboWindow
	local target = if recentStumble then chaserConfig.NearGap else chaserConfig.FarGap
	self.chaserGap += (target - self.chaserGap) * math.min(1, dt * chaserConfig.Follow)
end

function RunSession.update(self: RunSession, dt: number)
	if self.countIn > 0 then
		-- Contagem de largada: o mundo já aparece, o herói ainda não corre
		self.countIn -= dt
		self.hud:setCountdown(if self.countIn > 0 then tostring(math.ceil(self.countIn)) else Strings.Go)
		if self.countIn <= 0 then
			task.delay(0.6, function()
				self.hud:setCountdown(nil)
			end)
		end
		self.track:update(self.runner.distance)
	elseif not self.ended then
		self.track:update(self.runner.distance)
		local frame = math.min(dt, GameConfig.Simulation.MaxFrame) * self:_timeScale()
		local steps = math.max(1, math.ceil(frame / GameConfig.Simulation.MaxStep))
		local step = frame / steps
		for _ = 1, steps do
			self:_simulate(step)
			if self.ended then
				break
			end
		end
		self:_updateHud()
	else
		-- Depois do fim, o vilão alcança o herói
		self.chaserGap += (GameConfig.Chaser.CaughtGap - self.chaserGap) * math.min(1, dt * GameConfig.Chaser.CatchFollow)
	end
	self:_render(dt)
end

-- Estado enviado ao servidor na corrida multiplayer
function RunSession.raceState(self: RunSession): (number, number, number, boolean)
	local runner = self.runner
	return runner.distance, runner.x, runner.y, runner:isSliding()
end

function RunSession.applySnapshot(self: RunSession, snapshot: { Types.RaceSnapshotEntry })
	if self.ghosts then
		self.ghosts:applySnapshot(snapshot)
	end
end

-- Placar ao vivo: eu + rivais, do mais longe para o mais perto
function RunSession.standings(self: RunSession): { Hud.StandingRow }?
	local ghosts = self.ghosts
	if not ghosts then
		return nil
	end
	local rows: { Hud.StandingRow } = {
		{
			name = "",
			meters = math.floor(self.runner.distance * TrackConfig.MetersPerStud),
			alive = not self.ended,
			isYou = true,
		},
	}
	for _, standing in ghosts:standings() do
		table.insert(rows, { name = standing.name, meters = standing.meters, alive = standing.alive, isYou = false })
	end
	table.sort(rows, function(a, b)
		return a.meters > b.meters
	end)
	return rows
end

-- Modo espectador: depois de cair na corrida, a câmera segue o rival que está na frente
function RunSession.spectate(self: RunSession): string?
	local ghosts = self.ghosts
	if not ghosts or not self.ended then
		return nil
	end
	self.spectating = ghosts:leader() ~= nil
	return ghosts:leaderName()
end

function RunSession._updateHud(self: RunSession)
	self.hud:setDistance(math.floor(self.runner.distance * TrackConfig.MetersPerStud))

	local parts: { string } = {}
	if self.shield then
		table.insert(parts, Strings.PowerUps.Shield)
	end
	for _, active in self.effects do
		table.insert(parts, `{Strings.PowerUps[active.id] or active.id} {math.ceil(active.remaining)}`)
	end
	self.hud:setEffects(table.concat(parts, "  "))
	if self.hero.activeId then
		self.hud:setAbility(self.abilityCooldown)
	end
end

function RunSession._render(self: RunSession, dt: number)
	local runner = self.runner
	self.track:render(self.time)
	self.runnerView:update({
		x = runner.x,
		y = runner.y,
		distance = runner.distance,
		height = runner:height(),
		targetX = TrackSpace.laneX(runner.lane),
		grounded = runner.grounded and self.countIn <= 0 and not self.ended,
		gliding = runner.gliding,
		time = self.time,
	}, self.shield, self.time < self.graceUntil)
	if self.chaser then
		self.chaser:update(dt, runner.x, runner.distance - self.chaserGap, self.time)
	end

	local focus = Vector3.new(runner.x, runner.y, runner.distance)
	local speed = runner.speed
	local ghosts = self.ghosts
	if ghosts then
		ghosts:update(dt, self.time)
		local leader = if self.spectating then ghosts:leader() else nil
		if leader then
			focus = leader
			self.track:update(leader.Z)
		end
	end
	self.camera:update(dt, focus, speed)
	self.ambient:update(self.camera.camera.CFrame, if self.ended then 0 else speed, self.time)
end

function RunSession.destroy(self: RunSession)
	self.ended = true
	self.camera:destroy()
	self.track:destroy()
	self.runnerView:destroy()
	if self.chaser then
		self.chaser:destroy()
	end
	self.juice:destroy()
	self.ambient:destroy()
	if self.ghosts then
		self.ghosts:destroy()
	end
	self.folder:Destroy()
	ChapterAmbience.restore()
end

return RunSession
