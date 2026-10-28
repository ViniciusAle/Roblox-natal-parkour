--!strict
-- Monta o lobby: praça italiana numa tarde dourada, avenida de pedra com canais de água,
-- arco gigante de espaguete na entrada, cafeteira moka gigante com a placa do jogo, círculo dourado da fila,
-- ciprestes, casas coloridas, postes acesos, fontes, mesinhas de café, lambretas e confete caindo.
-- Usa os modelos prontos da Creator Store (Config/Models); sem eles, as receitas de peças (Config/Props).

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Props = require(Shared.Config.Props)
local Strings = require(Shared.Config.Strings)
local PropAssembler = require(Shared.PropAssembler)
local ModelLibrary = require(Shared.ModelLibrary)

local Lobby = GameConfig.Lobby
local CENTER = Lobby.Center
local GROUND_TOP = 0.2
local LANTERN = Color3.fromRGB(255, 210, 130)
local TITLE_FONT = Font.new("rbxasset://fonts/families/LuckiestGuy.json", Enum.FontWeight.Regular)

local C = {
	grass = Color3.fromRGB(120, 180, 90),
	stone = Color3.fromRGB(226, 204, 168),
	terracotta = Color3.fromRGB(196, 120, 80),
	water = Color3.fromRGB(70, 170, 220),
	gold = Color3.fromRGB(250, 196, 50),
	red = Color3.fromRGB(214, 48, 52),
	green = Color3.fromRGB(60, 170, 80),
	cream = Color3.fromRGB(252, 244, 222),
	ink = Color3.fromRGB(60, 20, 90),
}

export type Pad = {
	position: Vector3,
	radius: number,
	status: TextLabel,
}

local function block(parent: Instance, name: string, size: Vector3, cframe: CFrame, color: Color3, material: Enum.Material?): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Parent = parent
	return part
end

local function disc(parent: Instance, name: string, radius: number, height: number, position: Vector3, color: Color3, material: Enum.Material?): Part
	local part = block(parent, name, Vector3.new(height, radius * 2, radius * 2), CFrame.new(position) * CFrame.Angles(0, 0, math.pi / 2), color, material)
	part.Shape = Enum.PartType.Cylinder
	return part
end

local function ring(count: number, radius: number, offsetAngle: number?): { CFrame }
	local list: { CFrame } = {}
	for i = 1, count do
		local angle = (i - 1) / count * math.pi * 2 + (offsetAngle or 0)
		local position = CENTER + Vector3.new(math.cos(angle) * radius, GROUND_TOP, math.sin(angle) * radius)
		-- Frente (+Z da receita) virada para o centro
		local facing = CFrame.lookAt(position, Vector3.new(CENTER.X, GROUND_TOP, CENTER.Z)) * CFrame.Angles(0, math.pi, 0)
		table.insert(list, facing)
	end
	return list
end

-- A avenida (eixo Z, do spawn até a cafeteira) fica livre de decoração
local function onAvenue(base: CFrame, halfWidth: number): boolean
	local offset = base.Position - CENTER
	return math.abs(offset.X) < halfWidth and offset.Z < Lobby.SpawnOffset.Z + 10
end

local function prop(parent: Instance, name: string, base: CFrame, size: Vector3, collide: boolean): Model
	-- base fica no chão; a caixa é centrada
	local box = base * CFrame.new(0, size.Y / 2, 0)
	local source = ModelLibrary.source(name)
	if source then
		local fitted = ModelLibrary.prepare(source, nil, collide)
		ModelLibrary.fit(fitted, box, size)
		fitted.model.Parent = parent
		return fitted.model
	end
	return PropAssembler.build(Props[ModelLibrary.fallback(name)], parent, box, size, collide)
end

