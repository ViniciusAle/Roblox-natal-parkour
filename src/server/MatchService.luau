--!strict
-- Fila e corrida multiplayer (GDD seção 10): quem pisa no círculo dourado entra na fila; com jogadores
-- suficientes começa a contagem; todos recebem a mesma seed e largam juntos. O servidor repassa as
-- posições dos rivais (validadas) e no fim manda o ranking. Vence quem chegar mais longe
-- (fórmula de pontuação e prêmios de colocação ainda em aberto).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Chapters = require(Shared.Config.Chapters)
local Strings = require(Shared.Config.Strings)
local Remotes = require(Shared.Remotes)
local Types = require(Shared.Types)

local LobbyBuilder = require(script.Parent.LobbyBuilder)
local RunSessions = require(script.Parent.RunSessions)

local Match = GameConfig.Match
local IS_STUDIO = RunService:IsStudio()
local MIN_PLAYERS = if IS_STUDIO then Match.StudioMinPlayers else Match.MinPlayers
local COUNTDOWN = if IS_STUDIO then Match.StudioCountdownSeconds else Match.CountdownSeconds
local LANE_LIMIT = GameConfig.Track.LaneWidth * 1.5

type Participant = {
	finished: boolean,
	meters: number,
	distance: number,
	x: number,
	y: number,
	sliding: boolean,
}

local state: "Waiting" | "Countdown" | "Racing" = "Waiting"
local endsAt = 0
local queuedCount = 0
local chapterIndex = 1
local raceId = 0
local raceStartAt = 0
local participants: { [Player]: Participant } = {}
local pad: LobbyBuilder.Pad
local lastBroadcast = ""

local function now(): number
	return Workspace:GetServerTimeNow()
end

local function nextChapterId(): string
	return Chapters.Order[chapterIndex]
end

local function playersOnPad(): { Player }
	local list: { Player } = {}
	for _, player in Players:GetPlayers() do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root and root:IsA("BasePart") and not RunSessions.isRunning(player) then
			local offset = root.Position - pad.position
			local flat = Vector3.new(offset.X, 0, offset.Z).Magnitude
			if flat <= pad.radius and math.abs(offset.Y) < 12 then
				table.insert(list, player)
				if #list >= Match.MaxPlayers then
					break
				end
			end
		end
	end
	return list
end

local function broadcast(force: boolean?)
	local seconds = math.max(0, math.ceil(endsAt - now()))
	local key = `{state}:{queuedCount}:{seconds}`
	if key == lastBroadcast and not force then
		return
	end
	lastBroadcast = key

	local chapterName = Strings.Chapters[nextChapterId()] or nextChapterId()
	if state == "Waiting" then
		pad.status.Text = string.format(Strings.PadWaiting, queuedCount, MIN_PLAYERS)
	elseif state == "Countdown" then
		pad.status.Text = string.format(Strings.PadCountdown, seconds, chapterName)
	else
		pad.status.Text = Strings.PadRacing
	end

	local message: Types.MatchState = {
		state = state,
		queued = queuedCount,
		minPlayers = MIN_PLAYERS,
		maxPlayers = Match.MaxPlayers,
		endsAt = endsAt,
		chapterId = nextChapterId(),
	}
	Remotes.matchState():FireAllClients(message)
end

local function startRace(queue: { Player })
	raceId += 1
	local seed = RunSessions.newSeed()
	local chapterId = nextChapterId()
	chapterIndex = chapterIndex % #Chapters.Order + 1
	raceStartAt = now() + Match.CountIn

	table.clear(participants)
	local loadouts: { [Player]: Types.RunLoadout } = {}
	local rivals: { Types.Rival } = {}
	for _, player in queue do
		local loadout = RunSessions.startRace(player, seed, chapterId, Match.CountIn)
		if loadout then
			loadouts[player] = loadout
			participants[player] = { finished = false, meters = 0, distance = 0, x = 0, y = 0, sliding = false }
			table.insert(rivals, { userId = player.UserId, name = player.DisplayName, heroId = loadout.heroId })
		end
	end
	if next(participants) == nil then
		state = "Waiting"
		return
	end

	local spot = 0
	for player, loadout in loadouts do
		-- Tira o personagem do círculo: ao voltar da corrida ele não cai direto na próxima fila
		local character = player.Character
		if character then
			spot += 1
			local angle = spot / Match.MaxPlayers * math.pi
			local away = Vector3.new(math.cos(angle), 0, math.sin(angle)) * (pad.radius + 6)
			character:PivotTo(CFrame.new(pad.position + away + Vector3.new(0, 3, 0)))
		end

		local others: { Types.Rival } = {}
		for _, rival in rivals do
			if rival.userId ~= player.UserId then
				table.insert(others, rival)
			end
		end
		local message: Types.RaceStart = { raceId = raceId, loadout = loadout, startAt = raceStartAt, rivals = others }
		Remotes.raceStarted():FireClient(player, message)
	end
	state = "Racing"
