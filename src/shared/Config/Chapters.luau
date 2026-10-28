--!strict
-- Capítulos (biomas) do Anime Racers: regras de jogo. O visual de cada um fica em Config/Themes.
-- Capítulo novo = linha aqui + tema em Themes + nome em Strings + música em Sounds.Music.
-- Os biomas são originais (inspirados no clima de animes, sem copiar lugares de nenhuma obra).

export type ChapterDef = {
	id: string,
	chaserId: string?, -- perseguidor desligado por enquanto (GameConfig.Chaser.Enabled)
	bossId: string?, -- chefes entram numa fase posterior
	freeByDefault: boolean,
	price: number?, -- a definir
}

local ById: { [string]: ChapterDef } = {
	NinjaVillage = { id = "NinjaVillage", freeByDefault = true },
	HarborVillage = { id = "HarborVillage", freeByDefault = true },
	AlienPlanet = { id = "AlienPlanet", freeByDefault = true },
}

local Chapters = {
	ById = ById,
	-- Ordem dos biomas: a corrida avança por esta lista em ciclo
	Order = { "NinjaVillage", "HarborVillage", "AlienPlanet" },
}

function Chapters.indexOf(id: string): number?
	return table.find(Chapters.Order, id)
end

return Chapters
