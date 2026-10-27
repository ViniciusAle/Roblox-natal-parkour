--!strict
-- Receitas visuais (obstáculos, cenário, heróis e lobby) montadas com peças básicas.
-- Guia de estilo em docs/STYLE.md. Prop novo = receita nova; nada de lógica aqui.
-- Convenção: a caixa olha para -Z (sentido da corrida); a face +Z é a que o jogador vê chegando.

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
local SNOW = Enum.Material.Snow
local ICE = Enum.Material.Ice
local WOOD = Enum.Material.WoodPlanks

-- Paleta
local C = {
	white = rgb(250, 248, 242),
	red = rgb(214, 40, 52),
	pink = rgb(246, 140, 175),
	gold = rgb(250, 196, 50),
	green = rgb(46, 150, 80),
	green2 = rgb(80, 185, 100),
	darkGreen = rgb(24, 95, 60),
	ginger = rgb(186, 112, 56),
	choc = rgb(90, 52, 32),
	cookie = rgb(205, 145, 85),
	warm = rgb(255, 200, 110),
	skin = rgb(250, 210, 175),
	black = rgb(35, 32, 38),
	brown = rgb(120, 78, 45),
	tan = rgb(214, 180, 130),
	paperRed = rgb(232, 86, 80),
	paperRedLight = rgb(250, 140, 125),
	paperBlue = rgb(70, 130, 220),
	paperBlueLight = rgb(130, 180, 245),
	paperYellow = rgb(250, 200, 70),
	paperYellowLight = rgb(255, 230, 140),
	paperGreen = rgb(90, 175, 110),
	paperGreenLight = rgb(150, 215, 150),
	steel = rgb(110, 125, 150),
	ice = rgb(170, 220, 250),
	snowBlue = rgb(215, 232, 248),
	cyan = rgb(90, 235, 255),
	nightBlue = rgb(30, 45, 90),
	orange = rgb(250, 140, 40),
	silver = rgb(225, 235, 245),
}

-- Pirâmide de 4 meias-cunhas (copa de árvore, chapéu, montanha)
local function pyramid(pos: Vector3, size: Vector3, color: Color3, material: Enum.Material?): { PartSpec }
	local hx, hz = size.X / 4, size.Z / 4
	return {
		{ shape = "Wedge", pos = pos + v(-hx, 0, 0), size = v(size.X / 2, size.Y, size.Z), yaw = 90, color = color, material = material },
		{ shape = "Wedge", pos = pos + v(hx, 0, 0), size = v(size.X / 2, size.Y, size.Z), yaw = -90, color = color, material = material },
		{ shape = "Wedge", pos = pos + v(0, 0, -hz), size = v(size.X, size.Y, size.Z / 2), yaw = 0, color = color, material = material },
		{ shape = "Wedge", pos = pos + v(0, 0, hz), size = v(size.X, size.Y, size.Z / 2), yaw = 180, color = color, material = material },
	}
end

-- Empena (telhado / triângulo de papel visto de frente)
local function gable(pos: Vector3, size: Vector3, color: Color3, material: Enum.Material?): { PartSpec }
	local hx = size.X / 4
	return {
		{ shape = "Wedge", pos = pos + v(-hx, 0, 0), size = v(size.X / 2, size.Y, size.Z), yaw = 90, color = color, material = material },
		{ shape = "Wedge", pos = pos + v(hx, 0, 0), size = v(size.X / 2, size.Y, size.Z), yaw = -90, color = color, material = material },
	}
end

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
-- Capítulo 1: Vila de pão de mel
------------------------------------------------------------------------------------------

Recipes.GiftPair = recipe({
	{ pos = v(-0.24, 0, 0), size = v(0.46, 1, 0.9), color = C.red },
	{ pos = v(-0.24, 0, 0), size = v(0.08, 1.02, 0.92), color = C.gold },
	{ pos = v(-0.24, 0, 0), size = v(0.47, 1.02, 0.14), color = C.gold },
	{ shape = "Ball", pos = v(-0.24, 0.55, 0), size = v(0.14, 0.4, 0.45), color = C.gold },
	{ pos = v(0.25, -0.1, 0), size = v(0.46, 0.8, 0.85), color = C.green },
	{ pos = v(0.25, -0.1, 0), size = v(0.08, 0.82, 0.87), color = C.white },
})

