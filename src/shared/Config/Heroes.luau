--!strict
-- Personagens jogáveis (Brainrot Rush). Personagem novo = linha nova.
-- Os brainrots famosos dos memes, um por raridade, montados do zero com peças (decisão do dono do jogo em 28/10/2026).
-- Risco conhecido: há pedidos de marca de terceiros sobre alguns nomes (ver docs/ASSETS.md). Se um precisar sair,
-- troque recipe e o nome por uma das criaturas originais de reserva em Config/Props (HeroPollo, HeroLumaca etc.).
-- Visual (em ordem de prioridade):
--   1. Model em ReplicatedStorage.Assets.Characters.<id>: o tools/ImportModels.lua baixa o campo model da loja
--      (ou coloque um à mão; registrar em docs/ASSETS.md). rot corrige um modelo torto ou de costas (graus);
--   2. corpo R15 montado pelo servidor com itens do catálogo do Roblox (campo avatar; nenhum brainrot usa);
--   3. receita de peças em Config/Props (reserva enquanto o modelo não foi importado).

export type HeroPassive = {
	coinMultiplier: number?,
	startShield: boolean?,
	laneSwitchTimeMultiplier: number?,
	slideDurationMultiplier: number?,
	glideDurationMultiplier: number?,
}

-- Itens do catálogo (ids de asset) para montar o corpo R15 com HumanoidDescription
export type HeroAvatar = {
	hair: number,
	shirt: number,
	pants: number,
	skin: Color3,
	width: number?, -- escala do corpo (1 = normal)
	height: number?,
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
	avatar: HeroAvatar?,
	model: { id: number, rot: Vector3? }?, -- modelo pronto da Creator Store (sem scripts)
}

local ById: { [string]: HeroDef } = {
	-- Comum: tronco de árvore com cara de macaco e pés enormes
	BrrBrrPatapim = {
		id = "BrrBrrPatapim",
		rarity = "Common",
		recipe = "HeroPatapim",
		model = { id = 100538198930997 }, -- brr brr patapim (Haxcyc_LDC)
		color = Color3.fromRGB(120, 200, 80),
		freeByDefault = true,
		passive = { coinMultiplier = 1.1 },
	},
	-- Raro: bailarina com xícara de cappuccino na cabeça; o poder é uma pirueta para a frente
	BallerinaCappuccina = {
		id = "BallerinaCappuccina",
		rarity = "Rare",
		recipe = "HeroBallerina",
		model = { id = 132021456717690 }, -- Ballerina Cappuccina (vexqty)
		color = Color3.fromRGB(255, 150, 200),
		freeByDefault = false,
		passive = { laneSwitchTimeMultiplier = 0.85 },
		activeId = "Dash",
	},
	-- Épico: tora de madeira com taco; o poder quebra o obstáculo com uma tacada
	TungTungSahur = {
		id = "TungTungSahur",
		rarity = "Epic",
		recipe = "HeroTung",
		model = { id = 138151705692565 }, -- Tung Tung Tung Sahur (ATMnou)
		color = Color3.fromRGB(230, 170, 100),
		freeByDefault = false,
		passive = { startShield = true, slideDurationMultiplier = 1.3 },
		activeId = "Smash",
	},
	-- Lendário: tubarão de três pernas e tênis; o poder deixa o tempo lento
	TralaleroTralala = {
		id = "TralaleroTralala",
		rarity = "Legendary",
		recipe = "HeroTralalero",
		model = { id = 113095126725171 }, -- Tralalero Tralala (capuchin_queso)
		color = Color3.fromRGB(70, 160, 255),
		freeByDefault = false,
		passive = { coinMultiplier = 1.2, startShield = true },
		activeId = "TimeSlow",
	},
	-- Secreto: crocodilo-bombardeiro; o poder solta uma bomba que destrói o obstáculo à frente
	BombardiroCrocodilo = {
		id = "BombardiroCrocodilo",
		rarity = "Secret",
		recipe = "HeroBombardiro",
		model = { id = 91327024837680 }, -- Bombardiro Crocodilo [Working] (F0g_02; scripts removidos na importação)
		color = Color3.fromRGB(170, 255, 60),
		freeByDefault = false,
		passive = { glideDurationMultiplier = 1.75, coinMultiplier = 1.25 },
		activeId = "EnergyBlast",
	},
}

return {
	ById = ById,
	Order = { "BrrBrrPatapim", "BallerinaCappuccina", "TungTungSahur", "TralaleroTralala", "BombardiroCrocodilo" },
}
