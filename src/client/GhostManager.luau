--!strict
-- Fantasmas dos rivais na corrida multiplayer: cada um corre a mesma pista (mesma seed),
-- então basta desenhar a posição informada por cima da nossa pista, sem colisão.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

local RunnerView = require(script.Parent.RunnerView)
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)

type Ghost = {
	rival: Types.Rival,
	view: RunnerView.RunnerView,
	-- último estado recebido
	distance: number,
	x: number,
	y: number,
	sliding: boolean,
	alive: boolean,
	velocity: number,
	receivedAt: number,
	-- estado desenhado (suavizado)
	shownDistance: number,
	shownX: number,
	shownY: number,
}

type ManagerData = {
	ghosts: { [number]: Ghost },
}

local GhostManager = {}
GhostManager.__index = GhostManager

export type GhostManager = typeof(setmetatable({} :: ManagerData, GhostManager))

export type Standing = { userId: number, name: string, meters: number, alive: boolean }

function GhostManager.new(parent: Instance, rivals: { Types.Rival }): GhostManager
	local ghosts: { [number]: Ghost } = {}
	for _, rival in rivals do
		ghosts[rival.userId] = {
			rival = rival,
			view = RunnerView.new(parent, rival.heroId, rival.name),
			distance = 0,
			x = 0,
			y = 0,
			sliding = false,
			alive = true,
			velocity = 0,
			receivedAt = os.clock(),
			shownDistance = 0,
			shownX = 0,
			shownY = 0,
		}
	end
	local self: ManagerData = { ghosts = ghosts }
	return setmetatable(self, GhostManager)
end

function GhostManager.applySnapshot(self: GhostManager, snapshot: { Types.RaceSnapshotEntry })
	local now = os.clock()
	for _, entry in snapshot do
		local ghost = self.ghosts[entry[1]]
		if ghost then
			local elapsed = now - ghost.receivedAt
			if elapsed > 0 and entry[2] >= ghost.distance then
				ghost.velocity = (entry[2] - ghost.distance) / elapsed
			end
			ghost.distance = entry[2]
			ghost.x = entry[3]
			ghost.y = entry[4]
			ghost.sliding = entry[5] == 1
			ghost.alive = entry[6] == 1
			ghost.receivedAt = now
		end
	end
end

function GhostManager.update(self: GhostManager, dt: number, time: number)
	local now = os.clock()
	local smoothing = math.min(1, dt * 10)
	for _, ghost in self.ghosts do
		-- Projeta um pouco à frente para não "travar" entre os pacotes
		local projected = ghost.distance
		if ghost.alive then
			projected += ghost.velocity * math.min(now - ghost.receivedAt, 0.3)
		end
		ghost.shownDistance += (projected - ghost.shownDistance) * smoothing
		ghost.shownX += (ghost.x - ghost.shownX) * smoothing
		ghost.shownY += (ghost.y - ghost.shownY) * smoothing

		local runner = GameConfig.Runner
		ghost.view:update({
			x = ghost.shownX,
			y = ghost.shownY,
			distance = ghost.shownDistance,
			height = if ghost.sliding then runner.SlideHeight else runner.Height,
			targetX = ghost.x,
			grounded = ghost.shownY < 0.2,
			gliding = false,
			time = time,
		}, false, false)
	end
end

-- Rival vivo mais à frente (para o modo espectador)
function GhostManager.leader(self: GhostManager): Vector3?
	local best: Ghost? = nil
	for _, ghost in self.ghosts do
		if ghost.alive and (best == nil or ghost.shownDistance > best.shownDistance) then
			best = ghost
		end
	end
	if not best then
		return nil
	end
	return Vector3.new(best.shownX, best.shownY, best.shownDistance)
end

function GhostManager.leaderName(self: GhostManager): string?
	local best: Ghost? = nil
	for _, ghost in self.ghosts do
		if ghost.alive and (best == nil or ghost.shownDistance > best.shownDistance) then
			best = ghost
		end
	end
	return if best then best.rival.name else nil
end

function GhostManager.standings(self: GhostManager): { Standing }
	local list: { Standing } = {}
	local metersPerStud = GameConfig.Track.MetersPerStud
	for userId, ghost in self.ghosts do
		table.insert(list, {
			userId = userId,
			name = ghost.rival.name,
			meters = math.floor(ghost.distance * metersPerStud),
			alive = ghost.alive,
		})
	end
	return list
end

function GhostManager.destroy(self: GhostManager)
	for _, ghost in self.ghosts do
		ghost.view:destroy()
	end
	table.clear(self.ghosts)
end

return GhostManager
