--!strict
-- Vilões (GDD seção 7). Todos originais ou do folclore; o Ranzinza Verde NÃO pode lembrar o Grinch.
-- Cores provisórias até existir modelo; chefes entram numa fase posterior.

export type VillainDef = {
	id: string,
	kind: "Chaser" | "Boss",
	color: Color3,
	accent: Color3,
	recipe: string?, -- receita provisória em Config/Props
	modelId: string?,
}

local ById: { [string]: VillainDef } = {
	Krampus = {
		id = "Krampus",
		recipe = "ChaserKrampus",
		kind = "Chaser",
		color = Color3.fromRGB(60, 30, 30),
		accent = Color3.fromRGB(230, 220, 200),
	},
	RebelElf = {
		id = "RebelElf",
		recipe = "ChaserRebelElf",
		kind = "Chaser",
		color = Color3.fromRGB(110, 40, 140),
		accent = Color3.fromRGB(250, 200, 50),
	},
	GrumpyGreen = {
		id = "GrumpyGreen",
		kind = "Boss",
		color = Color3.fromRGB(120, 150, 60),
		accent = Color3.fromRGB(240, 240, 240),
	},
	IceKing = {
		id = "IceKing",
		kind = "Boss",
		color = Color3.fromRGB(150, 210, 255),
		accent = Color3.fromRGB(255, 255, 255),
	},
}

return { ById = ById }
