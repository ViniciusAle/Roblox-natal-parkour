--!strict
-- Visual de cada capítulo (direção de arte decidida em 27/10/2026, ver docs/STYLE.md):
--   1. Vila de pão de mel  : biscoito, glacê, doces, luz quente de fim de tarde
--   2. Fábrica de brinquedos: papel recortado, camadas planas, cores chapadas, luz clara e suave
--   3. Polo Norte           : noite de luzes, neon EQUILIBRADO (luz nos detalhes, piso legível)
-- Os capítulos dividem as mesmas formas; muda paleta, material, luz e efeitos.

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
	Gingerbread = {
		floor = { color = rgb(214, 150, 88), material = Enum.Material.SmoothPlastic, stripe = rgb(250, 245, 235), stripeEvery = 12 },
		laneLine = { color = rgb(250, 245, 235), material = Enum.Material.SmoothPlastic },
		rail = { color = rgb(250, 245, 235), trim = rgb(214, 40, 52), trimMaterial = Enum.Material.SmoothPlastic },
		ground = { color = rgb(250, 236, 236), material = Enum.Material.Snow },
		obstacles = { Low = "GiftPair", High = "CandyArch", Block = "GingerHouse" },
		trampoline = rgb(90, 220, 130),
		propsPerSide = 3,
		props = {
			{ recipe = "GingerHouse", size = Vector3.new(14, 14, 12), weight = 3, offset = NumberRange.new(10, 30) },
			{ recipe = "CandyCane", size = Vector3.new(2, 10, 2), weight = 3, offset = NumberRange.new(3, 8) },
			{ recipe = "Lollipop", size = Vector3.new(6, 10, 6), weight = 2, offset = NumberRange.new(6, 20) },
			{ recipe = "GumdropTree", size = Vector3.new(8, 12, 8), weight = 3, offset = NumberRange.new(8, 34) },
		},
		backdrop = {
			{ recipe = "CookieHill", size = Vector3.new(60, 24, 60), weight = 1, offset = NumberRange.new(70, 110) },
		},
		lighting = {
			clockTime = 16.6,
			brightness = 2.4,
			ambient = rgb(120, 90, 80),
			outdoorAmbient = rgb(170, 140, 130),
			fogColor = rgb(255, 214, 190),
			fogEnd = 650,
			atmosphere = {
				density = 0.32,
				offset = 0.1,
				color = rgb(255, 214, 190),
				decay = rgb(240, 150, 120),
				glare = 0.4,
				haze = 1.4,
			},
			bloom = { intensity = 0.5, size = 24, threshold = 1.7 },
			grading = { tint = rgb(255, 244, 232), saturation = 0.15, contrast = 0.06, brightness = 0.02 },
		},
		particles = { rate = 18, colors = { rgb(255, 255, 255) }, size = 0.35, speed = 6 },
		aurora = false,
	},

	ToyFactory = {
		floor = { color = rgb(72, 86, 120), material = Enum.Material.SmoothPlastic, stripe = rgb(56, 66, 96), stripeEvery = 4 },
		laneLine = { color = rgb(250, 200, 70), material = Enum.Material.SmoothPlastic },
		rail = { color = rgb(250, 200, 70), trim = rgb(35, 32, 38), trimMaterial = Enum.Material.SmoothPlastic },
		ground = { color = rgb(244, 232, 210), material = Enum.Material.SmoothPlastic },
		obstacles = { Low = "ToyCrate", High = "ConveyorBeam", Block = "ToyTower" },
		trampoline = rgb(90, 220, 140),
		propsPerSide = 3,
		props = {
			{ recipe = "PaperTree", size = Vector3.new(8, 14, 2), weight = 3, offset = NumberRange.new(5, 26) },
			{ recipe = "Gear", size = Vector3.new(10, 10, 2), weight = 2, offset = NumberRange.new(8, 30), elevation = 2 },
			{ recipe = "ToyBlocks", size = Vector3.new(8, 6, 8), weight = 2, offset = NumberRange.new(4, 18) },
			{ recipe = "PaperCloud", size = Vector3.new(16, 6, 2), weight = 2, offset = NumberRange.new(10, 40), elevation = 24 },
		},
		backdrop = {
			{ recipe = "PaperHills", size = Vector3.new(80, 30, 4), weight = 1, offset = NumberRange.new(60, 100) },
		},
		lighting = {
			clockTime = 13,
			brightness = 2.8,
			ambient = rgb(150, 150, 165),
			outdoorAmbient = rgb(190, 190, 205),
			fogColor = rgb(225, 232, 245),
			fogEnd = 600,
			atmosphere = {
				density = 0.25,
				offset = 0.05,
				color = rgb(225, 232, 245),
				decay = rgb(190, 200, 230),
				glare = 0,
				haze = 0.8,
			},
			bloom = { intensity = 0.25, size = 18, threshold = 2 },
			grading = { tint = rgb(255, 252, 245), saturation = 0.25, contrast = -0.05, brightness = 0.04 },
		},
		particles = {
			rate = 10,
			colors = { rgb(232, 86, 80), rgb(70, 130, 220), rgb(250, 200, 70), rgb(90, 175, 110) },
			size = 0.3,
			speed = 4,
		},
		aurora = false,
	},

	NorthPole = {
		floor = { color = rgb(180, 215, 240), material = Enum.Material.Ice },
		laneLine = { color = rgb(90, 235, 255), material = Enum.Material.Neon },
		rail = { color = rgb(235, 245, 255), trim = rgb(90, 235, 255), trimMaterial = Enum.Material.Neon },
		ground = { color = rgb(225, 238, 252), material = Enum.Material.Snow },
		obstacles = { Low = "SnowLog", High = "IcicleBeam", Block = "IceBlock" },
		trampoline = rgb(110, 240, 200),
		propsPerSide = 3,
		props = {
			{ recipe = "PineLights", size = Vector3.new(8, 16, 8), weight = 4, offset = NumberRange.new(6, 32) },
			{ recipe = "IceCrystal", size = Vector3.new(6, 12, 6), weight = 2, offset = NumberRange.new(4, 20) },
			{ recipe = "Igloo", size = Vector3.new(12, 8, 12), weight = 1, offset = NumberRange.new(14, 34) },
			{ recipe = "StarLamp", size = Vector3.new(2, 12, 2), weight = 2, offset = NumberRange.new(3, 6) },
		},
		backdrop = {
			{ recipe = "SnowMountain", size = Vector3.new(90, 50, 90), weight = 1, offset = NumberRange.new(80, 130) },
		},
		lighting = {
			clockTime = 0.5,
			brightness = 1.2,
			ambient = rgb(70, 80, 130),
			outdoorAmbient = rgb(90, 105, 160),
			fogColor = rgb(25, 35, 75),
			fogEnd = 520,
			atmosphere = {
				density = 0.35,
				offset = 0.15,
				color = rgb(40, 55, 110),
				decay = rgb(20, 30, 70),
				glare = 0,
				haze = 1.2,
			},
			bloom = { intensity = 0.9, size = 28, threshold = 1.2 },
			grading = { tint = rgb(225, 235, 255), saturation = 0.1, contrast = 0.08, brightness = 0.03 },
		},
		particles = { rate = 40, colors = { rgb(255, 255, 255) }, size = 0.4, speed = 5 },
		aurora = true,
	},
}

return Themes
