--!strict
-- Remotes do jogo. O servidor cria; o cliente espera existirem.
--   StartRun    (RemoteFunction)  cliente pede corrida solo -> RunLoadout com a seed
--   FinishRun   (RemoteEvent)     cliente informa RunReport -> servidor valida
--   RunResult   (RemoteEvent)     servidor devolve RunResult
--   SelectHero  (RemoteEvent)     cliente escolhe o herói (usado na corrida multiplayer)
--   MatchState  (RemoteEvent)     servidor -> todos: estado da fila do lobby
--   RaceStarted (RemoteEvent)     servidor -> participantes: RaceStart
--   RaceState   (Unreliable)      cliente -> servidor: distância, x, y, deslizando
--   RaceSnapshot(Unreliable)      servidor -> participantes: posições dos rivais
--   RaceResults (RemoteEvent)     servidor -> participantes: ranking final

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local FOLDER_NAME = "Remotes"
local IS_SERVER = RunService:IsServer()

local function folder(): Instance
	if not IS_SERVER then
		return ReplicatedStorage:WaitForChild(FOLDER_NAME)
	end
	local existing = ReplicatedStorage:FindFirstChild(FOLDER_NAME)
	if existing then
		return existing
	end
	local created = Instance.new("Folder")
	created.Name = FOLDER_NAME
	created.Parent = ReplicatedStorage
	return created
end

local function remoteEvent(name: string): RemoteEvent
	local parent = folder()
	if not IS_SERVER then
		return parent:WaitForChild(name) :: RemoteEvent
	end
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("RemoteEvent") then
		return existing
	end
	local remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = parent
	return remote
end

local function unreliableEvent(name: string): UnreliableRemoteEvent
	local parent = folder()
	if not IS_SERVER then
		return parent:WaitForChild(name) :: UnreliableRemoteEvent
	end
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("UnreliableRemoteEvent") then
		return existing
	end
	local remote = Instance.new("UnreliableRemoteEvent")
	remote.Name = name
	remote.Parent = parent
	return remote
end

local function remoteFunction(name: string): RemoteFunction
	local parent = folder()
	if not IS_SERVER then
		return parent:WaitForChild(name) :: RemoteFunction
	end
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("RemoteFunction") then
		return existing
	end
	local remote = Instance.new("RemoteFunction")
	remote.Name = name
	remote.Parent = parent
	return remote
end

local Remotes = {}

function Remotes.startRun(): RemoteFunction
	return remoteFunction("StartRun")
end

function Remotes.finishRun(): RemoteEvent
	return remoteEvent("FinishRun")
end

function Remotes.runResult(): RemoteEvent
	return remoteEvent("RunResult")
end

function Remotes.selectHero(): RemoteEvent
	return remoteEvent("SelectHero")
end

function Remotes.matchState(): RemoteEvent
	return remoteEvent("MatchState")
end

function Remotes.raceStarted(): RemoteEvent
	return remoteEvent("RaceStarted")
end

function Remotes.raceState(): UnreliableRemoteEvent
	return unreliableEvent("RaceState")
end

function Remotes.raceSnapshot(): UnreliableRemoteEvent
	return unreliableEvent("RaceSnapshot")
end

function Remotes.raceResults(): RemoteEvent
	return remoteEvent("RaceResults")
end

return Remotes