-- Luz quente presa no alto de um prop (postes)
local function glow(model: Model, color: Color3)
	local box, size = model:GetBoundingBox()
	local holder = block(model, "Glow", Vector3.new(0.5, 0.5, 0.5), box * CFrame.new(0, size.Y * 0.4, 0), color)
	holder.Transparency = 1
	holder.CanCollide = false
	local light = Instance.new("PointLight")
	light.Color = color
	light.Range = 20
	light.Brightness = 1.4
	light.Shadows = false
	light.Parent = holder
end

local function surfaceText(part: BasePart, face: Enum.NormalId, text: string, color: Color3, stroke: Color3?)
	local gui = Instance.new("SurfaceGui")
	gui.Face = face
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 40
	gui.LightInfluence = 0
	gui.Parent = part
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(0.9, 0.8)
	label.Position = UDim2.fromScale(0.05, 0.1)
	label.BackgroundTransparency = 1
	label.FontFace = TITLE_FONT
	label.TextScaled = true
	label.TextWrapped = true
	label.TextColor3 = color
	label.Text = text
	label.Parent = gui
	if stroke then
		local outline = Instance.new("UIStroke")
		outline.Color = stroke
		outline.Thickness = 4
		outline.Parent = label
	end
end

local function buildLighting()
	Lighting.ClockTime = 15.8
	Lighting.Brightness = 2.7
	Lighting.Ambient = Color3.fromRGB(140, 120, 115)
	Lighting.OutdoorAmbient = Color3.fromRGB(190, 170, 155)
	Lighting.FogColor = Color3.fromRGB(255, 225, 195)
	Lighting.FogEnd = 950

	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
	atmosphere.Density = 0.25
	atmosphere.Offset = 0.08
	atmosphere.Color = Color3.fromRGB(255, 225, 195)
	atmosphere.Decay = Color3.fromRGB(240, 170, 125)
	atmosphere.Glare = 0.3
	atmosphere.Haze = 1.1
	atmosphere.Parent = Lighting

	local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect")
	bloom.Intensity = 0.4
	bloom.Size = 22
	bloom.Threshold = 1.7
	bloom.Parent = Lighting

	local grading = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect")
	grading.TintColor = Color3.fromRGB(255, 246, 236)
	grading.Saturation = 0.3
	grading.Contrast = 0.08
	grading.Parent = Lighting
end

local function buildGround(folder: Folder)
	block(folder, "Grass", Vector3.new(Lobby.GroundSize, 2, Lobby.GroundSize), CFrame.new(CENTER + Vector3.new(0, GROUND_TOP - 1, 0)), C.grass, Enum.Material.Grass)
	disc(folder, "Plaza", Lobby.PlazaRadius, 0.4, CENTER + Vector3.new(0, GROUND_TOP, 0), C.stone, Enum.Material.Cobblestone)
	disc(folder, "PlazaRing", Lobby.PlazaRadius - 6, 0.44, CENTER + Vector3.new(0, GROUND_TOP, 0), C.terracotta, Enum.Material.Brick)
	disc(folder, "PlazaInner", Lobby.PlazaRadius - 8, 0.48, CENTER + Vector3.new(0, GROUND_TOP, 0), C.stone, Enum.Material.Cobblestone)

	-- Avenida de pedra do spawn até a cafeteira gigante, com canais de água dos dois lados
	local length = Lobby.SpawnOffset.Z - Lobby.TempleOffset.Z + 30
	local midZ = (Lobby.SpawnOffset.Z + Lobby.TempleOffset.Z) / 2
	block(folder, "Avenue", Vector3.new(22, 0.5, length), CFrame.new(CENTER + Vector3.new(0, GROUND_TOP + 0.05, midZ)), C.terracotta, Enum.Material.Brick)
	for _, side in { -1, 1 } do
		local x = side * Lobby.CanalOffset
		block(folder, "CanalEdge", Vector3.new(8, 0.8, length), CFrame.new(CENTER + Vector3.new(x, GROUND_TOP + 0.1, midZ)), C.stone, Enum.Material.Cobblestone)
		local water = block(folder, "Canal", Vector3.new(6, 0.4, length - 2), CFrame.new(CENTER + Vector3.new(x, GROUND_TOP + 0.35, midZ)), C.water, Enum.Material.Glass)
		water.Transparency = 0.25
		water.CanCollide = false
	end
