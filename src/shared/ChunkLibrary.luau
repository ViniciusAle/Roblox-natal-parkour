--!strict
-- Catálogo de chunks já validados. Chunk inválido é ignorado com aviso, nunca entra na pista.

local Chunks = require(script.Parent.Config.Chunks)
local ChunkValidator = require(script.Parent.ChunkValidator)
local ChunkGeometry = require(script.Parent.ChunkGeometry)
local Types = require(script.Parent.Types)

local regular: { Types.ChunkDef } = {}
local specials: { [string]: Types.ChunkDef } = {}
local coinCounts: { [Types.ChunkDef]: number } = {}
local candidateCache: { [string]: { Types.ChunkDef } } = {}
local seenIds: { [string]: boolean } = {}

for _, chunk in Chunks do
	local errors = ChunkValidator.validate(chunk)
	if seenIds[chunk.id] then
		table.insert(errors, `{chunk.id}: id repetido`)
	end
	seenIds[chunk.id] = true

	if #errors > 0 then
		for _, message in errors do
			warn(`[ChunkLibrary] chunk ignorado: {message}`)
		end
		continue
	end

	coinCounts[chunk] = ChunkGeometry.coinCount(chunk)
	if chunk.special then
		specials[chunk.special] = chunk
	else
		table.insert(regular, chunk)
	end
end

assert(specials.Start and specials.PageTurn, "[ChunkLibrary] faltam os chunks especiais Start e PageTurn")
assert(#regular > 0, "[ChunkLibrary] nenhum chunk regular válido")

local ChunkLibrary = {}

function ChunkLibrary.special(kind: "Start" | "PageTurn"): Types.ChunkDef
	return specials[kind]
end

function ChunkLibrary.coinCount(chunk: Types.ChunkDef): number
	return coinCounts[chunk] or 0
end

-- Chunks que podem aparecer neste capítulo até a dificuldade indicada
function ChunkLibrary.candidates(chapterId: string, maxDifficulty: number): { Types.ChunkDef }
	local key = `{chapterId}:{maxDifficulty}`
	local cached = candidateCache[key]
	if cached then
		return cached
	end

	local list: { Types.ChunkDef } = {}
	for _, chunk in regular do
		local chapterOk = chunk.chapters == nil or table.find(chunk.chapters, chapterId) ~= nil
		if chapterOk and chunk.difficulty <= maxDifficulty then
			table.insert(list, chunk)
		end
	end
	if #list == 0 then
		warn(`[ChunkLibrary] sem chunks para {key}; usando qualquer capítulo`)
		for _, chunk in regular do
			if chunk.difficulty <= maxDifficulty then
				table.insert(list, chunk)
			end
		end
	end
	if #list == 0 then
		list = regular
	end

	candidateCache[key] = list
	return list
end

return ChunkLibrary
