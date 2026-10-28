--!strict
-- Receitas visuais do Brainrot Rush (obstáculos, cenário, personagens e lobby) montadas com peças básicas.
-- Guia de estilo em docs/STYLE.md. Prop novo = receita nova; nada de lógica aqui.
-- Convenção: a caixa olha para -Z (sentido da corrida); a face +Z é a que o jogador vê chegando.
-- Telhados e formas inclinadas usam blocos girados (rot), não cunhas: o resultado não depende da orientação da cunha.

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
	-- Madeira, pedra e montanhas
	wood = rgb(120, 78, 45),
	woodDark = rgb(70, 45, 30),
	woodLight = rgb(176, 128, 80),
	stone = rgb(160, 158, 150),
	stoneDark = rgb(112, 110, 106),
	lantern = rgb(255, 200, 110),
	shoji = rgb(255, 228, 165),
	mountain = rgb(112, 132, 165),
	snowCap = rgb(240, 245, 252),
	-- Praia
	sand = rgb(238, 214, 160),
	palmTrunk = rgb(150, 105, 60),
	palmLeaf = rgb(60, 170, 80),
	palmLeaf2 = rgb(100, 205, 95),
	wallYellow = rgb(250, 214, 120),
	wallTeal = rgb(110, 200, 190),
	wallCoral = rgb(245, 160, 140),
	roofOrange = rgb(228, 108, 52),
	roofBlue = rgb(60, 110, 190),
	sailStripe = rgb(220, 60, 50),
	rope = rgb(206, 176, 116),
	crate = rgb(196, 146, 86),
	crateDark = rgb(150, 104, 60),
	grassGreen = rgb(96, 180, 90),
	-- Espaço
	rock = rgb(104, 140, 128),
	rockDark = rgb(70, 100, 96),
	crystal = rgb(176, 120, 255),
	vineDark = rgb(40, 140, 100),
	glowCyan = rgb(120, 255, 230),
	shroomCap = rgb(220, 80, 170),
	shroomStalk = rgb(232, 218, 242),
	alienLeaf = rgb(70, 200, 160),
	alienLeaf2 = rgb(150, 235, 120),
	spore = rgb(230, 255, 120),
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

local Recipes: { [string]: Recipe } = {}

------------------------------------------------------------------------------------------
-- Fase 1: Piazza Pizza (praça italiana; comida gigante com olhos esbugalhados nos obstáculos)
------------------------------------------------------------------------------------------

-- Cores brainrot (comida, metal, olhos)
local B = {
	cardboard = rgb(206, 162, 108),
	cardboardDark = rgb(160, 118, 72),
	crust = rgb(228, 168, 88),
	cheese = rgb(255, 214, 92),
	pepperoni = rgb(190, 40, 40),
	sauce = rgb(205, 40, 35),
	pasta = rgb(250, 222, 130),
	meatball = rgb(140, 80, 45),
	meatballDark = rgb(112, 62, 34),
	herb = rgb(70, 150, 60),
	breadstick = rgb(226, 182, 112),
	steel = rgb(192, 194, 204),
	steelDark = rgb(110, 112, 124),
	porcelain = rgb(248, 248, 250),
	cypress = rgb(46, 100, 56),
	cypressLight = rgb(70, 130, 70),
	waffle = rgb(215, 160, 85),
	waffleDark = rgb(165, 110, 50),
	coconut = rgb(110, 70, 40),
	coconutMeat = rgb(250, 246, 236),
	towelPink = rgb(255, 120, 170),
	towelCyan = rgb(90, 210, 230),
	towelYellow = rgb(255, 220, 80),
	banana = rgb(255, 222, 70),
	bananaTip = rgb(110, 80, 40),
	ufo = rgb(176, 182, 200),
	beam = rgb(140, 255, 160),
	rocket = rgb(240, 240, 246),
	rocketRed = rgb(230, 60, 70),
	planet = rgb(240, 170, 90),
	planetRing = rgb(255, 225, 160),
	frosting = rgb(255, 140, 200),
	sprinkleA = rgb(120, 220, 255),
	sprinkleB = rgb(255, 240, 110),
}

local METAL = Enum.Material.Metal

-- Olho esbugalhado ("googly eye") olhando para +Z (o jogador vê chegando); medidas em fração da caixa
local function googly(pos: Vector3, size: Vector3): { PartSpec }
	return {
		{ shape = "Cylinder", axis = "Z", pos = pos, size = size, color = C.white },
		{
			shape = "Cylinder",
			axis = "Z",
			pos = pos + v(size.X * 0.12, -size.Y * 0.15, size.Z * 0.6),
			size = v(size.X * 0.45, size.Y * 0.45, size.Z),
			color = C.black,
		},
	}
end

-- Baixo: pilhas de caixas de pizza, com uma pizza aberta em cima (pular)
do
	local parts: { PartSpec } = {}
	local stacks = { { x = -0.3, count = 3 }, { x = 0, count = 2 }, { x = 0.3, count = 2 } }
	for s, stack in stacks do
		for i = 1, stack.count do
			local y = -0.4 + (i - 1) * 0.2
			local twist = ((s + i) % 3 - 1) * 7
			table.insert(parts, { pos = v(stack.x, y, 0), size = v(0.28, 0.19, 0.95), rot = v(0, twist, 0), color = B.cardboard })
			table.insert(parts, { pos = v(stack.x, y, 0.47), size = v(0.16, 0.06, 0.02), rot = v(0, twist, 0), color = C.red })
			table.insert(parts, { pos = v(stack.x, y + 0.095, 0), size = v(0.285, 0.012, 0.96), rot = v(0, twist, 0), color = B.cardboardDark })
		end
	end
	-- Pizza aberta na pilha do meio (redonda: x * 6.8 = z * 2)
	table.insert(parts, { shape = "Cylinder", axis = "Y", pos = v(0, 0.03, 0), size = v(0.27, 0.06, 0.92), color = B.crust })
	table.insert(parts, { shape = "Cylinder", axis = "Y", pos = v(0, 0.06, 0), size = v(0.24, 0.04, 0.82), color = B.cheese })
	for _, p in { v(-0.06, 0.085, -0.2), v(0.05, 0.085, 0.15), v(-0.04, 0.085, 0.25), v(0.07, 0.085, -0.15) } do
		table.insert(parts, { shape = "Cylinder", axis = "Y", pos = p, size = v(0.06, 0.03, 0.2), color = B.pepperoni })
	end
	-- Olhos na caixa de cima da esquerda: a pilha "olha" para o jogador
	for _, part in googly(v(-0.35, 0.12, 0.48), v(0.07, 0.24, 0.03)) do
		table.insert(parts, part)
	end
	for _, part in googly(v(-0.25, 0.12, 0.48), v(0.07, 0.24, 0.03)) do
		table.insert(parts, part)
	end
	Recipes.PizzaBoxes = { parts = parts }
end

-- Alto: arco de grissini com espaguete pendurado até a altura de colisão (deslizar por baixo)
do
	local parts: { PartSpec } = {
		{ shape = "Cylinder", axis = "Y", pos = v(-0.44, -0.02, 0), size = v(0.07, 0.96, 0.24), color = B.breadstick, material = SAND },
		{ shape = "Cylinder", axis = "Y", pos = v(0.44, -0.02, 0), size = v(0.07, 0.96, 0.24), color = B.breadstick, material = SAND },
		{ shape = "Cylinder", axis = "Y", pos = v(-0.44, -0.48, 0), size = v(0.12, 0.04, 0.4), color = B.porcelain },
		{ shape = "Cylinder", axis = "Y", pos = v(0.44, -0.48, 0), size = v(0.12, 0.04, 0.4), color = B.porcelain },
		{ shape = "Cylinder", pos = v(0, 0.4, 0), size = v(1.04, 0.07, 0.3), color = B.breadstick, material = SAND },
		-- Montanha de espaguete com almôndegas e molho em cima do arco
		{ shape = "Ball", pos = v(0, 0.46, 0), size = v(0.62, 0.1, 0.9), color = B.pasta },
		{ shape = "Ball", pos = v(0.04, 0.5, 0), size = v(0.32, 0.06, 0.7), color = B.sauce },
		{ shape = "Ball", pos = v(-0.14, 0.52, 0.05), size = v(0.1, 0.078, 0.34), color = B.meatball, material = SAND },
		{ shape = "Ball", pos = v(0.12, 0.53, -0.05), size = v(0.11, 0.085, 0.38), color = B.meatballDark, material = SAND },
		{ shape = "Ball", pos = v(-0.01, 0.55, 0), size = v(0.09, 0.07, 0.3), color = B.meatball, material = SAND },
		{ pos = v(0.02, 0.6, 0), size = v(0.05, 0.012, 0.15), rot = v(0, 30, 0), color = B.herb },
	}
	-- Fios pendurados: todos chegam até a faixa de colisão (3,5 studs = -0,11 da caixa de 9)
	local count = 12
	for i = 0, count - 1 do
		local x = -0.38 + i * (0.76 / (count - 1))
		local extra = (i % 3) * 0.025
		local bottom = -0.1 - extra
		local top = 0.37
		table.insert(parts, {
			pos = v(x, (top + bottom) / 2, 0.06 * ((i % 2) * 2 - 1)),
			size = v(0.018, top - bottom, 0.05),
			rot = v(0, 0, ((i % 4) - 1.5) * 2.5),
			color = B.pasta,
		})
	end
	-- Pingos de molho na ponta de alguns fios
	for _, x in { -0.31, 0.04, 0.31 } do
		table.insert(parts, { shape = "Ball", pos = v(x, -0.12, 0), size = v(0.03, 0.03, 0.12), color = B.sauce })
	end
	Recipes.SpaghettiArch = { parts = parts }