end

local function buildSpawn(folder: Folder)
	-- Spawns que já existiam no lugar ficam desativados só durante o jogo (o arquivo não muda)
	for _, existing in Workspace:GetDescendants() do
		if existing:IsA("SpawnLocation") and not existing:IsDescendantOf(folder) then
			existing.Enabled = false
			existing.Transparency = 1
			existing.CanCollide = false
			for _, child in existing:GetChildren() do
				if child:IsA("Decal") then
					child.Transparency = 1
				end
			end
		end
	end

	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "PiazzaSpawn"
	spawn.Anchored = true
	spawn.Size = Vector3.new(10, 0.6, 10)
	spawn.CFrame = CFrame.new(CENTER + Lobby.SpawnOffset - Vector3.new(0, 2.6, 0)) -- olhando para a cafeteira (-Z)
	spawn.Color = C.red
	spawn.Material = Enum.Material.SmoothPlastic
	spawn.Neutral = true
	spawn.Duration = 0
	spawn.TopSurface = Enum.SurfaceType.Smooth
	spawn.Parent = folder
end

-- Marco ao fundo da avenida: cafeteira moka gigante com a placa do jogo, e um arco de espaguete na entrada
local function buildLandmark(folder: Folder)
	local base = CFrame.new(CENTER + Lobby.TempleOffset + Vector3.new(0, GROUND_TOP, 0))
	block(folder, "Steps", Vector3.new(44, 2, 16), base * CFrame.new(0, 1, 6), C.stone, Enum.Material.Cobblestone)
	PropAssembler.build(Props.MokaPot, folder, base * CFrame.new(0, 2 + 24, -8), Vector3.new(36, 48, 36), true)

	local board = block(folder, "TitleBoard", Vector3.new(32, 8, 1), base * CFrame.new(0, 14, 14), C.cream)
	surfaceText(board, Enum.NormalId.Back, Strings.Title, C.gold, C.ink)
	block(folder, "TitleTrimGreen", Vector3.new(11, 0.8, 1.2), base * CFrame.new(-11, 18.4, 14), C.green)
	block(folder, "TitleTrimWhite", Vector3.new(11, 0.8, 1.2), base * CFrame.new(0, 18.4, 14), C.cream)
	block(folder, "TitleTrimRed", Vector3.new(11, 0.8, 1.2), base * CFrame.new(11, 18.4, 14), C.red)
	for _, side in { -1, 1 } do
		block(folder, "TitlePost", Vector3.new(1, 14, 1), base * CFrame.new(side * 15.5, 7, 14), C.ink)
	end

	local hint = block(folder, "HintBoard", Vector3.new(16, 3.4, 0.6), base * CFrame.new(0, 3.6, 22), C.cream)
	surfaceText(hint, Enum.NormalId.Back, Strings.PortalHint, C.red)

	-- Arco gigante de espaguete sobre a avenida, entre o círculo e o spawn
	PropAssembler.build(Props.SpaghettiArch, folder, CFrame.new(CENTER + Vector3.new(0, GROUND_TOP + 13, 8)), Vector3.new(30, 26, 8), false)

	local sparkle = block(folder, "Sparkle", Vector3.new(30, 1, 20), base * CFrame.new(0, 52, -8), C.gold)
	sparkle.Transparency = 1
	sparkle.CanCollide = false
	local emitter = Instance.new("ParticleEmitter")
	emitter.Rate = 10
	emitter.Lifetime = NumberRange.new(2, 3)
	emitter.Speed = NumberRange.new(1, 3)
	emitter.Size = NumberSequence.new(0.6, 0)
	emitter.Color = ColorSequence.new(C.gold)
	emitter.LightEmission = 1
	emitter.Shape = Enum.ParticleEmitterShape.Box
	emitter.Parent = sparkle
