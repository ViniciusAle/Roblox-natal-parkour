--!strict
-- Visual de cada fase do Brainrot Rush (biomas originais, decididos em 28/10/2026; ver docs/STYLE.md):
--   1. Piazza Pizza    : praça italiana, casas coloridas, ciprestes, lambretas; tarde dourada
--   2. Spiaggia Banana : praia, deque, palmeiras, guarda-sóis; meio-dia de sol forte
--   3. Cosmo Caotico   : espaço roxo, cristais, cogumelos, disco voador e Saturno ao fundo; noite neon
-- Os obstáculos são comida e objetos gigantes com olhos esbugalhados (receitas em Config/Props:
-- a forma bate exatamente com a caixa de colisão). Cenário lateral e fundo usam modelos prontos (Config/Models).
-- Valores de luz escolhidos sem ver o jogo: calibrar por captura de tela.

export type PropEntry = {
	recipe: string,
	size: Vector3,
	weight: number,
	offset: NumberRange, -- distância lateral a partir da borda da pista
	elevation: number?,
}

export type Theme = {
	floor: { color: Color3, material: Enum.Material, stripe: Color3?, stripeEvery: number? },
	laneLine: { color: Color3, material: Enum.Material },
	rail: { color: Color3, trim: Color3, trimMaterial: Enum.Material },
	ground: { color: Color3, material: Enum.Material },
	obstacles: { Low: string, High: string, Block: string },
	trampoline: Color3,
	props: { PropEntry },
	propsPerSide: number,
	-- Decoração pequena e densa entre a borda e os props (arbustos, pedras, flores...), a cada decorSpacing studs
	decor: { PropEntry },
	decorSpacing: number,
	fence: { recipe: string, size: Vector3, offset: number }?, -- cerca contínua dos dois lados
	backdrop: { PropEntry },
	lighting: {
		clockTime: number,
		brightness: number,
		ambient: Color3,
		outdoorAmbient: Color3,
		fogColor: Color3,
		fogEnd: number,
		atmosphere: { density: number, offset: number, color: Color3, decay: Color3, glare: number, haze: number },
		bloom: { intensity: number, size: number, threshold: number },
		grading: { tint: Color3, saturation: number, contrast: number, brightness: number },
	},
	particles: { rate: number, colors: { Color3 }, size: number, speed: number },
	aurora: boolean,
}

local function rgb(r: number, g: number, b: number): Color3
	return Color3.fromRGB(r, g, b)
end

