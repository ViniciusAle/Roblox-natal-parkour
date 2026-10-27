--!strict
-- Monta a pista à frente do jogador a partir do gerador por seed, reaproveitando peças (pooling).
-- Cada chunk recebe o tema do seu capítulo: piso, faixas, bordas, chão lateral, cenário e obstáculos.
-- Também responde às perguntas de jogo: onde há chão e quais objetos estão perto.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.Config.GameConfig)
local Abilities = require(Shared.Config.Abilities)
local Themes = require(Shared.Config.Themes)
local ChunkGeometry = require(Shared.ChunkGeometry)
local TrackGenerator = require(Shared.TrackGenerator)
local Types = require(Shared.Types)

local Pool = require(script.Parent.Pool)
local PropPool = require(script.Parent.PropPool)
local TrackSpace = require(script.Parent.TrackSpace)
local Visuals = require(script.Parent.Visuals)

local TrackConfig = GameConfig.Track
local Obstacles = GameConfig.Obstacles
local Scenery = GameConfig.Scenery
local CHUNK = TrackConfig.ChunkLength
local TRACK_WIDTH = TrackConfig.LaneWidth * 3
local EDGE = TRACK_WIDTH / 2 + TrackConfig.RailWidth
local SMOOTH = Enum.Material.SmoothPlastic

export type Obstacle = {
	kind: Types.ObjectKind,
	lane: number,
	x: number,
	z0: number,
	z1: number,
	bottom: number,
	top: number,
	disabled: boolean,
}

export type Coin = {
	part: BasePart,
	position: Vector3, -- coordenadas da pista
	collected: boolean,
	attracted: boolean,
}

export type Pickup = {
	kind: "PowerUp" | "Trampoline",
	powerUpId: string?,
	lane: number,
	x: number,
	z0: number,
	z1: number,
	part: BasePart,
	used: boolean,
}

export type BuiltChunk = {
	index: number,
	slot: Types.ChunkSlot,
	parts: { { pool: Pool.Pool, part: BasePart } },
	props: { PropPool.PropInstance },
	obstacles: { Obstacle },
	coins: { Coin },
	pickups: { Pickup },
}

type Pools = {
	solid: Pool.Pool,
	flat: Pool.Pool,
	coin: Pool.Pool,
	powerUp: Pool.Pool,
}

type TrackData = {
	generator: TrackGenerator.TrackGenerator,
	folder: Folder,
	pools: Pools,
	props: PropPool.PropPool,
	built: { [number]: BuiltChunk },
	nearby: { BuiltChunk },
}

local Track = {}
Track.__index = Track

export type Track = typeof(setmetatable({} :: TrackData, Track))

