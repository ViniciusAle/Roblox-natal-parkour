--!strict
-- Conversão entre coordenadas da pista e o mundo.
-- Pista: X = lateral, Y = altura sobre o piso, Z = distância percorrida. No mundo a corrida vai para -Z.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)

local ORIGIN = GameConfig.Track.Origin

local TrackSpace = {}

TrackSpace.Hidden = CFrame.new(GameConfig.Track.HiddenPosition)

function TrackSpace.toWorld(localPosition: Vector3): Vector3
	return ORIGIN + Vector3.new(localPosition.X, localPosition.Y, -localPosition.Z)
end

function TrackSpace.cframe(x: number, y: number, distance: number): CFrame
	return CFrame.new(ORIGIN.X + x, ORIGIN.Y + y, ORIGIN.Z - distance)
end

function TrackSpace.laneX(lane: number): number
	return (lane - 2) * GameConfig.Track.LaneWidth
end

return TrackSpace
