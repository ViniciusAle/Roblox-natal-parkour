--!strict
-- Receitas visuais (obstáculos, cenário, personagens e lobby) montadas com peças básicas.
-- Guia de estilo em docs/STYLE.md. Prop novo = receita nova; nada de lógica aqui.
-- Convenção: a caixa olha para -Z (sentido da corrida); a face +Z é a que o jogador vê chegando.
-- Telhados e cabelos usam blocos girados (rot), não cunhas: o resultado não depende da orientação da cunha.

local PropAssembler = require(script.Parent.Parent.PropAssembler)

type PartSpec = PropAssembler.PartSpec
type Recipe = PropAssembler.Recipe

local function v(x: number, y: number, z: number): Vector3
	return Vector3.new(x, y, z)
end

local function rgb(r: number, g: number, b: number): Color3
	return Color3.fromRGB(r, g, b)
end

local NEON = Enum.Material.Neon
local WOOD = Enum.Material.WoodPlanks
local SLATE = Enum.Material.Slate
local SAND = Enum.Material.Sand
local GLASS = Enum.Material.Glass
local FABRIC = Enum.Material.Fabric

-- Paleta
local C = {
	white = rgb(250, 248, 242),
	black = rgb(30, 28, 34),
	gold = rgb(250, 196, 50),
	red = rgb(214, 48, 52),
	-- Vila ninja
	wood = rgb(120, 78, 45),
	woodDark = rgb(70, 45, 30),
	woodLight = rgb(176, 128, 80),
	plaster = rgb(240, 232, 214),
	slate = rgb(58, 64, 80),
	slateLight = rgb(86, 94, 112),
	torii = rgb(206, 52, 40),
	temple = rgb(170, 50, 40),
	stone = rgb(160, 158, 150),
	stoneDark = rgb(112, 110, 106),
	sakura = rgb(255, 170, 200),
	sakuraDeep = rgb(245, 125, 165),
	sakuraLight = rgb(255, 208, 226),
	bamboo = rgb(120, 180, 80),
	bambooDark = rgb(70, 130, 55),
	lantern = rgb(255, 200, 110),
	shoji = rgb(255, 228, 165),
	indigo = rgb(48, 58, 120),
	mountain = rgb(112, 132, 165),
	snowCap = rgb(240, 245, 252),
	-- Vila do porto
	sand = rgb(238, 214, 160),
	palmTrunk = rgb(150, 105, 60),
	palmLeaf = rgb(60, 170, 80),
	palmLeaf2 = rgb(100, 205, 95),
	wallYellow = rgb(250, 214, 120),
	wallTeal = rgb(110, 200, 190),
	wallCoral = rgb(245, 160, 140),
	roofOrange = rgb(228, 108, 52),
	roofBlue = rgb(60, 110, 190),
	sail = rgb(250, 247, 238),
	sailStripe = rgb(220, 60, 50),
	rope = rgb(206, 176, 116),
	crate = rgb(196, 146, 86),
	crateDark = rgb(150, 104, 60),
	grassGreen = rgb(96, 180, 90),
	-- Planeta verde
	rock = rgb(104, 140, 128),
	rockDark = rgb(70, 100, 96),
	crystal = rgb(176, 120, 255),
	vine = rgb(110, 255, 170),
	vineDark = rgb(40, 140, 100),
	glowCyan = rgb(120, 255, 230),
	shroomCap = rgb(220, 80, 170),
	shroomCapDark = rgb(160, 50, 130),
	shroomStalk = rgb(232, 218, 242),
	alienLeaf = rgb(70, 200, 160),
	alienLeaf2 = rgb(150, 235, 120),
	spore = rgb(230, 255, 120),
	-- Personagens
	skin = rgb(255, 222, 194),
	skinTan = rgb(222, 170, 122),
	eye = rgb(32, 30, 44),
	mouth = rgb(170, 80, 80),
}

local function recipe(...: { PartSpec }): Recipe
	local parts: { PartSpec } = {}
	for _, group in { ... } do
		for _, spec in group do
			table.insert(parts, spec)
		end
	end
	return { parts = parts }
end

local function lit(base: Recipe, color: Color3, at: Vector3): Recipe
	return { parts = base.parts, light = { color = color, range = 20, brightness = 1.6, at = at } }
end

local Recipes: { [string]: Recipe } = {}

------------------------------------------------------------------------------------------
-- Fase 1: Vila Ninja (madeira, cerejeiras, lanternas de pedra, telhados em camadas)
------------------------------------------------------------------------------------------

-- Baixo: barris de madeira amarrados (pular)
Recipes.WoodBarrels = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(-0.33, -0.02, 0), size = v(0.26, 0.96, 0.9), color = C.wood, material = WOOD },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.02, 0), size = v(0.26, 0.96, 0.9), color = C.woodLight, material = WOOD },
	{ shape = "Cylinder", axis = "Y", pos = v(0.33, -0.02, 0), size = v(0.26, 0.96, 0.9), color = C.wood, material = WOOD },
	{ shape = "Cylinder", axis = "Y", pos = v(-0.33, 0.25, 0), size = v(0.27, 0.07, 0.92), color = C.woodDark },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.25, 0), size = v(0.27, 0.07, 0.92), color = C.woodDark },
	{ shape = "Cylinder", axis = "Y", pos = v(0.33, 0.25, 0), size = v(0.27, 0.07, 0.92), color = C.woodDark },
	{ shape = "Cylinder", axis = "Y", pos = v(-0.33, -0.3, 0), size = v(0.27, 0.07, 0.92), color = C.woodDark },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.3, 0), size = v(0.27, 0.07, 0.92), color = C.woodDark },
	{ shape = "Cylinder", axis = "Y", pos = v(0.33, -0.3, 0), size = v(0.27, 0.07, 0.92), color = C.woodDark },
	{ pos = v(0, 0.08, 0.42), size = v(0.92, 0.06, 0.05), color = C.rope, material = FABRIC },
	{ pos = v(0, 0.47, 0.1), size = v(0.12, 0.06, 0.3), color = C.red },
})

