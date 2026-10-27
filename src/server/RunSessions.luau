--!strict
-- Dono das corridas (solo e multiplayer): sorteia a seed, guarda a sessão e valida o resultado informado.
-- Nunca confia no cliente: distância é limitada pelo tempo real e moedas pelas que existem na pista.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Heroes = require(Shared.Config.Heroes)
local Chapters = require(Shared.Config.Chapters)
local Abilities = require(Shared.Config.Abilities)
local Remotes = require(Shared.Remotes)
local SpeedCurve = require(Shared.SpeedCurve)
local TrackGenerator = require(Shared.TrackGenerator)
local Types = require(Shared.Types)

local PlayerData = require(script.Parent.PlayerData)

local Server = GameConfig.Server
local MAX_SEED = 2 ^ 31 - 1

export type Mode = "Solo" | "Race"

type Session = {
	mode: Mode,
	loadout: Types.RunLoadout,
	startedAt: number, -- os.clock() da largada (na corrida, depois da contagem)
	generator: TrackGenerator.TrackGenerator,
	maxCoinMultiplier: number,
}

local sessions: { [Player]: Session } = {}
local lastStartAt: { [Player]: number } = {}
local seedRandom = Random.new()
local finishHook: ((Player, Types.RunResult, Mode) -> ())? = nil

local function isFiniteNumber(value: unknown): boolean
	if typeof(value) ~= "number" then
		return false
	end
	return value == value and math.abs(value) ~= math.huge
end

local function createSession(player: Player, mode: Mode, seed: number, chapterId: string, heroId: string, countIn: number): Types.RunLoadout?
	local profile = PlayerData.get(player)
	local hero = Heroes.ById[heroId]
	if not profile or not hero or not Chapters.ById[chapterId] then
		return nil
	end
	if not profile.ownedHeroes[heroId] or not profile.ownedChapters[chapterId] then
		return nil
	end

	local loadout: Types.RunLoadout = {
		seed = seed,
		chapterId = chapterId,
		heroId = heroId,
		upgrades = {
			doubleJump = (profile.upgrades.DoubleJump or 0) > 0,
			extraLives = profile.upgrades.ExtraLife or 0,
			magnetLevel = profile.upgrades.MagnetPower or 0,
		},
	}
	sessions[player] = {
		mode = mode,
		loadout = loadout,
		startedAt = os.clock() + countIn,
		generator = TrackGenerator.new(seed, chapterId),
		maxCoinMultiplier = (hero.passive.coinMultiplier or 1) * Abilities.maxEffectCoinMultiplier(),
	}
	return loadout
end

local function onStartRun(player: Player, chapterId: unknown, heroId: unknown): Types.RunLoadout?
	if typeof(chapterId) ~= "string" or typeof(heroId) ~= "string" then
		return nil
	end
	local current = sessions[player]
	if current and current.mode == "Race" then
		return nil -- está numa corrida multiplayer
	end

	local now = os.clock()
	local last = lastStartAt[player]
	if last and now - last < Server.StartCooldown then
		return nil
	end
	lastStartAt[player] = now

	-- Começar outra corrida solo descarta a anterior sem prêmio
	local loadout = createSession(player, "Solo", seedRandom:NextInteger(1, MAX_SEED), chapterId, heroId, 0)
	if loadout then
		PlayerData.selectHero(player, heroId)
	end
	return loadout
end

local function onFinishRun(player: Player, report: unknown)
	local session = sessions[player]
	if not session then
		return
	end
	sessions[player] = nil

	if typeof(report) ~= "table" then
		return
	end
	local rawDistance = (report :: any).distance
	local rawCoins = (report :: any).coins
	if not isFiniteNumber(rawDistance) or not isFiniteNumber(rawCoins) then
		return
	end
	local reportedDistance = rawDistance :: number
	local reportedCoins = math.floor(rawCoins :: number)

	-- Distância máxima possível no tempo real decorrido (com folga para patins, dash e latência)
	local elapsed = math.min(os.clock() - session.startedAt, Server.MaxRunSeconds) + Server.LatencyAllowance
	local maxDistance = SpeedCurve.distanceAt(elapsed) * Server.DistanceTolerance
	local distance = math.clamp(reportedDistance, 0, maxDistance)

	-- Moedas: nunca mais do que as que existem na pista até ali, com o maior multiplicador possível
	local maxCoins = math.floor(session.generator:countCoinsUntil(distance) * session.maxCoinMultiplier)
	local coins = math.clamp(reportedCoins, 0, maxCoins)

	local adjusted = distance ~= reportedDistance or coins ~= reportedCoins
	if adjusted then
		warn(
			`[RunSessions] {player.Name}: relatório ajustado (distância {reportedDistance} -> {distance}, moedas {reportedCoins} -> {coins})`
		)
	end

	local meters = math.floor(distance * GameConfig.Track.MetersPerStud)
	local totalCoins = PlayerData.addCoins(player, coins)
	local newBest = PlayerData.submitDistance(player, meters)
	local profile = PlayerData.get(player)

	local result: Types.RunResult = {
		meters = meters,
		coins = coins,
		totalCoins = totalCoins,
		bestMeters = if profile then profile.bestMeters else meters,
		newBest = newBest,
		adjusted = adjusted,
	}
	Remotes.runResult():FireClient(player, result)

	local hook = finishHook
	if hook then
		hook(player, result, session.mode)
	end
end

local RunSessions = {}

-- Corrida multiplayer: todos recebem a mesma seed; a largada é depois da contagem (countIn segundos)
function RunSessions.startRace(player: Player, seed: number, chapterId: string, countIn: number): Types.RunLoadout?
	local profile = PlayerData.get(player)
	if not profile then
		return nil
	end
	return createSession(player, "Race", seed, chapterId, profile.selectedHero, countIn)
end

function RunSessions.newSeed(): number
	return seedRandom:NextInteger(1, MAX_SEED)
end

function RunSessions.isRunning(player: Player): boolean
	return sessions[player] ~= nil
end

function RunSessions.cancel(player: Player)
	sessions[player] = nil
end

-- Maior distância plausível agora (para validar posições repassadas aos rivais)
function RunSessions.maxDistanceNow(player: Player): number?
	local session = sessions[player]
	if not session then
		return nil
	end
	local elapsed = math.max(0, os.clock() - session.startedAt) + Server.LatencyAllowance
	return SpeedCurve.distanceAt(elapsed) * Server.DistanceTolerance
end

function RunSessions.onFinished(callback: (Player, Types.RunResult, Mode) -> ())
	finishHook = callback
end

function RunSessions.start()
	Remotes.startRun().OnServerInvoke = onStartRun
	Remotes.finishRun().OnServerEvent:Connect(onFinishRun)
	Remotes.runResult()
	Remotes.selectHero().OnServerEvent:Connect(function(player, heroId)
		if typeof(heroId) == "string" then
			PlayerData.selectHero(player, heroId)
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		sessions[player] = nil
		lastStartAt[player] = nil
	end)
end

return RunSessions
