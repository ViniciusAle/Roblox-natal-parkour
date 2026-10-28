--!strict
-- Garante que um chunk é justo: dentro dos limites, sem sobreposições impossíveis,
-- com pelo menos uma rota livre de ponta a ponta (GDD seção 5, "Justiça")
-- e sem pista que fique livre o chunk inteiro (não dá para passar parado).

local GameConfig = require(script.Parent.Config.GameConfig)
local Abilities = require(script.Parent.Config.Abilities)
local ChunkGeometry = require(script.Parent.ChunkGeometry)
local Types = require(script.Parent.Types)

local Track = GameConfig.Track
local LANES = Track.LaneCount
local SAMPLE_STEP = 0.5

type Solid = { object: Types.ChunkObject, z0: number, z1: number }

local KNOWN_KINDS = {
	Low = true,
	High = true,
	Block = true,
	Gap = true,
	Coins = true,
	PowerUp = true,
	Trampoline = true,
}

local function overlaps(a0: number, a1: number, b0: number, b1: number): boolean
	return a0 < b1 and b0 < a1
end

local ChunkValidator = {}

-- Retorna a lista de erros; vazia = chunk válido
function ChunkValidator.validate(chunk: Types.ChunkDef): { string }
	local errors: { string } = {}
	local function fail(message: string)
		table.insert(errors, `{chunk.id}: {message}`)
	end

	if chunk.difficulty < 1 or chunk.difficulty > 5 or chunk.difficulty % 1 ~= 0 then
		fail("dificuldade fora de 1..5")
	end

	local gaps: { ChunkGeometry.Span } = {}
	local solids: { Solid } = {}

	for i, object in chunk.objects do
		if not KNOWN_KINDS[object.kind] then
			fail(`objeto {i}: tipo desconhecido {object.kind}`)
			continue
		end
		local z0, z1 = ChunkGeometry.extent(object)

		if object.kind ~= "Gap" then
			local lane = object.lane
			if lane == nil or lane < 1 or lane > LANES or lane % 1 ~= 0 then
				fail(`objeto {i} ({object.kind}) sem pista válida`)
				continue
			end
		end

		if object.kind == "Coins" then
			if z0 < 0 or z1 > Track.ChunkLength then
				fail(`objeto {i}: moedas fora do chunk`)
			end
		elseif z0 < Track.EdgeMargin or z1 > Track.ChunkLength - Track.EdgeMargin then
			fail(`objeto {i} ({object.kind}) invade a margem de encaixe`)
		end

		if object.kind == "Gap" then
			local length = object.length or 0
			if length <= 0 or length > Track.MaxGapLength then
				fail(`objeto {i}: vão precisa ter entre 0 e {Track.MaxGapLength} studs`)
			end
			table.insert(gaps, { z0 = z0, z1 = z1 })
		elseif object.kind == "Block" then
			if (object.length or 0) <= 0 then
				fail(`objeto {i}: bloco sem comprimento`)
			end
			table.insert(solids, { object = object, z0 = z0, z1 = z1 })
		elseif object.kind == "PowerUp" then
			if object.powerUp == nil or Abilities.PowerUps[object.powerUp] == nil then
				fail(`objeto {i}: power-up desconhecido`)
			end
			table.insert(solids, { object = object, z0 = z0, z1 = z1 })
		elseif object.kind ~= "Coins" then
			table.insert(solids, { object = object, z0 = z0, z1 = z1 })
		end
	end

	-- Nada sólido sobre um vão, e dois sólidos nunca dividem o mesmo trecho de pista
	for i, a in solids do
		for _, gap in gaps do
			if overlaps(a.z0, a.z1, gap.z0, gap.z1) then
				fail(`{a.object.kind} em z={a.object.z} sobre um vão`)
			end
		end
		for j = i + 1, #solids do
			local b = solids[j]
			if a.object.lane == b.object.lane and overlaps(a.z0, a.z1, b.z0, b.z1) then
				fail(`{a.object.kind} e {b.object.kind} sobrepostos na pista {a.object.lane}`)
			end
		end
	end

	-- Sem pista livre o chunk inteiro: parado em qualquer pista, o jogador encontra um obstáculo
	if chunk.special == nil then
		local covered = table.create(LANES, false)
		for _, solid in solids do
			local kind = solid.object.kind
			if kind == "Low" or kind == "High" or kind == "Block" then
				covered[solid.object.lane :: number] = true
			end
		end
		for lane = 1, LANES do
			if not covered[lane] then
				fail(`pista {lane} sem nenhum obstáculo`)
			end
		end
	end

	-- Varredura de rota: pistas alcançáveis só passam por pistas sem bloco inteiro
	local reachable = table.create(LANES, true)
	local z = 0
	while z <= Track.ChunkLength do
		local open = table.create(LANES, true)
		for _, solid in solids do
			if solid.object.kind == "Block" and z >= solid.z0 and z < solid.z1 then
				open[solid.object.lane :: number] = false
			end
		end

		local any = false
		for lane = 1, LANES do
			reachable[lane] = reachable[lane] and open[lane]
			any = any or reachable[lane]
		end
		if not any then
			fail(`sem rota livre em z={z}`)
			break
		end

		-- Pode trocar para pistas vizinhas abertas
		for _ = 1, LANES - 1 do
			for lane = 1, LANES do
				if not reachable[lane] and open[lane] then
					local fromLeft = lane > 1 and reachable[lane - 1]
					local fromRight = lane < LANES and reachable[lane + 1]
					reachable[lane] = fromLeft or fromRight
				end
			end
		end

		z += SAMPLE_STEP
	end

	return errors
end

return ChunkValidator