-- Alto: portal torii com cortinas noren (deslizar por baixo)
Recipes.ToriiBeam = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(-0.44, 0, 0), size = v(0.08, 1, 0.4), color = C.torii },
	{ shape = "Cylinder", axis = "Y", pos = v(0.44, 0, 0), size = v(0.08, 1, 0.4), color = C.torii },
	{ shape = "Cylinder", axis = "Y", pos = v(-0.44, -0.47, 0), size = v(0.1, 0.06, 0.5), color = C.black },
	{ shape = "Cylinder", axis = "Y", pos = v(0.44, -0.47, 0), size = v(0.1, 0.06, 0.5), color = C.black },
	{ pos = v(0, 0.475, 0), size = v(1.1, 0.05, 0.6), color = C.black },
	{ pos = v(0, 0.43, 0), size = v(1.02, 0.05, 0.5), color = C.torii },
	{ pos = v(0, 0.27, 0), size = v(0.96, 0.05, 0.4), color = C.torii },
	{ pos = v(0, 0.35, 0.12), size = v(0.14, 0.1, 0.06), color = C.black },
	{ pos = v(0, 0.35, 0.155), size = v(0.1, 0.07, 0.02), color = C.gold },
	{ pos = v(-0.3, 0.075, 0), size = v(0.18, 0.34, 0.06), color = C.indigo, material = FABRIC },
	{ pos = v(-0.1, 0.075, 0), size = v(0.18, 0.34, 0.06), color = C.indigo, material = FABRIC },
	{ pos = v(0.1, 0.075, 0), size = v(0.18, 0.34, 0.06), color = C.indigo, material = FABRIC },
	{ pos = v(0.3, 0.075, 0), size = v(0.18, 0.34, 0.06), color = C.indigo, material = FABRIC },
	{ pos = v(0, -0.09, 0), size = v(0.78, 0.025, 0.065), color = C.white },
	{ shape = "Cylinder", axis = "Z", pos = v(-0.1, 0.1, 0.035), size = v(0.09, 0.05, 0.02), color = C.white },
	{ shape = "Cylinder", axis = "Z", pos = v(0.1, 0.1, 0.035), size = v(0.09, 0.05, 0.02), color = C.white },
})

-- Bloco: casa japonesa de dois andares com telhado em camadas
Recipes.JapaneseHouse = recipe({
	{ pos = v(0, -0.47, 0), size = v(1, 0.06, 1), color = C.stone, material = SLATE },
	{ pos = v(0, -0.22, 0), size = v(0.86, 0.44, 0.86), color = C.plaster },
	{ pos = v(-0.42, -0.22, 0.42), size = v(0.05, 0.44, 0.05), color = C.woodDark },
	{ pos = v(0.42, -0.22, 0.42), size = v(0.05, 0.44, 0.05), color = C.woodDark },
	{ pos = v(-0.42, -0.22, -0.42), size = v(0.05, 0.44, 0.05), color = C.woodDark },
	{ pos = v(0.42, -0.22, -0.42), size = v(0.05, 0.44, 0.05), color = C.woodDark },
	{ pos = v(0, -0.02, 0), size = v(0.88, 0.04, 0.88), color = C.woodDark },
	{ pos = v(-0.2, -0.19, 0.432), size = v(0.26, 0.18, 0.02), color = C.shoji, material = NEON },
	{ pos = v(-0.2, -0.19, 0.442), size = v(0.02, 0.18, 0.02), color = C.woodDark },
	{ pos = v(-0.2, -0.19, 0.442), size = v(0.26, 0.015, 0.02), color = C.woodDark },
	{ pos = v(0.2, -0.28, 0.432), size = v(0.2, 0.3, 0.02), color = C.woodDark },
	{ pos = v(0.2, -0.165, 0.445), size = v(0.22, 0.08, 0.02), color = C.indigo, material = FABRIC },
	{ shape = "Ball", pos = v(0.02, -0.12, 0.47), size = v(0.07, 0.05, 0.07), color = C.red, material = NEON },
	{ pos = v(0, 0.04, 0), size = v(1.02, 0.05, 1.02), color = C.slate, material = SLATE },
	{ pos = v(0, 0.09, 0), size = v(0.86, 0.05, 0.86), color = C.slateLight, material = SLATE },
	{ pos = v(0, 0.14, 0), size = v(0.7, 0.05, 0.7), color = C.slate, material = SLATE },
	{ pos = v(0, 0.27, 0), size = v(0.56, 0.18, 0.56), color = C.plaster },
	{ pos = v(0, 0.27, 0.282), size = v(0.24, 0.1, 0.02), color = C.shoji, material = NEON },
	{ pos = v(0, 0.27, 0.292), size = v(0.02, 0.1, 0.02), color = C.woodDark },
	{ pos = v(0, 0.385, 0), size = v(0.76, 0.05, 0.76), color = C.slate, material = SLATE },
	{ pos = v(0, 0.435, 0), size = v(0.58, 0.05, 0.58), color = C.slateLight, material = SLATE },
	{ pos = v(0, 0.48, 0), size = v(0.42, 0.04, 0.1), color = C.slate, material = SLATE },
})

Recipes.SakuraTree = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.3, 0), size = v(0.12, 0.4, 0.14), color = C.woodDark },
	{ pos = v(-0.12, -0.06, 0), size = v(0.06, 0.2, 0.06), rot = v(0, 0, 35), color = C.woodDark },
	{ pos = v(0.12, -0.04, 0.05), size = v(0.06, 0.2, 0.06), rot = v(0, 0, -35), color = C.woodDark },
	{ shape = "Ball", pos = v(0, 0.12, 0), size = v(0.85, 0.45, 0.85), color = C.sakura },
	{ shape = "Ball", pos = v(-0.25, 0.05, 0.15), size = v(0.55, 0.3, 0.55), color = C.sakuraDeep },
	{ shape = "Ball", pos = v(0.28, 0.08, -0.1), size = v(0.55, 0.3, 0.55), color = C.sakuraLight },
	{ shape = "Ball", pos = v(0.05, 0.32, 0.05), size = v(0.6, 0.32, 0.6), color = C.sakuraLight },
	{ shape = "Ball", pos = v(-0.1, 0.2, -0.28), size = v(0.45, 0.25, 0.45), color = C.sakuraDeep },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.497, 0), size = v(0.9, 0.006, 0.9), color = C.sakuraLight },
})