end

-- Bloco: cafeteira moka gigante com olhos e bigode, sobre um pires
do
	local parts: { PartSpec } = {
		{ pos = v(0, -0.485, 0), size = v(1.02, 0.03, 1), color = B.porcelain },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -0.3, 0), size = v(0.9, 0.34, 0.6), color = B.steel, material = METAL },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -0.46, 0), size = v(0.94, 0.03, 0.62), color = B.steelDark, material = METAL },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -0.11, 0), size = v(0.62, 0.06, 0.42), color = B.steelDark, material = METAL },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.13, 0), size = v(0.88, 0.4, 0.58), color = B.steel, material = METAL },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.34, 0), size = v(0.92, 0.04, 0.6), color = B.steelDark, material = METAL },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.37, 0), size = v(0.5, 0.03, 0.34), color = B.steel, material = METAL },
		{ shape = "Ball", pos = v(0, 0.4, 0), size = v(0.16, 0.05, 0.09), color = C.black },
		-- Bico virado para o jogador e alça preta do lado
		{ pos = v(0, 0.3, 0.3), size = v(0.16, 0.06, 0.1), rot = v(-25, 0, 0), color = B.steel, material = METAL },
		{ pos = v(0.5, 0.13, 0), size = v(0.1, 0.32, 0.07), color = C.black },
		{ pos = v(0.45, 0.28, 0), size = v(0.12, 0.04, 0.07), color = C.black },
		{ pos = v(0.45, -0.02, 0), size = v(0.12, 0.04, 0.07), color = C.black },
		-- Bigode
		{ pos = v(-0.07, 0.02, 0.295), size = v(0.15, 0.03, 0.03), rot = v(0, 0, 12), color = C.black },
		{ pos = v(0.07, 0.02, 0.295), size = v(0.15, 0.03, 0.03), rot = v(0, 0, -12), color = C.black },
		-- Vapor
		{ shape = "Ball", pos = v(0, 0.43, 0.03), size = v(0.3, 0.06, 0.18), color = C.white, transparency = 0.35 },
		{ shape = "Ball", pos = v(0.06, 0.47, 0), size = v(0.2, 0.05, 0.12), color = C.white, transparency = 0.45 },
	}
	for _, part in googly(v(-0.14, 0.15, 0.29), v(0.2, 0.115, 0.02)) do
		table.insert(parts, part)
	end
	for _, part in googly(v(0.14, 0.15, 0.29), v(0.2, 0.115, 0.02)) do
		table.insert(parts, part)
	end
	Recipes.MokaPot = { parts = parts }
end

-- Reservas dos modelos da praça (enquanto o modelo não foi importado)
Recipes.Cypress = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.44, 0), size = v(0.12, 0.12, 0.12), color = C.woodDark },
	{ shape = "Ball", pos = v(0, 0, 0), size = v(0.55, 0.9, 0.55), color = B.cypress },
	{ shape = "Ball", pos = v(0.05, 0.12, 0.05), size = v(0.4, 0.7, 0.4), color = B.cypressLight },
})

Recipes.Fountain = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.4, 0), size = v(1, 0.2, 1), color = C.stone, material = SLATE },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.32, 0), size = v(0.9, 0.06, 0.9), color = rgb(90, 180, 230), material = GLASS, transparency = 0.2 },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.05, 0), size = v(0.15, 0.5, 0.15), color = C.stone, material = SLATE },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.2, 0), size = v(0.5, 0.06, 0.5), color = C.stone, material = SLATE },
	{ shape = "Ball", pos = v(0, 0.33, 0), size = v(0.2, 0.25, 0.2), color = rgb(150, 220, 255), material = GLASS, transparency = 0.3 },
})

Recipes.StreetLamp = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.05, 0), size = v(0.12, 0.9, 0.12), color = C.black },
	{ pos = v(0, 0.42, 0), size = v(0.35, 0.12, 0.35), color = C.lantern, material = NEON },
	{ pos = v(0, 0.49, 0), size = v(0.45, 0.04, 0.45), color = C.black },
})

------------------------------------------------------------------------------------------
-- Montanha genérica do fundo: dois prismas cruzados fazem um pico de quatro faces
------------------------------------------------------------------------------------------

local function peak(color: Color3, capColor: Color3): Recipe
	return recipe({
		{ pos = v(0, -0.136, 0), size = v(0.5, 0.9, 0.5), rot = v(0, 0, 45), color = color, material = SLATE },
		{ pos = v(0, -0.136, 0), size = v(0.5, 0.9, 0.5), rot = v(0, 90, 45), color = color, material = SLATE },
		{ pos = v(0, 0.237, 0), size = v(0.21, 0.378, 0.21), rot = v(0, 0, 45), color = capColor },
		{ pos = v(0, 0.237, 0), size = v(0.21, 0.378, 0.21), rot = v(0, 90, 45), color = capColor },
	})
end
Recipes.MistyMountain = peak(C.mountain, C.snowCap)

-- Barris de madeira (reserva do modelo BarrelsModel)
Recipes.WoodBarrels = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(-0.33, -0.02, 0), size = v(0.26, 0.96, 0.9), color = C.wood, material = WOOD },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.02, 0), size = v(0.26, 0.96, 0.9), color = C.woodLight, material = WOOD },
	{ shape = "Cylinder", axis = "Y", pos = v(0.33, -0.02, 0), size = v(0.26, 0.96, 0.9), color = C.wood, material = WOOD },
})
------------------------------------------------------------------------------------------
-- Praia (Spiaggia Banana): reservas dos modelos de cais, barcos, palmeiras e casas coloridas
------------------------------------------------------------------------------------------

-- Caixotes e rolo de corda (reserva do modelo CrateModel)
Recipes.CargoCrates = recipe({
	{ pos = v(-0.3, -0.05, 0), size = v(0.3, 0.9, 0.9), color = C.crate, material = WOOD },
	{ pos = v(-0.3, -0.05, 0.455), size = v(0.04, 0.9, 0.02), rot = v(0, 0, 38), color = C.crateDark },
	{ pos = v(-0.3, -0.05, 0.455), size = v(0.04, 0.9, 0.02), rot = v(0, 0, -38), color = C.crateDark },
	{ pos = v(0.05, -0.1, 0.05), size = v(0.28, 0.8, 0.8), color = C.crateDark, material = WOOD },
	{ pos = v(0.05, 0.31, 0.05), size = v(0.29, 0.06, 0.82), color = C.wallTeal },
	{ shape = "Cylinder", axis = "Y", pos = v(0.35, -0.3, 0), size = v(0.24, 0.4, 0.8), color = C.rope, material = FABRIC },
	{ shape = "Cylinder", axis = "Y", pos = v(0.35, -0.09, 0), size = v(0.12, 0.03, 0.4), color = C.crateDark },
})


-- Casa de pescador colorida (reserva das casas)
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
-- Espaço (Cosmo Caotico): rochas, cristais, cogumelos gigantes; brilho só nos detalhes
------------------------------------------------------------------------------------------

-- Baixo: rochas com cristais (pular; obstáculo do espaço)
Recipes.CrystalRocks = recipe({
	{ shape = "Ball", pos = v(-0.3, -0.15, 0), size = v(0.3, 1, 1), color = C.rock, material = SLATE },
	{ shape = "Ball", pos = v(0.05, -0.2, 0.05), size = v(0.32, 1, 1), color = C.rockDark, material = SLATE },
	{ shape = "Ball", pos = v(0.33, -0.18, -0.05), size = v(0.28, 1, 1), color = C.rock, material = SLATE },
	{ pos = v(-0.12, 0.05, 0), size = v(0.08, 0.9, 0.4), rot = v(0, 0, 15), color = C.crystal, material = GLASS, transparency = 0.1 },
	{ pos = v(-0.12, 0.05, 0), size = v(0.03, 0.7, 0.2), rot = v(0, 0, 15), color = C.crystal, material = NEON },
	{ pos = v(0.2, 0.0, 0.1), size = v(0.07, 0.75, 0.35), rot = v(0, 0, -20), color = C.crystal, material = GLASS, transparency = 0.1 },
	{ pos = v(0.2, 0.0, 0.1), size = v(0.025, 0.6, 0.18), rot = v(0, 0, -20), color = C.crystal, material = NEON },
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
-- Fase 2: Spiaggia Banana (obstáculos de praia; o cenário reaproveita os modelos do porto)
------------------------------------------------------------------------------------------

-- Baixo: castelo de areia com balde e bandeirinha (pular)
Recipes.Sandcastle = recipe({
	{ pos = v(0, -0.4, 0), size = v(0.98, 0.2, 0.95), color = C.sand, material = SAND },
	{ shape = "Cylinder", axis = "Y", pos = v(-0.32, -0.08, 0), size = v(0.16, 0.5, 0.55), color = C.sand, material = SAND },
	{ shape = "Cylinder", axis = "Y", pos = v(0.32, -0.08, 0), size = v(0.16, 0.5, 0.55), color = C.sand, material = SAND },
	{ pos = v(0, -0.12, 0), size = v(0.5, 0.36, 0.6), color = C.sand, material = SAND },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.18, 0), size = v(0.14, 0.3, 0.48), color = C.sand, material = SAND },
	{ pos = v(-0.36, 0.2, 0), size = v(0.04, 0.12, 0.2), color = C.sand, material = SAND },
	{ pos = v(-0.28, 0.2, 0), size = v(0.04, 0.12, 0.2), color = C.sand, material = SAND },
	{ pos = v(0.28, 0.2, 0), size = v(0.04, 0.12, 0.2), color = C.sand, material = SAND },
	{ pos = v(0.36, 0.2, 0), size = v(0.04, 0.12, 0.2), color = C.sand, material = SAND },
	{ pos = v(0, -0.2, 0.31), size = v(0.08, 0.2, 0.02), color = C.crateDark },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.48, 0), size = v(0.008, 0.3, 0.03), color = C.white },
	{ pos = v(0.03, 0.55, 0), size = v(0.05, 0.12, 0.01), color = B.towelPink },
	-- Balde virado e pá
	{ shape = "Cylinder", axis = "Y", pos = v(0.15, -0.22, 0.32), size = v(0.08, 0.3, 0.28), color = B.towelCyan },
	{ pos = v(-0.16, -0.18, 0.4), size = v(0.025, 0.4, 0.04), rot = v(0, 0, 20), color = B.towelYellow },
})

