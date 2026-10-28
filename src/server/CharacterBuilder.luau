--!strict
-- Monta o corpo R15 de cada personagem com itens do catálogo (Heroes.avatar) e guarda em
-- ReplicatedStorage.Assets.Characters, de onde os clientes clonam. Um Model colocado à mão
-- com o mesmo nome tem prioridade e não é substituído.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Heroes = require(ReplicatedStorage.Shared.Config.Heroes)

local function folder(parent: Instance, name: string): Folder
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("Folder") then
		return existing
	end
	local created = Instance.new("Folder")
	created.Name = name
	created.Parent = parent
	return created
end

local function describe(avatar: Heroes.HeroAvatar): HumanoidDescription
	local description = Instance.new("HumanoidDescription")
	description.HairAccessory = tostring(avatar.hair)
	description.Shirt = avatar.shirt
	description.Pants = avatar.pants
	for _, part in { "HeadColor", "TorsoColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor" } do
		(description :: any)[part] = avatar.skin
	end
	description.WidthScale = avatar.width or 1
	description.DepthScale = avatar.width or 1
	description.HeightScale = avatar.height or 1
	return description
end

local CharacterBuilder = {}

function CharacterBuilder.build()
	local characters = folder(folder(ReplicatedStorage, "Assets"), "Characters")
	for _, heroId in Heroes.Order do
		local hero = Heroes.ById[heroId]
		local avatar = hero.avatar
		if avatar and not characters:FindFirstChild(heroId) then
			local ok, result = pcall(function()
				return Players:CreateHumanoidModelFromDescription(describe(avatar), Enum.HumanoidRigType.R15)
			end)
			if ok and result then
				local model = result :: Model
				model.Name = heroId
				-- Os clientes animam e movem por conta própria; scripts de controle não servem aqui
				for _, descendant in model:GetDescendants() do
					if descendant:IsA("Script") or descendant:IsA("LocalScript") then
						descendant:Destroy()
					end
				end
				model.Parent = characters
			else
				warn(`[CharacterBuilder] não deu para montar {heroId}: {result}`)
			end
		end
	end
end

return CharacterBuilder
