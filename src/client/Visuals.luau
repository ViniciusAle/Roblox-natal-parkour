--!strict
-- Fábricas de peças básicas. Visual PROVISÓRIO ("feio mas jogável"): a direção de arte está em aberto.
-- Quando houver modelos, troque as fábricas sem mexer na lógica da pista.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)

local Visuals = {}

local function basePart(): Part
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Material = Enum.Material.SmoothPlastic
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

function Visuals.block(): BasePart
	return basePart()
end

function Visuals.flat(): BasePart
	local part = basePart()
	part.CastShadow = false
	return part
end

function Visuals.coin(): BasePart
	local part = basePart()
	part.Shape = Enum.PartType.Cylinder
	part.Size = GameConfig.Visuals.CoinSize
	part.Color = Color3.fromRGB(255, 205, 50)
	part.Material = Enum.Material.Neon
	part.CastShadow = false
	return part
end

function Visuals.powerUp(): BasePart
	local part = basePart()
	part.Shape = Enum.PartType.Ball
	local size = GameConfig.Obstacles.PowerUp.size
	part.Size = Vector3.new(size, size, size)
	part.Material = Enum.Material.Neon
	part.CastShadow = false
	return part
end

-- Peça solta de um modelo (corredor, vilão)
function Visuals.piece(parent: Instance, name: string, size: Vector3, color: Color3, shape: Enum.PartType?): Part
	local part = basePart()
	part.Name = name
	part.Size = size
	part.Color = color
	if shape then
		part.Shape = shape
	end
	part.Parent = parent
	return part
end

return Visuals