-- Alto: banana gigante deitada entre dois postes listrados, com toalhas penduradas até a altura de colisão
do
	local parts: { PartSpec } = {
		{ shape = "Cylinder", axis = "Y", pos = v(-0.45, 0, 0), size = v(0.06, 1, 0.2), color = C.white },
		{ shape = "Cylinder", axis = "Y", pos = v(0.45, 0, 0), size = v(0.06, 1, 0.2), color = C.white },
		{ shape = "Cylinder", axis = "Y", pos = v(-0.45, 0.2, 0), size = v(0.065, 0.06, 0.21), color = B.towelPink },
		{ shape = "Cylinder", axis = "Y", pos = v(0.45, 0.2, 0), size = v(0.065, 0.06, 0.21), color = B.towelPink },
		{ shape = "Cylinder", axis = "Y", pos = v(-0.45, -0.2, 0), size = v(0.065, 0.06, 0.21), color = B.towelCyan },
		{ shape = "Cylinder", axis = "Y", pos = v(0.45, -0.2, 0), size = v(0.065, 0.06, 0.21), color = B.towelCyan },
		-- Banana em três gomos
		{ pos = v(-0.3, 0.44, 0), size = v(0.34, 0.07, 0.4), rot = v(0, 0, 10), color = B.banana },
		{ pos = v(0, 0.47, 0), size = v(0.34, 0.075, 0.42), color = B.banana },
		{ pos = v(0.3, 0.44, 0), size = v(0.34, 0.07, 0.4), rot = v(0, 0, -10), color = B.banana },
		{ pos = v(-0.48, 0.41, 0), size = v(0.04, 0.03, 0.12), rot = v(0, 0, 20), color = B.bananaTip },
		{ pos = v(0.48, 0.41, 0), size = v(0.04, 0.03, 0.12), rot = v(0, 0, -20), color = B.bananaTip },
		-- Corda das toalhas
		{ pos = v(0, 0.36, 0.02), size = v(0.9, 0.012, 0.03), color = C.rope, material = FABRIC },
	}
	for _, part in googly(v(-0.06, 0.48, 0.21), v(0.04, 0.05, 0.02)) do
		table.insert(parts, part)
	end
	for _, part in googly(v(0.06, 0.48, 0.21), v(0.04, 0.05, 0.02)) do
		table.insert(parts, part)
	end
	-- Toalhas listradas: a barra de baixo marca a altura de colisão (3,5 studs)
	local colors = { B.towelPink, B.towelCyan, B.towelYellow, B.towelPink }
	for i, color in colors do
		local x = -0.3 + (i - 1) * 0.2
		table.insert(parts, { pos = v(x, 0.13, 0.03), size = v(0.17, 0.46, 0.02), color = color, material = FABRIC })
		table.insert(parts, { pos = v(x, 0.13, 0.045), size = v(0.17, 0.05, 0.01), color = C.white, material = FABRIC })
		table.insert(parts, { pos = v(x, -0.09, 0.045), size = v(0.17, 0.03, 0.01), color = C.white, material = FABRIC })
	end
	Recipes.BananaLine = { parts = parts }
end

-- Bloco: coco gigante de canudinho e guarda-chuva, com olhos
do
	local parts: { PartSpec } = {
		{ pos = v(0, -0.485, 0), size = v(1.02, 0.03, 1), color = C.sand, material = SAND },
		{ shape = "Ball", pos = v(0, -0.08, 0), size = v(0.95, 0.8, 0.55), color = B.coconut, material = SAND },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.3, 0), size = v(0.76, 0.03, 0.44), color = B.coconutMeat },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.305, 0), size = v(0.62, 0.03, 0.36), color = rgb(255, 170, 200) },
		-- Canudo listrado e guarda-chuva de drinque
		{ shape = "Cylinder", axis = "Y", pos = v(0.18, 0.4, 0), size = v(0.05, 0.3, 0.03), rot = v(0, 0, -18), color = C.white },
		{ shape = "Cylinder", axis = "Y", pos = v(0.21, 0.44, 0), size = v(0.055, 0.04, 0.035), rot = v(0, 0, -18), color = C.red },
		{ shape = "Cylinder", axis = "Y", pos = v(-0.16, 0.42, 0), size = v(0.02, 0.26, 0.012), rot = v(0, 0, 15), color = C.woodLight },
		{ shape = "Ball", pos = v(-0.2, 0.5, 0), size = v(0.44, 0.06, 0.26), rot = v(0, 0, 15), color = B.towelCyan },
		{ shape = "Cylinder", axis = "Y", pos = v(0.3, 0.33, 0.05), size = v(0.18, 0.02, 0.1), rot = v(0, 0, 10), color = B.cheese },
		{ shape = "Ball", pos = v(-0.03, 0.34, -0.06), size = v(0.08, 0.04, 0.05), color = C.red },
	}
	for _, part in googly(v(-0.15, 0.05, 0.27), v(0.2, 0.115, 0.02)) do
		table.insert(parts, part)
	end
	for _, part in googly(v(0.15, 0.05, 0.27), v(0.2, 0.115, 0.02)) do
		table.insert(parts, part)
	end
	table.insert(parts, { pos = v(0, -0.12, 0.275), size = v(0.22, 0.025, 0.02), color = C.black })
	Recipes.CoconutDrink = { parts = parts }
end

------------------------------------------------------------------------------------------
-- Fase 3: Cosmo Caotico (obstáculos espaciais; o cenário reaproveita os modelos do planeta)
------------------------------------------------------------------------------------------

-- Alto: disco voador abduzindo uma pizza; o raio desce até a altura de colisão (deslizar por baixo)
Recipes.UfoBeam = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.38, 0), size = v(1, 0.07, 0.95), color = B.ufo, material = METAL },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.34, 0), size = v(0.7, 0.04, 0.7), color = B.steelDark, material = METAL },
	{ shape = "Ball", pos = v(0, 0.45, 0), size = v(0.4, 0.13, 0.85), color = C.glowCyan, material = GLASS, transparency = 0.3 },
	{ shape = "Ball", pos = v(-0.4, 0.38, 0.05), size = v(0.05, 0.04, 0.17), color = B.sprinkleB, material = NEON },
	{ shape = "Ball", pos = v(-0.2, 0.38, 0.4), size = v(0.05, 0.04, 0.17), color = B.frosting, material = NEON },
	{ shape = "Ball", pos = v(0.2, 0.38, 0.4), size = v(0.05, 0.04, 0.17), color = B.sprinkleB, material = NEON },
	{ shape = "Ball", pos = v(0.4, 0.38, 0.05), size = v(0.05, 0.04, 0.17), color = B.frosting, material = NEON },
	-- Raio: a base marca a faixa de colisão (3,5 studs = -0,11 da caixa de 9)
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.12, 0), size = v(0.62, 0.44, 0.62), color = B.beam, material = NEON, transparency = 0.75 },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.1, 0), size = v(0.66, 0.02, 0.66), color = B.beam, material = NEON, transparency = 0.2 },
	-- Fatia de pizza sendo abduzida
	{ pos = v(0, 0.08, 0), size = v(0.14, 0.012, 0.5), rot = v(0, 0, 25), color = B.cheese },
	{ shape = "Cylinder", axis = "Y", pos = v(0.01, 0.1, 0.05), size = v(0.03, 0.01, 0.1), rot = v(0, 0, 25), color = B.pepperoni },
})

-- Bloco: foguete na plataforma, com escotilha de olhos esbugalhados
do
	local parts: { PartSpec } = {
		{ pos = v(0, -0.48, 0), size = v(1.02, 0.04, 1), color = B.steelDark, material = METAL },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -0.08, 0), size = v(0.6, 0.72, 0.34), color = B.rocket, material = METAL },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -0.3, 0), size = v(0.62, 0.05, 0.35), color = B.rocketRed },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.3, 0), size = v(0.46, 0.06, 0.26), color = B.rocket, material = METAL },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.35, 0), size = v(0.32, 0.05, 0.18), color = B.rocketRed },
		{ shape = "Ball", pos = v(0, 0.42, 0), size = v(0.24, 0.12, 0.14), color = B.rocketRed },
		-- Aletas
		{ pos = v(-0.36, -0.36, 0), size = v(0.14, 0.2, 0.04), rot = v(0, 0, 20), color = B.rocketRed },
		{ pos = v(0.36, -0.36, 0), size = v(0.14, 0.2, 0.04), rot = v(0, 0, -20), color = B.rocketRed },
		{ pos = v(0, -0.36, 0.2), size = v(0.04, 0.2, 0.12), rot = v(-20, 0, 0), color = B.rocketRed },
		-- Escotilha
		{ shape = "Cylinder", axis = "Z", pos = v(0, 0.05, 0.165), size = v(0.4, 0.23, 0.02), color = B.steelDark, material = METAL },
	}
	for _, part in googly(v(-0.08, 0.06, 0.18), v(0.14, 0.08, 0.015)) do
		table.insert(parts, part)
	end
	for _, part in googly(v(0.08, 0.06, 0.18), v(0.14, 0.08, 0.015)) do
		table.insert(parts, part)
	end
	Recipes.Rocket = { parts = parts }