end

local function buildPad(folder: Folder): Pad
	local position = CENTER + Lobby.PadOffset + Vector3.new(0, GROUND_TOP, 0)
	local radius = Lobby.PadRadius
	local glow = disc(folder, "PadGlow", radius, 0.3, position + Vector3.new(0, 0.42, 0), Color3.fromRGB(255, 205, 70), Enum.Material.Neon)
	glow.CanCollide = false
	disc(folder, "PadInner", radius - 1.2, 0.4, position + Vector3.new(0, 0.45, 0), C.red)
	disc(folder, "PadCore", radius * 0.35, 0.44, position + Vector3.new(0, 0.48, 0), Color3.fromRGB(255, 225, 120), Enum.Material.Neon)

	local light = Instance.new("PointLight")
	light.Color = Color3.fromRGB(255, 205, 90)
	light.Range = 24
	light.Brightness = 1.4
	light.Parent = glow

	local anchor = block(folder, "PadSign", Vector3.new(1, 1, 1), CFrame.new(position + Vector3.new(0, 10, 0)), Color3.new())
	anchor.Transparency = 1
	anchor.CanCollide = false
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.fromScale(18, 5)
	billboard.LightInfluence = 0
	billboard.MaxDistance = 160
	billboard.Parent = anchor
	local status = Instance.new("TextLabel")
	status.Size = UDim2.fromScale(1, 1)
	status.BackgroundTransparency = 1
	status.FontFace = TITLE_FONT
	status.TextScaled = true
	status.TextColor3 = Color3.fromRGB(255, 240, 200)
	status.TextStrokeTransparency = 0.1
	status.TextStrokeColor3 = C.ink
	status.Text = ""
	status.Parent = billboard

	return { position = position, radius = radius, status = status }
end

local function cypress(folder: Folder, base: CFrame, height: number, random: Random)
	local name = if random:NextNumber() < 0.5 then "CypressA" else "CypressB"
	prop(folder, name, base, Vector3.new(height * 0.32, height, height * 0.32), true)
end

