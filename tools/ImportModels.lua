-- Importa os modelos prontos do cenário (src/shared/Config/Models.luau) para ReplicatedStorage.Assets.Props
-- e os dos personagens (campo model em src/shared/Config/Heroes.luau) para ReplicatedStorage.Assets.Characters.
-- Como usar:
--   1. No Studio, com o Rojo conectado e SEM estar em Play, abra View → Command Bar.
--   2. Cole este arquivo inteiro na Command Bar e aperte Enter.
--   3. Confira no Output a lista "ok"/"falhou" e salve o lugar (File → Save to File ou Publish).
-- Rodar de novo só baixa o que falta ou o que mudou de id (o modelo antigo é trocado sozinho).
-- No fim lista os modelos com muitas peças: são eles que pesam no celular.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Clone: a Command Bar guarda o resultado do require; o clone sempre lê a lista atual do Rojo
local Models = require(ReplicatedStorage.Shared.Config.Models:Clone())
local Heroes = require(ReplicatedStorage.Shared.Config.Heroes:Clone())

local HEAVY_PARTS = 150 -- acima disso o modelo aparece no aviso de peso (acima de Scenery.MaxModelParts nem é usado)

local function folder(parent, name)
	local existing = parent:FindFirstChild(name)
	if existing then
		return existing
	end
	local created = Instance.new("Folder")
	created.Name = name
	created.Parent = parent
	return created
end

local function countParts(model)
	local count = 0
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			count += 1
		end
	end
	return count
end

local assets = folder(ReplicatedStorage, "Assets")
local imported, failed, kept = 0, 0, 0

-- Lista única: { pasta de destino, nome, id }
local wanted = {}
for name, def in Models do
	table.insert(wanted, { folder(assets, "Props"), name, def.id })
end
for id, hero in Heroes.ById do
	if hero.model then
		table.insert(wanted, { folder(assets, "Characters"), id, hero.model.id })
	end
end

for _, entry in wanted do
	local target, name, assetId = entry[1], entry[2], entry[3]
	local existing = target:FindFirstChild(name)
	-- Modelo antigo sem marca de id: só é trocado se for de personagem (o de cenário veio desta mesma lista)
	local existingId = existing and existing:GetAttribute("AssetId")
	local stale = existing ~= nil
		and existingId ~= assetId
		and (existingId ~= nil or target.Name == "Characters")
	if existing and not stale then
		kept += 1
	else
		local ok, objects = pcall(function()
			return game:GetObjects("rbxassetid://" .. assetId)
		end)
		if ok and objects and #objects > 0 then
			local model
			if #objects == 1 and objects[1]:IsA("Model") then
				model = objects[1]
			else
				model = Instance.new("Model")
				for _, object in objects do
					object.Parent = model
				end
			end
			-- Cenário e personagens são só visuais: nada de scripts
			for _, descendant in model:GetDescendants() do
				if descendant:IsA("LuaSourceContainer") then
					descendant:Destroy()
				end
			end
			if existing then
				existing:Destroy()
			end
			model.Name = name
			model:SetAttribute("AssetId", assetId)
			model.Parent = target
			imported += 1
			print(`[ImportModels] ok: {target.Name}.{name} ({assetId})`)
		else
			failed += 1
			warn(`[ImportModels] falhou: {target.Name}.{name} ({assetId}): {objects}`)
		end
	end
end

-- Aviso de peso: quantidade de peças de cada modelo
for _, entry in wanted do
	local model = entry[1]:FindFirstChild(entry[2])
	if model then
		local parts = countParts(model)
		if parts > HEAVY_PARTS then
			warn(`[ImportModels] pesado: {entry[1].Name}.{entry[2]} tem {parts} peças`)
		end
	end
end

print(`[ImportModels] fim: {imported} importados, {kept} mantidos, {failed} falharam. Salve o lugar agora.`)