end

-- Reservas do cenário espacial
Recipes.Planet = recipe({
	{ shape = "Ball", pos = v(0, 0, 0), size = v(0.6, 0.6, 0.6), color = B.planet },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0, 0), size = v(1, 0.02, 1), rot = v(0, 0, 18), color = B.planetRing, transparency = 0.2 },
})

Recipes.Donut = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.1, 0), size = v(1, 0.6, 1), color = B.crust },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.15, 0), size = v(0.95, 0.2, 0.95), color = B.frosting },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.2, 0), size = v(0.3, 0.3, 0.3), color = C.black },
})
------------------------------------------------------------------------------------------
-- Decoração pequena (reserva dos modelos de Config/Models)
------------------------------------------------------------------------------------------

Recipes.Bush = recipe({
	{ shape = "Ball", pos = v(-0.15, -0.15, 0), size = v(0.6, 0.7, 0.6), color = C.palmLeaf },
	{ shape = "Ball", pos = v(0.18, -0.1, 0.05), size = v(0.55, 0.65, 0.55), color = C.palmLeaf2 },
	{ shape = "Ball", pos = v(0, 0.12, -0.05), size = v(0.5, 0.6, 0.5), color = C.grassGreen },
})

Recipes.Rock = recipe({
	{ shape = "Ball", pos = v(0, -0.2, 0), size = v(0.9, 0.9, 0.9), color = C.stone, material = SLATE },
	{ shape = "Ball", pos = v(0.25, -0.3, 0.15), size = v(0.5, 0.5, 0.5), color = C.stoneDark, material = SLATE },
})

Recipes.Fence = recipe({
	{ pos = v(-0.45, 0, 0), size = v(0.06, 1, 0.5), color = C.woodDark, material = WOOD },
	{ pos = v(0.45, 0, 0), size = v(0.06, 1, 0.5), color = C.woodDark, material = WOOD },
	{ pos = v(0, 0.3, 0), size = v(1, 0.12, 0.3), color = C.wood, material = WOOD },
	{ pos = v(0, -0.1, 0), size = v(1, 0.12, 0.3), color = C.wood, material = WOOD },
})

------------------------------------------------------------------------------------------
-- Personagens brainrot: bicho + objeto, olhos esbugalhados e tênis. Os jogáveis são os famosos (mais abaixo);
-- as cinco criaturas originais logo a seguir ficam de reserva, caso algum famoso precise sair do jogo.
-- Medidas em studs dentro da caixa do corredor (2,4 x 5 x 2), centro no meio da caixa:
-- pés em y = -2,5, rosto em -Z, costas (+Z) viradas para a câmera. swing = perna que balança ao correr.
------------------------------------------------------------------------------------------

local BODY = v(2.4, 5, 2)

local function creature(light: Color3?, ...: { PartSpec }): Recipe
	local parts: { PartSpec } = {}
	for _, group in { ... } do
		for _, spec in group do
			local copy = table.clone(spec)
			copy.pos = spec.pos / BODY
			copy.size = spec.size / BODY
			table.insert(parts, copy)
		end
	end
	if light then
		return { parts = parts, light = { color = light, range = 12, brightness = 1.5, at = v(0, 0, 0) } }
	end
	return { parts = parts }
end

-- Olho esbugalhado olhando para a frente (-Z), em studs
local function eye(x: number, y: number, z: number, d: number): { PartSpec }
	return {
		{ shape = "Ball", pos = v(x, y, z), size = v(d, d, d * 0.6), color = C.white },
		{ shape = "Ball", pos = v(x + d * 0.08, y - d * 0.1, z - d * 0.25), size = v(d * 0.45, d * 0.45, d * 0.2), color = C.black },
	}
end

-- Tênis com sola branca (balança com a perna)
local function sneaker(x: number, y: number, z: number, color: Color3, swing: number): { PartSpec }
	return {
		{ pos = v(x, y, z), size = v(0.55, 0.28, 0.9), color = color, swing = swing },
		{ pos = v(x, y - 0.17, z), size = v(0.58, 0.08, 0.95), color = C.white, swing = swing },
		{ pos = v(x, y + 0.05, z - 0.25), size = v(0.4, 0.06, 0.3), color = C.white, swing = swing },
	}
end

-- Comum: Pollo Polpetto, almôndega com pernas de galinha, crista e um garfo espetado nas costas
do
	local leg = rgb(255, 170, 40)
	local feather = rgb(250, 248, 240)
	local crest = rgb(230, 30, 50)
	Recipes.HeroPollo = creature(nil, {
		{ shape = "Cylinder", axis = "Y", pos = v(-0.4, -1.95, 0), size = v(0.22, 1.1, 0.22), color = leg, swing = 1 },
		{ shape = "Cylinder", axis = "Y", pos = v(0.4, -1.95, 0), size = v(0.22, 1.1, 0.22), color = leg, swing = -1 },
		{ pos = v(-0.4, -2.43, -0.15), size = v(0.55, 0.14, 0.75), color = leg, swing = 1 },
		{ pos = v(0.4, -2.43, -0.15), size = v(0.55, 0.14, 0.75), color = leg, swing = -1 },
		{ shape = "Ball", pos = v(0, -0.2, 0), size = v(2.7, 2.7, 2.7), color = B.meatball, material = SAND },
		{ shape = "Ball", pos = v(-0.8, 0.3, 0.7), size = v(0.7, 0.7, 0.7), color = B.meatballDark, material = SAND },
		{ shape = "Ball", pos = v(0.9, -0.4, 0.6), size = v(0.7, 0.7, 0.7), color = B.meatballDark, material = SAND },
		{ shape = "Ball", pos = v(-0.6, -0.9, 0.8), size = v(0.6, 0.6, 0.6), color = B.meatballDark, material = SAND },
		{ pos = v(0.5, 0.4, 1.15), size = v(0.2, 0.06, 0.2), rot = v(0, 30, 20), color = B.herb },
		{ pos = v(-0.3, -0.3, 1.27), size = v(0.18, 0.06, 0.18), rot = v(70, 0, 20), color = B.herb },
		{ pos = v(-0.9, 0.5, 0.5), size = v(0.18, 0.06, 0.18), rot = v(0, 0, 50), color = B.herb },
		-- Molho de tomate escorrendo e lascas de queijo
		{ shape = "Ball", pos = v(0, 0.85, 0), size = v(2.2, 0.9, 2.2), color = B.sauce },
		{ shape = "Ball", pos = v(0.7, 0.45, 0.85), size = v(0.35, 0.6, 0.35), color = B.sauce },
		{ shape = "Ball", pos = v(-0.6, 0.5, 0.9), size = v(0.3, 0.5, 0.3), color = B.sauce },
		{ shape = "Ball", pos = v(0.1, 0.4, 1.05), size = v(0.3, 0.55, 0.3), color = B.sauce },
		{ pos = v(0.2, 1.27, 0.2), size = v(0.28, 0.06, 0.16), rot = v(0, 25, 0), color = B.cheese },
		{ pos = v(-0.3, 1.25, 0.4), size = v(0.22, 0.06, 0.14), rot = v(0, -30, 0), color = B.cheese },
		-- Crista, bico e barbela
		{ shape = "Ball", pos = v(-0.3, 1.45, -0.3), size = v(0.5, 0.5, 0.5), color = crest },
		{ shape = "Ball", pos = v(0, 1.62, -0.25), size = v(0.6, 0.6, 0.6), color = crest },
		{ shape = "Ball", pos = v(0.3, 1.45, -0.3), size = v(0.5, 0.5, 0.5), color = crest },
		{ shape = "Ball", pos = v(0, -0.15, -1.4), size = v(0.5, 0.35, 0.55), color = rgb(255, 190, 40) },
		{ shape = "Ball", pos = v(0, -0.5, -1.3), size = v(0.25, 0.4, 0.25), color = crest },
		-- Asas e rabo de penas (o rabo é o que a câmera vê)
		{ shape = "Ball", pos = v(-1.35, -0.2, 0.1), size = v(0.4, 1.1, 1.3), color = feather },
		{ shape = "Ball", pos = v(1.35, -0.2, 0.1), size = v(0.4, 1.1, 1.3), color = feather },
		{ pos = v(0, 0.05, 1.4), size = v(0.25, 0.9, 0.15), rot = v(-35, 0, 0), color = feather },
		{ pos = v(-0.32, -0.05, 1.35), size = v(0.25, 0.8, 0.15), rot = v(-35, 0, 25), color = feather },
		{ pos = v(0.32, -0.05, 1.35), size = v(0.25, 0.8, 0.15), rot = v(-35, 0, -25), color = feather },
		-- Garfo espetado
		{ shape = "Cylinder", axis = "Y", pos = v(0.55, 1.6, 0.75), size = v(0.18, 1.8, 0.18), rot = v(40, 0, -20), color = B.steel, material = METAL },
		{ shape = "Ball", pos = v(0.86, 2.25, 1.29), size = v(0.32, 0.32, 0.32), color = B.steel, material = METAL },
	}, eye(-0.45, 0.25, -1.15, 0.75), eye(0.45, 0.25, -1.15, 0.75))
end

