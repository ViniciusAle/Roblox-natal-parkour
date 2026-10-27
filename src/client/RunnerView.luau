--!strict
-- Visual do herói montado pela receita dele (Config/Props): inclina na troca de pista, achata ao deslizar,
-- quica ao correr, abre guarda-chuva ao planar, mostra bolha de escudo e solta poeira ao pousar.
-- Também serve para os fantasmas dos rivais (translúcidos, com nome).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Heroes = require(Shared.Config.Heroes)
local Props = require(Shared.Config.Props)
local PropAssembler = require(Shared.PropAssembler)

local TrackSpace = require(script.Parent.TrackSpace)
local Visuals = require(script.Parent.Visuals)

local Size = GameConfig.Runner
local SHIELD = 7
local RUN_BOB = 0.25

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
	recipe: PropAssembler.Recipe,
	parts: { BasePart },
	umbrella: Part,
	shield: Part,
	dust: ParticleEmitter,
	anchor: Part,
	baseTransparency: { number },
	ghost: boolean,
}

local RunnerView = {}
RunnerView.__index = RunnerView

export type RunnerView = typeof(setmetatable({} :: ViewData, RunnerView))

function RunnerView.new(parent: Instance, heroId: string, ghostName: string?): RunnerView
	local hero = Heroes.ById[heroId] or Heroes.ById.Elf
	local recipe = Props[hero.recipe]
	local model, parts = PropAssembler.create(recipe, nil, false)
	model.Name = if ghostName then `Ghost_{ghostName}` else "Runner"

	local ghost = ghostName ~= nil
	local baseTransparency: { number } = {}
	for i, part in parts do
		local spec = recipe.parts[i]
		local transparency = spec.transparency or 0
		if ghost then
			transparency = math.max(transparency, GameConfig.Visuals.GhostTransparency)
		end
		part.Transparency = transparency
		baseTransparency[i] = transparency
	end

	local umbrella = Visuals.piece(model, "Umbrella", Vector3.new(0.4, 6, 6), Color3.fromRGB(240, 70, 90), Enum.PartType.Cylinder)
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
		label.Font = Enum.Font.FredokaOne
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
		parts = parts,
		umbrella = umbrella,
		shield = shield,
		dust = dust,
		anchor = anchor,
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

	-- Deslizar achata o herói dentro da caixa mais baixa
	PropAssembler.place(self.parts, self.recipe, base, Vector3.new(Size.Width, height, Size.Depth))
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
