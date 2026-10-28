--!strict
-- Vilões. O perseguidor está desligado por enquanto (GameConfig.Chaser.Enabled = false);
-- fica aqui para voltar depois. Todos originais.

export type VillainDef = {
	id: string,
	kind: "Chaser" | "Boss",
	color: Color3,
	accent: Color3,
	recipe: string?, -- receita em Config/Props
}

local ById: { [string]: VillainDef } = {
	ShadowNinja = {
		id = "ShadowNinja",
		recipe = "ChaserShadow",
		kind = "Chaser",
		color = Color3.fromRGB(25, 22, 32),
		accent = Color3.fromRGB(255, 60, 80),
	},
}

return { ById = ById }