Recipes.CandyArch = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(-0.46, -0.12, 0), size = v(0.08, 0.76, 0.4), color = C.white },
	{ shape = "Cylinder", axis = "Y", pos = v(0.46, -0.12, 0), size = v(0.08, 0.76, 0.4), color = C.white },
	{ shape = "Cylinder", axis = "Y", pos = v(-0.46, -0.3, 0), size = v(0.09, 0.05, 0.42), color = C.red },
	{ shape = "Cylinder", axis = "Y", pos = v(0.46, -0.3, 0), size = v(0.09, 0.05, 0.42), color = C.red },
	{ pos = v(0, 0.055, 0), size = v(1, 0.333, 0.8), color = C.pink },
	{ pos = v(0, 0.235, 0), size = v(1.03, 0.05, 0.86), color = C.white },
	{ pos = v(-0.3, 0.055, 0.41), size = v(0.06, 0.333, 0.02), color = C.red },
	{ pos = v(0, 0.055, 0.41), size = v(0.06, 0.333, 0.02), color = C.red },
	{ pos = v(0.3, 0.055, 0.41), size = v(0.06, 0.333, 0.02), color = C.red },
	{ shape = "Ball", pos = v(0, 0.32, 0), size = v(0.16, 0.13, 0.6), color = C.green2 },
})

Recipes.GingerHouse = recipe({
	{ pos = v(0, -0.2, 0), size = v(0.92, 0.6, 0.92), color = C.ginger },
	{ pos = v(0, -0.48, 0), size = v(0.95, 0.04, 0.95), color = C.white },
	{ pos = v(0, 0.1, 0), size = v(1, 0.03, 1), color = C.white },
	{ pos = v(0, -0.36, 0.465), size = v(0.24, 0.28, 0.02), color = C.choc },
	{ pos = v(-0.28, -0.12, 0.465), size = v(0.16, 0.14, 0.02), color = C.warm, material = NEON },
	{ pos = v(0.28, -0.12, 0.465), size = v(0.16, 0.14, 0.02), color = C.warm, material = NEON },
	{ pos = v(0.25, 0.36, -0.2), size = v(0.1, 0.16, 0.1), color = C.choc },
	{ shape = "Ball", pos = v(-0.15, 0.42, 0.3), size = v(0.09, 0.07, 0.09), color = C.red },
	{ shape = "Ball", pos = v(0.12, 0.42, -0.25), size = v(0.09, 0.07, 0.09), color = C.green2 },
}, gable(v(0, 0.255, 0), v(1, 0.31, 1), C.choc))

Recipes.CandyCane = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.08, 0), size = v(0.5, 0.84, 0.5), color = C.white },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.35, 0), size = v(0.52, 0.06, 0.52), color = C.red },
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.1, 0), size = v(0.52, 0.06, 0.52), color = C.red },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.15, 0), size = v(0.52, 0.06, 0.52), color = C.red },
	{ shape = "Cylinder", pos = v(0.3, 0.36, 0), size = v(0.7, 0.1, 0.5), color = C.red },
	{ shape = "Cylinder", axis = "Y", pos = v(0.62, 0.29, 0), size = v(0.5, 0.12, 0.5), color = C.white },
})

Recipes.Lollipop = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.2, 0), size = v(0.07, 0.6, 0.07), color = C.white },
	{ shape = "Cylinder", axis = "Z", pos = v(0, 0.22, 0), size = v(1, 0.6, 0.12), color = C.pink },
	{ shape = "Cylinder", axis = "Z", pos = v(0, 0.22, 0), size = v(0.66, 0.4, 0.14), color = C.white },
	{ shape = "Cylinder", axis = "Z", pos = v(0, 0.22, 0), size = v(0.33, 0.2, 0.16), color = C.red },
})