-- Raro: Lumaca Lampadina, lesma de tênis com uma lâmpada acesa no lugar da concha
do
	local slime = rgb(150, 220, 110)
	Recipes.HeroLumaca = creature(rgb(255, 220, 120), {
		-- Primeira peça segura a luz da lâmpada
		{ pos = v(0, 0.4, 0.2), size = v(0.16, 0.7, 0.16), color = rgb(255, 240, 150), material = NEON },
		{ pos = v(0, 0.75, 0.2), size = v(0.6, 0.08, 0.08), color = rgb(255, 240, 150), material = NEON },
		{ pos = v(-0.2, 0.0, 0.2), size = v(0.06, 0.9, 0.06), color = C.black },
		{ pos = v(0.2, 0.0, 0.2), size = v(0.06, 0.9, 0.06), color = C.black },
		{ shape = "Ball", pos = v(0, 0.4, 0.2), size = v(2.3, 2.5, 2.4), color = rgb(255, 245, 190), material = GLASS, transparency = 0.45 },
		-- Rosca da lâmpada, virada para a câmera
		{ shape = "Cylinder", axis = "Z", pos = v(0, 0.1, 1.45), size = v(1.3, 1.3, 0.8), color = B.steel, material = METAL },
		{ shape = "Cylinder", axis = "Z", pos = v(0, 0.1, 1.3), size = v(1.42, 1.42, 0.12), color = B.steelDark, material = METAL },
		{ shape = "Cylinder", axis = "Z", pos = v(0, 0.1, 1.55), size = v(1.42, 1.42, 0.12), color = B.steelDark, material = METAL },
		{ shape = "Cylinder", axis = "Z", pos = v(0, 0.1, 1.8), size = v(1.2, 1.2, 0.12), color = B.steelDark, material = METAL },
		{ shape = "Cylinder", axis = "Z", pos = v(0, 0.1, 1.92), size = v(0.55, 0.55, 0.15), color = C.black },
		-- Corpo de lesma, pescoço e cabeça
		{ shape = "Ball", pos = v(0, -1.85, 0.1), size = v(1.7, 1.1, 3.4), color = slime },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -1.1, -1.15), size = v(0.95, 1.5, 0.95), color = slime },
		{ shape = "Ball", pos = v(0, -0.3, -1.25), size = v(1.2, 1.2, 1.2), color = slime },
		{ shape = "Cylinder", axis = "Y", pos = v(-0.3, 0.4, -1.3), size = v(0.14, 0.9, 0.14), rot = v(0, 0, 12), color = slime },
		{ shape = "Cylinder", axis = "Y", pos = v(0.3, 0.4, -1.3), size = v(0.14, 0.9, 0.14), rot = v(0, 0, -12), color = slime },
		{ pos = v(0, -0.5, -1.83), size = v(0.4, 0.06, 0.05), color = C.black },
		{ shape = "Ball", pos = v(-0.4, -0.35, -1.7), size = v(0.25, 0.18, 0.1), color = rgb(255, 150, 170) },
		{ shape = "Ball", pos = v(0.4, -0.35, -1.7), size = v(0.25, 0.18, 0.1), color = rgb(255, 150, 170) },
	}, eye(-0.42, 0.95, -1.35, 0.5), eye(0.42, 0.95, -1.35, 0.5), sneaker(-0.55, -2.25, -0.3, rgb(60, 130, 255), 1), sneaker(0.55, -2.25, 0.4, rgb(60, 130, 255), -1))
end

-- Épico: Granchio Gelatino, caranguejo carregando uma casquinha de três bolas de sorvete
do
	local shell = rgb(240, 90, 60)
	local legs: { PartSpec } = {}
	for i, z in { -0.5, 0.1, 0.7 } do
		for _, side in { -1, 1 } do
			table.insert(legs, {
				pos = v(side * 1.25, -2.0, z),
				size = v(0.9, 0.16, 0.16),
				rot = v(0, 0, -side * 40),
				color = shell,
				swing = if i % 2 == 0 then side else -side,
			})
		end
	end
	Recipes.HeroGranchio = creature(nil, legs, {
		{ shape = "Ball", pos = v(0, -1.3, 0), size = v(2.6, 1.3, 2.1), color = shell },
		{ shape = "Ball", pos = v(0, -1.5, -0.3), size = v(2.2, 0.9, 1.6), color = rgb(255, 170, 130) },
		-- Garras
		{ pos = v(-1.2, -1.0, -0.8), size = v(0.25, 0.25, 0.9), rot = v(0, 30, 0), color = shell },
		{ pos = v(1.2, -1.0, -0.8), size = v(0.25, 0.25, 0.9), rot = v(0, -30, 0), color = shell },
		{ shape = "Ball", pos = v(-1.35, -0.8, -1.35), size = v(0.8, 0.7, 0.9), color = shell },
		{ shape = "Ball", pos = v(1.35, -0.8, -1.35), size = v(0.8, 0.7, 0.9), color = shell },
		{ pos = v(-1.35, -0.5, -1.7), size = v(0.25, 0.3, 0.6), rot = v(-25, 0, 0), color = shell },
		{ pos = v(1.35, -0.5, -1.7), size = v(0.25, 0.3, 0.6), rot = v(-25, 0, 0), color = shell },
		{ shape = "Cylinder", axis = "Y", pos = v(-0.35, -0.45, -0.75), size = v(0.12, 0.7, 0.12), color = shell },
		{ shape = "Cylinder", axis = "Y", pos = v(0.35, -0.45, -0.75), size = v(0.12, 0.7, 0.12), color = shell },
		-- Casquinha (cilindros cada vez mais largos) com riscas de waffle
		{ shape = "Cylinder", axis = "Y", pos = v(0, -0.55, 0), size = v(0.5, 0.4, 0.5), color = B.waffle, material = SAND },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -0.2, 0), size = v(0.9, 0.4, 0.9), color = B.waffle, material = SAND },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.15, 0), size = v(1.3, 0.4, 1.3), color = B.waffle, material = SAND },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.45, 0), size = v(1.6, 0.3, 1.6), color = B.waffle, material = SAND },
		{ pos = v(0, 0.0, 0.55), size = v(0.06, 1.0, 0.05), rot = v(0, 0, 30), color = B.waffleDark },
		{ pos = v(0, 0.0, 0.55), size = v(0.06, 1.0, 0.05), rot = v(0, 0, -30), color = B.waffleDark },
		-- Bolas de morango, menta e chocolate, cereja e granulado
		{ shape = "Ball", pos = v(0, 0.75, 0), size = v(1.8, 0.4, 1.8), color = rgb(255, 150, 190) },
		{ shape = "Ball", pos = v(0, 0.95, 0), size = v(1.7, 1.7, 1.7), color = rgb(255, 150, 190) },
		{ shape = "Ball", pos = v(0, 1.75, 0.05), size = v(1.45, 1.45, 1.45), color = rgb(150, 235, 190) },
		{ shape = "Ball", pos = v(0, 2.45, 0.05), size = v(1.2, 1.2, 1.2), color = rgb(120, 70, 45) },
		{ shape = "Ball", pos = v(0.05, 3.1, 0.05), size = v(0.45, 0.45, 0.45), color = rgb(220, 20, 40) },
		{ pos = v(0.1, 3.4, 0.05), size = v(0.06, 0.35, 0.06), rot = v(0, 0, -20), color = B.herb },
		{ pos = v(0.4, 1.2, 0.65), size = v(0.25, 0.06, 0.06), rot = v(0, 0, 30), color = B.sprinkleB, material = NEON },
		{ pos = v(-0.5, 1.0, 0.6), size = v(0.25, 0.06, 0.06), rot = v(0, 0, -40), color = B.sprinkleA, material = NEON },
		{ pos = v(0.2, 2.0, 0.62), size = v(0.25, 0.06, 0.06), rot = v(0, 0, 10), color = B.frosting, material = NEON },
		{ pos = v(-0.3, 2.6, 0.5), size = v(0.22, 0.06, 0.06), rot = v(0, 0, 50), color = B.sprinkleB, material = NEON },
		{ pos = v(0.6, 1.7, 0.35), size = v(0.22, 0.06, 0.06), rot = v(0, 0, -20), color = B.sprinkleA, material = NEON },
		{ pos = v(0.5, 2.3, 0.2), size = v(0.3, 1.0, 0.15), rot = v(0, 0, -25), color = rgb(240, 200, 130) },
	}, eye(-0.35, 0.05, -0.8, 0.5), eye(0.35, 0.05, -0.8, 0.5))
end

