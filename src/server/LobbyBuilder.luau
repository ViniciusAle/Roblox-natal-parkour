--!strict
-- Monta a vila do lobby: vila japonesa ao entardecer, avenida de pedra com canais de água,
-- portal torii gigante, templo com a placa do jogo, círculo dourado da fila, cerejeiras,
-- casas, lanternas de pedra acesas, bambuzal em volta e pétalas caindo.
-- Tudo com peças básicas e as mesmas receitas do jogo (Config/Props).

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Props = require(Shared.Config.Props)
local Strings = require(Shared.Config.Strings)
local PropAssembler = require(Shared.PropAssembler)

local Lobby = GameConfig.Lobby
local CENTER = Lobby.Center
local GROUND_TOP = 0.2
local TITLE_FONT = Font.new("rbxasset://fonts/families/LuckiestGuy.json", Enum.FontWeight.Regular)

local C = {
	grass = Color3.fromRGB(118, 165, 92),
	stone = Color3.fromRGB(182, 176, 166),
	stoneDark = Color3.fromRGB(130, 126, 120),
	water = Color3.fromRGB(70, 160, 210),
	wood = Color3.fromRGB(120, 78, 45),
	woodDark = Color3.fromRGB(70, 45, 30),
	gold = Color3.fromRGB(250, 196, 50),
	red = Color3.fromRGB(206, 52, 40),
	cream = Color3.fromRGB(252, 244, 222),
	petal = Color3.fromRGB(255, 185, 210),
	ink = Color3.fromRGB(40, 30, 50),
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

-- A avenida (eixo Z, do spawn até o templo) fica livre de decoração
local function onAvenue(base: CFrame, halfWidth: number): boolean
	local offset = base.Position - CENTER
	return math.abs(offset.X) < halfWidth and offset.Z < Lobby.SpawnOffset.Z + 10
end

local function prop(parent: Instance, recipeName: string, base: CFrame, size: Vector3, collide: boolean): Model
	-- base fica no chão; a caixa da receita é centrada
	return PropAssembler.build(Props[recipeName], parent, base * CFrame.new(0, size.Y / 2, 0), size, collide)
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
	Lighting.ClockTime = 17.3
	Lighting.Brightness = 2.2
	Lighting.Ambient = Color3.fromRGB(120, 100, 110)
	Lighting.OutdoorAmbient = Color3.fromRGB(170, 150, 160)
	Lighting.FogColor = Color3.fromRGB(255, 205, 195)
	Lighting.FogEnd = 900

	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
	atmosphere.Density = 0.28
	atmosphere.Offset = 0.1
	atmosphere.Color = Color3.fromRGB(255, 210, 205)
	atmosphere.Decay = Color3.fromRGB(220, 130, 140)
	atmosphere.Glare = 0.4
	atmosphere.Haze = 1.4
	atmosphere.Parent = Lighting

	local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect")
	bloom.Intensity = 0.5
	bloom.Size = 24
	bloom.Threshold = 1.6
	bloom.Parent = Lighting

	local grading = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect")
	grading.TintColor = Color3.fromRGB(255, 244, 240)
	grading.Saturation = 0.18
	grading.Contrast = 0.06
	grading.Parent = Lighting
end

local function buildGround(folder: Folder)
	block(folder, "Grass", Vector3.new(Lobby.GroundSize, 2, Lobby.GroundSize), CFrame.new(CENTER + Vector3.new(0, GROUND_TOP - 1, 0)), C.grass, Enum.Material.Grass)
	disc(folder, "Plaza", Lobby.PlazaRadius, 0.4, CENTER + Vector3.new(0, GROUND_TOP, 0), C.stone, Enum.Material.Cobblestone)
	disc(folder, "PlazaRing", Lobby.PlazaRadius - 6, 0.44, CENTER + Vector3.new(0, GROUND_TOP, 0), C.stoneDark, Enum.Material.Slate)
	disc(folder, "PlazaInner", Lobby.PlazaRadius - 8, 0.48, CENTER + Vector3.new(0, GROUND_TOP, 0), C.stone, Enum.Material.Cobblestone)

	-- Avenida de pedra do spawn até o templo, com canais de água dos dois lados
	local length = Lobby.SpawnOffset.Z - Lobby.TempleOffset.Z + 30
	local midZ = (Lobby.SpawnOffset.Z + Lobby.TempleOffset.Z) / 2
	block(folder, "Avenue", Vector3.new(22, 0.5, length), CFrame.new(CENTER + Vector3.new(0, GROUND_TOP + 0.05, midZ)), C.stoneDark, Enum.Material.Slate)
	for _, side in { -1, 1 } do
		local x = side * Lobby.CanalOffset
		block(folder, "CanalEdge", Vector3.new(8, 0.8, length), CFrame.new(CENTER + Vector3.new(x, GROUND_TOP + 0.1, midZ)), C.stoneDark, Enum.Material.Slate)
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
	spawn.Name = "VillageSpawn"
	spawn.Anchored = true
	spawn.Size = Vector3.new(10, 0.6, 10)
	spawn.CFrame = CFrame.new(CENTER + Lobby.SpawnOffset - Vector3.new(0, 2.6, 0)) -- olhando para o templo (-Z)
	spawn.Color = C.red
	spawn.Material = Enum.Material.SmoothPlastic
	spawn.Neutral = true
	spawn.Duration = 0
	spawn.TopSurface = Enum.SurfaceType.Smooth
	spawn.Parent = folder
end

-- Templo ao fundo da avenida, com a placa "Anime Racers" e um portal torii gigante na frente
local function buildTemple(folder: Folder)
	local base = CFrame.new(CENTER + Lobby.TempleOffset + Vector3.new(0, GROUND_TOP, 0))
	block(folder, "TempleSteps", Vector3.new(44, 2, 16), base * CFrame.new(0, 1, 6), C.stoneDark, Enum.Material.Slate)
	prop(folder, "Pagoda", base * CFrame.new(0, 2, -6), Vector3.new(34, 70, 34), true)

	local board = block(folder, "TitleBoard", Vector3.new(30, 8, 1), base * CFrame.new(0, 18, 10), C.woodDark, Enum.Material.WoodPlanks)
	surfaceText(board, Enum.NormalId.Back, Strings.Title, C.gold, C.ink)
	block(folder, "TitleTrim", Vector3.new(31, 0.6, 1.2), base * CFrame.new(0, 22.2, 10), C.red)
	block(folder, "TitleTrimLow", Vector3.new(31, 0.6, 1.2), base * CFrame.new(0, 13.8, 10), C.red)

	local hint = block(folder, "HintBoard", Vector3.new(16, 3.4, 0.6), base * CFrame.new(0, 3.6, 22), C.cream)
	surfaceText(hint, Enum.NormalId.Back, Strings.PortalHint, C.red)

	-- Portal torii gigante sobre a avenida, entre o círculo e o spawn
	prop(folder, "ToriiBeam", CFrame.new(CENTER + Vector3.new(0, GROUND_TOP, 8)), Vector3.new(30, 26, 3), false)

	local sparkle = block(folder, "TempleSparkle", Vector3.new(30, 1, 20), base * CFrame.new(0, 40, -6), C.gold)
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
	status.TextStrokeColor3 = Color3.fromRGB(120, 20, 30)
	status.Text = ""
	status.Parent = billboard

	return { position = position, radius = radius, status = status }
end

local function buildDecor(folder: Folder)
	local random = Random.new(2810)
	local avenueHalf = Lobby.CanalOffset + 8

	-- Cerejeiras em volta da praça (e duas grandes ao lado do templo)
	for _, base in ring(Lobby.TreeCount, Lobby.TreeRing, 0.3) do
		if not onAvenue(base, avenueHalf) then
			local height = random:NextNumber(16, 22)
			prop(folder, "SakuraTree", base, Vector3.new(height * 0.8, height, height * 0.8), true)
		end
	end
	for _, side in { -1, 1 } do
		local base = CFrame.new(CENTER + Lobby.TempleOffset + Vector3.new(side * 34, GROUND_TOP, 8))
		prop(folder, "SakuraTree", base, Vector3.new(24, 28, 24), true)
	end

	-- Casas japonesas em anel
	for _, base in ring(Lobby.HouseCount, Lobby.HouseRing, 0.4) do
		if not onAvenue(base, avenueHalf + 10) then
			prop(folder, "JapaneseHouse", base, Vector3.new(22, 22, 18), true)
		end
	end

	-- Lanternas de pedra acesas na borda da praça e ao longo dos canais
	for _, base in ring(Lobby.LanternCount, Lobby.LanternRing, 0.15) do
		if not onAvenue(base, avenueHalf) then
			prop(folder, "StoneLanternLit", base, Vector3.new(3, 6, 3), true)
		end
	end
	local z = Lobby.SpawnOffset.Z
	while z > Lobby.TempleOffset.Z + 12 do
		for _, side in { -1, 1 } do
			local base = CFrame.new(CENTER + Vector3.new(side * (Lobby.CanalOffset - 7), GROUND_TOP, z))
			prop(folder, "StoneLanternLit", base, Vector3.new(2.4, 5, 2.4), true)
		end
		z -= 22
	end

	-- Bambuzal fechando a vila
	for _, base in ring(Lobby.ForestCount, Lobby.ForestRing, 0.05) do
		local height = random:NextNumber(22, 34)
		local jitter = CFrame.new(random:NextNumber(-10, 10), 0, random:NextNumber(-10, 10))
		prop(folder, "Bamboo", base * jitter, Vector3.new(10, height, 10), true)
	end

	-- Montanhas ao longe
	for i = 1, 5 do
		local angle = math.pi * 1.25 + (i - 1) * 0.3
		local base = CFrame.new(CENTER + Vector3.new(math.cos(angle) * 300, GROUND_TOP, math.sin(angle) * 300))
		local height = random:NextNumber(90, 140)
		prop(folder, "MistyMountain", base, Vector3.new(height * 1.8, height, height * 1.8), false)
	end

	-- Pétalas de cerejeira caindo sobre a vila
	local sky = block(folder, "Petals", Vector3.new(300, 1, 300), CFrame.new(CENTER + Vector3.new(0, 70, 0)), Color3.new(1, 1, 1))
	sky.Transparency = 1
	sky.CanCollide = false
	sky.CanQuery = false
	local petals = Instance.new("ParticleEmitter")
	petals.Shape = Enum.ParticleEmitterShape.Box
	petals.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	petals.EmissionDirection = Enum.NormalId.Bottom
	petals.Rate = 50
	petals.Lifetime = NumberRange.new(12, 16)
	petals.Speed = NumberRange.new(3, 6)
	petals.SpreadAngle = Vector2.new(30, 30)
	petals.Rotation = NumberRange.new(0, 360)
	petals.RotSpeed = NumberRange.new(-120, 120)
	petals.Size = NumberSequence.new(0.4)
	petals.LightInfluence = 0
	petals.Color = ColorSequence.new(C.petal, Color3.fromRGB(255, 225, 235))
	petals.Parent = sky
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
	buildTemple(folder)
	local pad = buildPad(folder)
	buildDecor(folder)
	return pad
end

return LobbyBuilder
