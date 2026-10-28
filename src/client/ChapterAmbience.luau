--!strict
-- Iluminação local por fase (só no cliente): céu, névoa, atmosfera, bloom e correção de cor.
-- Os efeitos do lobby são guardados ao entrar na corrida e devolvidos ao sair.

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Themes = require(ReplicatedStorage.Shared.Config.Themes)

local BLEND = TweenInfo.new(1.2, Enum.EasingStyle.Sine)
local FX_NAME = "BrainrotRushFx"

type Snapshot = {
	clockTime: number,
	brightness: number,
	ambient: Color3,
	outdoorAmbient: Color3,
	fogEnd: number,
	fogColor: Color3,
	hidden: { Instance },
}

type Effects = {
	atmosphere: Atmosphere,
	bloom: BloomEffect,
	grading: ColorCorrectionEffect,
}

local saved: Snapshot? = nil
local effects: Effects? = nil

local function isLookEffect(instance: Instance): boolean
	return instance:IsA("Atmosphere") or instance:IsA("PostEffect")
end

local function createEffects(): Effects
	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Name = FX_NAME
	atmosphere.Parent = Lighting
	local bloom = Instance.new("BloomEffect")
	bloom.Name = FX_NAME
	bloom.Parent = Lighting
	local grading = Instance.new("ColorCorrectionEffect")
	grading.Name = FX_NAME
	grading.Parent = Lighting
	return { atmosphere = atmosphere, bloom = bloom, grading = grading }
end

local ChapterAmbience = {}

function ChapterAmbience.apply(chapterId: string, instant: boolean?)
	local theme = Themes[chapterId]
	if not theme then
		return
	end

	if not saved then
		-- Guarda o visual do lobby e tira os efeitos dele do caminho
		local hidden: { Instance } = {}
		for _, child in Lighting:GetChildren() do
			if isLookEffect(child) and child.Name ~= FX_NAME then
				table.insert(hidden, child)
				child.Parent = nil
			end
		end
		saved = {
			clockTime = Lighting.ClockTime,
			brightness = Lighting.Brightness,
			ambient = Lighting.Ambient,
			outdoorAmbient = Lighting.OutdoorAmbient,
			fogEnd = Lighting.FogEnd,
			fogColor = Lighting.FogColor,
			hidden = hidden,
		}
	end
	local fx = effects or createEffects()
	effects = fx

	local look = theme.lighting
	local function set(instance: Instance, goals: { [string]: any })
		if instant then
			for key, value in goals do
				(instance :: any)[key] = value
			end
		else
			TweenService:Create(instance, BLEND, goals):Play()
		end
	end

	-- ClockTime muda na hora (interpolar faria o sol dar a volta no céu)
	Lighting.ClockTime = look.clockTime
	set(Lighting, {
		Brightness = look.brightness,
		Ambient = look.ambient,
		OutdoorAmbient = look.outdoorAmbient,
		FogEnd = look.fogEnd,
		FogColor = look.fogColor,
	})
	set(fx.atmosphere, {
		Density = look.atmosphere.density,
		Offset = look.atmosphere.offset,
		Color = look.atmosphere.color,
		Decay = look.atmosphere.decay,
		Glare = look.atmosphere.glare,
		Haze = look.atmosphere.haze,
	})
	set(fx.bloom, {
		Intensity = look.bloom.intensity,
		Size = look.bloom.size,
		Threshold = look.bloom.threshold,
	})
	set(fx.grading, {
		TintColor = look.grading.tint,
		Saturation = look.grading.saturation,
		Contrast = look.grading.contrast,
		Brightness = look.grading.brightness,
	})
end

function ChapterAmbience.restore()
	local fx = effects
	if fx then
		fx.atmosphere:Destroy()
		fx.bloom:Destroy()
		fx.grading:Destroy()
		effects = nil
	end

	local snapshot = saved
	if not snapshot then
		return
	end
	Lighting.ClockTime = snapshot.clockTime
	Lighting.Brightness = snapshot.brightness
	Lighting.Ambient = snapshot.ambient
	Lighting.OutdoorAmbient = snapshot.outdoorAmbient
	Lighting.FogEnd = snapshot.fogEnd
	Lighting.FogColor = snapshot.fogColor
	for _, child in snapshot.hidden do
		child.Parent = Lighting
	end
	saved = nil
end

return ChapterAmbience
