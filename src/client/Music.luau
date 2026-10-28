--!strict
-- Música de fundo: uma faixa por vez, em loop, com troca suave (fade) entre a vila e as fases.

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundIds = require(ReplicatedStorage.Shared.Config.Sounds)

local FADE = TweenInfo.new(SoundIds.MusicFadeSeconds, Enum.EasingStyle.Sine)

local current: Sound? = nil
local currentKey: string? = nil

local Music = {}

-- key = "Lobby" ou id da fase (Sounds.Music)
function Music.play(key: string)
	if key == currentKey then
		return
	end
	currentKey = key

	local previous = current
	if previous then
		local fadeOut = TweenService:Create(previous, FADE, { Volume = 0 })
		fadeOut.Completed:Once(function()
			previous:Destroy()
		end)
		fadeOut:Play()
	end

	local id = SoundIds.Music[key]
	if not id or id == "" then
		current = nil
		return
	end
	local sound = Instance.new("Sound")
	sound.Name = `Music_{key}`
	sound.SoundId = id
	sound.Looped = true
	sound.Volume = 0
	sound.Parent = SoundService
	sound:Play()
	TweenService:Create(sound, FADE, { Volume = SoundIds.MusicVolume }):Play()
	current = sound
end

return Music
