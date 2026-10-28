--!strict
-- Efeitos que acompanham a câmera: pétalas, maresia ou esporos (por fase), aurora opcional
-- e linhas de vento que aparecem com a velocidade. Leves, pensando no celular.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Themes = require(Shared.Config.Themes)

local Fx = GameConfig.Fx
local Speed = GameConfig.Speed

local AURORA_COLORS = {
	Color3.fromRGB(80, 255, 170),
	Color3.fromRGB(60, 210, 255),
	Color3.fromRGB(150, 110, 255),
	Color3.fromRGB(90, 255, 200),
}

type FxData = {
	folder: Folder,
	emitterPart: Part,
	emitter: ParticleEmitter,
	windPart: Part,
	wind: ParticleEmitter,
	aurora: { Part },
	auroraOn: boolean,
}

local AmbientFx = {}
AmbientFx.__index = AmbientFx

export type AmbientFx = typeof(setmetatable({} :: FxData, AmbientFx))

local function holder(parent: Instance, name: string, size: Vector3): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Transparency = 1
	part.Size = size
	part.Parent = parent
	return part
end

function AmbientFx.new(parent: Instance): AmbientFx
	local folder = Instance.new("Folder")
	folder.Name = "AmbientFx"
	folder.Parent = parent

	-- Neve / confete: cai de uma área acima e à frente da câmera
	local emitterPart = holder(folder, "Weather", Fx.ParticleArea)
	local emitter = Instance.new("ParticleEmitter")
	emitter.Shape = Enum.ParticleEmitterShape.Box
	emitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	emitter.EmissionDirection = Enum.NormalId.Bottom
	emitter.Lifetime = NumberRange.new(5, 8)
	emitter.LightInfluence = 0
	emitter.RotSpeed = NumberRange.new(-90, 90)
	emitter.Rotation = NumberRange.new(0, 360)
	emitter.SpreadAngle = Vector2.new(15, 15)
	emitter.Parent = emitterPart

	-- Linhas de vento: partículas esticadas vindo na direção da câmera
	local windPart = holder(folder, "Wind", Vector3.new(30, 14, 1))
	local wind = Instance.new("ParticleEmitter")
	wind.Shape = Enum.ParticleEmitterShape.Box
	wind.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	wind.EmissionDirection = Enum.NormalId.Front -- a frente da peça aponta para a câmera
	wind.Speed = NumberRange.new(90, 120)
	wind.Lifetime = NumberRange.new(0.25, 0.4)
	wind.Size = NumberSequence.new(0.08)
	wind.Squash = NumberSequence.new(-3)
	wind.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.3, 0.5),
		NumberSequenceKeypoint.new(1, 1),
	})
	wind.LightInfluence = 0
	wind.Rate = 0
	wind.Parent = windPart

	-- Aurora: faixas neon translúcidas no céu, longe à frente
	local aurora: { Part } = {}
	for i = 1, Fx.AuroraBands do
		local band = holder(folder, `Aurora{i}`, Vector3.new(520, 70, 1))
		band.Material = Enum.Material.Neon
		band.Color = AURORA_COLORS[(i - 1) % #AURORA_COLORS + 1]
		band.Transparency = 1
		table.insert(aurora, band)
	end

	local self: FxData = {
		folder = folder,
		emitterPart = emitterPart,
		emitter = emitter,
		windPart = windPart,
		wind = wind,
		aurora = aurora,
		auroraOn = false,
	}
	return setmetatable(self, AmbientFx)
end

function AmbientFx.setChapter(self: AmbientFx, chapterId: string)
	local theme = Themes[chapterId]
	if not theme then
		return
	end
	local particles = theme.particles
	local keypoints = {}
	local colors = particles.colors
	for i, color in colors do
		local t = if #colors > 1 then (i - 1) / (#colors - 1) else 0
		table.insert(keypoints, ColorSequenceKeypoint.new(t, color))
	end
	if #keypoints == 1 then
		table.insert(keypoints, ColorSequenceKeypoint.new(1, colors[1]))
	end
	self.emitter.Color = ColorSequence.new(keypoints)
	self.emitter.Rate = particles.rate
	self.emitter.Size = NumberSequence.new(particles.size)
	self.emitter.Speed = NumberRange.new(particles.speed * 0.7, particles.speed * 1.3)
	self.auroraOn = theme.aurora
	if not theme.aurora then
		for _, band in self.aurora do
			band.Transparency = 1
		end
	end
end

-- cameraCFrame: posição da câmera; speed: velocidade atual do herói
function AmbientFx.update(self: AmbientFx, cameraCFrame: CFrame, speed: number, time: number)
	local position = cameraCFrame.Position
	local flatForward = Vector3.new(0, 0, -1)
	self.emitterPart.CFrame = CFrame.new(position + flatForward * Fx.ParticleAhead + Vector3.new(0, Fx.ParticleHeight, 0))

	-- Linhas de vento à frente da câmera, com intensidade pela velocidade
	self.windPart.CFrame = CFrame.lookAt(position + cameraCFrame.LookVector * 40, position)
	local alpha = math.clamp((speed - Fx.SpeedLinesFromSpeed) / (Speed.Max - Fx.SpeedLinesFromSpeed), 0, 1)
	self.wind.Rate = alpha * Fx.SpeedLinesMaxRate

	if self.auroraOn then
		for i, band in self.aurora do
			local wave = math.sin(time * 0.4 + i * 1.7)
			local offset = Vector3.new(wave * 60 + (i - 2.5) * 90, Fx.AuroraHeight + i * 18, 0)
			band.CFrame = CFrame.new(position + flatForward * Fx.AuroraDistance + offset)
				* CFrame.Angles(0, math.rad(wave * 12), math.rad(wave * 6))
			band.Transparency = 0.72 + 0.12 * math.sin(time * 0.8 + i)
		end
	end
end

function AmbientFx.destroy(self: AmbientFx)
	self.folder:Destroy()
end

return AmbientFx
