--!strict
-- Monta "props" a partir de receitas de peças simples (Config/Props).
-- Posições e tamanhos da receita são frações de uma caixa; a mesma receita serve em qualquer tamanho
-- (um obstáculo de 2 studs ou uma casa do lobby de 14 studs) e qualquer orientação da caixa.

export type Shape = "Block" | "Ball" | "Cylinder" | "Wedge" | "CornerWedge"

export type PartSpec = {
	shape: Shape?,
	pos: Vector3, -- centro, em fração da caixa (-0.5 a 0.5)
	size: Vector3, -- tamanho no mundo, em fração da caixa
	axis: ("Y" | "Z")?, -- cilindro: eixo vertical (Y) ou apontando para a pista (Z); padrão X
	yaw: number?, -- giro em graus em torno de Y (múltiplos de 90)
	rot: Vector3?, -- giro livre em graus (X, Y, Z), sem trocar o tamanho: cabelo espetado, telhado em prisma
	color: Color3,
	material: Enum.Material?,
	transparency: number?,
	swing: number?, -- personagens: perna que balança ao correr (1 ou -1, fase oposta)
}

export type Recipe = {
	parts: { PartSpec },
	light: { color: Color3, range: number, brightness: number, at: Vector3 }?,
}

local PropAssembler = {}

local function newPart(spec: PartSpec): BasePart
	local shape = spec.shape or "Block"
	local part: BasePart
	if shape == "Wedge" then
		part = Instance.new("WedgePart")
	elseif shape == "CornerWedge" then
		part = Instance.new("CornerWedgePart")
	else
		local basic = Instance.new("Part")
		if shape == "Ball" then
			basic.Shape = Enum.PartType.Ball
		elseif shape == "Cylinder" then
			basic.Shape = Enum.PartType.Cylinder
		end
		part = basic
	end
	part.Anchored = true
	part.CanQuery = false
	part.CanTouch = false
	part.CastShadow = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.Color = spec.color
	part.Material = spec.material or Enum.Material.SmoothPlastic
	part.Transparency = spec.transparency or 0
	return part
end

-- Cria o modelo (sem posicionar). collide = true para props em que o jogador pisa ou esbarra (lobby).
function PropAssembler.create(recipe: Recipe, parent: Instance?, collide: boolean?): (Model, { BasePart })
	local model = Instance.new("Model")
	local parts: { BasePart } = {}
	for i, spec in recipe.parts do
		local part = newPart(spec)
		part.Name = `P{i}`
		part.CanCollide = collide == true
		part.Parent = model
		parts[i] = part
	end
	if recipe.light then
		local holder = parts[1]
		local light = Instance.new("PointLight")
		light.Color = recipe.light.color
		light.Range = recipe.light.range
		light.Brightness = recipe.light.brightness
		light.Shadows = false
		light.Parent = holder
	end
	model.Parent = parent
	return model, parts
end

-- Posiciona as peças dentro da caixa (boxCFrame = centro e orientação da caixa)
function PropAssembler.place(parts: { BasePart }, recipe: Recipe, boxCFrame: CFrame, boxSize: Vector3)
	for i, spec in recipe.parts do
		local part = parts[i]
		local world = spec.size * boxSize
		local size = world
		local rotation = CFrame.identity
		if spec.axis == "Y" then
			size = Vector3.new(world.Y, world.X, world.Z)
			rotation = CFrame.Angles(0, 0, math.pi / 2)
		elseif spec.axis == "Z" then
			size = Vector3.new(world.Z, world.Y, world.X)
			rotation = CFrame.Angles(0, math.pi / 2, 0)
		end
		local yaw = spec.yaw
		if yaw and yaw ~= 0 then
			if spec.axis == nil and math.abs(yaw) % 180 == 90 then
				size = Vector3.new(size.Z, size.Y, size.X)
			end
			rotation = CFrame.Angles(0, math.rad(yaw), 0) * rotation
		end
		local rot = spec.rot
		if rot then
			rotation = CFrame.Angles(math.rad(rot.X), math.rad(rot.Y), math.rad(rot.Z)) * rotation
		end
		part.Size = Vector3.new(math.max(size.X, 0.05), math.max(size.Y, 0.05), math.max(size.Z, 0.05))
		part.CFrame = boxCFrame * CFrame.new(spec.pos * boxSize) * rotation
	end
end

-- Atalho: cria e posiciona de uma vez (cenário fixo, como o lobby)
function PropAssembler.build(
	recipe: Recipe,
	parent: Instance,
	boxCFrame: CFrame,
	boxSize: Vector3,
	collide: boolean?
): Model
	local model, parts = PropAssembler.create(recipe, nil, collide)
	PropAssembler.place(parts, recipe, boxCFrame, boxSize)
	model.Parent = parent
	return model
end

return PropAssembler
