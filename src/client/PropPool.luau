--!strict
-- Reaproveitamento de props montados por receita (obstáculos e cenário).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local Props = require(Shared.Config.Props)
local PropAssembler = require(Shared.PropAssembler)

local TrackSpace = require(script.Parent.TrackSpace)

export type PropInstance = {
	recipeName: string,
	recipe: PropAssembler.Recipe,
	model: Model,
	parts: { BasePart },
}

type PoolData = {
	parent: Instance,
	free: { [string]: { PropInstance } },
}

local PropPool = {}
PropPool.__index = PropPool

export type PropPool = typeof(setmetatable({} :: PoolData, PropPool))

function PropPool.new(parent: Instance): PropPool
	local self: PoolData = { parent = parent, free = {} }
	return setmetatable(self, PropPool)
end

function PropPool.acquire(self: PropPool, recipeName: string): PropInstance
	local list = self.free[recipeName]
	local reused = list and table.remove(list)
	if reused then
		return reused
	end
	local recipe = Props[recipeName]
	assert(recipe, `[PropPool] receita desconhecida: {recipeName}`)
	local model, parts = PropAssembler.create(recipe, self.parent, false)
	model.Name = recipeName
	return { recipeName = recipeName, recipe = recipe, model = model, parts = parts }
end

function PropPool.place(_self: PropPool, prop: PropInstance, boxCFrame: CFrame, boxSize: Vector3)
	PropAssembler.place(prop.parts, prop.recipe, boxCFrame, boxSize)
end

function PropPool.release(self: PropPool, prop: PropInstance)
	for _, part in prop.parts do
		part.CFrame = TrackSpace.Hidden
	end
	local list = self.free[prop.recipeName]
	if not list then
		list = {}
		self.free[prop.recipeName] = list
	end
	table.insert(list, prop)
end

return PropPool