Recipes.GumdropTree = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.38, 0), size = v(0.15, 0.24, 0.15), color = C.choc },
	{ shape = "Ball", pos = v(0, -0.08, 0), size = v(1, 0.667, 1), color = C.green },
	{ shape = "Ball", pos = v(0, 0.2, 0), size = v(0.75, 0.5, 0.75), color = C.green2 },
	{ shape = "Ball", pos = v(0, 0.4, 0), size = v(0.5, 0.333, 0.5), color = C.green },
	{ shape = "Ball", pos = v(0.35, -0.05, 0.25), size = v(0.15, 0.1, 0.15), color = C.red },
	{ shape = "Ball", pos = v(-0.28, 0.18, 0.22), size = v(0.15, 0.1, 0.15), color = C.gold },
	{ shape = "Ball", pos = v(0.15, 0.36, 0.18), size = v(0.12, 0.08, 0.12), color = C.white },
})

Recipes.CookieHill = recipe({
	{ shape = "Ball", pos = v(0, -0.2, 0), size = v(1, 2.5, 1), color = C.cookie },
	{ shape = "Ball", pos = v(0, 0.46, 0), size = v(0.6, 1.5, 0.6), color = C.white },
	{ shape = "Ball", pos = v(-0.25, 0.3, 0.3), size = v(0.1, 0.25, 0.1), color = C.red },
	{ shape = "Ball", pos = v(0.3, 0.2, 0.25), size = v(0.1, 0.25, 0.1), color = C.green2 },
})

------------------------------------------------------------------------------------------
-- Capítulo 2: Fábrica de brinquedos (papel recortado: camadas planas, cores chapadas)
------------------------------------------------------------------------------------------

Recipes.ToyCrate = recipe({
	{ pos = v(-0.24, 0, 0), size = v(0.46, 1, 0.9), color = C.tan, material = WOOD },
	{ pos = v(-0.24, 0, 0.455), size = v(0.36, 0.7, 0.02), color = C.brown },
	{ pos = v(0.25, -0.1, 0), size = v(0.46, 0.8, 0.85), color = C.paperBlue },
	{ pos = v(0.25, -0.1, 0.43), size = v(0.34, 0.56, 0.02), color = C.paperBlueLight },
	{ shape = "Ball", pos = v(0.25, 0.48, 0), size = v(0.16, 0.4, 0.5), color = C.paperYellow },
})

Recipes.ConveyorBeam = recipe({
	{ pos = v(-0.46, -0.12, 0), size = v(0.07, 0.76, 0.5), color = C.steel },
	{ pos = v(0.46, -0.12, 0), size = v(0.07, 0.76, 0.5), color = C.steel },
	{ pos = v(0, 0.055, 0), size = v(1, 0.333, 0.8), color = C.paperYellow },
	{ pos = v(-0.4, 0.055, 0.41), size = v(0.08, 0.333, 0.02), color = C.black },
	{ pos = v(-0.2, 0.055, 0.41), size = v(0.08, 0.333, 0.02), color = C.black },
	{ pos = v(0, 0.055, 0.41), size = v(0.08, 0.333, 0.02), color = C.black },
	{ pos = v(0.2, 0.055, 0.41), size = v(0.08, 0.333, 0.02), color = C.black },
	{ pos = v(0.4, 0.055, 0.41), size = v(0.08, 0.333, 0.02), color = C.black },
	{ pos = v(0, -0.115, 0.3), size = v(0.9, 0.025, 0.1), color = C.red, material = NEON },
})

Recipes.ToyTower = recipe({
	{ pos = v(0, -0.33, 0), size = v(0.92, 0.34, 0.92), color = C.paperRed },
	{ pos = v(0, -0.33, 0.465), size = v(0.7, 0.26, 0.02), color = C.paperRedLight },
	{ pos = v(0, 0, 0), size = v(0.8, 0.3, 0.85), color = C.paperBlue },
	{ pos = v(0, 0, 0.43), size = v(0.6, 0.22, 0.02), color = C.paperBlueLight },
	{ pos = v(0, 0.3, 0), size = v(0.66, 0.28, 0.75), color = C.paperYellow },
	{ pos = v(0, 0.3, 0.38), size = v(0.48, 0.2, 0.02), color = C.paperYellowLight },
})

Recipes.PaperTree = recipe(
	gable(v(0, 0.1, -0.25), v(1, 0.8, 0.25), C.paperGreen),
	gable(v(0, -0.05, 0.2), v(0.76, 0.6, 0.25), C.paperGreenLight),
	{ { pos = v(0, -0.42, 0), size = v(0.12, 0.16, 0.3), color = C.brown } }
)

