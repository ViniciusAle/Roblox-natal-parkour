--!strict
-- Visual do personagem: modelo 3D em ReplicatedStorage.Assets.Characters.<id> quando existir
-- (importado da loja pelo tools/ImportModels.lua, campo model em Config/Heroes),
-- senão a criatura brainrot de peças (Config/Props). Inclina na troca de pista, achata (ou deita) ao deslizar,
-- quica e rebola ao correr, balança as pernas, abre planador ao planar, mostra escudo, solta poeira ao pousar,
-- deixa um rastro de energia, brilha com a aura da raridade a partir de Épico e entra no modo brainrot
-- (aura forte, luz e contorno) com a energia cheia. Também serve para os fantasmas dos rivais.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Heroes = require(Shared.Config.Heroes)
local Props = require(Shared.Config.Props)
local Rarities = require(Shared.Config.Rarities)
local PropAssembler = require(Shared.PropAssembler)
local ModelLibrary = require(Shared.ModelLibrary)

local TrackSpace = require(script.Parent.TrackSpace)
local Visuals = require(script.Parent.Visuals)

local Size = GameConfig.Runner
local Animations = GameConfig.Animations
local SHIELD = 7
local RUN_BOB = 0.25
local WADDLE = math.rad(7) -- criatura de peças rebola de um lado para o outro
local STEP_REACH = 0.45 -- perna (swing) vai para a frente e para trás, em studs
local STEP_LIFT = 0.25
local AURA_FROM_RANK = 3 -- Épico em diante
local SLIDE_TILT = math.rad(70) -- modelo 3D em pé deita para trás ao deslizar
local LONG_RATIO = 1.2 -- comprimento/altura acima disso = modelo deitado
local MAX_LENGTH = 7 -- comprimento máximo do modelo deitado, em studs
-- Visual da transformação e do rastro
local TRANSFORM = {
	auraRate = 90,
	lightRange = 14,
	lightBrightness = 2,
	fillTransparency = 0.7,
	trailLifetime = 0.15,
	trailTransparency = 0.4,
}

export type Pose = {
	x: number,
	y: number,
	distance: number,
	height: number,
	targetX: number,
	grounded: boolean,
	gliding: boolean,
	time: number,
}

type ViewData = {
	model: Model,
	recipe: PropAssembler.Recipe?, -- nil quando usa modelo 3D
	asset: Model?,
	pivotFromFeet: CFrame, -- onde fica o pivô do modelo 3D em relação aos pés (na escala normal)
	long: boolean, -- modelo deitado: encolhe ao deslizar em vez de deitar para trás
	baseScale: number,
	squash: number, -- fator de escala atual do modelo deitado (1 = normal)
	animator: Animator?,
	tracks: { [string]: AnimationTrack },
	playing: string?,
	parts: { BasePart },
	umbrella: Part,
	shield: Part,
	dust: ParticleEmitter,
	anchor: Part,
	aura: Part,
	glow: ParticleEmitter,
	auraRate: number,
	auraLight: PointLight,
	trail: Trail,
	highlight: Highlight,
	baseTransparency: { number },
	blinkOn: boolean,
	ghost: boolean,
}

type AssetBody = {
	model: Model,
	parts: { BasePart },
	pivotFromFeet: CFrame,
	animator: Animator?,
	long: boolean,
	baseScale: number,
}

local RunnerView = {}
RunnerView.__index = RunnerView

export type RunnerView = typeof(setmetatable({} :: ViewData, RunnerView))

-- Modelo 3D do personagem, se alguém colocou um em ReplicatedStorage.Assets.Characters
local function findAsset(heroId: string): Model?
	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local characters = assets and assets:FindFirstChild("Characters")
	local found = characters and characters:FindFirstChild(heroId)
	if found and found:IsA("Model") then
		return found
	end
	return nil
end

