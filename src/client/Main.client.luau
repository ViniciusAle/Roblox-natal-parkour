--!strict
-- Ponto de entrada do cliente: vila (lobby) -> corrida solo ou multiplayer -> resultado -> vila.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Chapters = require(Shared.Config.Chapters)
local Heroes = require(Shared.Config.Heroes)
local Strings = require(Shared.Config.Strings)
local Remotes = require(Shared.Remotes)
local Types = require(Shared.Types)

local CharacterLock = require(script.Parent.CharacterLock)
local Hud = require(script.Parent.Hud)
local Input = require(script.Parent.Input)
local RunSession = require(script.Parent.RunSession)

local RENDER_STEP = "LivroDeNatalRun"
local MATCH_REFRESH = 0.25

type Mode = "Lobby" | "Solo" | "Race"

local player = Players.LocalPlayer
local heroIndex = 1
local chapterIndex = 1
local mode: Mode = "Lobby"
local session: RunSession.RunSession? = nil
local starting = false
local awaitingResult = false
local raceId = 0
local raceCoins = 0
local relayClock = 0
local matchState: Types.MatchState? = nil
local hud: Hud.Hud

local function heroId(): string
	return Heroes.Order[heroIndex]
end

local function chapterId(): string
	return Chapters.Order[chapterIndex]
end

local function refreshLobby()
	hud:setSelection(Strings.Heroes[heroId()] or heroId(), Strings.Chapters[chapterId()] or chapterId())
end

local function stopSession()
	RunService:UnbindFromRenderStep(RENDER_STEP)
	if session then
		session:destroy()
		session = nil
	end
end

local function raceTick(current: RunSession.RunSession, dt: number)
	relayClock += dt
	if relayClock >= GameConfig.Match.RelayInterval and not current.ended then
		relayClock = 0
		Remotes.raceState():FireServer(current:raceState())
	end
	hud:setStandings(current:standings())
end

local function onRunEnded(report: Types.RunReport, _reason: RunSession.EndReason)
	Remotes.finishRun():FireServer(report)
	local endedSession = session

	if mode == "Race" then
		-- Caiu na corrida: depois de um instante, assiste quem está na frente
		task.delay(GameConfig.Ui.ResultsDelay, function()
			if session ~= nil and session == endedSession and mode == "Race" then
				local leader = session:spectate()
				hud:setSpectating(if leader then string.format(Strings.Spectating, leader) else Strings.WaitingOthers)
			end
		end)
		return
	end

	awaitingResult = true
	task.delay(GameConfig.Ui.ResultsTimeout, function()
		-- O servidor não respondeu: não deixa o jogador preso
		if awaitingResult and session ~= nil and session == endedSession then
			awaitingResult = false
			stopSession()
			CharacterLock.unlock()
			mode = "Lobby"
			hud:showScreen("Lobby")
			hud:setStatus(Strings.StartFailed)
		end
	end)
end

local function beginSession(loadout: Types.RunLoadout, options: RunSession.Options, newMode: Mode)
	stopSession()
	local newSession = RunSession.new(loadout, hud, onRunEnded, options)
	session = newSession
	mode = newMode
	relayClock = 0
	CharacterLock.lock()
	hud:showScreen("Run")
	hud:setStandings(nil)
	hud:setSpectating(nil)
	RunService:BindToRenderStep(RENDER_STEP, Enum.RenderPriority.Camera.Value + 1, function(dt: number)
		newSession:update(dt)
		if mode == "Race" then
			raceTick(newSession, dt)
		end
	end)
end

local function startSolo()
	if starting or (mode == "Race" and session ~= nil and not session.ended) then
		return
	end
	starting = true
	hud:setStatus(Strings.Loading)
	local ok, response = pcall(function()
		return Remotes.startRun():InvokeServer(chapterId(), heroId())
	end)
	starting = false
	if not ok or typeof(response) ~= "table" then
		hud:setStatus(Strings.StartFailed)
		return
	end
	hud:setStatus("")
	beginSession(response :: Types.RunLoadout, { countIn = GameConfig.Ui.SoloCountIn }, "Solo")
end

local function backToVillage()
	stopSession()
	CharacterLock.unlock()
	mode = "Lobby"
	awaitingResult = false
	refreshLobby()
	hud:setStatus("")
	hud:showScreen("Lobby")
end

local function refreshMatchBanner()
	local state = matchState
	if not state then
		return
	end
	if state.state == "Waiting" then
		hud:setMatch(string.format(Strings.MatchWaiting, state.queued, state.minPlayers), false)
	elseif state.state == "Countdown" then
		local seconds = math.max(0, math.ceil(state.endsAt - Workspace:GetServerTimeNow()))
		local chapterName = Strings.Chapters[state.chapterId] or state.chapterId
		hud:setMatch(string.format(Strings.MatchCountdown, seconds, chapterName), true)
	else
		hud:setMatch(Strings.MatchRacing, false)
	end
end

hud = Hud.new({
	solo = startSolo,
	again = startSolo,
	village = backToVillage,
	cycleHero = function(step: number)
		heroIndex = (heroIndex - 1 + step) % #Heroes.Order + 1
		refreshLobby()
		Remotes.selectHero():FireServer(heroId())
	end,
	cycleChapter = function(step: number)
		chapterIndex = (chapterIndex - 1 + step) % #Chapters.Order + 1
		refreshLobby()
	end,
	ability = function()
		if session then
			session:press("Ability")
		end
	end,
})

Input.new({
	onAction = function(action)
		if session then
			session:press(action)
		end
	end,
	onJumpRelease = function()
		if session then
			session:releaseJump()
		end
	end,
})

Remotes.runResult().OnClientEvent:Connect(function(result: Types.RunResult)
	if mode == "Race" then
		raceCoins = result.coins
		return
	end
	awaitingResult = false
	-- Deixa o vilão alcançar o herói antes de mostrar o resultado
	task.delay(GameConfig.Ui.ResultsDelay, function()
		if mode == "Solo" and session and session.ended then
			hud:showResults(result)
		end
	end)
end)

Remotes.matchState().OnClientEvent:Connect(function(state: Types.MatchState)
	matchState = state
	refreshMatchBanner()
end)

Remotes.raceStarted().OnClientEvent:Connect(function(start: Types.RaceStart)
	raceId = start.raceId
	raceCoins = 0
	local countIn = math.max(0, start.startAt - Workspace:GetServerTimeNow())
	beginSession(start.loadout, { countIn = countIn, rivals = start.rivals }, "Race")
end)

Remotes.raceSnapshot().OnClientEvent:Connect(function(snapshot: { Types.RaceSnapshotEntry })
	if mode == "Race" and session then
		session:applySnapshot(snapshot)
	end
end)

Remotes.raceResults().OnClientEvent:Connect(function(results: Types.RaceResults)
	if mode ~= "Race" or results.raceId ~= raceId then
		return
	end
	-- Espera o RunResult chegar com as moedas antes de mostrar o ranking
	task.delay(0.3, function()
		hud:setSpectating(nil)
		hud:setStandings(nil)
		hud:showRaceResults(results, player.UserId, raceCoins)
	end)
end)

task.spawn(function()
	while true do
		task.wait(MATCH_REFRESH)
		refreshMatchBanner()
	end
end)

Remotes.selectHero():FireServer(heroId())
refreshLobby()
hud:showScreen("Lobby")