local function buildDecor(folder: Folder)
	local random = Random.new(2810)
	local avenueHalf = Lobby.CanalOffset + 8

	-- Ciprestes em volta da praça (e dois grandes ao lado da cafeteira)
	for _, base in ring(Lobby.TreeCount, Lobby.TreeRing, 0.3) do
		if not onAvenue(base, avenueHalf) then
			cypress(folder, base, random:NextNumber(16, 24), random)
		end
	end
	for _, side in { -1, 1 } do
		local base = CFrame.new(CENTER + Lobby.TempleOffset + Vector3.new(side * 30, GROUND_TOP, 8))
		prop(folder, "CypressA", base, Vector3.new(9, 28, 9), true)
	end

	-- Casas coloridas em anel
	local houses = { "ItalianHouseYellow", "EuroBuilding", "RedRoofHouse", "ShopHouse" }
	for i, base in ring(Lobby.HouseCount, Lobby.HouseRing, 0.4) do
		if not onAvenue(base, avenueHalf + 10) then
			prop(folder, houses[(i - 1) % #houses + 1], base, Vector3.new(26, 28, 26), true)
		end
	end

	-- Postes acesos na borda da praça e ao longo dos canais
	for _, base in ring(Lobby.LanternCount, Lobby.LanternRing, 0.15) do
		if not onAvenue(base, avenueHalf) then
			glow(prop(folder, "StreetLampModel", base, Vector3.new(2.4, 11, 2.4), true), LANTERN)
		end
	end
	local z = Lobby.SpawnOffset.Z
	while z > Lobby.TempleOffset.Z + 12 do
		for _, side in { -1, 1 } do
			local base = CFrame.new(CENTER + Vector3.new(side * (Lobby.CanalOffset - 7), GROUND_TOP, z))
			glow(prop(folder, "StreetLampModel", base, Vector3.new(2.2, 10, 2.2), true), LANTERN)
		end
		z -= 22
	end

	-- Fontes, mesinhas de café, carrinho de sorvete e lambretas na praça
	for _, side in { -1, 1 } do
		prop(folder, "FountainModel", CFrame.new(CENTER + Vector3.new(side * 48, GROUND_TOP, -8)), Vector3.new(16, 12, 16), true)
		for i = 0, 2 do
			local base = CFrame.new(CENTER + Vector3.new(side * 50, GROUND_TOP, 20 + i * 9)) * CFrame.Angles(0, random:NextNumber(0, math.pi), 0)
			prop(folder, "CafeTable", base, Vector3.new(6, 6, 6), true)
		end
		local cart = CFrame.lookAt(CENTER + Vector3.new(side * 18, GROUND_TOP, 30), CENTER + Vector3.new(0, GROUND_TOP, 30))
		prop(folder, "GelatoCart", cart, Vector3.new(6, 7, 5), true)
		local scooter = CFrame.new(CENTER + Vector3.new(side * 22, GROUND_TOP, -40)) * CFrame.Angles(0, side * 0.6, 0)
		prop(folder, if side < 0 then "ScooterOrange" else "ScooterWhite", scooter, Vector3.new(3.4, 3.4, 5.6), true)
	end

	-- Fileira de ciprestes fechando a praça
	for _, base in ring(Lobby.ForestCount, Lobby.ForestRing, 0.05) do
		local jitter = CFrame.new(random:NextNumber(-10, 10), 0, random:NextNumber(-10, 10))
		cypress(folder, base * jitter, random:NextNumber(22, 34), random)
	end

	-- Morros verdes ao longe
	for i = 1, 5 do
		local angle = math.pi * 1.25 + (i - 1) * 0.3
		local base = CFrame.new(CENTER + Vector3.new(math.cos(angle) * 300, GROUND_TOP, math.sin(angle) * 300))
		local height = random:NextNumber(70, 110)
		prop(folder, "MountainGreen", base, Vector3.new(height * 1.8, height, height * 1.8), false)
	end

	-- Confete verde, branco e vermelho caindo sobre a praça
	local sky = block(folder, "Confetti", Vector3.new(300, 1, 300), CFrame.new(CENTER + Vector3.new(0, 70, 0)), Color3.new(1, 1, 1))
	sky.Transparency = 1
	sky.CanCollide = false
	sky.CanQuery = false
	-- Um emissor por cor: cada papelzinho fica de uma cor só
	for _, color in { C.green, C.cream, C.red } do
		local confetti = Instance.new("ParticleEmitter")
		confetti.Shape = Enum.ParticleEmitterShape.Box
		confetti.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
		confetti.EmissionDirection = Enum.NormalId.Bottom
		confetti.Rate = 14
		confetti.Lifetime = NumberRange.new(12, 16)
		confetti.Speed = NumberRange.new(3, 6)
		confetti.SpreadAngle = Vector2.new(30, 30)
		confetti.Rotation = NumberRange.new(0, 360)
		confetti.RotSpeed = NumberRange.new(-180, 180)
		confetti.Size = NumberSequence.new(0.35)
		confetti.LightInfluence = 0
		confetti.Color = ColorSequence.new(color)
		confetti.Parent = sky
	end
end

local LobbyBuilder = {}

function LobbyBuilder.build(): Pad
	local existing = Workspace:FindFirstChild("Lobby")
	if existing then
		existing:Destroy()
	end
	local folder = Instance.new("Folder")
	folder.Name = "Lobby"
	folder.Parent = Workspace

	buildLighting()
	buildGround(folder)
	buildSpawn(folder)
	buildLandmark(folder)
	local pad = buildPad(folder)
	buildDecor(folder)
	return pad
end

return LobbyBuilder
