--!strict
-- Visual do personagem: modelo 3D em ReplicatedStorage.Assets.Characters.<id> quando existir,
-- senão a receita de peças (Config/Props). Inclina na troca de pista, achata (ou deita) ao deslizar,
-- quica ao correr, abre planador ao planar, mostra escudo, solta poeira ao pousar e,
-- a partir de Épico, brilha com a aura da raridade. Também serve para os fantasmas dos rivais.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Heroes = require(Shared.Config.Heroes)
local Props = require(Shared.Config.Props)
local Rarities = require(Shared.Config.Rarities)
local PropAssembler = require(Shared.PropAssembler)

local TrackSpace = require(script.Parent.TrackSpace)
local Visuals = require(script.Parent.Visuals)

local Size = GameConfig.Runner
local SHIELD = 7
local RUN_BOB = 0.25
local AURA_FROM_RANK = 3 -- Épico em diante
local SLIDE_TILT = math.rad(70) -- modelo 3D deita para trás ao deslizar

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
	parts: { BasePart },
	umbrella: Part,
	shield: Part,
	dust: ParticleEmitter,
	anchor: Part,
	aura: Part?,
	baseTransparency: { number },
	ghost: boolean,
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

-- Clona o modelo, deixa as peças só visuais e ajusta a escala para a altura do corredor
local function prepareAsset(source: Model, parent: Instance): (Model, { BasePart })
	local clone = source:Clone()
	local parts: { BasePart } = {}
	for _, descendant in clone:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanQuery = false
			descendant.CanTouch = false
			descendant.CastShadow = false
			table.insert(parts, descendant)
		elseif descendant:IsA("Script") or descendant:IsA("LocalScript") then
			descendant:Destroy() -- modelo é só visual
		end
	end
	local _, extents = clone:GetBoundingBox()
	if extents.Y > 0 then
		clone:ScaleTo(clone:GetScale() * Size.Height / extents.Y)
	end
	clone.Parent = parent
	return clone, parts
end

function RunnerView.new(parent: Instance, heroId: string, ghostName: string?): RunnerView
	local hero = Heroes.ById[heroId] or Heroes.ById[Heroes.Order[1]]
	local model = Instance.new("Model")
	model.Name = if ghostName then `Ghost_{ghostName}` else "Runner"

	local source = findAsset(hero.id)
	local recipe: PropAssembler.Recipe? = nil
	local asset: Model? = nil
	local parts: { BasePart }
	if source then
		asset, parts = prepareAsset(source, model)
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

	-- Aura da raridade (Épico, Lendário, Secreto): brilho subindo do corpo
	local rarity = Rarities.ById[hero.rarity]
	local aura: Part? = nil
	if rarity and rarity.rank >= AURA_FROM_RANK then
		local holder = Visuals.piece(model, "Aura", Vector3.new(Size.Width, Size.Height, Size.Depth), Color3.new())
		holder.Transparency = 1
		local glow = Instance.new("ParticleEmitter")
		glow.Shape = Enum.ParticleEmitterShape.Box
		glow.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
		glow.EmissionDirection = Enum.NormalId.Top
		glow.Rate = 8 * rarity.rank
		glow.Lifetime = NumberRange.new(0.4, 0.7)
		glow.Speed = NumberRange.new(3, 6)
		glow.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0) })
		glow.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1) })
		glow.Color = ColorSequence.new(rarity.glow, hero.color)
		glow.LightEmission = 1
		glow.LightInfluence = 0
		glow.Parent = holder
		aura = holder
	end

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
		parts = parts,
		umbrella = umbrella,
		shield = shield,
		dust = dust,
		anchor = anchor,
		aura = aura,
		baseTransparency = baseTransparency,
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
		-- Deslizar achata o herói dentro da caixa mais baixa
		PropAssembler.place(self.parts, recipe, base, Vector3.new(Size.Width, height, Size.Depth))
	elseif asset then
		-- Modelo 3D: deita para trás ao deslizar
		local sliding = height < Size.Height
		local feet = TrackSpace.cframe(pose.x, pose.y + bob, pose.distance) * lean
		local pose3d = if sliding
			then feet * CFrame.new(0, height / 2, 0) * CFrame.Angles(SLIDE_TILT, 0, 0)
			else feet * CFrame.new(0, Size.Height / 2, 0)
		asset:PivotTo(pose3d)
	end
	if self.aura then
		self.aura.CFrame = base
	end
	self.anchor.CFrame = TrackSpace.cframe(pose.x, pose.y, pose.distance)
	self.shield.CFrame = base
	self.shield.Transparency = if shieldActive then 0.3 else 1

	if pose.gliding then
		self.umbrella.Transparency = 0
		self.umbrella.CFrame = base * CFrame.new(0, height / 2 + 2.5, 0) * CFrame.Angles(0, 0, math.pi / 2)
	elseif self.umbrella.Transparency < 1 then
		self.umbrella.Transparency = 1
	end

	-- Pisca durante a invulnerabilidade depois de um tropeço
	local blink = blinking and (os.clock() * 10) % 2 < 1
	for i, part in self.parts do
		part.Transparency = if blink then math.max(0.6, self.baseTransparency[i]) else self.baseTransparency[i]
	end
end

function RunnerView.landDust(self: RunnerView)
	self.dust:Emit(GameConfig.Visuals.LandParticles)
end

function RunnerView.destroy(self: RunnerView)
	self.model:Destroy()
end

return RunnerView