-- Clona o modelo, deixa as peças só visuais e ajusta a escala para a altura do corredor.
-- Corpo com Humanoid (R15): só a raiz fica ancorada, para as juntas poderem animar.
-- A frente do modelo é para onde a raiz (ou a PrimaryPart) olha, mais a correção rot de Config/Heroes.
-- Modelo deitado (mais comprido que alto, ex.: tubarão, avião) também é limitado no comprimento.
local function prepareAsset(source: Model, parent: Instance, rot: Vector3?): AssetBody
	local clone = source:Clone()
	local humanoid = clone:FindFirstChildOfClass("Humanoid")
	local root = clone:FindFirstChild("HumanoidRootPart")
	local fix = rot or Vector3.zero
	local heading: CFrame
	if humanoid and root and root:IsA("BasePart") then
		local look = root.CFrame.LookVector
		heading = CFrame.lookAt(Vector3.zero, Vector3.new(look.X, 0, look.Z).Unit)
			* CFrame.Angles(math.rad(fix.X), math.rad(fix.Y), math.rad(fix.Z))
	else
		-- Modelo de peças soltas da loja: pivô em pé, virado para a frente da PrimaryPart
		ModelLibrary.stand(clone, fix)
		heading = clone:GetPivot().Rotation
	end
	local parts: { BasePart } = {}
	for _, descendant in clone:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.Anchored = humanoid == nil or descendant == root
			descendant.Massless = true
			descendant.CanCollide = false
			descendant.CanQuery = false
			descendant.CanTouch = false
			descendant.CastShadow = false
			table.insert(parts, descendant)
		elseif descendant:IsA("Script") or descendant:IsA("LocalScript") then
			descendant:Destroy() -- modelo é só visual
		end
	end
	local animator: Animator? = nil
	if humanoid then
		humanoid.EvaluateStateMachine = false -- quem move é o script da corrida
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		local existing = humanoid:FindFirstChildOfClass("Animator")
		animator = existing or Instance.new("Animator")
		if not existing then
			(animator :: Animator).Parent = humanoid
		end
	end

	-- Mede pelo corpo, não pela caixa do modelo: cabelos e acessórios longos distorciam a escala e o centro
	local function measure(): (Vector3, number, number)
		local head = clone:FindFirstChild("Head")
		if humanoid and root and root:IsA("BasePart") and head and head:IsA("BasePart") then
			local feet = root.CFrame * CFrame.new(0, -root.Size.Y / 2 - humanoid.HipHeight, 0)
			local top = head.Position.Y + head.Size.Y / 2
			return feet.Position, top - feet.Position.Y, 0
		end
		local box, size = clone:GetBoundingBox()
		return (box * CFrame.new(0, -size.Y / 2, 0)).Position, size.Y, size.Z
	end
	local _, height, length = measure()
	local long = length > height * LONG_RATIO
	if height > 0 then
		local factor = Size.Height / height
		if long then
			factor = math.min(factor, MAX_LENGTH / length)
		end
		clone:ScaleTo(clone:GetScale() * factor)
	end
	local feet = measure()
	if not humanoid then
		ModelLibrary.weldToRoot(clone) -- mover o personagem vira mover uma peça só
	end
	clone.Parent = parent
	return {
		model = clone,
		parts = parts,
		pivotFromFeet = (CFrame.new(feet) * heading):ToObjectSpace(clone:GetPivot()),
		animator = animator,
		long = long,
		baseScale = clone:GetScale(),
	}
end

