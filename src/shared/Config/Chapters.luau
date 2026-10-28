--!strict
-- Capítulos (biomas) do Brainrot Rush: regras de jogo. O visual de cada um fica em Config/Themes.
-- Capítulo novo = linha aqui + tema em Themes + nome em Strings + música em Sounds.Music.
-- Os biomas são originais: praça italiana, praia e espaço, cheios de comida gigante com olhos.

export type ChapterDef = {
	id: string,
	chaserId: string?, -- perseguidor desligado por enquanto (GameConfig.Chaser.Enabled)
	bossId: string?, -- chefes entram numa fase posterior
	freeByDefault: boolean,
	price: number?, -- a definir
}

local ById: { [string]: ChapterDef } = {
	PizzaPiazza = { id = "PizzaPiazza", freeByDefault = true },
	BananaBeach = { id = "BananaBeach", freeByDefault = true },
	ChaosCosmos = { id = "ChaosCosmos", freeByDefault = true },
}

local Chapters = {
	ById = ById,
	-- Ordem dos biomas: a corrida avança por esta lista em ciclo
	Order = { "PizzaPiazza", "BananaBeach", "ChaosCosmos" },
}

function Chapters.indexOf(id: string): number?
	return table.find(Chapters.Order, id)
end

return Chapters
