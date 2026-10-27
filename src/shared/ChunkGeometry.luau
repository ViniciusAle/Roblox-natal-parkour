--!strict
-- Medidas derivadas dos dados de chunk, usadas pelo validador, pelo gerador e pela pista do cliente.

local GameConfig = require(script.Parent.Config.GameConfig)
local Types = require(script.Parent.Types)

local Obstacles = GameConfig.Obstacles

export type Span = { z0: number, z1: number }

local ChunkGeometry = {}

local gapCache: { [Types.ChunkDef]: { Span } } = setmetatable({}, { __mode = "k" }) :: any

-- Trecho [z0, z1) que o objeto ocupa ao longo do chunk
function ChunkGeometry.extent(object: Types.ChunkObject): (number, number)
	local kind = object.kind
	if kind == "Low" then
		return object.z, object.z + Obstacles.Low.length
	elseif kind == "High" then
		return object.z, object.z + Obstacles.High.length
	elseif kind == "Trampoline" then
		return object.z, object.z + Obstacles.Trampoline.length
	elseif kind == "PowerUp" then
		return object.z, object.z + Obstacles.PowerUp.length
	elseif kind == "Coins" then
		local count = object.count or 1
		return object.z, object.z + (count - 1) * (object.spacing or 0)
	end
	return object.z, object.z + (object.length or 0)
end

function ChunkGeometry.coinCount(chunk: Types.ChunkDef): number
	local total = 0
	for _, object in chunk.objects do
		if object.kind == "Coins" then
			total += object.count or 1
		end
	end
	return total
end

-- Vãos do chunk, ordenados por z
function ChunkGeometry.gapsOf(chunk: Types.ChunkDef): { Span }
	local cached = gapCache[chunk]
	if cached then
		return cached
	end
	local gaps: { Span } = {}
	for _, object in chunk.objects do
		if object.kind == "Gap" then
			local z0, z1 = ChunkGeometry.extent(object)
			table.insert(gaps, { z0 = z0, z1 = z1 })
		end
	end
	table.sort(gaps, function(a, b)
		return a.z0 < b.z0
	end)
	gapCache[chunk] = gaps
	return gaps
end

return ChunkGeometry