-- Lendário: Gufo Sveglietta, coruja-despertador com mostrador na barriga e sinos na cabeça
do
	local brown = rgb(150, 95, 55)
	local gold = rgb(250, 200, 50)
	Recipes.HeroGufo = creature(nil, {
		{ shape = "Cylinder", axis = "Y", pos = v(-0.45, -2.05, 0), size = v(0.2, 0.5, 0.2), color = gold, material = METAL, swing = 1 },
		{ shape = "Cylinder", axis = "Y", pos = v(0.45, -2.05, 0), size = v(0.2, 0.5, 0.2), color = gold, material = METAL, swing = -1 },
		{ shape = "Ball", pos = v(-0.45, -2.35, -0.1), size = v(0.55, 0.3, 0.7), color = gold, material = METAL, swing = 1 },
		{ shape = "Ball", pos = v(0.45, -2.35, -0.1), size = v(0.55, 0.3, 0.7), color = gold, material = METAL, swing = -1 },
		{ shape = "Ball", pos = v(0, -0.35, 0), size = v(2.6, 3.2, 2.3), color = brown },
		{ shape = "Ball", pos = v(0, -0.6, -0.4), size = v(2.0, 2.4, 1.6), color = rgb(225, 190, 140) },
		-- Relógio na barriga
		{ shape = "Cylinder", axis = "Z", pos = v(0, -0.75, -1.12), size = v(1.85, 1.85, 0.12), color = gold, material = METAL },
		{ shape = "Cylinder", axis = "Z", pos = v(0, -0.75, -1.18), size = v(1.6, 1.6, 0.12), color = C.white },
		{ pos = v(0, -0.1, -1.25), size = v(0.1, 0.2, 0.05), color = C.black },
		{ pos = v(0, -1.4, -1.25), size = v(0.1, 0.2, 0.05), color = C.black },
		{ pos = v(0.65, -0.75, -1.25), size = v(0.2, 0.1, 0.05), color = C.black },
		{ pos = v(-0.65, -0.75, -1.25), size = v(0.2, 0.1, 0.05), color = C.black },
		{ pos = v(0, -0.5, -1.27), size = v(0.08, 0.55, 0.04), color = C.black },
		{ pos = v(0.2, -0.75, -1.27), size = v(0.45, 0.07, 0.04), color = C.black },
		{ shape = "Ball", pos = v(0, -0.75, -1.29), size = v(0.14, 0.14, 0.06), color = C.red },
		-- Rosto: aros dos olhos, bico e sobrancelhas de pena
		{ shape = "Cylinder", axis = "Z", pos = v(-0.5, 0.75, -0.98), size = v(0.95, 0.95, 0.12), color = gold },
		{ shape = "Cylinder", axis = "Z", pos = v(0.5, 0.75, -0.98), size = v(0.95, 0.95, 0.12), color = gold },
		{ shape = "Ball", pos = v(0, 0.35, -1.18), size = v(0.3, 0.42, 0.3), color = rgb(255, 170, 40) },
		{ pos = v(-0.7, 1.3, -0.5), size = v(0.55, 0.18, 0.3), rot = v(0, 0, 25), color = rgb(110, 65, 35) },
		{ pos = v(0.7, 1.3, -0.5), size = v(0.55, 0.18, 0.3), rot = v(0, 0, -25), color = rgb(110, 65, 35) },
		-- Sinos e martelinho do despertador
		{ shape = "Ball", pos = v(-0.75, 1.6, 0.1), size = v(1.0, 0.8, 1.0), color = gold, material = METAL },
		{ shape = "Ball", pos = v(0.75, 1.6, 0.1), size = v(1.0, 0.8, 1.0), color = gold, material = METAL },
		{ shape = "Cylinder", axis = "Y", pos = v(-0.75, 1.25, 0.1), size = v(1.05, 0.1, 1.05), color = rgb(200, 150, 30), material = METAL },
		{ shape = "Cylinder", axis = "Y", pos = v(0.75, 1.25, 0.1), size = v(1.05, 0.1, 1.05), color = rgb(200, 150, 30), material = METAL },
		{ pos = v(0, 1.65, 0.1), size = v(0.1, 0.6, 0.1), color = B.steelDark, material = METAL },
		{ shape = "Ball", pos = v(0, 2.0, 0.1), size = v(0.28, 0.28, 0.28), color = B.steelDark, material = METAL },
		-- Asas, rabo e a chave de corda nas costas
		{ shape = "Ball", pos = v(-1.35, -0.4, 0.2), size = v(0.45, 1.8, 1.4), color = rgb(120, 75, 40) },
		{ shape = "Ball", pos = v(1.35, -0.4, 0.2), size = v(0.45, 1.8, 1.4), color = rgb(120, 75, 40) },
		{ pos = v(0, -1.6, 1.1), size = v(0.8, 0.6, 0.2), rot = v(-30, 0, 0), color = rgb(110, 65, 35) },
		{ shape = "Cylinder", axis = "Z", pos = v(0, -0.3, 1.3), size = v(0.25, 0.25, 0.6), color = gold, material = METAL },
		{ pos = v(0, -0.3, 1.65), size = v(0.2, 0.3, 0.15), color = gold, material = METAL },
		{ shape = "Ball", pos = v(-0.38, -0.3, 1.65), size = v(0.6, 0.5, 0.15), color = gold, material = METAL },
		{ shape = "Ball", pos = v(0.38, -0.3, 1.65), size = v(0.6, 0.5, 0.15), color = gold, material = METAL },
	}, eye(-0.5, 0.75, -1.08, 0.72), eye(0.5, 0.75, -1.08, 0.72))
end

-- Secreto: Balena Mongolfiera, baleia-balão de bolinhas com coroa, cesto e tênis cor-de-rosa
do
	local blue = rgb(90, 150, 230)
	local pink = rgb(255, 110, 180)
	local gold = rgb(250, 200, 50)
	Recipes.HeroBalena = creature(nil, {
		{ shape = "Ball", pos = v(0, 1.0, 0), size = v(2.8, 2.4, 3.4), color = blue },
		{ shape = "Ball", pos = v(0, 0.6, -0.15), size = v(2.3, 1.5, 3.1), color = rgb(230, 238, 252) },
		{ shape = "Ball", pos = v(0.6, 1.95, 0.5), size = v(0.7, 0.3, 0.7), color = pink },
		{ shape = "Ball", pos = v(-0.55, 2.0, -0.3), size = v(0.6, 0.3, 0.6), color = pink },
		{ shape = "Ball", pos = v(-0.3, 1.85, 1.0), size = v(0.55, 0.3, 0.55), color = pink },
		{ shape = "Ball", pos = v(1.2, 1.2, -0.2), size = v(0.3, 0.55, 0.55), color = pink },
		{ shape = "Ball", pos = v(-1.2, 1.3, 0.4), size = v(0.3, 0.5, 0.5), color = pink },
		{ pos = v(0, 0.55, -1.62), size = v(1.0, 0.08, 0.06), color = rgb(40, 60, 120) },
		-- Esguicho de água e coroa
		{ shape = "Cylinder", axis = "Y", pos = v(0, 2.45, -0.4), size = v(0.2, 0.6, 0.2), color = C.glowCyan, material = NEON, transparency = 0.3 },
		{ shape = "Ball", pos = v(-0.3, 2.85, -0.4), size = v(0.3, 0.3, 0.3), color = C.glowCyan, material = NEON },
		{ shape = "Ball", pos = v(0.3, 2.85, -0.4), size = v(0.3, 0.3, 0.3), color = C.glowCyan, material = NEON },
		{ shape = "Ball", pos = v(0, 2.95, -0.4), size = v(0.35, 0.35, 0.35), color = C.glowCyan, material = NEON },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 2.25, 0.45), size = v(0.8, 0.3, 0.8), color = gold, material = METAL },
		{ pos = v(-0.3, 2.5, 0.45), size = v(0.15, 0.3, 0.15), rot = v(0, 45, 0), color = gold, material = METAL },
		{ pos = v(0, 2.55, 0.45), size = v(0.15, 0.35, 0.15), rot = v(0, 45, 0), color = gold, material = METAL },
		{ pos = v(0.3, 2.5, 0.45), size = v(0.15, 0.3, 0.15), rot = v(0, 45, 0), color = gold, material = METAL },
		-- Rabo virado para a câmera e nadadeiras
		{ pos = v(0, 1.3, 1.85), size = v(0.6, 0.6, 0.9), rot = v(-20, 0, 0), color = blue },
		{ pos = v(-0.55, 1.65, 2.25), size = v(1.1, 0.18, 0.6), rot = v(-20, 0, 20), color = blue },
		{ pos = v(0.55, 1.65, 2.25), size = v(1.1, 0.18, 0.6), rot = v(-20, 0, -20), color = blue },
		{ pos = v(-1.45, 0.6, -0.3), size = v(0.7, 0.15, 0.8), rot = v(0, 0, 30), color = blue },
		{ pos = v(1.45, 0.6, -0.3), size = v(0.7, 0.15, 0.8), rot = v(0, 0, -30), color = blue },
		-- Cordas e cesto
		{ shape = "Cylinder", axis = "Y", pos = v(-0.5, -0.55, -0.45), size = v(0.06, 1.3, 0.06), color = C.woodDark },
		{ shape = "Cylinder", axis = "Y", pos = v(0.5, -0.55, -0.45), size = v(0.06, 1.3, 0.06), color = C.woodDark },
		{ shape = "Cylinder", axis = "Y", pos = v(-0.5, -0.55, 0.45), size = v(0.06, 1.3, 0.06), color = C.woodDark },
		{ shape = "Cylinder", axis = "Y", pos = v(0.5, -0.55, 0.45), size = v(0.06, 1.3, 0.06), color = C.woodDark },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -1.55, 0), size = v(1.5, 1.0, 1.5), color = rgb(190, 140, 80), material = WOOD },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -1.55, 0), size = v(1.52, 0.15, 1.52), color = C.red },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -1.03, 0), size = v(1.6, 0.15, 1.6), color = rgb(140, 95, 55) },
		{ shape = "Cylinder", axis = "Y", pos = v(-0.35, -2.15, 0), size = v(0.18, 0.4, 0.18), color = rgb(240, 200, 170), swing = 1 },
		{ shape = "Cylinder", axis = "Y", pos = v(0.35, -2.15, 0), size = v(0.18, 0.4, 0.18), color = rgb(240, 200, 170), swing = -1 },
	}, eye(-0.75, 1.2, -1.42, 0.55), eye(0.75, 1.2, -1.42, 0.55), sneaker(-0.35, -2.3, -0.15, pink, 1), sneaker(0.35, -2.3, -0.15, pink, -1))
