--!strict
-- Reaproveitamento de peças: nada é criado ou destruído a cada quadro.

local TrackSpace = require(script.Parent.TrackSpace)

local Pool = {}
Pool.__index = Pool

type PoolData = {
	parent: Instance,
	factory: () -> BasePart,
	free: { BasePart },
}

export type Pool = typeof(setmetatable({} :: PoolData, Pool))

function Pool.new(parent: Instance, factory: () -> BasePart): Pool
	local self: PoolData = { parent = parent, factory = factory, free = {} }
	return setmetatable(self, Pool)
end

function Pool.acquire(self: Pool): BasePart
	local part = table.remove(self.free)
	if part then
		return part
	end
	local created = self.factory()
	created.CFrame = TrackSpace.Hidden
	created.Parent = self.parent
	return created
end

function Pool.release(self: Pool, part: BasePart)
	part.CFrame = TrackSpace.Hidden
	table.insert(self.free, part)
end

return Pool