end

local function endRace()
	local ranking: { Types.RaceStanding } = {}
	for player, participant in participants do
		local meters = if participant.finished
			then participant.meters
			else math.floor(participant.distance * GameConfig.Track.MetersPerStud)
		table.insert(ranking, { userId = player.UserId, name = player.DisplayName, meters = meters, place = 0 })
	end
	table.sort(ranking, function(a, b)
		return a.meters > b.meters
	end)
	for place, standing in ranking do
		standing.place = place
	end

	local results: Types.RaceResults = { raceId = raceId, ranking = ranking }
	for player, participant in participants do
		if player.Parent then
			Remotes.raceResults():FireClient(player, results)
		end
		if not participant.finished then
			RunSessions.cancel(player)
		end
	end
	table.clear(participants)
	state = "Waiting"
	endsAt = 0
end

local function tick()
	if state == "Racing" then
		local everyoneDone = true
		for _, participant in participants do
			if not participant.finished then
				everyoneDone = false
				break
			end
		end
		if everyoneDone or now() > raceStartAt + Match.MaxRaceSeconds then
			endRace()
		end
	else
		local queue = playersOnPad()
		queuedCount = #queue
		if queuedCount >= MIN_PLAYERS then
			if state == "Waiting" then
				state = "Countdown"
				endsAt = now() + COUNTDOWN
			elseif now() >= endsAt then
				startRace(queue)
			end
		elseif state == "Countdown" then
			state = "Waiting"
			endsAt = 0
		end
	end
	broadcast()
end

local function relay()
	if state ~= "Racing" then
		return
	end
	local snapshot: { Types.RaceSnapshotEntry } = {}
	for player, participant in participants do
		table.insert(snapshot, {
			player.UserId,
			math.floor(participant.distance * 10) / 10,
			math.floor(participant.x * 10) / 10,
			math.floor(participant.y * 10) / 10,
			if participant.sliding then 1 else 0,
			if participant.finished then 0 else 1,
		})
	end
	for player in participants do
		Remotes.raceSnapshot():FireClient(player, snapshot)
	end
end

local function isFinite(value: unknown): boolean
	if typeof(value) ~= "number" then
		return false
	end
	return value == value and math.abs(value) ~= math.huge
end

local function onRaceState(player: Player, distance: unknown, x: unknown, y: unknown, sliding: unknown)
	local participant = participants[player]
	if not participant or participant.finished then
		return
	end
	if not isFinite(distance) or not isFinite(x) or not isFinite(y) then
		return
	end
	local limit = RunSessions.maxDistanceNow(player) or 0
	participant.distance = math.clamp(distance :: number, participant.distance, math.max(participant.distance, limit))
	participant.x = math.clamp(x :: number, -LANE_LIMIT, LANE_LIMIT)
	participant.y = math.clamp(y :: number, -20, 60)
	participant.sliding = sliding == true
end

local MatchService = {}

function MatchService.start(lobbyPad: LobbyBuilder.Pad)
	pad = lobbyPad

	RunSessions.onFinished(function(player, result, mode)
		local participant = participants[player]
		if mode == "Race" and participant then
			participant.finished = true
			participant.meters = result.meters
		end
	end)

	Remotes.raceStarted()
	Remotes.raceResults()
	Remotes.raceSnapshot()
	Remotes.raceState().OnServerEvent:Connect(onRaceState)

	Players.PlayerAdded:Connect(function()
		broadcast(true)
	end)
	Players.PlayerRemoving:Connect(function(player)
		participants[player] = nil
	end)

	task.spawn(function()
		while true do
			task.wait(Match.TickSeconds)
			tick()
		end
	end)

	local accumulator = 0
	RunService.Heartbeat:Connect(function(dt)
		accumulator += dt
		if accumulator >= Match.RelayInterval then
			accumulator = 0
			relay()
		end
	end)

	broadcast(true)
end

return MatchService