Recipes.Gear = recipe({
	{ shape = "Cylinder", axis = "Z", pos = v(0, 0, 0), size = v(0.8, 0.8, 0.6), color = C.steel },
	{ pos = v(0, 0, 0), size = v(1, 0.16, 0.5), color = C.steel },
	{ pos = v(0, 0, 0), size = v(0.16, 1, 0.5), color = C.steel },
	{ shape = "Cylinder", axis = "Z", pos = v(0, 0, 0.1), size = v(0.5, 0.5, 0.7), color = C.paperBlueLight },
	{ shape = "Cylinder", axis = "Z", pos = v(0, 0, 0.2), size = v(0.22, 0.22, 0.8), color = C.paperYellow },
})

Recipes.PaperCloud = recipe({
	{ shape = "Cylinder", axis = "Z", pos = v(-0.25, -0.1, 0), size = v(0.375, 1, 0.5), color = C.white },
	{ shape = "Cylinder", axis = "Z", pos = v(0.08, 0.1, 0.1), size = v(0.5, 1.3, 0.5), color = C.white },
	{ shape = "Cylinder", axis = "Z", pos = v(0.32, -0.12, 0), size = v(0.33, 0.9, 0.5), color = C.white },
})

Recipes.ToyBlocks = recipe({
	{ pos = v(-0.22, -0.25, 0), size = v(0.45, 0.5, 0.45), color = C.paperRed },
	{ pos = v(-0.22, -0.25, 0.23), size = v(0.32, 0.36, 0.02), color = C.paperRedLight },
	{ pos = v(0.25, -0.25, 0.1), size = v(0.45, 0.5, 0.45), color = C.paperBlue },
	{ pos = v(0.25, -0.25, 0.33), size = v(0.32, 0.36, 0.02), color = C.paperBlueLight },
	{ pos = v(0, 0.25, 0.05), size = v(0.45, 0.5, 0.45), color = C.paperYellow },
	{ pos = v(0, 0.25, 0.28), size = v(0.32, 0.36, 0.02), color = C.paperYellowLight },
})

Recipes.PaperHills = recipe({
	{ shape = "Cylinder", axis = "Z", pos = v(-0.2, -0.4, 0), size = v(0.8, 2.6, 0.5), color = C.paperGreen },
	{ shape = "Cylinder", axis = "Z", pos = v(0.25, -0.5, 0.3), size = v(0.6, 2, 0.5), color = C.paperGreenLight },
})

------------------------------------------------------------------------------------------
-- Capítulo 3: Polo Norte (noite de luzes, neon equilibrado: luz nos detalhes, piso legível)
------------------------------------------------------------------------------------------

Recipes.SnowLog = recipe({
	{ shape = "Cylinder", pos = v(0, -0.1, 0), size = v(1, 1, 1), color = C.snowBlue, material = SNOW },
	{ pos = v(0, 0.42, 0), size = v(0.9, 0.16, 0.7), color = C.white, material = SNOW },
	{ shape = "Ball", pos = v(-0.3, 0.38, 0.32), size = v(0.05, 0.2, 0.2), color = C.red, material = NEON },
	{ shape = "Ball", pos = v(0, 0.38, 0.32), size = v(0.05, 0.2, 0.2), color = C.green2, material = NEON },
	{ shape = "Ball", pos = v(0.3, 0.38, 0.32), size = v(0.05, 0.2, 0.2), color = C.gold, material = NEON },
})

Recipes.IcicleBeam = recipe({
	{ pos = v(-0.46, -0.12, 0), size = v(0.07, 0.76, 0.5), color = C.ice, material = ICE },
	{ pos = v(0.46, -0.12, 0), size = v(0.07, 0.76, 0.5), color = C.ice, material = ICE },
	{ pos = v(0, 0.055, 0), size = v(1, 0.333, 0.8), color = C.ice, material = ICE },
	{ pos = v(0, 0.24, 0), size = v(1.02, 0.06, 0.85), color = C.white, material = SNOW },
	{ pos = v(0, -0.115, 0.3), size = v(1, 0.025, 0.1), color = C.cyan, material = NEON },
})