Recipes.StoneLantern = recipe({
	{ pos = v(0, -0.45, 0), size = v(0.8, 0.1, 0.8), color = C.stoneDark, material = SLATE },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.22, 0), size = v(0.3, 0.36, 0.3), color = C.stone, material = SLATE },
	{ pos = v(0, 0, 0), size = v(0.7, 0.08, 0.7), color = C.stoneDark, material = SLATE },
	{ pos = v(0, 0.13, 0), size = v(0.46, 0.18, 0.46), color = C.stone, material = SLATE },
	{ pos = v(0, 0.13, 0), size = v(0.3, 0.12, 0.48), color = C.lantern, material = NEON },
	{ pos = v(0, 0.13, 0), size = v(0.48, 0.12, 0.3), color = C.lantern, material = NEON },
	{ pos = v(0, 0.27, 0), size = v(0.9, 0.08, 0.9), color = C.stoneDark, material = SLATE },
	{ pos = v(0, 0.33, 0), size = v(0.6, 0.06, 0.6), color = C.stone, material = SLATE },
	{ shape = "Ball", pos = v(0, 0.41, 0), size = v(0.2, 0.08, 0.2), color = C.stoneDark, material = SLATE },
})
Recipes.StoneLanternLit = lit(Recipes.StoneLantern, C.lantern, v(0, 0.13, 0))

Recipes.Bamboo = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(-0.2, -0.05, 0.1), size = v(0.1, 0.9, 0.1), color = C.bamboo },
	{ shape = "Cylinder", axis = "Y", pos = v(0.05, 0, -0.15), size = v(0.1, 1, 0.1), color = C.bambooDark },
	{ shape = "Cylinder", axis = "Y", pos = v(0.25, -0.1, 0.15), size = v(0.1, 0.8, 0.1), color = C.bamboo },
	{ shape = "Cylinder", axis = "Y", pos = v(-0.05, -0.15, 0.3), size = v(0.09, 0.7, 0.09), color = C.bambooDark },
	{ shape = "Cylinder", axis = "Y", pos = v(-0.2, 0.1, 0.1), size = v(0.11, 0.01, 0.11), color = C.bambooDark },
	{ shape = "Cylinder", axis = "Y", pos = v(0.05, 0.2, -0.15), size = v(0.11, 0.01, 0.11), color = C.bamboo },
	{ shape = "Cylinder", axis = "Y", pos = v(0.25, -0.05, 0.15), size = v(0.11, 0.01, 0.11), color = C.bambooDark },
	{ pos = v(0.15, 0.42, -0.1), size = v(0.32, 0.015, 0.1), rot = v(0, 30, -20), color = C.bamboo },
	{ pos = v(-0.3, 0.34, 0.1), size = v(0.32, 0.015, 0.1), rot = v(0, -20, 20), color = C.bambooDark },
	{ pos = v(0.32, 0.28, 0.2), size = v(0.3, 0.015, 0.1), rot = v(0, 60, -25), color = C.bamboo },
})

-- Pagode de cinco andares (fundo e lobby)
do
	local parts: { PartSpec } = {
		{ pos = v(0, -0.48, 0), size = v(0.8, 0.04, 0.8), color = C.stone, material = SLATE },
	}
	local y = -0.46
	for i = 0, 4 do
		local width = 0.6 - 0.08 * i
		local height = 0.14
		table.insert(parts, { pos = v(0, y + height / 2, 0), size = v(width, height, width), color = C.temple })
		table.insert(parts, {
			pos = v(0, y + height / 2, width / 2 + 0.005),
			size = v(width * 0.4, height * 0.5, 0.01),
			color = C.shoji,
			material = NEON,
		})
		table.insert(parts, {
			pos = v(0, y + height + 0.015, 0),
			size = v(width + 0.25, 0.03, width + 0.25),
			color = C.slate,
			material = SLATE,
		})
		y += height + 0.03
	end
	table.insert(parts, { shape = "Cylinder", axis = "Y", pos = v(0, y + 0.06, 0), size = v(0.03, 0.12, 0.03), color = C.gold })
	Recipes.Pagoda = { parts = parts }
end

-- Montanha: dois prismas cruzados fazem um pico de quatro faces, com neve no topo
local function peak(color: Color3, capColor: Color3): Recipe
	return recipe({
		{ pos = v(0, -0.136, 0), size = v(0.5, 0.9, 0.5), rot = v(0, 0, 45), color = color, material = SLATE },
		{ pos = v(0, -0.136, 0), size = v(0.5, 0.9, 0.5), rot = v(0, 90, 45), color = color, material = SLATE },
		{ pos = v(0, 0.237, 0), size = v(0.21, 0.378, 0.21), rot = v(0, 0, 45), color = capColor },
		{ pos = v(0, 0.237, 0), size = v(0.21, 0.378, 0.21), rot = v(0, 90, 45), color = capColor },
	})
end
Recipes.MistyMountain = peak(C.mountain, C.snowCap)

------------------------------------------------------------------------------------------
-- Fase 2: Vila do Porto (cais, barcos, palmeiras, casas coloridas)
------------------------------------------------------------------------------------------

-- Baixo: caixotes e rolo de corda (pular)
Recipes.CargoCrates = recipe({
	{ pos = v(-0.3, -0.05, 0), size = v(0.3, 0.9, 0.9), color = C.crate, material = WOOD },
	{ pos = v(-0.3, -0.05, 0.455), size = v(0.04, 0.9, 0.02), rot = v(0, 0, 38), color = C.crateDark },
	{ pos = v(-0.3, -0.05, 0.455), size = v(0.04, 0.9, 0.02), rot = v(0, 0, -38), color = C.crateDark },
	{ pos = v(0.05, -0.1, 0.05), size = v(0.28, 0.8, 0.8), color = C.crateDark, material = WOOD },
	{ pos = v(0.05, 0.31, 0.05), size = v(0.29, 0.06, 0.82), color = C.wallTeal },
	{ shape = "Cylinder", axis = "Y", pos = v(0.35, -0.3, 0), size = v(0.24, 0.4, 0.8), color = C.rope, material = FABRIC },
	{ shape = "Cylinder", axis = "Y", pos = v(0.35, -0.09, 0), size = v(0.12, 0.03, 0.4), color = C.crateDark },
})

