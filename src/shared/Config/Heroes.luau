--!strict
-- Heróis jogáveis (GDD seção 6). Herói novo = linha nova.
-- Cores são provisórias até existir modelo de cada herói; preços a definir.

export type HeroPassive = {
	coinMultiplier: number?,
	startShield: boolean?,
	laneSwitchTimeMultiplier: number?,
	slideDurationMultiplier: number?,
	glideDurationMultiplier: number?,
}

export type HeroDef = {
	id: string,
	color: Color3,
	freeByDefault: boolean,
	price: number?,
	passive: HeroPassive,
	activeId: string?, -- id em Abilities.HeroActives
	recipe: string, -- visual provisório em Config/Props
	modelId: string?, -- modelo final (Creator Store ou arte própria)
}

local ById: { [string]: HeroDef } = {
	Elf = {
		id = "Elf",
		recipe = "HeroElf",
		color = Color3.fromRGB(60, 170, 80),
		freeByDefault = true,
		passive = { coinMultiplier = 1.1 },
	},
	Santa = {
		id = "Santa",
		recipe = "HeroSanta",
		color = Color3.fromRGB(210, 40, 40),
		freeByDefault = false,
		passive = { startShield = true, laneSwitchTimeMultiplier = 1.25 },
	},
	Reindeer = {
		id = "Reindeer",
		recipe = "HeroReindeer",
		color = Color3.fromRGB(140, 90, 50),
		freeByDefault = false,
		passive = {},
		activeId = "NoseDash",
	},
	Snowman = {
		id = "Snowman",
		recipe = "HeroSnowman",
		color = Color3.fromRGB(245, 245, 250),
		freeByDefault = false,
		passive = { slideDurationMultiplier = 1.5 },
		activeId = "SnowballRoll",
	},
	IceFairy = {
		id = "IceFairy",
		recipe = "HeroIceFairy",
		color = Color3.fromRGB(150, 220, 255),
		freeByDefault = false,
		passive = { glideDurationMultiplier = 1.75 },
		activeId = "TimeFreeze",
	},
}

return {
	ById = ById,
	Order = { "Elf", "Santa", "Reindeer", "Snowman", "IceFairy" },
}