end

------------------------------------------------------------------------------------------
-- Brainrots famosos (memes do TikTok de 2025), montados do zero com peças, sem copiar arte de outros jogos.
-- Risco: há pedidos de marca de terceiros sobre alguns nomes (ver docs/ASSETS.md). Para trocar um deles por uma
-- criatura original, basta mudar o campo recipe em Config/Heroes (as originais acima continuam aqui).
------------------------------------------------------------------------------------------

-- Comum: Brr Brr Patapim, tronco de árvore com cara de macaco, galhos de braço e pés enormes
do
	local bark = rgb(130, 90, 55)
	local barkDark = rgb(95, 62, 36)
	local skin = rgb(232, 192, 152)
	local leaf = rgb(80, 165, 60)
	Recipes.HeroPatapim = creature(nil, {
		{ shape = "Cylinder", axis = "Y", pos = v(-0.45, -1.75, 0), size = v(0.3, 1.5, 0.3), color = bark, material = WOOD, swing = 1 },
		{ shape = "Cylinder", axis = "Y", pos = v(0.45, -1.75, 0), size = v(0.3, 1.5, 0.3), color = bark, material = WOOD, swing = -1 },
		{ shape = "Ball", pos = v(-0.5, -2.35, -0.35), size = v(0.8, 0.35, 1.4), color = skin, swing = 1 },
		{ shape = "Ball", pos = v(0.5, -2.35, -0.35), size = v(0.8, 0.35, 1.4), color = skin, swing = -1 },
		-- Tronco, nós da casca (a câmera vê as costas) e galhos
		{ shape = "Cylinder", axis = "Y", pos = v(0, -0.2, 0), size = v(1.8, 2.2, 1.8), color = bark, material = WOOD },
		{ shape = "Ball", pos = v(0, -0.2, 0.88), size = v(0.5, 0.65, 0.15), color = barkDark },
		{ pos = v(-0.45, 0.4, 0.82), size = v(0.08, 0.9, 0.08), rot = v(0, 0, 10), color = barkDark },
		{ pos = v(0.5, -0.7, 0.8), size = v(0.08, 0.7, 0.08), rot = v(0, 0, -15), color = barkDark },
		{ shape = "Cylinder", axis = "Y", pos = v(-1.15, 0.1, 0), size = v(0.22, 1.3, 0.22), rot = v(0, 0, 40), color = bark, material = WOOD },
		{ shape = "Cylinder", axis = "Y", pos = v(1.15, 0.1, 0), size = v(0.22, 1.3, 0.22), rot = v(0, 0, -40), color = bark, material = WOOD },
		{ shape = "Ball", pos = v(-1.6, 0.6, 0), size = v(0.5, 0.5, 0.5), color = leaf },
		{ shape = "Ball", pos = v(1.6, 0.6, 0), size = v(0.5, 0.5, 0.5), color = leaf },
		-- Cabeça de macaco: rosto claro, narigão e boca
		{ shape = "Ball", pos = v(0, 1.3, 0), size = v(1.9, 1.7, 1.8), color = bark, material = WOOD },
		{ shape = "Ball", pos = v(0, 1.15, -0.6), size = v(1.4, 1.2, 0.7), color = skin },
		{ shape = "Ball", pos = v(0, 1.05, -1.0), size = v(0.55, 0.45, 0.5), color = rgb(220, 140, 120) },
		{ pos = v(0, 0.68, -0.92), size = v(0.6, 0.08, 0.05), color = C.black },
		-- Copa de folhas na cabeça
		{ shape = "Ball", pos = v(0, 2.3, 0.1), size = v(2.2, 1.2, 2.0), color = leaf },
		{ shape = "Ball", pos = v(-0.7, 2.1, 0.5), size = v(1.1, 0.9, 1.1), color = rgb(100, 190, 70) },
		{ shape = "Ball", pos = v(0.7, 2.15, 0.4), size = v(1.1, 0.9, 1.1), color = rgb(60, 140, 50) },
	}, eye(-0.35, 1.5, -0.88, 0.45), eye(0.35, 1.5, -0.88, 0.45))
end

-- Raro: Ballerina Cappuccina, bailarina de tutu rosa com uma xícara de cappuccino no lugar da cabeça
do
	local pink = rgb(255, 160, 205)
	local skin = rgb(245, 215, 190)
	Recipes.HeroBallerina = creature(nil, {
		{ shape = "Cylinder", axis = "Y", pos = v(-0.25, -1.85, 0), size = v(0.2, 1.2, 0.2), color = skin, swing = 1 },
		{ shape = "Cylinder", axis = "Y", pos = v(0.25, -1.85, 0), size = v(0.2, 1.2, 0.2), color = skin, swing = -1 },
		{ shape = "Ball", pos = v(-0.25, -2.4, -0.1), size = v(0.3, 0.2, 0.5), color = pink, swing = 1 },
		{ shape = "Ball", pos = v(0.25, -2.4, -0.1), size = v(0.3, 0.2, 0.5), color = pink, swing = -1 },
		-- Tutu em duas camadas e corpinho
		{ shape = "Cylinder", axis = "Y", pos = v(0, -1.05, 0), size = v(2.4, 0.35, 2.4), color = pink, material = FABRIC },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -0.85, 0), size = v(2.0, 0.25, 2.0), color = rgb(255, 200, 225), material = FABRIC },
		{ shape = "Ball", pos = v(0, -0.3, 0), size = v(0.8, 1.3, 0.7), color = pink },
		-- Braços erguidos em arco
		{ shape = "Cylinder", axis = "Y", pos = v(-0.65, 0.3, 0), size = v(0.14, 1.0, 0.14), rot = v(0, 0, 35), color = skin },
		{ shape = "Cylinder", axis = "Y", pos = v(0.65, 0.3, 0), size = v(0.14, 1.0, 0.14), rot = v(0, 0, -35), color = skin },
		-- Pires, xícara, café, espuma e coração de latte art
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.48, 0), size = v(1.9, 0.1, 1.9), color = B.porcelain },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.6, 0), size = v(1.2, 0.15, 1.2), color = B.porcelain },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 1.25, 0), size = v(1.6, 1.3, 1.6), color = B.porcelain },
		{ shape = "Ball", pos = v(0.95, 1.25, 0), size = v(0.5, 0.75, 0.15), color = B.porcelain },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 1.92, 0), size = v(1.5, 0.08, 1.5), color = rgb(150, 95, 55) },
		{ shape = "Ball", pos = v(0, 1.97, 0), size = v(1.4, 0.25, 1.4), color = rgb(245, 225, 195) },
		{ shape = "Ball", pos = v(-0.12, 2.08, 0.05), size = v(0.3, 0.06, 0.3), color = rgb(150, 95, 55) },
		{ shape = "Ball", pos = v(0.12, 2.08, 0.05), size = v(0.3, 0.06, 0.3), color = rgb(150, 95, 55) },
		{ shape = "Ball", pos = v(0, 2.08, 0.2), size = v(0.25, 0.06, 0.25), color = rgb(150, 95, 55) },
		-- Boquinha e bochechas na xícara
		{ pos = v(0, 0.95, -0.81), size = v(0.3, 0.08, 0.04), color = rgb(220, 70, 110) },
		{ shape = "Ball", pos = v(-0.5, 1.05, -0.75), size = v(0.25, 0.15, 0.08), color = rgb(255, 160, 180) },
		{ shape = "Ball", pos = v(0.5, 1.05, -0.75), size = v(0.25, 0.15, 0.08), color = rgb(255, 160, 180) },
	}, eye(-0.32, 1.35, -0.8, 0.42), eye(0.32, 1.35, -0.8, 0.42))
end

-- Épico: Tung Tung Tung Sahur, tora de madeira de olhos arregalados com um taco no ombro
do
	local wood = rgb(200, 150, 95)
	local woodDark = rgb(150, 100, 60)
	local bat = rgb(150, 95, 50)
	Recipes.HeroTung = creature(nil, {
		{ shape = "Cylinder", axis = "Y", pos = v(-0.4, -2.0, 0), size = v(0.2, 1.0, 0.2), color = wood, swing = 1 },
		{ shape = "Cylinder", axis = "Y", pos = v(0.4, -2.0, 0), size = v(0.2, 1.0, 0.2), color = wood, swing = -1 },
		{ pos = v(-0.4, -2.45, -0.12), size = v(0.35, 0.12, 0.5), color = woodDark, swing = 1 },
		{ pos = v(0.4, -2.45, -0.12), size = v(0.35, 0.12, 0.5), color = woodDark, swing = -1 },
		-- Tora com anéis no topo e nós nas costas
		{ shape = "Cylinder", axis = "Y", pos = v(0, 0.2, 0), size = v(1.7, 3.4, 1.7), color = wood, material = WOOD },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 1.92, 0), size = v(1.6, 0.06, 1.6), color = rgb(225, 185, 130) },
		{ shape = "Cylinder", axis = "Y", pos = v(0, 1.94, 0), size = v(1.0, 0.04, 1.0), color = woodDark },
		{ shape = "Ball", pos = v(-0.2, 0.6, 0.83), size = v(0.4, 0.5, 0.12), color = woodDark },
		{ pos = v(0.35, -0.4, 0.8), size = v(0.08, 0.9, 0.08), color = woodDark },
		-- Sobrancelhas e sorriso
		{ pos = v(-0.38, 1.45, -0.82), size = v(0.5, 0.1, 0.08), rot = v(0, 0, -10), color = C.black },
		{ pos = v(0.38, 1.45, -0.82), size = v(0.5, 0.1, 0.08), rot = v(0, 0, 10), color = C.black },
		{ pos = v(0, 0.2, -0.85), size = v(0.8, 0.12, 0.06), color = C.black },
		{ pos = v(-0.42, 0.28, -0.84), size = v(0.12, 0.2, 0.06), color = C.black },
		{ pos = v(0.42, 0.28, -0.84), size = v(0.12, 0.2, 0.06), color = C.black },
		-- Braços; o direito segura o taco apoiado no ombro (a câmera vê o taco)
		{ shape = "Cylinder", axis = "Y", pos = v(-1.0, 0.0, 0), size = v(0.18, 1.2, 0.18), rot = v(0, 0, -20), color = wood },
		{ shape = "Cylinder", axis = "Y", pos = v(0.95, 0.35, -0.12), size = v(0.18, 0.7, 0.18), rot = v(25, 0, 0), color = wood },
		{ shape = "Ball", pos = v(1.05, 0.1, -0.25), size = v(0.3, 0.3, 0.3), color = wood },
		{ shape = "Cylinder", axis = "Y", pos = v(1.05, 0.23, -0.19), size = v(0.18, 0.8, 0.18), rot = v(35, 0, 0), color = bat, material = WOOD },
		{ shape = "Cylinder", axis = "Y", pos = v(1.05, 1.3, 0.55), size = v(0.4, 1.8, 0.4), rot = v(35, 0, 0), color = bat, material = WOOD },
	}, eye(-0.35, 1.0, -0.85, 0.6), eye(0.35, 1.0, -0.85, 0.6))
