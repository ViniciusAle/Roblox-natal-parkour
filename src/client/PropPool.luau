--!strict
-- Reaproveitamento de props (obstáculos e cenário): modelo pronto da Creator Store quando existe
-- (Config/Models + ModelLibrary), senão a receita de peças (Config/Props).
-- Um pool só para o jogo todo (PropPool.shared), numa pasta que sobrevive às corridas: clonar modelos da loja
-- é caro, então cada um é clonado uma vez, aos poucos (prewarm), e reaproveitado em todas as corridas.
-- Esconder o que saiu de uso também é feito aos poucos, a cada frame, dentro de um orçamento de tempo.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Shared = ReplicatedStorage.Shared
local Props = require(Shared.Config.Props)
local PropAssembler = require(Shared.PropAssembler)
local ModelLibrary = require(Shared.ModelLibrary)

local TrackSpace = require(script.Parent.TrackSpace)

local BACKGROUND_BUDGET = 0.0015 -- segundos por frame para pré-carregar e esconder

export type PropInstance = {
	recipeName: string, -- nome pedido (receita ou modelo)
	recipe: PropAssembler.Recipe?,
	fitted: ModelLibrary.Fitted?,
	model: Model,
	parts: { BasePart },
	inUse: boolean,
	hidden: boolean,
}

type PoolData = {
	parent: Instance,
	free: { [string]: { PropInstance } },
	total: { [string]: number },
	toHide: { PropInstance },
	toWarm: { string },
	warmSize: { [string]: Vector3 }, -- tamanho em que cada modelo é usado (já sai do pré-carregamento na escala certa)
	warmPaused: boolean, -- pausa o pré-carregamento durante a corrida (clonar no meio dela dá soluço)
}

local PropPool = {}
PropPool.__index = PropPool

export type PropPool = typeof(setmetatable({} :: PoolData, PropPool))

local sharedPool: PropPool? = nil

function PropPool.new(parent: Instance): PropPool
	local self: PoolData = { parent = parent, free = {}, total = {}, toHide = {}, toWarm = {}, warmSize = {}, warmPaused = false }
	return setmetatable(self, PropPool)
end

-- Pool do jogo todo, com o trabalho de fundo ligado
function PropPool.shared(): PropPool
	if sharedPool then
		return sharedPool
	end
	local folder = Instance.new("Folder")
	folder.Name = "PropCache"
	folder.Parent = Workspace
	local pool = PropPool.new(folder)
	sharedPool = pool
	RunService.Heartbeat:Connect(function()
		pool:_background(BACKGROUND_BUDGET)
	end)
	return pool
end

-- Cópias criadas desde a última leitura (medidor de travadas)
PropPool.clones = 0

function PropPool._create(self: PropPool, name: string): PropInstance
	self.total[name] = (self.total[name] or 0) + 1
	PropPool.clones += 1
	local source = ModelLibrary.source(name)
	local prop: PropInstance
	if source then
		local fitted = ModelLibrary.prepare(source, nil, false)
		fitted.model.Name = name
		prop = { recipeName = name, recipe = nil, fitted = fitted, model = fitted.model, parts = {}, inUse = true, hidden = false }
	else
		local recipeName = ModelLibrary.fallback(name)
		local recipe = Props[recipeName]
		assert(recipe, `[PropPool] receita desconhecida: {recipeName}`)
		local model, parts = PropAssembler.create(recipe, nil, false)
		model.Name = recipeName
		prop = { recipeName = name, recipe = recipe, fitted = nil, model = model, parts = parts, inUse = true, hidden = false }
	end
	self:_hideNow(prop)
	prop.model.Parent = self.parent
	return prop
end

function PropPool.acquire(self: PropPool, name: string): PropInstance
	local list = self.free[name]
	local prop = (list and table.remove(list)) or self:_create(name)
	prop.inUse = true
	prop.hidden = false
	return prop
end

function PropPool.place(_self: PropPool, prop: PropInstance, boxCFrame: CFrame, boxSize: Vector3)
	if prop.fitted then
		ModelLibrary.fit(prop.fitted, boxCFrame, boxSize)
	elseif prop.recipe then
		PropAssembler.place(prop.parts, prop.recipe, boxCFrame, boxSize)
	end
end

function PropPool._hideNow(_self: PropPool, prop: PropInstance)
	prop.hidden = true
	if prop.fitted then
		prop.model:PivotTo(TrackSpace.Hidden)
	else
		for _, part in prop.parts do
			part.CFrame = TrackSpace.Hidden
		end
	end
end

-- Esconde sem devolver ao pool (obstáculo destruído); o chunk devolve depois, como sempre
function PropPool.hide(self: PropPool, prop: PropInstance)
	self:_hideNow(prop)
end

-- Devolve ao pool; some da tela no trabalho de fundo (ou é reaproveitado antes disso)
function PropPool.release(self: PropPool, prop: PropInstance)
	prop.inUse = false
	local list = self.free[prop.recipeName]
	if not list then
		list = {}
		self.free[prop.recipeName] = list
	end
	table.insert(list, prop)
	if not prop.hidden then
		table.insert(self.toHide, prop)
	end
end

-- Garante que existam pelo menos counts[nome] cópias de cada prop, criadas aos poucos no fundo.
-- sizes[nome] = tamanho em que o modelo é usado: a troca de escala (cara) já acontece aqui, não na corrida
function PropPool.prewarm(self: PropPool, counts: { [string]: number }, sizes: { [string]: Vector3 })
	for name, size in sizes do
		self.warmSize[name] = size
	end
	for name, count in counts do
		for _ = (self.total[name] or 0) + 1, count do
			table.insert(self.toWarm, name)
		end
	end
end

function PropPool._background(self: PropPool, budget: number)
	local started = os.clock()
	local toHide = self.toHide
	while #toHide > 0 and os.clock() - started < budget do
		local prop = table.remove(toHide) :: PropInstance
		if not prop.inUse and not prop.hidden then
			self:_hideNow(prop)
		end
	end
	local toWarm = self.toWarm
	while not self.warmPaused and #toWarm > 0 and os.clock() - started < budget do
		local name = table.remove(toWarm, 1) :: string
		local prop = self:_create(name)
		prop.inUse = false
		local size = self.warmSize[name]
		if prop.fitted and size then
			ModelLibrary.fit(prop.fitted, TrackSpace.Hidden, size)
		end
		local list = self.free[name]
		if not list then
			list = {}
			self.free[name] = list
		end
		table.insert(list, prop)
	end
end

return PropPool
