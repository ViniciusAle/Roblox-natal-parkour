--!strict
-- Personagens jogáveis (Anime Racers). Personagem novo = linha nova.
-- Todos originais, em estilo anime de luta; um por raridade. Preços a definir.
-- Visual: modelo em ReplicatedStorage.Assets.Characters.<id> quando existir (Blender ou Creator Store,
-- registrado em docs/ASSETS.md); sem modelo, usa a receita de peças em Config/Props.

export type HeroPassive = {
	coinMultiplier: number?,
	startShield: boolean?,
	laneSwitchTimeMultiplier: number?,
	slideDurationMultiplier: number?,
	glideDurationMultiplier: number?,
}

export type HeroDef = {
	id: string,
	rarity: string, -- id em Config/Rarities
	color: Color3, -- cor principal (aura, interface)
	freeByDefault: boolean,
	price: number?,
	passive: HeroPassive,
	activeId: string?, -- id em Abilities.HeroActives
	recipe: string, -- visual de peças em Config/Props (reserva quando não há modelo)
}

local ById: { [string]: HeroDef } = {
	-- Comum: aprendiz de jaqueta azul e cachecol vermelho
	Riku = {
		id = "Riku",
		rarity = "Common",
		recipe = "HeroRiku",
		color = Color3.fromRGB(60, 120, 220),
		freeByDefault = true,
		passive = { coinMultiplier = 1.1 },
	},
	-- Raro: espadachim de cabelo rosa e quimono verde
	Hana = {
		id = "Hana",
		rarity = "Rare",
		recipe = "HeroHana",
		color = Color3.fromRGB(80, 190, 120),
		freeByDefault = false,
		passive = { laneSwitchTimeMultiplier = 0.85 },
		activeId = "Dash",
	},
	-- Épico: lutador grandão de moicano roxo
	Gorou = {
		id = "Gorou",
		rarity = "Epic",
		recipe = "HeroGorou",
		color = Color3.fromRGB(160, 80, 230),
		freeByDefault = false,
		passive = { startShield = true, slideDurationMultiplier = 1.3 },
		activeId = "Smash",
	},
	-- Lendário: guerreiro de cabelo prateado e manto vermelho
	Ryuga = {
		id = "Ryuga",
		rarity = "Legendary",
		recipe = "HeroRyuga",
		color = Color3.fromRGB(230, 50, 60),
		freeByDefault = false,
		passive = { coinMultiplier = 1.2, startShield = true },
		activeId = "Dash",
	},
	-- Secreto: guardiã celestial de cabelo azul-gelo e auréola
	Akari = {
		id = "Akari",
		rarity = "Secret",
		recipe = "HeroAkari",
		color = Color3.fromRGB(120, 230, 255),
		freeByDefault = false,
		passive = { glideDurationMultiplier = 1.75, coinMultiplier = 1.25 },
		activeId = "TimeSlow",
	},
}

return {
	ById = ById,
	Order = { "Riku", "Hana", "Gorou", "Ryuga", "Akari" },
}