function RunnerView.new(parent: Instance, heroId: string, ghostName: string?): RunnerView
	local hero = Heroes.ById[heroId] or Heroes.ById[Heroes.Order[1]]
	local model = Instance.new("Model")
	model.Name = if ghostName then `Ghost_{ghostName}` else "Runner"

	local source = findAsset(hero.id)
	local recipe: PropAssembler.Recipe? = nil
	local asset: Model? = nil
	local pivotFromFeet = CFrame.identity
	local animator: Animator? = nil
	local long = false
	local baseScale = 1
	local parts: { BasePart }
	if source then
		local body = prepareAsset(source, model, hero.model and hero.model.rot)
		asset, parts, pivotFromFeet, animator = body.model, body.parts, body.pivotFromFeet, body.animator
		long, baseScale = body.long, body.baseScale
	else
		local built = Props[hero.recipe]
		local recipeModel, recipeParts = PropAssembler.create(built, model, false)
		recipeModel.Name = "Body"
		recipe = built
		parts = recipeParts
	end

	local ghost = ghostName ~= nil
	local baseTransparency: { number } = {}
	for i, part in parts do
		local transparency = part.Transparency
		if ghost then
			transparency = math.max(transparency, GameConfig.Visuals.GhostTransparency)
		end
		part.Transparency = transparency
		baseTransparency[i] = transparency
	end

	local umbrella = Visuals.piece(model, "Glider", Vector3.new(0.4, 6, 6), hero.color, Enum.PartType.Cylinder)
	umbrella.Transparency = 1
	local shield = Visuals.piece(model, "Shield", Vector3.new(SHIELD, SHIELD, SHIELD), Color3.fromRGB(120, 210, 255), Enum.PartType.Ball)
	shield.Material = Enum.Material.ForceField
	shield.Transparency = 1

	-- Peça invisível que segura a poeira e o nome
	local anchor = Visuals.piece(model, "Anchor", Vector3.new(1, 1, 1), Color3.new())
	anchor.Transparency = 1
	local attachment = Instance.new("Attachment")
	attachment.Parent = anchor
	local dust = Instance.new("ParticleEmitter")
	dust.Rate = 0
	dust.Lifetime = NumberRange.new(0.3, 0.5)
	dust.Speed = NumberRange.new(6, 10)
	dust.SpreadAngle = Vector2.new(80, 20)
	dust.Size = NumberSequence.new(0.8, 0)
	dust.Color = ColorSequence.new(Color3.new(1, 1, 1))
	dust.LightInfluence = 0
	dust.Parent = attachment

	-- Aura: sempre ligada a partir de Épico; em qualquer raridade, explode durante a transformação
	local rarity = Rarities.ById[hero.rarity]
	local glowColor = if rarity then rarity.glow else hero.color
	local aura = Visuals.piece(model, "Aura", Vector3.new(Size.Width, Size.Height, Size.Depth), Color3.new())
	aura.Transparency = 1
	local auraRate = if rarity and rarity.rank >= AURA_FROM_RANK then 8 * rarity.rank else 0
	local glow = Instance.new("ParticleEmitter")
	glow.Shape = Enum.ParticleEmitterShape.Box
	glow.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	glow.EmissionDirection = Enum.NormalId.Top
	glow.Rate = auraRate
	glow.Lifetime = NumberRange.new(0.4, 0.7)
	glow.Speed = NumberRange.new(3, 6)
	glow.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0) })
	glow.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1) })
	glow.Color = ColorSequence.new(glowColor, hero.color)
	glow.LightEmission = 1
	glow.LightInfluence = 0
	glow.Parent = aura
	local auraLight = Instance.new("PointLight")
	auraLight.Color = hero.color
	auraLight.Range = TRANSFORM.lightRange
	auraLight.Brightness = TRANSFORM.lightBrightness
	auraLight.Enabled = false
	auraLight.Parent = aura

	-- Rastro de energia na cor do personagem
	local top = Instance.new("Attachment")
	top.Position = Vector3.new(0, Size.Height * 0.25, 0)
	top.Parent = aura
	local bottom = Instance.new("Attachment")
	bottom.Position = Vector3.new(0, -Size.Height * 0.25, 0)
	bottom.Parent = aura
	local trail = Instance.new("Trail")
	trail.Attachment0 = top
	trail.Attachment1 = bottom
	trail.Color = ColorSequence.new(glowColor, hero.color)
	trail.Transparency = NumberSequence.new(TRANSFORM.trailTransparency, 1)
	trail.Lifetime = TRANSFORM.trailLifetime
	trail.LightEmission = 1
	trail.FaceCamera = true
	trail.Parent = aura

	-- Contorno brilhante durante a transformação
	local highlight = Instance.new("Highlight")
	highlight.FillColor = hero.color
	highlight.FillTransparency = 1
	highlight.OutlineColor = glowColor
	highlight.OutlineTransparency = 1
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
	highlight.Parent = model

	if ghostName then
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.fromOffset(160, 36)
		billboard.StudsOffset = Vector3.new(0, Size.Height + 2.5, 0)
		billboard.AlwaysOnTop = true
		billboard.MaxDistance = 220
		billboard.Parent = anchor
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.FontFace = Font.new("rbxasset://fonts/families/LuckiestGuy.json")
		label.TextScaled = true
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextStrokeTransparency = 0.2
		label.Text = ghostName
		label.Parent = billboard
	end

	model.Parent = parent

	local self: ViewData = {
		model = model,
		recipe = recipe,
		asset = asset,
		pivotFromFeet = pivotFromFeet,
		long = long,
		baseScale = baseScale,
		squash = 1,
		animator = animator,
		tracks = {},
		playing = nil,
		parts = parts,
		umbrella = umbrella,
		shield = shield,
		dust = dust,
		anchor = anchor,
		aura = aura,
		glow = glow,
		auraRate = auraRate,
		auraLight = auraLight,
		trail = trail,
		highlight = highlight,
		baseTransparency = baseTransparency,
		blinkOn = false,
		ghost = ghost,
	}
	return setmetatable(self, RunnerView)
end