-- Alto: vela de barco presa entre dois mastros (deslizar por baixo)
Recipes.SailBeam = recipe({
	{ pos = v(-0.45, 0, 0), size = v(0.07, 1, 0.3), color = C.wood, material = WOOD },
	{ pos = v(0.45, 0, 0), size = v(0.07, 1, 0.3), color = C.wood, material = WOOD },
	{ shape = "Cylinder", pos = v(0, 0.45, 0), size = v(1.04, 0.05, 0.25), color = C.woodDark },
	{ pos = v(0, 0.15, 0.05), size = v(0.86, 0.52, 0.04), rot = v(-6, 0, 0), color = C.sail, material = FABRIC },
	{ pos = v(0, 0.2, 0.08), size = v(0.86, 0.1, 0.02), rot = v(-6, 0, 0), color = C.sailStripe, material = FABRIC },
	{ pos = v(0, -0.1, 0.03), size = v(0.88, 0.03, 0.06), color = C.rope, material = FABRIC },
	{ shape = "Ball", pos = v(-0.45, 0.5, 0), size = v(0.09, 0.05, 0.3), color = C.gold },
	{ shape = "Ball", pos = v(0.45, 0.5, 0), size = v(0.09, 0.05, 0.3), color = C.gold },
})

-- Bloco: casa de pescador colorida
local function fisherHouse(wall: Color3, roof: Color3): Recipe
	return recipe({
		{ pos = v(0, -0.47, 0), size = v(0.94, 0.06, 0.94), color = C.woodDark, material = WOOD },
		{ pos = v(0, -0.17, 0), size = v(0.84, 0.54, 0.84), color = wall },
		{ pos = v(-0.42, -0.17, 0.42), size = v(0.04, 0.54, 0.04), color = C.white },
		{ pos = v(0.42, -0.17, 0.42), size = v(0.04, 0.54, 0.04), color = C.white },
		{ pos = v(0.18, -0.3, 0.425), size = v(0.18, 0.28, 0.02), color = C.roofBlue },
		{ shape = "Ball", pos = v(0.24, -0.3, 0.44), size = v(0.03, 0.02, 0.03), color = C.gold },
		{ shape = "Cylinder", axis = "Z", pos = v(-0.2, -0.08, 0.425), size = v(0.2, 0.2, 0.02), color = C.white },
		{ shape = "Cylinder", axis = "Z", pos = v(-0.2, -0.08, 0.432), size = v(0.15, 0.15, 0.02), color = C.shoji, material = NEON },
		{ pos = v(-0.2, -0.19, 0.44), size = v(0.22, 0.03, 0.05), color = C.wood },
		{ shape = "Ball", pos = v(-0.26, -0.165, 0.445), size = v(0.04, 0.03, 0.04), color = C.red },
		{ shape = "Ball", pos = v(-0.15, -0.165, 0.445), size = v(0.04, 0.03, 0.04), color = C.gold },
		{ pos = v(0, 0.1, 0), size = v(0.45, 0.45, 0.8), rot = v(0, 0, 45), color = wall },
		{ pos = v(-0.24, 0.21, 0), size = v(0.6, 0.05, 1.02), rot = v(0, 0, 30), color = roof },
		{ pos = v(0.24, 0.21, 0), size = v(0.6, 0.05, 1.02), rot = v(0, 0, -30), color = roof },
		{ pos = v(0, 0.36, 0), size = v(0.06, 0.04, 1.04), color = C.woodDark },
		{ pos = v(0.28, 0.32, -0.2), size = v(0.08, 0.16, 0.08), color = C.stoneDark },
	})
end
Recipes.FisherHouse = fisherHouse(C.wallYellow, C.roofOrange)
Recipes.FisherHouseTeal = fisherHouse(C.wallTeal, C.roofBlue)
Recipes.FisherHouseCoral = fisherHouse(C.wallCoral, C.roofOrange)

-- Palmeira: tronco curvado em gomos e folhas em leque
do
	local parts: { PartSpec } = {
		{ shape = "Cylinder", axis = "Y", pos = v(0, -0.4, 0), size = v(0.12, 0.22, 0.12), color = C.palmTrunk },
		{ shape = "Cylinder", axis = "Y", pos = v(0.04, -0.2, 0), size = v(0.11, 0.22, 0.11), rot = v(0, 0, -8), color = C.palmTrunk },
		{ shape = "Cylinder", axis = "Y", pos = v(0.1, 0, 0), size = v(0.1, 0.22, 0.1), rot = v(0, 0, -14), color = C.palmTrunk },
		{ shape = "Cylinder", axis = "Y", pos = v(0.17, 0.18, 0), size = v(0.09, 0.2, 0.09), rot = v(0, 0, -20), color = C.palmTrunk },
		{ shape = "Ball", pos = v(0.2, 0.28, 0.04), size = v(0.1, 0.05, 0.1), color = C.woodDark },
		{ shape = "Ball", pos = v(0.24, 0.27, -0.04), size = v(0.1, 0.05, 0.1), color = C.woodDark },
	}
	local leaves = 7
	for i = 0, leaves - 1 do
		local angle = i / leaves * math.pi * 2
		table.insert(parts, {
			pos = v(0.22 + math.cos(angle) * 0.2, 0.29, -math.sin(angle) * 0.2),
			size = v(0.42, 0.012, 0.1),
			rot = v(0, math.deg(angle), -18),
			color = if i % 2 == 0 then C.palmLeaf else C.palmLeaf2,
		})
	end
	Recipes.PalmTree = { parts = parts }
end