end

-- Lendário: Tralalero Tralala, tubarão azul de três pernas com tênis azuis
do
	local blue = rgb(70, 130, 200)
	local skin = rgb(235, 195, 160)
	local shoe = rgb(40, 90, 220)
	Recipes.HeroTralalero = creature(nil, {
		{ shape = "Cylinder", axis = "Y", pos = v(-0.45, -1.45, -0.6), size = v(0.25, 1.3, 0.25), color = skin, swing = 1 },
		{ shape = "Cylinder", axis = "Y", pos = v(0.45, -1.45, -0.6), size = v(0.25, 1.3, 0.25), color = skin, swing = -1 },
		{ shape = "Cylinder", axis = "Y", pos = v(0, -1.45, 0.7), size = v(0.25, 1.3, 0.25), color = skin, swing = -1 },
		-- Corpo deitado, barriga branca, boca com dentes
		{ shape = "Ball", pos = v(0, 0, 0), size = v(1.8, 1.6, 3.6), color = blue },
		{ shape = "Ball", pos = v(0, -0.25, -0.1), size = v(1.5, 1.2, 3.3), color = C.white },
		{ pos = v(0, -0.3, -1.55), size = v(0.9, 0.12, 0.2), color = C.black },
		{ pos = v(-0.25, -0.2, -1.6), size = v(0.1, 0.12, 0.08), color = C.white },
		{ pos = v(0, -0.2, -1.65), size = v(0.1, 0.12, 0.08), color = C.white },
		{ pos = v(0.25, -0.2, -1.6), size = v(0.1, 0.12, 0.08), color = C.white },
		-- Barbatanas: dorsal e rabo (a câmera vê os dois) e laterais
		{ pos = v(0, 1.1, 0.2), size = v(0.2, 0.9, 0.9), rot = v(-30, 0, 0), color = blue },
		{ pos = v(0, 0.25, 1.95), size = v(0.4, 0.6, 0.7), color = blue },
		{ pos = v(0, 0.75, 2.3), size = v(0.15, 1.0, 0.5), rot = v(-35, 0, 0), color = blue },
		{ pos = v(0, -0.1, 2.3), size = v(0.15, 0.8, 0.5), rot = v(35, 0, 0), color = blue },
		{ pos = v(-0.95, -0.3, -0.4), size = v(0.6, 0.1, 0.5), rot = v(0, 0, 30), color = blue },
		{ pos = v(0.95, -0.3, -0.4), size = v(0.6, 0.1, 0.5), rot = v(0, 0, -30), color = blue },
	}, eye(-0.55, 0.4, -1.35, 0.45), eye(0.55, 0.4, -1.35, 0.45),
		sneaker(-0.45, -2.25, -0.65, shoe, 1), sneaker(0.45, -2.25, -0.65, shoe, -1), sneaker(0, -2.25, 0.65, shoe, -1))
end

-- Secreto: Bombardiro Crocodilo, crocodilo-bombardeiro de asas, hélices e bombas penduradas (voa, sem pernas)
do
	local olive = rgb(110, 130, 70)
	local green = rgb(90, 150, 70)
	local dark = rgb(60, 62, 70)
	local function p(x: number, y: number, z: number): Vector3
		return v(x, y - 0.6, z)
	end
	local parts: { PartSpec } = {
		-- Fuselagem, cabine e escamas nas costas
		{ shape = "Cylinder", axis = "Z", pos = p(0, 0, 0.3), size = v(1.3, 1.3, 3.0), color = olive },
		{ shape = "Ball", pos = p(0, 0.6, -0.5), size = v(0.7, 0.5, 0.9), color = rgb(170, 220, 255), material = GLASS, transparency = 0.3 },
		-- Cabeça de crocodilo com focinho comprido e dentes
		{ shape = "Ball", pos = p(0, 0.1, -1.5), size = v(1.2, 1.0, 1.2), color = green },
		{ shape = "Ball", pos = p(0, -0.05, -2.2), size = v(0.9, 0.5, 1.4), color = green },
		{ pos = p(-0.35, -0.25, -2.2), size = v(0.06, 0.15, 1.0), color = C.white },
		{ pos = p(0.35, -0.25, -2.2), size = v(0.06, 0.15, 1.0), color = C.white },
		{ shape = "Ball", pos = p(-0.15, 0.2, -2.85), size = v(0.12, 0.08, 0.12), color = C.black },
		{ shape = "Ball", pos = p(0.15, 0.2, -2.85), size = v(0.12, 0.08, 0.12), color = C.black },
		-- Asas com insígnia, motores e hélices
		{ pos = p(0, 0, 0), size = v(4.6, 0.15, 1.1), color = olive },
		{ shape = "Cylinder", axis = "Y", pos = p(-1.8, 0.09, 0), size = v(0.6, 0.04, 0.6), color = C.white },
		{ shape = "Cylinder", axis = "Y", pos = p(1.8, 0.09, 0), size = v(0.6, 0.04, 0.6), color = C.white },
		{ shape = "Cylinder", axis = "Y", pos = p(-1.8, 0.11, 0), size = v(0.3, 0.04, 0.3), color = C.red },
		{ shape = "Cylinder", axis = "Y", pos = p(1.8, 0.11, 0), size = v(0.3, 0.04, 0.3), color = C.red },
		-- Cauda: estabilizadores (a câmera vê)
		{ shape = "Cylinder", axis = "Z", pos = p(0, 0.1, 1.95), size = v(0.8, 0.8, 0.6), color = olive },
		{ pos = p(0, 0.15, 2.15), size = v(1.8, 0.1, 0.6), color = olive },
		{ pos = p(0, 0.6, 2.15), size = v(0.1, 0.9, 0.6), color = green },
	}
	for _, side in { -1, 1 } do
		table.insert(parts, { shape = "Cylinder", axis = "Z", pos = p(side * 1.1, -0.1, -0.55), size = v(0.45, 0.45, 0.7), color = dark, material = METAL })
		table.insert(parts, { pos = p(side * 1.1, -0.1, -0.95), size = v(0.9, 0.12, 0.05), color = B.steel, material = METAL })
		table.insert(parts, { pos = p(side * 1.1, -0.1, -0.95), size = v(0.12, 0.9, 0.05), color = B.steel, material = METAL })
		table.insert(parts, { shape = "Cylinder", axis = "Z", pos = p(side * 0.35, -0.8, 0.2), size = v(0.35, 0.35, 1.0), color = dark, material = METAL })
		table.insert(parts, { pos = p(side * 0.35, -0.8, 0.75), size = v(0.4, 0.06, 0.2), color = dark, material = METAL })
	end
	for z = -0.6, 1.2, 0.45 do
		table.insert(parts, { pos = p(0, 0.68, z), size = v(0.2, 0.18, 0.25), rot = v(0, 45, 0), color = green })
	end
	Recipes.HeroBombardiro = creature(nil, parts, eye(-0.35, -0.05, -1.7, 0.42), eye(0.35, -0.05, -1.7, 0.42))
end

------------------------------------------------------------------------------------------
-- Perseguidor (desligado por enquanto): almôndega queimada de olhos vermelhos, original
------------------------------------------------------------------------------------------

Recipes.ChaserShadow = creature(nil, {
	{ shape = "Ball", pos = v(0, -0.2, 0), size = v(2.7, 2.7, 2.7), color = rgb(45, 35, 40), material = SAND },
	{ shape = "Ball", pos = v(-0.45, 0.25, -1.15), size = v(0.6, 0.6, 0.4), color = rgb(255, 60, 80), material = NEON },
	{ shape = "Ball", pos = v(0.45, 0.25, -1.15), size = v(0.6, 0.6, 0.4), color = rgb(255, 60, 80), material = NEON },
	{ shape = "Cylinder", axis = "Y", pos = v(-0.4, -1.95, 0), size = v(0.22, 1.1, 0.22), color = rgb(25, 22, 32), swing = 1 },
	{ shape = "Cylinder", axis = "Y", pos = v(0.4, -1.95, 0), size = v(0.22, 1.1, 0.22), color = rgb(25, 22, 32), swing = -1 },
})
return Recipes
