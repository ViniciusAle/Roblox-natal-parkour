--!strict
-- Raridades dos personagens, da mais comum à mais rara. Nome exibido em Strings.Rarities.

export type RarityDef = {
	id: string,
	rank: number, -- 1 = Comum ... 5 = Secreto
	color: Color3,
	glow: Color3, -- brilho da aura e da moldura do cartão
}

local ById: { [string]: RarityDef } = {
	Common = { id = "Common", rank = 1, color = Color3.fromRGB(170, 176, 190), glow = Color3.fromRGB(220, 225, 235) },
	Rare = { id = "Rare", rank = 2, color = Color3.fromRGB(60, 140, 255), glow = Color3.fromRGB(120, 190, 255) },
	Epic = { id = "Epic", rank = 3, color = Color3.fromRGB(170, 70, 255), glow = Color3.fromRGB(210, 140, 255) },
	Legendary = { id = "Legendary", rank = 4, color = Color3.fromRGB(255, 170, 30), glow = Color3.fromRGB(255, 215, 90) },
	Secret = { id = "Secret", rank = 5, color = Color3.fromRGB(255, 60, 120), glow = Color3.fromRGB(255, 150, 200) },
}

return {
	ById = ById,
	Order = { "Common", "Rare", "Epic", "Legendary", "Secret" },
}