Recipes.IceBlock = recipe({
	{ pos = v(0, -0.05, 0), size = v(0.92, 0.9, 0.92), color = C.ice, material = ICE, transparency = 0.1 },
	{ pos = v(0, 0.42, 0), size = v(0.96, 0.06, 0.96), color = C.white, material = SNOW },
	{ pos = v(0, 0.38, 0.465), size = v(0.92, 0.03, 0.02), color = C.cyan, material = NEON },
	{ pos = v(-0.46, -0.05, 0.465), size = v(0.02, 0.86, 0.02), color = C.cyan, material = NEON },
	{ pos = v(0.46, -0.05, 0.465), size = v(0.02, 0.86, 0.02), color = C.cyan, material = NEON },
})

Recipes.PineLights = recipe(
	{ { shape = "Cylinder", axis = "Y", pos = v(0, -0.44, 0), size = v(0.15, 0.12, 0.15), color = C.brown } },
	pyramid(v(0, -0.16, 0), v(1, 0.45, 1), C.darkGreen),
	pyramid(v(0, 0.16, 0), v(0.7, 0.4, 0.7), C.green),
	{
		{ shape = "Ball", pos = v(0.28, -0.26, 0.26), size = v(0.12, 0.09, 0.12), color = C.red, material = NEON },
		{ shape = "Ball", pos = v(-0.26, -0.22, 0.24), size = v(0.12, 0.09, 0.12), color = C.gold, material = NEON },
		{ shape = "Ball", pos = v(0.12, 0.08, 0.2), size = v(0.12, 0.09, 0.12), color = C.cyan, material = NEON },
		{ shape = "Ball", pos = v(0, 0.39, 0), size = v(0.16, 0.12, 0.16), color = C.gold, material = NEON },
	}
)

Recipes.IceCrystal = recipe({
	{ pos = v(0, -0.1, 0), size = v(0.35, 0.8, 0.35), yaw = 45, color = C.ice, material = ICE, transparency = 0.25 },
	{ pos = v(0, -0.1, 0), size = v(0.1, 0.7, 0.1), yaw = 45, color = C.cyan, material = NEON },
	{ pos = v(0.3, -0.25, 0.1), size = v(0.25, 0.5, 0.25), yaw = 45, color = C.ice, material = ICE, transparency = 0.25 },
	{ pos = v(-0.28, -0.3, -0.05), size = v(0.22, 0.4, 0.22), yaw = 45, color = C.ice, material = ICE, transparency = 0.25 },
})

Recipes.Igloo = recipe({
	{ shape = "Ball", pos = v(0, -0.5, 0), size = v(1, 1.5, 1), color = C.white, material = SNOW },
	{ shape = "Cylinder", axis = "Z", pos = v(0, -0.3, 0.45), size = v(0.35, 0.5, 0.15), color = C.snowBlue, material = SNOW },
	{ shape = "Cylinder", axis = "Z", pos = v(0, -0.33, 0.47), size = v(0.24, 0.36, 0.12), color = C.warm, material = NEON },
})

Recipes.StarLamp = recipe({
	{ shape = "Cylinder", axis = "Y", pos = v(0, -0.05, 0), size = v(0.25, 0.9, 0.25), color = C.black },
	{ shape = "Ball", pos = v(0, 0.45, 0), size = v(0.9, 0.15, 0.9), color = C.warm, material = NEON },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.5, 0), size = v(0.8, 0.04, 0.8), color = C.black },
})

Recipes.StarLampLit = {
	parts = Recipes.StarLamp.parts,
	light = { color = C.warm, range = 22, brightness = 1.6, at = v(0, 0.45, 0) },
}

Recipes.SnowMountain = recipe(pyramid(v(0, 0, 0), v(1, 1, 1), C.snowBlue, SNOW), pyramid(v(0, 0.3, 0), v(0.42, 0.4, 0.42), C.white, SNOW))

------------------------------------------------------------------------------------------
-- Heróis (provisórios até existirem modelos finais). Caixa = tamanho do corredor; frente = -Z.
------------------------------------------------------------------------------------------