local function pickWeighted(rng: Random, entries: { Themes.PropEntry }): Themes.PropEntry
	local total = 0
	for _, entry in entries do
		total += entry.weight
	end
	local roll = rng:NextNumber() * total
	for _, entry in entries do
		if roll < entry.weight then
			return entry
		end
		roll -= entry.weight
	end
	return entries[#entries]
end

function Track.new(generator: TrackGenerator.TrackGenerator, parent: Instance): Track
	local folder = Instance.new("Folder")
	folder.Name = "Track"
	folder.Parent = parent

	local self: TrackData = {
		generator = generator,
		folder = folder,
		pools = {
			solid = Pool.new(folder, Visuals.block),
			flat = Pool.new(folder, Visuals.flat),
			coin = Pool.new(folder, Visuals.coin),
			powerUp = Pool.new(folder, Visuals.powerUp),
		},
		props = PropPool.new(folder),
		built = {},
		nearby = {},
	}
	return setmetatable(self, Track)
end

-- Altura do chão na distância indicada; nil = vão
function Track.groundAt(self: Track, distance: number): number?
	if distance < 0 then
		return 0
	end
	local index = math.floor(distance / CHUNK)
	local dz = distance - index * CHUNK
	for _, gap in ChunkGeometry.gapsOf(self.generator:getSlot(index).chunk) do
		if dz >= gap.z0 and dz < gap.z1 then
			return nil
		end
	end
	return 0
end

function Track._place(
	self: Track,
	built: BuiltChunk,
	pool: Pool.Pool,
	size: Vector3,
	center: Vector3,
	color: Color3,
	material: Enum.Material?
): BasePart
	local part = pool:acquire()
	part.Size = size
	part.Color = color
	part.Material = material or SMOOTH
	part.CFrame = TrackSpace.cframe(center.X, center.Y, center.Z)
	table.insert(built.parts, { pool = pool, part = part })
	return part
end

function Track._prop(self: Track, built: BuiltChunk, recipeName: string, center: Vector3, size: Vector3)
	local prop = self.props:acquire(recipeName)
	self.props:place(prop, TrackSpace.cframe(center.X, center.Y, center.Z), size)
	table.insert(built.props, prop)
end

-- Piso de um trecho sem vão: placa, linhas das pistas e faixas decorativas
function Track._floor(self: Track, built: BuiltChunk, from: number, to: number, theme: Themes.Theme)
	local length = to - from
	if length <= 0 then
		return
	end
	local thickness = TrackConfig.FloorThickness
	local mid = from + length / 2
	self:_place(
		built,
		self.pools.solid,
		Vector3.new(TRACK_WIDTH, thickness, length),
		Vector3.new(0, -thickness / 2, mid),
		theme.floor.color,
		theme.floor.material
	)

	for _, side in { -1, 1 } do
		self:_place(
			built,
			self.pools.flat,
			Vector3.new(Scenery.LaneLineWidth, 0.06, length),
			Vector3.new(side * TrackConfig.LaneWidth / 2, 0.03, mid),
			theme.laneLine.color,
			theme.laneLine.material
		)
	end

	local every = theme.floor.stripeEvery
	local stripe = theme.floor.stripe
	if every and stripe then
		local z = math.ceil(from / every) * every
		while z < to do
			self:_place(
				built,
				self.pools.flat,
				Vector3.new(TRACK_WIDTH, 0.05, Scenery.StripeWidth),
				Vector3.new(0, 0.025, z),
				stripe
			)
			z += every
		end
	end
end

function Track._scenery(self: Track, built: BuiltChunk, start: number, theme: Themes.Theme)
	-- Bordas da pista
	local railX = TRACK_WIDTH / 2 + TrackConfig.RailWidth / 2
	local trimHeight = Scenery.RailTrimHeight
	for _, side in { -1, 1 } do
		self:_place(
			built,
			self.pools.flat,
			Vector3.new(TrackConfig.RailWidth, TrackConfig.RailHeight, CHUNK),
			Vector3.new(side * railX, TrackConfig.RailHeight / 2, start + CHUNK / 2),
			theme.rail.color
		)
		self:_place(
			built,
			self.pools.flat,
			Vector3.new(TrackConfig.RailWidth + 0.2, trimHeight, CHUNK),
			Vector3.new(side * railX, TrackConfig.RailHeight + trimHeight / 2, start + CHUNK / 2),
			theme.rail.trim,
			theme.rail.trimMaterial
		)

		-- Chão dos lados
		local width = Scenery.SideGroundWidth
		self:_place(
			built,
			self.pools.flat,
			Vector3.new(width, 1, CHUNK),
			Vector3.new(side * (EDGE + width / 2), -Scenery.SideGroundDrop - 0.5, start + CHUNK / 2),
			theme.ground.color,
			theme.ground.material
		)
	end

	-- Props sorteados pela seed: mesma pista, mesmo cenário para todos na corrida
	local rng = Random.new(self.generator.seed + built.index * Scenery.SeedSalt + 1)
	local slots = theme.propsPerSide
	local slotLength = CHUNK / slots
	for _, side in { -1, 1 } do
		for s = 1, slots do
			local entry = pickWeighted(rng, theme.props)
			local size = entry.size
			local z = start + (s - 1 + rng:NextNumber(0.15, 0.85)) * slotLength
			local x = side * (EDGE + rng:NextNumber(entry.offset.Min, entry.offset.Max) + size.X / 2)
			local y = -Scenery.SideGroundDrop + (entry.elevation or 0) + size.Y / 2
			self:_prop(built, entry.recipe, Vector3.new(x, y, z), size)
		end
	end

	-- Um elemento de fundo grande por chunk, alternando os lados
	if #theme.backdrop > 0 then
		local entry = pickWeighted(rng, theme.backdrop)
		local side = if built.index % 2 == 0 then -1 else 1
		local size = entry.size
		local x = side * (EDGE + rng:NextNumber(entry.offset.Min, entry.offset.Max) + size.X / 2)
		self:_prop(built, entry.recipe, Vector3.new(x, -Scenery.SideGroundDrop + size.Y / 2, start + CHUNK / 2), size)
	end
end

function Track._obstacle(self: Track, built: BuiltChunk, kind: Types.ObjectKind, lane: number, z0: number, z1: number, theme: Themes.Theme)
	local x = TrackSpace.laneX(lane)
	local width = Obstacles.HalfWidth * 2
	local bottom, top

	if kind == "Low" then
		bottom, top = Obstacles.Low.bottom, Obstacles.Low.top
		self:_prop(built, theme.obstacles.Low, Vector3.new(x, top / 2, (z0 + z1) / 2), Vector3.new(width, top, z1 - z0))
	elseif kind == "High" then
		-- A caixa visual vai até o chão para mostrar os postes; a colisão é só a viga
		bottom, top = Obstacles.High.bottom, Obstacles.High.top
		self:_prop(built, theme.obstacles.High, Vector3.new(x, top / 2, (z0 + z1) / 2), Vector3.new(width, top, z1 - z0))
	else
		bottom, top = Obstacles.Block.bottom, Obstacles.Block.top
		local length = z1 - z0
		local tiles = math.max(1, math.floor(length / Scenery.BlockTileLength + 0.5))
		local tileLength = length / tiles
		for t = 0, tiles - 1 do
			local center = z0 + (t + 0.5) * tileLength
			self:_prop(built, theme.obstacles.Block, Vector3.new(x, top / 2, center), Vector3.new(width, top, tileLength))
		end
	end

	table.insert(built.obstacles, {
		kind = kind,
		lane = lane,
		x = x,
		z0 = z0,
		z1 = z1,
		bottom = bottom,
		top = top,
		disabled = false,
	})
end

function Track._build(self: Track, index: number): BuiltChunk
	local slot = self.generator:getSlot(index)
	local theme = Themes[slot.chapterId]
	local start = index * CHUNK
	local built: BuiltChunk = {
		index = index,
		slot = slot,
		parts = {},
		props = {},
		obstacles = {},
		coins = {},
		pickups = {},
	}

	-- Piso, interrompido nos vãos
	local cursor = 0
	for _, gap in ChunkGeometry.gapsOf(slot.chunk) do
		self:_floor(built, start + cursor, start + gap.z0, theme)
		cursor = gap.z1
	end
	self:_floor(built, start + cursor, start + CHUNK, theme)
	self:_scenery(built, start, theme)

	for _, object in slot.chunk.objects do
		local kind = object.kind
		local z0, z1 = ChunkGeometry.extent(object)
		z0 += start
		z1 += start
		local lane = object.lane or 2
		local x = TrackSpace.laneX(lane)

		if kind == "Low" or kind == "High" or kind == "Block" then
			self:_obstacle(built, kind, lane, z0, z1, theme)
		elseif kind == "Coins" then
			local count = object.count or 1
			local spacing = object.spacing or 0
			local arc = object.arcHeight or 0
			for k = 0, count - 1 do
				local t = if count > 1 then k / (count - 1) else 0.5
				local position = Vector3.new(
					x,
					GameConfig.Coins.Height + arc * math.sin(math.pi * t),
					start + object.z + k * spacing
				)
				local part = self.pools.coin:acquire()
				table.insert(built.parts, { pool = self.pools.coin, part = part })
				table.insert(built.coins, { part = part, position = position, collected = false, attracted = false })
			end
		elseif kind == "PowerUp" then
			local powerUpId = object.powerUp :: string
			local def = Abilities.PowerUps[powerUpId]
			local part = self:_place(
				built,
				self.pools.powerUp,
				Vector3.one * Obstacles.PowerUp.size,
				Vector3.new(x, Obstacles.PowerUp.height, (z0 + z1) / 2),
				def.color,
				Enum.Material.Neon
			)
			table.insert(built.pickups, {
				kind = "PowerUp",
				powerUpId = powerUpId,
				lane = lane,
				x = x,
				z0 = z0,
				z1 = z1,
				part = part,
				used = false,
			})
		elseif kind == "Trampoline" then
			local top = Obstacles.Trampoline.top
			local part = self:_place(
				built,
				self.pools.flat,
				Vector3.new(Obstacles.HalfWidth * 2, top, z1 - z0),
				Vector3.new(x, top / 2, (z0 + z1) / 2),
				theme.trampoline,
				Enum.Material.Neon
			)
			table.insert(built.pickups, {
				kind = "Trampoline",
				lane = lane,
				x = x,
				z0 = z0,
				z1 = z1,
				part = part,
				used = false,
			})
		end
	end

	return built
end

function Track._release(self: Track, built: BuiltChunk)
	for _, entry in built.parts do
		entry.pool:release(entry.part)
	end
	for _, prop in built.props do
		self.props:release(prop)
	end
	table.clear(built.parts)
	table.clear(built.props)
end

-- Mantém os chunks perto do ponto indicado montados e devolve os outros ao pool
function Track.update(self: Track, distance: number)
	local current = math.floor(distance / CHUNK)
	local first = math.max(0, current - TrackConfig.ChunksBehind)
	local last = current + TrackConfig.ChunksAhead

	for index, built in self.built do
		if index < first or index > last then
			self:_release(built)
			self.built[index] = nil
		end
	end
	for index = first, last do
		if not self.built[index] then
			self.built[index] = self:_build(index)
		end
	end
end

-- Chunk atual e o seguinte (para colisão, moedas e ímã)
function Track.chunksAround(self: Track, distance: number): { BuiltChunk }
	local nearby = self.nearby
	table.clear(nearby)
	local current = math.floor(distance / CHUNK)
	for index = current, current + 1 do
		local built = self.built[index]
		if built then
			table.insert(nearby, built)
		end
	end
	return nearby
end

function Track.hide(_self: Track, part: BasePart)
	part.CFrame = TrackSpace.Hidden
end

-- Moedas girando e power-ups flutuando
function Track.render(self: Track, time: number)
	local spin = CFrame.Angles(0, time * GameConfig.Coins.SpinSpeed, 0)
	local bob = math.sin(time * 3) * GameConfig.Visuals.PowerUpBob
	for _, built in self.built do
		for _, coin in built.coins do
			if not coin.collected then
				local p = coin.position
				coin.part.CFrame = TrackSpace.cframe(p.X, p.Y, p.Z) * spin
			end
		end
		for _, pickup in built.pickups do
			if pickup.kind == "PowerUp" and not pickup.used then
				pickup.part.CFrame =
					TrackSpace.cframe(pickup.x, Obstacles.PowerUp.height + bob, (pickup.z0 + pickup.z1) / 2)
			end
		end
	end
end

function Track.destroy(self: Track)
	table.clear(self.built)
	self.folder:Destroy()
end

return Track