function RunnerView.update(self: RunnerView, pose: Pose, shieldActive: boolean, blinking: boolean)
	local height = pose.height
	local laneDelta = (pose.targetX - pose.x) / GameConfig.Track.LaneWidth
	local lean = CFrame.Angles(0, 0, -laneDelta * GameConfig.Visuals.LeanAngle)
	local bob = if pose.grounded then math.abs(math.sin(pose.time * 14)) * RUN_BOB else 0
	local base = TrackSpace.cframe(pose.x, pose.y + height / 2 + bob, pose.distance) * lean

	local recipe = self.recipe
	local asset = self.asset
	if recipe then
		-- Deslizar achata a criatura dentro da caixa mais baixa; no chão ela rebola e balança as pernas
		local box = if pose.grounded then base * CFrame.Angles(0, 0, math.sin(pose.time * 7) * WADDLE) else base
		PropAssembler.place(self.parts, recipe, box, Vector3.new(Size.Width, height, Size.Depth))
		if pose.grounded then
			local step = math.sin(pose.time * 14)
			for i, spec in recipe.parts do
				local swing = spec.swing
				if swing then
					local s = step * swing
					local part = self.parts[i]
					part.CFrame += box:VectorToWorldSpace(Vector3.new(0, math.max(s, 0) * STEP_LIFT, -s * STEP_REACH))
				end
			end
		end
	elseif asset then
		-- Modelo 3D: anima corrida/pulo e deita para trás ao deslizar; modelo sem esqueleto quica e rebola
		local sliding = height < Size.Height
		local feet = TrackSpace.cframe(pose.x, pose.y, pose.distance) * lean
		if sliding and not self.long then
			feet = feet * CFrame.new(0, height / 2, 0) * CFrame.Angles(SLIDE_TILT, 0, 0) * CFrame.new(0, -height / 2, 0)
		elseif not self.animator and pose.grounded then
			feet = feet * CFrame.new(0, bob, 0) * CFrame.Angles(0, 0, math.sin(pose.time * 7) * WADDLE)
		end
		-- Modelo deitado encolhe ao deslizar (só reescala quando entra ou sai do deslize)
		local squash = if sliding and self.long then Size.SlideHeight / Size.Height else 1
		if squash ~= self.squash then
			asset:ScaleTo(self.baseScale * squash)
			self.squash = squash
		end
		local offset = self.pivotFromFeet
		asset:PivotTo(feet * CFrame.new(offset.Position * squash) * offset.Rotation)
		self:_animate(if pose.grounded then "Run" elseif pose.y > 0.05 then (if pose.gliding then "Fall" else "Jump") else "Idle")
	end
	self.aura.CFrame = base
	self.anchor.CFrame = TrackSpace.cframe(pose.x, pose.y, pose.distance)
	self.shield.CFrame = base
	self.shield.Transparency = if shieldActive then 0.3 else 1

	if pose.gliding then
		self.umbrella.Transparency = 0
		self.umbrella.CFrame = base * CFrame.new(0, height / 2 + 2.5, 0) * CFrame.Angles(0, 0, math.pi / 2)
	elseif self.umbrella.Transparency < 1 then
		self.umbrella.Transparency = 1
	end

	-- Pisca durante a invulnerabilidade depois de um tropeço (só mexe nas peças quando o estado muda)
	local blink = blinking and (os.clock() * 10) % 2 < 1
	if blink == self.blinkOn then
		return
	end
	self.blinkOn = blink
	for i, part in self.parts do
		part.Transparency = if blink then math.max(0.6, self.baseTransparency[i]) else self.baseTransparency[i]
	end
end

-- Troca a animação do corpo R15 (carrega cada uma na primeira vez)
function RunnerView._animate(self: RunnerView, name: string)
	local animator = self.animator
	if not animator or self.playing == name then
		return
	end
	local track = self.tracks[name]
	if not track then
		local animation = Instance.new("Animation")
		animation.AnimationId = (Animations :: any)[name]
		local ok, loaded = pcall(function()
			return animator:LoadAnimation(animation)
		end)
		if not ok then
			return
		end
		track = loaded
		track.Looped = name ~= "Jump"
		self.tracks[name] = track
	end
	local current = self.playing and self.tracks[self.playing]
	if current then
		current:Stop(0.15)
	end
	track:Play(0.15)
	if name == "Run" then
		track:AdjustSpeed(Animations.RunSpeed)
	end
	self.playing = name
end

-- Modo brainrot: aura forte, luz, contorno brilhante e rastro mais longo
function RunnerView.setTransformed(self: RunnerView, on: boolean)
	self.glow.Rate = if on then TRANSFORM.auraRate else self.auraRate
	self.glow.Speed = if on then NumberRange.new(8, 14) else NumberRange.new(3, 6)
	self.auraLight.Enabled = on
	self.highlight.FillTransparency = if on then TRANSFORM.fillTransparency else 1
	self.highlight.OutlineTransparency = if on then 0 else 1
	self.trail.Lifetime = if on then TRANSFORM.trailLifetime * 3 else TRANSFORM.trailLifetime
end

function RunnerView.landDust(self: RunnerView)
	self.dust:Emit(GameConfig.Visuals.LandParticles)
end

function RunnerView.destroy(self: RunnerView)
	self.model:Destroy()
end

return RunnerView
