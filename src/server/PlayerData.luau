--!strict
-- Perfis dos jogadores, só EM MEMÓRIA nesta fase (somem ao sair).
-- TODO fase de dados salvos: trocar por ProfileStore (sessão travada) + OrderedDataStore do ranking.
-- Não ligar DataStore sem confirmação do usuário (GDD seção 18).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Heroes = require(Shared.Config.Heroes)
local Chapters = require(Shared.Config.Chapters)
local Abilities = require(Shared.Config.Abilities)
local Strings = require(Shared.Config.Strings)

export type Profile = {
	coins: number,
	bestMeters: number,
	selectedHero: string,
	ownedHeroes: { [string]: boolean },
	ownedChapters: { [string]: boolean },
	upgrades: { [string]: number }, -- nível de cada melhoria permanente
}

type Leaderstats = { coins: IntValue, best: IntValue }

local profiles: { [Player]: Profile } = {}
local leaderstats: { [Player]: Leaderstats } = {}

local function newProfile(): Profile
	local unlockAll = GameConfig.Dev.UnlockAllInStudio and RunService:IsStudio()
	local profile: Profile = {
		coins = 0,
		bestMeters = 0,
		selectedHero = Heroes.Order[1],
		ownedHeroes = {},
		ownedChapters = {},
		upgrades = {},
	}
	for id, hero in Heroes.ById do
		profile.ownedHeroes[id] = hero.freeByDefault or unlockAll or GameConfig.Dev.UnlockAllHeroes
	end
	for id, chapter in Chapters.ById do
		profile.ownedChapters[id] = chapter.freeByDefault or unlockAll
	end
	for id, upgrade in Abilities.Upgrades do
		local studioLevel: number? = (GameConfig.Dev.StudioUpgrades :: any)[id]
		local level = if unlockAll and studioLevel then studioLevel else 0
		profile.upgrades[id] = math.clamp(level, 0, upgrade.maxLevel)
	end
	return profile
end

local function createLeaderstats(player: Player, profile: Profile)
	local folder = Instance.new("Folder")
	folder.Name = "leaderstats"

	local coins = Instance.new("IntValue")
	coins.Name = Strings.Leaderstats.Coins
	coins.Value = profile.coins
	coins.Parent = folder

	local best = Instance.new("IntValue")
	best.Name = Strings.Leaderstats.Best
	best.Value = profile.bestMeters
	best.Parent = folder

	folder.Parent = player
	leaderstats[player] = { coins = coins, best = best }
end

local function onPlayerAdded(player: Player)
	local profile = newProfile()
	profiles[player] = profile
	createLeaderstats(player, profile)
end

local function onPlayerRemoving(player: Player)
	profiles[player] = nil
	leaderstats[player] = nil
end

local PlayerData = {}

function PlayerData.get(player: Player): Profile?
	return profiles[player]
end

-- Herói usado na corrida multiplayer (só se o jogador tiver)
function PlayerData.selectHero(player: Player, heroId: string): boolean
	local profile = profiles[player]
	if not profile or not profile.ownedHeroes[heroId] then
		return false
	end
	profile.selectedHero = heroId
	return true
end

function PlayerData.addCoins(player: Player, amount: number): number
	local profile = profiles[player]
	if not profile then
		return 0
	end
	profile.coins += amount
	local stats = leaderstats[player]
	if stats then
		stats.coins.Value = profile.coins
	end
	return profile.coins
end

-- Retorna true se for recorde novo
function PlayerData.submitDistance(player: Player, meters: number): boolean
	local profile = profiles[player]
	if not profile or meters <= profile.bestMeters then
		return false
	end
	profile.bestMeters = meters
	local stats = leaderstats[player]
	if stats then
		stats.best.Value = meters
	end
	return true
end

function PlayerData.start()
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)
	for _, player in Players:GetPlayers() do
		task.spawn(onPlayerAdded, player)
	end
end

return PlayerData
