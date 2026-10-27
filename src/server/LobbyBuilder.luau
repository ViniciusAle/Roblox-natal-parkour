--!strict
-- Monta a vila do lobby: praça nevada ao entardecer, livro gigante (a "porta" da corrida),
-- círculo dourado da fila, árvore de Natal, casas de pão de mel, postes com cordões de luz e neve.
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

local BULB_COLORS = {
	Color3.fromRGB(255, 70, 80),
	Color3.fromRGB(90, 230, 120),
	Color3.fromRGB(255, 205, 70),
	Color3.fromRGB(90, 220, 255),
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

local function prop(parent: Instance, recipeName: string, base: CFrame, size: Vector3, collide: boolean): Model
	-- base fica no chão; a caixa da receita é centrada
	return PropAssembler.build(Props[recipeName], parent, base * CFrame.new(0, size.Y / 2, 0), size, collide)
end

local function surfaceText(part: BasePart, text: string, color: Color3)
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Back
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 40
	gui.LightInfluence = 0
	gui.Parent = part
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(0.86, 0.6)
	label.Position = UDim2.fromScale(0.07, 0.12)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.FredokaOne
	label.TextScaled = true
	label.TextWrapped = true
	label.TextColor3 = color
	label.Text = text
	label.Parent = gui
end

local function buildLighting()
	Lighting.ClockTime = 18.1
	Lighting.Brightness = 1.8
	Lighting.Ambient = Color3.fromRGB(110, 90, 120)
	Lighting.OutdoorAmbient = Color3.fromRGB(150, 125, 165)
	Lighting.FogColor = Color3.fromRGB(70, 55, 100)
	Lighting.FogEnd = 900

	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
	atmosphere.Density = 0.3
	atmosphere.Offset = 0.1
	atmosphere.Color = Color3.fromRGB(215, 175, 215)
	atmosphere.Decay = Color3.fromRGB(120, 90, 160)
	atmosphere.Glare = 0.3
	atmosphere.Haze = 1.6
	atmosphere.Parent = Lighting

	local bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect")
	bloom.Intensity = 0.7
	bloom.Size = 26
	bloom.Threshold = 1.4
	bloom.Parent = Lighting

	local grading = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect")
	grading.TintColor = Color3.fromRGB(255, 240, 235)
	grading.Saturation = 0.12
	grading.Contrast = 0.05
	grading.Parent = Lighting
end

local function buildGround(folder: Folder)
	block(
		folder,
		"Snow",
		Vector3.new(Lobby.GroundSize, 2, Lobby.GroundSize),
		CFrame.new(CENTER + Vector3.new(0, GROUND_TOP - 1, 0)),
		Color3.fromRGB(245, 248, 255),
		Enum.Material.Snow
	)
	disc(folder, "Plaza", Lobby.PlazaRadius, 0.4, CENTER + Vector3.new(0, GROUND_TOP, 0), Color3.fromRGB(200, 170, 150), Enum.Material.Cobblestone)
	disc(folder, "PlazaRing", Lobby.PlazaRadius - 6, 0.44, CENTER + Vector3.new(0, GROUND_TOP, 0), Color3.fromRGB(170, 120, 100), Enum.Material.Brick)
	disc(folder, "PlazaInner", Lobby.PlazaRadius - 8, 0.48, CENTER + Vector3.new(0, GROUND_TOP, 0), Color3.fromRGB(215, 190, 170), Enum.Material.Cobblestone)
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
	spawn.CFrame = CFrame.new(CENTER + Lobby.SpawnOffset - Vector3.new(0, 2.6, 0)) -- olhando para o livro (-Z)
	spawn.Color = Color3.fromRGB(214, 40, 52)
	spawn.Material = Enum.Material.SmoothPlastic
	spawn.Neutral = true
	spawn.Duration = 0
	spawn.TopSurface = Enum.SurfaceType.Smooth
	spawn.Parent = folder
end

local function buildBook(folder: Folder)
	local hinge = CFrame.new(CENTER + Lobby.BookOffset + Vector3.new(0, GROUND_TOP, 0))
	local cream = Color3.fromRGB(252, 244, 222)
	local coverColor = Color3.fromRGB(176, 30, 45)
	local gold = Color3.fromRGB(250, 196, 50)

	block(folder, "BookStand", Vector3.new(40, 1.2, 12), hinge * CFrame.new(0, 0.6, -1), Color3.fromRGB(90, 52, 32), Enum.Material.WoodPlanks)
	block(folder, "BookSpine", Vector3.new(2.4, 23, 2.4), hinge * CFrame.new(0, 12.6, -1.4), gold)

	for _, side in { -1, 1 } do
		local open = hinge * CFrame.Angles(0, math.rad(-side * 24), 0)
		block(folder, "Cover", Vector3.new(17.5, 23, 0.7), open * CFrame.new(side * 9, 12.6, -1.3), coverColor)
		local page = block(folder, "Page", Vector3.new(16, 21, 1.6), open * CFrame.new(side * 8.4, 12.6, -0.2), cream)
		block(folder, "PageGold", Vector3.new(16.2, 0.4, 1.7), open * CFrame.new(side * 8.4, 2.3, -0.2), gold)

		if side == -1 then
			surfaceText(page, Strings.Title, Color3.fromRGB(176, 30, 45))
		else
			surfaceText(page, Strings.BookHint, Color3.fromRGB(46, 110, 70))
		end
	end

	local sparkle = block(folder, "BookSparkle", Vector3.new(30, 1, 6), hinge * CFrame.new(0, 24, 0), gold)
	sparkle.Transparency = 1
	sparkle.CanCollide = false
	local emitter = Instance.new("ParticleEmitter")
	emitter.Rate = 12
	emitter.Lifetime = NumberRange.new(1.5, 2.5)
	emitter.Speed = NumberRange.new(1, 3)
	emitter.Size = NumberSequence.new(0.5, 0)
	emitter.Color = ColorSequence.new(gold)
	emitter.LightEmission = 1
	emitter.Shape = Enum.ParticleEmitterShape.Box
	emitter.Parent = sparkle
end

local function buildPad(folder: Folder): Pad
	local position = CENTER + Lobby.PadOffset + Vector3.new(0, GROUND_TOP, 0)
	local radius = Lobby.PadRadius
	local glow = disc(folder, "PadGlow", radius, 0.3, position + Vector3.new(0, 0.42, 0), Color3.fromRGB(255, 205, 70), Enum.Material.Neon)
	glow.CanCollide = false
	disc(folder, "PadInner", radius - 1.2, 0.4, position + Vector3.new(0, 0.45, 0), Color3.fromRGB(176, 30, 45))
	disc(folder, "PadStar", radius * 0.35, 0.44, position + Vector3.new(0, 0.48, 0), Color3.fromRGB(255, 225, 120), Enum.Material.Neon)

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
	status.Font = Enum.Font.FredokaOne
	status.TextScaled = true
	status.TextColor3 = Color3.fromRGB(255, 240, 200)
	status.TextStrokeTransparency = 0.1
	status.TextStrokeColor3 = Color3.fromRGB(120, 20, 30)
	status.Text = ""
	status.Parent = billboard

	return { position = position, radius = radius, status = status }
end

local function buildStringLights(folder: Folder, from: Vector3, to: Vector3, index: number)
	local bulbs = 9
	local sag = 2.2
	for i = 1, bulbs do
		local t = i / (bulbs + 1)
		local point = from:Lerp(to, t) - Vector3.new(0, math.sin(t * math.pi) * sag, 0)
		local bulb = block(folder, "Bulb", Vector3.new(0.6, 0.6, 0.6), CFrame.new(point), BULB_COLORS[(i + index) % #BULB_COLORS + 1], Enum.Material.Neon)
		bulb.Shape = Enum.PartType.Ball
		bulb.CanCollide = false
		bulb.CastShadow = false
	end
end

local function buildDecor(folder: Folder)
	local random = Random.new(1225)

	-- Árvore de Natal gigante com presentes
	local treeBase = CFrame.new(CENTER + Vector3.new(-34, GROUND_TOP, -24))
	prop(folder, "PineLights", treeBase, Vector3.new(24, 46, 24), true)
	for i = 1, 6 do
		local angle = i / 6 * math.pi * 2
		local base = treeBase * CFrame.new(math.cos(angle) * 10, 0, math.sin(angle) * 10) * CFrame.Angles(0, angle, 0)
		prop(folder, "GiftPair", base, Vector3.new(5, 2.4, 2.4), true)
	end

	-- Casas em volta da praça
	local houses = { "GingerHouse", "GingerHouse", "Igloo", "GingerHouse", "ToyTower" }
	for i, base in ring(Lobby.HouseCount, Lobby.HouseRing, 0.35) do
		local recipe = houses[(i - 1) % #houses + 1]
		local size = if recipe == "Igloo" then Vector3.new(18, 12, 18) elseif recipe == "ToyTower" then Vector3.new(14, 22, 14) else Vector3.new(20, 20, 18)
		prop(folder, recipe, base, size, true)
	end

	-- Bosque de pinheiros
	for _, base in ring(Lobby.TreeCount, Lobby.TreeRing, 0.1) do
		local height = random:NextNumber(16, 28)
		local jitter = CFrame.new(random:NextNumber(-8, 8), 0, random:NextNumber(-8, 8))
		prop(folder, "PineLights", base * jitter, Vector3.new(height * 0.5, height, height * 0.5), true)
	end

	-- Postes com cordões de luz entre eles
	local lamps = ring(Lobby.LampCount, Lobby.LampRing, 0.2)
	local lampSize = Vector3.new(2, 12, 2)
	for i, base in lamps do
		prop(folder, "StarLampLit", base, lampSize, true)
		local nextBase = lamps[i % #lamps + 1]
		local top = Vector3.new(0, lampSize.Y * 0.9, 0)
		buildStringLights(folder, base.Position + top, nextBase.Position + top, i)
	end

	-- Bengalas e pirulitos na borda da praça
	for i, base in ring(12, Lobby.PlazaRadius - 2, 0.05) do
		if i % 2 == 0 then
			prop(folder, "CandyCane", base, Vector3.new(2, 9, 2), true)
		else
			prop(folder, "Lollipop", base, Vector3.new(5, 9, 5), true)
		end
	end

	-- Neve caindo sobre a vila
	local sky = block(folder, "Snowfall", Vector3.new(300, 1, 300), CFrame.new(CENTER + Vector3.new(0, 70, 0)), Color3.new(1, 1, 1))
	sky.Transparency = 1
	sky.CanCollide = false
	sky.CanQuery = false
	local snow = Instance.new("ParticleEmitter")
	snow.Shape = Enum.ParticleEmitterShape.Box
	snow.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	snow.EmissionDirection = Enum.NormalId.Bottom
	snow.Rate = 70
	snow.Lifetime = NumberRange.new(10, 14)
	snow.Speed = NumberRange.new(4, 7)
	snow.SpreadAngle = Vector2.new(20, 20)
	snow.Size = NumberSequence.new(0.35)
	snow.LightInfluence = 0
	snow.Color = ColorSequence.new(Color3.new(1, 1, 1))
	snow.Parent = sky
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
	buildBook(folder)
	local pad = buildPad(folder)
	buildDecor(folder)
	return pad
end

return LobbyBuilder