Recipes.HeroElf = recipe({
	{ pos = v(-0.2, -0.38, 0), size = v(0.32, 0.24, 0.6), color = C.darkGreen },
	{ pos = v(0.2, -0.38, 0), size = v(0.32, 0.24, 0.6), color = C.darkGreen },
	{ pos = v(0, -0.08, 0), size = v(0.9, 0.36, 0.85), color = C.green },
	{ pos = v(0, -0.2, 0), size = v(0.92, 0.06, 0.87), color = C.black },
	{ pos = v(0, -0.2, -0.44), size = v(0.2, 0.06, 0.03), color = C.gold },
	{ shape = "Ball", pos = v(0, 0.2, 0), size = v(0.62, 0.3, 0.75), color = C.skin },
	{ pos = v(-0.33, 0.22, 0), size = v(0.12, 0.08, 0.2), color = C.skin },
	{ pos = v(0.33, 0.22, 0), size = v(0.12, 0.08, 0.2), color = C.skin },
	{ shape = "Ball", pos = v(0, 0.54, 0), size = v(0.2, 0.08, 0.2), color = C.white },
}, pyramid(v(0, 0.42, 0), v(0.6, 0.2, 0.7), C.red))

Recipes.HeroSanta = recipe({
	{ pos = v(-0.2, -0.38, 0), size = v(0.34, 0.24, 0.6), color = C.black },
	{ pos = v(0.2, -0.38, 0), size = v(0.34, 0.24, 0.6), color = C.black },
	{ pos = v(0, -0.06, 0), size = v(1, 0.4, 0.95), color = C.red },
	{ pos = v(0, -0.27, 0), size = v(1.02, 0.05, 0.97), color = C.white },
	{ pos = v(0, -0.14, 0), size = v(1.02, 0.06, 0.97), color = C.black },
	{ pos = v(0, -0.14, -0.49), size = v(0.22, 0.07, 0.03), color = C.gold },
	{ shape = "Ball", pos = v(0, 0.22, 0), size = v(0.62, 0.3, 0.75), color = C.skin },
	{ shape = "Ball", pos = v(0, 0.13, -0.18), size = v(0.55, 0.24, 0.55), color = C.white },
	{ pos = v(0, 0.33, 0), size = v(0.66, 0.05, 0.75), color = C.white },
	{ shape = "Ball", pos = v(0, 0.55, 0), size = v(0.2, 0.08, 0.2), color = C.white },
}, pyramid(v(0, 0.44, 0), v(0.6, 0.18, 0.7), C.red))

Recipes.HeroReindeer = recipe({
	{ pos = v(-0.2, -0.38, 0), size = v(0.3, 0.24, 0.6), color = C.choc },
	{ pos = v(0.2, -0.38, 0), size = v(0.3, 0.24, 0.6), color = C.choc },
	{ pos = v(0, -0.08, 0), size = v(0.88, 0.38, 0.85), color = C.brown },
	{ pos = v(0, -0.08, -0.43), size = v(0.5, 0.25, 0.04), color = C.tan },
	{ shape = "Ball", pos = v(0, 0.22, 0), size = v(0.62, 0.3, 0.75), color = C.brown },
	{ shape = "Ball", pos = v(0, 0.18, -0.4), size = v(0.25, 0.1, 0.25), color = C.red, material = NEON },
	{ pos = v(-0.22, 0.44, 0), size = v(0.07, 0.2, 0.08), color = C.tan },
	{ pos = v(0.22, 0.44, 0), size = v(0.07, 0.2, 0.08), color = C.tan },
	{ pos = v(-0.32, 0.5, 0), size = v(0.22, 0.04, 0.08), color = C.tan },
	{ pos = v(0.32, 0.5, 0), size = v(0.22, 0.04, 0.08), color = C.tan },
	{ pos = v(-0.34, 0.27, 0), size = v(0.14, 0.06, 0.15), color = C.choc },
	{ pos = v(0.34, 0.27, 0), size = v(0.14, 0.06, 0.15), color = C.choc },
})

Recipes.HeroSnowman = recipe({
	{ shape = "Ball", pos = v(0, -0.3, 0), size = v(1, 0.48, 1.2), color = C.white, material = SNOW },
	{ shape = "Ball", pos = v(0, 0.05, 0), size = v(0.8, 0.38, 0.95), color = C.white, material = SNOW },
	{ shape = "Ball", pos = v(0, 0.32, 0), size = v(0.6, 0.28, 0.7), color = C.white, material = SNOW },
	{ shape = "Cylinder", axis = "Z", pos = v(0, 0.32, -0.42), size = v(0.08, 0.06, 0.3), color = C.orange },
	{ pos = v(0, 0.19, 0), size = v(0.62, 0.05, 0.72), color = C.red },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.43, 0), size = v(0.66, 0.02, 0.77), color = C.black },
	{ shape = "Cylinder", axis = "Y", pos = v(0, 0.51, 0), size = v(0.42, 0.14, 0.5), color = C.black },
	{ shape = "Ball", pos = v(0, 0.06, -0.45), size = v(0.1, 0.04, 0.1), color = C.black },
	{ shape = "Ball", pos = v(0, -0.06, -0.45), size = v(0.1, 0.04, 0.1), color = C.black },
})

