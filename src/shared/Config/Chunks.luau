--!strict
-- Blocos de pista (60 studs, 3 pistas). Chunk novo = entrada nova; o ChunkValidator recusa chunks injustos.
-- z em studs a partir da entrada. Obstáculos ficam entre EdgeMargin (6) e 54 para o encaixe ser sempre livre.
-- Pista 1 = esquerda, 2 = meio, 3 = direita. "chapters = nil" serve em qualquer capítulo.

local Types = require(script.Parent.Parent.Types)

local Chunks: { Types.ChunkDef } = {
	-- Especiais
	{
		id = "start",
		difficulty = 1,
		special = "Start",
		objects = {
			{ kind = "Coins", lane = 2, z = 10, count = 10, spacing = 4 },
		},
	},
	{
		id = "page_turn",
		difficulty = 1,
		special = "PageTurn",
		objects = {
			{ kind = "Coins", lane = 1, z = 8, count = 6, spacing = 4 },
			{ kind = "Coins", lane = 3, z = 8, count = 6, spacing = 4 },
		},
	},

	-- Dificuldade 1: um perigo por vez, muito espaço
	{
		id = "d1_low_center",
		difficulty = 1,
		objects = {
			{ kind = "Low", lane = 2, z = 30 },
			{ kind = "Coins", lane = 2, z = 26, count = 5, spacing = 2.5, arcHeight = 4 },
			{ kind = "Coins", lane = 1, z = 10, count = 8, spacing = 5 },
		},
	},
	{
		id = "d1_high_sides",
		difficulty = 1,
		objects = {
			{ kind = "High", lane = 1, z = 24 },
			{ kind = "High", lane = 3, z = 40 },
			{ kind = "Coins", lane = 2, z = 8, count = 10, spacing = 4.5 },
		},
	},
	{
		id = "d1_block_left",
		difficulty = 1,
		objects = {
			{ kind = "Block", lane = 1, z = 10, length = 30 },
			{ kind = "Coins", lane = 2, z = 12, count = 7, spacing = 4 },
			{ kind = "PowerUp", lane = 3, z = 30, powerUp = "Magnet" },
		},
	},
	{
		id = "d1_coin_lanes",
		difficulty = 1,
		objects = {
			{ kind = "Coins", lane = 1, z = 6, count = 5, spacing = 4 },
			{ kind = "Coins", lane = 2, z = 26, count = 5, spacing = 4 },
			{ kind = "Coins", lane = 3, z = 46, count = 3, spacing = 4 },
			{ kind = "Low", lane = 1, z = 40 },
		},
	},

	-- Dificuldade 2: combinações simples, primeiro vão e trampolim
	{
		id = "d2_corridor_jump",
		difficulty = 2,
		objects = {
			{ kind = "Block", lane = 1, z = 8, length = 22 },
			{ kind = "Block", lane = 3, z = 8, length = 22 },
			{ kind = "Low", lane = 2, z = 20 },
			{ kind = "Coins", lane = 2, z = 16, count = 5, spacing = 2.5, arcHeight = 4 },
			{ kind = "Coins", lane = 2, z = 36, count = 4, spacing = 4 },
		},
	},
	{
		id = "d2_mixed_row",
		difficulty = 2,
		objects = {
			{ kind = "Low", lane = 1, z = 16 },
			{ kind = "High", lane = 2, z = 16 },
			{ kind = "Low", lane = 3, z = 16 },
			{ kind = "PowerUp", lane = 2, z = 28, powerUp = "Shield" },
			{ kind = "High", lane = 1, z = 40 },
			{ kind = "Low", lane = 2, z = 40 },
			{ kind = "High", lane = 3, z = 40 },
		},
	},
	{
		id = "d2_trampoline",
		difficulty = 2,
		objects = {
			{ kind = "Trampoline", lane = 2, z = 8 },
			{ kind = "Coins", lane = 2, z = 14, count = 10, spacing = 3.5, arcHeight = 16 },
			{ kind = "Block", lane = 1, z = 20, length = 20 },
			{ kind = "Block", lane = 3, z = 20, length = 20 },
		},
	},
	{
		id = "d2_gap",
		difficulty = 2,
		objects = {
			{ kind = "Gap", z = 24, length = 10 },
			{ kind = "Coins", lane = 2, z = 21, count = 7, spacing = 2.5, arcHeight = 5 },
		},
	},

	-- Dificuldade 3: zigue-zague e corredores
	{
		id = "d3_zigzag",
		difficulty = 3,
		objects = {
			{ kind = "Block", lane = 1, z = 6, length = 16 },
			{ kind = "Block", lane = 2, z = 26, length = 14 },
			{ kind = "Block", lane = 3, z = 44, length = 10 },
			{ kind = "Coins", lane = 3, z = 8, count = 4, spacing = 4 },
			{ kind = "Coins", lane = 1, z = 28, count = 4, spacing = 4 },
			{ kind = "Coins", lane = 2, z = 44, count = 3, spacing = 4 },
		},
	},
	{
		id = "d3_slide_corridor",
		difficulty = 3,
		objects = {
			{ kind = "Block", lane = 1, z = 6, length = 48 },
			{ kind = "Block", lane = 3, z = 6, length = 48 },
			{ kind = "High", lane = 2, z = 18 },
			{ kind = "Coins", lane = 2, z = 24, count = 3, spacing = 4 },
			{ kind = "Low", lane = 2, z = 38 },
		},
	},
	{
		id = "d3_gap_long",
		difficulty = 3,
		objects = {
			{ kind = "Gap", z = 18, length = 14 },
			{ kind = "Coins", lane = 1, z = 14, count = 9, spacing = 2.5, arcHeight = 6 },
			{ kind = "Low", lane = 2, z = 44 },
			{ kind = "PowerUp", lane = 3, z = 46, powerUp = "DoubleCoins" },
		},
	},

	-- Dificuldade 4
	{
		id = "d4_mixed",
		difficulty = 4,
		objects = {
			{ kind = "Block", lane = 2, z = 6, length = 20 },
			{ kind = "Low", lane = 1, z = 14 },
			{ kind = "High", lane = 3, z = 14 },
			{ kind = "Gap", z = 36, length = 10 },
			{ kind = "Coins", lane = 2, z = 32, count = 7, spacing = 2.5, arcHeight = 5 },
		},
	},
	{
		id = "d4_double_row",
		difficulty = 4,
		objects = {
			{ kind = "Block", lane = 3, z = 6, length = 14 },
			{ kind = "High", lane = 1, z = 12 },
			{ kind = "High", lane = 2, z = 12 },
			{ kind = "Block", lane = 1, z = 26, length = 14 },
			{ kind = "Low", lane = 2, z = 32 },
			{ kind = "Low", lane = 3, z = 32 },
			{ kind = "PowerUp", lane = 2, z = 46, powerUp = "Skates" },
		},
	},

	-- Dificuldade 5
	{
		id = "d5_gauntlet",
		difficulty = 5,
		objects = {
			{ kind = "Block", lane = 1, z = 6, length = 14 },
			{ kind = "Block", lane = 3, z = 6, length = 14 },
			{ kind = "Low", lane = 2, z = 12 },
			{ kind = "Block", lane = 2, z = 26, length = 12 },
			{ kind = "High", lane = 1, z = 30 },
			{ kind = "Low", lane = 3, z = 30 },
			{ kind = "Block", lane = 1, z = 44, length = 10 },
			{ kind = "Block", lane = 3, z = 44, length = 10 },
			{ kind = "High", lane = 2, z = 48 },
		},
	},
	{
		id = "d5_gap_zigzag",
		difficulty = 5,
		objects = {
			{ kind = "Block", lane = 1, z = 6, length = 12 },
			{ kind = "Block", lane = 2, z = 6, length = 12 },
			{ kind = "Coins", lane = 3, z = 8, count = 4, spacing = 3 },
			{ kind = "Gap", z = 22, length = 12 },
			{ kind = "Block", lane = 2, z = 38, length = 16 },
			{ kind = "Block", lane = 3, z = 38, length = 16 },
			{ kind = "Coins", lane = 1, z = 40, count = 4, spacing = 3 },
		},
	},
}

return Chunks