local Themes: { [string]: Theme } = {
	PizzaPiazza = {
		floor = { color = rgb(226, 200, 160), material = Enum.Material.Cobblestone, stripe = rgb(200, 110, 70), stripeEvery = 8 },
		laneLine = { color = rgb(255, 250, 235), material = Enum.Material.SmoothPlastic },
		rail = { color = rgb(245, 236, 215), trim = rgb(60, 170, 80), trimMaterial = Enum.Material.SmoothPlastic },
		ground = { color = rgb(120, 180, 90), material = Enum.Material.Grass },
		obstacles = { Low = "PizzaBoxes", High = "SpaghettiArch", Block = "MokaPot" },
		trampoline = rgb(255, 110, 170),
		propsPerSide = 4,
		decorSpacing = 9,
		decor = {
			{ recipe = "FlowerPink", size = Vector3.new(3, 2.5, 3), weight = 3, offset = NumberRange.new(3, 9) },
			{ recipe = "FlowerPlanter", size = Vector3.new(4, 2, 2), weight = 2, offset = NumberRange.new(2, 6) },
			{ recipe = "BushA", size = Vector3.new(4, 3, 4), weight = 2, offset = NumberRange.new(4, 10) },
			{ recipe = "PizzaSlice", size = Vector3.new(4, 1.2, 4), weight = 1, offset = NumberRange.new(4, 10) },
			{ recipe = "PizzaBoxModel", size = Vector3.new(3, 2.4, 3), weight = 1, offset = NumberRange.new(2, 6) },
			{ recipe = "CafeTable", size = Vector3.new(5, 5, 5), weight = 1, offset = NumberRange.new(5, 10) },
		},
		props = {
			{ recipe = "ItalianHouseYellow", size = Vector3.new(20, 24, 20), weight = 3, offset = NumberRange.new(12, 32) },
			{ recipe = "EuroBuilding", size = Vector3.new(22, 26, 22), weight = 2, offset = NumberRange.new(12, 32) },
			{ recipe = "RedRoofHouse", size = Vector3.new(18, 18, 18), weight = 2, offset = NumberRange.new(12, 32) },
			{ recipe = "ShopHouse", size = Vector3.new(20, 20, 20), weight = 2, offset = NumberRange.new(12, 32) },
			{ recipe = "CypressA", size = Vector3.new(5, 16, 5), weight = 3, offset = NumberRange.new(3, 12) },
			{ recipe = "CypressB", size = Vector3.new(5, 14, 5), weight = 2, offset = NumberRange.new(3, 12) },
			{ recipe = "StreetLampModel", size = Vector3.new(2, 9, 2), weight = 2, offset = NumberRange.new(2, 4) },
			{ recipe = "ScooterOrange", size = Vector3.new(3, 3, 5), weight = 1, offset = NumberRange.new(2, 8) },
			{ recipe = "ScooterWhite", size = Vector3.new(3, 3, 5), weight = 1, offset = NumberRange.new(2, 8) },
			{ recipe = "GelatoCart", size = Vector3.new(5, 6, 4), weight = 1, offset = NumberRange.new(3, 10) },
			{ recipe = "FountainModel", size = Vector3.new(12, 9, 12), weight = 1, offset = NumberRange.new(10, 30) },
		},
		backdrop = {
			{ recipe = "MountainGreen", size = Vector3.new(100, 50, 100), weight = 1, offset = NumberRange.new(90, 150) },
		},
		lighting = {
			clockTime = 15.5,
			brightness = 2.8,
			ambient = rgb(140, 120, 110),
			outdoorAmbient = rgb(190, 170, 150),
			fogColor = rgb(255, 225, 190),
			fogEnd = 750,
			atmosphere = {
				density = 0.25,
				offset = 0.08,
				color = rgb(255, 225, 190),
				decay = rgb(240, 170, 120),
				glare = 0.3,
				haze = 1,
			},
			bloom = { intensity = 0.35, size = 22, threshold = 1.8 },
			grading = { tint = rgb(255, 246, 235), saturation = 0.3, contrast = 0.08, brightness = 0.02 },
		},
		-- Confete verde, branco e vermelho
		particles = { rate = 10, colors = { rgb(60, 180, 80), rgb(255, 255, 255), rgb(230, 50, 50) }, size = 0.3, speed = 2.5 },
		aurora = false,
	},

	BananaBeach = {
		floor = { color = rgb(196, 150, 100), material = Enum.Material.WoodPlanks, stripe = rgb(150, 108, 70), stripeEvery = 4 },
		laneLine = { color = rgb(255, 250, 235), material = Enum.Material.SmoothPlastic },
		rail = { color = rgb(255, 255, 255), trim = rgb(255, 120, 170), trimMaterial = Enum.Material.SmoothPlastic },
		ground = { color = rgb(240, 216, 160), material = Enum.Material.Sand },
		obstacles = { Low = "Sandcastle", High = "BananaLine", Block = "CoconutDrink" },
		trampoline = rgb(90, 220, 200),
		propsPerSide = 4,
		decorSpacing = 9,
		decor = {
			{ recipe = "TropicalBush", size = Vector3.new(5, 4, 5), weight = 3, offset = NumberRange.new(3, 10) },
			{ recipe = "RockB", size = Vector3.new(3, 2, 3), weight = 2, offset = NumberRange.new(3, 10) },
			{ recipe = "BeachUmbrella", size = Vector3.new(5, 6, 5), weight = 2, offset = NumberRange.new(5, 12) },
			{ recipe = "FlowerBush", size = Vector3.new(3, 2.5, 3), weight = 2, offset = NumberRange.new(3, 9) },
			{ recipe = "GelatoCart", size = Vector3.new(5, 6, 4), weight = 1, offset = NumberRange.new(4, 10) },
		},
		props = {
			{ recipe = "BeachHouse", size = Vector3.new(20, 18, 20), weight = 3, offset = NumberRange.new(10, 30) },
			{ recipe = "FisherHouseCoral", size = Vector3.new(14, 14, 14), weight = 1, offset = NumberRange.new(10, 30) },
			{ recipe = "PalmTreeModel", size = Vector3.new(12, 20, 12), weight = 4, offset = NumberRange.new(4, 34) },
			{ recipe = "CrateModel", size = Vector3.new(3, 3, 3), weight = 1, offset = NumberRange.new(2, 8) },
			{ recipe = "BarrelsModel", size = Vector3.new(5, 4, 5), weight = 1, offset = NumberRange.new(2, 10) },
			{ recipe = "RowboatModel", size = Vector3.new(5, 3, 10), weight = 1, offset = NumberRange.new(8, 24) },
		},
		backdrop = {
			{ recipe = "MountainGreen", size = Vector3.new(100, 50, 100), weight = 1, offset = NumberRange.new(90, 150) },
		},
		lighting = {
			clockTime = 12.5,
			brightness = 3,
			ambient = rgb(140, 150, 165),
			outdoorAmbient = rgb(185, 195, 210),
			fogColor = rgb(200, 230, 250),
			fogEnd = 700,
			atmosphere = {
				density = 0.22,
				offset = 0.05,
				color = rgb(200, 230, 250),
				decay = rgb(150, 200, 240),
				glare = 0.2,
				haze = 0.8,
			},
			bloom = { intensity = 0.3, size = 20, threshold = 2 },
			grading = { tint = rgb(255, 252, 245), saturation = 0.35, contrast = 0.05, brightness = 0.03 },
		},
		-- Brilho leve de maresia
		particles = { rate = 6, colors = { rgb(255, 255, 255) }, size = 0.2, speed = 2 },
		aurora = false,
	},

	ChaosCosmos = {
		floor = { color = rgb(70, 56, 110), material = Enum.Material.Slate, stripe = rgb(255, 90, 200), stripeEvery = 12 },
		laneLine = { color = rgb(120, 240, 255), material = Enum.Material.Neon },
		rail = { color = rgb(40, 32, 70), trim = rgb(255, 90, 200), trimMaterial = Enum.Material.Neon },
		ground = { color = rgb(96, 70, 150), material = Enum.Material.Ground },
		obstacles = { Low = "CrystalRocks", High = "UfoBeam", Block = "Rocket" },
		trampoline = rgb(230, 255, 120),
		propsPerSide = 4,
		decorSpacing = 9,
		decor = {
			{ recipe = "GlowMushroomCyan", size = Vector3.new(3, 4, 3), weight = 3, offset = NumberRange.new(3, 10) },
			{ recipe = "GlowMushroomBlue", size = Vector3.new(4, 5, 4), weight = 2, offset = NumberRange.new(4, 12) },
			{ recipe = "AlienCrystal", size = Vector3.new(3, 4, 3), weight = 2, offset = NumberRange.new(3, 10) },
			{ recipe = "RockA", size = Vector3.new(3, 2, 3), weight = 1, offset = NumberRange.new(3, 10) },
			{ recipe = "DonutPack", size = Vector3.new(4, 2, 4), weight = 1, offset = NumberRange.new(3, 10), elevation = 6 },
		},
		props = {
			{ recipe = "AlienMushroomTree", size = Vector3.new(14, 20, 14), weight = 3, offset = NumberRange.new(6, 30) },
			{ recipe = "PurpleMushroom", size = Vector3.new(8, 8, 8), weight = 2, offset = NumberRange.new(2, 14) },
			{ recipe = "AlienPlantModel", size = Vector3.new(8, 10, 8), weight = 2, offset = NumberRange.new(3, 20) },
			{ recipe = "CrystalCluster", size = Vector3.new(6, 6, 6), weight = 2, offset = NumberRange.new(2, 12) },
			{ recipe = "RocketModel", size = Vector3.new(6, 14, 6), weight = 1, offset = NumberRange.new(8, 26) },
			{ recipe = "AsteroidModel", size = Vector3.new(8, 8, 8), weight = 1, offset = NumberRange.new(10, 40), elevation = 20 },
			{ recipe = "RockArchModel", size = Vector3.new(24, 18, 10), weight = 1, offset = NumberRange.new(14, 40) },
		},
		backdrop = {
			{ recipe = "MistyMountain", size = Vector3.new(100, 50, 100), weight = 1, offset = NumberRange.new(90, 150) },
		},
		lighting = {
			clockTime = 21.5,
			brightness = 1.6,
			ambient = rgb(130, 100, 170),
			outdoorAmbient = rgb(150, 120, 200),
			fogColor = rgb(90, 50, 140),
			fogEnd = 600,
			atmosphere = {
				density = 0.35,
				offset = 0.1,
				color = rgb(150, 90, 220),
				decay = rgb(90, 40, 160),
				glare = 0,
				haze = 1.5,
			},
			bloom = { intensity = 0.8, size = 28, threshold = 1.2 },
			grading = { tint = rgb(240, 228, 255), saturation = 0.3, contrast = 0.1, brightness = 0.05 },
		},
		-- Estrelinhas coloridas flutuando
		particles = { rate = 14, colors = { rgb(255, 120, 220), rgb(120, 240, 255), rgb(255, 240, 120) }, size = 0.3, speed = 1.5 },
		aurora = true,
	},
}

return Themes