Recipes.HeroIceFairy = recipe({
	{ pos = v(-0.14, -0.4, 0), size = v(0.18, 0.2, 0.4), color = C.silver },
	{ pos = v(0.14, -0.4, 0), size = v(0.18, 0.2, 0.4), color = C.silver },
	{ pos = v(0, 0.08, 0), size = v(0.5, 0.18, 0.5), color = C.white },
	{ shape = "Ball", pos = v(0, 0.27, 0), size = v(0.58, 0.28, 0.7), color = C.skin },
	{ shape = "Ball", pos = v(0, 0.3, 0.08), size = v(0.64, 0.31, 0.76), color = C.silver },
	{ shape = "Ball", pos = v(0, 0.47, 0), size = v(0.15, 0.07, 0.15), color = C.gold, material = NEON },
	{ pos = v(-0.45, 0.08, 0.42), size = v(0.6, 0.45, 0.03), color = C.cyan, material = NEON, transparency = 0.45 },
	{ pos = v(0.45, 0.08, 0.42), size = v(0.6, 0.45, 0.03), color = C.cyan, material = NEON, transparency = 0.45 },
}, pyramid(v(0, -0.14, 0), v(0.95, 0.42, 0.85), C.ice))

-- Vilões perseguidores (provisórios). Krampus: folclore; Duende Rebelde: original.
Recipes.ChaserKrampus = recipe({
	{ pos = v(-0.2, -0.38, 0), size = v(0.3, 0.24, 0.5), color = C.black },
	{ pos = v(0.2, -0.38, 0), size = v(0.3, 0.24, 0.5), color = C.black },
	{ pos = v(0, -0.04, 0), size = v(0.95, 0.46, 0.85), color = rgb(70, 40, 35) },
	{ shape = "Ball", pos = v(0, 0.28, 0), size = v(0.65, 0.3, 0.75), color = rgb(90, 50, 40) },
	{ shape = "Ball", pos = v(-0.14, 0.3, -0.38), size = v(0.12, 0.05, 0.1), color = C.gold, material = NEON },
	{ shape = "Ball", pos = v(0.14, 0.3, -0.38), size = v(0.12, 0.05, 0.1), color = C.gold, material = NEON },
	{ pos = v(-0.3, 0.48, 0), size = v(0.1, 0.22, 0.1), color = C.tan },
	{ pos = v(0.3, 0.48, 0), size = v(0.1, 0.22, 0.1), color = C.tan },
	{ pos = v(-0.4, 0.58, 0), size = v(0.2, 0.06, 0.1), color = C.tan },
	{ pos = v(0.4, 0.58, 0), size = v(0.2, 0.06, 0.1), color = C.tan },
})

Recipes.ChaserRebelElf = recipe({
	{ pos = v(-0.2, -0.38, 0), size = v(0.3, 0.24, 0.5), color = C.black },
	{ pos = v(0.2, -0.38, 0), size = v(0.3, 0.24, 0.5), color = C.black },
	{ pos = v(0, -0.06, 0), size = v(0.9, 0.42, 0.85), color = rgb(110, 40, 140) },
	{ pos = v(0, -0.18, 0), size = v(0.92, 0.06, 0.87), color = C.gold },
	{ shape = "Ball", pos = v(0, 0.24, 0), size = v(0.62, 0.3, 0.75), color = C.skin },
	{ pos = v(0, 0.28, -0.37), size = v(0.5, 0.06, 0.03), color = C.black },
	{ shape = "Ball", pos = v(0, 0.58, 0), size = v(0.2, 0.08, 0.2), color = C.gold },
}, pyramid(v(0, 0.45, 0), v(0.62, 0.22, 0.72), rgb(110, 40, 140)))

return Recipes