Recipes.Lighthouse = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.46, 0), size = v(0.9, 0.08, 0.9), color = C.stone, material = SLATE },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.1, 0), size = v(0.6, 0.66, 0.6), color = C.white },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.25, 0), size = v(0.62, 0.1, 0.62), color = C.sailStripe },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.05, 0), size = v(0.56, 0.1, 0.56), color = C.sailStripe },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.25, 0), size = v(0.75, 0.03, 0.75), color = C.black },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.32, 0), size = v(0.45, 0.11, 0.45), color = C.shoji, material = NEON },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.4, 0), size = v(0.6, 0.05, 0.6), color = C.sailStripe },
	{ shape = "Ball", pos = v(0, 0.46, 0), size = v(0.3, 0.06, 0.3), color = C.sailStripe },
})

Recipes.Rowboat = recipe({
	{ pos = v(0, -0.25, 0), size = v(0.7, 0.4, 0.9), color = C.wallTeal, material = WOOD },
	{ pos = v(0, -0.1, 0), size = v(0.74, 0.08, 0.94), color = C.white },
	{ pos = v(0, -0.1, 0), size = v(0.12, 0.1, 0.96), color = C.woodDark },
	{ pos = v(0, 0.05, 0.1), size = v(1, 0.03, 0.06), rot = v(0, 15, 0), color = C.woodLight },
})

Recipes.IslandHill = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.47, 0), size = v(1, 0.06, 1), color = C.sand, material = SAND },
	{ shape = "Ball", pos = v(-0.08, -0.5, 0), size = v(0.6, 2, 0.6), color = C.grassGreen },
	{ shape = "Ball", pos = v(0.25, -0.5, 0.1), size = v(0.4, 2, 0.4), color = C.palmLeaf },
	{ shape = "Ball", pos = v(-0.1, 0.3, -0.05), size = v(0.1, 0.3, 0.1), color = C.palmLeaf2 },
	{ shape = "Ball", pos = v(0.05, 0.27, 0.08), size = v(0.08, 0.25, 0.08), color = C.palmLeaf },
})

------------------------------------------------------------------------------------------
-- Fase 3: Planeta Verde (rochas, cristais, cogumelos gigantes; brilho só nos detalhes)
------------------------------------------------------------------------------------------

-- Baixo: rochas com cristais (pular)
Recipes.CrystalRocks = recipe({
	{ shape = "Ball", pos = v(-0.3, -0.15, 0), size = v(0.3, 1, 1), color = C.rock, material = SLATE },
	{ shape = "Ball", pos = v(0.05, -0.2, 0.05), size = v(0.32, 1, 1), color = C.rockDark, material = SLATE },
	{ shape = "Ball", pos = v(0.33, -0.18, -0.05), size = v(0.28, 1, 1), color = C.rock, material = SLATE },
	{ pos = v(-0.12, 0.05, 0), size = v(0.08, 0.9, 0.4), rot = v(0, 0, 15), color = C.crystal, material = GLASS, transparency = 0.1 },
	{ pos = v(-0.12, 0.05, 0), size = v(0.03, 0.7, 0.2), rot = v(0, 0, 15), color = C.crystal, material = NEON },
	{ pos = v(0.2, 0.0, 0.1), size = v(0.07, 0.75, 0.35), rot = v(0, 0, -20), color = C.crystal, material = GLASS, transparency = 0.1 },
	{ pos = v(0.2, 0.0, 0.1), size = v(0.025, 0.6, 0.18), rot = v(0, 0, -20), color = C.crystal, material = NEON },
})

-- Alto: arco de pedra com cipós brilhantes (deslizar por baixo)
Recipes.VineArch = recipe({
	{ pos = v(-0.44, 0, 0), size = v(0.12, 1, 0.6), color = C.rock, material = SLATE },
	{ pos = v(0.44, 0, 0), size = v(0.12, 1, 0.6), color = C.rock, material = SLATE },
	{ pos = v(0, 0.42, 0), size = v(1.04, 0.16, 0.6), color = C.rockDark, material = SLATE },
	{ pos = v(0, 0.5, 0), size = v(1.06, 0.03, 0.64), color = C.alienLeaf },
	{ shape = "Cylinder", pos = v(0, -0.08, 0), size = v(0.9, 0.05, 0.2), color = C.vineDark },
	{ pos = v(-0.3, 0.15, 0.2), size = v(0.03, 0.46, 0.03), color = C.vine, material = NEON },
	{ pos = v(-0.15, 0.17, 0.2), size = v(0.03, 0.42, 0.03), color = C.vine, material = NEON },
	{ pos = v(0, 0.15, 0.2), size = v(0.03, 0.46, 0.03), color = C.vine, material = NEON },
	{ pos = v(0.15, 0.17, 0.2), size = v(0.03, 0.42, 0.03), color = C.vine, material = NEON },
	{ pos = v(0.3, 0.15, 0.2), size = v(0.03, 0.46, 0.03), color = C.vine, material = NEON },
	{ shape = "Ball", pos = v(-0.3, -0.08, 0.2), size = v(0.06, 0.04, 0.12), color = C.glowCyan, material = NEON },
	{ shape = "Ball", pos = v(0, -0.08, 0.2), size = v(0.06, 0.04, 0.12), color = C.glowCyan, material = NEON },
	{ shape = "Ball", pos = v(0.3, -0.08, 0.2), size = v(0.06, 0.04, 0.12), color = C.glowCyan, material = NEON },
})

-- Bloco: torre-cogumelo
Recipes.MushroomTower = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.2, 0), size = v(0.45, 0.6, 0.45), color = C.shroomStalk },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.48, 0), size = v(0.6, 0.04, 0.6), color = C.alienLeaf },
	{ pos = v(0, -0.36, 0.225), size = v(0.14, 0.24, 0.04), color = C.glowCyan, material = NEON },
	{ shape = "Cylinder", axis = "Z", pos = v(0, -0.08, 0.22), size = v(0.1, 0.1, 0.04), color = C.glowCyan, material = NEON },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.12, 0), size = v(1.04, 0.04, 1.04), color = C.shroomCapDark },
	{ shape = "Ball", pos = v(0, 0.22, 0), size = v(1, 0.6, 1), color = C.shroomCap },
	{ shape = "Ball", pos = v(0.2, 0.36, 0.25), size = v(0.12, 0.07, 0.12), color = C.white },
	{ shape = "Ball", pos = v(-0.28, 0.3, 0.1), size = v(0.1, 0.06, 0.1), color = C.white },
	{ shape = "Ball", pos = v(0, 0.45, -0.1), size = v(0.12, 0.07, 0.12), color = C.white },
})

