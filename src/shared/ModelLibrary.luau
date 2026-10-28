--!strict
-- Modelos prontos (Config/Models) guardados em ReplicatedStorage.Assets.Props.
-- Prepara um clone só visual e encaixa na caixa pedida: escala uniforme (cabe na caixa),
-- centrado em X/Z e apoiado no fundo da caixa. Sem o modelo, quem chama usa a receita de reserva.
-- A caixa é medida em pé (eixo Y do mundo), virada para onde a PrimaryPart olha (só o giro horizontal), mais a
-- correção rot de Config/Models: muitos modelos da loja têm a PrimaryPart inclinada e ficariam deitados.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Models = require(script.Parent.Config.Models)
local GameConfig = require(script.Parent.Config.GameConfig)

local MAX_PARTS = GameConfig.Scenery.MaxModelParts
local partCounts: { [string]: number } = {}

export type Fitted = {
	model: Model,
	baseScale: number,
	baseSize: Vector3, -- tamanho da caixa do modelo na escala original
	pivotFromBottom: CFrame, -- pivô em relação ao centro da base, na escala original
	lastSize: Vector3?,
}

local ModelLibrary = {}

-- Modelo original na pasta de assets, ou nil se ainda não foi importado
function ModelLibrary.source(name: string): Model?
	if Models[name] == nil then
		return nil
	end
	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local props = assets and assets:FindFirstChild("Props")
	local found = props and props:FindFirstChild(name)
	if not (found and found:IsA("Model")) then
		return nil
	end
	-- Modelo pesado demais trava o celular (e a troca de escala dele estourava o tempo do script): usa a receita
	local count = partCounts[name]
	if not count then
		count = 0
		for _, descendant in found:GetDescendants() do
			if descendant:IsA("BasePart") then
				count += 1
			end
		end
		partCounts[name] = count
		if count > MAX_PARTS then
			warn(`[ModelLibrary] {name} tem {count} peças (limite {MAX_PARTS}); usando a receita de peças`)
		end
	end
	return if count <= MAX_PARTS then found else nil
end

-- Giro horizontal para onde o modelo olha (PrimaryPart, senão o pivô); identidade se ele olha para cima ou para baixo
function ModelLibrary.heading(model: Model): CFrame
	local primary = model.PrimaryPart
	local reference = if primary then primary.CFrame else model:GetPivot()
	local look = reference.LookVector
	local flat = Vector3.new(look.X, 0, look.Z)
	if flat.Magnitude < 0.3 then
		return CFrame.identity
	end
	return CFrame.lookAt(Vector3.zero, flat.Unit)
end

-- Põe o pivô do modelo em pé (sem PrimaryPart), olhando para a frente dele, com a correção rot em graus
function ModelLibrary.stand(model: Model, rot: Vector3?)
	local heading = ModelLibrary.heading(model)
	local fix = rot or Vector3.zero
	model.PrimaryPart = nil
	model.WorldPivot = CFrame.new(model:GetPivot().Position)
		* heading
		* CFrame.Angles(math.rad(fix.X), math.rad(fix.Y), math.rad(fix.Z))
end

-- Solda todas as peças numa raiz ancorada no pivô: mover o modelo passa a ser mover uma peça só,
-- bem mais barato no celular do que reposicionar cada peça ancorada
function ModelLibrary.weldToRoot(model: Model): BasePart
	local root = Instance.new("Part")
	root.Name = "MoveRoot"
	root.Size = Vector3.new(0.2, 0.2, 0.2)
	root.Transparency = 1
	root.Anchored = true
	root.CanCollide = false
	root.CanQuery = false
	root.CanTouch = false
	root.CFrame = model:GetPivot()
	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = root
			weld.Part1 = descendant
			weld.Parent = root
			descendant.Anchored = false
			descendant.Massless = true
		end
	end
	root.Parent = model
	model.PrimaryPart = root
	return root
end

-- Nome da receita de peças para usar quando o modelo não existe
function ModelLibrary.fallback(name: string): string
	local def = Models[name]
	return if def then def.fallback else name
end

-- collide = true para o lobby (o jogador esbarra); na pista tudo é só visual
function ModelLibrary.prepare(source: Model, parent: Instance?, collide: boolean?): Fitted
	local clone = source:Clone()
	for _, descendant in clone:GetDescendants() do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = collide == true
			descendant.CanQuery = collide == true
			descendant.CanTouch = false
			descendant.CastShadow = collide == true
		elseif descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
			descendant:Destroy()
		end
	end
	local def = Models[source.Name]
	ModelLibrary.stand(clone, def and def.rot)
	local box, size = clone:GetBoundingBox()
	local bottom = box * CFrame.new(0, -size.Y / 2, 0)
	if not collide then
		ModelLibrary.weldToRoot(clone) -- na pista o modelo é movido o tempo todo pelo pool
	end
	clone.Parent = parent
	return {
		model = clone,
		baseScale = clone:GetScale(),
		baseSize = size,
		pivotFromBottom = bottom:ToObjectSpace(clone:GetPivot()),
	}
end

-- Encaixa na caixa (boxCFrame = centro da caixa); só reescala quando o tamanho muda
function ModelLibrary.fit(fitted: Fitted, boxCFrame: CFrame, boxSize: Vector3)
	local base = fitted.baseSize
	local factor = math.min(boxSize.X / base.X, boxSize.Y / base.Y, boxSize.Z / base.Z)
	if fitted.lastSize ~= boxSize then
		fitted.model:ScaleTo(fitted.baseScale * factor)
		fitted.lastSize = boxSize
	end
	local offset = fitted.pivotFromBottom
	local scaled = CFrame.new(offset.Position * factor) * offset.Rotation
	fitted.model:PivotTo(boxCFrame * CFrame.new(0, -boxSize.Y / 2, 0) * scaled)
end

return ModelLibrary
