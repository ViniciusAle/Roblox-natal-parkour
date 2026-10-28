--!strict
-- Visual de cada fase do Anime Racers (biomas originais, decididos em 28/10/2026; ver docs/STYLE.md):
--   1. Vila Ninja    : madeira, telhados em camadas, cerejeiras, lanternas; fim de tarde dourado
--   2. Vila do Porto : cais, casas coloridas, palmeiras, velas; meio-dia de sol forte
--   3. Planeta Verde : rochas, cristais, cogumelos gigantes; céu verde-água, brilho só nos detalhes
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
	NinjaVillage = {
		floor = { color = rgb(168, 160, 150), material = Enum.Material.Cobblestone, stripe = rgb(120, 112, 104), stripeEvery = 10 },
		laneLine = { color = rgb(235, 225, 205), material = Enum.Material.SmoothPlastic },
		rail = { color = rgb(120, 78, 45), trim = rgb(206, 52, 40), trimMaterial = Enum.Material.SmoothPlastic },
		ground = { color = rgb(118, 160, 90), material = Enum.Material.Grass },
		obstacles = { Low = "WoodBarrels", High = "ToriiBeam", Block = "JapaneseHouse" },
		trampoline = rgb(255, 120, 170),
		propsPerSide = 3,
		props = {
			{ recipe = "JapaneseHouse", size = Vector3.new(16, 16, 14), weight = 3, offset = NumberRange.new(10, 32) },
			{ recipe = "SakuraTree", size = Vector3.new(10, 14, 10), weight = 4, offset = NumberRange.new(4, 30) },
			{ recipe = "StoneLantern", size = Vector3.new(2.6, 5, 2.6), weight = 2, offset = NumberRange.new(2, 5) },
			{ recipe = "Bamboo", size = Vector3.new(6, 18, 6), weight = 2, offset = NumberRange.new(6, 36) },
		},
		backdrop = {
			{ recipe = "Pagoda", size = Vector3.new(26, 60, 26), weight = 1, offset = NumberRange.new(55, 85) },
			{ recipe = "MistyMountain", size = Vector3.new(90, 50, 90), weight = 2, offset = NumberRange.new(90, 140) },
		},
		lighting = {
			clockTime = 16.8,
			brightness = 2.4,
			ambient = rgb(120, 100, 100),
			outdoorAmbient = rgb(175, 150, 145),
			fogColor = rgb(255, 214, 200),
			fogEnd = 650,
			atmosphere = {
				density = 0.3,
				offset = 0.1,
				color = rgb(255, 210, 200),
				decay = rgb(235, 140, 130),
				glare = 0.4,
				haze = 1.3,
			},
			bloom = { intensity = 0.45, size = 24, threshold = 1.7 },
			grading = { tint = rgb(255, 242, 236), saturation = 0.18, contrast = 0.06, brightness = 0.02 },
		},
		-- Pétalas de cerejeira
		particles = { rate = 16, colors = { rgb(255, 190, 215), rgb(255, 150, 190) }, size = 0.35, speed = 3 },
		aurora = false,
	},

	HarborVillage = {
		floor = { color = rgb(186, 140, 92), material = Enum.Material.WoodPlanks, stripe = rgb(140, 100, 64), stripeEvery = 4 },
		laneLine = { color = rgb(250, 245, 230), material = Enum.Material.SmoothPlastic },
		rail = { color = rgb(250, 247, 238), trim = rgb(60, 110, 190), trimMaterial = Enum.Material.SmoothPlastic },
		ground = { color = rgb(238, 214, 160), material = Enum.Material.Sand },
		obstacles = { Low = "CargoCrates", High = "SailBeam", Block = "FisherHouse" },
		trampoline = rgb(90, 220, 200),
		propsPerSide = 3,
		props = {
			{ recipe = "FisherHouseTeal", size = Vector3.new(14, 14, 14), weight = 2, offset = NumberRange.new(10, 30) },
			{ recipe = "FisherHouseCoral", size = Vector3.new(14, 14, 14), weight = 2, offset = NumberRange.new(10, 30) },
			{ recipe = "PalmTree", size = Vector3.new(10, 18, 10), weight = 4, offset = NumberRange.new(4, 34) },
			{ recipe = "CargoCrates", size = Vector3.new(7, 3, 3), weight = 2, offset = NumberRange.new(2, 8) },
			{ recipe = "Rowboat", size = Vector3.new(4, 3, 9), weight = 1, offset = NumberRange.new(8, 24) },
		},
		backdrop = {
			{ recipe = "Lighthouse", size = Vector3.new(10, 44, 10), weight = 1, offset = NumberRange.new(45, 70) },
			{ recipe = "IslandHill", size = Vector3.new(70, 26, 70), weight = 2, offset = NumberRange.new(80, 130) },
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
			grading = { tint = rgb(255, 252, 245), saturation = 0.28, contrast = 0.04, brightness = 0.03 },
		},
		-- Brilho leve de maresia
		particles = { rate = 6, colors = { rgb(255, 255, 255) }, size = 0.2, speed = 2 },
		aurora = false,
	},

	AlienPlanet = {
		floor = { color = rgb(150, 160, 175), material = Enum.Material.Slate, stripe = rgb(110, 255, 200), stripeEvery = 12 },
		laneLine = { color = rgb(120, 255, 220), material = Enum.Material.Neon },
		rail = { color = rgb(70, 100, 96), trim = rgb(120, 255, 220), trimMaterial = Enum.Material.Neon },
		ground = { color = rgb(80, 190, 150), material = Enum.Material.Grass },
		obstacles = { Low = "CrystalRocks", High = "VineArch", Block = "MushroomTower" },
		trampoline = rgb(230, 255, 120),
		propsPerSide = 3,
		props = {
			{ recipe = "SpiralPlant", size = Vector3.new(8, 16, 8), weight = 3, offset = NumberRange.new(4, 30) },
			{ recipe = "GlowShrooms", size = Vector3.new(6, 6, 6), weight = 3, offset = NumberRange.new(2, 14) },
			{ recipe = "MushroomTower", size = Vector3.new(14, 18, 14), weight = 2, offset = NumberRange.new(12, 34) },
			{ recipe = "FloatingRock", size = Vector3.new(10, 8, 10), weight = 1, offset = NumberRange.new(10, 40), elevation = 18 },
		},
		backdrop = {
			{ recipe = "AlienSpire", size = Vector3.new(36, 70, 36), weight = 2, offset = NumberRange.new(60, 110) },
		},
		lighting = {
			clockTime = 14,
			brightness = 2.2,
			ambient = rgb(90, 130, 120),
			outdoorAmbient = rgb(130, 180, 165),
			fogColor = rgb(150, 230, 200),
			fogEnd = 600,
			atmosphere = {
				density = 0.34,
				offset = 0.12,
				color = rgb(150, 240, 200),
				decay = rgb(90, 190, 170),
				glare = 0.1,
				haze = 1.4,
			},
			bloom = { intensity = 0.6, size = 26, threshold = 1.4 },
			grading = { tint = rgb(235, 255, 245), saturation = 0.2, contrast = 0.08, brightness = 0.02 },
		},
		-- Esporos brilhantes flutuando
		particles = { rate = 14, colors = { rgb(230, 255, 120), rgb(120, 255, 220) }, size = 0.3, speed = 1.5 },
		aurora = false,
	},
}

return Themes