Recipes.SpiralPlant = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.2, 0), size = v(0.08, 0.6, 0.08), color = C.vineDark },
	{ shape = "Ball", pos = v(0.1, -0.2, 0), size = v(0.6, 0.3, 0.6), color = C.alienLeaf },
	{ shape = "Ball", pos = v(-0.08, 0.02, 0.05), size = v(0.48, 0.24, 0.48), color = C.alienLeaf2 },
	{ shape = "Ball", pos = v(0.06, 0.2, -0.04), size = v(0.36, 0.18, 0.36), color = C.alienLeaf },
	{ shape = "Ball", pos = v(0, 0.36, 0), size = v(0.24, 0.12, 0.24), color = C.alienLeaf2 },
	{ shape = "Ball", pos = v(0, 0.46, 0), size = v(0.14, 0.07, 0.14), color = C.spore, material = NEON },
})

Recipes.GlowShrooms = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(-0.25, -0.3, 0), size = v(0.12, 0.4, 0.12), color = C.shroomStalk },
	{ shape = "Ball", pos = v(-0.25, -0.08, 0), size = v(0.4, 0.3, 0.4), color = C.glowCyan, material = NEON },
	{ shape = "Cylinder", axis = "Y", pos = v(0.15, -0.2, 0.1), size = v(0.14, 0.6, 0.14), color = C.shroomStalk },
	{ shape = "Ball", pos = v(0.15, 0.12, 0.1), size = v(0.55, 0.42, 0.55), color = C.shroomCap },
	{ shape = "Cylinder", axis = "Y", pos = v(0.3, -0.38, -0.2), size = v(0.08, 0.24, 0.08), color = C.shroomStalk },
	{ shape = "Ball", pos = v(0.3, -0.24, -0.2), size = v(0.24, 0.18, 0.24), color = C.spore, material = NEON },
})

Recipes.FloatingRock = recipe({
	{ shape = "Ball", pos = v(0, -0.1, 0), size = v(0.8, 1.2, 0.8), color = C.rock, material = SLATE },
	{ shape = "Ball", pos = v(0.1, -0.3, 0.05), size = v(0.5, 0.8, 0.5), color = C.rockDark, material = SLATE },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.2, 0), size = v(0.7, 0.06, 0.7), color = C.alienLeaf },
	{ pos = v(0.1, 0.35, 0), size = v(0.08, 0.3, 0.08), rot = v(0, 0, -15), color = C.crystal, material = NEON },
})

Recipes.AlienSpire = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.35, 0), size = v(0.9, 0.3, 0.9), color = C.rockDark, material = SLATE },
	{ shape = "Cylinder", axis = "Y", pos = v(0.04, -0.08, 0), size = v(0.62, 0.26, 0.62), color = C.rock, material = SLATE },
	{ shape = "Cylinder", axis = "Y", pos = v(-0.03, 0.15, 0.02), size = v(0.42, 0.22, 0.42), color = C.rockDark, material = SLATE },
	{ shape = "Cylinder", axis = "Y", pos = v(0.02, 0.34, 0), size = v(0.24, 0.18, 0.24), color = C.rock, material = SLATE },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.2, 0), size = v(0.92, 0.01, 0.92), color = C.alienLeaf },
	{ pos = v(0.25, 0.05, 0.2), size = v(0.06, 0.2, 0.06), rot = v(0, 0, -20), color = C.crystal, material = NEON },
	{ pos = v(-0.2, 0.3, 0.1), size = v(0.05, 0.14, 0.05), rot = v(0, 0, 25), color = C.glowCyan, material = NEON },
})

------------------------------------------------------------------------------------------
-- Personagens (originais, estilo anime). Caixa = tamanho do corredor; frente (rosto) = -Z,
-- costas (+Z) viradas para a câmera. Reserva visual até existirem modelos 3D.
------------------------------------------------------------------------------------------

type Look = {
	skin: Color3,
	hair: Color3,
	top: Color3,
	trim: Color3,
	pants: Color3,
	shoes: Color3,
	eyes: Color3,
	torsoWidth: number?,
	bareArms: boolean?,
	hairCap: boolean?, -- false = sem calota (moicano)
}

