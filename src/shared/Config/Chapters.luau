--!strict
-- Capítulos (ambientes) do Livro de Natal: regras de jogo. O visual de cada um fica em Config/Themes.
-- Capítulo novo = linha aqui + tema em Themes + nome em Strings.

export type ChapterDef = {
	id: string,
	chaserId: string,
	bossId: string?, -- chefes entram numa fase posterior
	freeByDefault: boolean,
	price: number?, -- a definir (GDD seção 19)
	musicId: string, -- a definir: origem e licença do áudio em aberto
}

local ById: { [string]: ChapterDef } = {
	Gingerbread = {
		id = "Gingerbread",
		chaserId = "Krampus",
		bossId = "GrumpyGreen",
		freeByDefault = true,
		musicId = "",
	},
	ToyFactory = {
		id = "ToyFactory",
		chaserId = "RebelElf",
		freeByDefault = true,
		musicId = "",
	},
	NorthPole = {
		id = "NorthPole",
		chaserId = "Krampus",
		bossId = "IceKing",
		freeByDefault = true,
		musicId = "",
	},
}

local Chapters = {
	ById = ById,
	-- Ordem das páginas do livro: a corrida avança por esta lista em ciclo
	Order = { "Gingerbread", "ToyFactory", "NorthPole" },
}

function Chapters.indexOf(id: string): number?
	return table.find(Chapters.Order, id)
end

return Chapters
