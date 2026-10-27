--!strict
-- Sons de resposta imediata. Moedas seguidas sobem de tom; errar a sequência reinicia.
-- Sons sem id (Config/Sounds) ficam mudos até a origem do áudio ser decidida.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local SoundIds = require(Shared.Config.Sounds)

local Config = GameConfig.Juice

type JuiceData = {
	folder: Folder,
	sounds: { [string]: Sound },
	coinPitch: number,
	lastCoinAt: number,
}

local Juice = {}
Juice.__index = Juice

export type Juice = typeof(setmetatable({} :: JuiceData, Juice))

function Juice.new(parent: Instance): Juice
	local folder = Instance.new("Folder")
	folder.Name = "Sounds"
	folder.Parent = parent

	local sounds: { [string]: Sound } = {}
	for name, id in SoundIds do
		if id ~= "" then
			local sound = Instance.new("Sound")
			sound.Name = name
			sound.SoundId = id
			sound.Parent = folder
			sounds[name] = sound
		end
	end

	local self: JuiceData = { folder = folder, sounds = sounds, coinPitch = 1, lastCoinAt = -math.huge }
	return setmetatable(self, Juice)
end

function Juice.play(self: Juice, name: string, pitch: number?)
	local sound = self.sounds[name]
	if not sound then
		return
	end
	sound.PlaybackSpeed = pitch or 1
	sound.TimePosition = 0
	sound:Play()
end

function Juice.coin(self: Juice, time: number)
	if time - self.lastCoinAt > Config.CoinComboReset then
		self.coinPitch = 1
	else
		self.coinPitch = math.min(Config.CoinPitchMax, self.coinPitch + Config.CoinPitchStep)
	end
	self.lastCoinAt = time
	self:play("Coin", self.coinPitch)
end

function Juice.destroy(self: Juice)
	self.folder:Destroy()
end

return Juice