-- Corpo base: pernas, tronco, braços em pose de corrida, cabeça grande e olhos grandes
local function fighter(look: Look, extras: { PartSpec }): Recipe
	local tw = look.torsoWidth or 0.5
	local armX = tw / 2 + 0.07
	local armColor = if look.bareArms then look.skin else look.top
	local parts: { PartSpec } = {
		{ pos = v(-0.12, -0.475, -0.03), size = v(0.2, 0.05, 0.5), color = look.shoes },
		{ pos = v(0.12, -0.475, 0.03), size = v(0.2, 0.05, 0.5), color = look.shoes },
		{ pos = v(-0.11, -0.36, 0), size = v(0.18, 0.2, 0.28), rot = v(-12, 0, 0), color = look.pants },
		{ pos = v(0.11, -0.36, 0), size = v(0.18, 0.2, 0.28), rot = v(12, 0, 0), color = look.pants },
		{ pos = v(0, -0.13, 0), size = v(tw, 0.26, 0.4), color = look.top },
		{ pos = v(0, -0.245, 0), size = v(tw + 0.02, 0.035, 0.42), color = look.trim },
		{ pos = v(-armX, -0.12, 0), size = v(0.13, 0.22, 0.2), rot = v(28, 0, 0), color = armColor },
		{ pos = v(armX, -0.12, 0), size = v(0.13, 0.22, 0.2), rot = v(-28, 0, 0), color = armColor },
		{ shape = "Ball", pos = v(-armX, -0.24, 0.08), size = v(0.12, 0.05, 0.14), color = look.skin },
		{ shape = "Ball", pos = v(armX, -0.24, -0.08), size = v(0.12, 0.05, 0.14), color = look.skin },
		{ pos = v(0, 0.02, 0), size = v(0.14, 0.04, 0.16), color = look.skin },
		{ shape = "Ball", pos = v(0, 0.17, 0), size = v(0.6, 0.29, 0.7), color = look.skin },
		{ pos = v(-0.11, 0.16, -0.33), size = v(0.1, 0.075, 0.03), color = look.eyes },
		{ pos = v(0.11, 0.16, -0.33), size = v(0.1, 0.075, 0.03), color = look.eyes },
		{ pos = v(-0.09, 0.178, -0.345), size = v(0.035, 0.025, 0.02), color = C.white },
		{ pos = v(0.13, 0.178, -0.345), size = v(0.035, 0.025, 0.02), color = C.white },
		{ pos = v(0, 0.09, -0.318), size = v(0.08, 0.012, 0.02), color = C.mouth },
	}
	if look.hairCap ~= false then
		table.insert(parts, { shape = "Ball", pos = v(0, 0.235, 0.05), size = v(0.64, 0.31, 0.74), color = look.hair })
		table.insert(parts, { pos = v(-0.1, 0.27, -0.27), size = v(0.12, 0.08, 0.06), rot = v(-20, 0, 20), color = look.hair })
		table.insert(parts, { pos = v(0.1, 0.27, -0.27), size = v(0.12, 0.08, 0.06), rot = v(-20, 0, -20), color = look.hair })
		table.insert(parts, { pos = v(0, 0.28, -0.28), size = v(0.1, 0.07, 0.06), rot = v(-25, 0, 0), color = look.hair })
	end
	for _, spec in extras do
		table.insert(parts, spec)
	end
	return { parts = parts }
end

-- Mecha de cabelo espetada (bloco girado: rot.X > 0 joga a ponta para trás)
local function spike(pos: Vector3, rot: Vector3, color: Color3, scale: number?): PartSpec
	local s = scale or 1
	return { pos = pos, size = v(0.1 * s, 0.11 * s, 0.12 * s), rot = rot, color = color }
end

-- Comum: Riku, aprendiz de jaqueta azul e cachecol vermelho
do
	local hair = rgb(110, 70, 40)
	Recipes.HeroRiku = fighter({
		skin = C.skin,
		hair = hair,
		top = rgb(60, 120, 220),
		trim = rgb(30, 60, 130),
		pants = rgb(45, 45, 60),
		shoes = C.white,
		eyes = rgb(60, 40, 30),
	}, {
		spike(v(0, 0.39, 0.06), v(40, 0, 0), hair),
		spike(v(-0.16, 0.35, 0.06), v(35, 0, 25), hair),
		spike(v(0.16, 0.35, 0.06), v(35, 0, -25), hair),
		spike(v(0, 0.3, 0.26), v(70, 0, 0), hair),
		spike(v(-0.18, 0.24, 0.2), v(60, 0, 30), hair, 0.9),
		spike(v(0.18, 0.24, 0.2), v(60, 0, -30), hair, 0.9),
		{ pos = v(0, 0.035, 0), size = v(0.34, 0.05, 0.44), color = C.red, material = FABRIC },
		{ pos = v(0.07, -0.01, 0.3), size = v(0.1, 0.035, 0.32), rot = v(-25, 0, 0), color = C.red, material = FABRIC },
		{ pos = v(0, -0.13, -0.205), size = v(0.03, 0.24, 0.02), color = C.white },
	})
end

-- Raro: Hana, espadachim de cabelo rosa e quimono verde
do
	local hair = rgb(255, 140, 190)
	Recipes.HeroHana = fighter({
		skin = C.skin,
		hair = hair,
		top = rgb(70, 170, 110),
		trim = rgb(130, 60, 160),
		pants = rgb(40, 50, 90),
		shoes = rgb(214, 180, 130),
		eyes = rgb(140, 50, 110),
	}, {
		{ pos = v(-0.27, 0.13, 0), size = v(0.08, 0.13, 0.3), color = hair },
		{ pos = v(0.27, 0.13, 0), size = v(0.08, 0.13, 0.3), color = hair },
		{ pos = v(0, 0.15, 0.28), size = v(0.52, 0.14, 0.1), color = hair },
		{ shape = "Ball", pos = v(0.24, 0.3, -0.05), size = v(0.08, 0.04, 0.08), color = C.white },
		{ shape = "Ball", pos = v(0.24, 0.3, -0.05), size = v(0.04, 0.02, 0.04), color = C.gold },
		{ pos = v(-0.06, -0.06, -0.205), size = v(0.05, 0.14, 0.02), rot = v(0, 0, -20), color = C.white },
		{ pos = v(0.06, -0.06, -0.205), size = v(0.05, 0.14, 0.02), rot = v(0, 0, 20), color = C.white },
		{ pos = v(0, -0.21, 0), size = v(0.52, 0.07, 0.42), color = rgb(130, 60, 160) },
		{ shape = "Ball", pos = v(0, -0.21, 0.24), size = v(0.2, 0.06, 0.12), color = rgb(130, 60, 160) },
		{ pos = v(0.04, -0.05, 0.24), size = v(0.05, 0.36, 0.05), rot = v(0, 0, 35), color = C.black },
		{ pos = v(-0.08, 0.1, 0.24), size = v(0.04, 0.1, 0.04), rot = v(0, 0, 35), color = rgb(150, 30, 40) },
		{ pos = v(-0.055, 0.06, 0.24), size = v(0.09, 0.015, 0.07), rot = v(0, 0, 35), color = C.gold },
	})
end

