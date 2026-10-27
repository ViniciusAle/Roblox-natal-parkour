--!strict
-- Gera a sequência de chunks a partir de uma seed. Mesma seed = mesma pista,
-- no cliente (para jogar) e no servidor (para validar moedas e para a corrida multiplayer).

local GameConfig = require(script.Parent.Config.GameConfig)
local Chapters = require(script.Parent.Config.Chapters)
local ChunkLibrary = require(script.Parent.ChunkLibrary)
local Types = require(script.Parent.Types)

local Track = GameConfig.Track
local SEED_STRIDE = 104729 -- separa os geradores de cada chunk

local TrackGenerator = {}
TrackGenerator.__index = TrackGenerator

type GeneratorData = {
	seed: number,
	startChapter: number,
	slots: { Types.ChunkSlot }, -- slots[i + 1] = chunk de índice i
}

export type TrackGenerator = typeof(setmetatable({} :: GeneratorData, TrackGenerator))

local function maxDifficultyAt(meters: number): number
	local result = 1
	for _, step in GameConfig.Difficulty do
		if meters >= step.meters then
			result = step.maxDifficulty
		end
	end
	return result
end

local function pickWeighted(
	rng: Random,
	candidates: { Types.ChunkDef },
	maxDifficulty: number,
	previousId: string?
): Types.ChunkDef
	local weights: { number } = {}
	local total = 0
	for i, chunk in candidates do
		local weight = GameConfig.DifficultyWeights[maxDifficulty - chunk.difficulty + 1] or 0
		if chunk.id == previousId and #candidates > 1 then
			weight = 0 -- evita repetir o mesmo chunk em seguida
		end
		weights[i] = weight
		total += weight
	end
	if total <= 0 then
		return candidates[rng:NextInteger(1, #candidates)]
	end

	local roll = rng:NextNumber() * total
	for i, chunk in candidates do
		local weight = weights[i]
		if weight > 0 and roll < weight then
			return chunk
		end
		roll -= weight
	end
	return candidates[#candidates]
end

function TrackGenerator.new(seed: number, startChapterId: string): TrackGenerator
	local self: GeneratorData = {
		seed = seed,
		startChapter = Chapters.indexOf(startChapterId) or 1,
		slots = {},
	}
	return setmetatable(self, TrackGenerator)
end

function TrackGenerator.chapterIdAt(self: TrackGenerator, index: number): string
	local meters = math.max(0, index) * Track.ChunkLength * Track.MetersPerStud
	local pages = math.floor(meters / Track.ChapterLengthMeters)
	local order = Chapters.Order
	return order[(self.startChapter - 1 + pages) % #order + 1]
end

function TrackGenerator._generate(self: TrackGenerator, index: number): Types.ChunkSlot
	local chapterId = self:chapterIdAt(index)
	local chunk: Types.ChunkDef
	if index < Track.StartChunks then
		chunk = ChunkLibrary.special("Start")
	elseif chapterId ~= self:chapterIdAt(index - 1) then
		chunk = ChunkLibrary.special("PageTurn")
	else
		local rng = Random.new(self.seed + index * SEED_STRIDE)
		local meters = index * Track.ChunkLength * Track.MetersPerStud
		local maxDifficulty = maxDifficultyAt(meters)
		local previous = self.slots[index] -- slot do índice anterior
		chunk = pickWeighted(
			rng,
			ChunkLibrary.candidates(chapterId, maxDifficulty),
			maxDifficulty,
			if previous then previous.chunk.id else nil
		)
	end
	return { index = index, chunk = chunk, chapterId = chapterId }
end

-- Gera em ordem até o índice pedido (cada chunk depende do anterior)
function TrackGenerator.getSlot(self: TrackGenerator, index: number): Types.ChunkSlot
	for i = #self.slots, index do
		self.slots[i + 1] = self:_generate(i)
	end
	return self.slots[index + 1]
end

-- Total de moedas existentes do início até a distância (limite usado pelo servidor)
function TrackGenerator.countCoinsUntil(self: TrackGenerator, distance: number): number
	local last = math.floor(math.max(0, distance) / Track.ChunkLength)
	local total = 0
	for i = 0, last do
		total += ChunkLibrary.coinCount(self:getSlot(i).chunk)
	end
	return total
end

return TrackGenerator