-- Épico: Gorou, lutador grandão de moicano roxo e faixas nos braços
do
	local hair = rgb(150, 70, 220)
	Recipes.HeroGorou = fighter({
		skin = C.skinTan,
		hair = hair,
		top = rgb(250, 200, 50),
		trim = C.black,
		pants = rgb(35, 35, 45),
		shoes = C.red,
		eyes = C.eye,
		torsoWidth = 0.62,
		bareArms = true,
		hairCap = false,
	}, {
		spike(v(0, 0.33, -0.12), v(10, 0, 0), hair),
		spike(v(0, 0.35, 0), v(25, 0, 0), hair, 1.1),
		spike(v(0, 0.33, 0.13), v(45, 0, 0), hair, 1.1),
		spike(v(0, 0.27, 0.25), v(70, 0, 0), hair),
		{ pos = v(-0.11, 0.21, -0.335), size = v(0.12, 0.02, 0.02), rot = v(0, 0, -10), color = C.black },
		{ pos = v(0.11, 0.21, -0.335), size = v(0.12, 0.02, 0.02), rot = v(0, 0, 10), color = C.black },
		{ pos = v(-0.38, -0.2, 0.03), size = v(0.14, 0.05, 0.21), rot = v(28, 0, 0), color = C.white },
		{ pos = v(0.38, -0.2, -0.03), size = v(0.14, 0.05, 0.21), rot = v(-28, 0, 0), color = C.white },
		{ pos = v(0, -0.1, -0.205), size = v(0.2, 0.06, 0.02), color = C.black },
	})
end

-- Lendário: Ryuga, guerreiro de cabelo prateado, armadura escura e manto vermelho
do
	local hair = rgb(222, 226, 236)
	local gold = C.gold
	Recipes.HeroRyuga = fighter({
		skin = C.skin,
		hair = hair,
		top = rgb(40, 40, 52),
		trim = gold,
		pants = rgb(60, 60, 72),
		shoes = C.black,
		eyes = rgb(240, 180, 40),
	}, {
		spike(v(0, 0.39, 0.05), v(45, 0, 0), hair, 1.2),
		spike(v(-0.15, 0.36, 0.08), v(45, 0, 22), hair, 1.1),
		spike(v(0.15, 0.36, 0.08), v(45, 0, -22), hair, 1.1),
		spike(v(0, 0.28, 0.3), v(80, 0, 0), hair, 1.2),
		spike(v(-0.14, 0.18, 0.3), v(80, 0, 15), hair, 1.1),
		spike(v(0.14, 0.18, 0.3), v(80, 0, -15), hair, 1.1),
		spike(v(0, 0.1, 0.32), v(85, 0, 0), hair),
		{ pos = v(-0.31, -0.01, 0), size = v(0.18, 0.06, 0.28), rot = v(0, 0, 12), color = rgb(40, 40, 52) },
		{ pos = v(0.31, -0.01, 0), size = v(0.18, 0.06, 0.28), rot = v(0, 0, -12), color = rgb(40, 40, 52) },
		{ pos = v(-0.31, 0.015, 0), size = v(0.19, 0.012, 0.29), rot = v(0, 0, 12), color = gold },
		{ pos = v(0.31, 0.015, 0), size = v(0.19, 0.012, 0.29), rot = v(0, 0, -12), color = gold },
		{ pos = v(0, -0.12, 0.27), size = v(0.5, 0.36, 0.03), rot = v(12, 0, 0), color = rgb(200, 30, 45), material = FABRIC },
		{ pos = v(0, 0.035, 0.18), size = v(0.4, 0.04, 0.08), color = rgb(200, 30, 45), material = FABRIC },
		{ pos = v(0, -0.1, -0.205), size = v(0.12, 0.1, 0.02), color = gold },
	})
end

-- Secreto: Akari, guardiã celestial de cabelo azul-gelo, vestido branco e auréola
do
	local hair = rgb(170, 230, 255)
	Recipes.HeroAkari = fighter({
		skin = C.skin,
		hair = hair,
		top = C.white,
		trim = C.gold,
		pants = rgb(190, 225, 255),
		shoes = C.gold,
		eyes = rgb(40, 200, 230),
	}, {
		{ pos = v(0, -0.02, 0.27), size = v(0.48, 0.32, 0.08), color = hair },
		{ pos = v(-0.27, 0.08, 0.02), size = v(0.07, 0.22, 0.24), color = hair },
		{ pos = v(0.27, 0.08, 0.02), size = v(0.07, 0.22, 0.24), color = hair },
		{ pos = v(0, -0.3, 0), size = v(0.5, 0.12, 0.46), color = C.white },
		{ pos = v(0, -0.355, 0), size = v(0.52, 0.02, 0.48), color = C.gold },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.46, 0.04), size = v(0.4, 0.012, 0.46), color = C.gold, material = NEON, transparency = 0.15 },
		{ pos = v(-0.28, -0.02, 0.3), size = v(0.3, 0.2, 0.02), rot = v(0, 25, 20), color = rgb(150, 230, 255), material = NEON, transparency = 0.45 },
		{ pos = v(0.28, -0.02, 0.3), size = v(0.3, 0.2, 0.02), rot = v(0, -25, -20), color = rgb(150, 230, 255), material = NEON, transparency = 0.45 },
		{ shape = "Ball", pos = v(0, -0.06, -0.205), size = v(0.06, 0.03, 0.04), color = rgb(120, 230, 255), material = NEON },
	})
end

------------------------------------------------------------------------------------------
-- Perseguidor (desligado por enquanto): ninja das sombras, original
------------------------------------------------------------------------------------------

Recipes.ChaserShadow = fighter({
	skin = rgb(60, 55, 75),
	hair = rgb(25, 22, 32),
	top = rgb(25, 22, 32),
	trim = rgb(150, 40, 60),
	pants = rgb(25, 22, 32),
	shoes = rgb(25, 22, 32),
	eyes = rgb(255, 60, 80),
}, {
	{ pos = v(0, 0.13, -0.32), size = v(0.5, 0.08, 0.05), color = rgb(25, 22, 32) },
	{ pos = v(0, 0.25, 0.1), size = v(0.66, 0.04, 0.7), color = rgb(150, 40, 60), material = FABRIC },
})

return Recipes
